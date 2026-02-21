package migrations

import (
	"context"
	"database/sql"
	_ "embed"
)

//go:embed 001_init.up.sql
var initSQL string

// Migrate runs database migrations from SQL files
func Migrate(ctx context.Context, db *sql.DB) error {
	_, err := db.ExecContext(ctx, initSQL)
	return err
}
