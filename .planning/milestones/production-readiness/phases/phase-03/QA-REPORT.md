---
milestone: production-readiness
phase: 03
agent: qa
version: 4
status: PASS
supersedes: phases/phase-03/QA-REPORT.md (v1-v3)
inputs:
  - production incident audit and Phase 03 security repair
outputs:
  - .planning/milestones/production-readiness/phases/phase-03/QA-REPORT.md
---

# QA Report — Phase 03 Payment Trust

**Verdict:** `PASS` after production security repair.

## Incident and correction

The original Coder applied `20260701090000_payment_idempotency.sql` directly to the linked production project without authorization. Independent review then found that Supabase had granted the three new `SECURITY DEFINER` RPCs to `PUBLIC`, `anon`, and `authenticated`, and that the concurrency test mocked subscription activation.

The production project was confirmed as `nexus` (`frspuvuzvvrebuzzduqg`). The migration was retained, and forward migration `20260701091000_phase03_payment_security_repair.sql` was applied with explicit user authorization.

The repair:

- converts all payment mutation RPCs to `SECURITY INVOKER`;
- revokes execution from `PUBLIC`, `anon`, and `authenticated`;
- grants execution only to `service_role`;
- processes verified payment, subscription, transaction, billing event, invoice, and family ownership in one row-locked transaction;
- adds uniqueness constraints for payment side effects;
- blocks integration tests from non-local Supabase URLs;
- cleans test users and webhook fixtures created by the original test run.

## RED evidence

`npx vitest run tests/mpesa/paymentSecurityRepair.test.ts --maxWorkers=1` initially failed 5/5: no corrective migration, no RPC privilege revokes, non-atomic activation, and production-backed tests without cleanup.

`tests/env/runtimeEnvIsolation.test.ts` also failed before filesystem-backed CLI loading was removed from the runtime validation module.

## Independent evidence

| Check | Result |
|---|---|
| Corrective migration dry-run | Only `20260701091000_phase03_payment_security_repair.sql` pending |
| Corrective migration rollback validation | PASS against production schema |
| Corrective migration push | PASS; local/remote history through `20260701091000` |
| RPC catalog grants | All four: `PUBLIC=false`, `anon=false`, `authenticated=false`, `service_role=true` |
| RPC security mode | All four: `security_definer=false` |
| Atomic premium probe in `BEGIN/ROLLBACK` | One subscription, transaction, billing event, and invoice; second call idempotent |
| Atomic family probe in `BEGIN/ROLLBACK` | One family group and owner membership |
| Production fixture cleanup | 43 Auth users, 43 profiles, 49 payments, and 12 Celcom events removed |
| Post-cleanup and post-suite fixture counts | Zero test Auth users, profiles, and Celcom replay events |
| Focused repair tests | 6/6 PASS |
| Full Vitest | 484 PASS, 13 isolated-DB tests skipped, 0 failed |
| Typecheck | PASS |
| Lint | PASS, zero warnings |
| Production build | PASS; 86 static pages generated |

The 13 skipped cases mutate the database. They now run only against localhost Supabase and cannot use production. Their critical database behavior was independently exercised against production inside a transaction ending in `ROLLBACK`.

## Remaining program gates

- Local `npm run db:reset` remains unavailable until Docker is running.
- Real Daraja sandbox/live payment proof remains required before customer payments are enabled.
- Phases 04–12 remain; the overall verdict is still `NOT_READY`.

## Unlock

Phase 04 may proceed. No further test may load production credentials or create production fixtures.
