# ADR 0001: Local Agent Lab First

## Status

Accepted

## Context

Our software engineering team wants to explore agentic SDLC workflows using AI coding assistants like Claude Code, Superpowers, and eventually OpenCode. However, we face several constraints:

- **Tool restrictions**: GitHub Copilot is not available to us
- **Multi-org reality**: We work across multiple GitHub organizations, not a single centralized org
- **Cloud caution**: We want to avoid GCP dependencies initially to keep infrastructure simple
- **Safety concerns**: Need to prevent accidental production impact, credential leakage, or policy violations
- **Team maturity**: This is exploratory work; we need to learn best practices before scaling

We need a safe, isolated environment to experiment with these tools and develop team practices.

## Decision

We will create a **local-first agent lab** with the following architecture:

### Core Principles

1. **Dedicated user isolation**: Run all agent experiments under a non-admin Mac user (or equivalent isolation mechanism)
2. **Human merge gate**: All pull requests require human review and approval
3. **No webhook triggers**: Avoid comment-triggered automation that could be abused
4. **Credential isolation**: Complete separation from production secrets and shared tokens
5. **Allowlist-based safety**: Explicit allowlists for repositories and commands
6. **Audit trails**: Comprehensive logging for review and learning

### Repository-Level Design

The `tsd-agent-lab` repository serves as:

- **Configuration hub**: Stores policies, allowlists, and safety rules
- **Documentation center**: ADRs, guides, threat model, operator rules
- **Experiment workspace**: Safe space for testing agent workflows
- **Knowledge base**: Lessons learned and team practices

### Phased Implementation

We will build this incrementally across 12+ phases:

- **Phase 0**: Discovery and safety boundaries (this phase)
- **Phase 1**: Dedicated local user setup
- **Phase 2-3**: Basic harness and instructions
- **Phase 4-5**: Runner mode and workflow experiments
- **Phase 6**: First real pilot task
- **Phase 7-8**: Controlled PR workflows
- **Phase 9-10**: Advanced experiments
- **Phase 11**: Team documentation
- **Phase 12**: Optional CI integration

### Technology Choices

- **Claude Code**: Primary tool (already available)
- **Superpowers**: Planned evaluation
- **OpenCode**: Future evaluation
- **Local execution**: Mac workstation with dedicated user
- **Git-based workflow**: Standard PR review process
- **YAML policies**: Simple, readable configuration

## Consequences

### Positive

- **Safe experimentation**: Isolated environment prevents production impact
- **Incremental learning**: Phased approach allows team to learn and adapt
- **Multi-org compatible**: Design works across our diverse GitHub org structure
- **Low infrastructure**: No cloud dependencies initially
- **Clear audit trail**: Logging and policies support review
- **Team ownership**: Repository-based design makes policies visible and versioned

### Negative

- **Manual overhead**: Human-in-loop requirement slows automation
- **Local scaling limits**: Single-user setup won't scale to full team immediately
- **Setup complexity**: Dedicated user and isolation requires initial configuration
- **Tool fragmentation**: Supporting multiple tools (Claude Code, Superpowers, OpenCode) adds complexity

### Risks and Mitigations

| Risk | Mitigation |
|------|------------|
| Agent uses production credentials | Dedicated user with isolated credential store |
| Agent makes unauthorized changes | Command and repository allowlists |
| Hidden long-running processes | Process monitoring and audit logs |
| Cross-org policy violations | Repository allowlist enforcement |
| Experiment escapes sandbox | Non-admin user permissions, clear boundaries |

## Alternatives Considered

### Cloud-based agent service

**Rejected**: Adds GCP dependency and operational overhead before we understand requirements.

### Single GitHub org focus

**Rejected**: Doesn't match our multi-org reality; would require significant org restructuring.

### Comment-triggered automation

**Rejected**: Opens abuse vectors and removes human review checkpoint.

### GitHub Copilot

**Not available**: Tool restriction from organization.

### Production environment testing

**Rejected**: Too risky for exploratory phase; lab isolation is essential.

## Notes

This ADR establishes the foundation. Subsequent ADRs will document decisions for specific phases (dedicated user setup, harness design, workflow patterns, etc.).

The lab is explicitly **not** a production service. Success criteria focus on learning and safe experimentation, not uptime or scale.

## References

- Phase 0 documentation: `docs/archive/phases/Phase-0-Prompt.md`
- Threat model: `docs/architecture/threat-model.md`
- Operator checklists: `docs/admin/operator-checklist.md`
