---
aliases: 
tags: 
---
# TSD Agent Lab Strategy

Summarized from the full planning document. See the original for detailed rationale and [Fullsend documentation](https://github.com/fullsend-ai/fullsend/tree/main/docs) references.

## Core Principle

**Fullsend-first, but not Fullsend-everywhere yet.** As of 2026-06-11, anyone who can comment on a public repository can trigger an agent. Public repos stay local-only until authorization guardrails ship and are verified.

## Three Lanes

| Lane | Repositories | Runtime | Purpose |
|------|-------------|---------|---------|
| Hosted Fullsend pilot | One dedicated private test repo | GCP mint + GitHub Actions | Exercise complete issue-to-agent-to-PR lifecycle |
| Local Fullsend evaluation | Selected public team repos | Mac lab, manually triggered | Test Fullsend against real code without public triggers |
| Interactive experimentation | Selected repos | Claude Code / Codex / Gemini | Learn effective human-agent workflows, compare results |

## Key Decisions

1. **Do not event-enrol `tsd-agent-lab`.** It is the control layer -- agents must not modify their own constraints.
2. **Do use Fullsend locally** to review or evaluate `tsd-agent-lab` (read-only analysis).
3. **Do not event-enrol public repositories** until authorization guardrails are available and verified.
4. **Do manually run local Fullsend** against selected public repositories.
5. **Use one private test repository** for the complete hosted Fullsend lifecycle.
6. **Keep interactive tools (Claude Code, Superpowers)** as the interactive alternative.
7. **Defer LangGraph / custom orchestration** unless building orchestration is itself an explicit experiment.

## Repository Responsibilities

| Location | Purpose |
|----------|---------|
| `tsd-agent-lab` | Control repo: architecture, onboarding, shared templates, experiments, evaluations, operating docs |
| Target repo `.fullsend/` | Repo-specific Fullsend installation and customizations |
| Target repo `AGENTS.md` | Build commands, test procedures, architectural constraints, repo-specific instructions |
| GCP project | Mint, Workload Identity Federation, Secret Manager, inference permissions |
| Mac lab account | Local runtime, disposable workspaces, caches, containers, local services |

## Architecture

```
tsd-agent-lab (governance, templates, experiments)
    ├── Local Mac lab (interactive and experimental execution)
    │     ├── Target repo A
    │     └── Target repo B
    └── GCP Fullsend infrastructure (mint + WIF + inference)
          ├── Target repo B
          └── Target repo C
```

Per-repo Fullsend installation (`fullsend admin install ORG/REPO`) is preferred over org-wide installation, since the team works across repos in different organizations.

## Team Access Model

**Lab users** -- request agent runs, view logs/results, cancel own jobs, propose repo instructions. No shell access needed.

**Repository owners** -- propose onboarding via PR with an `AgentRepository` manifest specifying permissions, constraints, and validation commands.

**Lab operators** (small group) -- update runtime, rotate credentials, manage budgets, approve write-capable onboarding, administer GCP mint.

Team interaction should go through PRs/issues in `tsd-agent-lab` and a `labctl` CLI or web interface -- not shared SSH access.

## Security Boundaries for Public Repos

Before public enrolment, verify:
- External/first-time/bot commenters cannot trigger runs
- Each command has a role-based allowlist
- Concurrency and spend limits exist
- GitHub App is installed only on selected repos
- Emergency kill switch works

For local evaluation of public repos: use disposable clones, `--no-post-script`, minimum token permissions, human inspection of generated patches, and destroy worktrees after each run.

## Agent Access to `tsd-agent-lab` Itself

Once the lab is mature, agents may propose changes to low-risk areas:

```
/docs/**              Agent PRs allowed
/experiments/**       Agent PRs allowed
/evaluations/**       Agent PRs allowed

/policies/**          Human-only approval
/environments/**      Human-only approval
/bootstrap/**         Human-only approval
/scripts/admin/**     Human-only approval
/.fullsend/**         Human-only approval
```

## The Mac Lab's Value

The local lab is the **team's agent engineering workshop** -- not "Fullsend, but on a laptop." It provides interactive experimentation, fast edit-run-inspect loops, multi-framework comparison, and works when org-level permissions or GCP IAM are blocked. Anything that proves useful locally should be expressed as version-controlled config so it can move to the hosted platform.
