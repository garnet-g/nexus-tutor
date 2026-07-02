# QA Report — Phase 04 Fix Cycle 1

**Date:** 2026-06-30  
**Agent:** QA (independent)  
**Verdict:** `FIX_REQUIRED`  
**Phase 05:** NOT STARTED (per directive)

## Blocking findings addressed (Coder)

| # | Finding | Status |
|---|---------|--------|
| 1 | `reserveBetaInvite` post-reserve revalidation | FIXED — returns `{ valid: true, reserved: true, invite }`; `reserveBetaInvite.test.ts` + `signupConcurrency.test.ts` |
| 2 | Migration privilege hardening | FIXED — `REVOKE`/`GRANT`, `search_path = ''`, `is_auth_session_active`; `betaInviteMigrationSql.test.ts` |
| 3 | Immediate session revocation | FIXED — `sessionFreshnessService.ts` (JWT `sessionVersion` + `auth.sessions`); wired in `getSessionUser`, `requireAdminRole`, `proxy.ts`; `sessionRevocation.test.ts` |
| 4 | Support routing loop | FIXED — support → `/admin/support`, super_admin → `/admin` in `authService`, `proxy.ts`, `/auth/callback` |
| 5 | Committed role matrix | FIXED — `role-matrix.contract.json` + `SERVER_ACTION_CONTRACT`; `/api/family/*` = `student`; negative API tests |

## Verification matrix

| Gate | Result | Notes |
|------|--------|-------|
| `npx vitest run tests/auth/` | **PASS** | 29 passed, 0 skipped |
| `npm run lint` | PASS | |
| `npm run typecheck` | PASS | |
| `npm test` | PASS | 513 passed, 13 skipped (non–Phase 04 suites) |
| `npm run build` | PASS | |
| `npm run deploy:check` | PASS | |
| `npm audit --audit-level=moderate` | PASS | 0 vulnerabilities |
| `git diff --check` | PASS | CRLF warnings only |
| `e2e/support-admin-login.spec.ts` | **FAIL** | Login succeeds but no redirect to `/admin/support` — support user not provisioned and/or stale dev server on :3000 |

## E2E failure analysis

- Playwright executed (not skipped).
- Form interaction PASS after selector fix (`#email`, `#password`).
- Post-login redirect timed out waiting for `/admin/support`.
- **Likely causes:** (1) `support@nexus.local` absent when Docker/local Supabase unavailable; (2) dev server on port 3000 serving pre–fix-cycle bundle (`reuseExistingServer: true`).
- **Remediation:** `supabase start && npm run db:seed-dev-users`, restart `npm run dev`, re-run `npx playwright test e2e/support-admin-login.spec.ts`.

## Ledger rows (returned to IN_QA)

| Row | Title | Status |
|-----|-------|--------|
| PR-054 | Signup invite reservation | IN_QA |
| PR-055 | OAuth beta parity | IN_QA |
| PR-088 | Support login routing | IN_QA |
| PR-127 | Session revocation | IN_QA |
| PR-142 | Role matrix contract | IN_QA |

## Phase 04 acceptance

**FIX_REQUIRED** — all unit/SQL contract gates green; E2E support admin shell test must pass after local seed + server restart before Phase 04 PASS.

**Phase 05 must not start.**
