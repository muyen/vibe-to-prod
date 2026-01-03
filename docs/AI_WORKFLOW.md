# AI Workflow Guide

How to get the most out of AI-assisted development with this template.

---

## Claude Code Setup

This template is optimized for [Claude Code](https://claude.com/claude-code).

### Install

```bash
npm install -g @anthropic-ai/claude-code
claude login
```

### Start a Session

```bash
cd your-project
claude
```

---

## What's Included

### Commands (`.claude/commands/`)

| Command | Purpose |
|---------|---------|
| `/commit` | Create conventional commits |
| `/code-review` | Review code for issues |
| `/generate-tests` | Create test suite |
| `/refactor-code` | Safe refactoring |
| `/ultra-think` | Deep analysis mode |
| `/security-scan` | Security vulnerability check |
| `/improve-claude-config` | Audit and improve config |

### Skills (`.claude/skills/`)

Skills auto-activate based on context:

| Skill | Triggers When |
|-------|---------------|
| `systematic-debugging` | Bugs reported, errors seen, tests failing |
| `git-workflow` | Creating branches, preparing PRs |

### Hooks (`.claude/hooks/`)

| Hook | Purpose |
|------|---------|
| `protect-generated-files.sh` | Prevents editing generated files |
| `openapi-changed.sh` | Reminds to regenerate after API changes |

### Permissions (`.claude/settings.json`)

Protected by default:
- `.env` files (secrets)
- `*.pem`, `*.key` files (certificates)
- `secrets/` directories

---

## MCP Servers

MCP (Model Context Protocol) servers extend Claude's capabilities. This template includes some pre-configured, others you'll need to set up.

> **Need help setting up an MCP?** Just ask Claude:
> "Help me set up the GitHub MCP server"
> Claude will guide you through the process using the official documentation.

### What's Pre-Configured (`.mcp.json`)

These MCPs are included in the project and work after cloning:

| MCP | Status | What It Does |
|-----|--------|--------------|
| **memory** | Works immediately | Persistent knowledge across sessions |
| **context7** | Works immediately | Up-to-date library documentation |
| **github** | Needs token | Create PRs, issues, search code |
| **notion** | Needs token | Connect to Notion workspace |
| **pulumi** | Needs token | Infrastructure management |

### Setting Up MCPs That Need Tokens

#### Option 1: Set Environment Variables

The `.mcp.json` uses `${VAR}` syntax. Set these in your shell profile:

```bash
# Add to ~/.zshrc or ~/.bashrc
export GITHUB_PERSONAL_ACCESS_TOKEN="ghp_xxxx"  # From github.com/settings/tokens
export NOTION_API_KEY="secret_xxxx"              # From notion.so/my-integrations
export PULUMI_ACCESS_TOKEN="pul_xxxx"            # From app.pulumi.com/account/tokens
```

Then restart Claude Code.

#### Option 2: Ask Claude to Help

Just ask:
```
"Help me set up the GitHub MCP with a personal access token"
```

Claude will guide you through creating the token and configuring it.

### Linear MCP (Highly Recommended)

Linear uses **OAuth** (no API key needed) - just log in with your browser:

```bash
claude mcp add --transport sse linear https://mcp.linear.app/sse
```

This opens your browser to authorize. Once done, Linear MCP is ready.

**Why Linear is critical:**
- Track tasks across AI sessions
- Claude updates issue status as work progresses
- Next session picks up where you left off

### Quick Setup Commands

```bash
# Linear (OAuth - recommended)
claude mcp add --transport sse linear https://mcp.linear.app/sse

# Check what's configured
claude mcp list
```

### MCP Summary

| MCP | Best Setup Method | Required For |
|-----|------------------|--------------|
| **Linear** | `claude mcp add` (OAuth) | Multi-session task tracking |
| **GitHub** | Env var + `.mcp.json` | PR/issue management |
| **Memory** | Pre-configured | Persistent knowledge |
| **Context7** | Pre-configured | Library documentation |
| **Notion** | Env var + `.mcp.json` | Team documentation |
| **Pulumi** | Env var + `.mcp.json` | Infrastructure management |

---

## Why Linear MCP is Critical

When you work across multiple AI sessions:

**Without Linear:**
- Each session starts fresh
- Context is lost
- You repeat yourself
- Progress isn't tracked

**With Linear:**
- Create issues for tasks
- Claude updates issue status
- Next session picks up where you left off
- Full history of what was done

**Example workflow:**

```
Session 1:
You: "Add user authentication"
Claude: *creates Linear issue AUTH-1*
Claude: *implements half the feature*
Claude: *updates issue: "In Progress - JWT setup complete, need OAuth"*

Session 2:
You: "Continue working on auth"
Claude: *reads Linear issue AUTH-1*
Claude: "I see we completed JWT setup. Continuing with OAuth..."
```

---

## Best Practices

### 1. Use Commands for Repetitive Tasks

```
/commit              # Instead of manually writing commit messages
/code-review file.go # Before submitting PRs
/generate-tests      # After writing new code
```

### 2. Let Skills Activate

Don't fight the skills. When debugging:
- Describe the bug
- Let `systematic-debugging` skill guide the process
- Follow the 4-phase approach

### 3. Use Linear for Multi-Session Work

For anything that spans multiple sessions:

```
1. Create a Linear issue describing the task
2. Claude updates the issue as work progresses
3. Next session, Claude reads the issue for context
4. Close the issue when done
```

### 4. Trust the Hooks

The hooks prevent common mistakes:
- Editing generated files (regenerate instead)
- Forgetting to update clients after API changes

### 5. Connect Your MCPs

The more context Claude has, the better:
- GitHub: sees your codebase
- Linear: tracks your tasks
- Memory: remembers your decisions

---

## Troubleshooting

### "Command not found"

```bash
# Check commands exist
ls .claude/commands/

# Reload Claude
claude
```

### "Hook not running"

Check `.claude/settings.json` is valid JSON:

```bash
cat .claude/settings.json | jq .
```

### "MCP not connecting"

```bash
# Check MCP server runs manually
npx -y @modelcontextprotocol/server-github

# Check your tokens are set
echo $GITHUB_PERSONAL_ACCESS_TOKEN
```

---

## Adding Custom Commands

Create a new file in `.claude/commands/`:

```markdown
# .claude/commands/my-command.md

# My Custom Command

## Purpose
What this command does.

## Steps
1. First step
2. Second step

## Output
What to produce.
```

Then use: `/my-command`

---

## Adding Custom Skills

Create a new folder in `.claude/skills/`:

```markdown
# .claude/skills/my-skill/SKILL.md

# My Custom Skill

## Activation
When to activate this skill.

## Behavior
How to behave when active.

## Steps
1. First step
2. Second step
```

---

## Continuous Improvement (Built-In)

One of the most powerful patterns in this template: **every mistake becomes a lesson**.

### The Improvement Loop

```
┌────────────────────────────────────────────────────────────┐
│                    SDLC with Improvement                   │
├────────────────────────────────────────────────────────────┤
│                                                             │
│  Intake → Explore → Plan → Code → Test → Deploy → IMPROVE  │
│                                                    ↓        │
│                                           ┌────────────────┐│
│                                           │ What worked?   ││
│                                           │ What was hard? ││
│                                           │ What's missing?││
│                                           └────────┬───────┘│
│                                                    ↓        │
│           ┌──────────────────────────────────────────┐     │
│           │ Repeated mistake → Update .claude/rules/ │     │
│           │ Complex process → Create .claude/skills/ │     │
│           │ New pattern    → Store in Memory MCP     │     │
│           │ Missing tool   → Create Linear issue     │     │
│           └──────────────────────────────────────────┘     │
│                                                             │
└────────────────────────────────────────────────────────────┘
```

### How It Works

After completing a task, briefly reflect:

| Learning Type | Action |
|---------------|--------|
| Same mistake twice | Add rule to `.claude/rules/` |
| Manual process > 5 min | Create skill in `.claude/skills/` |
| New pattern discovered | Store in Memory MCP |
| Missing automation | Create issue to fix later |

### Example: Capturing a Learning

```
You made the same mistake twice (forgot to regenerate API client).

Instead of just fixing it again:
1. Add to .claude/rules/backend.md:
   "After editing openapi.yaml, ALWAYS run `make generate`"
2. Claude now reminds you automatically
```

### Memory MCP for Persistent Knowledge

```javascript
// When you learn something important
mcp__memory__create_entities({
  entities: [{
    name: "Learning_FirestoreTransactions",
    entityType: "development_learning",
    observations: [
      "Context: Was getting transaction errors",
      "Learning: Reads MUST come before writes in Firestore transactions",
      "Application: Always order tx.Get() before tx.Set()"
    ]
  }]
})
```

### `/improve-claude-config` Command

Periodically run this command to:
- Audit your Claude configuration
- Check for outdated rules
- Identify missing skills
- Ensure best practices

### Why This Matters

Traditional development: You make mistakes, fix them, move on.

AI-assisted development: You make mistakes, **Claude learns from them**, and helps you avoid them forever.

**The configuration improves over time.** After a few months:
- Rules catch common mistakes before they happen
- Skills automate repetitive processes
- Memory contains project-specific knowledge
- Hooks enforce quality gates

This is the difference between "using AI" and "building an AI-assisted workflow."

---

*AI-assisted development is a skill. These tools help you develop it.*
