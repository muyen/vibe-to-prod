#!/bin/bash
# Protect generated files from manual editing
# Hook: PreToolUse (Write|Edit)

FILE_PATH="$1"

# List of generated file patterns
GENERATED_PATTERNS=(
    "*.xcodeproj/*"
    "*.xcworkspace/*"
    "Pods/*"
    "*/generated/*"
    "*/build/*"
    "*/node_modules/*"
)

for pattern in "${GENERATED_PATTERNS[@]}"; do
    if [[ "$FILE_PATH" == $pattern ]]; then
        echo "BLOCKED: $FILE_PATH is a generated file."
        echo "Edit the source file instead (e.g., project.yml for Xcode projects)"
        exit 1
    fi
done

exit 0
