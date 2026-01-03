---
name: extract-from-proofmi
description: Extract and adapt reusable infrastructure from the proofmi repository
---

# Extract from Proofmi Skill

Helps extract and adapt reusable code, configuration, and patterns from the proofmi repository to the vibe-to-prod template.

## When to Activate

This skill activates when:
- User asks to extract/copy something from proofmi
- User wants to adapt proofmi code for the template
- Working on the template/ directory structure

## Source Repository

Location: `/Users/arsenelee/github/proofmi`

## Extraction Guidelines

### What to Extract (KEEP)

| Category | Path | Notes |
|----------|------|-------|
| Claude Config | `.claude/settings.json` | Adapt hooks |
| Claude Commands | `.claude/commands/*.md` | Remove proofmi-specific |
| Claude Skills | `.claude/skills/` | Keep generic ones |
| OpenSpec | `openspec/` | Keep framework, clear content |
| CI/CD | `.github/workflows/` | Simplify for hello-world |
| Dockerfile | `backend/services/core/Dockerfile` | Keep pattern |
| Makefiles | Various | Keep structure |

### What to Remove (REPLACE)

| Category | Notes |
|----------|-------|
| Business Logic | All domain code |
| Proofmi Naming | Replace with generic names |
| Firestore Rules | Replace with minimal |
| Social Features | Remove entirely |
| Cloud Functions | Remove (complex) |

### Adaptation Process

1. **Copy**: Get the source file
2. **Analyze**: Identify proofmi-specific parts
3. **Adapt**: Replace with generic equivalents
4. **Simplify**: Remove complexity not needed for hello-world
5. **Document**: Add comments explaining the pattern

## Output Locations

Extracted files go to `/Users/arsenelee/github/vibe-to-prod/template/`:

```
template/
├── backend/           # Go API
├── mobile/
│   ├── ios/          # Swift/SwiftUI
│   └── android/      # Kotlin/Compose
├── .claude/          # Claude Code config
├── .github/          # CI/CD
├── openspec/         # Change framework
└── README.md
```
