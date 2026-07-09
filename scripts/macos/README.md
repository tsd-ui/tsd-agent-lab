# macOS Scripts

This directory contains macOS-specific scripts for setting up and managing the agent-lab environment.

## Scripts

### check-agent-lab-user.sh

**Purpose**: Inspect the agent-lab user configuration without making any changes.

**Usage**:
```bash
./scripts/macos/check-agent-lab-user.sh
```

**What it checks**:
- Current logged-in user
- Whether `agent-lab` user exists
- Admin status (should be non-admin)
- Home directory existence and ownership
- Expected workspace directories
- Tool availability (git, gh, node, npm, python3, jq, claude, docker, etc.)

**When to run**:
- After creating the agent-lab user
- To verify configuration before running bootstrap
- To troubleshoot setup issues
- As a pre-flight check before starting agent work

**Safe to run**: Yes, this script only reads system state and makes no modifications.

### health-report.sh

**Purpose**: Produce a daily health report for the agent-lab environment.

**Usage**:
```bash
# Print to stdout (no file written)
./scripts/macos/health-report.sh --dry-run

# Write to docs/admin/reports/health-YYYY-MM-DD.md
./scripts/macos/health-report.sh
```

**What it checks**:
- tsd-agent-lab launchd agents and their run/exit status
- Failed tsd-agent-lab jobs (non-zero exit status)
- System log errors/faults from the last 24 hours
- Disk usage on local volumes (warns above 80%)
- Notable background processes (claude, node, python, fullsend)

**Scheduling**: A launchd plist is provided at `com.tsd-agent-lab.health-report.plist` for daily runs at 06:00. See [health-report docs](../../docs/admin/health-report.md) for load/unload instructions.

**Safe to run**: Yes, this script only reads system state and writes a markdown report.

### stale-docs-check.sh

**Purpose**: Mechanical (path/link existence) staleness scan across the repo's Markdown docs.

**Usage**:
```bash
# Print report to stdout (no file written)
./scripts/macos/stale-docs-check.sh --dry-run

# Write report to docs/admin/reports/stale-docs-YYYY-MM-DD.md
./scripts/macos/stale-docs-check.sh
```

**What it checks**:
- Broken markdown links
- Bare file/script path references that no longer resolve
- Scripts referenced as invocations (`./scripts/<name>.sh`-style) that exist but aren't executable

Excludes `docs/archive/`. For semantic review (directory structure, setup steps, feature drift) layered on top of this mechanical pass, see [skills/stale-docs-check/SKILL.md](../../skills/stale-docs-check/SKILL.md) and [docs/admin/stale-docs-check.md](../../docs/admin/stale-docs-check.md).

**Safe to run**: Yes, this script only reads repo files and writes a markdown report.

## Directory Structure

```
scripts/
├── macos/
│   ├── README.md                                    # This file
│   ├── check-agent-lab-user.sh                     # User configuration inspector
│   ├── health-report.sh                            # Daily health report generator
│   ├── stale-docs-check.sh                         # Mechanical doc staleness scanner
│   └── com.tsd-agent-lab.health-report.plist       # launchd plist for scheduling
└── bootstrap/
    └── bootstrap-agent-lab.sh                      # First-time setup for agent-lab user
```

## Related Documentation

- [macos-agent-lab-user.md](../../docs/setup/macos-agent-lab-user.md) - Complete setup guide
- [bootstrap-agent-lab.md](../../docs/setup/bootstrap-agent-lab.md) - Bootstrap process
- [tool-installation-notes.md](../../docs/setup/tool-installation-notes.md) - Tool installation

## Platform Notes

These scripts are specifically for macOS and use:
- `dscl` - Directory Service command line utility
- `dseditgroup` - Directory Service group editing
- `id` - User/group ID utilities
- `stat` - File status (BSD syntax: `stat -f`)

They will not work on Linux or Windows without modification. For Linux/Fedora equivalents, see [`scripts/linux/`](../linux/).

## Development

When adding new scripts to this directory:

1. Use `#!/usr/bin/env bash` shebang
2. Include `set -euo pipefail` for safe shell behavior
3. Add comprehensive usage comments
4. Make scripts idempotent where possible
5. Avoid `sudo` unless absolutely necessary (prefer inspection over modification)
6. Use clear success/warning/error messages
7. Make executable with `chmod +x`
8. Document in this README

## Security Considerations

Scripts in this directory should:
- **Inspect, not modify** (prefer read-only checks)
- Avoid requiring admin privileges when possible
- Never handle credentials directly
- Print clear warnings for any security concerns
- Default to safe, conservative behavior

When inspection scripts detect issues, they should:
- Clearly describe the problem
- Reference the relevant documentation
- Suggest manual remediation steps
- Exit with appropriate status codes
