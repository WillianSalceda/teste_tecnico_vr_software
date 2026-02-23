package handler

import (
	"context"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/gin-gonic/gin"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/infrastructure/viacep"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type mockViaCEP struct {
	addr *entities.Address
	err  error
}

func (m *mockViaCEP) GetAddressByCEP(ctx context.Context, cep string) (*entities.Address, error) {
	return m.addr, m.err
}

var _ domain.ViaCEPService = (*mockViaCEP)(nil)

func TestAddressHandler_GetByCEP_Success(t *testing.T) {
	gin.SetMode(gin.TestMode)
	expected := &entities.Address{
		CEP:          "01310-100",
		Street:       "Avenida Paulista",
		Neighborhood: "Bela Vista",
		City:         "São Paulo",
		State:        "SP",
	}
	h := NewAddressHandler(usecase.NewGetAddressByCEPUseCase(&mockViaCEP{addr: expected}))

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodGet, "/api/v1/address/cep/01310100", nil)
	c.Params = gin.Params{{Key: "cep", Value: "01310100"}}

	h.GetByCEP(c)

	if w.Code != http.StatusOK {
		t.Errorf("expected status 200, got %d: %s", w.Code, w.Body.String())
	}
}

func TestAddressHandler_GetByCEP_EmptyCEP_Returns400(t *testing.T) {
	gin.SetMode(gin.TestMode)
	h := NewAddressHandler(usecase.NewGetAddressByCEPUseCase(&mockViaCEP{}))

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodGet, "/api/v1/address/cep/", nil)
	c.Params = gin.Params{{Key: "cep", Value: ""}}

	h.GetByCEP(c)

	if w.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d", w.Code)
	}
}

func TestAddressHandler_GetByCEP_InvalidCEP_Returns400(t *testing.T) {
	gin.SetMode(gin.TestMode)
	mock := &mockViaCEP{err: usecase.ErrInvalidCEP}
	uc := usecase.NewGetAddressByCEPUseCase(mock)
	h := NewAddressHandler(uc)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodGet, "/api/v1/address/cep/123", nil)
	c.Params = gin.Params{{Key: "cep", Value: "123"}}

	h.GetByCEP(c)

	if w.Code != http.StatusBadRequest {
		t.Errorf("expected status 400, got %d: %s", w.Code, w.Body.String())
	}
}

func TestAddressHandler_GetByCEP_CEPNotFound_Returns404(t *testing.T) {
	gin.SetMode(gin.TestMode)
	mock := &mockViaCEP{err: viacep.ErrCEPInvalid}
	uc := usecase.NewGetAddressByCEPUseCase(mock)
	h := NewAddressHandler(uc)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodGet, "/api/v1/address/cep/00000000", nil)
	c.Params = gin.Params{{Key: "cep", Value: "00000000"}}

	h.GetByCEP(c)

	if w.Code != http.StatusNotFound {
		t.Errorf("expected status 404, got %d: %s", w.Code, w.Body.String())
	}
}

func TestAddressHandler_GetByCEP_ServiceUnavailable_Returns503(t *testing.T) {
	gin.SetMode(gin.TestMode)
	mock := &mockViaCEP{err: viacep.ErrViaCEPUnavailable}
	uc := usecase.NewGetAddressByCEPUseCase(mock)
	h := NewAddressHandler(uc)

	w := httptest.NewRecorder()
	c, _ := gin.CreateTestContext(w)
	c.Request = httptest.NewRequest(http.MethodGet, "/api/v1/address/cep/01310100", nil)
	c.Params = gin.Params{{Key: "cep", Value: "01310100"}}

	h.GetByCEP(c)

	if w.Code != http.StatusServiceUnavailable {
		t.Errorf("expected status 503, got %d: %s", w.Code, w.Body.String())
	}
}
