package listing_test

import (
	"context"
	"testing"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type mockListListingRepo struct {
	listings []*entities.Listing
	total    int
	err      error
}

func (m *mockListListingRepo) Create(ctx context.Context, listing *entities.Listing) error {
	return nil
}
func (m *mockListListingRepo) GetByID(ctx context.Context, id string) (*entities.Listing, error) {
	return nil, nil
}
func (m *mockListListingRepo) List(ctx context.Context, filter entities.ListingFilter, page, limit int) ([]*entities.Listing, int, error) {
	return m.listings, m.total, m.err
}
func (m *mockListListingRepo) Update(ctx context.Context, listing *entities.Listing) error {
	return nil
}
func (m *mockListListingRepo) Delete(ctx context.Context, id string) error { return nil }

var _ repositories.ListingRepository = (*mockListListingRepo)(nil)

func TestListListings_Success(t *testing.T) {
	listings := []*entities.Listing{
		{ID: "1", Type: entities.ListingTypeSale, ValueBRL: 100000},
		{ID: "2", Type: entities.ListingTypeRent, ValueBRL: 2000},
	}
	uc := usecase.NewListListingsUseCase(&mockListListingRepo{listings: listings, total: 2})

	result, err := uc.Execute(context.Background(), usecase.ListListingsInput{
		Page:  1,
		Limit: 10,
	})
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if len(result.Listings) != 2 {
		t.Errorf("expected 2 listings, got %d", len(result.Listings))
	}
	if result.Total != 2 {
		t.Errorf("expected total 2, got %d", result.Total)
	}
}
