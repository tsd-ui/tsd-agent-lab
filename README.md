# TSD Agent Lab

A local experimental environment for testing agentic SDLC workflows with Claude Code, Superpowers, and eventually OpenCode.

## Purpose

This repository serves as a safe, isolated prototype lab for the software engineering team to:

- Experiment with AI-assisted development workflows
- Evaluate different agentic coding tools (Claude Code, Superpowers, OpenCode)
- Develop team practices and policies for safe AI tool usage
- Test automation patterns without production risk

## Key Principles

- **Local-first**: Runs on dedicated Mac user or equivalent isolation
- **Human-in-the-loop**: All merges require human review
- **No production secrets**: Completely isolated from production credentials
- **Multi-org safe**: Works across GitHub organizations without cross-contamination
- **Audit-friendly**: Clear logs and reviewable outputs

## Quick Start

See [docs/getting-started.md](docs/getting-started.md) for setup instructions.

## Repository Structure

```
tsd-agent-lab/
├── docs/              # Documentation and ADRs
│   ├── adr/          # Architecture decision records
│   ├── guides/       # How-to guides and runbooks
│   └── threat-model.md
├── policies/         # Safety policies and allowlists
│   ├── default-policy.yaml
│   ├── command-allowlist.yaml
│   └── repo-allowlist.example.yaml
├── experiments/      # Experimental scripts and test cases
├── logs/            # Execution logs and audit trail
└── README.md        # This file
```

## Safety Model

- **Dedicated user isolation**: Agents run under non-admin Mac user
- **No auto-merge**: Human approval required for all PRs
- **No comment triggers**: No webhook-based automation
- **Credential isolation**: No access to production secrets or shared tokens
- **Command allowlisting**: Only approved commands can execute
- **Repository allowlisting**: Only approved repos accessible

## Implementation Phases

1. **Phase 0**: Discovery and safety boundaries
2. **Phase 1**: Dedicated local user setup
3. **Phase 2**: Global and repo instructions (CLAUDE.md, etc.)
4. **Phase 3**: Local harness v0
5. **Phase 4**: Runner mode
6. **Phase 5**: Skills and workflow experiments
7. **Phase 6**: First real pilot task
8. **Phase 7**: Patch-only mode
9. **Phase 8**: Draft PR mode (manual, explicit)
10. **Phase 9**: Multi-agent comparison
11. **Phase 10**: Protocol playground
12. **Phase 11**: Team documentation
13. **Phase 12**: GitHub Actions experiment (optional)

Current phase: **Phase 1 - Dedicated Local User Setup (Ready for Execution)**

See [PHASE1-QUICKSTART.md](PHASE1-QUICKSTART.md) for execution steps.

## Non-Goals

- Production deployment (this is a prototype lab only)
- GCP integration (avoiding cloud dependency initially)
- Autonomous merging or deployment
- GitHub Copilot integration (not available to team)
- Long-running daemon services (initially)
- Single-org optimization (we work across multiple orgs)
- Formal security certification

## Assumptions

1. Team has access to Claude Code
2. Team will gain access to Superpowers and OpenCode for evaluation
3. Mac workstations available for dedicated user setup
4. GitHub access available (but credentials properly isolated)
5. Team follows existing code review practices
6. Experimental work won't impact production systems
7. Team size is small enough for pragmatic controls

## Contributing

See [docs/operator-rules.md](docs/operator-rules.md) for lab operation guidelines.

## License

Internal team use only.
