---
allowed-tools: Read, Edit, Write, Bash(git status:*), Bash(git log:*), TodoWrite
description: End session and update session log with progress
model: sonnet
---

# Session End

End the current session and log progress for future sessions.

## Current State

- Uncommitted changes: !`git status --short`
- Branch commits: !`git log origin/main..HEAD --oneline 2>/dev/null | head -5`

## Process

1. Review what was accomplished this session
2. Read the current todo list
3. Update `docs/SESSION_LOG.md` with:
   - Summary of work done
   - Decisions made
   - Progress on tasks
   - Next steps for next session

## Session Log Format

Add a new entry at the TOP of the file (after the header) with this structure:

```markdown
## Session N - YYYY-MM-DD

### Summary
[Brief description of what was accomplished]

### Decisions Made
| Decision | Choice | Rationale |
|----------|--------|-----------|
| ... | ... | ... |

### Progress
- [x] Completed task
- [ ] Incomplete task

### Next Steps
1. ...
2. ...

---
```

## Final Actions

1. Update SESSION_LOG.md
2. Report any uncommitted changes
3. Suggest whether to commit or stash
