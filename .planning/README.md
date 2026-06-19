# Agent Workflow — Nexus

## Four-agent orchestra (V2+)

Symbiotic development with explicit handoff artifacts:

```
Orchestrator (you)
    → Architect  → ARCHITECT-BRIEF.md
    → Planner    → PHASE-PLAN.md (allowlist + APPROVED_TO_BUILD)
    → Coder      → code + CODER-CHANGELOG.md
    → QA         → QA-REPORT.md (PASS/FAIL)
```

**Playbooks:** [.planning/agents/](./agents/)

| Command | Purpose |
|---------|---------|
| `npm run orchestrator:status` | Print active milestone STATUS.md |

**Active milestone:** [milestones/v2-tier-1/](./milestones/v2-tier-1/) — Phase 0 approved for Coder.

## Legacy three-agent cycle (V1 waves)

1. **Overseer** (= Planner) — `.planning/waves/wave-{N}/OVERSEER.md`
2. **Coder** — implementation
3. **QA** — `.planning/waves/wave-{N}/QA-REPORT.md`

## Templates

- [ARCHITECT-BRIEF.md](./templates/ARCHITECT-BRIEF.md)
- [PHASE-PLAN.md](./templates/PHASE-PLAN.md)
- [CODER-CHANGELOG.md](./templates/CODER-CHANGELOG.md)
- [OVERSEER.md](./templates/OVERSEER.md) (legacy)
- [QA-REPORT.md](./templates/QA-REPORT.md)

## CI gates

```bash
npm run lint
npm run typecheck
npm test
npm run test:scope-check
npm run build
```

## Scope check

`scripts/scope-check.ts` blocks V2 routes until Planner allowlists them per phase.
