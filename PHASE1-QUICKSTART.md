# Phase 1 Quick Start Guide

This guide helps you execute Phase 1: Dedicated Local User Setup.

## What Was Created

Phase 1 generated all documentation and scripts needed to create and configure the `agent-lab` user. You now need to execute the manual steps.

## Quick Execution Steps

### Step 1: Create the agent-lab User (Admin Account)

**Option A: GUI Method (Recommended)**
1. Open **System Settings** → **Users & Groups**
2. Click **+** button
3. Set Account Type: **Standard** (NOT Administrator)
4. Full Name: `Agent Lab`
5. Account Name: `agent-lab`
6. Set a password
7. Click **Create User**

**Option B: Command Line Method**
```bash
sudo dscl . -create /Users/agent-lab
sudo dscl . -create /Users/agent-lab UserShell /bin/zsh
sudo dscl . -create /Users/agent-lab RealName "Agent Lab"
sudo dscl . -create /Users/agent-lab UniqueID 503
sudo dscl . -create /Users/agent-lab PrimaryGroupID 20
sudo dscl . -create /Users/agent-lab NFSHomeDirectory /Users/agent-lab
sudo dscl . -passwd /Users/agent-lab
sudo createhomedir -c -u agent-lab
```

### Step 2: Verify User (Admin Account)

```bash
./scripts/macos/check-agent-lab-user.sh
```

Expected output:
- ✓ User 'agent-lab' exists
- ✓ User is NOT an administrator
- ✓ Home directory exists

### Step 3: Log In as agent-lab

1. Log out of your current account
2. Log in as `agent-lab`
3. Open Terminal

### Step 4: Clone Repository (agent-lab Account)

```bash
cd ~
mkdir -p workspaces/repos
cd workspaces/repos
git clone https://github.com/YOUR-ORG/tsd-agent-lab.git
cd tsd-agent-lab
```

### Step 5: Run Bootstrap (agent-lab Account)

```bash
./scripts/bootstrap/bootstrap-agent-lab.sh
```

This will:
- Create workspace directories
- Check for required tools
- Provide installation guidance for missing tools

### Step 6: Install Missing Tools (If Needed)

If the bootstrap script reports missing tools, see:
```bash
cat docs/setup/tool-installation-notes.md
```

**Minimum required tools:**
- git (usually pre-installed)
- gh (GitHub CLI)
- node + npm
- python3 (usually pre-installed)
- jq

**Recommended optional tools:**
- claude (Claude Code CLI)
- podman (container engine)

### Step 7: Configure Tools (agent-lab Account)

```bash
# Configure Git
git config --global user.name "Agent Lab"
git config --global user.email "agent-lab@example.com"

# Authenticate GitHub CLI
gh auth login

# Authenticate Claude Code (if installed)
claude auth login
```

## Verification

After completing all steps:

```bash
# Re-run bootstrap to verify
./scripts/bootstrap/bootstrap-agent-lab.sh

# Check workspace structure
ls -la ~/workspaces/

# Verify tools
which git gh node npm python3 jq claude
```

## What's Next?

Once Phase 1 is complete, proceed to:
- **Phase 2**: Claude global and repo instructions

## Detailed Documentation

For complete details, troubleshooting, and security notes:
- **docs/setup/macos-agent-lab-user.md** - Full setup guide
- **docs/setup/bootstrap-agent-lab.md** - Bootstrap details
- **docs/setup/tool-installation-notes.md** - Tool installation
- **docs/phases/phase1-completion.md** - Phase 1 summary

## Common Issues

**"command not found" when running scripts**
```bash
# Make sure you're in the repo directory
cd ~/workspaces/repos/tsd-agent-lab

# Verify script is executable
ls -la scripts/bootstrap/bootstrap-agent-lab.sh
```

**"Permission denied"**
```bash
# Make scripts executable
chmod +x scripts/macos/check-agent-lab-user.sh
chmod +x scripts/bootstrap/bootstrap-agent-lab.sh
```

**"agent-lab is an administrator"**
```bash
# From admin account, remove admin privileges
sudo dseditgroup -o edit -d agent-lab -t user admin
```

## Help

If you encounter issues:
1. Check the troubleshooting sections in the detailed documentation
2. Verify you're running commands as the correct user (`whoami`)
3. Review script output for specific error messages
