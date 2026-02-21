package repositories

import (
	"context"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
)

type ListingRepository interface {
	Create(ctx context.Context, listing *entities.Listing) error
	GetByID(ctx context.Context, id string) (*entities.Listing, error)
	List(ctx context.Context, filter entities.ListingFilter, page, limit int) ([]*entities.Listing, int, error)
	Update(ctx context.Context, listing *entities.Listing) error
	Delete(ctx context.Context, id string) error
}
