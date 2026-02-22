package postgres

import (
	"context"
	"database/sql"
	"errors"
	"fmt"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/entities"
	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/domain/repositories"
)

type listingRepository struct {
	db *sql.DB
}

func NewListingRepository(db *sql.DB) repositories.ListingRepository {
	return &listingRepository{db: db}
}

func (r *listingRepository) Create(ctx context.Context, listing *entities.Listing) error {
	query := `INSERT INTO listings (id, type, value_brl, image_url, cep, street, number, complement, neighborhood, city, state, created_at)
		VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)`
	_, err := r.db.ExecContext(ctx, query,
		listing.ID, listing.Type, listing.ValueBRL, listing.ImageURL,
		listing.Address.CEP, listing.Address.Street, listing.Address.Number, listing.Address.Complement,
		listing.Address.Neighborhood, listing.Address.City, listing.Address.State,
		listing.CreatedAt,
	)

	return err
}

func (r *listingRepository) GetByID(ctx context.Context, id string) (*entities.Listing, error) {
	query := `SELECT id, type, value_brl, image_url, cep, street, number, complement, neighborhood, city, state, created_at
		FROM listings WHERE id = $1`
	var listing entities.Listing
	var imageURL, number, complement sql.NullString
	err := r.db.QueryRowContext(ctx, query, id).Scan(
		&listing.ID, &listing.Type, &listing.ValueBRL, &imageURL,
		&listing.Address.CEP, &listing.Address.Street, &number, &complement,
		&listing.Address.Neighborhood, &listing.Address.City, &listing.Address.State,
		&listing.CreatedAt,
	)

	if errors.Is(err, sql.ErrNoRows) {
		return nil, nil
	}

	if err != nil {
		return nil, err
	}

	if imageURL.Valid {
		listing.ImageURL = &imageURL.String
	}

	if number.Valid {
		listing.Address.Number = &number.String
	}

	if complement.Valid {
		listing.Address.Complement = &complement.String
	}

	return &listing, nil
}

func (r *listingRepository) List(ctx context.Context, filter entities.ListingFilter, page int, limit int) ([]*entities.Listing, int, error) {
	offset := (page - 1) * limit

	countQuery := `SELECT COUNT(*) FROM listings WHERE 1=1`
	args := []interface{}{}
	argPos := 1
	if filter.Type != nil {
		countQuery += fmt.Sprintf(` AND type = $%d`, argPos)
		args = append(args, string(*filter.Type))
		argPos++
	}

	var total int
	if err := r.db.QueryRowContext(ctx, countQuery, args...).Scan(&total); err != nil {
		return nil, 0, err
	}

	listQuery := `SELECT id, type, value_brl, image_url, cep, street, number, complement, neighborhood, city, state, created_at
		FROM listings WHERE 1=1`
	listArgs := make([]interface{}, 0, 3)
	listArgPos := 1
	if filter.Type != nil {
		listQuery += fmt.Sprintf(` AND type = $%d`, listArgPos)
		listArgs = append(listArgs, string(*filter.Type))
		listArgPos++
	}
	listQuery += fmt.Sprintf(` ORDER BY created_at DESC LIMIT $%d OFFSET $%d`, listArgPos, listArgPos+1)
	listArgs = append(listArgs, limit, offset)

	rows, err := r.db.QueryContext(ctx, listQuery, listArgs...)
	if err != nil {
		return nil, 0, err
	}

	defer rows.Close()

	var listings []*entities.Listing
	for rows.Next() {
		var listing entities.Listing
		var imageURL, number, complement sql.NullString
		if err := rows.Scan(
			&listing.ID, &listing.Type, &listing.ValueBRL, &imageURL,
			&listing.Address.CEP, &listing.Address.Street, &number, &complement,
			&listing.Address.Neighborhood, &listing.Address.City, &listing.Address.State,
			&listing.CreatedAt,
		); err != nil {
			return nil, 0, err
		}

		if imageURL.Valid {
			listing.ImageURL = &imageURL.String
		}

		if number.Valid {
			listing.Address.Number = &number.String
		}

		if complement.Valid {
			listing.Address.Complement = &complement.String
		}

		listings = append(listings, &listing)
	}

	return listings, total, nil
}

func (r *listingRepository) Update(ctx context.Context, listing *entities.Listing) error {
	query := `UPDATE listings SET type=$2, value_brl=$3, image_url=$4, cep=$5, street=$6, number=$7, complement=$8, neighborhood=$9, city=$10, state=$11 WHERE id=$1`
	var imageURL, number, complement sql.NullString
	if listing.ImageURL != nil {
		imageURL = sql.NullString{String: *listing.ImageURL, Valid: true}
	}

	if listing.Address.Number != nil {
		number = sql.NullString{String: *listing.Address.Number, Valid: true}
	}

	if listing.Address.Complement != nil {
		complement = sql.NullString{String: *listing.Address.Complement, Valid: true}
	}

	_, err := r.db.ExecContext(ctx, query,
		listing.ID, listing.Type, listing.ValueBRL, imageURL,
		listing.Address.CEP, listing.Address.Street, number, complement,
		listing.Address.Neighborhood, listing.Address.City, listing.Address.State,
	)

	return err
}

func (r *listingRepository) Delete(ctx context.Context, id string) error {
	_, err := r.db.ExecContext(ctx, `DELETE FROM listings WHERE id = $1`, id)
	return err
}
