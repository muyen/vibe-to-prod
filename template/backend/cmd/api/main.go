package main

import (
	"context"
	"fmt"
	"net/http"
	"os"

	"github.com/labstack/echo/v4"
	"github.com/labstack/echo/v4/middleware"
	"go.uber.org/fx"
	"go.uber.org/zap"
)

func main() {
	app := fx.New(
		fx.Provide(
			NewLogger,
			NewEchoServer,
		),
		fx.Invoke(RegisterRoutes),
		fx.Invoke(StartServer),
	)

	app.Run()
}

// NewLogger creates a production-ready zap logger
func NewLogger() (*zap.Logger, error) {
	env := os.Getenv("ENV")
	if env == "production" {
		return zap.NewProduction()
	}
	return zap.NewDevelopment()
}

// NewEchoServer creates and configures the Echo server
func NewEchoServer(logger *zap.Logger) *echo.Echo {
	e := echo.New()
	e.HideBanner = true
	e.HidePort = true

	// Middleware
	e.Use(middleware.Recover())
	e.Use(middleware.RequestID())
	e.Use(middleware.CORS())

	// Request logging
	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			logger.Info("request",
				zap.String("method", c.Request().Method),
				zap.String("path", c.Request().URL.Path),
				zap.String("request_id", c.Response().Header().Get(echo.HeaderXRequestID)),
			)
			return next(c)
		}
	})

	return e
}

// RegisterRoutes sets up all API routes
func RegisterRoutes(e *echo.Echo, logger *zap.Logger) {
	// Health check (required for Cloud Run / Kubernetes)
	e.GET("/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"status": "ok",
		})
	})

	// API v1 routes
	api := e.Group("/api/v1")

	api.GET("/health", func(c echo.Context) error {
		return c.JSON(http.StatusOK, map[string]string{
			"status":  "ok",
			"version": "1.0.0",
		})
	})

	// Example: Hello endpoint
	api.GET("/hello", func(c echo.Context) error {
		name := c.QueryParam("name")
		if name == "" {
			name = "World"
		}
		return c.JSON(http.StatusOK, map[string]string{
			"message": fmt.Sprintf("Hello, %s!", name),
		})
	})

	logger.Info("routes registered")
}

// StartServer starts the HTTP server with lifecycle management
func StartServer(lc fx.Lifecycle, e *echo.Echo, logger *zap.Logger) {
	port := os.Getenv("PORT")
	if port == "" {
		port = "8080"
	}

	lc.Append(fx.Hook{
		OnStart: func(ctx context.Context) error {
			logger.Info("starting server", zap.String("port", port))
			go func() {
				if err := e.Start(":" + port); err != nil && err != http.ErrServerClosed {
					logger.Fatal("server error", zap.Error(err))
				}
			}()
			return nil
		},
		OnStop: func(ctx context.Context) error {
			logger.Info("shutting down server")
			return e.Shutdown(ctx)
		},
	})
}
