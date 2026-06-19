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
│   ├── phases/       # Phase prompts and completion summaries
│   ├── setup/        # Setup guides
│   ├── harness.md    # Harness usage guide
│   └── task-format.md # Task specification format
├── harness/          # Local harness scripts
│   ├── lib/          # Shared libraries (common.sh, git.sh, agent.sh, verify.sh)
│   ├── create-run.sh # Create a timestamped run directory
│   ├── prepare-repo.sh # Safe clone + worktree creation
│   ├── run-claude.sh # Run Claude Code against a prepared task
│   ├── verify-run.sh # Run verification commands
│   └── write-report.sh # Generate markdown report from a run
├── schemas/          # JSON schemas
│   └── task.schema.json
├── examples/         # Example task specs and reports
│   ├── tasks/        # Sample task YAML files
│   └── reports/      # Sample run reports
├── skills/           # Portable skill packages (SKILL.md format)
│   ├── codebase-map/ # Read-only repo exploration
│   ├── bugfix-minimal/ # Minimal targeted bugfix
│   ├── test-generation/ # Test creation
│   ├── pr-review/    # Structured code review
│   └── adr-writer/   # ADR drafting
├── prompts/          # Agent prompt files
│   ├── common/       # Shared preambles (safety-preamble.md)
│   └── claude/       # Claude Code task prompts
├── policies/         # Safety policies and allowlists
│   ├── default-policy.yaml
│   ├── command-allowlist.yaml
│   └── repo-allowlist.example.yaml
├── scripts/          # Setup and utility scripts
│   ├── bootstrap/
│   └── macos/
├── templates/        # Reusable templates
└── README.md         # This file
```

## Safety Model

- **Dedicated user isolation**: Agents run under non-admin Mac user
- **No auto-merge**: Human approval required for all PRs
- **No comment triggers**: No webhook-based automation
- **Credential isolation**: No access to production secrets or shared tokens
- **Command allowlisting**: Only approved commands can execute
- **Repository allowlisting**: Only approved repos accessible

## Implementation Phases

1. [x] **Phase 0**: Discovery and safety boundaries
2. [x] **Phase 1**: Dedicated local user setup
3. [x] **Phase 2**: Global and repo instructions (`CLAUDE.md`, etc.)
4. [x] **Phase 3**: Local harness v0
5. [x] **Phase 4**: Runner mode
6. [x] **Phase 5**: Skills and workflow experiments
7. [ ] **Phase 6**: First real pilot task
8. [ ] **Phase 7**: Patch-only mode
9. [ ] **Phase 8**: Draft PR mode (manual, explicit)
10. [ ] **Phase 9**: Multi-agent comparison
11. [ ] **Phase 10**: Protocol playground
12. [ ] **Phase 11**: Team documentation
13. [ ] **Phase 12**: Fullsend hosted lane and GitHub Actions

Current phase: **Phase 6 - First real pilot task**

## Integration Strategy

This lab is designed to complement—not replace—two external tools:

- **[Fullsend](https://github.com/fullsend-ai/fullsend)**: An open-source framework for fully autonomous agentic development on GitHub. Fullsend provides the production lifecycle (issue triage, code generation, review, merge) with secure credential delivery via a GCP-hosted mint service. As of mid-2026, Fullsend's authorization guardrails for public repositories are not yet complete, so public repos stay local-only until those guardrails ship and are verified.

- **[agent-eval-harness](https://github.com/opendatahub-io/agent-eval-harness)**: A systematic evaluation framework for measuring agent and skill quality. Provides multi-judge scoring, baseline comparison, regression detection, and MLflow tracking—replacing the need for custom evaluation scripts.

The three tools form complementary layers:

| Layer | Tool | Purpose |
|-------|------|---------|
| **Orchestration** | This lab's harness | Run agents safely against repos locally |
| **Context assembly** | Fullsend (local CLI, then hosted) | Assemble skills, prompts, and tools per agent role |
| **Evaluation** | agent-eval-harness | Score quality, detect regressions, compare agents |

Skills written in this lab follow Fullsend's SKILL.md conventions for portability. Evaluation baselines established here carry forward into multi-agent comparison. When Fullsend's public-repo guardrails are ready, enrolled repositories move to a hosted mint service (GCP) while this lab remains the team's interactive experimentation workshop. See [docs/lab-strategy.md](docs/lab-strategy.md) for the full three-lane strategy.

## Non-Goals

- Production deployment (this is a prototype lab only)
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
