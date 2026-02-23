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

type mockExchangeRateRepo struct {
	createErr error
	listOut   []*entities.ExchangeRate
	listTotal int
	listErr   error
}

func (m *mockExchangeRateRepo) Create(ctx context.Context, er *entities.ExchangeRate) error {
	return m.createErr
}

func (m *mockExchangeRateRepo) GetCurrent(ctx context.Context, at time.Time) (*entities.ExchangeRate, error) {
	return nil, nil
}

func (m *mockExchangeRateRepo) List(ctx context.Context, page, limit int) ([]*entities.ExchangeRate, int, error) {
	return m.listOut, m.listTotal, m.listErr
}

var _ repositories.ExchangeRateRepository = (*mockExchangeRateRepo)(nil)

func TestExchangeRateHandler_Create_ValidInput_Returns201(t *testing.T) {
	gin.SetMode(gin.TestMode)
	createUC := usecase.NewCreateExchangeRateUseCase(&mockExchangeRateRepo{})
	listUC := usecase.NewListExchangeRatesUseCase(&mockExchangeRateRepo{})
	h := NewExchangeRateHandler(createUC, listUC)

	body := map[string]interface{}{"rate": 0.19}
	bodyBytes, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodPost, "/api/v1/exchange-rates", bytes.NewReader(bodyBytes))
	c.Request.Header.Set("Content-Type", "application/json")

	h.Create(c)

	if w.Code != http.StatusCreated {
		t.Errorf("expected status 201, got %d: %s", w.Code, w.Body.String())
	}
}

func TestExchangeRateHandler_Create_InvalidRate_Returns400(t *testing.T) {
	gin.SetMode(gin.TestMode)
	createUC := usecase.NewCreateExchangeRateUseCase(&mockExchangeRateRepo{})
	listUC := usecase.NewListExchangeRatesUseCase(&mockExchangeRateRepo{})
	h := NewExchangeRateHandler(createUC, listUC)

	body := map[string]interface{}{"rate": 0}
	bodyBytes, _ := json.Marshal(body)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodPost, "/api/v1/exchange-rates", bytes.NewReader(bodyBytes))
	c.Request.Header.Set("Content-Type", "application/json")

	h.Create(c)

	if w.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d: %s", w.Code, w.Body.String())
	}
}

func TestExchangeRateHandler_List_Returns200(t *testing.T) {
	gin.SetMode(gin.TestMode)
	createUC := usecase.NewCreateExchangeRateUseCase(&mockExchangeRateRepo{})
	listUC := usecase.NewListExchangeRatesUseCase(&mockExchangeRateRepo{
		listOut:   []*entities.ExchangeRate{},
		listTotal: 0,
	})
	h := NewExchangeRateHandler(createUC, listUC)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodGet, "/api/v1/exchange-rates?page=1&limit=10", nil)

	h.List(c)

	if w.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d: %s", w.Code, w.Body.String())
	}
}
