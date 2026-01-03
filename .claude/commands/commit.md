---
allowed-tools: Bash(git add:*), Bash(git status:*), Bash(git commit:*), Bash(git diff:*), Bash(git log:*)
argument-hint: [message] | --no-verify | --amend
description: Create well-formatted commits with conventional commit format and emoji
model: sonnet
---

# Smart Git Commit

Create well-formatted commit: $ARGUMENTS

## Current Repository State

- Git status: !`git status --porcelain`
- Current branch: !`git branch --show-current`
- Staged changes: !`git diff --cached --stat`
- Recent commits: !`git log --oneline -5`

## Commit Format

**Format**: `type: description`

### Commit Types with Emoji

| Type | Emoji | Description |
|------|-------|-------------|
| feat | * | New feature |
| fix | * | Bug fix |
| docs | * | Documentation |
| refactor | * | Code refactoring |
| test | * | Tests |
| chore | * | Tooling, configuration |
| perf | * | Performance |
| ci | * | CI/CD |
| build | * | Build system |

### Examples

```
feat: add session logging system
fix: resolve hook execution timing
refactor: simplify project structure
docs: update business plan
chore: add gitignore entries
```

## Process

1. Check staged files with `git status`
2. If nothing staged, prompt user to stage specific files
3. Analyze diff to determine commit type
4. Generate commit message
5. Commit changes

## Atomic Commits

If diff contains multiple unrelated changes:
- Suggest splitting into separate commits
- Each commit should serve a single purpose

## Guidelines

- **Present tense, imperative mood**: "add feature" not "added feature"
- **Concise first line**: Keep under 72 characters
- **No WIP commits**: Only commit working code
