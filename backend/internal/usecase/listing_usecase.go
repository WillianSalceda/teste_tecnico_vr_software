package usecase

import (
	"context"
	"errors"
	"time"

	"github.com/google/uuid"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
)

var ErrInvalidListingType = errors.New("invalid listing type: must be sale or rent")
var ErrInvalidValue = errors.New("value must be positive")
var ErrEmptyAddress = errors.New("address must be filled")

type CreateListingInput struct {
	Type     string
	ValueBRL float64
	ImageURL *string
	Address  entities.Address
}

type CreateListingUseCase struct {
	repo repositories.ListingRepository
}

func NewCreateListingUseCase(repo repositories.ListingRepository) *CreateListingUseCase {
	return &CreateListingUseCase{repo: repo}
}

func (uc *CreateListingUseCase) Execute(ctx context.Context, input CreateListingInput) (*entities.Listing, error) {
	listingType := entities.ListingType(input.Type)
	if listingType != entities.ListingTypeSale && listingType != entities.ListingTypeRent {
		return nil, ErrInvalidListingType
	}
	if input.ValueBRL <= 0 {
		return nil, ErrInvalidValue
	}
	if err := validateAddress(input.Address); err != nil {
		return nil, err
	}

	now := time.Now()
	listing := &entities.Listing{
		ID:        uuid.New().String(),
		Type:      listingType,
		ValueBRL:  input.ValueBRL,
		ImageURL:  input.ImageURL,
		Address:   input.Address,
		CreatedAt: now,
	}

	if err := uc.repo.Create(ctx, listing); err != nil {
		return nil, err
	}
	return listing, nil
}

type ListListingsInput struct {
	Page  int
	Limit int
	Type  *string
}

type ListListingsOutput struct {
	Listings []*entities.Listing
	Total    int
}

type ListListingsUseCase struct {
	repo repositories.ListingRepository
}

func NewListListingsUseCase(repo repositories.ListingRepository) *ListListingsUseCase {
	return &ListListingsUseCase{repo: repo}
}

func (uc *ListListingsUseCase) Execute(ctx context.Context, input ListListingsInput) (*ListListingsOutput, error) {
	if input.Page < 1 {
		input.Page = 1
	}
	if input.Limit < 1 || input.Limit > 100 {
		input.Limit = 10
	}

	filter := entities.ListingFilter{}
	if input.Type != nil {
		listingType := entities.ListingType(*input.Type)
		if listingType == entities.ListingTypeSale || listingType == entities.ListingTypeRent {
			filter.Type = &listingType
		}
	}

	listings, total, err := uc.repo.List(ctx, filter, input.Page, input.Limit)
	if err != nil {
		return nil, err
	}
	return &ListListingsOutput{Listings: listings, Total: total}, nil
}

func validateAddress(a entities.Address) error {
	if a.CEP == "" && a.Street == "" && a.City == "" && a.State == "" && a.Neighborhood == "" {
		return ErrEmptyAddress
	}
	if a.Street == "" || a.Neighborhood == "" || a.City == "" || a.State == "" {
		return ErrEmptyAddress
	}
	return nil
}
