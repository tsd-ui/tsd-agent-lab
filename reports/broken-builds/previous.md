# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-27 |
| Host | ryordan-mac |
| User | agent-lab |
| Generated | 2026-07-27 06:00:25 |
| Status | 0 failures; 8 collection errors |

## Summary

No CI failures detected. All 8 monitored repos encountered collection errors when querying the GitHub API.

## Collection Issues

All repositories failed during data collection. This indicates a systemic problem with GitHub API access, not actual build failures.

### [securesign/rhtas-console dependency](https://github.com/securesign/rhtas-console)

> **Collection issue:** error — Failed to query repo API

### [securesign/rhtas-console-ui maintained](https://github.com/securesign/rhtas-console-ui)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/conforma-policy-test maintained](https://github.com/tsd-ui/conforma-policy-test)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/devtools maintained](https://github.com/tsd-ui/devtools)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-agent-lab maintained](https://github.com/tsd-ui/tsd-agent-lab)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui maintained](https://github.com/tsd-ui/tsd-ui)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui-plugin maintained](https://github.com/tsd-ui/tsd-ui-plugin)

> **Collection issue:** error — Failed to query repo API

### [tsd-ui/tsd-ui-template maintained](https://github.com/tsd-ui/tsd-ui-template)

> **Collection issue:** error — Failed to query repo API

---

## Next Steps

**Diagnosis** (model assessment)
- **Category:** config-error
- **Confidence:** confirmed
- **Root cause:** Repository identifiers in the configuration are malformed — they include metadata suffixes ("dependency", "maintained") appended to the org/repo format. GitHub API expects clean `org/repo` format, so queries like `securesign/rhtas-console dependency` fail. The default_branch field shows "unknown" for all repos, confirming the API queries never succeeded.
- **Suggested next step:** Fix the repository list configuration to use clean `org/repo` format (e.g., `tsd-ui/tsd-agent-lab` instead of `tsd-ui/tsd-agent-lab maintained`). If "dependency" and "maintained" are tracking labels, store them as separate metadata fields rather than suffixes to the repository identifier.
