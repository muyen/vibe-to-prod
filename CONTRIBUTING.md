# Contributing to Vibe to Production

Thank you for your interest in contributing! This project aims to help developers ship to production faster with AI-assisted workflows.

## How to Contribute

### Reporting Issues

1. **Check existing issues** - Your issue may already be reported
2. **Create a new issue** with:
   - Clear title describing the problem
   - Steps to reproduce
   - Expected vs actual behavior
   - Environment details (OS, versions)

### Suggesting Improvements

1. **Open a discussion** first for major changes
2. Describe the problem you're solving
3. Explain why this benefits others

### Pull Requests

1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature`
3. Make your changes
4. Test thoroughly
5. Commit with conventional format: `type: description`
6. Push and create a PR

## Development Setup

```bash
# Clone your fork
git clone https://github.com/YOUR_USERNAME/vibe-to-prod.git
cd vibe-to-prod/template

# Run setup
./scripts/setup.sh

# Verify everything works
cd backend && make test
```

## Code Style

### General

- Keep it simple - this is a template, not a framework
- Document "why", not "what"
- Prefer explicit over clever

### Go (Backend)

- Follow standard Go conventions
- Use `gofmt` before committing
- Run `make lint` to check

### Swift (iOS)

- Follow Swift API Design Guidelines
- Use SwiftLint rules (if configured)

### Kotlin (Android)

- Follow Kotlin coding conventions
- Run `./gradlew ktlintCheck`

## Commit Messages

Use conventional commits:

```
type: short description

Longer description if needed.

🤖 Generated with [Claude Code](https://claude.com/claude-code)
```

Types:
- `feat` - New feature
- `fix` - Bug fix
- `docs` - Documentation
- `refactor` - Code refactoring
- `test` - Adding tests
- `chore` - Maintenance

## What Makes a Good Contribution

### High Value

- Fixes bugs that affect many users
- Improves onboarding experience
- Adds commonly-needed patterns
- Improves AI workflow (skills, commands, hooks)
- Better documentation

### Please Avoid

- Adding complexity without clear benefit
- Framework-specific patterns (keep it vanilla)
- Features that require extensive ongoing maintenance
- Changes that make it harder for beginners

## Claude Code Contributions

This project heavily uses Claude Code. Contributions to `.claude/` are especially welcome:

- **New commands** in `.claude/commands/`
- **New skills** in `.claude/skills/`
- **New rules** in `.claude/rules/`
- **Improved hooks** in `.claude/hooks/`

### Testing Claude Code Changes

1. Start a Claude Code session in the template
2. Test your command/skill/hook
3. Verify it works across scenarios
4. Document activation triggers

## Questions?

- Open an issue for bugs
- Start a discussion for ideas
- Check existing docs first

---

*Thank you for helping make production deployment accessible to more developers!*
