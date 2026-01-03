package main

import (
	"context"
	"fmt"
	"net/http"
	"os"
	"strings"
	"time"

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

// NewEchoServer creates and configures the Echo server with middleware
// Pattern matches proofmi: Recover, CORS, Security Headers, RequestID, Logging
func NewEchoServer(logger *zap.Logger) *echo.Echo {
	e := echo.New()
	e.HideBanner = true
	e.HidePort = true

	env := os.Getenv("ENV")
	isProduction := env == "production"

	// 1. Panic recovery - prevents server crash on panic
	e.Use(middleware.Recover())

	// 2. Request logging
	e.Use(middleware.Logger())

	// 3. CORS - Cross-Origin Resource Sharing (matches proofmi pattern)
	allowedOrigins := os.Getenv("CORS_ALLOWED_ORIGINS")
	if allowedOrigins == "" {
		if isProduction {
			allowedOrigins = "https://yourapp.com"
			logger.Warn("CORS_ALLOWED_ORIGINS not set, using default. Set this in production!")
		} else {
			allowedOrigins = "http://localhost:3000,http://localhost:8080"
		}
	}

	// Create origin lookup map for O(1) checking (matches proofmi)
	allowedOriginMap := make(map[string]bool)
	for _, origin := range strings.Split(allowedOrigins, ",") {
		allowedOriginMap[strings.TrimSpace(origin)] = true
	}

	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			origin := c.Request().Header.Get("Origin")

			// Only set CORS headers if origin is in allowed list
			if origin != "" && allowedOriginMap[origin] {
				c.Response().Header().Set("Access-Control-Allow-Origin", origin)
				c.Response().Header().Set("Access-Control-Allow-Methods", "GET, POST, PUT, DELETE, OPTIONS")
				c.Response().Header().Set("Access-Control-Allow-Headers", "Origin, Content-Type, Accept, Authorization")
				c.Response().Header().Set("Access-Control-Allow-Credentials", "true")
				c.Response().Header().Add("Vary", "Origin")
			}

			if c.Request().Method == "OPTIONS" {
				return c.NoContent(http.StatusNoContent)
			}

			return next(c)
		}
	})

	// 4. Security headers (matches proofmi pattern - OWASP A05:2021)
	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			// X-Content-Type-Options: Prevent MIME type sniffing
			c.Response().Header().Set("X-Content-Type-Options", "nosniff")

			// X-Frame-Options: Prevent clickjacking
			c.Response().Header().Set("X-Frame-Options", "DENY")

			// X-XSS-Protection: Enable browser's XSS filtering
			c.Response().Header().Set("X-XSS-Protection", "1; mode=block")

			// Referrer-Policy: Control referrer information leakage
			c.Response().Header().Set("Referrer-Policy", "strict-origin-when-cross-origin")

			// Content-Security-Policy: Strict policy for API responses
			c.Response().Header().Set("Content-Security-Policy", "default-src 'none'; frame-ancestors 'none'")

			// Permissions-Policy: Disable unnecessary browser features
			c.Response().Header().Set("Permissions-Policy", "geolocation=(), microphone=(), camera=()")

			// Cache-Control: Prevent caching of authenticated responses
			if c.Request().Header.Get("Authorization") != "" {
				c.Response().Header().Set("Cache-Control", "no-store, no-cache, must-revalidate, private")
				c.Response().Header().Set("Pragma", "no-cache")
			}

			// HSTS: Force HTTPS in production only
			if isProduction {
				c.Response().Header().Set("Strict-Transport-Security", "max-age=31536000; includeSubDomains; preload")
			}

			return next(c)
		}
	})

	// 5. Request ID - for tracing requests across services
	e.Use(middleware.RequestID())

	// 6. Request logging with context (structured logging)
	e.Use(func(next echo.HandlerFunc) echo.HandlerFunc {
		return func(c echo.Context) error {
			start := time.Now()

			err := next(c)

			logger.Info("request",
				zap.String("method", c.Request().Method),
				zap.String("path", c.Request().URL.Path),
				zap.Int("status", c.Response().Status),
				zap.Duration("latency", time.Since(start)),
				zap.String("request_id", c.Response().Header().Get(echo.HeaderXRequestID)),
				zap.String("remote_ip", c.RealIP()),
			)

			return err
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
