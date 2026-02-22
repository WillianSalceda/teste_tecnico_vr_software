package docs

import "github.com/swaggo/swag"

const docTemplate = `{
    "swagger": "2.0",
    "info": {
        "title": "Real Estate API",
        "description": "API para gestão de anúncios de imóveis.",
        "version": "1.0",
        "contact": {}
    },
    "host": "{{.Host}}",
    "basePath": "{{.BasePath}}",
    "schemes": {{ marshal .Schemes }},
    "securityDefinitions": {
        "BearerAuth": {
            "type": "apiKey",
            "name": "Authorization",
            "in": "header",
            "description": "JWT Bearer token. Click 'Authorize' and enter: Bearer <your_token>. Obtain the token via POST http://localhost:9090/api/auth/login (credentials: admin/admin123)."
        }
    },
    "security": [{"BearerAuth": []}],
    "paths": {
        "/health": {
            "get": {
                "tags": ["Health"],
                "summary": "Health check",
                "description": "Verifica se a API está funcionando.",
                "security": [],
                "responses": {
                    "200": {
                        "description": "API está operacional",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "status": {"type": "string", "example": "ok"}
                            }
                        }
                    }
                }
            }
        },
        "/api/v1/listings": {
            "get": {
                "tags": ["Listings"],
                "summary": "Listar anúncios",
                "description": "Retorna uma lista paginada de anúncios de imóveis.",
                "parameters": [
                    {"name": "page", "in": "query", "type": "integer", "default": 1, "description": "Página atual"},
                    {"name": "limit", "in": "query", "type": "integer", "default": 10, "description": "Itens por página"},
                    {"name": "type", "in": "query", "type": "string", "enum": ["sale", "rent"], "description": "Filtro por tipo (venda ou aluguel)"}
                ],
                "responses": {
                    "200": {
                        "description": "Lista de anúncios",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "listings": {
                                    "type": "array",
                                    "items": {"$ref": "#/definitions/ListingResponse"}
                                },
                                "total": {"type": "integer", "description": "Total de registros"}
                            }
                        }
                    },
                    "401": {"description": "Token ausente ou inválido"}
                }
            },
            "post": {
                "tags": ["Listings"],
                "summary": "Criar anúncio",
                "description": "Cria um novo anúncio de imóvel.",
                "parameters": [{
                    "name": "body",
                    "in": "body",
                    "required": true,
                    "schema": {"$ref": "#/definitions/CreateListingRequest"}
                }],
                "responses": {
                    "201": {
                        "description": "Anúncio criado",
                        "schema": {"$ref": "#/definitions/Listing"}
                    },
                    "400": {"description": "Dados inválidos"},
                    "401": {"description": "Token ausente ou inválido"}
                }
            }
        },
        "/api/v1/address/cep/{cep}": {
            "get": {
                "tags": ["Address"],
                "summary": "Consultar endereço por CEP",
                "description": "Busca dados de endereço via ViaCEP.",
                "parameters": [{
                    "name": "cep",
                    "in": "path",
                    "required": true,
                    "type": "string",
                    "description": "CEP (8 dígitos, com ou sem hífen)"
                }],
                "responses": {
                    "200": {
                        "description": "Endereço encontrado",
                        "schema": {"$ref": "#/definitions/Address"}
                    },
                    "400": {"description": "CEP inválido"},
                    "404": {"description": "CEP não encontrado"},
                    "503": {"description": "Serviço ViaCEP indisponível"},
                    "401": {"description": "Token ausente ou inválido"}
                }
            }
        },
        "/api/v1/exchange-rates": {
            "get": {
                "tags": ["Exchange Rates"],
                "summary": "Listar cotações",
                "description": "Retorna lista paginada de cotações de câmbio BRL/USD.",
                "parameters": [
                    {"name": "page", "in": "query", "type": "integer", "default": 1},
                    {"name": "limit", "in": "query", "type": "integer", "default": 10}
                ],
                "responses": {
                    "200": {
                        "description": "Lista de cotações",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "exchange_rates": {
                                    "type": "array",
                                    "items": {"$ref": "#/definitions/ExchangeRate"}
                                },
                                "total": {"type": "integer"}
                            }
                        }
                    },
                    "401": {"description": "Token ausente ou inválido"}
                }
            },
            "post": {
                "tags": ["Exchange Rates"],
                "summary": "Criar cotação",
                "description": "Cadastra uma nova cotação de câmbio.",
                "parameters": [{
                    "name": "body",
                    "in": "body",
                    "required": true,
                    "schema": {"$ref": "#/definitions/CreateExchangeRateRequest"}
                }],
                "responses": {
                    "201": {
                        "description": "Cotação criada",
                        "schema": {"$ref": "#/definitions/ExchangeRate"}
                    },
                    "400": {"description": "Taxa inválida (deve ser maior que zero)"},
                    "401": {"description": "Token ausente ou inválido"}
                }
            }
        },
        "/api/v1/upload": {
            "post": {
                "tags": ["Upload"],
                "summary": "Upload de arquivo",
                "description": "Faz upload de uma imagem e retorna a URL pública.",
                "consumes": ["multipart/form-data"],
                "parameters": [{
                    "name": "file",
                    "in": "formData",
                    "required": true,
                    "type": "file",
                    "description": "Arquivo de imagem"
                }],
                "responses": {
                    "200": {
                        "description": "URL do arquivo enviado",
                        "schema": {
                            "type": "object",
                            "properties": {
                                "url": {"type": "string", "description": "URL pública do arquivo"}
                            }
                        }
                    },
                    "400": {"description": "Arquivo não informado"},
                    "401": {"description": "Token ausente ou inválido"}
                }
            }
        }
    },
    "definitions": {
        "Address": {
            "type": "object",
            "properties": {
                "cep": {"type": "string", "example": "01310-100"},
                "street": {"type": "string"},
                "number": {"type": "string"},
                "complement": {"type": "string"},
                "neighborhood": {"type": "string"},
                "city": {"type": "string"},
                "state": {"type": "string", "maxLength": 2}
            },
            "required": ["cep", "street", "neighborhood", "city", "state"]
        },
        "CreateListingRequest": {
            "type": "object",
            "properties": {
                "type": {"type": "string", "enum": ["sale", "rent"], "description": "Tipo do anúncio"},
                "value_brl": {"type": "number", "minimum": 0, "exclusiveMinimum": true, "description": "Valor em BRL"},
                "image_url": {"type": "string", "description": "URL da imagem (opcional)"},
                "address": {"$ref": "#/definitions/Address"}
            },
            "required": ["type", "value_brl", "address"]
        },
        "Listing": {
            "type": "object",
            "properties": {
                "id": {"type": "string"},
                "type": {"type": "string", "enum": ["sale", "rent"]},
                "value_brl": {"type": "number"},
                "image_url": {"type": "string"},
                "address": {"$ref": "#/definitions/Address"},
                "created_at": {"type": "string", "format": "date-time"}
            }
        },
        "ListingResponse": {
            "type": "object",
            "properties": {
                "id": {"type": "string"},
                "type": {"type": "string", "enum": ["sale", "rent"]},
                "value_brl": {"type": "number"},
                "value_usd": {"type": "number", "description": "Valor convertido para USD"},
                "image_url": {"type": "string"},
                "address": {"$ref": "#/definitions/Address"},
                "created_at": {"type": "string", "format": "date-time"}
            }
        },
        "CreateExchangeRateRequest": {
            "type": "object",
            "properties": {
                "rate": {"type": "number", "minimum": 0, "exclusiveMinimum": true, "description": "Taxa 1 BRL = X USD"}
            },
            "required": ["rate"]
        },
        "ExchangeRate": {
            "type": "object",
            "properties": {
                "id": {"type": "string"},
                "rate": {"type": "number"},
                "valid_from": {"type": "string", "format": "date-time"},
                "valid_to": {"type": "string", "format": "date-time"},
                "created_at": {"type": "string", "format": "date-time"}
            }
        }
    }
}`

var SwaggerInfo = &swag.Spec{
	Version:          "1.0",
	Host:             "localhost:8080",
	BasePath:         "/",
	Schemes:          []string{"http"},
	Title:            "Real Estate API",
	Description:      "API para gestão de anúncios de imóveis.",
	InfoInstanceName: "swagger",
	SwaggerTemplate:  docTemplate,
}

func init() {
	swag.Register(SwaggerInfo.InstanceName(), SwaggerInfo)
}
