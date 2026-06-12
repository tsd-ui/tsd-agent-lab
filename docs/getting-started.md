# Getting Started

Quick start guide for the TSD Agent Lab.

## Current Status

**Phase**: 0A - Initial Lab Plan Complete

**Next Phase**: 0B - Threat Model Hardening

## Prerequisites

Before using the lab, ensure you have:

- [ ] Claude Code access and license
- [ ] Mac workstation (macOS 11.0+)
- [ ] GitHub account with appropriate org access
- [ ] Git command-line tools installed
- [ ] Admin access for initial setup (Phase 1)
- [ ] Understanding of basic Git workflows

## Phase 0A Completion

Phase 0A has created the foundational documentation:

### Created Files

- `README.md` - Main repository overview
- `docs/adr/0001-local-agent-lab-first.md` - Architecture decision
- `docs/implementation-plan.md` - Phased development plan
- `docs/safety-model.md` - Security and safety controls
- `docs/assumptions-and-non-goals.md` - Scope boundaries
- `docs/repository-structure.md` - Repository organization
- This getting started guide

### Repository Structure

```
tsd-agent-lab/
├── docs/              # Documentation
│   ├── adr/          # Architecture decisions
│   └── ...
├── policies/         # Safety policies (Phase 0B)
├── experiments/      # Experimental workspace
└── logs/            # Audit trail
```

## Next Steps (Phase 0B)

Before you can run experiments, complete Phase 0B:

1. **Review Current Documentation**
   - Read `README.md`
   - Review `docs/safety-model.md`
   - Understand `docs/adr/0001-local-agent-lab-first.md`

2. **Create Threat Model**
   - Create `docs/threat-model.md`
   - Identify specific threats for your environment
   - Document mitigations and controls

3. **Define Policies**
   - Create `policies/default-policy.yaml`
   - Create `policies/command-allowlist.yaml`
   - Create `policies/repo-allowlist.example.yaml`
   - Customize for your organization

4. **Write Operator Rules**
   - Create `docs/operator-rules.md`
   - Document procedures and guidelines
   - Include emergency procedures

## Future Phases (Quick Overview)

### Phase 1: Dedicated User Setup
- Create non-admin Mac user for agent execution
- Configure credential isolation
- Test isolation boundaries

### Phase 2: Configuration
- Set up `.claude/` configuration
- Write `CLAUDE.md` instructions
- Prepare for Superpowers

### Phase 3: Local Harness
- Build runner scripts
- Implement policy enforcement
- Add logging infrastructure

### Phases 4-12
See `docs/implementation-plan.md` for full details.

## Key Principles to Remember

1. **Safety First**: All experiments must follow safety policies
2. **Human in Loop**: Every merge requires human review
3. **Isolated Environment**: No production access from agent user
4. **Audit Everything**: Comprehensive logging required
5. **Learn by Doing**: Expect and document failures

## Common Questions

### Can I use this for production work?

No. This is a prototype lab for experimentation only. Production workflows are separate.

### What if I need access to a repository not on the allowlist?

Update `policies/repo-allowlist.yaml` and get team review before adding.

### What if an experiment fails?

Document it! Failures are valuable learning. Write up what happened in the experiment README.

### Can I skip safety checks for quick tests?

No. Safety controls exist for good reasons. If they're blocking you, understand why and update policies thoughtfully.

### How do I share my experiment results?

Update your experiment's README, mention in team chat/meeting, and link from relevant documentation.

## Getting Help

- **Documentation Issues**: Check `docs/` directory first
- **Policy Questions**: Review `policies/` and safety model
- **Technical Problems**: Check logs in `logs/` directory
- **Team Questions**: Discuss in team channel/meeting

## Contributing

1. Work on a feature branch
2. Make changes
3. Update relevant documentation
4. Create PR to `main`
5. Get team review
6. Merge after approval

All changes to `main` require pull request review.

## Useful Commands

### Repository Navigation

```bash
# View repository structure
tree -L 2 -a

# Find documentation
find docs -name "*.md"

# View ADRs
ls docs/adr/
```

### Future Phases

```bash
# Run experiment (Phase 5+)
cd experiments/my-experiment
./run.sh

# Execute workflow (Phase 4+)
bin/agent-run workflow-name

# View logs (Phase 3+)
tail -f logs/$(date +%Y-%m)/$(date +%Y-%m-%d)-session-001.log
```

## Important Files

| File | Purpose |
|------|---------|
| `README.md` | Main repository overview |
| `docs/implementation-plan.md` | Phased development plan |
| `docs/safety-model.md` | Security controls |
| `docs/threat-model.md` | Threat analysis (Phase 0B) |
| `docs/operator-rules.md` | Operating procedures (Phase 0B) |
| `docs/adr/` | Architecture decisions |

## Status Tracking

Current phase completion status:

- [x] **Phase 0A**: Initial Lab Plan - COMPLETE
- [ ] **Phase 0B**: Threat Model Hardening - NEXT
- [ ] **Phase 1**: Dedicated User Setup
- [ ] **Phase 2**: Configuration
- [ ] **Phase 3**: Local Harness
- [ ] **Phases 4-12**: See implementation plan

## Stay Updated

Review these documents as the lab evolves:
- `docs/implementation-plan.md` for phase status
- `docs/adr/` for architecture decisions
- `CHANGELOG.md` for notable changes (if created)

---

Welcome to the TSD Agent Lab! Start with Phase 0B when ready.
