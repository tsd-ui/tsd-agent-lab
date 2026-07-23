# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-23 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-23 06:00:27 |
| Status | Collection failed for 8 repo(s) |

## Summary

No build failures detected. All 8 repos encountered collection errors (failed to query repo API). This indicates an infrastructure or authentication issue with the GitHub Actions collector, not build failures.

## Collection Issues

### [securesign/rhtas-console dependency](https://github.com/securesign/rhtas-console dependency)

> **Collection issue:** error — Failed to query repo API

### [securesign/rhtas-console-ui maintained](https://github.com/securesign/rhtas-console-ui maintained)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/conforma-policy-test maintained](https://github.com/tsd-ui/conforma-policy-test maintained)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/devtools maintained](https://github.com/tsd-ui/devtools maintained)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-agent-lab maintained](https://github.com/tsd-ui/tsd-agent-lab maintained)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui maintained](https://github.com/tsd-ui/tsd-ui maintained)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui-plugin maintained](https://github.com/tsd-ui/tsd-ui-plugin maintained)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui-template maintained](https://github.com/tsd-ui/tsd-ui-template maintained)

> **Collection issue:** error — Failed to query repo API

---

**Collector Diagnosis** (model assessment)

- **Category:** infra-problem
- **Confidence:** probable
- **Root cause:** The GitHub Actions collector failed to query the GitHub API for all 8 repositories. This suggests either a GitHub API authentication failure (expired/invalid token), rate limiting, or network connectivity issue. The collector script likely encountered an error early in its execution that prevented it from fetching CI data for any repository.
- **Suggested next step:** Check the collector script logs for authentication errors. Verify the GitHub token is valid and has sufficient permissions (`repo` scope for private repos, `public_repo` for public). Check GitHub API rate limits. If the issue persists, run the collector manually with verbose logging to diagnose the root cause.

**Reproduction Status**
- Current occurrence (collection infrastructure failure)
