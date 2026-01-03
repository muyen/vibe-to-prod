# Android Makefile
# Consistent CLI commands for Android development

.PHONY: setup build build-release test lint clean help

# Build debug APK
build:
	./gradlew assembleDebug

# Build release APK
build-release:
	./gradlew assembleRelease

# Run unit tests
test:
	./gradlew testDebugUnitTest

# Run all tests including instrumented
test-all:
	./gradlew test connectedAndroidTest

# Run linter (ktlint)
lint:
	./gradlew ktlintCheck

# Fix lint issues
lint-fix:
	./gradlew ktlintFormat

# Static analysis (detekt)
analyze:
	./gradlew detekt

# Security scan (requires dependency-check plugin)
security-scan:
	./gradlew dependencyCheckAnalyze

# Clean build
clean:
	./gradlew clean
	rm -rf build/
	rm -rf app/build/

# Setup local properties
setup:
	@if [ ! -f local.properties ]; then \
		echo "sdk.dir=$(HOME)/Library/Android/sdk" > local.properties; \
		echo "Created local.properties"; \
	fi
	./gradlew dependencies

# Install debug APK on connected device
install:
	./gradlew installDebug

# Run on connected device
run: install
	adb shell am start -n com.example.app/.MainActivity

# Generate APK for testing
apk:
	./gradlew assembleDebug
	@echo "APK: app/build/outputs/apk/debug/app-debug.apk"

# === FASTLANE ===

# Run Fastlane tests
fastlane-test:
	bundle exec fastlane test

# Build and upload to internal testing
fastlane-internal:
	bundle exec fastlane internal

# Build and upload to beta
fastlane-beta:
	bundle exec fastlane beta

# Build and upload to production
fastlane-release:
	bundle exec fastlane release

# Setup Fastlane
fastlane-setup:
	@if [ ! -f "Gemfile" ]; then \
		bundle init && bundle add fastlane; \
		bundle exec fastlane init; \
	else \
		bundle install; \
	fi

# Help
help:
	@echo "Available targets:"
	@echo ""
	@echo "  SETUP:"
	@echo "    setup           - Create local.properties and sync"
	@echo ""
	@echo "  BUILD:"
	@echo "    build           - Build debug APK"
	@echo "    build-release   - Build release APK"
	@echo "    apk             - Build debug APK and show path"
	@echo ""
	@echo "  TEST:"
	@echo "    test            - Run unit tests"
	@echo "    test-all        - Run all tests including instrumented"
	@echo ""
	@echo "  LINT:"
	@echo "    lint            - Run ktlint"
	@echo "    lint-fix        - Auto-fix lint issues"
	@echo "    analyze         - Run detekt static analysis"
	@echo ""
	@echo "  SECURITY:"
	@echo "    security-scan   - Run dependency security check"
	@echo ""
	@echo "  FASTLANE:"
	@echo "    fastlane-setup  - Initialize Fastlane"
	@echo "    fastlane-test   - Run tests via Fastlane"
	@echo "    fastlane-internal - Upload to internal testing"
	@echo "    fastlane-beta   - Upload to beta track"
	@echo "    fastlane-release - Upload to production"
	@echo ""
	@echo "  DEVICE:"
	@echo "    install         - Install debug APK on device"
	@echo "    run             - Install and launch on device"
	@echo ""
	@echo "  CLEAN:"
	@echo "    clean           - Clean build artifacts"
