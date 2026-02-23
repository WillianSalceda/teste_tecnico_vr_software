package handler

import (
	"bytes"
	"context"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type mockListingRepo struct {
	createErr error
	listOut   []*entities.Listing
	listTotal int
	listErr   error
}

func (m *mockListingRepo) Create(ctx context.Context, listing *entities.Listing) error {
	return m.createErr
}

func (m *mockListingRepo) GetByID(ctx context.Context, id string) (*entities.Listing, error) {
	return nil, nil
}

func (m *mockListingRepo) List(ctx context.Context, filter entities.ListingFilter, page, limit int) ([]*entities.Listing, int, error) {
	return m.listOut, m.listTotal, m.listErr
}

func (m *mockListingRepo) Update(ctx context.Context, listing *entities.Listing) error { return nil }
func (m *mockListingRepo) Delete(ctx context.Context, id string) error                 { return nil }

var _ repositories.ListingRepository = (*mockListingRepo)(nil)

type mockRateRepo struct {
	current *entities.ExchangeRate
}

func (m *mockRateRepo) Create(ctx context.Context, er *entities.ExchangeRate) error {
	return nil
}

func (m *mockRateRepo) GetCurrent(ctx context.Context, at time.Time) (*entities.ExchangeRate, error) {
	return m.current, nil
}

func (m *mockRateRepo) List(ctx context.Context, page, limit int) ([]*entities.ExchangeRate, int, error) {
	return nil, 0, nil
}

var _ repositories.ExchangeRateRepository = (*mockRateRepo)(nil)

func TestListingHandler_Create_ValidInput_Returns201(t *testing.T) {
	gin.SetMode(gin.TestMode)
	createUC := usecase.NewCreateListingUseCase(&mockListingRepo{})
	listUC := usecase.NewListListingsUseCase(&mockListingRepo{})
	rateUC := usecase.NewGetCurrentExchangeRateUseCase(&mockRateRepo{})
	h := NewListingHandler(createUC, listUC, rateUC)

	body := map[string]interface{}{
		"type":      "sale",
		"value_brl": 500000,
		"address": map[string]interface{}{
			"cep":          "01310-100",
			"street":       "Avenida Paulista",
			"neighborhood": "Bela Vista",
			"city":         "São Paulo",
			"state":        "SP",
		},
	}
	bodyBytes, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodPost, "/api/v1/listings", bytes.NewReader(bodyBytes))
	c.Request.Header.Set("Content-Type", "application/json")

	h.Create(c)

	if w.Code != http.StatusCreated {
		t.Errorf("expected status 201, got %d: %s", w.Code, w.Body.String())
	}
}

func TestListingHandler_Create_InvalidType_Returns400(t *testing.T) {
	gin.SetMode(gin.TestMode)
	createUC := usecase.NewCreateListingUseCase(&mockListingRepo{})
	listUC := usecase.NewListListingsUseCase(&mockListingRepo{})
	rateUC := usecase.NewGetCurrentExchangeRateUseCase(&mockRateRepo{})
	h := NewListingHandler(createUC, listUC, rateUC)

	body := map[string]interface{}{
		"type":      "invalid",
		"value_brl": 100,
		"address": map[string]interface{}{
			"cep":          "01310-100",
			"street":       "Avenida Paulista",
			"neighborhood": "Bela Vista",
			"city":         "São Paulo",
			"state":        "SP",
		},
	}
	bodyBytes, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodPost, "/api/v1/listings", bytes.NewReader(bodyBytes))
	c.Request.Header.Set("Content-Type", "application/json")

	h.Create(c)

	if w.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d: %s", w.Code, w.Body.String())
	}
}

func TestListingHandler_List_Returns200(t *testing.T) {
	gin.SetMode(gin.TestMode)
	createUC := usecase.NewCreateListingUseCase(&mockListingRepo{})
	listUC := usecase.NewListListingsUseCase(&mockListingRepo{
		listOut:   []*entities.Listing{},
		listTotal: 0,
	})
	rateUC := usecase.NewGetCurrentExchangeRateUseCase(&mockRateRepo{})
	h := NewListingHandler(createUC, listUC, rateUC)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodGet, "/api/v1/listings?page=1&limit=10", nil)

	h.List(c)

	if w.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d: %s", w.Code, w.Body.String())
	}
}
