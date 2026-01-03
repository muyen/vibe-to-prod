# From Vibe to Production - Root Makefile
# ==========================================
# Unified CLI interface for AI and human developers.
# Each component has its own Makefile with detailed targets.
#
# Quick Start:
#   make setup      - Full project setup
#   make verify-all - Generate + Build + Test all platforms
#   make help       - Show all available targets

.PHONY: help setup build test lint security clean

.DEFAULT_GOAL := help

# Component directories
BACKEND_DIR := backend
IOS_DIR := mobile/ios
ANDROID_DIR := mobile/android
INFRA_DIR := infrastructure/pulumi

# ==============================================================================
# HELP
# ==============================================================================

help: ## Show this help message
	@echo "From Vibe to Production"
	@echo "======================="
	@echo ""
	@echo "UNIFIED TARGETS (Cross-Platform):"
	@echo "  verify-all     - Full verification (generate + build + test) all platforms"
	@echo "  build-all      - Build all platforms (backend, iOS, Android)"
	@echo "  test-all       - Run tests across all platforms"
	@echo "  lint-all       - Run linters across all platforms"
	@echo "  security-all   - Run security scans across all platforms"
	@echo ""
	@echo "MAIN TARGETS:"
	@echo "  setup          - Full project setup (run ./scripts/setup.sh)"
	@echo "  build          - Build backend"
	@echo "  test           - Run backend tests"
	@echo "  clean          - Clean all build artifacts"
	@echo ""
	@echo "COMPONENT-SPECIFIC:"
	@echo "  backend-help   - Show backend-specific targets"
	@echo "  ios-help       - Show iOS-specific targets"
	@echo "  android-help   - Show Android-specific targets"
	@echo "  infra-help     - Show infrastructure-specific targets"
	@echo ""
	@echo "INFRASTRUCTURE:"
	@echo "  infra-deploy-dev   - Deploy to development environment"
	@echo "  infra-deploy-prod  - Deploy to production environment"
	@echo ""
	@echo "API GENERATION:"
	@echo "  api-generate   - Generate code from OpenAPI spec"
	@echo "  api-validate   - Validate OpenAPI spec"
	@echo ""
	@echo "EXAMPLES:"
	@echo "  make backend-run       # Run backend locally"
	@echo "  make ios-build         # Build iOS app"
	@echo "  make android-test      # Run Android tests"
	@echo "  make infra-deploy-dev  # Deploy to dev"
	@echo ""
	@echo "For component-specific operations:"
	@echo "  make backend-help      # Backend development targets"
	@echo "  make ios-help          # iOS development targets"
	@echo "  make android-help      # Android development targets"
	@echo "  make infra-help        # Infrastructure targets"

# ==============================================================================
# SETUP
# ==============================================================================

setup: ## Full project setup
	@echo "Running setup script..."
	./scripts/setup.sh

setup-backend: ## Setup backend dependencies
	cd $(BACKEND_DIR) && make deps

setup-ios: ## Setup iOS project
	cd $(IOS_DIR) && make setup

setup-android: ## Setup Android project
	cd $(ANDROID_DIR) && make setup

setup-infra: ## Setup Pulumi infrastructure
	cd $(INFRA_DIR) && make setup

# ==============================================================================
# UNIFIED CROSS-PLATFORM TARGETS
# ==============================================================================

verify-all: ## Full cross-platform verification (generate + build + test)
	@echo "Full cross-platform verification starting..."
	@echo "This will: generate code → build → test for all platforms"
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  PHASE 1: API CODE GENERATION"
	@echo "═══════════════════════════════════════════════════════════"
	@$(MAKE) api-generate
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  PHASE 2: BUILD ALL PLATFORMS"
	@echo "═══════════════════════════════════════════════════════════"
	@$(MAKE) build-all
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  PHASE 3: TEST ALL PLATFORMS"
	@echo "═══════════════════════════════════════════════════════════"
	@$(MAKE) test-all
	@echo ""
	@echo "═══════════════════════════════════════════════════════════"
	@echo "  FULL VERIFICATION COMPLETE!"
	@echo "═══════════════════════════════════════════════════════════"
	@echo ""
	@echo "All platforms verified:"
	@echo "  Backend (Go)"
	@echo "  iOS (Swift)"
	@echo "  Android (Kotlin)"

build-all: backend-build ios-build android-build ## Build all platforms
	@echo "All platforms built."

test-all: backend-test ios-test android-test ## Run tests across all platforms
	@echo "All tests complete."

lint-all: backend-lint ios-lint android-lint ## Run linters across all platforms
	@echo "All linting complete."

security-all: backend-security ios-security android-security ## Run security scans
	@echo "All security scans complete."

# ==============================================================================
# BACKEND TARGETS
# ==============================================================================

backend-help: ## Show backend-specific targets
	cd $(BACKEND_DIR) && make help

backend-run: ## Run backend locally
	cd $(BACKEND_DIR) && make run

backend-dev: ## Run backend with hot reload
	cd $(BACKEND_DIR) && make dev

backend-build: ## Build backend
	cd $(BACKEND_DIR) && make build

backend-test: ## Run backend tests
	cd $(BACKEND_DIR) && make test

backend-lint: ## Run backend linter
	cd $(BACKEND_DIR) && make lint

backend-security: ## Run backend security scan
	cd $(BACKEND_DIR) && make security

backend-docker: ## Build backend Docker image
	cd $(BACKEND_DIR) && make docker-build

# ==============================================================================
# iOS TARGETS
# ==============================================================================

ios-help: ## Show iOS-specific targets
	cd $(IOS_DIR) && make help

ios-setup: ## Setup iOS project
	cd $(IOS_DIR) && make setup

ios-build: ## Build iOS app
	cd $(IOS_DIR) && make build

ios-test: ## Run iOS tests
	cd $(IOS_DIR) && make test

ios-lint: ## Run iOS linter
	cd $(IOS_DIR) && make lint

ios-security: ## Run iOS security scan
	cd $(IOS_DIR) && make security-scan

ios-open: ## Open Xcode
	cd $(IOS_DIR) && make open

# ==============================================================================
# ANDROID TARGETS
# ==============================================================================

android-help: ## Show Android-specific targets
	cd $(ANDROID_DIR) && make help

android-setup: ## Setup Android project
	cd $(ANDROID_DIR) && make setup

android-build: ## Build Android app
	cd $(ANDROID_DIR) && make build

android-test: ## Run Android tests
	cd $(ANDROID_DIR) && make test

android-lint: ## Run Android linter
	cd $(ANDROID_DIR) && make lint

android-security: ## Run Android security scan
	cd $(ANDROID_DIR) && make security-scan

android-install: ## Install APK on device
	cd $(ANDROID_DIR) && make install

# ==============================================================================
# INFRASTRUCTURE TARGETS
# ==============================================================================

infra-help: ## Show infrastructure targets
	cd $(INFRA_DIR) && make help

infra-preview-dev: ## Preview dev infrastructure changes
	cd $(INFRA_DIR) && make preview-dev

infra-deploy-dev: ## Deploy to development
	cd $(INFRA_DIR) && make deploy-dev

infra-preview-prod: ## Preview prod infrastructure changes
	cd $(INFRA_DIR) && make preview-prod

infra-deploy-prod: ## Deploy to production (requires confirmation)
	cd $(INFRA_DIR) && make deploy-prod

infra-outputs-dev: ## Show dev stack outputs
	cd $(INFRA_DIR) && make outputs-dev

infra-outputs-prod: ## Show prod stack outputs
	cd $(INFRA_DIR) && make outputs-prod

# ==============================================================================
# API GENERATION
# ==============================================================================

api-generate: ## Generate code from OpenAPI spec for all platforms
	@echo "Generating API code for all platforms..."
	python scripts/openapi_workflow.py --full

api-validate: ## Validate OpenAPI spec
	python scripts/openapi_workflow.py --validate

api-backend: ## Generate backend code only
	python scripts/openapi_workflow.py --codegen --skip-ios --skip-android

# ==============================================================================
# DOCKER
# ==============================================================================

docker-build: ## Build Docker image
	cd $(BACKEND_DIR) && make docker-build

docker-run: ## Run Docker container
	cd $(BACKEND_DIR) && make docker-run

# ==============================================================================
# HEALTH & UTILITIES
# ==============================================================================

health: ## Check backend health endpoint
	cd $(BACKEND_DIR) && make health

clean: backend-clean ios-clean android-clean ## Clean all build artifacts
	@echo "All clean."

backend-clean:
	cd $(BACKEND_DIR) && make clean

ios-clean:
	cd $(IOS_DIR) && make clean

android-clean:
	cd $(ANDROID_DIR) && make clean
