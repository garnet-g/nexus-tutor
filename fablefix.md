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
- **Commit:** (pending)
