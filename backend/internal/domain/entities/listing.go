package entities

import "time"

type ListingType string

const (
	ListingTypeSale ListingType = "sale"
	ListingTypeRent ListingType = "rent"
)

type Listing struct {
	ID        string      `json:"id"`
	Type      ListingType `json:"type"`
	ValueBRL  float64     `json:"value_brl"`
	ImageURL  *string     `json:"image_url,omitempty"`
	Address   Address     `json:"address"`
	CreatedAt time.Time   `json:"created_at"`
}

type ListingFilter struct {
	Type *ListingType
}
