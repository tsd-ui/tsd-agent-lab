# ADR 0002: RHTAS Console Database Removal — UI Impact Assessment

## Status

Proposed

## Context

The RHTAS Console backend (`securesign/rhtas-console`) is removing its MariaDB/PostgreSQL database dependency, replacing it with TUF-native caching and an optional JSONL-based audit log for tracking target lifecycle events. This work is in progress on the `remove/DB` branch.

Concurrently, two new UI views are being designed for the frontend (`securesign/rhtas-console-ui`):

- **Trust Coverage** — a dashboard showing signing adoption metrics, certificate health, and target status breakdowns
- **System Health** — an operational health page showing Sigstore service statuses and availability metrics

This ADR assesses the impact of the database removal on these planned views and recommends whether to keep them as two separate pages or merge them into one.

### What the database stored

The `targets` table held these columns per TUF target:

| Column | Purpose |
|---|---|
| `target_name` | TUF target filename (e.g., `fulcio_v1.crt.pem`) |
| `type` | Target type (Fulcio, Rekor, CTFE, TSA) |
| `status` | Active, Expired, or **Revoked** |
| `content` | Full target content (PEM certificate data, public keys) |
| `repo_url` | Source TUF repository URL |
| `created_at` / `updated_at` | Timestamps for lifecycle tracking |

Critically, when a target was removed from TUF metadata, `syncDatabaseWithTargets` marked it as `status = 'Revoked'` but **preserved its content and metadata** in the database. This allowed the UI to display revoked targets with full detail.

### What replaces it

Post-removal, the backend relies on two data sources:

1. **TUF metadata cache** (native filesystem) — provides active/expired targets with full content.
2. **JSONL audit log** (optional, `--audit-log-path` flag) — records target lifecycle events with this schema:
   ```json
   {
     "timestamp": "2026-07-02T10:00:00Z",
     "event_type": "revoked",
     "repo_url": "https://tuf-repo.example.com",
     "target_name": "old_fulcio.crt.pem",
     "target_type": "Fulcio",
     "old_status": "Active"
   }
   ```

### Data availability comparison

| Data point | With DB | Post-removal (TUF + audit log) |
|---|---|---|
| Active target name, type, status | Yes | Yes (from TUF metadata) |
| Active target content (PEM/key) | Yes | Yes (from TUF cache) |
| Certificate expiration, issuer, subject | Yes (parsed from content) | Yes (parsed from content) |
| Revoked target name and type | Yes | Yes (from audit log) |
| Revoked target content | **Yes** (preserved in DB) | **No** — content is gone once removed from TUF |
| Revoked target timestamps | Yes (`updated_at`) | Yes (`timestamp` in audit log) |
| Historical status transitions | Partial (latest status only) | Yes (full event stream in audit log) |
| Aggregate counts by status | Yes (SQL `GROUP BY`) | Derivable (count TUF targets + audit log entries) |
| Time-series/trend data | No (DB had no history table) | Partially (audit log timestamps enable event timelines) |

### Current state of API endpoints and UI

**Endpoints relevant to the planned views:**

| Endpoint | Data source (post-removal) | UI hook exists? | Status |
|---|---|---|---|
| `GET /api/v1/trust/targets` | TUF metadata + cache | No | Returns active targets with content |
| `GET /api/v1/trust/targets/certificates` | TUF metadata, parsed | Yes | Returns certificate details (expiry, issuer, subject, status) |
| `GET /api/v1/trust/root-metadata-info` | TUF metadata (remote) | Yes | Returns root metadata versions |
| `GET /api/v1/trust/coverage` | **Mock data only** | No | Returns hardcoded `totalArtifacts=1000, attestedCount=610` |
| `GET /api/v1/system/health` | Kubernetes API (CRDs, deployments, probes) | No | Independent of DB — unaffected |

**The Trust Coverage endpoint is mock-only on both `main` and `remove/DB`.** It has never returned real data. The `GetTrustCoverage` function returns hardcoded values behind a `MOCK_MODE=true` gate and returns a 503 otherwise. The DB removal does not change this — it was always a stub.

**The System Health endpoint is DB-independent.** It reads Kubernetes CRD status (`securesigns`, `rekors`, `tufs`), deployment replica health, and probes the Rekor HTTP endpoint. The database removal has zero effect on this data source.

## Decision

### 1. Impact on Trust Coverage design

**Low-to-moderate impact.** The core metrics in the Trust Coverage PoC (`totalArtifacts`, `attestedCount`, `verifiedPercentage`, `attestedPercentage`) were never sourced from the database — they were always mock data. The DB removal does not remove any real data source for these metrics.

What **is** affected:

- **Revoked target display**: The PoC likely shows a breakdown of targets by status (Active/Expired/Revoked). Post-removal, revoked targets can still be listed (name, type, timestamp from the audit log), but their **content will be empty**. This is an acceptable trade-off: customers are primarily interested in active trust root material, and showing that a target was revoked (with when/what but not the expired certificate content) is sufficient for audit purposes.

- **Certificate health overview**: The existing Trust Root page already shows certificate health via the `/trust/targets/certificates` endpoint, which parses active certificates from TUF. This is unaffected. A donut chart of Active/Expiring/Expired status continues to work. Revoked certificates simply won't appear in the certificate table (they are no longer in TUF metadata) but would appear in an audit trail section.

- **Aggregate artifact counts**: The `totalArtifacts` and `attestedCount` fields in `TrustCoverageResponse` would need a real data source regardless of the DB. These are conceptually different from TUF target counts — they measure how many container images/SBOMs have been signed, not how many signing certificates exist. This was always a gap.

### 2. Impact on System Health design

**No impact.** The System Health PoC relies on:
- Kubernetes CRD status checks (Securesign, Rekor, TUF operator readiness)
- Deployment replica counts and health
- HTTP health probes against Rekor

None of these involve the database. The `SystemHealthResponse` schema (`sigstoreServices`, `rekorStatus`, `tufStatus`, `updatedAt`) is fully served by the existing `health.go` service, which queries the Kubernetes API.

### 3. Keep two separate views or merge?

**Recommendation: keep two separate views.**

The two views serve different audiences and update at different cadences:

| Dimension | Trust Coverage | System Health |
|---|---|---|
| Audience | Security/compliance teams, developers | Platform operators, SREs |
| Question answered | "What is the state of our signing trust material?" | "Are the Sigstore services operational right now?" |
| Data source | TUF metadata (minutes-to-hours cadence) | Kubernetes API (seconds cadence, real-time) |
| Update frequency | Changes when certificates rotate or are revoked (rare) | Changes when pods restart, services degrade (continuous) |
| Action triggered | Certificate renewal, trust root rotation | Incident response, deployment rollback |

Merging them would create a page that tries to serve two distinct workflows and would clutter the operational signal (which needs to be glanceable) with slower-moving trust metadata context.

However, the existing **Trust Root** page (`/trust-root`) already shows much of what Trust Coverage would display:
- Certificate table with status (Active/Expiring/Expired), expiration, issuer, subject, PEM content
- Root metadata versions and their status
- Certificate health donut chart (in the Overview tab)

The Trust Coverage view's unique additions beyond the existing Trust Root page are:
- Aggregate artifact verification metrics (signed/attested counts) — **still mock-only, no real data source**
- Revoked target history — **newly available from the audit log, but with limited detail**
- Trend data — **partially derivable from audit log timestamps**

Given that the unique Trust Coverage data (artifact verification metrics) has no real backend implementation regardless of the DB, the pragmatic path forward is to **enhance the existing Trust Root page** with an audit trail tab showing target lifecycle events from the audit log, rather than building a separate Trust Coverage page that would be mostly duplicate or mock data.

## Consequences

### Positive

- System Health page can proceed as designed — zero DB dependency, zero impact.
- The existing Trust Root page already handles certificate health display for active targets.
- The audit log provides richer lifecycle history (event stream with timestamps) than the DB ever did (which only stored latest status).
- Simpler deployment: no database means one fewer service to operate.

### Negative

- Revoked targets lose their content (PEM data, public keys). Once removed from TUF, only the name, type, and revocation timestamp remain via the audit log. Customers cannot download or inspect revoked certificates after revocation.
- The audit log is optional (`--audit-log-path`). If not configured, there is no revocation history at all. The UI must handle this gracefully (hide or grey out the audit trail section).
- Aggregate artifact verification metrics (`totalArtifacts`, `attestedCount`) remain unimplemented. Building Trust Coverage as a standalone page would require a new data source (possibly Rekor log queries or an external metrics pipeline) regardless of the DB decision.
- The audit log file is append-only with no built-in rotation or size management. Long-running deployments could accumulate large audit files.

## Alternatives Considered

### Merge both views into a single "Dashboard" page

**Not recommended.** The audiences and data cadences differ too much. Operators need a fast, glanceable health status; security teams need detailed certificate and trust material information. A combined page would be noisy for both.

### Build Trust Coverage as a fully separate page with mock data

**Not recommended yet.** The backend has no real implementation for artifact verification metrics. Building a UI page around mock data creates a maintenance burden and user confusion. Better to wait until the backend can provide real coverage metrics (e.g., from Rekor log aggregation).

### Add a lightweight SQLite or embedded DB for revoked target content

**Rejected for now.** This reintroduces database complexity. The audit log approach is simpler and the loss of revoked target content is an acceptable trade-off per team consensus. Could be revisited if customer feedback demands it.

### Enhance the audit log to snapshot target content at revocation time

**Worth considering.** When `trackTargetChanges` detects a revocation, it could fetch and store the target's content in the audit event before the old updater is replaced. This would preserve revoked content without a database. Trade-off: larger audit log file size. This is a moderate implementation effort and could be a follow-up.

## Notes

- The `GetTrustCoverage` endpoint returns mock data on both `main` and `remove/DB`. The DB removal is not the reason this data is unavailable — it was never implemented.
- The `GetTrustConfig` endpoint is also a stub returning hardcoded data. The existing UI hook (`useFetchTrustConfig`) exists but is unused.
- The Rekor service (`rekor.go`) has unimplemented methods (`GetRekorEntry`, `GetRekorPublicKey`) that return stubs. These are unrelated to the DB removal but relevant context for the System Health and Trust Coverage designs.
- The Monitoring page in `rhtas-console-ui` is feature-flagged (`FEATURE_MONITORING=on`) and currently renders only an empty placeholder. It could serve as the home for System Health, but this is a product decision.

## References

- Backend codebase map: generated 2026-07-02 via `codebase-map` skill
- Frontend codebase map: generated 2026-07-02 via `codebase-map` skill
- DB removal branch: `securesign/rhtas-console` branch `remove/DB`
- Trust Coverage PoC: `pankajshivpuje.github.io/rhtas-console-ui/dashboard`
- System Health PoC: `pankajshivpuje.github.io/rhtas-console-ui/operational-health`
- DB schema: `internal/db/migrations/{mysql,postgres}/001_create_targets_table.up.sql`
- Audit log implementation: `internal/services/audit_log.go` (on `remove/DB` branch)
