---
paths: mobile/ios/**
description: Rules for iOS development with Swift and SwiftUI
---

# iOS Rules (Swift + SwiftUI)

These rules apply when working on iOS code.

## Critical Rules

| Rule | Why | Example |
|------|-----|---------|
| **Use XcodeGen** | `project.yml` is source of truth | Never commit `.xcodeproj` changes |
| **Verify build before commit** | Catch errors early | `make build` or Xcode build |
| **Use generated API client** | Type-safe, matches backend | Use generated models |
| **Test on simulator** | Catch UI issues | Run on multiple device sizes |

## Project Structure

```
mobile/ios/
├── project.yml           # XcodeGen config (SOURCE OF TRUTH)
├── App/
│   ├── App.swift         # App entry point
│   ├── ContentView.swift # Main view
│   └── Info.plist        # App configuration
├── Generated/            # Generated API client (DO NOT EDIT)
├── Makefile              # Build commands
└── fastlane/             # App Store automation
```

## Common Workflows

### Making UI Changes

1. Edit SwiftUI views in `App/`
2. Build and run in Xcode or `make build`
3. Test on simulator
4. Commit changes

### Adding a New Screen

1. Create new SwiftUI view file in `App/`
2. Add navigation to the screen
3. If new files: regenerate Xcode project with `xcodegen generate`
4. Build and test

### Updating API Client

1. Backend updates OpenAPI spec
2. Run `python scripts/openapi_workflow.py --full`
3. Update code to use new/changed types
4. Build and test

## Code Patterns

### View Structure

```swift
// Good - clear structure
struct MyView: View {
    // State
    @State private var isLoading = false

    var body: some View {
        content
    }

    // Computed properties
    private var content: some View {
        // ...
    }
}
```

### Async/Await

```swift
// Good - use Task and proper error handling
Task {
    do {
        let result = try await api.fetchData()
        await MainActor.run {
            self.data = result
        }
    } catch {
        await MainActor.run {
            self.errorMessage = error.localizedDescription
        }
    }
}
```

### Environment Usage

```swift
// Good - use environment for shared state
@Environment(\.dismiss) private var dismiss
@EnvironmentObject private var appState: AppState
```

## Makefile Commands

| Command | Purpose |
|---------|---------|
| `make build` | Build for simulator |
| `make test` | Run unit tests |
| `make generate` | Regenerate Xcode project |
| `make clean` | Clean build artifacts |
| `make fastlane-beta` | Upload to TestFlight |

## XcodeGen Notes

- **Add new files**: They're auto-discovered, just regenerate project
- **Add dependencies**: Edit `project.yml`, regenerate
- **Change settings**: Edit `project.yml`, regenerate

```bash
# Regenerate after structural changes
cd mobile/ios
xcodegen generate
open App.xcodeproj
```

## Quality Checklist

Before committing iOS changes:

- [ ] Build succeeds: `make build` or Xcode
- [ ] Tests pass: `make test`
- [ ] UI tested on multiple screen sizes
- [ ] No hardcoded strings (use Localizable.strings)
- [ ] Accessibility labels added where appropriate
- [ ] Memory leaks checked (no retain cycles)
- [ ] `project.yml` updated if structure changed
