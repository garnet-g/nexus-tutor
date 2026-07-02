---
milestone: production-readiness
phase: 04
agent: planner
version: 1
status: APPROVED_TO_BUILD
supersedes: PHASE-PLAN.md §Phase 04 (pre-amendment)
inputs:
  - .planning/milestones/production-readiness/phases/phase-04/ARCHITECT-AMENDMENT.md
  - .planning/milestones/production-readiness/DECISION-REGISTER.md
  - .planning/milestones/production-readiness/REMEDIATION-LEDGER.md
  - .planning/milestones/production-readiness/PHASE-PLAN.md
outputs:
  - .planning/milestones/production-readiness/PHASE-PLAN.md (Phase 04 section amended)
  - .planning/milestones/production-readiness/DECISION-REGISTER.md (DEC-003 SELECTED)
---

# PLAN-AMENDMENT — Phase 04 Authentication, Authorization, and Account Consistency

## Verdict

**`APPROVED_TO_BUILD`**

Phase 04 is unblocked for Coder after Phase 03 QA PASS. DEC-003 resolved per Architect amendment (fail-closed OAuth beta parity).

## Decision resolution

| Decision | Outcome | Authority |
|----------|---------|-----------|
| DEC-003 | **SELECTED: (A)** Enforce identical beta policy on OAuth and email signup — invite validated server-side in `signInWithGoogleAction` and `/auth/callback` | Security default; Architect recommendation |

OAuth UI hiding is not a security control. Server actions and crafted callback URLs must enforce invite when `BETA_INVITE_REQUIRED=true`.

## Allowlist corrections (from pre-amendment plan)

| Change | Path | Rationale |
|--------|------|-----------|
| **Fix** | `src/app/(super-admin)/admin/usage-stats/page.tsx` | Was `src/app/admin/usage-stats/page.tsx` |
| **Fix** | `src/app/(public)/(auth)/signup/page.tsx` | Was `src/app/signup/page.tsx` |
| **Fix** | `src/app/(public)/(auth)/login/page.tsx` | Was `src/app/login/page.tsx` |
| **Fix** | `src/server/services/superAdminGuard.ts` | Was `src/server/guards/superAdminGuard.ts` |
| **Fix** | `src/server/services/requireAdminApi.ts` | Was `src/server/guards/requireAdminApi.ts` |
| **Fix** | `src/features/student/server/requireStudentExperience.ts` | Was `src/server/guards/requireStudentExperience.ts` |
| **Add** | `src/server/services/nexOpsService.ts` | Audit-only; usage-stats reads service-role snapshot |
| **Add** | `src/server/services/betaInviteService.ts` | Invite validate + reservation integration |
| **Add** | `src/server/services/sessionRevocationService.ts` | **NEW** — `revokeAllSessions` on role change (PR-127) |
| **Add** | `src/server/services/signupCompensation.ts` | **NEW** — compensating rollback for failed signup (PR-054) |
| **Add** | `src/features/auth/components/AuthForm.tsx` | OAuth + invite UX when beta required |
| **Add** | `src/server/services/contentAuthorGuard.ts` | Matrix tier `content_author` |
| **Add** | `scripts/extractRouteGuards.ts` | Static guard extractor (drift detector) |
| **Add** | `tests/auth/roleMatrix.manifest.ts` | Golden 69-page + 74-API access matrix |
| **Add** | `supabase/migrations/20260701100000_beta_invite_reservation.sql` | `reserve_beta_invite` / `release_beta_invite` RPCs |

**Unchanged (retained):** `authService.ts`, `authActions.ts`, `auth/callback/route.ts`, `proxy.ts`, `weekly-reports/route.ts`, all `tests/auth/*.test.ts`, `e2e/support-admin-login.spec.ts`, `CODER-CHANGELOG.md`.

## Migration

**Exact filename:** `supabase/migrations/20260701100000_beta_invite_reservation.sql`

RPC contract (Architect §4):

- `reserve_beta_invite(p_code text, p_user_id uuid)` — atomically increment `use_count` when valid; idempotent per `(invite_code, user_id)` via `beta_invite_redemptions`
- `release_beta_invite(p_code text, p_user_id uuid)` — compensating release on rollback after failed signup/OAuth

Application-layer `rollbackFailedSignup()` in `signupCompensation.ts` remains required even with RPC (auth user delete + profile cleanup with 5-minute window guard).

## Build order (Coder)

1. **4.1** `getRoleFromAppMetadata` whitelist + `support` in `getSessionUser` / `getPostAuthRedirectPath` (PR-088)
2. **RED:** `npx vitest run tests/auth/supportLoginRouting.test.ts`
3. **4.2** `requireSuperAdmin()` on usage-stats page before `loadNexOpsSnapshot()` (PR-013)
4. **4.3** `roleMatrix.manifest.ts` + `extractRouteGuards.ts` + `roleMatrix.test.ts` (PR-142)
5. **RED:** `npx vitest run tests/auth/roleMatrix.test.ts`
6. **4.4** Migration + `signupCompensation.ts`; refactor `signupAction` to reserve-then-commit (PR-054)
7. **RED:** `npx vitest run tests/auth/signupConcurrency.test.ts`
8. **4.5** DEC-003 (A): invite in OAuth flow — `signInWithGoogleAction`, callback, `AuthForm` (PR-055)
9. **RED:** `npx vitest run tests/auth/oauthBetaPolicy.test.ts`
10. **4.6** `sessionRevocationService.ts`; wire `setUserRole` on role **change** (PR-127)
11. **4.7** Cron error sanitization (`weekly-reports/route.ts`); API error shape spot checks (PR-099, PR-100)
12. **4.8** Proxy matcher audit — document layout-gated vs proxy-gated routes in manifest (PR-142)
13. **GREEN:** `npx vitest run tests/auth/` + `e2e/support-admin-login.spec.ts`

## RED gate (must fail before fix)

```powershell
npx vitest run tests/auth/supportLoginRouting.test.ts
npx vitest run tests/auth/roleMatrix.test.ts
npx vitest run tests/auth/signupConcurrency.test.ts
npx vitest run tests/auth/oauthBetaPolicy.test.ts
```

## Ledger rows addressed

| ID | Owner task |
|----|------------|
| PR-013 | `requireSuperAdmin()` on usage-stats SSR before service-role reads |
| PR-054 | `reserve_beta_invite` RPC + `signupCompensation.ts` + concurrent signup test |
| PR-055 | OAuth invite enforcement per DEC-003 (A) |
| PR-088 | `support` in `getSessionUser` + post-auth redirect |
| PR-099 | Cron stable error codes; no stack/message leak |
| PR-100 | Spot-check admin API `{ success, error: { code, message } }` on touched routes |
| PR-127 | `sessionRevocationService` + `setUserRole` change hook |
| PR-142 | Role matrix manifest + extractor + negative cases + proxy coverage |

## Scope boundary

- Matrix manifest lists all 69 pages + 74 API routes; Coder implements guard **fixes** only for confirmed defects (usage-stats, authService support, signup/OAuth, session revoke, cron sanitization).
- `admin_role_assignments` → Auth metadata sync deferred to Phase 06 (DEC-008).
- Atomic quotas deferred to Phase 05.

## Handoff

- **Coder:** Execute allowlist only; reference [ARCHITECT-AMENDMENT.md](./ARCHITECT-AMENDMENT.md) for OAuth state flow, RPC contract, and matrix tiers.
- **QA:** Verify RED→GREEN on all four auth test files; support blocked from usage-stats SSR; `e2e/support-admin-login.spec.ts` green.
