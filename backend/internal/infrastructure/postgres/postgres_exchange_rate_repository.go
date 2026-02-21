package postgres

import (
	"context"
	"database/sql"
	"errors"
	"time"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
)

type exchangeRateRepository struct {
	db *sql.DB
}

func NewExchangeRateRepository(db *sql.DB) repositories.ExchangeRateRepository {
	return &exchangeRateRepository{db: db}
}

func (r *exchangeRateRepository) Create(ctx context.Context, er *entities.ExchangeRate) error {
	query := `INSERT INTO exchange_rates (id, rate, valid_from, valid_to, created_at)
		VALUES ($1, $2, $3, $4, $5)`
	_, err := r.db.ExecContext(ctx, query,
		er.ID, er.Rate, er.ValidFrom, er.ValidTo, er.CreatedAt,
	)

	return err
}

func (r *exchangeRateRepository) GetCurrent(ctx context.Context, at time.Time) (*entities.ExchangeRate, error) {
	query := `SELECT id, rate, valid_from, valid_to, created_at
		FROM exchange_rates
		WHERE valid_from <= $1 AND (valid_to IS NULL OR valid_to > $1)
		ORDER BY valid_from DESC LIMIT 1`
	var er entities.ExchangeRate
	var validTo sql.NullTime
	err := r.db.QueryRowContext(ctx, query, at).Scan(
		&er.ID, &er.Rate, &er.ValidFrom, &validTo, &er.CreatedAt,
	)

	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}

	if err != nil {
		return nil, err
	}

	if validTo.Valid {
		er.ValidTo = &validTo.Time
	}
	return &er, nil
}

func (r *exchangeRateRepository) List(ctx context.Context, page, limit int) ([]*entities.ExchangeRate, int, error) {
	offset := (page - 1) * limit

	var total int
	if err := r.db.QueryRowContext(ctx, `SELECT COUNT(*) FROM exchange_rates`).Scan(&total); err != nil {
		return nil, 0, err
	}

	query := `SELECT id, rate, valid_from, valid_to, created_at
		FROM exchange_rates ORDER BY valid_from DESC LIMIT $1 OFFSET $2`
	rows, err := r.db.QueryContext(ctx, query, limit, offset)

	if err != nil {
		return nil, 0, err
	}

	defer rows.Close()

	var rates []*entities.ExchangeRate
	for rows.Next() {
		var er entities.ExchangeRate
		var validTo sql.NullTime

		if err := rows.Scan(&er.ID, &er.Rate, &er.ValidFrom, &validTo, &er.CreatedAt); err != nil {
			return nil, 0, err
		}

		if validTo.Valid {
			er.ValidTo = &validTo.Time
		}

		rates = append(rates, &er)
	}

	return rates, total, nil
}
