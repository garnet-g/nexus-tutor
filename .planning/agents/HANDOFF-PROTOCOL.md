# Agent Handoff Protocol

All agents communicate through **versioned markdown artifacts**. No handoffs via chat memory alone.

## Required headers (every artifact)

```markdown
---
milestone: v2-tier-1
phase: 2.1 | null
agent: architect | planner | coder | qa
version: 1
status: DRAFT | APPROVED | PASS | FAIL
supersedes: null | path/to/prior.md
inputs:
  - path/to/doc.md
outputs:
  - path/to/artifact.md
---
```

## Handoff chain

| From | To | Required attachment |
|------|-----|---------------------|
| Orchestrator | Architect | Milestone goal, constraints, links to authority docs |
| Architect | Planner | `ARCHITECT-BRIEF.md` with `READY_FOR_PLANNING` |
| Planner | Coder | `PHASE-PLAN.md` phase section + **file allowlist** + `APPROVED_TO_BUILD` |
| Coder | QA | `CODER-CHANGELOG.md` + list of criteria IDs addressed |
| QA | Coder (fail) | `QA-REPORT.md` with numbered fix list |
| QA | Planner (pass) | `QA-REPORT.md` with `PASS`; Planner unlocks next phase |

## Coder changelog format

```markdown
## Phase 2.1 — Assessment Mode foundation

### Criteria addressed
- V2-ASSESS-01: detectNexMode returns assessment
- V2-ASSESS-02: session metadata state machine

### Files touched
| File | Change |
|------|--------|
| src/lib/nex/detectNexMode.ts | Added assessment patterns |

### Deviations from plan
- None

### Follow-ups for QA
- Run golden tests for assessment mode fixtures
```

## QA report format

See [templates/QA-REPORT.md](../templates/QA-REPORT.md). Add:

```markdown
## Planner criteria matrix
| ID | Criterion | Pass | Evidence |
|----|-----------|------|----------|
```

## Escalation

| Situation | Escalate to |
|-----------|-------------|
| Architect proposes banned V2+ feature | Planner BLOCKED → Product |
| Coder needs file outside allowlist | Planner amend plan |
| QA FAIL after 2 cycles | Architect + Planner re-review scope |
| Nex behavior change | Architect + read socratic-tutor-engine.md |

## Symbiotic principles

1. **Architect dreams in systems** — data flywheels, eval strategy, Kenya edge cases.
2. **Planner dreams in slices** — 1–2 week phases, testable exit, explicit allowlist.
3. **Coder dreams in diffs** — minimal, pattern-matching, no scope drift.
4. **QA dreams in evidence** — commands run, exit codes, criterion IDs.
