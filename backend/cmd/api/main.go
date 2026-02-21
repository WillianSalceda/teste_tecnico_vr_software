package main

import (
	"context"
	"database/sql"
	"errors"
	"log"
	"net/http"
	"os"
	"os/signal"
	"path/filepath"
	"syscall"
	"time"

	_ "github.com/lib/pq"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/handler"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/infrastructure/postgres"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/infrastructure/viacep"
	httplib "github.com/williansalceda/teste_tecnico_vr_software/backend/internal/interface/http"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/migrations"
)

func main() {
	dbURL := os.Getenv("DATABASE_URL")
	if dbURL == "" {
		dbURL = "postgres://postgres:postgres@localhost:5432/realestate?sslmode=disable"
	}

	db, err := sql.Open("postgres", dsn)
	if err != nil {
		log.Fatalf("failed to open db: %v", err)
	}
	defer db.Close()

	if err := db.Ping(); err != nil {
		log.Fatalf("failed to ping db: %v", err)
	}

	if err := migrations.Migrate(context.Background(), db); err != nil {
		log.Fatalf("failed to migrate: %v", err)
	}
	if err := os.MkdirAll(filepath.Join(".", "uploads"), 0755); err != nil {
		log.Printf("warning: could not create uploads dir: %v", err)
	}

	listingRepo := postgres.NewListingRepository(db)
	exchangeRateRepo := postgres.NewExchangeRateRepository(db)
	viaCEPClient := viacep.NewClient("", 10*time.Second)

	createListingUC := usecase.NewCreateListingUseCase(listingRepo)
	listListingsUC := usecase.NewListListingsUseCase(listingRepo)
	getAddressByCEPUC := usecase.NewGetAddressByCEPUseCase(viaCEPClient)
	createExchangeRateUC := usecase.NewCreateExchangeRateUseCase(exchangeRateRepo)
	getCurrentExchangeRateUC := usecase.NewGetCurrentExchangeRateUseCase(exchangeRateRepo)
	listExchangeRatesUC := usecase.NewListExchangeRatesUseCase(exchangeRateRepo)

	listingH := handler.NewListingHandler(createListingUC, listListingsUC, getCurrentExchangeRateUC)
	exchangeRateH := handler.NewExchangeRateHandler(createExchangeRateUC, listExchangeRatesUC)
	addressH := handler.NewAddressHandler(getAddressByCEPUC)
	baseURL := os.Getenv("BASE_URL")
	if baseURL == "" {
		baseURL = "http://localhost:8080"
	}
	uploadH := handler.NewUploadHandler(baseURL)
	router := httplib.SetupRouter(addressH, listingH, exchangeRateH, uploadH)

	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}
	srv := &http.Server{Addr: ":" + port, Handler: router}

	go func() {
		log.Printf("server listening on :%s", port)
		if err := srv.ListenAndServe(); err != nil && !errors.Is(err, http.ErrServerClosed) {
			log.Fatalf("listen: %v", err)
		}
	}()

	quit := make(chan os.Signal, 1)
	signal.Notify(quit, syscall.SIGINT, syscall.SIGTERM)
	<-quit

	ctx, cancel := context.WithTimeout(context.Background(), 5*time.Second)
	defer cancel()
	if err := srv.Shutdown(ctx); err != nil {
		log.Printf("server shutdown: %v", err)
	}
}
