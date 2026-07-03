---
milestone: production-readiness
phase: 05
agent: planner
version: 1
status: APPROVED_TO_BUILD
supersedes: null
inputs:
  - .planning/milestones/production-readiness/PHASE-PLAN.md
  - .planning/milestones/production-readiness/REMEDIATION-LEDGER.md
outputs:
  - .planning/milestones/production-readiness/phases/phase-05/PLAN-AMENDMENT.md
---

# Phase 05 Plan Amendment — environment + verification

**Verdict:** `APPROVED_TO_BUILD` (2026-07-03)

## Amendment 1 — remote-only database environment

Local Docker/Supabase is unavailable (Docker Desktop backend crash; user directive
2026-07-03: ignore Docker, work against the linked remote project). Changes to the
plan's verification section:

- `npm run db:reset` is **replaced** by `npx supabase db push --linked` (remote apply)
  after unit gates are green. Remote/local migration parity verified with
  `npx supabase migration list --linked`.
- 20-way-parallel enforcement is proven the way Phase 04 proved signup concurrency:
  vitest suites with mocked admin clients whose in-memory state reproduces the RPC
  atomicity contract (`tests/auth/signupConcurrency.test.ts` pattern), plus SQL
  contract assertions that read the migration file
  (`tests/mpesa/paymentSecurityRepair.test.ts` pattern).

## Amendment 2 — migration contract requirements

`supabase/migrations/20260702090000_atomic_usage_and_seats.sql` must follow the
Phase 03/04 hardening conventions: `SECURITY DEFINER`, `SET search_path = ''`,
`REVOKE ALL ... FROM PUBLIC, anon, authenticated` then `GRANT EXECUTE ... TO
service_role` for every new function. Quota enforcement returns
`(allowed boolean, new_count integer)` style results so services never read-then-write.

## Amendment 3 — PR-049 admin burst limits via shared chokepoint

The plan's task 7 applies burst limits to admin mutations. Wrapping all 31
mutating admin route files individually is high-churn and high-risk (each route
extracts its user id differently). Instead, enforcement is centralized at the
shared admin API guard, which already receives `request` and returns `userId`:

```
src/server/services/requireAdminApi.ts   (call enforceAdminMutationGuards after auth; mutating-method-only, so GET admin routes are unaffected)
```

This covers every privileged/financial/security-critical admin mutation that
routes through `requireAdminApi` — comp (grants premium), impersonate, coupons,
roles, communications, outcomes/parent-sms, support-cases, feature-rollouts,
platform alerts/approvals/experiments.

**Deferred (documented follow-up, not this phase):** admin routes that bypass
`requireAdminApi` — the `requireContentAuthor` content-studio surface (trusted
authors) and the two raw-`getUser` routes (`platform-settings`, `beta-invites`).
Lower burst-abuse risk; a follow-up ledger row will apply the same guard there.

## Unchanged

Tasks 1–7, file allowlist, criterion IDs (PR-014–016, PR-046, PR-048–049,
PR-089–093), and acceptance criteria stand as written in PHASE-PLAN.md.
