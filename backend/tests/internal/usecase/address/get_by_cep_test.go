package address_test

import (
	"context"
	"errors"
	"testing"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
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

func TestGetAddressByCEP_Success(t *testing.T) {
	expected := &entities.Address{
		CEP:          "01310-100",
		Street:       "Avenida Paulista",
		Neighborhood: "Bela Vista",
		City:         "São Paulo",
		State:        "SP",
	}
	uc := usecase.NewGetAddressByCEPUseCase(&mockViaCEP{addr: expected})

	addr, err := uc.Execute(context.Background(), "01310100")
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if addr.Street != expected.Street {
		t.Errorf("expected street %s, got %s", expected.Street, addr.Street)
	}
}

func TestGetAddressByCEP_ServiceError_ReturnsError(t *testing.T) {
	uc := usecase.NewGetAddressByCEPUseCase(&mockViaCEP{err: errors.New("CEP not found")})

	_, err := uc.Execute(context.Background(), "00000000")
	if err == nil {
		t.Fatal("expected error when service fails")
	}
}
