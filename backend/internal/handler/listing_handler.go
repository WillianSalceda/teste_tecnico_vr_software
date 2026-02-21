package handler

import (
	"errors"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type ListingHandler struct {
	createListing *usecase.CreateListingUseCase
	listListings  *usecase.ListListingsUseCase
	getRate       *usecase.GetCurrentExchangeRateUseCase
}

func NewListingHandler(create *usecase.CreateListingUseCase, list *usecase.ListListingsUseCase, getRate *usecase.GetCurrentExchangeRateUseCase) *ListingHandler {
	return &ListingHandler{createListing: create, listListings: list, getRate: getRate}
}

type createListingRequest struct {
	Type     string     `json:"type" binding:"required,oneof=sale rent"`
	ValueBRL float64    `json:"value_brl" binding:"required,gt=0"`
	ImageURL *string    `json:"image_url,omitempty"`
	Address  addressDTO `json:"address" binding:"required"`
}

type addressDTO struct {
	CEP          string  `json:"cep"`
	Street       string  `json:"street" binding:"required"`
	Number       *string `json:"number,omitempty"`
	Complement   *string `json:"complement,omitempty"`
	Neighborhood string  `json:"neighborhood" binding:"required"`
	City         string  `json:"city" binding:"required"`
	State        string  `json:"state" binding:"required,len=2"`
}

func (h *ListingHandler) Create(c *gin.Context) {
	var req createListingRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	listing, err := h.createListing.Execute(c.Request.Context(), usecase.CreateListingInput{
		Type:     req.Type,
		ValueBRL: req.ValueBRL,
		ImageURL: req.ImageURL,
		Address: entities.Address{
			CEP:          req.Address.CEP,
			Street:       req.Address.Street,
			Number:       req.Address.Number,
			Complement:   req.Address.Complement,
			Neighborhood: req.Address.Neighborhood,
			City:         req.Address.City,
			State:        req.Address.State,
		},
	})

	if err != nil {
		if errors.Is(err, usecase.ErrInvalidListingType) || errors.Is(err, usecase.ErrInvalidValue) || errors.Is(err, usecase.ErrEmptyAddress) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
		return
	}

	c.JSON(http.StatusCreated, listing)
}

func (h *ListingHandler) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "10"))
	typeFilter := c.Query("type")

	input := usecase.ListListingsInput{Page: page, Limit: limit}
	if typeFilter != "" {
		input.Type = &typeFilter
	}

	result, err := h.listListings.Execute(c.Request.Context(), input)
	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
		return
	}

	rate, _ := h.getRate.Execute(c.Request.Context())
	response := make([]gin.H, len(result.Listings))
	for i, listing := range result.Listings {
		usd := 0.0
		if rate != nil {
			usd = listing.ValueBRL * rate.Rate
		}
		response[i] = gin.H{
			"id":         listing.ID,
			"type":       listing.Type,
			"value_brl":  listing.ValueBRL,
			"value_usd":  usd,
			"image_url":  listing.ImageURL,
			"address":    listing.Address,
			"created_at": listing.CreatedAt,
		}
	}

	c.JSON(http.StatusOK, gin.H{"listings": response, "total": result.Total})
}
