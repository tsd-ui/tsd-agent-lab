# ADR 0002: RHTAS Console DB Removal — UI Impact Assessment

## What was created

- **ADR file**: `docs/architecture/adr/0002-rhtas-console-db-removal-ui-impact.md`
- **ADR index updated**: `docs/architecture/adr/README.md`

## Summary

ADR 0002 assesses the impact of removing MariaDB/PostgreSQL from `securesign/rhtas-console` on two planned UI views: Trust Coverage and System Health.

### Key findings

1. **System Health page: zero impact.** It reads from the Kubernetes API (CRD status, deployment health, Rekor probes) — no database involvement.

2. **Trust Coverage page: low-to-moderate impact.** The core coverage metrics (`totalArtifacts`, `attestedCount`, `verifiedPercentage`) were never real — they were mock data behind a `MOCK_MODE=true` gate on both the `main` and `remove/DB` branches. The DB removal doesn't remove a real data source for these.

3. **Revoked targets lose content.** With the DB, revoked targets kept their full PEM/key content and remained queryable. Post-removal, revoked targets only appear in the optional JSONL audit log with name, type, and timestamp — no content. This is the one material data loss.

4. **Recommendation: keep two separate views** (Trust Coverage vs. System Health) because they serve different audiences (security/compliance vs. SRE) and data cadences (minutes-to-hours vs. seconds). However, Trust Coverage should enhance the existing Trust Root page rather than be built as a standalone page, since its unique data (artifact verification metrics) has no real backend implementation.

### Open questions

- Should the audit log snapshot target content at revocation time? This would preserve revoked certificate data without a database (moderate implementation effort).
- When will real artifact verification metrics (`totalArtifacts`, `attestedCount`) be implemented? This blocks any meaningful Trust Coverage dashboard beyond what the Trust Root page already shows.
- Is the audit log (`--audit-log-path`) opt-in acceptable, or should it be on by default?
