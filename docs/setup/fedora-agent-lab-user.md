# Fedora Agent Lab User Setup

This document describes the setup process for a dedicated non-admin local user named `agent-lab` on Fedora for safe agentic SDLC experimentation.

## Purpose

The `agent-lab` user provides an isolated environment for:
- Local AI agent experimentation
- Testing automated SDLC workflows
- Building custom harnesses and skills
- Safe exploration without risking production credentials or personal data

## Security Model

**Critical**: This is a **local experimentation sandbox**, not a production service.

### What this IS
- A dedicated Fedora user for local agent development
- An isolated environment with no sudo privileges
- A safe space to test agentic workflows

### What this is NOT
- Not a shared always-on team service
- Not for production workloads
- Not for storing production credentials
- Not for personal browsing or SSH keys

## Prerequisites

- Fedora system with sudo access (for initial user creation)
- Familiarity with Terminal and basic Unix commands

## Setup Checklist

### 1. Create the Non-Admin User

```bash
# Run as a user with sudo access
sudo useradd -m -s /bin/bash agent-lab
sudo passwd agent-lab
```

Verify the user is **not** in the `wheel` group (which grants sudo):
```bash
groups agent-lab
# Should NOT include 'wheel'
```

If accidentally added to wheel, remove it:
```bash
sudo gpasswd -d agent-lab wheel
```

### 2. Verify User Configuration

Run the check script from your admin account:
```bash
./scripts/linux/check-agent-lab-user.sh
```

Verify:
- ✅ User `agent-lab` exists
- ✅ User is **not** in the `wheel` group
- ✅ Home directory `/home/agent-lab` exists
- ✅ Shell is `/bin/bash` or `/bin/zsh`

### 3. Switch to agent-lab

```bash
sudo su - agent-lab
```

Or use the convenience alias (set up with `scripts/linux/setup-agent-alias.sh`):
```bash
agent
```

### 4. Install Required Tools

While still in your admin account, install system-wide tools via `dnf`:

```bash
sudo dnf install -y git gh jq python3 podman
```

> **Note**: `gh` (GitHub CLI) is available in Fedora repos since Fedora 36. If `dnf install gh` fails, see the [GitHub CLI section](#github-cli-gh) below.

Node.js is best installed via `nvm` (no admin required) — see [Node.js section](#nodejs-and-npm) below.

### 5. Run Bootstrap Script

Switch to the `agent-lab` user and clone the repository:

```bash
sudo su - agent-lab

cd ~
mkdir -p workspaces/repos
cd workspaces/repos
git clone https://github.com/YOUR-ORG/tsd-agent-lab.git
cd tsd-agent-lab

./scripts/bootstrap/bootstrap-agent-lab.sh
```

See [bootstrap-agent-lab.md](./bootstrap-agent-lab.md) for details.

## Tool Installation

### Git

Already available on most Fedora systems. If not:

```bash
sudo dnf install -y git
```

Configuration (run as `agent-lab`):
```bash
git config --global user.name "Agent Lab"
git config --global user.email "agent-lab@example.com"
```

### GitHub CLI (gh)

**Via dnf (Fedora 36+)**:
```bash
sudo dnf install -y gh
```

**Manual binary install** (if dnf package unavailable):
```bash
mkdir -p ~/bin
cd ~/bin
curl -LO https://github.com/cli/cli/releases/latest/download/gh_*_linux_amd64.tar.gz
tar -xzf gh_*_linux_amd64.tar.gz --strip-components=2 --wildcards '*/bin/gh'
rm -f gh_*.tar.gz

# Add to PATH in ~/.bashrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Authentication:
```bash
gh auth login
```

### Node.js and npm

Install via `nvm` (no admin required, works as `agent-lab`):

```bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell
source ~/.bashrc

# Install Node LTS
nvm install --lts
nvm use --lts

# Verify
node --version
npm --version
```

### Python 3

Fedora ships Python 3 by default. Verify:
```bash
python3 --version
```

If missing or you need a specific version:
```bash
# System-wide (admin)
sudo dnf install -y python3

# Or user-local via pyenv
curl https://pyenv.run | bash
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.bashrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(pyenv init -)"' >> ~/.bashrc
source ~/.bashrc
pyenv install 3.11
pyenv global 3.11
```

### jq

```bash
sudo dnf install -y jq
```

Or user-local:
```bash
mkdir -p ~/bin
curl -L https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux-amd64 -o ~/bin/jq
chmod +x ~/bin/jq
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Podman

On Fedora, Podman runs natively — no VM needed (unlike macOS):

```bash
sudo dnf install -y podman
```

Verify:
```bash
podman --version
podman ps
podman run --rm hello-world
```

No `podman machine init` is required on Linux. Podman uses the host kernel directly.

Docker compatibility alias (optional):
```bash
echo 'alias docker=podman' >> ~/.bashrc
source ~/.bashrc
```

### Visual Studio Code

**Via RPM repository**:
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code
```

Enable `code` command in PATH:
- Open VS Code
- Ctrl+Shift+P → "Shell Command: Install 'code' command in PATH"

### Claude Code CLI

Follow the official installation instructions from your organization. Authentication:
```bash
claude auth login
```

## Directory Structure

After setup, the `agent-lab` user should have:

```
/home/agent-lab/
├── .codex/                    # Codex CLI config
├── .config/
│   └── tsd-agent-lab/        # Lab-specific config
├── workspaces/
│   ├── repos/                # Git repositories
│   ├── runs/                 # Agent run outputs
│   └── reports/              # Generated reports
└── .claude/                  # Claude Code config
```

## Switching Between Users

```bash
# Switch to agent-lab user
sudo su - agent-lab

# Return to your account
exit
```

**Convenience alias** — run `scripts/linux/setup-agent-alias.sh` to add to your shell config, then:
```bash
agent        # Switch to agent-lab
exit         # Return to your account
```

## Security Boundaries

**DO:**
- Keep this user for local experimentation only
- Use scoped access tokens with minimum permissions
- Clone only the repos you're actively working on

**DO NOT:**
- Copy your personal SSH keys to this user
- Store production API keys or credentials
- Add this user to the `wheel` group
- Run untrusted code without review

## Troubleshooting

### "gh not found" after dnf install

Ensure the package was installed for the correct user context:
```bash
which gh
# If missing, check: sudo dnf list installed gh
```

On older Fedora versions, install from binary (see [GitHub CLI section](#github-cli-gh) above).

### "Permission denied" when running bootstrap

Verify you are logged in as `agent-lab`:
```bash
whoami
```

### Podman: "cannot find user in /etc/subuid"

Add subuid/subgid mappings for rootless Podman:
```bash
sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 agent-lab
```

### Node not found after nvm install

Reload the shell config:
```bash
source ~/.bashrc
nvm use --lts
```

## Next Steps

After completing this setup:
1. Proceed to Phase 2: Claude global and repo instructions
2. Create your first `CLAUDE.md` file
3. Begin experimenting with local agent workflows

## Reference

- [bootstrap-agent-lab.md](./bootstrap-agent-lab.md) - Bootstrap script details
- [tool-installation-notes.md](./tool-installation-notes.md) - Tool installation guide
- [../../scripts/linux/check-agent-lab-user.sh](../../scripts/linux/check-agent-lab-user.sh) - User configuration inspector (Linux)
