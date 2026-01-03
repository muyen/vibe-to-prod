---
allowed-tools: Bash
description: Create well-formatted commits with conventional commit format
---

# Create Commit

Create a well-formatted commit following conventional commit conventions.

## Process

1. Check git status to see changes
2. Review the diff to understand what changed
3. Stage appropriate files
4. Create commit with conventional format

## Commit Format

```
type: description

Types:
- feat:     New feature
- fix:      Bug fix
- docs:     Documentation
- style:    Formatting (no code change)
- refactor: Code restructuring
- test:     Adding tests
- chore:    Maintenance
```

## Pre-Commit Checklist

- [ ] Tests pass
- [ ] No secrets in code
- [ ] Commit message is clear
- [ ] Only relevant files staged

## Commands

```bash
# Check status
git status

# View changes
git diff

# Stage files
git add -A  # or specific files

# Commit
git commit -m "type: description"

# Push
git push
```
