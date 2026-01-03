#!/bin/bash
# Toggle GitHub Actions runner between GitHub-hosted and self-hosted
#
# Usage:
#   ./scripts/toggle-runner.sh local    # Switch to self-hosted runner
#   ./scripts/toggle-runner.sh github   # Switch to GitHub-hosted runner
#   ./scripts/toggle-runner.sh status   # Show current setting
#
# WHY USE A LOCAL RUNNER?
# -----------------------
# GitHub provides 2000 free minutes/month for private repos.
# For active development, this can run out quickly:
#   - Backend CI: ~5 min per run
#   - Security scan: ~8 min per run
#   - Full deployment: ~15 min per run
#
# With 10 pushes/day = ~280 min/day = quota exhausted in ~1 week
#
# A self-hosted runner on your local machine or a $5/month VPS:
#   - Unlimited minutes
#   - Faster (no queue time)
#   - Free to run
#
# SETUP SELF-HOSTED RUNNER:
# -------------------------
# 1. Go to: Settings > Actions > Runners > New self-hosted runner
# 2. Follow the download and configure instructions
# 3. Run: ./run.sh (or install as service)
# 4. Use this script to toggle between runners
#
# This script updates the RUNNER_LABEL repository variable which controls
# which runner all workflows use by default.

set -e

# IMPORTANT: Update this to your repository
REPO="${GITHUB_REPOSITORY:-your-org/your-repo}"

show_usage() {
    echo "Usage: $0 [local|github|status]"
    echo ""
    echo "Commands:"
    echo "  local   - Switch to self-hosted runner"
    echo "  github  - Switch to GitHub-hosted runner (ubuntu-latest)"
    echo "  status  - Show current runner setting"
    echo ""
    echo "Examples:"
    echo "  $0 local   # When GitHub quota runs out"
    echo "  $0 github  # When quota resets (monthly)"
    echo ""
    echo "Environment:"
    echo "  GITHUB_REPOSITORY - Override default repo (default: $REPO)"
}

check_gh_cli() {
    if ! command -v gh &> /dev/null; then
        echo "Error: GitHub CLI (gh) is not installed."
        echo "Install it with: brew install gh"
        exit 1
    fi

    if ! gh auth status &> /dev/null; then
        echo "Error: Not authenticated with GitHub CLI."
        echo "Run: gh auth login"
        exit 1
    fi
}

get_current_runner() {
    gh variable get RUNNER_LABEL --repo "$REPO" 2>/dev/null || echo "(not set)"
}

show_quota_info() {
    echo ""
    echo "GitHub Actions Quota Info:"
    echo "  - Free tier: 2000 min/month for private repos"
    echo "  - Resets on your billing cycle date"
    echo "  - Check usage: Settings > Billing > Actions"
}

case "$1" in
    local)
        check_gh_cli
        echo "Switching to self-hosted runner..."
        gh variable set RUNNER_LABEL --body "self-hosted" --repo "$REPO"
        echo "Done! All workflows will now use: self-hosted"
        echo ""
        echo "Current setting:"
        get_current_runner
        ;;
    github)
        check_gh_cli
        echo "Switching to GitHub-hosted runner..."
        gh variable set RUNNER_LABEL --body "ubuntu-latest" --repo "$REPO"
        echo "Done! All workflows will now use: ubuntu-latest"
        echo ""
        echo "Current setting:"
        get_current_runner
        show_quota_info
        ;;
    status)
        check_gh_cli
        echo "Current runner setting:"
        CURRENT=$(get_current_runner)
        echo "  RUNNER_LABEL = $CURRENT"
        echo ""
        if [ "$CURRENT" = "self-hosted" ]; then
            echo "Workflows are using: self-hosted runner"
            echo "Tip: Run '$0 github' when quota resets"
        elif [ "$CURRENT" = "ubuntu-latest" ]; then
            echo "Workflows are using: GitHub-hosted runner"
            show_quota_info
        elif [ "$CURRENT" = "(not set)" ]; then
            echo "Workflows are using: ubuntu-latest (default, variable not set)"
            echo ""
            echo "To initialize the variable, run:"
            echo "  $0 github"
        else
            echo "Workflows are using: $CURRENT"
        fi
        ;;
    *)
        show_usage
        exit 1
        ;;
esac
