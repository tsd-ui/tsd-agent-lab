# macOS Agent Lab User Setup

This document describes the setup process for a dedicated non-admin local user named `agent-lab` for safe agentic SDLC experimentation.

## Purpose

The `agent-lab` user provides an isolated environment for:
- Local AI agent experimentation
- Testing automated SDLC workflows
- Building custom harnesses and skills
- Safe exploration without risking production credentials or personal data

## Security Model

**Critical**: This is a **local experimentation sandbox**, not a production service.

### What this IS
- A dedicated Mac user for local agent development
- An isolated environment with no admin privileges
- A safe space to test agentic workflows

### What this is NOT
- Not a shared always-on team service
- Not for production workloads
- Not for storing production credentials
- Not for personal browsing or SSH keys

## Prerequisites

- macOS system with admin access (for initial user creation)
- Familiarity with Terminal and basic Unix commands
- Understanding of macOS user management

## Setup Checklist

### 1. Create the Non-Admin User

**Option A: Using System Settings (Recommended)**
1. Open **System Settings** → **Users & Groups**
2. Click the **+** button (may require admin authentication)
3. Account Type: **Standard**
4. Full Name: `Agent Lab`
5. Account Name: `agent-lab`
6. Password: Use a strong password (store in your password manager)
7. Click **Create User**

**Option B: Using Command Line**
```bash
# Run as admin user
sudo dscl . -create /Users/agent-lab
sudo dscl . -create /Users/agent-lab UserShell /bin/zsh
sudo dscl . -create /Users/agent-lab RealName "Agent Lab"
sudo dscl . -create /Users/agent-lab UniqueID 503
sudo dscl . -create /Users/agent-lab PrimaryGroupID 20
sudo dscl . -create /Users/agent-lab NFSHomeDirectory /Users/agent-lab
sudo dscl . -passwd /Users/agent-lab
sudo createhomedir -c -u agent-lab
```

### 2. Verify User Configuration

Run the check script from your admin account:
```bash
./scripts/macos/check-agent-lab-user.sh
```

Verify:
- ✅ User `agent-lab` exists
- ✅ User is **not** an administrator
- ✅ Home directory `/Users/agent-lab` exists
- ✅ Shell is `/bin/zsh` or `/bin/bash`

### 3. Log In as agent-lab

1. Log out of your current account
2. Log in as `agent-lab`
3. Complete macOS first-time setup if prompted
4. Open Terminal

### 4. Run Bootstrap Script

Once logged in as `agent-lab`:
```bash
# Clone the lab repository
cd ~
mkdir -p workspaces/repos
cd workspaces/repos
git clone https://github.com/YOUR-ORG/tsd-agent-lab.git
cd tsd-agent-lab

# Run bootstrap
./scripts/bootstrap/bootstrap-agent-lab.sh
```

See [bootstrap-agent-lab.md](./bootstrap-agent-lab.md) for details.

### 5. Install Required Tools

See [tool-installation-notes.md](./tool-installation-notes.md) for installation guidance.

Minimum required:
- git
- gh (GitHub CLI)
- node & npm
- python3
- jq

Optional but recommended:
- claude (Claude Code CLI)
- podman (daemonless container engine)
- code (VS Code)

### 6. Configure Tool Access

**Git Configuration**
```bash
git config --global user.name "Agent Lab"
git config --global user.email "agent-lab@example.com"
```

**GitHub CLI**
```bash
# Authenticate (creates a scoped token)
gh auth login
```

**Claude Code**
```bash
# Authenticate if using Claude Code
claude auth login
```

### 7. Security Boundaries

**DO:**
- Keep this user for local experimentation only
- Use scoped access tokens with minimum permissions
- Clone only the repos you're actively working on
- Review any credentials before adding them

**DO NOT:**
- Copy your personal SSH keys to this user
- Store production API keys or credentials
- Use this as a personal browsing account
- Give this user admin privileges
- Run untrusted code without review

## Directory Structure

After setup, the agent-lab user should have:

```
/Users/agent-lab/
├── .codex/                    # Codex CLI config
├── .config/
│   └── tsd-agent-lab/        # Lab-specific config
├── workspaces/
│   ├── repos/                # Git repositories
│   ├── runs/                 # Agent run outputs
│   └── reports/              # Generated reports
└── .claude/                  # Claude Code config
```

## Credential Management

### Scoped Tokens Only
- Use GitHub Personal Access Tokens with minimum scopes
- Use GCP service accounts (not your personal credentials)
- Use Claude API keys from a separate project

### Storage
- Store credentials in environment variables or config files
- Never commit credentials to git
- Use `.env` files with `.gitignore` entries
- Consider using macOS Keychain for sensitive values

## Switching Between Users

**Fast User Switching**
1. Click your username in the menu bar
2. Select the other user
3. Both sessions remain active

**Full Logout**
```bash
# From agent-lab user
logout
```

## Troubleshooting

### User Creation Failed
- Verify you have admin privileges
- Check if username `agent-lab` is already taken
- Try a different UniqueID if 503 is in use

### Cannot Install Tools
- Homebrew may require admin for `/usr/local` write access
- Consider user-local installation in `~/bin` or `~/.local`
- Ask your admin to pre-install tools system-wide

### Permission Denied
- Verify you're running as `agent-lab` user: `whoami`
- Check file permissions: `ls -la`
- Ensure you're not trying to run `sudo` (should fail for non-admin)

## Next Steps

After completing this setup:
1. Proceed to Phase 2: Claude global and repo instructions
2. Create your first `CLAUDE.md` file
3. Begin experimenting with local agent workflows

## Maintenance

### Regular Review
- Periodically audit what repositories are cloned
- Review and rotate access tokens
- Clean up old run outputs and reports

### Decommissioning
If you need to remove the agent-lab user:
1. Back up any important files from `/Users/agent-lab`
2. Use System Settings → Users & Groups → Delete User
3. Choose to delete the home folder or save to disk image

## Reference

- [bootstrap-agent-lab.md](./bootstrap-agent-lab.md) - Bootstrap script details
- [tool-installation-notes.md](./tool-installation-notes.md) - Tool installation guide
- [macOS User Management](https://support.apple.com/guide/mac-help/set-up-users-mtusr001/mac)
