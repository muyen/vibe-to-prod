# Android App

Minimal Jetpack Compose app that connects to the Go backend.

## Prerequisites

- Android Studio Hedgehog+
- JDK 17

## Quick Start

```bash
# Build debug APK
./gradlew assembleDebug

# Install on connected device/emulator
./gradlew installDebug
```

Or open in Android Studio and run.

## Project Structure

```
android/
├── settings.gradle.kts
├── build.gradle.kts
└── app/
    ├── build.gradle.kts
    └── src/main/
        ├── AndroidManifest.xml
        ├── kotlin/com/example/app/
        │   └── MainActivity.kt    # UI + API call
        └── res/values/
            ├── strings.xml
            └── themes.xml
```

## API Connection

The app calls `http://10.0.2.2:8080/api/v1/hello`.

Note: `10.0.2.2` is the Android emulator's alias for `localhost`.

For production, update `BASE_URL` in `MainActivity.kt`.

## Key Points

- **Jetpack Compose** for UI
- **Retrofit** for networking
- **Coroutines** for async
- **Single Activity** architecture
- **No Hilt** - simplified for template (add if needed)

## Adding Features

1. Add new Composables to `app/src/main/kotlin/`
2. Create ViewModels for complex state
3. Add Hilt for dependency injection when scaling
