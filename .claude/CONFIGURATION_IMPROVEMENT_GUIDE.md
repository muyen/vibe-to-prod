# Claude Code Configuration Improvement Guide

**Purpose**: Regular review and optimization of Claude Code configuration.

**Schedule**: Run `/improve-claude-config` monthly or after major project changes.

---

## Quick Start

```bash
# Run the improvement process
/improve-claude-config

# Or specify scope
/improve-claude-config hooks
/improve-claude-config rules
/improve-claude-config full
```

---

## Configuration Architecture

### File Hierarchy (Precedence: Highest → Lowest)

```
1. Enterprise managed settings (system-level)
2. Command-line arguments
3. .claude/settings.local.json (personal project overrides)
4. .claude/settings.json (team-shared, in git)
5. ~/.claude/settings.json (personal, all projects)
```

### Directory Structure

```
.claude/
├── settings.json              # Team-shared settings (hooks, permissions)
├── settings.local.json        # Personal overrides (gitignored)
├── rules/                     # Path-conditional rules
│   ├── backend.md            # paths: backend/**
│   ├── ios.md                # paths: mobile/ios/**
│   ├── android.md            # paths: mobile/android/**
│   └── testing.md            # paths: **/*test*
├── skills/                    # Model-invoked (Claude decides)
│   ├── continuous-improvement/SKILL.md
│   ├── git-workflow/SKILL.md
│   └── systematic-debugging/SKILL.md
├── commands/                  # User-invoked (/command)
│   ├── commit.md
│   ├── code-review.md
│   ├── ultra-think.md
│   └── ...
└── hooks/                     # Hook scripts
    ├── session-start.sh
    ├── session-end.sh
    ├── protect-generated-files.sh
    └── openapi-changed.sh
```

---

## Component Best Practices

### 1. CLAUDE.md (Main Memory)

**Goals**:
- Keep under 150 lines
- Only cross-cutting rules
- Link to detailed guides

**Structure**:
```markdown
# Project Name

## Core Principles
[3-5 fundamental principles]

## Before ANY Code Change
[Quick checklist]

## Critical Rules (All Platforms)
[Only rules that apply everywhere]

## Platform Rules (Auto-loaded)
[Table pointing to .claude/rules/]

## Common Workflows
[Most frequent workflows]

## Slash Commands
[Quick reference]

## Configuration
[File locations]
```

### 2. Rules (`.claude/rules/`)

**When to create**:
- Platform-specific rules (backend, iOS, Android)
- Feature-specific rules (social features, payments)
- Domain-specific rules (security, performance)

**Format**:
```yaml
---
paths: path/pattern/**
description: Brief description of when these rules apply
---

# Rule Category

## Critical Rules (Must Follow)
| Rule | Why | Example |

## Workflow
...

## Quality Checklist
- [ ] ...
```

**Path patterns**:
- `backend/**` - All backend code
- `mobile/ios/**` - iOS code only
- `**/test/**` - Test files anywhere
- Multiple: Use YAML list format

### 3. Skills (`.claude/skills/`)

**When to use Skills** (model-invoked):
- Should trigger automatically based on context
- Examples: code-review, security-scan, continuous-improvement

**When to use Commands** (user-invoked):
- User explicitly requests action
- Examples: /commit, /deploy, /ultra-think

**Skill format**:
```yaml
---
name: skill-name
description: Clear description of when to activate
# allowed-tools: Read, Grep, Glob  # Optional - only if restricting to read-only
# model: haiku                      # Optional - for simpler skills
---

# Skill Title

## When to Activate
[Trigger conditions]

## Process
[What the skill does]

## Output Format
[Expected output structure]
```

### 4. Hooks (`.claude/hooks/`)

**Available Events**:
| Event | When | Blocking? |
|-------|------|-----------|
| SessionStart | Session begins | No |
| SessionEnd | Session ends | No |
| PreToolUse | Before tool execution | Yes (exit 2) |
| PostToolUse | After tool execution | No |

**Best Practices**:
- Keep hooks fast (< 30s)
- Use exit code 2 to block in PreToolUse
- Output goes to Claude's context
- Always register in `settings.json`

### 5. Settings (`.claude/settings.json`)

**Required sections**:
```json
{
  "$schema": "https://json.schemastore.org/claude-code-settings.json",
  "permissions": {
    "deny": [
      "Read(.env)",
      "Read(.env.*)",
      "Read(**/secrets/**)"
    ]
  },
  "hooks": { ... },
  "env": {
    "CLAUDE_BASH_MAINTAIN_PROJECT_WORKING_DIR": "1"
  },
  "sandbox": {
    "enabled": true,
    "excludedCommands": ["docker", "git push"]
  }
}
```

**Important**: The `$schema` URL must be exactly `https://json.schemastore.org/claude-code-settings.json`

---

## Improvement Checklist

### Monthly Review

**Structure**:
- [ ] CLAUDE.md under 150 lines
- [ ] No duplicate rules across files
- [ ] All rules have path conditions
- [ ] Unused files removed

**Security**:
- [ ] Deny rules cover all secrets
- [ ] Sandbox enabled
- [ ] Hooks don't expose secrets

**Efficiency**:
- [ ] Large content linked, not embedded
- [ ] Hooks are fast
- [ ] Haiku used for simple skills

**Team**:
- [ ] settings.json committed
- [ ] settings.local.json gitignored
- [ ] All team members can use config

### After Major Changes

- [ ] New platform? Add rule file
- [ ] New workflow? Add command or skill
- [ ] New automation? Add hook
- [ ] Breaking change? Update version

---

## Troubleshooting

### Rules Not Loading
1. Check `paths:` frontmatter syntax
2. Verify file is in `.claude/rules/`
3. Check for YAML syntax errors

### Hooks Not Running
1. Verify registered in `settings.json`
2. Check script is executable: `chmod +x script.sh`
3. Test manually: `bash .claude/hooks/script.sh`

### Skills Not Activating
1. Check `description:` is clear and specific
2. Verify skill is in `.claude/skills/{name}/SKILL.md`
3. Check for naming conflicts with commands

### Settings Not Applied
1. Check JSON syntax (use `jq . .claude/settings.json`)
2. Verify `$schema` is correct
3. Verify precedence (local > team > user)
4. Restart Claude Code session

---

## Version Control

### What to Commit
```
.claude/
├── settings.json ✓
├── rules/ ✓
├── skills/ ✓
├── commands/ ✓
├── hooks/ ✓
└── CONFIGURATION_IMPROVEMENT_GUIDE.md ✓
```

### What to Gitignore
```
.claude/settings.local.json
CLAUDE.local.md
.claude/*.backup-*
```

---

## Resources

- **Official Docs**: https://code.claude.com/docs/
- **Best Practices**: https://www.anthropic.com/engineering/claude-code-best-practices

---

**Last Updated**: 2026-01-02
**Guide Version**: 1.0.0 - Initial setup
