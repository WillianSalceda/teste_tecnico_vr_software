package viacep

import (
	"context"
	"encoding/json"
	"errors"
	"fmt"
	"io"
	"net/http"
	"time"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
)

var (
	ErrCEPInvalid        = errors.New("CEP não encontrado ou inválido")
	ErrViaCEPUnavailable = errors.New("serviço de consulta de CEP indisponível")
)

type viaCEPResponse struct {
	CEP         string `json:"cep"`
	Logradouro  string `json:"logradouro"`
	Complemento string `json:"complemento"`
	Bairro      string `json:"bairro"`
	Localidade  string `json:"localidade"`
	UF          string `json:"uf"`
	Erro        bool   `json:"erro"`
}

type Client struct {
	baseURL    string
	httpClient *http.Client
}

func NewClient(baseURL string, timeout time.Duration) *Client {
	if baseURL == "" {
		baseURL = "https://viacep.com.br"
	}
	return &Client{
		baseURL:    baseURL,
		httpClient: &http.Client{Timeout: timeout},
	}
}

func (c *Client) GetAddressByCEP(ctx context.Context, cep string) (*entities.Address, error) {
	url := fmt.Sprintf("%s/ws/%s/json/", c.baseURL, cep)
	req, err := http.NewRequestWithContext(ctx, http.MethodGet, url, nil)
	if err != nil {
		return nil, ErrViaCEPUnavailable
	}

	resp, err := c.httpClient.Do(req)
	if err != nil {
		return nil, ErrViaCEPUnavailable
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return nil, ErrCEPInvalid
	}

	body, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, ErrViaCEPUnavailable
	}

	var v viaCEPResponse
	if err := json.Unmarshal(body, &v); err != nil {
		return nil, ErrViaCEPUnavailable
	}

	if v.Erro || (v.Logradouro == "" && v.Localidade == "") {
		return nil, ErrCEPInvalid
	}

	addr := &entities.Address{
		CEP:          v.CEP,
		Street:       v.Logradouro,
		Neighborhood: v.Bairro,
		City:         v.Localidade,
		State:        v.UF,
	}
	if v.Complemento != "" {
		addr.Complement = &v.Complemento
	}
	return addr, nil
}

var _ domain.ViaCEPService = (*Client)(nil)
