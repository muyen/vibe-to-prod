.PHONY: help setup preview-dev deploy-dev preview-prod deploy-prod destroy-dev destroy-prod

help:
	@echo "Infrastructure Management"
	@echo ""
	@echo "  SETUP:"
	@echo "  make setup              - Initialize Pulumi and create stacks"
	@echo ""
	@echo "  DEVELOPMENT:"
	@echo "  make preview-dev        - Preview dev infrastructure changes"
	@echo "  make deploy-dev         - Deploy to development"
	@echo "  make destroy-dev        - Destroy development infrastructure"
	@echo ""
	@echo "  PRODUCTION:"
	@echo "  make preview-prod       - Preview prod infrastructure changes"
	@echo "  make deploy-prod        - Deploy to production"
	@echo "  make destroy-prod       - Destroy production infrastructure"
	@echo ""
	@echo "  UTILITIES:"
	@echo "  make outputs-dev        - Show dev stack outputs"
	@echo "  make outputs-prod       - Show prod stack outputs"
	@echo "  make refresh-dev        - Refresh dev stack state"
	@echo "  make refresh-prod       - Refresh prod stack state"

# Initial setup
setup:
	@echo "🚀 Setting up Pulumi infrastructure..."
	@echo ""
	pulumi login --local
	go mod tidy
	@echo ""
	@echo "Creating development stack..."
	pulumi stack init dev || true
	@echo ""
	@echo "Creating production stack..."
	pulumi stack init prod || true
	@echo ""
	@echo "✅ Setup complete!"
	@echo ""
	@echo "Next steps:"
	@echo "  1. Configure dev project:  pulumi config set gcp:project YOUR_DEV_PROJECT --stack dev"
	@echo "  2. Configure prod project: pulumi config set gcp:project YOUR_PROD_PROJECT --stack prod"
	@echo "  3. Deploy dev:             make deploy-dev"

# Development
preview-dev:
	pulumi preview --stack dev

deploy-dev:
	pulumi up --stack dev --yes

destroy-dev:
	pulumi destroy --stack dev

refresh-dev:
	pulumi refresh --stack dev --yes

outputs-dev:
	@pulumi stack output --stack dev

# Production
preview-prod:
	pulumi preview --stack prod

deploy-prod:
	@echo "⚠️  WARNING: Deploying to PRODUCTION"
	@echo "Press Ctrl+C within 5 seconds to cancel..."
	@sleep 5
	pulumi up --stack prod --yes

destroy-prod:
	@echo "🚨 DANGER: This will destroy PRODUCTION infrastructure!"
	@echo "Type 'yes-destroy-production' to confirm:"
	@read confirm && [ "$$confirm" = "yes-destroy-production" ] || exit 1
	pulumi destroy --stack prod

refresh-prod:
	pulumi refresh --stack prod --yes

outputs-prod:
	@pulumi stack output --stack prod

# Utility
cancel:
	pulumi cancel --yes

check:
	@echo "Checking dependencies..."
	@pulumi version
	@go version
	@gcloud version | head -1
	@echo "✅ All checks passed!"
