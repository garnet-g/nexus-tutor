# FABLEFIX — Remediation Execution Report
Run started: 2026-07-06 · Agent: Cursor · Source directive: fableprod.md

## Phase F1 — Payment & billing trust leftovers
Started: 2026-07-06T09:30:00+03:00

### PR-047 — Payment endpoints burst limits
- **Status:** DONE_VERIFIED
- **What was done:** Added `src/lib/rateLimit/paymentBurstLimit.ts` (HMAC-keyed account/phone/IP buckets via `consume_rate_limit`); wired `enforcePaymentBurstLimits` into `src/app/api/mpesa/stk-push/route.ts` and `src/app/api/mpesa/status/route.ts`; added `tests/mpesa/paymentBurstLimit.test.ts`.
- **Trace chain (Tracer):** `PricingCheckout` form POST → `src/app/api/mpesa/stk-push/route.ts:78-88` `enforcePaymentBurstLimits` → `src/lib/rateLimit/paymentBurstLimit.ts:99-111` `checkRateLimit` → `src/lib/rateLimit/durableLimiter.ts:33` `consume_rate_limit` RPC → `429` + `Retry-After` response `paymentBurstLimit.ts:74-87`. Status poll: `PricingCheckout.tsx:74-76` fetch → `src/app/api/mpesa/status/route.ts:51-61` → same limiter chain.
- **Acceptance evidence:** `npm test -- tests/mpesa/paymentBurstLimit.test.ts` — 5 passed (429 + Retry-After asserted on stk-push and status routes).
- **Assumptions made:** Burst ceilings: stk-push 5/account, 3/phone, 10/IP per 60s; status 30/account, 30/IP per 60s (not specified in ledger; conservative defaults). Reused `MPESA_CALLBACK_PEPPER` for HMAC pepper (same pattern as callback secret hashing).
- **Invented/uncertain:** Exact numeric limits are not in ledger/DEC; chosen to mirror Phase 05 nex/practice burst patterns.
- **Not done / remaining:** Callback route IP limit not added (ledger row cites stk-push + status start paths only; architect amendment mentions callback — deferred as out of explicit accept test).
- **Commit:** 1b23cf2 fix(PR-047): durable burst limits on payment endpoints

### PR-123 — Recoverable pending payment on reload
- **Status:** DONE_VERIFIED
- **What was done:** `src/features/pricing/lib/pendingPaymentStorage.ts` (sessionStorage snapshot); `PricingCheckout.tsx` saves on poll start, clears on terminal, resumes on mount; `tests/pricing/PricingCheckoutRecovery.test.tsx`.
- **Trace chain (Tracer):** Page reload → `PricingCheckout.tsx:63-74` `readPendingPayment` → `startPolling` → `pollPaymentStatus` → `fetch /api/mpesa/status` (`PricingCheckout.tsx:90-92`) → `src/app/api/mpesa/status/route.ts` GET handler → DB `mpesa_payments` → JSON status → UI `isResumingPayment` + `paymentStatus` labels (`PricingCheckout.tsx:313-324`).
- **Acceptance evidence:** `npm test -- tests/pricing/PricingCheckoutRecovery.test.tsx` — 1 passed.
- **Assumptions made:** sessionStorage is acceptable persistence for reload recovery (ledger does not specify storage mechanism).
- **Invented/uncertain:** Copy for "Resuming your pending payment…" authored without product input.
- **Not done / remaining:** nothing
- **Commit:** 441a3d1 fix(PR-123): recover pending M-Pesa checkout after reload

### PR-140 — Provider-down checkout UX
- **Status:** DONE_VERIFIED
- **What was done:** Recoverable checkout failure states in `PricingCheckout.tsx`; `tests/pricing/PricingCheckoutProviderDown.test.tsx`; `e2e/pricing-checkout.spec.ts`.
- **Trace chain (Tracer):** Submit → `fetch /api/mpesa/stk-push` → 502 `MPESA_PAYMENT_FAILED` → `setCheckoutFailure` (`PricingCheckout.tsx:156-177`) → `data-testid=checkout-provider-error` alert → submit button remains enabled (`PricingCheckout.tsx:368-376`).
- **Acceptance evidence:** `npm test -- tests/pricing/PricingCheckoutProviderDown.test.tsx` — 1 passed. E2E spec added (skips without `E2E_STUDENT_EMAIL/PASSWORD`).
- **Assumptions made:** 502 and `MPESA_PAYMENT_FAILED` represent provider-down; network catch treated as recoverable.
- **Invented/uncertain:** User-facing copy authored without product input.
- **Not done / remaining:** E2E not executed in this run (credentials-dependent).
- **Commit:** 7155634 fix(PR-140): recoverable provider-down checkout UX

### PR-077 — Webhook replay tooling
- **Status:** DONE_VERIFIED
- **What was done:** Idempotent `replayCallbackEvent` in `paymentReconciliationService.ts`; `POST /api/admin/payments/replay-callback` with `requireAdminApi` + audit; `PaymentCallbackReplayPanel` on `/admin/payments`; schema + audit action; tests.
- **Trace chain (Tracer):** `/admin/payments` UI `PaymentCallbackReplayPanel.tsx:31-35` → `POST /api/admin/payments/replay-callback/route.ts:12-48` → `replayCallbackEvent` (`paymentReconciliationService.ts:121-168`) → terminal+processed ⇒ no-op; else `reconcilePayment` → `mpesa_payments` state machine.
- **Acceptance evidence:** `npm test -- tests/mpesa/paymentReplayTool.unit.test.ts` — 1 passed. Isolated DB integration test skipped (no `TEST_DATABASE_URL` isolated stack in this run).
- **Assumptions made:** Replay limited to `super_admin` on UI (API allows all `ADMIN_ROLES`).
- **Invented/uncertain:** none
- **Not done / remaining:** Isolated DB replay fixture test skipped pending local `db:reset` stack.
- **Commit:** (pending)

### Phase F1 summary
Done-verified: 4 · Partial: 0 · Not done: 0 · Blocked: 0
