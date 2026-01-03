package handlers

import (
	"fmt"
	"net/http"
	"strings"

	"github.com/labstack/echo/v4"
)

// HelloResponse represents the hello endpoint response
type HelloResponse struct {
	Message string `json:"message"`
}

// HelloHandler handles hello endpoints
type HelloHandler struct{}

// NewHelloHandler creates a new hello handler
func NewHelloHandler() *HelloHandler {
	return &HelloHandler{}
}

// Hello returns a greeting message
func (h *HelloHandler) Hello(c echo.Context) error {
	name := strings.TrimSpace(c.QueryParam("name"))
	if name == "" {
		name = "World"
	}

	// Basic input validation - prevent excessively long names
	if len(name) > 100 {
		return echo.NewHTTPError(http.StatusBadRequest, "name too long")
	}

	return c.JSON(http.StatusOK, HelloResponse{
		Message: fmt.Sprintf("Hello, %s!", name),
	})
}
