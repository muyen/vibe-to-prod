#!/bin/bash
# Session Start Hook - Vibe to Prod
# Purpose: Load context from previous sessions

echo "== VIBE TO PROD - SESSION START =="
echo ""

# 1. Git context
BRANCH=$(git branch --show-current 2>/dev/null)
echo "Branch: $BRANCH"

# 2. Check for uncommitted changes
UNCOMMITTED=$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
if [ "$UNCOMMITTED" -gt 0 ]; then
    echo "Uncommitted changes: $UNCOMMITTED file(s)"
fi
echo ""

# 3. Display session log summary
SESSION_LOG="docs/SESSION_LOG.md"
if [ -f "$SESSION_LOG" ]; then
    echo "IMPORTANT: Read docs/SESSION_LOG.md for context from previous sessions"
    echo ""
    # Show last session header
    LAST_SESSION=$(grep -n "^## Session" "$SESSION_LOG" | tail -1)
    if [ -n "$LAST_SESSION" ]; then
        echo "Last session: $(echo "$LAST_SESSION" | cut -d: -f2 | sed 's/## //')"
    fi
fi
echo ""

# 4. Quick actions
echo "Quick Actions:"
echo "  /commit - Create formatted commit"
echo "  /session-end - Log progress and end session"
echo ""

# 5. Reminder
echo "GOAL: Quick validation - ship fast, test demand, iterate"
echo "Focus: Claude Code config is the unique selling point"

exit 0
