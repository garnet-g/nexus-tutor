---
milestone: v2-tier-1
phase: 0
agent: coder
version: 1
status: READY_FOR_QA
inputs:
  - .planning/milestones/v2-tier-1/PHASE-PLAN.md (Phase 0)
outputs:
  - src/server/services/practiceService.ts
  - src/app/(student)/progress/page.tsx
  - tests/streakBadge.test.ts
  - e2e/fixtures/auth.ts
  - e2e/student-gate.spec.ts
  - playwright.config.ts
  - .github/workflows/ci.yml
  - docs/LOCAL-DEV.md
  - .planning/FEASIBILITY-UAT.md
---

# CODER-CHANGELOG — Phase 0 Beta Hardening

## Summary

Closed Phase 0 implementation gaps: 7-day streak badge persistence, progress page achievable badges UI, Playwright student auth fixture, CI e2e job, and engineering pre-UAT documentation.

## Changes

| File | Change |
|------|--------|
| `practiceService.ts` | Upsert `seven_day_streak` via `streakBadges` helper at day 7 |
| `lib/gamification/streakBadges.ts` | Badge payload + idempotent upsert options (tested) |
| `progress/page.tsx` | Show 3 achievable badges (earned vs locked) |
| `tests/streakBadge.test.ts` | Unit test badge upsert at day 7 with idempotent `onConflict` |
| `e2e/fixtures/auth.ts` | `loginAsStudent()` + `hasE2eStudentCredentials()` |
| `e2e/student-gate.spec.ts` | Auth redirect tests (skip without `E2E_*` env) |
| `playwright.config.ts` | CI uses `npm run start` webServer |
| `ci.yml` | Playwright install + e2e after build; CI env placeholders |
| `package.json` | `test:e2e:ci` script |
| `FEASIBILITY-UAT.md` | Engineering pre-verification table; partial checklist |
| `LOCAL-DEV.md` | E2E credential docs |

## Criteria addressed

- BETA-GAME-01, BETA-GAME-02, BETA-GAME-03
- BETA-E2E-01, BETA-E2E-02, BETA-E2E-03
- BETA-CI-01
- BETA-UAT-01 (partial — staging sign-off pending manual walkthrough)

## Out of scope (per plan)

- Full persona E2E automation
- Staging provisioning
- P0/P1 defect fixes from live UAT (none found in code review)

## Handoff to QA

Run:

```bash
npm run lint
npm run typecheck
npm test
npm run test:scope-check
npm run build
$env:CI='true'; npm run test:e2e:ci   # PowerShell
```

Verify BETA-* criteria in PHASE-PLAN Phase 0 section.
