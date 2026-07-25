## Report Complete

**Status:** 0 CI failures, 8 collection errors

The broken-builds data bundle shows a complete collector infrastructure failure. All 8 monitored repos returned "Failed to query repo API" errors, indicating the GitHub Actions collector cannot access the GitHub API.

**Root cause:** Missing or expired GitHub authentication token (confirmed)

**Next action:** Fix the collector's `GITHUB_TOKEN` configuration before the next automated run.

Report written to `reports/broken-builds/current.md`.
