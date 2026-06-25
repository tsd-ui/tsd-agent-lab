# Getting Started

The TSD Agent Lab is a safe, local experimentation environment for AI-assisted software development. The team uses it to run coding agents (Claude Code) against real repositories, review their output, build reusable skills, and measure quality — all without touching production systems.

## Current Status

**Phase 8 — Draft PR mode (in progress)**

Agents can now create draft PRs for human review. Phases 0–7 are complete. See the checkboxes in [README.md](../README.md) for the full phase list.

## Key Concepts

| Term | What It Means |
|------|---------------|
| **Harness** | Shell scripts (`harness/`) that run an agent safely against a repo — clone, run, verify, report |
| **Skill** | A reusable `SKILL.md` file that tells an agent what task to perform (e.g., `codebase-map`, `bugfix-minimal`) |
| **Task** | A YAML file specifying a job: which repo, which skill, which mode, what to verify |
| **Mode** | How much the agent is allowed to do: `read-only`, `patch-only`, `commit-allowed`, or PR creation |
| **Run** | A timestamped directory under `~/workspaces/runs/` created for one task execution |
| **Evaluation** | Scoring a skill's output quality using agent-eval-harness (`/eval-*` commands) |

## Quick Start: Your First Run

```bash
# 1. Switch to the agent-lab user
agent

# 2. Go to the lab repo
cd ~/workspaces/repos/tsd-agent-lab

# 3. Create a run from an example task
RUN_DIR=$(./harness/create-run.sh examples/tasks/read-only-codebase-map.yaml)

# 4. Run the full pipeline: clone → run agent → verify → report
./harness/prepare-repo.sh examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR"
./harness/run-claude.sh   examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR"
./harness/verify-run.sh   examples/tasks/read-only-codebase-map.yaml --run-dir "$RUN_DIR"
./harness/write-report.sh "$RUN_DIR"

# Result is in $RUN_DIR/summary.md
```

## Common Workflows

| What you want to do | Where to start |
|---------------------|---------------|
| Connect to the lab for the first time | [guides/connect-to-lab.md](guides/connect-to-lab.md) |
| Add a new repo and run an agent against it | [guides/onboard-a-repo.md](guides/onboard-a-repo.md) |
| Understand how a run works end-to-end | [guides/run-a-task.md](guides/run-a-task.md) |
| Create a new skill | [guides/write-a-skill.md](guides/write-a-skill.md) |
| Test and score a skill's quality | [guides/test-a-skill.md](guides/test-a-skill.md) |
| Review an agent-generated PR | [guides/review-agent-output.md](guides/review-agent-output.md) |
| Look up eval slash commands | [guides/slash-commands.md](guides/slash-commands.md) |

## Safety in 30 Seconds

- Always run as the **agent-lab user**, not your primary account
- No production credentials in the environment — verify with `env | grep -E '(AWS|GCP|AZURE|PROD)'`
- Check `policies/repo-allowlist.yaml` before pointing the agent at any repo
- Review all agent output before merging — never auto-merge
- If something unexpected happens: `Ctrl+C`, then `killall -u agent-lab`

Full safety model: [architecture/safety-model.md](architecture/safety-model.md)

## Repository Layout

```
tsd-agent-lab/
├── docs/               # Documentation (you are here)
│   ├── guides/         # Scenario-based how-to guides
│   ├── reference/      # Technical reference for harness and tools
│   ├── admin/          # Operator checklists, incident response, strategy
│   ├── architecture/   # Safety model, threat model, ADRs
│   ├── setup/          # One-time setup guides
│   ├── pilot/          # Pilot evaluation docs
│   └── archive/        # Historical phase docs
├── harness/            # Run scripts (create-run, prepare-repo, run-claude, verify, report)
├── skills/             # Reusable SKILL.md packages
├── examples/tasks/     # Sample task YAML files
├── policies/           # Repo and command allowlists
├── prompts/            # Safety preamble and prompt files
├── scripts/            # Setup and utility scripts
└── eval/               # Evaluation runs and baselines
```

## Getting Help

- **Can't find a command**: Check [guides/slash-commands.md](guides/slash-commands.md)
- **Harness script failing**: Check [reference/harness.md](reference/harness.md)
- **Allowlist or policy question**: Check `policies/` and [admin/operator-checklist.md](admin/operator-checklist.md)
- **Security concern**: Follow [admin/incident-response.md](admin/incident-response.md) — escalate immediately
- **Team questions**: `#agent-lab` Slack channel
