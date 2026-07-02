---
milestone: production-readiness
phase: 04
agent: coder
version: 1
status: COMPLETE
---

# CODER-CHANGELOG — Phase 04 Authentication, Authorization, and Account Consistency

## Summary

Closed support login failure, usage-stats SSR bypass, OAuth beta bypass, and non-transactional signup invite consumption. Added role matrix inventory, session revocation on role change, and cron error sanitization.

## RED evidence (pre-fix)

### `tests/auth/supportLoginRouting.test.ts`

```
FAIL returns a non-null session user for support role — expected null to equal support session
FAIL routes support users to platform settings — expected '/login' to be '/admin/platform-settings'
```

Exit code: 1 (2 failed, 1 passed)

### `tests/auth/roleMatrix.test.ts`

Created alongside implementation; initial run failed on:

- usage-stats page missing `requireSuperAdmin` (guard drift)
- manifest/API path alignment (fixed during GREEN)

### `tests/auth/oauthBetaPolicy.test.ts`

Would fail pre-fix: `signInWithGoogleAction` had no beta invite gate; callback provisioned accounts without invite validation.

### `tests/auth/signupConcurrency.test.ts`

Would fail pre-fix: parallel signups could both succeed against a single-use invite (no atomic `reserve_beta_invite` RPC).

## GREEN evidence (post-fix)

### Auth suite

```powershell
npx vitest run tests/auth/
# Test Files  3 passed | 1 skipped (4)
# Tests  13 passed | 1 skipped (14)
```

- `signupConcurrency.test.ts`: **skipped** when Supabase URL is not localhost (existing isolated-DB pattern). Runs when local stack is up with migration `20260701100000_beta_invite_reservation.sql` applied.

### Full verification

```powershell
npm run lint          # pass
npm run typecheck     # pass
npm test              # 497 passed | 14 skipped
npm run build         # pass
npm run deploy:check  # pass (env:check, lint, typecheck, test, scope-check, build, audit)
git diff --check      # no issues in Phase 04 allowlist files
```

## Changes by ledger ID

| ID | Fix |
|----|-----|
| PR-088 | `support` in `getRoleFromAppMetadata`, `getSessionUser`, `getPostAuthRedirectPath` |
| PR-013 | `requireSuperAdmin()` on `usage-stats/page.tsx` before `loadNexOpsSnapshot()` |
| PR-142 | `roleMatrix.manifest.ts`, `extractRouteGuards.ts`, `roleMatrix.test.ts` (69 pages + 74 APIs) |
| PR-054 | Migration `20260701100000_beta_invite_reservation.sql`, `signupCompensation.ts`, reserve-then-commit `signupAction` |
| PR-055 | OAuth invite in `signInWithGoogleAction`, `/auth/callback`, `AuthForm` (DEC-003 A) |
| PR-127 | `sessionRevocationService.ts`; `setUserRole` revokes sessions on role **change** |
| PR-099 | Cron `weekly-reports` returns stable `{ code: "CRON_JOB_FAILED" }`; logs detail server-side |
| PR-100 | Spot-check: usage-stats API negative cases assert `{ success, error: { code, message } }` |

## Files touched (allowlist only)

### Product

- `src/server/services/authService.ts`
- `src/server/services/sessionRevocationService.ts` (new)
- `src/server/services/signupCompensation.ts` (new)
- `src/server/services/betaInviteService.ts` — `reserveBetaInvite`, `releaseBetaInvite`
- `src/server/actions/authActions.ts`
- `src/app/auth/callback/route.ts`
- `src/app/(super-admin)/admin/usage-stats/page.tsx`
- `src/features/auth/components/AuthForm.tsx`
- `src/app/api/cron/weekly-reports/route.ts`
- `supabase/migrations/20260701100000_beta_invite_reservation.sql` (new, local file only — no remote push)

### Tooling / tests

- `scripts/extractRouteGuards.ts` (new)
- `tests/auth/supportLoginRouting.test.ts` (new)
- `tests/auth/roleMatrix.manifest.ts` (new)
- `tests/auth/roleMatrix.test.ts` (new)
- `tests/auth/oauthBetaPolicy.test.ts` (new)
- `tests/auth/signupConcurrency.test.ts` (new)
- `e2e/support-admin-login.spec.ts` (new; requires `E2E_SUPPORT_EMAIL` / `E2E_SUPPORT_PASSWORD`)

## Notes

- **usage-stats guard** also asserted in `roleMatrix.test.ts` super-admin page list (covers PR-013 without editing out-of-allowlist `sensitiveAdminPageGuards.test.ts`).
- **Migration**: apply locally via `supabase db reset` or `supabase migration up` before running `signupConcurrency` integration test.
- **E2E**: `e2e/support-admin-login.spec.ts` skips unless support credentials env vars are set.

## Out of scope (unchanged)

- `admin_role_assignments` → Auth metadata sync (Phase 06)
- Atomic quotas (Phase 05)
- Remote `supabase db push`
