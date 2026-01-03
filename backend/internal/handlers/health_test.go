package handlers

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestHealthHandler_Health(t *testing.T) {
	// Arrange
	e := echo.New()
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	handler := NewHealthHandler("1.0.0")

	// Act
	err := handler.Health(c)

	// Assert
	require.NoError(t, err)
	assert.Equal(t, http.StatusOK, rec.Code)

	var response HealthResponse
	err = json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)
	assert.Equal(t, "ok", response.Status)
	assert.Empty(t, response.Version) // Version not included in basic health
}

func TestHealthHandler_HealthWithVersion(t *testing.T) {
	tests := []struct {
		name            string
		version         string
		expectedVersion string
	}{
		{
			name:            "returns version 1.0.0",
			version:         "1.0.0",
			expectedVersion: "1.0.0",
		},
		{
			name:            "returns version 2.1.0",
			version:         "2.1.0",
			expectedVersion: "2.1.0",
		},
		{
			name:            "handles empty version",
			version:         "",
			expectedVersion: "",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Arrange
			e := echo.New()
			req := httptest.NewRequest(http.MethodGet, "/api/v1/health", nil)
			rec := httptest.NewRecorder()
			c := e.NewContext(req, rec)

			handler := NewHealthHandler(tt.version)

			// Act
			err := handler.HealthWithVersion(c)

			// Assert
			require.NoError(t, err)
			assert.Equal(t, http.StatusOK, rec.Code)

			var response HealthResponse
			err = json.Unmarshal(rec.Body.Bytes(), &response)
			require.NoError(t, err)
			assert.Equal(t, "ok", response.Status)
			assert.Equal(t, tt.expectedVersion, response.Version)
		})
	}
}
