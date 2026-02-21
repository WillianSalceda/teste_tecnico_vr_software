package handler

import (
	"errors"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/infrastructure/viacep"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/usecase"
)

type AddressHandler struct {
	getByCEP *usecase.GetAddressByCEPUseCase
}

func NewAddressHandler(getByCEP *usecase.GetAddressByCEPUseCase) *AddressHandler {
	return &AddressHandler{getByCEP: getByCEP}
}

func (h *AddressHandler) GetByCEP(c *gin.Context) {
	cep := c.Param("cep")
	if cep == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "CEP is required"})
		return
	}
	addr, err := h.getByCEP.Execute(c.Request.Context(), cep)
	if err != nil {
		if errors.Is(err, usecase.ErrInvalidCEP) {
			c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
			return
		}
		if errors.Is(err, viacep.ErrCEPInvalid) {
			c.JSON(http.StatusNotFound, gin.H{"error": "CEP not found"})
			return
		}
		if errors.Is(err, viacep.ErrViaCEPUnavailable) {
			c.JSON(http.StatusServiceUnavailable, gin.H{"error": "Address lookup service unavailable"})
			return
		}
		c.JSON(http.StatusInternalServerError, gin.H{"error": "internal server error"})
		return
	}
	c.JSON(http.StatusOK, addr)
}
