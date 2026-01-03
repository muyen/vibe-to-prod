---
description: Review and improve Claude Code configuration (CLAUDE.md, hooks, skills, rules)
model: sonnet
---

# Claude Code Configuration Improvement

Run periodic review and optimization of Claude Code configuration.

**Scope**: $ARGUMENTS

---

## 1. Research Phase

### Check Latest Best Practices

Search for the latest Claude Code best practices:
- CLAUDE.md organization and structure
- Hooks - types, use cases, best practices
- Skills vs Commands - when to use each
- Settings and permissions

**Use**: claude-code-guide agent or web search for "Claude Code CLI best practices 2025"

---

## 2. Audit Current Configuration

### File Structure Check

```bash
# List all Claude config files
find .claude -type f \( -name "*.md" -o -name "*.json" -o -name "*.sh" \) | sort

# Check file sizes
wc -l CLAUDE.md .claude/rules/*.md .claude/skills/**/SKILL.md 2>/dev/null
```

### Configuration Inventory

| Component | Location | Count |
|-----------|----------|-------|
| Main memory | `CLAUDE.md` | 1 |
| Rules | `.claude/rules/` | ? |
| Skills | `.claude/skills/` | ? |
| Commands | `.claude/commands/` | ? |
| Hooks | `.claude/hooks/` | ? |

### Check for Issues

1. **CLAUDE.md Size**: Should be < 150 lines
2. **Rules Have Paths**: All rules should have `paths:` frontmatter
3. **Skills Have Description**: Skills need clear `description:` for activation triggers
4. **Hooks Registered**: All hooks in `.claude/hooks/` should be in `settings.json`
5. **Settings Security**: Check deny rules for secrets
6. **Settings Schema**: Must use `"$schema": "https://json.schemastore.org/claude-code-settings.json"`

---

## 3. Identify Improvements

### Checklist

**Structure:**
- [ ] CLAUDE.md is focused (only cross-cutting rules)
- [ ] Platform rules are in `.claude/rules/` with path conditions
- [ ] No duplicate rules across files

**Security:**
- [ ] `settings.json` has deny rules for `.env`, secrets, keys
- [ ] Sandbox is enabled

**Efficiency:**
- [ ] Commands that should be proactive are converted to skills
- [ ] Hooks are fast (< 30s timeout)

**Team:**
- [ ] `settings.json` is committed (team-shared)
- [ ] `settings.local.json` is gitignored (personal)

---

## 4. Implement Changes

For each improvement identified:

1. **Plan**: Describe the change
2. **Impact**: What files are affected
3. **Implement**: Make the change
4. **Verify**: Check it works

---

## 5. Document Improvements

Update version in CLAUDE.md if maintaining versions:

```markdown
**Last Updated**: YYYY-MM-DD
**Version**: X.Y.Z - Brief description of changes
```

---

## Quick Reference

### Add New Rule File

```markdown
---
paths: path/to/code/**
description: Brief description
---

# Rule Title

## Critical Rules
| Rule | Why |
|------|-----|
```

### Add New Skill

```markdown
---
name: skill-name
description: When this skill should activate
---

# Skill Title

## When to Activate
[Trigger conditions]

## Process
[What the skill does]
```

### Add New Hook

1. Create script in `.claude/hooks/`
2. Register in `.claude/settings.json`
3. Test with a sample scenario

---

## Resources

- **Guide**: `.claude/CONFIGURATION_IMPROVEMENT_GUIDE.md`
- **Best practices**: https://www.anthropic.com/engineering/claude-code-best-practices
- **Official docs**: https://code.claude.com/docs/
