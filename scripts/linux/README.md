# Linux Scripts

This directory contains Linux-specific scripts for setting up and managing the agent-lab environment. Currently targets **Fedora** (36+), but most scripts work on any systemd-based Linux distribution.

## Scripts

### check-agent-lab-user.sh

**Purpose**: Inspect the agent-lab user configuration without making any changes.

**Usage**:
```bash
./scripts/linux/check-agent-lab-user.sh
```

**What it checks**:
- Current logged-in user
- Whether `agent-lab` user exists (via `id` / `getent passwd`)
- Admin status — checks for `wheel`/`sudo` group membership (should be absent)
- Home directory existence and ownership (`stat -c "%U"`)
- Expected workspace directories
- Tool availability (git, gh, node, npm, python3, jq, claude, podman, etc.)

**When to run**:
- After creating the agent-lab user
- To verify configuration before running bootstrap
- To troubleshoot setup issues
- As a pre-flight check before starting agent work

**Safe to run**: Yes, this script only reads system state and makes no modifications.

### setup-agent-alias.sh

**Purpose**: Add a shell alias `agent` that switches to the agent-lab user.

**Usage**:
```bash
./scripts/linux/setup-agent-alias.sh
```

Writes `alias agent='sudo su - agent-lab'` to `~/.bashrc` or `~/.zshrc` (if zsh is installed). Idempotent — safe to run multiple times.

## Directory Structure

```
scripts/
├── linux/
│   ├── README.md                    # This file
│   ├── check-agent-lab-user.sh     # User configuration inspector
│   └── setup-agent-alias.sh        # Shell alias installer
├── macos/
│   └── ...                         # macOS equivalents
└── bootstrap/
    └── bootstrap-agent-lab.sh      # Cross-platform first-time setup
```

## Related Documentation

- [fedora-agent-lab-user.md](../../docs/setup/fedora-agent-lab-user.md) - Complete Fedora setup guide
- [bootstrap-agent-lab.md](../../docs/setup/bootstrap-agent-lab.md) - Bootstrap process
- [tool-installation-notes.md](../../docs/setup/tool-installation-notes.md) - Tool installation

## Platform Notes

These scripts use GNU coreutils conventions:
- `getent passwd` — user lookup
- `id -Gn` / `groups` — group membership
- `stat -c "%U"` — file owner (GNU stat syntax)

They do **not** use `dscl`, `dseditgroup`, or `stat -f` (macOS/BSD). For macOS equivalents, see [`scripts/macos/`](../macos/).

## Development

When adding new scripts to this directory:

1. Use `#!/usr/bin/env bash` shebang
2. Include `set -euo pipefail` for safe shell behavior
3. Add comprehensive usage comments
4. Make scripts idempotent where possible
5. Avoid `sudo` inside the script — document the `sudo` commands separately
6. Use clear success/warning/error messages
7. Make executable with `chmod +x`
8. Document in this README

## Security Considerations

Scripts in this directory should:
- **Inspect, not modify** (prefer read-only checks)
- Avoid requiring root privileges when possible
- Never handle credentials directly
- Print clear warnings for any security concerns
- Default to safe, conservative behavior
