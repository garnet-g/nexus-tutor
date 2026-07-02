---
milestone: production-readiness
phase: 03
agent: planner
version: 1
status: APPROVED_TO_BUILD
supersedes: PHASE-PLAN.md §Phase 03 (pre-amendment)
inputs:
  - .planning/milestones/production-readiness/phases/phase-03/ARCHITECT-AMENDMENT.md
  - .planning/milestones/production-readiness/DECISION-REGISTER.md
  - .planning/milestones/production-readiness/REMEDIATION-LEDGER.md
  - .planning/milestones/production-readiness/PHASE-PLAN.md
outputs:
  - .planning/milestones/production-readiness/PHASE-PLAN.md (Phase 03 section amended)
  - .planning/milestones/production-readiness/DECISION-REGISTER.md (DEC-010 SELECTED)
---

# PLAN-AMENDMENT — Phase 03 Payment Trust

## Verdict

**`APPROVED_TO_BUILD`**

Phase 03 is unblocked for Coder after Phase 02 QA PASS. DEC-010 resolved per Architect amendment.

## Decision resolution

| Decision | Outcome | Authority |
|----------|---------|-----------|
| DEC-010 | **SELECTED: (A)** Opaque per-payment callback secret in URL path + mandatory STK Query reconciliation before activation | Safaricom Daraja Lipa na M-Pesa Online — no callback signatures; STK Query (`POST /mpesa/stkpushquery/v1/query`) is independent proof |

**Daraja cite summary:** Safaricom Daraja 3.0 Lipa na M-Pesa Online does not sign STK Push callbacks. Nexus uses unguessable per-payment secrets embedded in `CallBackURL` (`/api/mpesa/callback/{secret}`) plus mandatory server-to-server STK Query before any `verified-paid` transition. Callbacks are notifications only.

## Allowlist changes (from pre-amendment plan)

| Change | Path | Rationale |
|--------|------|-----------|
| **Add** | `src/app/api/mpesa/callback/[secret]/route.ts` | DEC-010 (A) per-payment secret gate |
| **Delete** | `src/app/api/mpesa/callback/route.ts` | Replace flat public callback |
| **Add** | `src/lib/mpesa/paymentProof.ts` | Secret generation, hash, query proof validation |
| **Add** | `src/lib/mpesa/paymentStateMachine.ts` | Monotonic transition matrix |
| **Add** | `src/server/services/paymentReconciliationService.ts` | Expiry + query sweep + replay stub |
| **Fix path** | `src/features/pricing/components/PricingCheckout.tsx` | Was incorrectly `CheckoutPanel.tsx` |
| **Remove** | `src/app/pricing/page.tsx` | Not in architect scope; UI changes in component only |
| **Fix path** | `src/schemas/mpesaSchemas.ts` | Was incorrectly `src/schemas/mpesa.ts` |
| **Add tests** | `stkPushResponse.test.ts`, `paymentExpiry.test.ts`, `duplicatePending.test.ts` | Architect adversarial matrix |

## Migration

**Exact filename:** `supabase/migrations/20260701090000_payment_idempotency.sql`

Includes: extended `payment_status` CHECK, `callback_secret_hash`, receipt uniqueness, callback event idempotency, Celcom webhook events, atomic RPCs.

## Build order (Coder)

1. Migration + `db:reset`
2. `paymentProof.ts` + `paymentStateMachine.ts` (pure functions)
3. `queryStkPush` in `mpesaClient.ts`
4. **RED:** all eight `tests/mpesa/*.test.ts` files fail against current code
5. Callback `[secret]` route → stk-push hardening → status poll
6. Activation gate + Celcom webhook + reconciliation stub
7. `PricingCheckout.tsx` poll + recovery UI
8. **GREEN:** `npx vitest run tests/mpesa/`

## RED gate (must fail before fix)

```powershell
npx vitest run tests/mpesa/callbackForgery.test.ts
npx vitest run tests/mpesa/callbackReplay.test.ts
npx vitest run tests/mpesa/paymentConcurrency.test.ts
npx vitest run tests/mpesa/stkQueryProof.test.ts
npx vitest run tests/mpesa/stkPushResponse.test.ts
npx vitest run tests/mpesa/celcomWebhook.test.ts
npx vitest run tests/mpesa/paymentExpiry.test.ts
npx vitest run tests/mpesa/duplicatePending.test.ts
```

## Ledger rows addressed

PR-001, PR-002, PR-003, PR-004, PR-056, PR-047, PR-077, PR-094, PR-095, PR-096, PR-111, PR-113, PR-114, PR-115, PR-123, PR-124, PR-140

## Handoff

- **Coder:** Execute allowlist only; reference [ARCHITECT-AMENDMENT.md](./ARCHITECT-AMENDMENT.md) for state machine, security, and RPC design.
- **QA:** Verify RED→GREEN on all eight mpesa test files; confirm flat callback route removed.
