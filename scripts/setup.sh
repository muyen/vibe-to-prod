#!/bin/bash
# Vibe to Production - Quick Setup Script
# This script sets up your entire development environment

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}========================================${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}! $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

check_command() {
    if command -v "$1" &> /dev/null; then
        print_success "$1 is installed"
        return 0
    else
        print_error "$1 is not installed"
        return 1
    fi
}

# =============================================================================
# Welcome
# =============================================================================

print_header "Vibe to Production - Setup"
echo "This script will set up your entire development environment."
echo "You'll need:"
echo "  - A Google Cloud project (or we'll help you create one)"
echo "  - About 10 minutes"
echo ""

# =============================================================================
# Check Prerequisites
# =============================================================================

print_header "Checking Prerequisites"

MISSING_TOOLS=()

check_command "gcloud" || MISSING_TOOLS+=("gcloud")
check_command "pulumi" || MISSING_TOOLS+=("pulumi")
check_command "go" || MISSING_TOOLS+=("go")
check_command "node" || MISSING_TOOLS+=("node")

if [ ${#MISSING_TOOLS[@]} -gt 0 ]; then
    echo ""
    print_error "Missing tools: ${MISSING_TOOLS[*]}"
    echo ""
    echo "Install missing tools:"
    for tool in "${MISSING_TOOLS[@]}"; do
        case $tool in
            gcloud)
                echo "  gcloud: https://cloud.google.com/sdk/docs/install"
                ;;
            pulumi)
                echo "  pulumi: brew install pulumi"
                ;;
            go)
                echo "  go: brew install go"
                ;;
            node)
                echo "  node: brew install node"
                ;;
        esac
    done
    exit 1
fi

echo ""
print_success "All prerequisites installed!"

# =============================================================================
# Get Google Cloud Project
# =============================================================================

print_header "Google Cloud Configuration"

# Check if already logged in
if gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null | head -1 | grep -q "@"; then
    CURRENT_ACCOUNT=$(gcloud auth list --filter=status:ACTIVE --format="value(account)" 2>/dev/null | head -1)
    print_success "Logged in as: $CURRENT_ACCOUNT"
else
    echo "You need to log in to Google Cloud."
    echo "Running 'gcloud auth login'..."
    gcloud auth login
fi

# Get or create project
echo ""
echo "Google Cloud Project Options:"
echo "  1) Use existing project"
echo "  2) Create new project"
read -p "Choose (1 or 2): " PROJECT_CHOICE

if [ "$PROJECT_CHOICE" == "2" ]; then
    read -p "Enter new project ID (e.g., my-app-dev): " GCP_PROJECT_DEV
    echo "Creating project $GCP_PROJECT_DEV..."
    gcloud projects create "$GCP_PROJECT_DEV" --name="$GCP_PROJECT_DEV" || {
        print_warning "Project may already exist or creation failed. Continuing..."
    }
else
    echo ""
    echo "Your existing projects:"
    gcloud projects list --format="table(projectId,name)" 2>/dev/null | head -10
    echo ""
    read -p "Enter your development project ID: " GCP_PROJECT_DEV
fi

# Set as default project
gcloud config set project "$GCP_PROJECT_DEV"
print_success "Using project: $GCP_PROJECT_DEV"

# Ask about production project
echo ""
read -p "Do you have a separate production project? (y/n): " HAS_PROD
if [ "$HAS_PROD" == "y" ]; then
    read -p "Enter production project ID: " GCP_PROJECT_PROD
else
    GCP_PROJECT_PROD="$GCP_PROJECT_DEV"
    print_warning "Using same project for dev and prod (not recommended for production)"
fi

# =============================================================================
# Enable Google Cloud APIs
# =============================================================================

print_header "Enabling Google Cloud APIs"

APIS=(
    "run.googleapis.com"
    "artifactregistry.googleapis.com"
    "cloudbuild.googleapis.com"
    "firestore.googleapis.com"
    "secretmanager.googleapis.com"
    "firebase.googleapis.com"
)

for api in "${APIS[@]}"; do
    echo "Enabling $api..."
    gcloud services enable "$api" --project="$GCP_PROJECT_DEV" 2>/dev/null || true
done

print_success "APIs enabled!"

# =============================================================================
# Initialize Firebase
# =============================================================================

print_header "Firebase Setup"

if command -v firebase &> /dev/null; then
    print_success "Firebase CLI is installed"

    echo ""
    echo "To complete Firebase setup:"
    echo "  1. Go to https://console.firebase.google.com"
    echo "  2. Add Firebase to your project: $GCP_PROJECT_DEV"
    echo "  3. Enable Firestore in Native mode"
    echo "  4. Enable Authentication (Email/Password, Google, Apple)"
    echo ""
    read -p "Press Enter when Firebase is configured..."
else
    print_warning "Firebase CLI not installed. Install with: npm install -g firebase-tools"
    echo "You can set up Firebase manually later."
fi

# =============================================================================
# Configure Pulumi
# =============================================================================

print_header "Pulumi Infrastructure Setup"

cd "$(dirname "$0")/../infrastructure/pulumi" || exit 1

echo "Initializing Pulumi..."
pulumi login --local 2>/dev/null || true
go mod tidy

# Create stacks if they don't exist
pulumi stack init dev 2>/dev/null || true
pulumi stack init prod 2>/dev/null || true

# Configure stacks
pulumi config set gcp:project "$GCP_PROJECT_DEV" --stack dev
pulumi config set gcp:project "$GCP_PROJECT_PROD" --stack prod

print_success "Pulumi configured!"

echo ""
echo "Pulumi stacks created:"
echo "  - dev (project: $GCP_PROJECT_DEV)"
echo "  - prod (project: $GCP_PROJECT_PROD)"

# =============================================================================
# Backend Setup
# =============================================================================

print_header "Backend Setup"

cd "$(dirname "$0")/../backend" || exit 1

if [ -f "go.mod" ]; then
    echo "Installing Go dependencies..."
    go mod tidy
    print_success "Backend dependencies installed!"
fi

# =============================================================================
# Summary
# =============================================================================

print_header "Setup Complete!"

echo "Your development environment is ready."
echo ""
echo "Next steps:"
echo ""
echo "  1. Deploy infrastructure (dev):"
echo "     cd infrastructure/pulumi && make deploy-dev"
echo ""
echo "  2. Run backend locally:"
echo "     cd backend && make run"
echo ""
echo "  3. Open mobile apps:"
echo "     - iOS: Open mobile/ios in Xcode"
echo "     - Android: Open mobile/android in Android Studio"
echo ""
echo "  4. Read the docs:"
echo "     - docs/ARCHITECTURE.md - Why these technologies"
echo "     - docs/GETTING_STARTED.md - Development workflow"
echo ""
echo -e "${GREEN}Happy coding! ${NC}"
echo ""
