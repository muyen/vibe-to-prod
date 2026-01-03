#!/bin/bash
# OpenAPI Change Detection Hook
# Hook Type: PostToolUse (Write|Edit)
# Purpose: Remind to regenerate code when OpenAPI spec changes

FILE_PATH="$1"

# Check if OpenAPI spec was modified
if [[ "$FILE_PATH" == *openapi.yaml ]] || [[ "$FILE_PATH" == *openapi.yml ]]; then
    echo ""
    echo "🔧 [OpenAPI Hook] Spec modified: $(basename "$FILE_PATH")"
    echo ""
    echo "⚠️  REQUIRED NEXT STEPS:"
    echo ""
    echo "1️⃣  Regenerate code for all platforms:"
    echo "    python scripts/openapi_workflow.py --full"
    echo ""
    echo "    Or manually:"
    echo "    - Backend:  cd backend && oapi-codegen -config api/oapi-codegen.yaml api/openapi.yaml"
    echo "    - iOS:      cd mobile/ios && ./scripts/generate-api.sh"
    echo "    - Android:  cd mobile/android && ./gradlew openApiGenerate"
    echo ""
    echo "2️⃣  Verify all builds pass:"
    echo "    - Backend:  cd backend && make build && make test"
    echo "    - iOS:      cd mobile/ios && make build"
    echo "    - Android:  cd mobile/android && ./gradlew assembleDebug"
    echo ""
fi

exit 0
