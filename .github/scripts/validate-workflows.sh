#!/bin/bash

# GitHub Actions Workflow Validation Script
# Validates workflows before deployment to avoid production issues

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WORKFLOWS_DIR="$(dirname "$SCRIPT_DIR")/workflows"

echo "Validating GitHub Actions workflows..."
echo "Workflows directory: $WORKFLOWS_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

ERRORS=0
WARNINGS=0

log_error() {
    echo -e "${RED}ERROR: $1${NC}"
    ((ERRORS++))
}

log_warning() {
    echo -e "${YELLOW}WARNING: $1${NC}"
    ((WARNINGS++))
}

log_success() {
    echo -e "${GREEN}OK: $1${NC}"
}

log_info() {
    echo -e "${BLUE}INFO: $1${NC}"
}

# 1. Validate YAML syntax
echo -e "\n${BLUE}Step 1: Validating YAML syntax...${NC}"
for file in "$WORKFLOWS_DIR"/*.yml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")
        if python3 -c "import yaml; yaml.safe_load(open('$file', 'r'))" 2>/dev/null; then
            log_success "YAML syntax valid: $filename"
        else
            log_error "YAML syntax invalid: $filename"
        fi
    fi
done

# 2. Check for required fields
echo -e "\n${BLUE}Step 2: Checking required workflow fields...${NC}"
for file in "$WORKFLOWS_DIR"/*.yml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")

        if grep -q "^name:" "$file"; then
            log_success "Has name field: $filename"
        else
            log_error "Missing name field: $filename"
        fi

        if grep -q "^on:" "$file"; then
            log_success "Has trigger field: $filename"
        else
            log_error "Missing trigger field: $filename"
        fi

        if grep -q "^jobs:" "$file"; then
            log_success "Has jobs field: $filename"
        else
            log_error "Missing jobs field: $filename"
        fi
    fi
done

# 3. Check for authentication setup (GCP deployments)
echo -e "\n${BLUE}Step 3: Checking authentication configuration...${NC}"
for file in "$WORKFLOWS_DIR"/*.yml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")

        if grep -q -E "(gcloud|docker push|Cloud Build)" "$file"; then
            if grep -q -E "(google-github-actions/setup-gcloud|google-github-actions/auth)" "$file"; then
                log_success "Has GCP authentication: $filename"
            else
                log_warning "Missing GCP authentication: $filename"
            fi
        fi
    fi
done

# 4. Check for hardcoded secrets
echo -e "\n${BLUE}Step 4: Validating secret handling...${NC}"
for file in "$WORKFLOWS_DIR"/*.yml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")

        if grep -q -E "(password|secret|key|token).*[:=].*['\"][^'\"]{8,}['\"]" "$file" && \
           ! grep -q -E "(default-|placeholder-|change-in-production|example-)" "$file"; then
            log_error "Potential hardcoded secret in: $filename"
        fi
    fi
done

# 5. Best practices
echo -e "\n${BLUE}Step 5: Best practices check...${NC}"
for file in "$WORKFLOWS_DIR"/*.yml; do
    if [ -f "$file" ]; then
        filename=$(basename "$file")

        if grep -q "timeout-minutes:" "$file"; then
            log_success "Has timeouts: $filename"
        else
            log_info "No timeouts set: $filename"
        fi
    fi
done

# Summary
echo -e "\n${BLUE}Validation Summary${NC}"
echo "======================="
echo "Files validated: $(find "$WORKFLOWS_DIR" -name "*.yml" 2>/dev/null | wc -l | tr -d ' ')"
echo -e "Errors: ${RED}$ERRORS${NC}"
echo -e "Warnings: ${YELLOW}$WARNINGS${NC}"

if [ $ERRORS -gt 0 ]; then
    echo -e "\n${RED}VALIDATION FAILED${NC}"
    exit 1
elif [ $WARNINGS -gt 0 ]; then
    echo -e "\n${YELLOW}VALIDATION PASSED WITH WARNINGS${NC}"
    exit 0
else
    echo -e "\n${GREEN}VALIDATION PASSED${NC}"
    exit 0
fi
