---
aliases: 
tags: 
---
# Bootstrap Agent Lab User

This document describes the bootstrap process for the `agent-lab` user after initial account creation.

## Platform Support

The bootstrap script works on **macOS** and **Fedora**. It detects the OS automatically and routes platform-specific checks accordingly.

| Platform | Setup guide |
|---|---|
| macOS | [macos-agent-lab-user.md](./macos-agent-lab-user.md) |
| Fedora | [fedora-agent-lab-user.md](./fedora-agent-lab-user.md) |

All other steps (directory creation, tool checks, git setup) are cross-platform and work as-is.

## Purpose

The bootstrap script (`scripts/bootstrap/bootstrap-agent-lab.sh`) performs first-time setup for the agent-lab user environment:
- Creates the workspace directory structure
- Checks for required and optional tools
- Verifies configuration
- Provides installation guidance for missing components

## Prerequisites

Before running the bootstrap script:

1. **User created**: The `agent-lab` user must exist (see [macos-agent-lab-user.md](./macos-agent-lab-user.md) or [fedora-agent-lab-user.md](./fedora-agent-lab-user.md))
2. **Logged in**: You must be logged in as the `agent-lab` user
3. **Repository cloned**: The `tsd-agent-lab` repository should be cloned locally

## Running the Bootstrap

### Step 1: Clone the Repository

If you haven't already cloned the repository:

```bash
# As agent-lab user
cd ~
mkdir -p workspaces/repos
cd workspaces/repos
git clone https://github.com/YOUR-ORG/tsd-agent-lab.git
cd tsd-agent-lab
```

### Step 2: Run the Bootstrap Script

```bash
./scripts/bootstrap/bootstrap-agent-lab.sh
```

The script will:
1. Verify you're running as `agent-lab` user
2. Check that the user is non-admin
3. Create necessary directories
4. Check for required tools
5. Check for optional tools
6. Verify git configuration
7. Check GitHub CLI authentication
8. Check Claude Code authentication
9. Provide a summary and next steps

## What the Script Creates

### Directory Structure

```
~/workspaces/
├── repos/          # Git repositories
├── runs/           # Agent run outputs
└── reports/        # Generated analysis reports

~/.codex/           # Codex CLI configuration

~/.config/
└── tsd-agent-lab/  # Lab-specific configuration
    └── .bootstrapped  # Marker file with timestamp
```

### Configuration Files

The script creates a marker file at `~/.config/tsd-agent-lab/.bootstrapped` to track that bootstrap has completed.

## Required Tools Checklist

The script checks for these required tools:

- **git** - Version control
- **gh** - GitHub CLI for repository and PR operations
- **node** - JavaScript runtime
- **npm** - Node package manager
- **python3** - Python runtime
- **jq** - JSON processing tool

If any required tools are missing, the script will exit with an error and reference the installation guide.

## Optional Tools Checklist

The script also checks for these optional but recommended tools:

- **claude** - Claude Code CLI (primary agent interface)
- **podman** - Container engine (daemonless, rootless)
- **code** - VS Code editor

Missing optional tools are noted but don't prevent bootstrap completion.

## Post-Bootstrap Configuration

After the bootstrap script completes, you should:

### 1. Configure Git

If not already configured:

```bash
git config --global user.name "Agent Lab"
git config --global user.email "agent-lab@example.com"
```

### 2. Authenticate GitHub CLI

```bash
gh auth login
```

Follow the prompts to:
- Choose GitHub.com
- Select HTTPS or SSH protocol
- Authenticate via web browser
- Use scoped tokens with minimum permissions needed

### 3. Authenticate Claude Code

If you plan to use Claude Code CLI:

```bash
claude auth login
```

### 4. Optional: Configure Podman

If using Podman:

```bash
# Initialize podman machine (one-time)
podman machine init

# Start podman machine
podman machine start

# Verify Podman works
podman ps
```

## Verification

After bootstrap and configuration, verify the setup:

### From Your Admin Account

**macOS:**
```bash
./scripts/macos/check-agent-lab-user.sh
```

**Fedora:**
```bash
./scripts/linux/check-agent-lab-user.sh
```

### From the agent-lab Account

```bash
# Verify directory structure
ls -la ~/workspaces/

# Verify tools
which git gh node npm python3 jq

# Verify git config
git config --global --list

# Verify GitHub auth
gh auth status

# Verify you can access the lab repo
gh repo view tsd-ui/tsd-agent-lab
```

## Troubleshooting

### "Must be run as agent-lab user"

**Problem**: You're running the script from the wrong account.

**Solution**: Log out and log in as the `agent-lab` user, then run the script again.

### "User has admin privileges"

**Problem**: The agent-lab user was created with admin rights.

**Solution**: Ask your system administrator to remove admin privileges:

```bash
sudo dseditgroup -o edit -d agent-lab -t user admin
```

### Required Tools Missing

**Problem**: One or more required tools are not installed.

**Solution**: See [tool-installation-notes.md](./tool-installation-notes.md) for installation instructions.

If you don't have admin rights to install tools:
1. Ask your system administrator to install them system-wide
2. Consider user-local installation alternatives (like `nvm` for Node, `pyenv` for Python)

### Git Configuration Not Set

**Problem**: Git user.name or user.email not configured.

**Solution**: Run the git config commands shown in the script output.

### GitHub CLI Not Authenticated

**Problem**: `gh auth status` fails.

**Solution**: Run `gh auth login` and follow the prompts.

### Permission Denied Creating Directories

**Problem**: Cannot create directories in home folder.

**Solution**: This is unusual. Check that:
- You're logged in as the `agent-lab` user (`whoami`)
- The home directory `/Users/agent-lab` exists and is owned by `agent-lab`
- You have write permissions: `ls -la /Users/agent-lab`

## Re-running Bootstrap

The bootstrap script is idempotent and safe to run multiple times:
- Existing directories are skipped (not recreated)
- Tool checks are re-run
- The `.bootstrapped` timestamp is updated

## Next Steps

After successful bootstrap:

1. **Phase 2**: Create Claude global and repo instructions
   - Set up `~/.claude/CLAUDE.md` for global preferences
   - Create `tsd-agent-lab/CLAUDE.md` for repo-specific guidance

2. **Install Missing Tools**: Reference [tool-installation-notes.md](./tool-installation-notes.md)
3. **Begin Experimentation**: Start exploring agent workflows in a safe, isolated environment

## Security Notes

The bootstrap script:
- ✅ Creates only local directories
- ✅ Makes no network calls
- ✅ Requires no admin privileges
- ✅ Writes no credentials
- ✅ Is safe to run multiple times

It will warn if:
- ❌ You're running as the wrong user
- ❌ The agent-lab user has admin privileges
- ❌ Required tools are missing

## Reference

- [macos-agent-lab-user.md](./macos-agent-lab-user.md) - Initial user creation
- [tool-installation-notes.md](./tool-installation-notes.md) - Tool installation guide
- [../scripts/bootstrap/bootstrap-agent-lab.sh](../../scripts/bootstrap/bootstrap-agent-lab.sh) - The bootstrap script
