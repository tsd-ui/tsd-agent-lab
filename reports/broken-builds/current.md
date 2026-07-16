Report written to `reports/broken-builds/current.md`.

**Summary:** 10 failures across 3 repos (down from 20 across 5 in the prior report — securesign/rhtas-console and tsd-ui/tsd-ui-team-docs are now clear). All failures are recurring from the 2026-07-13 report. 5 top actions identified:

1. **tsd-ui/tsd-ui** — npm publish token needs 2FA bypass (confirmed)
2. **tsd-ui/tsd-ui** — workspace dependencies need to be published or switched to `workspace:*` (confirmed)
3. **securesign/rhtas-console-ui** — Docker Hub connectivity timeout (confirmed, likely transient)
4. **securesign/rhtas-console-ui** — GitHub Pages deployment queue stuck (probable)
5. **securesign/rhtas-console-ui** — Flaky Playwright e2e tests (probable)

The conforma-policy-test triage token failures remain undiagnosable due to truncated logs (insufficient-evidence).
