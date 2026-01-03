#!/bin/bash
# Session Start Hook - Context Reminder
# Triggers: Every session start
# Output: Injected into AI context

echo "🚀 SESSION START"
echo ""

# 1. Git context
BRANCH=$(git branch --show-current 2>/dev/null)
if [ -n "$BRANCH" ]; then
    echo "📍 Branch: $BRANCH"
else
    echo "📍 Not in a git repository"
fi

# 2. Check for uncommitted changes
UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$UNCOMMITTED" -gt 0 ]; then
    echo "⚠️  Uncommitted changes: $UNCOMMITTED file(s)"
fi

# 3. Check for uncommitted OpenAPI changes
if git diff --name-only 2>/dev/null | grep -q "openapi.yaml"; then
    echo "🔴 UNCOMMITTED OPENAPI CHANGES - Run: python scripts/openapi_workflow.py --full"
fi
echo ""

# 4. CRITICAL RULES REMINDER
echo "🚨 CRITICAL RULES:"
echo "   • Edit SOURCE files, not GENERATED files"
echo "   • After OpenAPI changes: python scripts/openapi_workflow.py --full"
echo "   • Verify build before commit: make build (or platform equivalent)"
echo "   • Commit format: type: description"
echo ""

# 5. Quick actions
echo "📋 Quick Actions:"
echo "   /commit       - Create formatted commit"
echo "   /code-review  - Review code quality"
echo "   /ultra-think  - Deep analysis mode"
echo ""

# 6. Project context
echo "📁 Project: Vibe to Production Template"
echo "   Backend: Go + Echo"
echo "   iOS: Swift + SwiftUI (XcodeGen)"
echo "   Android: Kotlin + Compose"
echo ""

exit 0
