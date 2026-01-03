---
paths: mobile/android/**
description: Rules for Android development with Kotlin and Jetpack Compose
---

# Android Rules (Kotlin + Compose)

These rules apply when working on Android code.

## Critical Rules

| Rule | Why | Example |
|------|-----|---------|
| **Use Jetpack Compose** | Modern, declarative UI | `@Composable` functions |
| **Verify build before commit** | Catch errors early | `./gradlew build` |
| **Use generated API client** | Type-safe, matches backend | Use generated models |
| **Handle configuration changes** | Compose handles most, verify complex cases | Test rotation |

## Project Structure

```
mobile/android/
├── app/
│   ├── build.gradle.kts          # App module config
│   └── src/
│       ├── main/
│       │   ├── kotlin/com/example/app/
│       │   │   ├── MainActivity.kt   # Entry point
│       │   │   └── ui/               # Compose screens
│       │   ├── res/                  # Resources
│       │   └── AndroidManifest.xml   # App manifest
│       ├── test/                     # Unit tests (JUnit)
│       │   └── kotlin/com/example/app/
│       └── androidTest/              # Instrumented tests
│           └── kotlin/com/example/app/
├── build.gradle.kts              # Root config
├── settings.gradle.kts           # Module settings
├── Makefile                      # Build commands
└── fastlane/                     # Play Store automation
```

## Common Workflows

### Making UI Changes

1. Edit Composable functions in `app/src/main/kotlin/`
2. Build: `./gradlew build` or Android Studio
3. Run on emulator/device
4. Commit changes

### Adding a New Screen

1. Create new Composable in `ui/` package
2. Add navigation to the screen
3. Build and test

### Updating API Client

1. Backend updates OpenAPI spec
2. Run `python scripts/openapi_workflow.py --full`
3. Update code to use new/changed types
4. Build and test

## Code Patterns

### Composable Structure

```kotlin
// Good - clear structure with state hoisting
@Composable
fun MyScreen(
    state: MyScreenState,
    onAction: (MyScreenAction) -> Unit
) {
    Column {
        // UI content
    }
}

// Preview
@Preview
@Composable
private fun MyScreenPreview() {
    MyScreen(
        state = MyScreenState(),
        onAction = {}
    )
}
```

### ViewModel Pattern

```kotlin
// Good - use ViewModel for state management
class MyViewModel : ViewModel() {
    private val _uiState = MutableStateFlow(MyUiState())
    val uiState: StateFlow<MyUiState> = _uiState.asStateFlow()

    fun onAction(action: MyAction) {
        when (action) {
            is MyAction.Load -> load()
        }
    }
}
```

### Coroutines

```kotlin
// Good - use viewModelScope
viewModelScope.launch {
    try {
        val result = repository.fetchData()
        _uiState.update { it.copy(data = result) }
    } catch (e: Exception) {
        _uiState.update { it.copy(error = e.message) }
    }
}
```

## Makefile Commands

| Command | Purpose |
|---------|---------|
| `make build` | Build debug APK |
| `make build-release` | Build release APK |
| `make test` | Run unit tests |
| `make lint` | Run ktlint |
| `make lint-fix` | Auto-fix lint issues |
| `make install` | Install on connected device |
| `make fastlane-beta` | Upload to Play Store beta |

## Gradle Notes

- **Add dependencies**: Edit `app/build.gradle.kts`
- **Update SDK versions**: Edit `build.gradle.kts`
- **Sync after changes**: Android Studio or `./gradlew --refresh-dependencies`

## Quality Checklist

Before committing Android changes:

- [ ] Build succeeds: `./gradlew build`
- [ ] Tests pass: `./gradlew test`
- [ ] Lint passes: `./gradlew ktlintCheck`
- [ ] UI tested on multiple screen sizes
- [ ] No hardcoded strings (use `strings.xml`)
- [ ] ProGuard rules updated if using reflection
- [ ] Memory leaks checked
- [ ] Configuration changes handled (rotation)
