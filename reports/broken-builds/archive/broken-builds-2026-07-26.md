## Report Complete

**Status:** 0 CI failures, 8 collection errors

The broken-builds data bundle shows a complete collector infrastructure failure. All 8 monitored repos returned "Failed to query repo API" errors, indicating the GitHub Actions collector cannot access the GitHub API.

**Root cause:** Repository identifiers in the configuration are malformed — they include metadata suffixes ("dependency", "maintained") appended to the org/repo format, causing the GitHub API queries to fail.

**Next action:** Fix the repository list configuration to use clean `org/repo` format (e.g., `tsd-ui/tsd-agent-lab` instead of `tsd-ui/tsd-agent-lab maintained`). If "dependency" and "maintained" are tracking labels, store them separately from the repository identifier.

Report written to `reports/broken-builds/current.md`.
