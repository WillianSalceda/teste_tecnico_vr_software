package handler

import (
	"errors"
	"net/http"
	"strconv"

	"github.com/gin-gonic/gin"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type ExchangeRateHandler struct {
	create *usecase.CreateExchangeRateUseCase
	list   *usecase.ListExchangeRatesUseCase
}

func NewExchangeRateHandler(create *usecase.CreateExchangeRateUseCase, list *usecase.ListExchangeRatesUseCase) *ExchangeRateHandler {
	return &ExchangeRateHandler{create: create, list: list}
}

type createExchangeRateRequest struct {
	Rate float64 `json:"rate" binding:"required,gt=0"`
}

func (h *ExchangeRateHandler) Create(c *gin.Context) {
	var req createExchangeRateRequest
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}

	er, err := h.create.Execute(c.Request.Context(), usecase.CreateExchangeRateInput{Rate: req.Rate})
	if err != nil {
		if errors.Is(err, usecase.ErrInvalidRate) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}

		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
		return
	}

	c.JSON(http.StatusCreated, er)
}

func (h *ExchangeRateHandler) List(c *gin.Context) {
	page, _ := strconv.Atoi(c.DefaultQuery("page", "1"))
	limit, _ := strconv.Atoi(c.DefaultQuery("limit", "10"))
	result, err := h.list.Execute(c.Request.Context(), usecase.ListExchangeRatesInput{Page: page, Limit: limit})

	if err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
		return
	}

	c.JSON(http.StatusOK, gin.H{"exchange_rates": result.ExchangeRates, "total": result.Total})
}
