# Lab Context: What You Need to Know

A single-file briefing on the TSD Agent Lab for humans and LLMs. Read this first; dig into the linked files when you need detail.

## What This Lab Is

A local experimentation environment for AI-assisted development. Agents (currently Claude Code) run under a dedicated non-admin Mac user (`agent-lab`) against allowlisted repositories. Every merge requires human review. There are no production credentials in the environment.

Current phase: **Phase 9 — Multi-agent comparison.** Draft PR mode (Phase 8) is complete: agents can deliver fixes as draft PRs for human review via an explicit operator command. See [README.md](../README.md) for the full phase list.

## Gotchas That Will Bite You

### 1. Write files in place — never copy-and-rename

Atomic copy-and-rename breaks Obsidian: the original inode disappears, so any open tab closes and the user loses scroll position and edit state. Write directly to the target file. This applies to all formats, not just Markdown.

> Detail: [policies/agent-conventions.md](../policies/agent-conventions.md)

### 2. Never run `claude auth login` or `gcloud auth login` on agent-lab

The agent-lab user authenticates via a shared GCP service account key (Vertex AI), scoped to the lab's GCP project. Running auth login would overwrite that with personal credentials and break isolation.

> Detail: [docs/architecture/safety-model.md](architecture/safety-model.md) §Credential Protection

### 3. LaunchAgents require a GUI login

macOS only fires LaunchAgents for users with an active GUI session. If the agent-lab user is only logged in via `su` or SSH, the daily report pipeline will not run. Use Fast User Switching to keep the session alive.

> Detail: [docs/admin/schedule.md](admin/schedule.md)

### 4. Kebab-case everything

All machine-generated names — tasks, runs, reports, skills, directories — use kebab-case. No spaces, underscores, or camelCase. Timestamps use `YYYY-MM-DD-HHMMSS` (local time, 24-hour).

> Detail: [policies/agent-conventions.md](../policies/agent-conventions.md)

### 5. Use `claude -p` for scripted invocations

Reserve interactive `claude` for human-in-the-loop sessions. All harness, cron, and automation scripts must use `claude -p` (print/pipe mode).

> Detail: [policies/agent-conventions.md](../policies/agent-conventions.md)

### 6. Do not event-enrol `tsd-agent-lab` itself

This repo is the control layer. Agents must not modify their own constraints via automated triggers. Read-only analysis is fine.

> Detail: [docs/admin/lab-strategy.md](admin/lab-strategy.md)

### 7. The repo auto-syncs every 10 minutes

A Sync & Push job (`com.tsd-agent-lab.sync-and-push`) commits and pushes changes on a 10-minute cycle. If you are editing files on the agent-lab user, expect your changes to be auto-committed. Work on a branch if you need isolation.

> Detail: [docs/admin/schedule.md](admin/schedule.md)

### 8. No force push, no auto-merge, no `sudo`

Force push and `git reset --hard` are blocked. Auto-merge is disabled. The agent-lab user has no admin privileges and cannot run `sudo`.

> Detail: [policies/default-policy.yaml](../policies/default-policy.yaml), [policies/command-allowlist.yaml](../policies/command-allowlist.yaml)

### 9. Markdown hygiene

Trim trailing whitespace on every line. End files with a single newline. No trailing spaces for line breaks — use `<br>` if truly needed (prefer restructuring instead).

> Detail: [policies/agent-conventions.md](../policies/agent-conventions.md)

### 10. SSH to agent-lab@localhost doesn't work reliably

macOS OpenSSH has issues with `publickey-hostbound-v00@openssh.com` on localhost. Use `sudo su - agent-lab` (aliased as `agent`) instead.

> Detail: [docs/setup/SSH_TROUBLESHOOTING.md](setup/SSH_TROUBLESHOOTING.md)

## Where to Look Next

### If you are a human

| Question | Start here |
|----------|-----------|
| First time using the lab | [docs/getting-started.md](getting-started.md) |
| How to switch to agent-lab user | [docs/setup/SWITCHING-TO-AGENT-LAB.md](setup/SWITCHING-TO-AGENT-LAB.md) |
| How to run a task end-to-end | [docs/guides/run-a-task.md](guides/run-a-task.md) |
| Pre-flight and post-flight checklists | [docs/admin/operator-checklist.md](admin/operator-checklist.md) |
| Something went wrong | [docs/admin/incident-response.md](admin/incident-response.md) |
| Full documentation map | [docs/README.md](README.md) |

### If you are an agent (LLM)

| Question | Read this file |
|----------|---------------|
| What rules apply to you | [AGENTS.md](../AGENTS.md) (imported by CLAUDE.md) |
| Naming, file ops, output quality | [policies/agent-conventions.md](../policies/agent-conventions.md) |
| What commands you can run | [policies/command-allowlist.yaml](../policies/command-allowlist.yaml) |
| What repos you can access | [policies/repo-allowlist.yaml](../policies/repo-allowlist.yaml) |
| Safety model and credential rules | [docs/architecture/safety-model.md](architecture/safety-model.md) |
| Default runtime policy | [policies/default-policy.yaml](../policies/default-policy.yaml) |
| Global Claude instructions | [docs/setup/global-CLAUDE.md](setup/global-CLAUDE.md) |
| Daily pipeline schedule | [docs/admin/schedule.md](admin/schedule.md) |

## Emergency Stop

```bash
# 1. Interrupt the running agent
Ctrl+C

# 2. Kill all agent-lab processes
killall -u agent-lab

# 3. Revoke GitHub access if needed
gh auth logout
```

Then review logs and follow [docs/admin/incident-response.md](admin/incident-response.md).
