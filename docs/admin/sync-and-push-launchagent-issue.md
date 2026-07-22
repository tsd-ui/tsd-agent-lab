# sync-and-push LaunchAgent — bootout not taking (known issue)

**Status:** open · **First observed:** 2026-07-22 · **Owner:** operator (needs foreground desktop)

## Symptom

`launchctl bootout` of `com.tsd-agent-lab.sync-and-push` appears to succeed but the
agent keeps firing on its 600s `StartInterval`. Confirmed by
`logs/sync-and-push.log` showing runs on a clean, unbroken cadence across multiple
bootout attempts:

```
13:00:58  === sync-and-push started ... ===
13:10:58  === sync-and-push started ... ===
13:20:58  === sync-and-push started ... ===
```

The `:58` offset never shifts — a successful unload + later reload would move it —
so the loaded job was **never actually removed** by the attempts. Bootout was run
from agent-lab's **foreground desktop** (fast-user-switched, Terminal.app as
agent-lab, uid 502) and **without** a `bootstrap` afterward, yet the cadence
continued.

## Root cause found: installed plist ≠ loaded job (drift)

There are **two different definitions** of this agent, and the one launchd is
running is **not** the file currently in `~/Library/LaunchAgents/`:

| | Installed (`~/Library/LaunchAgents/com.tsd-agent-lab.sync-and-push.plist`) | Repo (`scripts/macos/com.tsd-agent-lab.sync-and-push.plist`) |
|---|---|---|
| Program | `scripts/macos/sync-and-push.sh` (direct) | `automations/bin/run-automation sync-and-push` |
| `UserName` | — | `agent-lab` |
| `WorkingDirectory` | — | repo root |
| `RunAtLoad` | true | true |
| `StartInterval` | 600 | 600 |

**Proof the loaded job is the repo/`run-automation` variant:** the log's
`=== sync-and-push started at <ISO-UTC> ===` / `=== ... finished ... ===` wrapper
lines are emitted by `automations/bin/run-automation` (see lines ~145/151), **not**
by `sync-and-push.sh` (which only logs `--- sync started ---` and `SKIP:` lines).
So whatever was bootstrapped into launchd came from the `run-automation` plist,
while the file now sitting in `~/Library/LaunchAgents/` is the older direct-script
variant. Editing/booting-out based on the installed file operates on the wrong
definition.

## Domain

The job is **not** in `user/502` and is invisible to `launchctl list` from an
SSH/tty session (`Could not find service ... in domain for uid: 502`). It lives in
the **`gui/502` (Aqua) domain**, addressable only from agent-lab's foreground
desktop. From any non-GUI session, `launchctl print gui/502/...` returns
`125: Domain does not support specified action` — this is *domain-not-addressable*,
not a permissions error, so `sudo` does not help and neither does running as
`ryordan` (uid 501, wrong owner).

## Why the foreground bootout still didn't take (hypotheses, unverified)

1. **Label/domain the operator booted out ≠ where the job actually lives.** Worth
   dumping the live definition first: from the foreground desktop,
   `launchctl print gui/$(id -u)/com.tsd-agent-lab.sync-and-push` and read its
   `program`/`arguments` + `path` to confirm which variant and domain are loaded.
2. **A re-bootstrapper.** `run-automation` and/or `daily-command-center.sh`
   (`com.tsd-agent-lab.command-center`) may re-install/reload the automation
   agents. The steady `:58` cadence argues against a *recent* reload, but grep
   these for `launchctl bootstrap`/`load`/`enable` before the next attempt.
3. **Not disabled.** Even a clean bootout is undone at next login / `RunAtLoad`
   unless the service is also `disable`d.

## Current mitigation (in place, safe)

Paused via the script's own guard, not launchctl: a **non-empty git stash** trips
`sync-and-push.sh`'s `SKIP: stash is non-empty` branch (guards, before any
fetch/commit/push). Every tick since 2026-07-22 12:40 has logged `SKIP` — **zero
commits, zero pushes**. The stash (`stash@{0}: pause-auto-sync ...`) holds only
disposable runtime churn.

- **Keep it in place** to stay paused.
- **To resume:** `git stash drop stash@{0}` (drop, *not* pop — the snapshot is
  stale runtime state), the agent resumes on its next tick.

## Recommended fix (next attempt, from agent-lab foreground desktop)

```bash
# 1. Inspect what is actually loaded (only works from the GUI session)
launchctl print gui/$(id -u)/com.tsd-agent-lab.sync-and-push

# 2. Disable (persists across logins/RunAtLoad), then remove
launchctl disable gui/$(id -u)/com.tsd-agent-lab.sync-and-push
launchctl bootout  gui/$(id -u)/com.tsd-agent-lab.sync-and-push

# 3. Verify it's gone
launchctl print gui/$(id -u)/com.tsd-agent-lab.sync-and-push   # expect: Could not find service
```

Then watch `logs/sync-and-push.log` for ~11 min: **no new `=== started ===`
marker = success**. Do **not** run `bootstrap`/`load` afterward.

Re-enable later: `launchctl enable gui/$(id -u)/com.tsd-agent-lab.sync-and-push`
then `launchctl bootstrap gui/$(id -u) <plist>`.

## Follow-up cleanup (separate task)

Reconcile the plist drift: decide the canonical definition (the `run-automation`
variant appears to be what's actually used) and make `~/Library/LaunchAgents/` match
the repo copy, so future bootstrap/bootout/disable act on a known definition.
Consider also gitignoring `automations/runtime/` (status/lock churn there is what
generates the `chore(auto-sync)` noise in the first place).
