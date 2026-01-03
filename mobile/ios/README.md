# iOS App

Minimal SwiftUI app that connects to the Go backend.

## Prerequisites

- Xcode 15+
- XcodeGen (`brew install xcodegen`)

## Quick Start

```bash
# Generate Xcode project
make setup

# Open in Xcode
make open
```

Then run on simulator (Cmd+R).

## Project Structure

```
ios/
├── project.yml          # XcodeGen config (source of truth)
├── Config/
│   ├── Development.xcconfig
│   └── Production.xcconfig
├── App/
│   ├── App.swift        # Main entry
│   ├── ContentView.swift # UI + API call
│   └── Info.plist
├── Makefile
└── README.md
```

## Key Points

- **XcodeGen** generates `.xcodeproj` from `project.yml`
- **Never edit** `.xcodeproj` directly - it's generated
- **Config** via xcconfig files (API_BASE_URL, etc.)
- **iOS 16+** minimum, SwiftUI only

## API Connection

The app calls `http://localhost:8080/api/v1/hello`.

For production, update `API_BASE_URL` in `Config/Production.xcconfig`.

## Adding Features

1. Add new Swift files to `App/` directory
2. Run `make generate` to update project
3. Build and run
