package handlers

import (
	"net/http"

	"github.com/labstack/echo/v4"
)

// HealthResponse represents the health check response
type HealthResponse struct {
	Status  string `json:"status"`
	Version string `json:"version,omitempty"`
}

// HealthHandler handles health check endpoints
type HealthHandler struct {
	version string
}

// NewHealthHandler creates a new health handler
func NewHealthHandler(version string) *HealthHandler {
	return &HealthHandler{version: version}
}

// Health returns basic health status
func (h *HealthHandler) Health(c echo.Context) error {
	return c.JSON(http.StatusOK, HealthResponse{
		Status: "ok",
	})
}

// HealthWithVersion returns health status with version info
func (h *HealthHandler) HealthWithVersion(c echo.Context) error {
	return c.JSON(http.StatusOK, HealthResponse{
		Status:  "ok",
		Version: h.version,
	})
}
