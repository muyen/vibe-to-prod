#!/bin/bash
# Session End Hook - Handover Summary
# Triggers: Every session end
# Output: Injected into AI context

echo "👋 SESSION END - Handover Summary"
echo ""

# 1. Check for uncommitted changes
UNCOMMITTED=$(git status --short 2>/dev/null)
if [ -n "$UNCOMMITTED" ]; then
    UNCOMMITTED_COUNT=$(echo "$UNCOMMITTED" | wc -l | tr -d ' ')
    echo "⚠️  Uncommitted Changes: $UNCOMMITTED_COUNT file(s)"
    echo ""
    echo "$UNCOMMITTED" | head -10
    if [ "$UNCOMMITTED_COUNT" -gt 10 ]; then
        echo "   ... and $(($UNCOMMITTED_COUNT - 10)) more"
    fi
    echo ""
fi

# 2. Check for staged but uncommitted changes
STAGED=$(git diff --cached --name-only 2>/dev/null)
if [ -n "$STAGED" ]; then
    STAGED_COUNT=$(echo "$STAGED" | wc -l | tr -d ' ')
    echo "📦 Staged Changes: $STAGED_COUNT file(s) ready to commit"
    echo ""
fi

# 3. Branch commits not pushed
BRANCH_COMMITS=$(git log origin/main..HEAD --oneline 2>/dev/null | wc -l | tr -d ' ')
if [ "$BRANCH_COMMITS" -gt 0 ]; then
    echo "✅ Branch Commits: $BRANCH_COMMITS (not yet pushed)"
    echo ""
    echo "Recent commits:"
    git log origin/main..HEAD --oneline --max-count=5 2>/dev/null
    echo ""
fi

# 4. Handover checklist
echo "📝 Before Next Session:"
if [ -n "$UNCOMMITTED" ]; then
    echo "  ⬜ Review uncommitted changes (commit or stash)"
fi
if [ "$BRANCH_COMMITS" -gt 0 ]; then
    echo "  ⬜ Consider: Push commits or create PR"
fi
echo "  ⬜ Note any blocking issues"
echo "  ⬜ Update task tracker if using Linear/GitHub Issues"
echo ""

# 5. Continuous improvement reminder
echo "💡 Continuous Improvement:"
echo "   Did you learn something? Consider:"
echo "   • Add rule to .claude/rules/ (for repeated mistakes)"
echo "   • Add skill to .claude/skills/ (for complex processes)"
echo "   • Store in Memory MCP (for patterns/knowledge)"
echo ""

exit 0
