#!/bin/bash
# Smoke Test - Quick validation that services are running
# Usage: ./scripts/smoke-test.sh [backend|ios|android|all]

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

BACKEND_URL="${BACKEND_URL:-http://localhost:8080}"
TIMEOUT=5

print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ PASS${NC}: $2"
    else
        echo -e "${RED}✗ FAIL${NC}: $2"
        return 1
    fi
}

print_skip() {
    echo -e "${YELLOW}○ SKIP${NC}: $1"
}

# Backend smoke tests
test_backend() {
    echo ""
    echo "=== Backend Smoke Tests ==="

    local failed=0

    # Health check
    if curl -sf --max-time $TIMEOUT "$BACKEND_URL/health" > /dev/null 2>&1; then
        print_status 0 "Health endpoint responding"
    else
        print_status 1 "Health endpoint responding"
        failed=1
    fi

    # API health with version
    response=$(curl -sf --max-time $TIMEOUT "$BACKEND_URL/api/v1/health" 2>/dev/null || echo "")
    if echo "$response" | grep -q '"status":"ok"'; then
        print_status 0 "API v1 health returns status ok"
    else
        print_status 1 "API v1 health returns status ok"
        failed=1
    fi

    # Hello endpoint
    response=$(curl -sf --max-time $TIMEOUT "$BACKEND_URL/api/v1/hello?name=SmokeTest" 2>/dev/null || echo "")
    if echo "$response" | grep -q '"message":"Hello, SmokeTest!"'; then
        print_status 0 "Hello endpoint works with parameters"
    else
        print_status 1 "Hello endpoint works with parameters"
        failed=1
    fi

    # 404 handling
    status=$(curl -sf -o /dev/null -w "%{http_code}" --max-time $TIMEOUT "$BACKEND_URL/nonexistent" 2>/dev/null || echo "000")
    if [ "$status" = "404" ]; then
        print_status 0 "404 returned for unknown routes"
    else
        print_status 1 "404 returned for unknown routes (got $status)"
        failed=1
    fi

    return $failed
}

# iOS smoke tests (requires simulator running)
test_ios() {
    echo ""
    echo "=== iOS Smoke Tests ==="

    if ! command -v xcrun &> /dev/null; then
        print_skip "Xcode not available"
        return 0
    fi

    # Check if app bundle exists
    APP_PATH="mobile/ios/build/Debug-iphonesimulator/*.app"
    if ls $APP_PATH 1> /dev/null 2>&1; then
        print_status 0 "iOS app bundle exists"
    else
        print_skip "iOS app not built (run: cd mobile/ios && make build)"
        return 0
    fi

    # TODO: Add xcrun simctl tests when app is more mature
    print_skip "iOS simulator tests (not implemented yet)"
}

# Android smoke tests (requires emulator running)
test_android() {
    echo ""
    echo "=== Android Smoke Tests ==="

    if ! command -v adb &> /dev/null; then
        print_skip "Android SDK not available"
        return 0
    fi

    # Check if APK exists
    APK_PATH="mobile/android/app/build/outputs/apk/debug/app-debug.apk"
    if [ -f "$APK_PATH" ]; then
        print_status 0 "Android APK exists"
    else
        print_skip "Android APK not built (run: cd mobile/android && ./gradlew assembleDebug)"
        return 0
    fi

    # Check if emulator is running
    if adb devices | grep -q "emulator"; then
        print_status 0 "Android emulator running"
    else
        print_skip "Android emulator not running"
        return 0
    fi

    # TODO: Add adb tests when app is more mature
    print_skip "Android instrumentation tests (not implemented yet)"
}

# Main
main() {
    echo "╔══════════════════════════════════════════╗"
    echo "║         SMOKE TEST SUITE                 ║"
    echo "╚══════════════════════════════════════════╝"

    local target="${1:-all}"
    local exit_code=0

    case $target in
        backend)
            test_backend || exit_code=1
            ;;
        ios)
            test_ios || exit_code=1
            ;;
        android)
            test_android || exit_code=1
            ;;
        all)
            test_backend || exit_code=1
            test_ios || exit_code=1
            test_android || exit_code=1
            ;;
        *)
            echo "Usage: $0 [backend|ios|android|all]"
            exit 1
            ;;
    esac

    echo ""
    echo "════════════════════════════════════════════"
    if [ $exit_code -eq 0 ]; then
        echo -e "${GREEN}All smoke tests passed!${NC}"
    else
        echo -e "${RED}Some smoke tests failed!${NC}"
    fi

    exit $exit_code
}

main "$@"
