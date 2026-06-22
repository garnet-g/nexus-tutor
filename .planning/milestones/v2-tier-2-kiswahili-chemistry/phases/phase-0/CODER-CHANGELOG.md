---
milestone: v2-tier-2-kiswahili-chemistry
phase: 0
agent: coder
version: 1
status: COMPLETE
---

# Coder Changelog — Phase 0

## Criteria addressed

| ID | Status | Notes |
|----|--------|-------|
| ACTIVE_SUBJECT_CODES constant | done | Added to contentModel.ts with kiswahili + chemistry |
| No consumer changes | done | TIER1_SUBJECT_CODES unchanged |
| Green gate | done | lint, typecheck, test, scope-check, build all pass |

## Files touched

| File | Change |
|------|--------|
| `src/lib/curriculum/contentModel.ts` | Added `ACTIVE_SUBJECT_CODES` and `ActiveSubjectCode` type |

## Migrations

| Migration | Purpose |
|-----------|---------|
| None | Phase 0 is constants only |

## Deviations from plan

- None

## Follow-ups for QA

- Confirm no imports of ACTIVE_SUBJECT_CODES yet (Phase 6+ consumers)
