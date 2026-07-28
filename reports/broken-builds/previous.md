# Broken Builds Report

| Field | Value |
|---|---|
| Date | 2026-07-28 |
| Host | agent-lab |
| User | agent-lab |
| Generated | 2026-07-28 05:00:05 |
| Status | 0 failure(s) — 8 repo(s) with collection errors |

## Summary

No CI failures detected. However, all 8 repositories encountered collection errors: "Failed to query repo API". This indicates a systemic issue with the data collector, not actual build failures.

## Collection Issues

All repositories failed during data collection with identical error messages:

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

**Diagnosis** (model assessment)

- **Category:** config-error
- **Confidence:** confirmed
- **Root cause:** The repository identifiers in the JSON data are malformed. Each repo name includes metadata suffixes ("dependency", "maintained") appended to the standard `org/repo` format (e.g., `securesign/rhtas-console dependency` instead of `securesign/rhtas-console`). GitHub API queries fail because these are not valid repository identifiers.
- **Suggested next step:** Fix the collector's repository list configuration to use clean `org/repo` format. If "dependency" and "maintained" are tracking labels or categories, store them as separate metadata fields in the configuration rather than suffixing them to the repository identifier.

**Evidence:** All repos show `default_branch: "unknown"`, indicating the collector couldn't retrieve even basic repository metadata — consistent with invalid repository names preventing API queries.
