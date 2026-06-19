---
milestone: template
phase: null
agent: planner
version: 1
status: DRAFT
inputs:
  - ARCHITECT-BRIEF.md
outputs: []
---

# PHASE-PLAN — {Milestone Title}

**Architect input:** [ARCHITECT-BRIEF.md](./ARCHITECT-BRIEF.md)  
**Overall verdict:** `APPROVED_TO_BUILD` | `CHANGES_REQUIRED` | `BLOCKED`

## Milestone exit criteria

- [ ] 

---

## Phase {N} — {Title}

**Status:** `APPROVED_TO_BUILD` | `PENDING` | `COMPLETE`  
**Depends on:** Phase {N-1} | none

### Goal

{One sentence}

### Criterion IDs

| ID | Description |
|----|-------------|
| | |

### Tasks

1. 
2. 

### File allowlist

```
src/...
supabase/migrations/...
tests/...
```

### Out of scope

- 

### Verification

```bash
npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build
```

### Planner verdict

`APPROVED_TO_BUILD` | `CHANGES_REQUIRED` | `BLOCKED`

---

## Parallel workstreams (optional)

| Stream | Phases | Notes |
|--------|--------|-------|

## Verdict rationale

{Why APPROVED_TO_BUILD or what must change}
