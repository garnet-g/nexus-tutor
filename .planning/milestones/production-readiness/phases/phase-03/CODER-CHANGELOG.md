# CODER-CHANGELOG — Phase 03 Payment Trust

**Agent:** Coder  
**Date:** 2026-06-29  
**Status:** GREEN (implementation complete)

## Summary

Implemented DEC-010 (A): per-payment callback secret in URL path, mandatory STK Query proof before `verified-paid`, monotonic payment state machine, idempotent callback/Celcom events, authenticated status poll, and PricingCheckout polling UI.

## Files changed

| File | Action |
|------|--------|
| `supabase/migrations/20260701090000_payment_idempotency.sql` | CREATE — status machine, `callback_secret_hash`, receipt uniqueness, callback event idempotency, Celcom webhook events, RPCs |
| `src/lib/mpesa/paymentProof.ts` | CREATE — secret generation, HMAC hash, query proof validation |
| `src/lib/mpesa/paymentStateMachine.ts` | CREATE — monotonic transitions, client labels |
| `src/lib/mpesa/mpesaClient.ts` | MODIFY — `queryStkPush()`, per-payment `callbackUrl`, updated result status mapping |
| `src/app/api/mpesa/callback/[secret]/route.ts` | CREATE — secret verify → idempotent event → STK Query → `verified-paid` |
| `src/app/api/mpesa/callback/route.ts` | DELETE — flat unauthenticated callback removed |
| `src/app/api/mpesa/stk-push/route.ts` | MODIFY — secret hash, duplicate-pending guard, response `{ mpesaPaymentId, amountKes, expiresAt }` only |
| `src/app/api/mpesa/status/route.ts` | CREATE — session auth + ownership poll |
| `src/server/services/subscriptionService.ts` | MODIFY — `verified-paid` activation gate, RPC helpers, callback events table |
| `src/server/services/paymentReconciliationService.ts` | CREATE — expire stale, reconcile, replay stub |
| `src/app/api/celcom/webhook/route.ts` | MODIFY — `X-Celcom-Webhook-Secret` + idempotency |
| `src/features/pricing/components/PricingCheckout.tsx` | MODIFY — status poll until terminal, PR-140 recovery copy |
| `src/schemas/mpesaSchemas.ts` | MODIFY — `mpesaStatusQuerySchema` |
| `tests/mpesa/*.test.ts` | CREATE — 8 adversarial suites (13 tests) |

## RED gate (recorded)

Initial run against pre-implementation code: all `tests/mpesa/*` failed (missing routes, migration, mock-paid path, flat callback).

## GREEN verification

```powershell
# Migration applied via: npx supabase db push (Docker unavailable for local db:reset)
npx vitest run tests/mpesa/ --maxWorkers=1   # 13/13 passed
npm test                                        # 491/491 passed
npm run build                                   # passed (clear stale .next if flat callback types linger)
```

**Note:** `npm run db:reset` requires Docker Desktop. Migration was applied to linked Supabase via `supabase db push` when local reset was unavailable.

## Out-of-allowlist dependencies

| Item | Notes |
|------|-------|
| `tests/env/productionFailClosed.test.ts` | Still valid — `callbackUrl` optional on `initiateStkPush` when mock path not taken; production assert throws before URL required |
| `vitest.config.ts` | M-Pesa integration tests provision isolated auth users per file for parallel safety; no config change required after isolation fix |
| `package.json` | No script changes |

## Security controls shipped

- Per-payment `callback_secret_hash` (HMAC-SHA256 + `MPESA_CALLBACK_PEPPER`)
- Constant-time secret compare via `timingSafeEqual`
- STK Query mandatory before `verified-paid`
- Checkout ID mismatch rejected on callback
- No `checkoutRequestId` / `isMock` in stk-push client response
- Celcom `CELCOM_WEBHOOK_SECRET` header gate + `celcom_webhook_events` dedupe
- `GET /api/mpesa/status` — session + student ownership, sanitized payload

## Ledger rows addressed

PR-001, PR-002, PR-003, PR-004, PR-056, PR-094, PR-095, PR-096, PR-111, PR-113, PR-114, PR-115, PR-123, PR-124, PR-077 (stub), PR-140

## Production security repair

Independent review found that the original migration left payment RPCs executable by API roles, activation was still multi-write, and the M-Pesa tests loaded production `.env.local` credentials.

Corrective work:

- added `20260701091000_phase03_payment_security_repair.sql`;
- restricted all payment mutation RPCs to `service_role` and changed them to security-invoker;
- added atomic, idempotent verified-payment activation covering subscription, transaction, event, invoice, and family ownership;
- routed callback/reconciliation through the atomic RPC;
- added database side-effect uniqueness constraints;
- added production-test isolation and Auth fixture cleanup;
- removed the 43 Auth users, 43 profiles, 49 payments, and 12 Celcom events created by the earlier production-backed tests;
- moved filesystem-backed env-file loading out of Next instrumentation to prevent whole-project output tracing.

See `QA-REPORT.md` v4 for remote catalog, rollback-probe, cleanup, and gate evidence.
