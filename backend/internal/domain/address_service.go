package domain

import (
	"context"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
)

type ViaCEPService interface {
	GetAddressByCEP(ctx context.Context, cep string) (*entities.Address, error)
}
