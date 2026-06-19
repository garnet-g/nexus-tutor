# QA Report — Phase 2.3 Mock Exams + Exam Simulator

**Verdict:** PASS  
**Date:** 2026-06-15

| Command | Result |
|---------|--------|
| npm test | 124 passed |
| npm run lint | pass |
| npm run typecheck | pass |
| npm run test:scope-check | pass |
| npm run build | pass |

## Criteria verified

| ID | Status |
|----|--------|
| V2-MOCK-01 | PASS — generate creates session + questions from pool/fallback |
| V2-MOCK-02 | PASS — submit auto-marks and stores results |
| V2-MOCK-03 | PASS — KCSE, CBC, topic-specific, full math styles |
| V2-MOCK-04 | PASS — free preview ≤5 questions + upgrade CTA |
| V2-SIM-01 | PASS — start sets `ends_at` from server clock |
| V2-SIM-02 | PASS — fullscreen timer UI, navigation, auto-submit on expiry |
| V2-SIM-03 | PASS — score, weak topics, predicted grade delta |
| V2-SIM-04 | PASS — mastery + academic_health_scores updated on submit |
| V2-SIM-05 | PASS — RLS policies scoped to `auth_student_id()` |
| V2-SIM-06 | PASS — scope-check allowlists mock + simulator APIs |

## Next

Phase 2.4 Science + English — content manifest authorship before Coder starts.
