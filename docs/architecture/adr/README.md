# Architecture Decision Records

This directory contains Architecture Decision Records (ADRs) for the TSD Agent Lab.

## What is an ADR?

An ADR documents an important architectural decision along with its context and consequences. ADRs help future maintainers understand:
- Why we made certain choices
- What alternatives we considered
- What trade-offs we accepted
- When decisions become outdated

## Format

Each ADR follows this structure:

```markdown
# ADR NNNN: Title

## Status

Accepted | Superseded by ADR-XXXX | Deprecated

## Context

What is the issue we're facing? What constraints exist?

## Decision

What did we decide to do?

## Consequences

What are the positive and negative outcomes?

## Alternatives Considered

What other options did we evaluate and why were they rejected?

## Notes

Any additional context or future considerations.

## References

Links to related documents, discussions, or external resources.
```

## Naming Convention

- Use sequential numbers: `0001`, `0002`, `0003`, etc.
- Use descriptive titles: `0001-local-agent-lab-first.md`
- Date is implicit in git history

## When to Write an ADR

Write an ADR when you make a decision that:
- Is significant to the architecture
- Is hard to reverse
- Affects multiple parts of the system
- Has important trade-offs
- Future maintainers need to understand

Examples:
- Choosing dedicated user isolation over containers
- Deciding on policy file format (YAML vs JSON)
- Selecting audit log structure
- Determining merge workflow

## When NOT to Write an ADR

Skip the ADR for:
- Minor implementation details
- Easily reversible choices
- Obvious decisions
- Tactical code-level choices

## ADR Index

### Active ADRs

- [ADR 0001: Local Agent Lab First](0001-local-agent-lab-first.md) - Core architecture: local-first, human-in-loop, multi-tool evaluation
- [ADR 0002: RHTAS Console DB Removal — UI Impact](0002-rhtas-console-db-removal-ui-impact.md) - Impact assessment of database removal on Trust Coverage and System Health UI designs

### Superseded ADRs

(None yet)

### Future ADRs

Planned for upcoming phases:
- ADR 0002: Dedicated User Isolation Mechanism (Phase 1)
- ADR 0003: Policy Configuration Format (Phase 2)
- ADR 0004: Harness Architecture (Phase 3)
- ADR 0005: Workflow Definition Language (Phase 4)
- ADR 0006: Multi-Agent Comparison Framework (Phase 9)

## Process

### Creating a New ADR

1. Choose next sequential number
2. Create file: `NNNN-short-title.md`
3. Fill in all sections
4. Get team review
5. Update this index
6. Commit to main via PR

### Superseding an ADR

When a decision changes:
1. Create new ADR explaining the change
2. Update old ADR status: "Superseded by ADR-NNNN"
3. Link both directions
4. Don't delete old ADR (it's historical context)

### Reviewing ADRs

Review ADRs:
- After each major phase
- When making related decisions
- Before changing architecture
- During team onboarding

## Resources

- [ADR GitHub Organization](https://adr.github.io/)
- [ADR Tools](https://github.com/npryce/adr-tools)
- [Documenting Architecture Decisions](https://cognitect.com/blog/2011/11/15/documenting-architecture-decisions)

## Guidelines

### Be Honest

- Document actual reasons, not idealized ones
- Include political/organizational context if relevant
- Admit uncertainty where it exists

### Be Specific

- Name specific technologies, not categories
- Include version numbers where relevant
- Link to concrete examples

### Be Concise

- Aim for 1-2 pages
- Link to details rather than embedding
- Focus on "why" over "what"

### Be Forward-Looking

- Consider future implications
- Note what might change
- Identify review triggers

---

Last updated: 2026-06-12 (ADR 0001 created)
