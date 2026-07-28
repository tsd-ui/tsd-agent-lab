## Report Complete

**Status:** 0 CI failures, 8 collection errors

The broken-builds data bundle shows a complete collector infrastructure failure. All 8 monitored repos returned "Failed to query repo API" errors.

**Root cause:** Repository identifiers in the configuration are malformed — they include metadata suffixes ("dependency", "maintained") appended to the org/repo format, causing GitHub API queries to fail (e.g., `securesign/rhtas-console dependency` instead of `securesign/rhtas-console`).

**Next action:** Fix the repository list configuration to use clean `org/repo` format. If "dependency" and "maintained" are tracking labels, store them as separate metadata fields rather than suffixes to the repository identifier.

Report written to `reports/broken-builds/current.md`.
