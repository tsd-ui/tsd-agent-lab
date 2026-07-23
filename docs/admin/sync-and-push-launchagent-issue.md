# sync-and-push LaunchAgent — bootout not taking (RESOLVED)

**Status:** resolved · **First observed:** 2026-07-22 · **Resolved:** 2026-07-23

## TL;DR

The earlier diagnosis was wrong. The job that keeps firing is **not** a per-user LaunchAgent in the `gui/502` (Aqua) domain — it is a **system `LaunchDaemon`** at `/Library/LaunchDaemons/com.tsd-agent-lab.sync-and-push.plist`, loaded in the `system` domain. Every `bootout` attempt failed because it targeted the wrong domain (`gui/502` / the foreground desktop), and booting out a service that does not exist in the addressed domain is a **silent no-op** — which is exactly why the `:58` cadence never shifted.

There is **no drift** between the running job and the repo: the loaded daemon is byte-identical to `scripts/macos/com.tsd-agent-lab.sync-and-push.plist`. The only mess was a set of **stale `~/Library/LaunchAgents/` leftovers** from the pre-migration LaunchAgent setup, which have now been deleted.

## Symptom (original)

`launchctl bootout` of `com.tsd-agent-lab.sync-and-push` appeared to succeed but the agent kept firing on its 600s `StartInterval`, with an unbroken `:58` cadence in `logs/sync-and-push.log`.

## Root cause (corrected)

The automation suite was migrated to **system LaunchDaemons on 2026-07-21** (see `automations/bin/lab-jobs` `cmd_install_script`, which renders each job and installs it with `sudo launchctl bootstrap system …`). After that migration:

- The **live job** is `system/com.tsd-agent-lab.sync-and-push`, backed by `/Library/LaunchDaemons/com.tsd-agent-lab.sync-and-push.plist` (owned `root:wheel`), running the `automations/bin/run-automation sync-and-push` variant. `launchctl print system/com.tsd-agent-lab.sync-and-push` confirms `domain = system`, `type = LaunchDaemon`.
- The `~/Library/LaunchAgents/com.tsd-agent-lab.*.plist` files (dated 16 Jul, direct-`sync-and-push.sh` variant) were **leftovers from the old LaunchAgent setup**. They were never loaded after the migration — nothing in `user/502`, nothing in `launchctl list`, and the log only ever shows the `run-automation` `=== started ===` wrapper (never the bare `--- sync started ---` a direct-script LaunchAgent would emit). Comparing that stale file against the running daemon is what produced the bogus "installed ≠ loaded = drift" conclusion.

### Why the domain probing was misleading

From an SSH / `Background` session (`launchctl managername` → `Background`), `launchctl print gui/502/…` returns `125: Domain does not support specified action`. That is **domain-not-addressable from a non-GUI session**, not evidence the job lives in `gui/502`. The job was in `system` the whole time; `system` *is* addressable from any session (with `sudo`), which is how it was finally identified:

```
launchctl print system/com.tsd-agent-lab.sync-and-push   # → domain = system, path = /Library/LaunchDaemons/...
```

## Correct commands (system domain, require sudo)

Stop the job (persisted across reboot):

```bash
sudo launchctl bootout  system/com.tsd-agent-lab.sync-and-push
sudo launchctl disable  system/com.tsd-agent-lab.sync-and-push
```

Reload after editing `/Library/LaunchDaemons/com.tsd-agent-lab.sync-and-push.plist`:

```bash
sudo launchctl bootout   system/com.tsd-agent-lab.sync-and-push 2>/dev/null || true
sudo launchctl bootstrap system /Library/LaunchDaemons/com.tsd-agent-lab.sync-and-push.plist
```

Trigger a run immediately:

```bash
sudo launchctl kickstart -k system/com.tsd-agent-lab.sync-and-push
```

The old, failing incantation was `launchctl bootout gui/$(id -u)/com.tsd-agent-lab.sync-and-push` — **wrong domain, no sudo**. Do not use it.

## Pause mechanism (still valid)

Stopping the daemon is heavy-handed. To pause without touching launchd, use the script's own guard: a **non-empty git stash** trips `sync-and-push.sh`'s `SKIP: stash is non-empty` branch before any fetch/commit/push. Create a throwaway stash to pause; `git stash drop` to resume on the next tick. This is what was used on 2026-07-22 and dropped on 2026-07-23 to resume.

## Cleanup done (2026-07-23)

- Deleted all six stale `~/Library/LaunchAgents/com.tsd-agent-lab.*.plist` leftovers (`sync-and-push`, `command-center`, `health-report`, `broken-builds`, `stale-docs-check`, `stale-docs-check-full`). The system daemons in `/Library/LaunchDaemons/` are the single source of truth and were untouched.
- Verified the loaded `sync-and-push` daemon is byte-identical to the repo copy `scripts/macos/com.tsd-agent-lab.sync-and-push.plist`.

## Follow-up (optional)

Consider gitignoring `automations/runtime/` — the status/lock churn there is what generates the `chore(auto-sync)` commit noise.
