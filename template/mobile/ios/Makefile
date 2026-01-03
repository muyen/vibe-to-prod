# iOS Makefile
# Uses XcodeGen for project generation

.PHONY: setup generate build clean

# Generate Xcode project from project.yml
generate:
	xcodegen generate

# Setup: generate project
setup: generate
	@echo "Project generated. Open App.xcodeproj in Xcode."

# Build for simulator
build:
	xcodebuild -project App.xcodeproj \
		-scheme App \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		build

# Clean build artifacts
clean:
	xcodebuild clean -project App.xcodeproj -scheme App
	rm -rf build/

# Open in Xcode
open:
	open App.xcodeproj

# Help
help:
	@echo "Available targets:"
	@echo "  setup    - Generate Xcode project"
	@echo "  generate - Regenerate project.yml -> .xcodeproj"
	@echo "  build    - Build for iOS Simulator"
	@echo "  clean    - Clean build artifacts"
	@echo "  open     - Open in Xcode"
