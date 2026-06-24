# Tool Installation Notes

This document provides installation guidance for tools required by the agent-lab environment.

## Overview

Tools are categorized as:
- **Required**: Must be installed for basic functionality
- **Optional**: Recommended but not strictly necessary

## Installation Methods

### System-Wide (Requires Admin)

If you have admin access or can request installation:
- **macOS**: Homebrew, official installers, direct downloads
- **Fedora**: `dnf install <package>`, official installers, direct downloads

### User-Local (No Admin Required)

If you're running as non-admin `agent-lab`:
- Version managers (nvm, pyenv) — same on both platforms
- User-local Homebrew installation (macOS only)
- Manual installation to `~/bin` or `~/.local`

## Required Tools

### Git

**Purpose**: Version control system

**Check if installed**:
```bash
git --version
```

**Installation**:

macOS (admin):
```bash
brew install git
```

Fedora (admin):
```bash
sudo dnf install -y git
```

Verify:
```bash
git --version
# Should show git version 2.x or later
```

Configuration:
```bash
git config --global user.name "Agent Lab"
git config --global user.email "agent-lab@example.com"
```

### GitHub CLI (gh)

**Purpose**: GitHub operations from command line

**Check if installed**:
```bash
gh --version
```

**Installation**:

macOS (admin):
```bash
brew install gh
```

Fedora (admin, Fedora 36+):
```bash
sudo dnf install -y gh
```

User-local macOS (no admin):
```bash
mkdir -p ~/bin
cd ~/bin
curl -LO https://github.com/cli/cli/releases/latest/download/gh_*_macOS_amd64.tar.gz
tar -xzf gh_*_macOS_amd64.tar.gz
mv gh_*/bin/gh .
rm -rf gh_*

echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

User-local Linux (no admin):
```bash
mkdir -p ~/bin
curl -L https://github.com/cli/cli/releases/latest/download/gh_*_linux_amd64.tar.gz \
  | tar -xz --strip-components=2 --wildcards '*/bin/gh' -C ~/bin
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Authentication:
```bash
gh auth login
```

### Node.js and npm

**Purpose**: JavaScript runtime and package manager

**Check if installed**:
```bash
node --version
npm --version
```

**Installation**:

macOS (admin):
```bash
brew install node
```

Fedora (admin):
```bash
sudo dnf install -y nodejs npm
```

User-local (no admin) - **Recommended** on both platforms:
```bash
# Install nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Reload shell
source ~/.zshrc  # or ~/.bash_profile

# Install Node LTS
nvm install --lts
nvm use --lts

# Verify
node --version
npm --version
```

Official installer:
- Download from https://nodejs.org/
- Requires admin for system-wide install

### Python 3

**Purpose**: Python runtime for scripts and tools

**Check if installed**:
```bash
python3 --version
```

**Installation**:

macOS usually includes Python 3, but you may want a newer version. Fedora also ships Python 3 by default.

macOS (admin):
```bash
brew install python3
```

Fedora (admin):
```bash
sudo dnf install -y python3
```

User-local (no admin):
```bash
# Install pyenv
curl https://pyenv.run | bash

# Add to shell config (~/.zshrc or ~/.bash_profile)
echo 'export PYENV_ROOT="$HOME/.pyenv"' >> ~/.zshrc
echo 'export PATH="$PYENV_ROOT/bin:$PATH"' >> ~/.zshrc
echo 'eval "$(pyenv init -)"' >> ~/.zshrc
source ~/.zshrc

# Install Python 3.11
pyenv install 3.11
pyenv global 3.11

# Verify
python3 --version
```

### jq

**Purpose**: JSON processing tool

**Check if installed**:
```bash
jq --version
```

**Installation**:

macOS (admin):
```bash
brew install jq
```

Fedora (admin):
```bash
sudo dnf install -y jq
```

User-local macOS (no admin):
```bash
mkdir -p ~/bin
curl -L https://github.com/jqlang/jq/releases/download/jq-1.7/jq-macos-amd64 -o ~/bin/jq
chmod +x ~/bin/jq
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

User-local Linux (no admin):
```bash
mkdir -p ~/bin
curl -L https://github.com/jqlang/jq/releases/download/jq-1.7/jq-linux-amd64 -o ~/bin/jq
chmod +x ~/bin/jq
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

Verify:
```bash
jq --version
```

## Optional Tools

### Claude Code CLI

**Purpose**: Primary AI agent interface

**Check if installed**:
```bash
claude --version
```

**Installation**:

Follow official Claude Code installation instructions:
- ~~Desktop app: https://claude.ai/code~~
- CLI: Bundled with desktop app or standalone installer
	- See employer instructions here: https://docs.google.com/document/d/1eNARy9CI28o09E7Foq01e5WD5MvEj3LSBnXqFcprxjo/edit?tab=t.0

Authentication:
```bash
claude auth login
```

### Podman

**Purpose**: Daemonless container engine for isolated environments (Docker alternative)

**Why Podman?**
- Runs rootless (perfect for non-admin users)
- No daemon required
- Docker-compatible CLI
- Better security model

**Check if installed**:
```bash
podman --version
```

**Installation**:

macOS (admin):
```bash
brew install podman
```

Fedora (admin):
```bash
sudo dnf install -y podman
```

macOS user-local setup:
```bash
mkdir -p ~/.homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.homebrew
echo 'export PATH="$HOME/.homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
brew install podman
```

**Initial Setup — macOS** (requires a VM):
```bash
podman machine init
podman machine start
podman ps
podman run --rm hello-world
```

**Initial Setup — Fedora** (no VM needed; runs natively):
```bash
# No machine init required on Linux
podman ps
podman run --rm hello-world
```

**Usage**:
```bash
# macOS: start podman machine if not running
podman machine start

# Run containers (Docker-compatible)
podman run -d --name myapp myimage
podman ps
podman stop myapp
```

**Docker Compatibility**:
Podman is Docker-compatible. You can alias `docker` to `podman`:
```bash
# Add to ~/.zshrc
echo 'alias docker=podman' >> ~/.zshrc
source ~/.zshrc
```

### Visual Studio Code

**Purpose**: Code editor with good Claude Code integration

**Check if installed**:
```bash
code --version
```

**Installation**:

macOS:
```bash
brew install --cask visual-studio-code
# Or download from https://code.visualstudio.com/
```

Fedora (via Microsoft RPM repo):
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'
sudo dnf install -y code
```

Enable `code` command (macOS):
- Open VS Code
- CMD+Shift+P → "Shell Command: Install 'code' command in PATH"

Enable `code` command (Fedora):
- The `code` command is available immediately after dnf install.

## Package Managers

### macOS: Homebrew

System-wide (requires admin):
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

This installs to `/usr/local` (Intel) or `/opt/homebrew` (Apple Silicon).

User-local (no admin):
```bash
mkdir -p ~/.homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.homebrew
echo 'export PATH="$HOME/.homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
brew --version
```

Note: User-local Homebrew may have limitations with some packages that expect system paths.

### Fedora: dnf

Most required tools are available in a single command (run as admin):
```bash
sudo dnf install -y git gh jq python3 podman
```

Node.js is best installed via `nvm` instead (no admin required — see [Node.js section](#nodejs-and-npm)).

## Verification Script

After installing tools, verify your setup:

```bash
# From the tsd-agent-lab repo
./scripts/bootstrap/bootstrap-agent-lab.sh
```

Or check individual tools:

```bash
echo "Git: $(git --version)"
echo "GitHub CLI: $(gh --version)"
echo "Node: $(node --version)"
echo "npm: $(npm --version)"
echo "Python: $(python3 --version)"
echo "jq: $(jq --version)"
echo "Claude: $(claude --version 2>/dev/null || echo 'not installed')"
echo "Podman: $(podman --version 2>/dev/null || echo 'not installed')"
```

## PATH Configuration

Many user-local installations require updating your PATH. Add to `~/.zshrc` (for zsh) or `~/.bash_profile` (for bash):

```bash
# User binaries
export PATH="$HOME/bin:$PATH"

# User-local Homebrew (if installed)
export PATH="$HOME/.homebrew/bin:$PATH"

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# pyenv (Python version manager)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
```

After editing, reload your shell:
```bash
source ~/.zshrc  # or source ~/.bash_profile
```

## Troubleshooting

### "Command not found"

**Cause**: Tool not in PATH or not installed.

**Solutions**:
1. Verify installation: `which <command>`
2. Check if binary exists: `ls -la ~/bin/<command>`
3. Ensure PATH is updated: `echo $PATH`
4. Reload shell config: `source ~/.zshrc`

### "Permission denied" during installation

**Cause**: Trying to install to system directories without admin.

**Solutions**:
1. Use user-local installation methods (nvm, pyenv, ~/bin)
2. Ask system administrator to install system-wide
3. Use Homebrew in user directory

### Homebrew installation fails

**Cause**: Insufficient permissions for `/usr/local` or `/opt/homebrew`.

**Solutions**:
1. Use user-local Homebrew installation
2. Request admin to install Homebrew system-wide
3. Use alternative installation methods (direct downloads, version managers)

### Tool version too old

**Cause**: System-provided versions may be outdated.

**Solutions**:
1. Use version managers (nvm, pyenv) for latest versions
2. Install via Homebrew for newer versions
3. Download and install manually to ~/bin

## Security Considerations

### Scoped Access Tokens

When authenticating tools:
- GitHub: Use Personal Access Tokens with minimum required scopes
- Claude: Use project-specific API keys if available
- Never use production credentials in the agent-lab user

### Credential Storage

- Store tokens in environment variables or config files (not in code)
- Use `.gitignore` to prevent committing credentials
- Consider macOS Keychain for sensitive values

### Installation Source Verification

When downloading binaries:
- Verify checksums when provided
- Download from official sources only
- Use HTTPS URLs
- Check GitHub release signatures

## Reference

Related documentation:
- [macos-agent-lab-user.md](./macos-agent-lab-user.md) - User setup guide
- [bootstrap-agent-lab.md](./bootstrap-agent-lab.md) - Bootstrap process
- [../../scripts/bootstrap/bootstrap-agent-lab.sh](../../scripts/bootstrap/bootstrap-agent-lab.sh) - Bootstrap script

Official tool documentation:
- Git: https://git-scm.com/doc
- GitHub CLI: https://cli.github.com/manual/
- Node.js: https://nodejs.org/en/docs/
- Python: https://docs.python.org/3/
- jq: https://jqlang.github.io/jq/manual/
- Podman: https://podman.io/docs
- VS Code: https://code.visualstudio.com/docs
