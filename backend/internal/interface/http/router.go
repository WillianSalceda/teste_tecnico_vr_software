package http

import (
	"github.com/gin-gonic/gin"
	swaggerFiles "github.com/swaggo/files"
	ginSwagger "github.com/swaggo/gin-swagger"

	"github.com/williansalceda/teste_tecnico_vr_software/backend/internal/handler"

	_ "github.com/williansalceda/teste_tecnico_vr_software/backend/docs"
)

func SetupRouter(
	addressHandler *handler.AddressHandler,
	listingHandler *handler.ListingHandler,
	exchangeRateHandler *handler.ExchangeRateHandler,
	uploadHandler *handler.UploadHandler,
) *gin.Engine {
	r := gin.Default()

	r.Use(func(c *gin.Context) {
		c.Header("Access-Control-Allow-Origin", "*")
		c.Header("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
		c.Header("Access-Control-Allow-Headers", "Content-Type, Authorization")
		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}
		c.Next()
	})

	r.GET("/health", func(c *gin.Context) { c.JSON(200, gin.H{"status": "ok"}) })
	r.Static("/uploads", "./uploads")

	api := r.Group("/api/v1")
	api.Use(JWTAuth())
	{
		api.POST("/listings", listingHandler.Create)
		api.GET("/listings", listingHandler.List)
		api.GET("/address/cep/:cep", addressHandler.GetByCEP)
		api.POST("/exchange-rates", exchangeRateHandler.Create)
		api.GET("/exchange-rates", exchangeRateHandler.List)
		api.POST("/upload", uploadHandler.Upload)
	}

	r.GET("/swagger/*any", ginSwagger.WrapHandler(swaggerFiles.Handler))
	return r
}
