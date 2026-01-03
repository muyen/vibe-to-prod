// Package integration contains integration tests for the API
package integration

import (
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/require"
	"github.com/your-org/your-app/internal/testutil"
)

// TestAPI_HealthCheck tests the basic health endpoint
func TestAPI_HealthCheck(t *testing.T) {
	// Arrange
	server := testutil.SetupTestServer()
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()

	// Act
	server.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusOK, rec.Code)

	var response map[string]string
	err := json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)
	assert.Equal(t, "ok", response["status"])
}

// TestAPI_VersionedHealthCheck tests the versioned health endpoint
func TestAPI_VersionedHealthCheck(t *testing.T) {
	// Arrange
	server := testutil.SetupTestServer()
	req := httptest.NewRequest(http.MethodGet, "/api/v1/health", nil)
	rec := httptest.NewRecorder()

	// Act
	server.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusOK, rec.Code)

	var response map[string]string
	err := json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)
	assert.Equal(t, "ok", response["status"])
	assert.NotEmpty(t, response["version"])
}

// TestAPI_Hello_DefaultGreeting tests hello without name parameter
func TestAPI_Hello_DefaultGreeting(t *testing.T) {
	// Arrange
	server := testutil.SetupTestServer()
	req := httptest.NewRequest(http.MethodGet, "/api/v1/hello", nil)
	rec := httptest.NewRecorder()

	// Act
	server.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusOK, rec.Code)

	var response map[string]string
	err := json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)
	assert.Equal(t, "Hello, World!", response["message"])
}

// TestAPI_Hello_CustomGreeting tests hello with name parameter
func TestAPI_Hello_CustomGreeting(t *testing.T) {
	// Arrange
	server := testutil.SetupTestServer()
	req := httptest.NewRequest(http.MethodGet, "/api/v1/hello?name=Alice", nil)
	rec := httptest.NewRecorder()

	// Act
	server.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusOK, rec.Code)

	var response map[string]string
	err := json.Unmarshal(rec.Body.Bytes(), &response)
	require.NoError(t, err)
	assert.Equal(t, "Hello, Alice!", response["message"])
}

// TestAPI_NotFound tests 404 for unknown routes
func TestAPI_NotFound(t *testing.T) {
	// Arrange
	server := testutil.SetupTestServer()
	req := httptest.NewRequest(http.MethodGet, "/api/v1/unknown", nil)
	rec := httptest.NewRecorder()

	// Act
	server.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusNotFound, rec.Code)
}

// TestAPI_MethodNotAllowed tests 405 for wrong HTTP methods
func TestAPI_MethodNotAllowed(t *testing.T) {
	// Arrange
	server := testutil.SetupTestServer()
	req := httptest.NewRequest(http.MethodPost, "/health", nil)
	rec := httptest.NewRecorder()

	// Act
	server.ServeHTTP(rec, req)

	// Assert
	assert.Equal(t, http.StatusMethodNotAllowed, rec.Code)
}

// TestAPI_RequestIDHeader tests that request ID is added
func TestAPI_RequestIDHeader(t *testing.T) {
	// Arrange
	server := testutil.SetupTestServer()
	req := httptest.NewRequest(http.MethodGet, "/health", nil)
	rec := httptest.NewRecorder()

	// Act
	server.ServeHTTP(rec, req)

	// Assert
	assert.NotEmpty(t, rec.Header().Get("X-Request-Id"))
}
