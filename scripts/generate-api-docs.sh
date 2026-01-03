#!/bin/bash
# Generate API documentation from OpenAPI spec
#
# Prerequisites:
#   npm install -g @redocly/cli
#   OR
#   npm install -g redoc-cli
#
# Usage:
#   ./scripts/generate-api-docs.sh
#
# Output:
#   backend/api/docs/index.html

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
OPENAPI_SPEC="$PROJECT_ROOT/backend/api/openapi.yaml"
DOCS_DIR="$PROJECT_ROOT/backend/api/docs"

echo "Generating API documentation..."
echo "  Source: $OPENAPI_SPEC"
echo "  Output: $DOCS_DIR/index.html"

# Create docs directory
mkdir -p "$DOCS_DIR"

# Check for redocly CLI (newer)
if command -v redocly &> /dev/null; then
    echo "Using redocly CLI..."
    redocly build-docs "$OPENAPI_SPEC" \
        --output "$DOCS_DIR/index.html" \
        --title "API Documentation"
    echo "Documentation generated successfully!"
    exit 0
fi

# Check for redoc-cli (older)
if command -v redoc-cli &> /dev/null; then
    echo "Using redoc-cli..."
    redoc-cli bundle "$OPENAPI_SPEC" \
        --output "$DOCS_DIR/index.html" \
        --title "API Documentation"
    echo "Documentation generated successfully!"
    exit 0
fi

# Fallback: Create a simple HTML page that loads Redoc from CDN
echo "No redoc CLI found, generating CDN-based docs..."
cat > "$DOCS_DIR/index.html" << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>API Documentation</title>
    <meta charset="utf-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://fonts.googleapis.com/css?family=Montserrat:300,400,700|Roboto:300,400,700" rel="stylesheet">
    <style>
        body { margin: 0; padding: 0; }
    </style>
</head>
<body>
    <redoc spec-url='openapi.yaml'></redoc>
    <script src="https://cdn.redoc.ly/redoc/latest/bundles/redoc.standalone.js"></script>
</body>
</html>
EOF

# Copy OpenAPI spec to docs directory for CDN version
cp "$OPENAPI_SPEC" "$DOCS_DIR/openapi.yaml"

echo "CDN-based documentation generated!"
echo ""
echo "To view locally:"
echo "  cd $DOCS_DIR && python -m http.server 8000"
echo "  Open http://localhost:8000"
echo ""
echo "For better docs, install redocly:"
echo "  npm install -g @redocly/cli"
