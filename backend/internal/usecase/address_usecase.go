package usecase

import (
	"context"
	"errors"
	"regexp"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
)

var ErrInvalidCEP = errors.New("Formato do CEP inválido: deve conter 8 digitos")

var cepRegex = regexp.MustCompile(`^\d{8}$`)

type GetAddressByCEPUseCase struct {
	viaCEP domain.ViaCEPService
}

func NewGetAddressByCEPUseCase(viaCEP domain.ViaCEPService) *GetAddressByCEPUseCase {
	return &GetAddressByCEPUseCase{viaCEP: viaCEP}
}

func (uc *GetAddressByCEPUseCase) Execute(ctx context.Context, cep string) (*entities.Address, error) {
	cep = regexp.MustCompile(`\D`).ReplaceAllString(cep, "")
	if !cepRegex.MatchString(cep) {
		return nil, ErrInvalidCEP
	}
	return uc.viaCEP.GetAddressByCEP(ctx, cep)
}
