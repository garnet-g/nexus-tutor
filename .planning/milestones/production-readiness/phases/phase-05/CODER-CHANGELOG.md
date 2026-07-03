---
milestone: production-readiness
phase: 05
agent: coder
version: 1
status: CODE_COMPLETE
supersedes: null
inputs:
  - .planning/milestones/production-readiness/PHASE-PLAN.md
  - .planning/milestones/production-readiness/phases/phase-05/PLAN-AMENDMENT.md
outputs:
  - supabase/migrations/20260702090000_atomic_usage_and_seats.sql
  - src/lib/rateLimit/durableLimiter.ts
  - src/lib/security/originCheck.ts
  - src/lib/security/bodySizeLimit.ts
---

# Phase 05 Coder Changelog — atomic DB ops + durable rate limiting

## Summary

Replaced every read-then-write quota/seat/trial path with atomic Postgres
functions, swapped the per-process waitlist rate-limit `Map` for a durable
multi-instance limiter, and added CSRF origin enforcement + request body-size
ceilings across public, AI, billing, family, and admin mutation surfaces.

## Migration — `20260702090000_atomic_usage_and_seats.sql`

Six SECURITY DEFINER functions + one table, all `SET search_path = ''`,
`REVOKE ALL FROM PUBLIC/anon/authenticated`, `GRANT EXECUTE TO service_role`:

| Function | Contract | Ledger |
|----------|----------|--------|
| `increment_nex_daily_usage(uuid,date,int) → jsonb` | `INSERT … ON CONFLICT (student_id,usage_date) DO UPDATE … WHERE count < limit`; returns `{allowed,new_count}` | PR-014 |
| `increment_practice_daily_usage(uuid,date,int) → jsonb` | same, practice column | PR-015 |
| `join_family_group(text,uuid) → jsonb` | `SELECT … FOR UPDATE` group row; membership + seat guard; member insert + seat bump + prior-sub cancel + family-sub insert in one txn; raises `INVALID_CODE`/`ALREADY_MEMBER`/`NO_SEATS` | PR-016 |
| `start_trial_atomic(uuid,uuid,int) → jsonb` | trial (unique student, `ON CONFLICT DO NOTHING`) + trialing subscription + billing event in one txn; raises `TRIAL_ALREADY_USED` | PR-091 |
| `create_family_group_atomic(uuid,uuid,uuid,text,int) → jsonb` | group + owner member in one txn (was two non-atomic inserts) | PR-093 |
| `consume_rate_limit(text,int,int) → jsonb` | fixed-window `INSERT … ON CONFLICT (key,window_start) DO UPDATE`; returns `{allowed,retry_after_seconds}`; opportunistic stale-bucket cleanup | PR-046/048/049 |
| `rate_limit_buckets` table | PK `(key,window_start)`, RLS on, service-role-only grants | PR-046 |

Schema assumptions verified against base migrations before push: `nex_daily_usage`
UNIQUE(student_id,usage_date), `family_group_members.student_id` UNIQUE,
`subscription_trials.student_id` UNIQUE, and every written column on
`student_subscriptions`, `family_groups`, `billing_events`.

## New library helpers

- `src/lib/rateLimit/durableLimiter.ts` — `checkRateLimit({key,windowSeconds,max}) → {allowed,retryAfterSeconds}` over `consume_rate_limit`. Fail-open on RPC error (availability > strict limiting; daily-quota RPCs remain the hard spend backstop).
- `src/lib/security/originCheck.ts` — `enforceSameOrigin(request)` (Origin → Sec-Fetch-Site → Referer, vs request host + `NEXT_PUBLIC_SITE_URL`; passes non-mutating/cookieless/non-browser). `enforceAdminMutationGuards(request,userId)` bundles origin + body ceiling + `admin:mutations:${userId}` burst (60/min).
- `src/lib/security/bodySizeLimit.ts` — `checkContentLength` (pre-parse 413 for multipart) and `readJsonWithLimit` (Content-Length + streamed hard cap; null body on invalid JSON so callers keep their own 400 shape). Caps: 64KB JSON default, 1MB admin JSON, ~5MB media.

## Service rewrites (delegate to RPCs, preserve public contracts)

- `nexUsageService.ts` — `incrementNexDailyUsage(id, dailyLimit)` / `incrementPracticeDailyUsage(id, dailyLimit)` now return `{allowed,newCount}` from the RPC; no client-side `.from().update()`.
- `familySubscriptionService.ts` — `joinFamilyGroupWithCode` → `join_family_group` with error-token→string mapping (exact strings preserved: "Family plan has no seats remaining" / "Student is already on a family plan" / "Invalid or expired family invite code"); `createFamilyGroupForPayment` → `create_family_group_atomic`.
- `subscriptionService.ts` — `startFreeTrial` → `start_trial_atomic`; `TRIAL_ALREADY_USED` → "Trial already used for this student"; premium-plan lookup + trial-ending notification preserved.

## Route wiring

| Route | Guards added |
|-------|--------------|
| `api/waitlist/teacher` | durable limiter (5/min/ip, replaces Map) + origin + JSON body cap — PR-046/089/090 |
| `api/nex/chat` | origin + `nex:chat` burst (20/min/student) + JSON body cap — PR-048 |
| `api/nex/camera` | origin + media Content-Length + `nex:camera` burst (10/min) — PR-048/090 |
| `api/nex/voice` | origin + media Content-Length + `nex:voice` burst (10/min) — PR-048/090 |
| `api/practice-sessions` | origin + `practice:start` burst (30/min) + JSON body cap |
| `api/family/join` | origin + JSON body cap (route's `{error}` envelope preserved) |
| `api/subscriptions/trial` | origin + `subscriptions:trial` burst (5/min) |
| `server/services/requireAdminApi.ts` | central `enforceAdminMutationGuards` chokepoint — covers all privileged admin mutations routed through it (comp, impersonate, coupons, roles, communications, parent-sms, support-cases, feature-rollouts, alerts, approvals, experiments) — PR-049 |

Increment call sites updated to pass the in-scope daily limit: chat ×2, voice, camera, practice.

## Deviations

1. **DB env:** local Docker unavailable; migration applied to the linked remote via `supabase db push --linked` per PLAN-AMENDMENT. Concurrency proven with mocked-RPC suites reproducing Postgres atomicity + SQL-contract assertions reading the migration (Phase 04 `signupConcurrency` / `paymentSecurityRepair` patterns).
2. **PR-049 scope:** enforced at the shared `requireAdminApi` chokepoint (Amendment 3) instead of editing 31 route files. **Deferred (documented follow-up):** admin routes bypassing `requireAdminApi` — the `requireContentAuthor` content-studio surface and the two raw-`getUser` routes (`platform-settings`, `beta-invites`). Lower burst-abuse risk; a follow-up ledger row should extend the same guard there.
3. **PR-092 (atomic activation):** already satisfied by the Phase 03 `process_verified_mpesa_payment` RPC (single-transaction subscription activation + family group). No new code; verified still atomic.

## Verification (commands run)

- `npm run typecheck` → PASS
- `npm run lint` → PASS (0 warnings)
- `npx vitest run` → **551 passed**, 13 skipped (was 513; +38 new across 6 suites)
- `npm run test:scope-check` → PASS
- `npm run build` → PASS (Next 16.2.9, all routes emitted)
- `supabase db push --linked` → applied `20260702090000`; `migration list --linked` in sync
- Live remote RPC smoke: `consume_rate_limit` (allow→deny w/ retry_after), `increment_nex_daily_usage` (callable by service_role) → **SMOKE_PASS**

## New tests

`tests/concurrency/{nexQuota,practiceQuota,familySeats}.test.ts`,
`tests/security/{originCheck,bodySizeLimit}.test.ts`,
`tests/rateLimit/durableLimiter.test.ts` — 20-way-parallel exact-cap enforcement,
cross-origin cookie rejection, streamed body-cap 413, multi-instance shared-bucket
simulation, plus SQL-contract assertions on the migration.
