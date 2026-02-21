package listing_test

import (
	"context"
	"testing"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type mockListingRepo struct {
	createErr error
}

func (m *mockListingRepo) Create(ctx context.Context, listing *entities.Listing) error {
	return m.createErr
}

func (m *mockListingRepo) GetByID(ctx context.Context, id string) (*entities.Listing, error) {
	return nil, nil
}

func (m *mockListingRepo) List(ctx context.Context, filter entities.ListingFilter, page, limit int) ([]*entities.Listing, int, error) {
	return nil, 0, nil
}

func (m *mockListingRepo) Update(ctx context.Context, listing *entities.Listing) error { return nil }
func (m *mockListingRepo) Delete(ctx context.Context, id string) error                 { return nil }

var _ repositories.ListingRepository = (*mockListingRepo)(nil)

func TestCreateListing_ValidInput_Success(t *testing.T) {
	uc := usecase.NewCreateListingUseCase(&mockListingRepo{})
	input := usecase.CreateListingInput{
		Type:     string(entities.ListingTypeSale),
		ValueBRL: 500000.00,
		Address: entities.Address{
			CEP:          "01310-100",
			Street:       "Avenida Paulista",
			Neighborhood: "Bela Vista",
			City:         "São Paulo",
			State:        "SP",
		},
	}

	lst, err := uc.Execute(context.Background(), input)
	if err != nil {
		t.Fatalf("expected no error, got %v", err)
	}
	if lst == nil {
		t.Fatal("expected listing, got nil")
	}
	if lst.ID == "" {
		t.Error("expected non-empty ID")
	}
	if lst.Type != entities.ListingTypeSale {
		t.Errorf("expected type sale, got %s", lst.Type)
	}
	if lst.ValueBRL != 500000.00 {
		t.Errorf("expected ValueBRL 500000, got %f", lst.ValueBRL)
	}
}

func TestCreateListing_InvalidType_ReturnsError(t *testing.T) {
	uc := usecase.NewCreateListingUseCase(&mockListingRepo{})
	input := usecase.CreateListingInput{
		Type:     "invalid",
		ValueBRL: 100.00,
		Address: entities.Address{
			CEP:          "01310-100",
			Street:       "Avenida Paulista",
			Neighborhood: "Bela Vista",
			City:         "São Paulo",
			State:        "SP",
		},
	}

	_, err := uc.Execute(context.Background(), input)
	if err == nil {
		t.Fatal("expected error for invalid type")
	}
}
