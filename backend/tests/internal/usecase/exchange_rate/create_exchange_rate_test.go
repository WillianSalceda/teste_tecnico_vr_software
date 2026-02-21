package exchange_rate_test

import (
	"context"
	"testing"
	"time"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type mockExchangeRateRepo struct{ err error }

func (m *mockExchangeRateRepo) Create(ctx context.Context, r *entities.ExchangeRate) error {
	return m.err
}
func (m *mockExchangeRateRepo) GetCurrent(ctx context.Context, at time.Time) (*entities.ExchangeRate, error) {
	return nil, nil
}
func (m *mockExchangeRateRepo) List(ctx context.Context, page, limit int) ([]*entities.ExchangeRate, int, error) {
	return nil, 0, nil
}

var _ repositories.ExchangeRateRepository = (*mockExchangeRateRepo)(nil)

func TestCreateExchangeRate_ValidInput_Success(t *testing.T) {
	uc := usecase.NewCreateExchangeRateUseCase(&mockExchangeRateRepo{})
	input := usecase.CreateExchangeRateInput{Rate: 0.19}

	er, err := uc.Execute(context.Background(), input)
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if er == nil {
		t.Fatal("expected exchange rate, got nil")
	}
	if er.Rate != 0.19 {
		t.Errorf("expected rate 0.19, got %f", er.Rate)
	}
}

func TestCreateExchangeRate_InvalidRate_ReturnsError(t *testing.T) {
	uc := usecase.NewCreateExchangeRateUseCase(&mockExchangeRateRepo{})
	input := usecase.CreateExchangeRateInput{Rate: -1}

	_, err := uc.Execute(context.Background(), input)
	if err == nil {
		t.Fatal("expected error for invalid rate")
	}
}
