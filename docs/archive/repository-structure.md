---
aliases: []
tags: []
---
# Repository Structure

## Overview

The `tsd-agent-lab` repository is organized to support safe experimentation, clear documentation, and effective policy enforcement.

## Directory Tree

```
tsd-agent-lab/
├── .git/                      # Git repository data
├── .gitignore                 # Git ignore patterns
├── README.md                  # Main repository documentation
│
├── docs/                      # Documentation
│   ├── adr/                  # Architecture Decision Records
│   │   ├── 0001-local-agent-lab-first.md
│   │   └── README.md         # ADR index
│   │
│   ├── guides/               # How-to guides and runbooks
│   │   ├── getting-started.md
│   │   ├── workflow-guide.md
│   │   └── troubleshooting.md
│   │
│   ├── assumptions-and-non-goals.md
│   ├── implementation-plan.md
│   ├── operator-rules.md     # To be created in Phase 0B
│   ├── repository-structure.md  # This file
│   ├── safety-model.md
│   └── threat-model.md       # To be created in Phase 0B
│
├── policies/                  # Safety policies and allowlists
│   ├── default-policy.yaml   # To be created in Phase 0B
│   ├── command-allowlist.yaml # To be created in Phase 0B
│   └── repo-allowlist.example.yaml # To be created in Phase 0B
│
├── experiments/              # Experimental scripts and test cases
│   ├── skills/              # Skill experiments (Phase 5)
│   ├── workflows/           # Workflow experiments (Phase 5)
│   └── README.md            # Experiment documentation
│
├── logs/                     # Execution logs and audit trail
│   ├── .gitignore           # Ignore actual log files
│   └── README.md            # Log format documentation
│
└── bin/                      # Executables (Phase 3+)
    └── agent-run            # Main runner script (Phase 3)
```

## Directory Purposes

### `/docs` - Documentation

Central location for all project documentation.

**Subdirectories**:
- `adr/` - Architecture Decision Records following [ADR pattern](https://adr.github.io/)
- `guides/` - Operational guides, tutorials, and runbooks

**Key Files**:
- `assumptions-and-non-goals.md` - Project scope and boundaries
- `implementation-plan.md` - Phased development plan
- `operator-rules.md` - Guidelines for running experiments
- `repository-structure.md` - This file
- `safety-model.md` - Security and safety controls
- `threat-model.md` - Threat analysis and mitigations

### `/policies` - Safety Policies

Enforceable policies and allowlists that control agent behavior.

**Policy Files**:
- `default-policy.yaml` - Default safety policy configuration
- `command-allowlist.yaml` - Approved commands for agent execution
- `repo-allowlist.example.yaml` - Template for repository allowlist

**Format**: YAML for readability and easy parsing

### `/experiments` - Experimental Workspace

Safe space for testing workflows, skills, and agent behaviors.

**Subdirectories**:
- `skills/` - Individual skill experiments
- `workflows/` - Multi-step workflow experiments

**Usage**:
- Disposable experimental code
- Test cases for new patterns
- Proof-of-concept implementations
- Learning exercises

### `/logs` - Audit Trail

Execution logs for all agent operations.

**Organization**:

```
logs/
├── 2026-06/
│   ├── 2026-06-12-session-001.log
│   ├── 2026-06-12-session-002.log
│   └── 2026-06-13-session-001.log
└── README.md
```

**Log Format**: Structured JSON or line-delimited format for easy parsing

**Retention**: Minimum 90 days, configurable

### `/bin` - Executable Scripts

Runner scripts and utilities (created in Phase 3+).

**Key Files**:
- `agent-run` - Main orchestration script
- Policy enforcement utilities
- Logging helpers
- Workflow launchers

## File Naming Conventions

### Documentation Files

- Use kebab-case: `operator-rules.md`
- Descriptive names: `threat-model.md` not `tm.md`
- Date prefix for ADRs: `0001-description.md`

### Policy Files

- YAML extension: `.yaml` (not `.yml`)
- Descriptive names: `command-allowlist.yaml`
- Example suffix for templates: `.example.yaml`

### Log Files

- ISO date prefix: `2026-06-12-session-001.log`
- Session identifier included
- Chronological sorting

### Experiment Files

- Descriptive directory names
- Self-contained per experiment
- Include README.md in each experiment

## Git Patterns

### Version Control

**Tracked**:
- All documentation
- All policy files
- Example configurations
- Scripts and tools
- Experiment code (without secrets)

**Not Tracked**:
- Actual log files (too large, contain sensitive data)
- Temporary files
- Local credentials
- Build artifacts
- OS-specific files

### Branch Strategy

```
main                    # Stable, reviewed changes
├── phase-0-foundation  # Phase-specific work
├── phase-1-user-setup
└── experiments/*       # Throwaway experiment branches
```

**Protected Branch**: `main` requires PR review

## Configuration Hierarchy

### Lab-Wide Configuration

```
tsd-agent-lab/
└── policies/
    ├── default-policy.yaml        # Lab-wide defaults
    └── command-allowlist.yaml     # Lab-wide commands
```

### Per-Experiment Configuration

```
experiments/skill-experiment-01/
├── .agent-config.yaml            # Experiment-specific config
├── README.md
└── experiment.sh
```

### User-Specific Configuration

```
~/.tsd-agent-lab/                 # User home, not in repo
├── credentials/
└── local-overrides.yaml
```

## Security Boundaries

### Public (in git)

- Documentation
- Policies
- Example configurations
- Non-sensitive logs (redacted)

### Private (local only)

- Actual credentials
- Full execution logs
- API tokens
- Personal configurations

### Sensitive (never written)

- Production credentials
- Production repository contents
- Personal data
- Proprietary code from experiments

## Expansion Plan

### Phase 3 Additions

```
bin/
└── agent-run
lib/
├── policy-enforcer.sh
└── logger.sh
```

### Phase 4 Additions

```
workflows/
├── templates/
└── examples/
results/
└── (workflow outputs)
```

### Phase 11 Additions

```
docs/
└── guides/
    ├── team-onboarding.md
    ├── workflow-catalog.md
    └── troubleshooting.md
```

## Maintenance

### Regular Updates

- Keep ADR index current
- Update implementation plan status
- Review and prune old experiments
- Archive old logs
- Update documentation for new patterns

### Quarterly Review

- Validate structure still appropriate
- Archive completed experiments
- Review security boundaries
- Update conventions as needed

## Related Documentation

- [Implementation Plan](implementation-plan.md) - Development phases
- [Safety Model](safety-model.md) - Security controls
- [Operator Rules](operator-rules.md) - Usage guidelines (Phase 0B)
- [ADR 0001](adr/0001-local-agent-lab-first.md) - Architecture decisions
