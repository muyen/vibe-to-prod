---
name: git-workflow
description: Git workflow management. Triggers when creating branches, preparing PRs, or managing merge decisions.
---

# Git Workflow Skill

Manage git branches, commits, and pull requests following project conventions.

## When to Activate

This skill should activate when:
- Starting work on a new feature/fix
- Creating a new feature branch
- Preparing to create a pull request
- Deciding whether to merge or rebase
- Resolving merge conflicts

## Branch Naming Convention

```
<type>/<short-description>

Examples:
- feature/add-user-profile
- fix/login-redirect-bug
- chore/update-dependencies
```

## Commit Message Format

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

Examples:
- feat: add user profile endpoint
- fix: resolve login redirect issue
- chore: update dependencies
```

## Workflow Steps

### 1. Start New Work
```bash
# Ensure main is up to date
git checkout main
git pull origin main

# Create feature branch
git checkout -b feature/description
```

### 2. During Development
```bash
# Stage changes
git add -p  # Interactive staging (review each change)

# Commit with conventional format
git commit -m "type: description"

# Push regularly
git push -u origin branch-name
```

### 3. Before PR
```bash
# Ensure all tests pass
make test  # or appropriate test command

# Rebase on latest main (if needed)
git fetch origin main
git rebase origin/main

# Force push after rebase
git push --force-with-lease
```

### 4. Create PR
```bash
# Using GitHub CLI
gh pr create --title "type: description" \
  --body "## Summary
- What this PR does

## Test Plan
- How to test"
```

## Merge vs Rebase Decision

| Situation | Action |
|-----------|--------|
| Feature branch behind main | Rebase onto main |
| Shared branch (multiple devs) | Merge, don't rebase |
| Before PR | Rebase + squash if messy |
| After PR approved | Squash merge via GitHub |

## Conflict Resolution

```bash
# During rebase conflict
git status  # See conflicted files
# Edit files to resolve conflicts
git add <resolved-files>
git rebase --continue

# If too messy, abort and merge instead
git rebase --abort
git merge origin/main
```

## Rules

- **Never** force push to main/master
- **Always** run tests before creating PR
- **Squash merge** feature branches to keep history clean

## Output Format

```
## Git Workflow

**Branch**: `feature/description`
**Base**: `main`
**Commits**: X commits

### Pre-PR Checklist
- [ ] Tests passing
- [ ] Rebased on latest main
- [ ] Commit messages follow convention
- [ ] No merge conflicts

### Ready for PR
```bash
gh pr create --title "..." --body "..."
```
```
