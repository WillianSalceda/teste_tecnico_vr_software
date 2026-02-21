package docs

import "github.com/swaggo/swag"

const docTemplate = `{
    "schemes": {{ marshal .Schemes }},
    "swagger": "2.0",
    "info": {
        "description": "{{escape .Description}}",
        "title": "{{.Title}}",
        "version": "{{.Version}}"
    },
    "host": "{{.Host}}",
    "basePath": "{{.BasePath}}",
    "paths": {
        "/api/v1/listings": {
            "get": {
                "summary": "List listings",
                "parameters": [
                    {"name": "page", "in": "query", "type": "integer"},
                    {"name": "limit", "in": "query", "type": "integer"},
                    {"name": "type", "in": "query", "type": "string", "enum": ["sale", "rent"]}
                ],
                "responses": {"200": {"description": "OK"}}
            },
            "post": {
                "summary": "Create listing",
                "parameters": [{
                    "name": "body",
                    "in": "body",
                    "required": true,
                    "schema": {"type": "object"}
                }],
                "responses": {"201": {"description": "Created"}}
            }
        },
        "/api/v1/address/cep/{cep}": {
            "get": {
                "summary": "Get address by CEP",
                "parameters": [{"name": "cep", "in": "path", "required": true, "type": "string"}],
                "responses": {"200": {"description": "OK"}, "404": {"description": "CEP not found"}}
            }
        },
        "/api/v1/exchange-rates": {
            "get": {"summary": "List exchange rates", "responses": {"200": {"description": "OK"}}},
            "post": {
                "summary": "Create exchange rate",
                "parameters": [{
                    "name": "body",
                    "in": "body",
                    "required": true,
                    "schema": {"type": "object", "properties": {"rate": {"type": "number"}}}
                }],
                "responses": {"201": {"description": "Created"}}
            }
        }
    }
}`

var SwaggerInfo = &swag.Spec{
	Version:          "1.0",
	Host:             "localhost:8080",
	BasePath:         "/",
	Schemes:          []string{},
	Title:            "Real Estate API",
	Description:      "...",
	InfoInstanceName: "swagger",
	SwaggerTemplate:  docTemplate,
}

func init() {
	swag.Register(SwaggerInfo.InstanceName(), SwaggerInfo)
}
