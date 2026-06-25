# Documentation Map

## For Teammates (start here)

- [Getting Started](getting-started.md) — What the lab is, current status, quick start commands
- [guides/connect-to-lab.md](guides/connect-to-lab.md) — Switch to the agent-lab user and verify your environment
- [guides/onboard-a-repo.md](guides/onboard-a-repo.md) — Add a repo to the allowlist and run your first task
- [guides/run-a-task.md](guides/run-a-task.md) — End-to-end task run with commands and result inspection
- [guides/write-a-skill.md](guides/write-a-skill.md) — Create a reusable SKILL.md from scratch
- [guides/test-a-skill.md](guides/test-a-skill.md) — Evaluate skill quality with agent-eval-harness
- [guides/review-agent-output.md](guides/review-agent-output.md) — Review agent PRs as operator or code reviewer
- [guides/slash-commands.md](guides/slash-commands.md) — Reference for all /eval-* and utility slash commands

## Reference

- [reference/harness.md](reference/harness.md) — Harness scripts, workflow, environment variables
- [reference/task-format.md](reference/task-format.md) — Task YAML specification
- [reference/evaluation.md](reference/evaluation.md) — agent-eval-harness setup and eval.yaml format
- [reference/prompts.md](reference/prompts.md) — Prompt files and composition
- [reference/run-claude.md](reference/run-claude.md) — run-claude.sh flags and behavior
- [reference/verification.md](reference/verification.md) — verify-run.sh and verification commands
- [reference/patch-only-mode.md](reference/patch-only-mode.md) — Patch-only mode constraints and usage
- [reference/branch-only-mode.md](reference/branch-only-mode.md) — Branch-only mode constraints and usage

## For Admins

- [admin/operator-checklist.md](admin/operator-checklist.md) — Pre-flight and post-execution checklists
- [admin/incident-response.md](admin/incident-response.md) — Severity levels, response steps, report template
- [admin/policy-overrides.md](admin/policy-overrides.md) — Override process and log format
- [admin/onboarding-operators.md](admin/onboarding-operators.md) — New operator training steps
- [admin/lab-strategy.md](admin/lab-strategy.md) — Three-lane strategy and Fullsend integration

## Architecture & Design

- [architecture/safety-model.md](architecture/safety-model.md) — Security controls and trust model
- [architecture/threat-model.md](architecture/threat-model.md) — Threat analysis and mitigations
- [architecture/assumptions-and-non-goals.md](architecture/assumptions-and-non-goals.md) — Scope boundaries
- [architecture/adr/README.md](architecture/adr/README.md) — Architecture Decision Record index
- [architecture/adr/0001-local-agent-lab-first.md](architecture/adr/0001-local-agent-lab-first.md) — ADR: local-first approach

## Setup

- [setup/macos-agent-lab-user.md](setup/macos-agent-lab-user.md) — Create the agent-lab Mac user
- [setup/fedora-agent-lab-user.md](setup/fedora-agent-lab-user.md) — Create the agent-lab Fedora user
- [setup/SWITCHING-TO-AGENT-LAB.md](setup/SWITCHING-TO-AGENT-LAB.md) — Switch between accounts
- [setup/bootstrap-agent-lab.md](setup/bootstrap-agent-lab.md) — Bootstrap the agent environment
- [setup/install-claude-global-instructions.md](setup/install-claude-global-instructions.md) — Install global Claude instructions
- [setup/tool-installation-notes.md](setup/tool-installation-notes.md) — Tool installation notes
- [setup/SSH_TROUBLESHOOTING.md](setup/SSH_TROUBLESHOOTING.md) — SSH troubleshooting

## Historical

- [archive/README.md](archive/README.md) — What's archived and why
- [archive/phases/](archive/phases/) — Phase prompts and summaries (Phases 0–9)
- [archive/implementation-plan.md](archive/implementation-plan.md) — Original phased roadmap
- [archive/repository-structure.md](archive/repository-structure.md) — Early directory tree snapshot
- [archive/superpowers.md](archive/superpowers.md) — Pre-skills superpowers pattern guide
- [archive/operator-rules.md](archive/operator-rules.md) — Original operator rules (split into admin/)
