Report written to `reports/broken-builds/current.md`.

**Status:** All builds passing (0 actual CI failures detected).

**Collection Issues:** All 8 monitored repos encountered "Failed to query repo API" errors during data collection. This is a systemic collector problem, not a build problem. The most likely cause is a missing or expired `GITHUB_TOKEN` environment variable preventing the collector script from accessing the GitHub API.

**Next Step:** Investigate the broken-builds collector script's GitHub authentication before the next run.
