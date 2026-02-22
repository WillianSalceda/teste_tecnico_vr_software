package exchange_rate_test

import (
	"context"
	"testing"
	"time"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

func TestListExchangeRates_ReturnsPaginatedResult(t *testing.T) {
	listings := []*entities.ExchangeRate{
		{ID: "id-1", Rate: 0.19},
		{ID: "id-2", Rate: 0.20},
	}
	mock := &mockListExchangeRateRepo{
		rates: listings,
		total: 2,
	}
	uc := usecase.NewListExchangeRatesUseCase(mock)

	result, err := uc.Execute(context.Background(), usecase.ListExchangeRatesInput{
		Page:  1,
		Limit: 10,
	})
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if result == nil {
		t.Fatal("expected result, got nil")
	}
	if len(result.ExchangeRates) != 2 {
		t.Errorf("expected 2 rates, got %d", len(result.ExchangeRates))
	}
	if result.Total != 2 {
		t.Errorf("expected total 2, got %d", result.Total)
	}
}

func TestListExchangeRates_ValidatesPageAndLimit(t *testing.T) {
	mock := &mockListExchangeRateRepo{rates: nil, total: 0}
	uc := usecase.NewListExchangeRatesUseCase(mock)

	_, err := uc.Execute(context.Background(), usecase.ListExchangeRatesInput{
		Page:  0,
		Limit: 5,
	})
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if mock.page != 1 {
		t.Errorf("expected page 1 (default), got %d", mock.page)
	}
}

type mockListExchangeRateRepo struct {
	rates []*entities.ExchangeRate
	total int
	page  int
	limit int
}

func (m *mockListExchangeRateRepo) Create(ctx context.Context, r *entities.ExchangeRate) error {
	return nil
}

func (m *mockListExchangeRateRepo) GetCurrent(ctx context.Context, at time.Time) (*entities.ExchangeRate, error) {
	return nil, nil
}

func (m *mockListExchangeRateRepo) List(ctx context.Context, page, limit int) ([]*entities.ExchangeRate, int, error) {
	m.page = page
	m.limit = limit
	return m.rates, m.total, nil
}

var _ repositories.ExchangeRateRepository = (*mockListExchangeRateRepo)(nil)
