package viacep_test

import (
	"context"
	"errors"
	"net/http"
	"net/http/httptest"
	"testing"
	"time"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/infrastructure/viacep"
)

func TestClient_GetAddressByCEP_Success(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(200)
		w.Write([]byte(`{"cep":"01310-100","logradouro":"Avenida Paulista","bairro":"Bela Vista","localidade":"São Paulo","uf":"SP"}`))
	}))
	defer srv.Close()

	client := viacep.NewClient(srv.URL, 0)
	addr, err := client.GetAddressByCEP(context.Background(), "01310100")
	if err != nil {
		t.Fatalf("expected no error: %v", err)
	}
	if addr.Street != "Avenida Paulista" {
		t.Errorf("expected Avenida Paulista, got %s", addr.Street)
	}
	if addr.City != "São Paulo" {
		t.Errorf("expected São Paulo, got %s", addr.City)
	}
}

func TestClient_GetAddressByCEP_InvalidCEP(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(200)
		w.Write([]byte(`{"erro":true}`))
	}))
	defer srv.Close()

	client := viacep.NewClient(srv.URL, 0)
	_, err := client.GetAddressByCEP(context.Background(), "00000000")
	if !errors.Is(err, viacep.ErrCEPInvalid) {
		t.Errorf("expected ErrCEPInvalid, got %v", err)
	}
}

func TestClient_GetAddressByCEP_HTTPNon200_ReturnsErrCEPInvalid(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(http.StatusNotFound)
	}))
	defer srv.Close()

	client := viacep.NewClient(srv.URL, 0)
	_, err := client.GetAddressByCEP(context.Background(), "01310100")
	if !errors.Is(err, viacep.ErrCEPInvalid) {
		t.Errorf("expected ErrCEPInvalid when status != 200, got %v", err)
	}
}

func TestClient_GetAddressByCEP_InvalidJSON_ReturnsErrViaCEPUnavailable(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		w.WriteHeader(200)
		w.Write([]byte(`not valid json`))
	}))
	defer srv.Close()

	client := viacep.NewClient(srv.URL, 0)
	_, err := client.GetAddressByCEP(context.Background(), "01310100")
	if !errors.Is(err, viacep.ErrViaCEPUnavailable) {
		t.Errorf("expected ErrViaCEPUnavailable on invalid JSON, got %v", err)
	}
}

func TestClient_GetAddressByCEP_Timeout_ReturnsErrViaCEPUnavailable(t *testing.T) {
	srv := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		time.Sleep(100 * time.Millisecond)
		w.WriteHeader(200)
	}))
	defer srv.Close()

	client := viacep.NewClient(srv.URL, 1*time.Millisecond)
	_, err := client.GetAddressByCEP(context.Background(), "01310100")
	if !errors.Is(err, viacep.ErrViaCEPUnavailable) {
		t.Errorf("expected ErrViaCEPUnavailable on timeout, got %v", err)
	}
}
