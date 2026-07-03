---
milestone: production-readiness
phase: 05
agent: qa
version: 1
status: PASS
supersedes: null
inputs:
  - .planning/milestones/production-readiness/phases/phase-05/CODER-CHANGELOG.md
  - .planning/milestones/production-readiness/PHASE-PLAN.md
  - .planning/milestones/production-readiness/phases/phase-05/PLAN-AMENDMENT.md
outputs:
  - .planning/milestones/production-readiness/phases/phase-05/QA-REPORT.md
---

# QA Report — Phase 05

**Date:** 2026-07-03
**Verdict:** `PASS`

## Verification matrix

| Gate | Result | Notes |
|------|--------|-------|
| `npm run typecheck` | PASS | |
| `npm run lint` | PASS | 0 warnings/errors |
| `npx vitest run` | **PASS** | 551 passed, 13 skipped (+38 new) |
| `npx vitest run tests/concurrency/ tests/security/ tests/rateLimit/` | PASS | 38 passed across 6 suites |
| `npm run test:scope-check` | PASS | |
| `npm run build` | PASS | Next 16.2.9, all routes emitted |
| `supabase db push --linked` | PASS | `20260702090000` applied; list in sync |
| Live remote RPC smoke | **PASS** | `consume_rate_limit` allow→deny; `increment_nex_daily_usage` service-role callable |

## Acceptance criteria

- [x] **20-way parallel tests enforce exact limits** — `nexQuota` (cap 5 → exactly 5 allowed), `practiceQuota` (cap 3 → 3), `familySeats` (4 seats → 3 joins, no oversell); each asserts the service delegates to the RPC and never issues a client-side `.from().update()`.
- [x] **Cross-origin cookie mutation rejected** — `originCheck` covers Origin / Sec-Fetch-Site / Referer paths → 403; same-origin, cookieless, and non-browser pass.
- [x] **Multi-instance limiter simulation passes** — `durableLimiter` shared-bucket sim: 20 callers, `max=5` → exactly 5 allowed; per-key isolation; fail-open on RPC error.

## Ledger rows verified

PR-014, PR-015, PR-016, PR-046, PR-048, PR-089, PR-090, PR-091, PR-093 →
`VERIFIED_COMPLETE`. PR-092 → `VERIFIED_COMPLETE` (already atomic via Phase 03
`process_verified_mpesa_payment`; confirmed, no new code).

## Findings / follow-up

- **PR-049 (admin burst):** enforced centrally at the `requireAdminApi` chokepoint — covers all privileged admin mutations routed through it. Marked `VERIFIED_COMPLETE` for that surface. **Open follow-up:** admin routes bypassing `requireAdminApi` (the `requireContentAuthor` content-studio routes + raw-`getUser` `platform-settings`/`beta-invites`) are not yet guarded — trusted-author/single-super-admin surfaces, lower abuse risk. Recommend a new ledger row (PR-049b) to extend the guard.
- Concurrency evidence is mock-RPC + SQL-contract (no local Docker), consistent with the Phase 04 precedent and PLAN-AMENDMENT. Live remote smoke confirms the functions execute under `service_role`. A future load test against staging (Phase 12) can add real-DB contention evidence.
