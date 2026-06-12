# Tool Installation Notes

This document provides installation guidance for tools required by the agent-lab environment.

## Overview

Tools are categorized as:
- **Required**: Must be installed for basic functionality
- **Optional**: Recommended but not strictly necessary

## Installation Methods

### System-Wide (Requires Admin)

If you have admin access or can request installation:
- Homebrew (macOS package manager)
- Official installers
- Direct downloads

### User-Local (No Admin Required)

If you're running as non-admin `agent-lab`:
- Version managers (nvm, pyenv)
- User-local Homebrew installation
- Manual installation to `~/bin` or `~/.local`

## Required Tools

### Git

**Purpose**: Version control system

**Check if installed**:
```bash
git --version
```

**Installation**:

System-wide (admin):
```bash
# Homebrew
brew install git

# Or download from
# https://git-scm.com/download/mac
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

System-wide (admin):
```bash
# Homebrew
brew install gh

# Or download from
# https://cli.github.com/
```

User-local (no admin):
```bash
# Download binary
mkdir -p ~/bin
cd ~/bin
curl -LO https://github.com/cli/cli/releases/latest/download/gh_*_macOS_amd64.tar.gz
tar -xzf gh_*_macOS_amd64.tar.gz
mv gh_*/bin/gh .
rm -rf gh_* 

# Add to PATH in ~/.zshrc or ~/.bash_profile
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
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

System-wide (admin):
```bash
# Homebrew
brew install node
```

User-local (no admin) - **Recommended**:
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

macOS usually includes Python 3, but you may want a newer version.

System-wide (admin):
```bash
# Homebrew
brew install python3
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

System-wide (admin):
```bash
# Homebrew
brew install jq
```

User-local (no admin):
```bash
# Download binary
mkdir -p ~/bin
cd ~/bin
curl -LO https://github.com/jqlang/jq/releases/download/jq-1.7/jq-macos-amd64
mv jq-macos-amd64 jq
chmod +x jq

# Add to PATH in ~/.zshrc
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
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
- Desktop app: https://claude.ai/code
- CLI: Bundled with desktop app or standalone installer

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

System-wide (admin):
```bash
brew install podman
```

User-local setup:
```bash
# Install Homebrew in user directory (if not already)
mkdir -p ~/.homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1 -C ~/.homebrew

# Add to PATH
echo 'export PATH="$HOME/.homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Install podman
brew install podman
```

**Initial Setup**:
```bash
# Initialize podman machine (one-time setup)
podman machine init

# Start the podman machine
podman machine start

# Verify podman works
podman ps

# Test with a simple container
podman run --rm hello-world
```

**Usage**:
```bash
# Start podman machine (if not running)
podman machine start

# Run containers (Docker-compatible commands)
podman run -d --name myapp myimage
podman ps
podman stop myapp

# Stop podman machine when done (optional)
podman machine stop
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

Download from: https://code.visualstudio.com/

Or with Homebrew:
```bash
brew install --cask visual-studio-code
```

Enable `code` command:
- Open VS Code
- CMD+Shift+P → "Shell Command: Install 'code' command in PATH"

## Homebrew Installation Methods

### System-Wide Homebrew (Requires Admin)

Standard installation:
```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

This installs to `/usr/local` (Intel) or `/opt/homebrew` (Apple Silicon) and requires admin.

### User-Local Homebrew (No Admin)

Install Homebrew in your home directory:

```bash
# Create local homebrew directory
mkdir -p ~/.homebrew

# Download and extract
cd ~/.homebrew
curl -L https://github.com/Homebrew/brew/tarball/master | tar xz --strip 1

# Add to PATH in ~/.zshrc
echo 'export PATH="$HOME/.homebrew/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc

# Verify
brew --version
```

Note: User-local Homebrew may have limitations with some packages that expect system paths.

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
