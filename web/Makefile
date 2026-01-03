# =============================================================================
# Web Makefile - Firebase Hosting with Cloud Functions (Static + Dynamic)
# =============================================================================
#
# Architecture:
# - Static pages served from Firebase CDN
# - Dynamic routes (SSR) via Firebase Cloud Functions
# - Next.js standalone output for serverless deployment
#

# Project Configuration (customize these)
PROJECT_ID_DEV = your-project-dev
PROJECT_ID_PROD = your-project-prod

# Default target
.PHONY: help
help: ## Show available commands
	@echo "Web Commands"
	@echo "============"
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}'

# =============================================================================
# DEVELOPMENT
# =============================================================================

.PHONY: install dev build clean generate-api
install: ## Install dependencies
	npm ci

dev: ## Start development server (use 'make dev clean=true' to clear cache first)
ifeq ($(clean),true)
	@echo "Cleaning build cache..."
	@rm -rf .next
endif
	@echo "Starting development server..."
	@npm run dev

build: install ## Build for production
	npm run build

clean: ## Clean build artifacts
	rm -rf .next node_modules/.cache .firebase

generate-api: ## Generate TypeScript types from OpenAPI spec
	npm run generate:api

# =============================================================================
# QUALITY CHECKS
# =============================================================================

.PHONY: lint type-check test pre-deploy-check
lint: ## Run ESLint
	npm run lint

type-check: ## Run TypeScript type checking
	npm run type-check

test: ## Run unit tests
	npm test -- --run

pre-deploy-check: ## Run all pre-deployment checks
	@echo "Running pre-deployment checks..."
	@npm run lint
	@npm run type-check
	@npm test -- --run
	@echo "All pre-deployment checks passed!"

# =============================================================================
# DEPLOYMENT (Firebase Hosting + Cloud Functions)
# =============================================================================
#
# Firebase Web Frameworks automatically:
# 1. Builds Next.js with standalone output
# 2. Deploys static assets to Firebase Hosting CDN
# 3. Deploys SSR routes to Cloud Functions
#

.PHONY: deploy-dev deploy-prod deploy
deploy-dev: pre-deploy-check ## Deploy to development environment
	@echo "Firebase Hosting deployment to dev..."
	@echo "Project: $(PROJECT_ID_DEV)"
	@firebase experiments:enable webframeworks || true
	firebase deploy --project $(PROJECT_ID_DEV) --only hosting,functions
	@echo "Deployment complete!"

deploy-prod: pre-deploy-check ## Deploy to production environment
	@echo "Firebase Hosting deployment to prod..."
	@echo "Project: $(PROJECT_ID_PROD)"
	@firebase experiments:enable webframeworks || true
	firebase deploy --project $(PROJECT_ID_PROD) --only hosting,functions
	@echo "Deployment complete!"

deploy: deploy-dev ## Default deployment to dev environment

# =============================================================================
# UTILITIES
# =============================================================================

.PHONY: logs-dev logs-prod status
logs-dev: ## View development Cloud Function logs
	firebase functions:log --project $(PROJECT_ID_DEV)

logs-prod: ## View production Cloud Function logs
	firebase functions:log --project $(PROJECT_ID_PROD)

status: ## Show deployment status
	@echo "Development: https://$(PROJECT_ID_DEV).web.app"
	@echo "Production: https://$(PROJECT_ID_PROD).web.app"
	@echo "Firebase Console: https://console.firebase.google.com"
