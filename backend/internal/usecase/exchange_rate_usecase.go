package usecase

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
)

var ErrInvalidRate = errors.New("rate must be positive")

type CreateExchangeRateInput struct {
	Rate float64
}

type CreateExchangeRateUseCase struct {
	repo repositories.ExchangeRateRepository
}

func NewCreateExchangeRateUseCase(repo repositories.ExchangeRateRepository) *CreateExchangeRateUseCase {
	return &CreateExchangeRateUseCase{repo: repo}
}

func (uc *CreateExchangeRateUseCase) Execute(ctx context.Context, input CreateExchangeRateInput) (*entities.ExchangeRate, error) {
	if input.Rate <= 0 {
		return nil, ErrInvalidRate
	}

	now := time.Now()
	er := &entities.ExchangeRate{
		ID:        uuid.New().String(),
		Rate:      input.Rate,
		ValidFrom: now,
		CreatedAt: now,
	}

	if err := uc.repo.Create(ctx, er); err != nil {
		return nil, err
	}
	return er, nil
}

type GetCurrentExchangeRateUseCase struct {
	repo repositories.ExchangeRateRepository
}

func NewGetCurrentExchangeRateUseCase(repo repositories.ExchangeRateRepository) *GetCurrentExchangeRateUseCase {
	return &GetCurrentExchangeRateUseCase{repo: repo}
}

func (uc *GetCurrentExchangeRateUseCase) Execute(ctx context.Context) (*entities.ExchangeRate, error) {
	return uc.repo.GetCurrent(ctx, time.Now())
}

type ListExchangeRatesInput struct {
	Page  int
	Limit int
}

type ListExchangeRatesOutput struct {
	ExchangeRates []*entities.ExchangeRate
	Total         int
}

type ListExchangeRatesUseCase struct {
	repo repositories.ExchangeRateRepository
}

func NewListExchangeRatesUseCase(repo repositories.ExchangeRateRepository) *ListExchangeRatesUseCase {
	return &ListExchangeRatesUseCase{repo: repo}
}

func (uc *ListExchangeRatesUseCase) Execute(ctx context.Context, input ListExchangeRatesInput) (*ListExchangeRatesOutput, error) {
	if input.Page < 1 {
		input.Page = 1
	}
	if input.Limit < 1 || input.Limit > 50 {
		input.Limit = 10
	}
	rates, total, err := uc.repo.List(ctx, input.Page, input.Limit)
	if err != nil {
		return nil, err
	}
	return &ListExchangeRatesOutput{ExchangeRates: rates, Total: total}, nil
}
