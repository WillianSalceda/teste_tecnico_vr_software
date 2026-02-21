package entities

import "time"

type ExchangeRate struct {
	ID        string     `json:"id"`
	Rate      float64    `json:"rate"`
	ValidFrom time.Time  `json:"valid_from"`
	ValidTo   *time.Time `json:"valid_to,omitempty"`
	CreatedAt time.Time  `json:"created_at"`
}
