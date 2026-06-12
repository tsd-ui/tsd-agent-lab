#!/usr/bin/env bash
#
# check-agent-lab-user.sh
# Inspects the agent-lab user configuration without making changes
#
# Usage: ./scripts/macos/check-agent-lab-user.sh

set -euo pipefail

# ANSI color codes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Agent Lab User Check ===${NC}\n"

# Check 1: Current user
echo -e "${BLUE}Current User:${NC}"
CURRENT_USER=$(whoami)
echo "  Logged in as: ${CURRENT_USER}"
if [ "${CURRENT_USER}" = "agent-lab" ]; then
    echo -e "  ${GREEN}✓${NC} Running as agent-lab user"
else
    echo -e "  ${YELLOW}ℹ${NC} Not running as agent-lab (this is fine for inspection)"
fi
echo ""

# Check 2: Does agent-lab user exist?
echo -e "${BLUE}User Existence:${NC}"
if id "agent-lab" &>/dev/null; then
    echo -e "  ${GREEN}✓${NC} User 'agent-lab' exists"

    # Get user details
    USER_ID=$(id -u agent-lab)
    GROUP_ID=$(id -g agent-lab)
    USER_SHELL=$(dscl . -read /Users/agent-lab UserShell 2>/dev/null | awk '{print $2}')
    HOME_DIR=$(dscl . -read /Users/agent-lab NFSHomeDirectory 2>/dev/null | awk '{print $2}')

    echo "  User ID: ${USER_ID}"
    echo "  Group ID: ${GROUP_ID}"
    echo "  Shell: ${USER_SHELL}"
    echo "  Home: ${HOME_DIR}"
else
    echo -e "  ${RED}✗${NC} User 'agent-lab' does not exist"
    echo ""
    echo "To create the user, see: docs/setup/macos-agent-lab-user.md"
    exit 1
fi
echo ""

# Check 3: Admin status
echo -e "${BLUE}Admin Status:${NC}"
if dseditgroup -o checkmember -m agent-lab admin &>/dev/null; then
    echo -e "  ${RED}✗${NC} User 'agent-lab' is an ADMINISTRATOR"
    echo "  ${YELLOW}WARNING:${NC} This user should NOT have admin privileges"
    echo "  Remove admin with: sudo dseditgroup -o edit -d agent-lab -t user admin"
else
    echo -e "  ${GREEN}✓${NC} User 'agent-lab' is NOT an administrator (correct)"
fi
echo ""

# Check 4: Home directory
echo -e "${BLUE}Home Directory:${NC}"
if [ -d "/Users/agent-lab" ]; then
    echo -e "  ${GREEN}✓${NC} Home directory exists: /Users/agent-lab"

    # Check ownership
    OWNER=$(stat -f "%Su" /Users/agent-lab)
    if [ "${OWNER}" = "agent-lab" ]; then
        echo -e "  ${GREEN}✓${NC} Owned by agent-lab"
    else
        echo -e "  ${RED}✗${NC} Owned by ${OWNER} (should be agent-lab)"
    fi
else
    echo -e "  ${RED}✗${NC} Home directory does not exist"
    echo "  Create with: sudo createhomedir -c -u agent-lab"
fi
echo ""

# Check 5: Expected directories (only if home exists)
if [ -d "/Users/agent-lab" ]; then
    echo -e "${BLUE}Expected Directories:${NC}"

    DIRS=(
        "/Users/agent-lab/workspaces"
        "/Users/agent-lab/workspaces/repos"
        "/Users/agent-lab/workspaces/runs"
        "/Users/agent-lab/workspaces/reports"
        "/Users/agent-lab/.codex"
        "/Users/agent-lab/.config/tsd-agent-lab"
    )

    for dir in "${DIRS[@]}"; do
        if [ -d "${dir}" ]; then
            echo -e "  ${GREEN}✓${NC} ${dir}"
        else
            echo -e "  ${YELLOW}○${NC} ${dir} (not yet created)"
        fi
    done
    echo ""
fi

# Check 6: Common tools
echo -e "${BLUE}Tool Availability:${NC}"

check_tool() {
    local tool=$1
    local required=$2

    if command -v "${tool}" &>/dev/null; then
        local version=$(${tool} --version 2>&1 | head -n1 | cut -d' ' -f1-3 || echo "version unknown")
        echo -e "  ${GREEN}✓${NC} ${tool} (${version})"
    else
        if [ "${required}" = "required" ]; then
            echo -e "  ${RED}✗${NC} ${tool} (required, not found)"
        else
            echo -e "  ${YELLOW}○${NC} ${tool} (optional, not found)"
        fi
    fi
}

echo "  Required tools:"
check_tool "git" "required"
check_tool "gh" "required"
check_tool "node" "required"
check_tool "npm" "required"
check_tool "python3" "required"
check_tool "jq" "required"

echo ""
echo "  Optional tools:"
check_tool "claude" "optional"
check_tool "podman" "optional"
check_tool "code" "optional"

echo ""

# Summary
echo -e "${BLUE}=== Summary ===${NC}"
echo ""

if id "agent-lab" &>/dev/null && ! dseditgroup -o checkmember -m agent-lab admin &>/dev/null; then
    echo -e "${GREEN}✓${NC} User 'agent-lab' is properly configured as a non-admin user"

    if [ -d "/Users/agent-lab/workspaces" ]; then
        echo -e "${GREEN}✓${NC} Workspace directories are set up"
        echo ""
        echo "Next steps:"
        echo "  1. Log in as agent-lab user"
        echo "  2. Run: ./scripts/bootstrap/bootstrap-agent-lab.sh"
        echo "  3. Install any missing required tools"
    else
        echo ""
        echo "Next steps:"
        echo "  1. Log in as agent-lab user"
        echo "  2. Run: ./scripts/bootstrap/bootstrap-agent-lab.sh"
    fi
else
    echo -e "${YELLOW}⚠${NC} Configuration issues detected (see above)"
    echo ""
    echo "Refer to: docs/setup/macos-agent-lab-user.md"
fi

echo ""
