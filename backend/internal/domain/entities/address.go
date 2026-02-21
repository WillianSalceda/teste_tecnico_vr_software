package entities

type Address struct {
	CEP          string  `json:"cep"`
	Street       string  `json:"street"`
	Number       *string `json:"number,omitempty"`
	Complement   *string `json:"complement,omitempty"`
	Neighborhood string  `json:"neighborhood"`
	City         string  `json:"city"`
	State        string  `json:"state"`
}
