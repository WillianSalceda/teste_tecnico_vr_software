package repositories

import (
	"context"
	"time"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
)

type ExchangeRateRepository interface {
	Create(ctx context.Context, r *entities.ExchangeRate) error
	GetCurrent(ctx context.Context, at time.Time) (*entities.ExchangeRate, error)
	List(ctx context.Context, page, limit int) ([]*entities.ExchangeRate, int, error)
}
