package handlers

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"strings"
	"testing"

	"github.com/labstack/echo/v4"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
)

func TestHelloHandler_Hello(t *testing.T) {
	tests := []struct {
		name           string
		queryName      string
		expectedMsg    string
		expectedStatus int
	}{
		{
			name:           "greets world when no name provided",
			queryName:      "",
			expectedMsg:    "Hello, World!",
			expectedStatus: http.StatusOK,
		},
		{
			name:           "greets provided name",
			queryName:      "Alice",
			expectedMsg:    "Hello, Alice!",
			expectedStatus: http.StatusOK,
		},
		{
			name:           "handles special characters",
			queryName:      "O'Brien",
			expectedMsg:    "Hello, O'Brien!",
			expectedStatus: http.StatusOK,
		},
		{
			name:           "handles unicode names",
			queryName:      "世界",
			expectedMsg:    "Hello, 世界!",
			expectedStatus: http.StatusOK,
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			// Arrange
			e := echo.New()
			target := "/api/v1/hello"
			if tt.queryName != "" {
				target += "?name=" + tt.queryName
			}
			req := httptest.NewRequest(http.MethodGet, target, nil)
			rec := httptest.NewRecorder()
			c := e.NewContext(req, rec)

			handler := NewHelloHandler()

			// Act
			err := handler.Hello(c)

			// Assert
			require.NoError(t, err)
			assert.Equal(t, tt.expectedStatus, rec.Code)

			var response HelloResponse
			err = json.Unmarshal(rec.Body.Bytes(), &response)
			require.NoError(t, err)
			assert.Equal(t, tt.expectedMsg, response.Message)
		})
	}
}

func TestHelloHandler_Hello_RejectsLongName(t *testing.T) {
	// Arrange
	e := echo.New()
	longName := strings.Repeat("a", 101)
	req := httptest.NewRequest(http.MethodGet, "/api/v1/hello?name="+longName, nil)
	rec := httptest.NewRecorder()
	c := e.NewContext(req, rec)

	handler := NewHelloHandler()

	// Act
	err := handler.Hello(c)

	// Assert
	require.Error(t, err)
	httpErr, ok := err.(*echo.HTTPError)
	require.True(t, ok)
	assert.Equal(t, http.StatusBadRequest, httpErr.Code)
}
