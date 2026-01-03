# iOS Makefile
# Consistent CLI commands for iOS development

.PHONY: setup generate build build-release test lint clean open help

# === SETUP ===

# Generate Xcode project from project.yml
generate:
	xcodegen generate

# Full setup
setup: generate
	@echo "Project generated. Run 'make open' to open in Xcode."

# Open in Xcode
open:
	open App.xcodeproj

# === BUILD ===

# Build for simulator
build:
	xcodebuild -project App.xcodeproj \
		-scheme App \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		-configuration Debug \
		build

# Build for release
build-release:
	xcodebuild -project App.xcodeproj \
		-scheme App \
		-configuration Release \
		-archivePath build/App.xcarchive \
		archive

# === TEST ===

# Run unit tests
test:
	xcodebuild test \
		-project App.xcodeproj \
		-scheme App \
		-destination 'platform=iOS Simulator,name=iPhone 15' \
		-enableCodeCoverage YES

# === LINT ===

# Run SwiftLint (requires: brew install swiftlint)
lint:
	swiftlint lint --strict

# Auto-fix lint issues
lint-fix:
	swiftlint lint --fix

# Run SwiftFormat (requires: brew install swiftformat)
format:
	swiftformat .

# === SECURITY ===

# Security scan with swift-security (if available)
security-scan:
	@echo "Running security checks..."
	@if command -v swift-security &> /dev/null; then \
		swift-security scan .; \
	else \
		echo "swift-security not installed. Run: brew install swift-security"; \
	fi

# === FASTLANE ===

# Run Fastlane tests
fastlane-test:
	cd fastlane && bundle exec fastlane test

# Build and upload to TestFlight
fastlane-beta:
	cd fastlane && bundle exec fastlane beta

# Build and upload to App Store
fastlane-release:
	cd fastlane && bundle exec fastlane release

# Setup Fastlane
fastlane-setup:
	@if [ ! -d "fastlane" ]; then \
		bundle init && bundle add fastlane; \
		bundle exec fastlane init; \
	else \
		echo "Fastlane already configured"; \
	fi

# === CLEAN ===

clean:
	xcodebuild clean -project App.xcodeproj -scheme App 2>/dev/null || true
	rm -rf build/
	rm -rf ~/Library/Developer/Xcode/DerivedData/App-*

# === HELP ===

help:
	@echo "Available targets:"
	@echo ""
	@echo "  SETUP:"
	@echo "    setup           - Generate Xcode project"
	@echo "    generate        - Regenerate project.yml -> .xcodeproj"
	@echo "    open            - Open in Xcode"
	@echo ""
	@echo "  BUILD:"
	@echo "    build           - Build for iOS Simulator"
	@echo "    build-release   - Build release archive"
	@echo ""
	@echo "  TEST:"
	@echo "    test            - Run unit tests"
	@echo ""
	@echo "  LINT:"
	@echo "    lint            - Run SwiftLint"
	@echo "    lint-fix        - Auto-fix lint issues"
	@echo "    format          - Run SwiftFormat"
	@echo ""
	@echo "  SECURITY:"
	@echo "    security-scan   - Run security analysis"
	@echo ""
	@echo "  FASTLANE:"
	@echo "    fastlane-setup  - Initialize Fastlane"
	@echo "    fastlane-test   - Run tests via Fastlane"
	@echo "    fastlane-beta   - Upload to TestFlight"
	@echo "    fastlane-release - Upload to App Store"
	@echo ""
	@echo "  CLEAN:"
	@echo "    clean           - Clean build artifacts"
