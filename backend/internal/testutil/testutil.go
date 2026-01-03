// Package testutil provides utilities for testing the API
package testutil

import (
	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"github.com/your-org/your-app/internal/handlers"
)

// SetupTestServer creates a configured Echo server for testing
func SetupTestServer() *echo.Echo {
	e := echo.New()
	e.HideBanner = true
	e.HidePort = true

	// Standard middleware
	e.Use(middleware.Recover())
	e.Use(middleware.RequestID())

	// Register handlers
	healthHandler := handlers.NewHealthHandler("1.0.0-test")
	helloHandler := handlers.NewHelloHandler()

	// Routes
	e.GET("/health", healthHandler.Health)

	api := e.Group("/api/v1")
	api.GET("/health", healthHandler.HealthWithVersion)
	api.GET("/hello", helloHandler.Hello)

	return e
}
