#!/usr/bin/env bash
#
# bootstrap-agent-lab.sh
# First-time setup for the agent-lab user
#
# This script should be run while logged in as the agent-lab user.
# It creates necessary directories, checks for required tools, and
# provides installation guidance for missing tools.
#
# Usage: ./scripts/bootstrap/bootstrap-agent-lab.sh

set -euo pipefail

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Track if any issues were found
MISSING_REQUIRED=0
MISSING_OPTIONAL=0

echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║         Agent Lab Bootstrap - First Time Setup             ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Verify we're running as agent-lab
echo -e "${BLUE}Step 1: Verify User${NC}"
CURRENT_USER=$(whoami)
if [ "${CURRENT_USER}" != "agent-lab" ]; then
    echo -e "${RED}✗ This script must be run as the agent-lab user${NC}"
    echo "  Current user: ${CURRENT_USER}"
    echo ""
    echo "Please log in as agent-lab and run this script again."
    exit 1
fi
echo -e "${GREEN}✓ Running as agent-lab user${NC}"
echo ""

# Verify we're NOT admin
echo -e "${BLUE}Step 2: Verify Non-Admin Status${NC}"
if dseditgroup -o checkmember -m agent-lab admin &>/dev/null; then
    echo -e "${RED}✗ WARNING: agent-lab user has admin privileges${NC}"
    echo "  This is a security concern. This user should be non-admin."
    echo ""
    echo "Ask your administrator to remove admin privileges:"
    echo "  sudo dseditgroup -o edit -d agent-lab -t user admin"
    echo ""
    read -p "Continue anyway? (y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
else
    echo -e "${GREEN}✓ User is non-admin (correct)${NC}"
fi
echo ""

# Create directory structure
echo -e "${BLUE}Step 3: Create Directory Structure${NC}"

create_dir() {
    local dir=$1
    if [ -d "${dir}" ]; then
        echo -e "  ${GREEN}✓${NC} ${dir} (already exists)"
    else
        mkdir -p "${dir}"
        echo -e "  ${GREEN}✓${NC} ${dir} (created)"
    fi
}

create_dir "${HOME}/workspaces"
create_dir "${HOME}/workspaces/repos"
create_dir "${HOME}/workspaces/runs"
create_dir "${HOME}/workspaces/reports"
create_dir "${HOME}/.codex"
create_dir "${HOME}/.config/tsd-agent-lab"

echo ""

# Check for required tools
echo -e "${BLUE}Step 4: Check Required Tools${NC}"

check_tool() {
    local tool=$1
    local required=$2

    if command -v "${tool}" &>/dev/null; then
        local version=$(${tool} --version 2>&1 | head -n1 || echo "version unknown")
        echo -e "  ${GREEN}✓${NC} ${tool}"
        echo -e "    ${version}"
        return 0
    else
        if [ "${required}" = "required" ]; then
            echo -e "  ${RED}✗${NC} ${tool} ${RED}(REQUIRED - not found)${NC}"
            MISSING_REQUIRED=$((MISSING_REQUIRED + 1))
        else
            echo -e "  ${YELLOW}○${NC} ${tool} (optional - not found)"
            MISSING_OPTIONAL=$((MISSING_OPTIONAL + 1))
        fi
        return 1
    fi
}

echo "  Checking required tools..."
echo ""

check_tool "git" "required"
check_tool "gh" "required"
check_tool "node" "required"
check_tool "npm" "required"
check_tool "python3" "required"
check_tool "jq" "required"

echo ""
echo "  Checking optional tools..."
echo ""

check_tool "claude" "optional"
check_tool "podman" "optional"
check_tool "code" "optional"

echo ""

# Check for package managers
echo -e "${BLUE}Step 5: Check Package Managers${NC}"

check_tool "brew" "optional"

echo ""

# Git configuration check
echo -e "${BLUE}Step 6: Check Git Configuration${NC}"

GIT_NAME=$(git config --global user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config --global user.email 2>/dev/null || echo "")

if [ -n "${GIT_NAME}" ] && [ -n "${GIT_EMAIL}" ]; then
    echo -e "${GREEN}✓ Git is configured${NC}"
    echo "  Name: ${GIT_NAME}"
    echo "  Email: ${GIT_EMAIL}"
else
    echo -e "${YELLOW}○ Git is not fully configured${NC}"
    echo ""
    echo "Configure git with:"
    echo '  git config --global user.name "Agent Lab"'
    echo '  git config --global user.email "agent-lab@example.com"'
fi

echo ""

# GitHub CLI auth check
echo -e "${BLUE}Step 7: Check GitHub CLI Authentication${NC}"

if command -v gh &>/dev/null; then
    if gh auth status &>/dev/null; then
        echo -e "${GREEN}✓ GitHub CLI is authenticated${NC}"
        gh auth status 2>&1 | grep -E "Logged in|account" || true
    else
        echo -e "${YELLOW}○ GitHub CLI is not authenticated${NC}"
        echo ""
        echo "Authenticate with:"
        echo "  gh auth login"
    fi
else
    echo -e "${YELLOW}○ GitHub CLI not installed${NC}"
fi

echo ""

# Claude CLI auth check
echo -e "${BLUE}Step 8: Check Claude Code Authentication${NC}"

if command -v claude &>/dev/null; then
    # Claude CLI doesn't have a simple auth check, so just note it's installed
    echo -e "${GREEN}✓ Claude Code CLI is installed${NC}"
    echo ""
    echo "If not authenticated, run:"
    echo "  claude auth login"
else
    echo -e "${YELLOW}○ Claude Code CLI not installed${NC}"
fi

echo ""

# Summary
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                      Bootstrap Summary                     ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

if [ ${MISSING_REQUIRED} -eq 0 ]; then
    echo -e "${GREEN}✓ All required tools are installed${NC}"
else
    echo -e "${RED}✗ ${MISSING_REQUIRED} required tool(s) missing${NC}"
    echo ""
    echo "See: docs/setup/tool-installation-notes.md for installation guidance"
fi

if [ ${MISSING_OPTIONAL} -gt 0 ]; then
    echo -e "${YELLOW}○ ${MISSING_OPTIONAL} optional tool(s) not installed${NC}"
fi

echo ""

if [ ${MISSING_REQUIRED} -eq 0 ]; then
    echo -e "${GREEN}Bootstrap complete!${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Review tool installation notes if needed:"
    echo "     docs/setup/tool-installation-notes.md"
    echo "  2. Authenticate with GitHub CLI if not done:"
    echo "     gh auth login"
    echo "  3. Authenticate with Claude Code if not done:"
    echo "     claude auth login"
    echo "  4. Proceed to Phase 2: Claude global and repo instructions"
    echo ""
else
    echo -e "${YELLOW}Please install missing required tools before proceeding.${NC}"
    echo ""
    echo "Installation guide: docs/setup/tool-installation-notes.md"
    echo ""
    exit 1
fi

# Create a marker file to indicate bootstrap has run
touch "${HOME}/.config/tsd-agent-lab/.bootstrapped"
echo "Bootstrap timestamp: $(date)" > "${HOME}/.config/tsd-agent-lab/.bootstrapped"

echo -e "${BLUE}Configuration saved to: ~/.config/tsd-agent-lab/${NC}"
echo ""
