# Broken Builds Report Summary

**Status:** 0 CI build failures detected (8 collection errors)

**Diagnosis:** Complete collector infrastructure failure. All 8 monitored repos returned "Failed to query repo API" errors. This is an infra-problem with probable confidence.

**Root cause:** The GitHub Actions collector script cannot access the GitHub API, most likely due to a missing or expired `GITHUB_TOKEN` environment variable.

**Next action:** Fix the collector's GitHub authentication before the next automated run.

Report written to `reports/broken-builds/current.md`.
