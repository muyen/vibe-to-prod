#!/bin/bash
# Session End Hook - Vibe to Prod
# Purpose: Remind to update session log

echo "== SESSION END - VIBE TO PROD =="
echo ""

# 1. Check for uncommitted changes
UNCOMMITTED=$(git status --short 2>/dev/null)
if [ -n "$UNCOMMITTED" ]; then
    UNCOMMITTED_COUNT=$(echo "$UNCOMMITTED" | wc -l | tr -d ' ')
    echo "Uncommitted Changes: $UNCOMMITTED_COUNT file(s)"
    echo "$UNCOMMITTED" | head -5
    echo ""
fi

# 2. Commits this session
BRANCH_COMMITS=$(git log origin/main..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ "$BRANCH_COMMITS" -gt 0 ]; then
    echo "Branch Commits: $BRANCH_COMMITS (not yet pushed)"
    git log origin/main..HEAD --oneline --max-count=3 2>/dev/null
    echo ""
fi

# 3. Session log reminder
echo "IMPORTANT: Update docs/SESSION_LOG.md before ending"
echo ""
echo "Add to SESSION_LOG.md:"
echo "  - What was accomplished"
echo "  - Decisions made"
echo "  - Next steps for next session"
echo ""

exit 0
