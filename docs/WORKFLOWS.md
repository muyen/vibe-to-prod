# Development Workflows

How to use the AI-native development tools in this template.

---

## Claude Code Integration

This template is optimized for Claude Code, Anthropic's AI-powered CLI.

### Installation

```bash
npm install -g @anthropic-ai/claude-code
claude login
```

### Start a Session

```bash
cd your-project
claude
```

### Available Commands

| Command | Description |
|---------|-------------|
| `/commit` | Create conventional commits |
| `/code-review [file]` | Review code for issues |
| `/generate-tests [file]` | Create test suite |
| `/refactor-code [file]` | Safe refactoring |
| `/openspec:proposal` | Plan a significant change |
| `/openspec:apply` | Implement an approved change |
| `/openspec:archive` | Archive completed change |

### Example Session

```
> claude

You: Add a new endpoint to list users

Claude: I'll help you add a users endpoint. Let me:
1. Update the OpenAPI spec
2. Regenerate code
3. Implement the handler
...
```

---

## OpenSpec Workflow

For larger changes, use the OpenSpec framework:

1. **Propose**: `/openspec:proposal` - Create a change proposal
2. **Review**: Get approval on the approach
3. **Apply**: `/openspec:apply` - Implement the change
4. **Archive**: `/openspec:archive` - Archive when deployed

---

## Git Workflow

### Branch Naming

```
feature/add-user-auth
fix/login-redirect
chore/update-deps
docs/update-readme
```

### Commit Format

```
type: description

feat: add user authentication
fix: resolve login redirect issue
docs: update README
chore: update dependencies
```

---

## Testing

### Backend

```bash
cd backend
make test
```

### iOS

```bash
cd mobile/ios
make test
```

### Android

```bash
cd mobile/android
./gradlew test
```

---

## Claude Code Configuration

The template includes Claude configuration in `.claude/`:

```
.claude/
├── settings.json       # Hooks, permissions
├── commands/           # Custom slash commands
│   ├── commit.md
│   ├── code-review.md
│   ├── generate-tests.md
│   └── refactor-code.md
├── hooks/              # Automated checks
│   └── openapi-changed.sh
└── skills/             # Context-aware behaviors
    ├── systematic-debugging/
    └── git-workflow/
```

### Hooks

**PreToolUse**: Protects generated files like `*.xcodeproj/*`

**PostToolUse**: Reminds to regenerate code when OpenAPI spec changes

### Skills

**systematic-debugging**: Activates on bugs/errors - 4-phase debugging

**git-workflow**: Activates on branches/PRs - enforces conventions

---

## Best Practices

1. **Read before editing** - Always understand existing code first
2. **Use OpenSpec for big changes** - Plan before implementing
3. **Run tests before committing** - Catch issues early
4. **Keep commits atomic** - One change per commit
5. **Trust the hooks** - They prevent common mistakes

---

*AI-native development = faster shipping with fewer bugs.*
