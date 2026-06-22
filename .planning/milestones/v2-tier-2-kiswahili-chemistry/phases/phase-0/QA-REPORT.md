# QA Report — Phase 0

**Milestone:** v2-tier-2-kiswahili-chemistry  
**Phase:** 0  
**Date:** 2026-06-22  
**Verdict:** PASS

## Commands run

| Command | Exit code | Notes |
|---------|-----------|-------|
| `npm run lint` | 0 | Clean |
| `npm run typecheck` | 0 | Clean |
| `npm test` | 0 | 218 tests passed |
| `npm run test:scope-check` | 0 | Passed |
| `npm run build` | 0 | Next.js build succeeded |

## Criteria verification

| Criterion | Expected | Actual | Pass |
|-----------|----------|--------|------|
| ACTIVE_SUBJECT_CODES exported | 5 subject codes incl. kiswahili, chemistry | Present in contentModel.ts | yes |
| TIER1_SUBJECT_CODES preserved | Unchanged 3-code array | Unchanged | yes |
| No behavior change | No consumer imports yet | Grep confirms no consumers | yes |

## Verdict rationale

Phase 0 adds the generation-scope constant only. All CI gates green. No migrations or seed changes.
