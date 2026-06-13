# M-Pesa Payment Flow Specification

**Version:** 1.0  
**Provider:** Safaricom Daraja API (STK Push / Lipa na M-Pesa Online)

---

## 1. Overview

Nexus is **M-Pesa first**. All subscription payments flow through STK Push to the customer's phone.

**Naming:** `mpesaPayment`, `mpesaStkPush`, `mpesaCallback` — see [Naming Guidelines](../product-governance/naming-guidelines.md)

---

## 2. Payment Statuses

```
pending → processing → paid
                    → failed
                    → cancelled
                    → expired
paid → refunded (admin/manual, rare)
```

| Status | Meaning |
|--------|---------|
| `pending` | STK push initiated, awaiting customer action |
| `processing` | Callback received, verification in progress |
| `paid` | Confirmed successful payment |
| `failed` | Customer declined or insufficient funds |
| `cancelled` | User cancelled on phone |
| `expired` | STK timeout (~5 min) no response |
| `refunded` | Manual refund recorded |

---

## 3. STK Push Flow

```
┌──────────┐     POST /api/mpesa/initiate      ┌──────────┐
│  Client  │ ────────────────────────────────► │  Server  │
└──────────┘                                     └────┬─────┘
                                                      │
                         1. Validate session + plan     │
                         2. Create mpesa_payments     │
                            status: pending           │
                         3. Call Daraja STK Push      │
                         ◄─────────────────────────────┘
                                                      │
┌──────────┐     STK prompt on phone                  │
│ Customer │ ◄───────────────────────────────────────┘
└────┬─────┘
     │ Enter PIN
     ▼
┌──────────┐     POST /api/mpesa/callback       ┌──────────┐
│ Safaricom│ ─────────────────────────────────► │  Server  │
└──────────┘                                     └────┬─────┘
                                                      │
                         4. Log mpesa_callbacks       │
                         5. Idempotent process        │
                         6. Update payment_status     │
                         7. Activate subscription    │
                         8. Send notifications       │
```

---

## 4. Initiate Payment

### Request

```json
POST /api/mpesa/initiate
{
  "subscriptionPlanId": "uuid",
  "phoneNumber": "+254712345678",
  "studentId": "uuid"
}
```

### Server Steps

1. Authenticate user (student or parent paying for linked student)
2. Validate `phoneNumber` format (+254...)
3. Load plan → `amount_kes`
4. Create `mpesa_payments` row:
   - `payment_status: pending`
   - `expires_at: now + 5 minutes`
5. Call `initiateMpesaPayment()` → Daraja STK Push
6. Store `checkout_request_id`, `merchant_request_id`
7. Return payment ID to client for polling

### Daraja Error Handling

- Daraja API failure → `payment_status: failed`, return `MPESA_PAYMENT_FAILED`
- Do not create duplicate pending payments for same user+plan within 2 minutes

---

## 5. Callback Handling

### Endpoint

`POST /api/mpesa/callback` — public webhook, no auth cookie

### Steps

```ts
async function handleMpesaCallback(payload: DarajaCallback) {
  // 1. Always log raw payload first
  const callback = await logMpesaCallback(payload);

  // 2. Idempotency check
  if (await isCallbackAlreadyProcessed(payload.CheckoutRequestID, payload.ResultCode)) {
    return acceptResponse(); // 200 OK, no re-processing
  }

  // 3. Find payment by checkout_request_id
  const payment = await findPaymentByCheckoutRequestId(payload.CheckoutRequestID);
  if (!payment) return acceptResponse(); // log anomaly

  // 4. Map ResultCode
  if (payload.ResultCode === 0) {
    await markMpesaPaymentAsPaid(payment, payload);
    await activateSubscription(payment);
    await sendPaymentNotifications(payment);
  } else {
    await updatePaymentStatus(payment, mapResultCodeToStatus(payload.ResultCode));
  }

  // 5. Mark callback processed
  await markCallbackProcessed(callback.id);
  return acceptResponse();
}
```

### Safaricom Response Format

```json
{
  "ResultCode": 0,
  "ResultDesc": "Accepted"
}
```

---

## 6. Duplicate Callback Protection

### Problem

Safaricom may send the same callback multiple times.

### Protection Layers

1. **Insert callback with unique constraint:**
   ```sql
   UNIQUE (checkout_request_id, result_code, mpesa_receipt_number)
   ```
   where receipt is not null

2. **Check `is_processed` flag** before business logic

3. **Payment status guard:**
   ```ts
   if (payment.payment_status === 'paid') return; // already done
   ```

4. **Subscription activation idempotency:**
   ```ts
   if (await billingEventExists('payment_received', mpesaPaymentId)) return;
   ```

5. **Database transaction:** payment update + subscription activation + billing event in single transaction

---

## 7. Result Code Mapping

| ResultCode | payment_status |
|------------|----------------|
| 0 | `paid` |
| 1 | `failed` (insufficient balance) |
| 1032 | `cancelled` (user cancelled) |
| 1037 | `expired` (timeout) |
| Other | `failed` |

Extract from callback metadata:
- `MpesaReceiptNumber`
- `Amount`
- `PhoneNumber`

---

## 8. Verification / Polling Fallback

Client polls `GET /api/mpesa/verify?mpesaPaymentId=uuid` every 3s for up to 2 minutes.

Server may also call `verifyMpesaPayment()` against Daraja query API if callback delayed > 30s.

---

## 9. Expiry Job

Background check (cron or scheduled):
```ts
expireMpesaPayment() // pending payments where expires_at < now → expired
```

---

## 10. Subscription Activation Rules

On `paid`:

| Check | Action |
|-------|--------|
| Valid receipt number | Required |
| Amount matches plan | Required |
| Student exists | Required |
| Not already activated for this payment | Idempotent skip |

```ts
await convertTrialToSubscription(studentId); // if trialing
await updateStudentSubscription({
  subscriptionStatus: 'active',
  currentPeriodStart: now(),
  currentPeriodEnd: addDays(now(), 30),
});
```

---

## 11. Security

- Callback URL registered in Daraja portal only
- Validate callback originates from Safaricom IP ranges where possible
- Never log full STK PIN or sensitive auth tokens
- `MPESA_*` secrets server-only
- Rate limit initiate: 5/hour per user

---

## 12. Logging

Log to `mpesa_callbacks` (raw payload) and application logs:

```
[INFO] mpesa.stk.initiated { mpesaPaymentId, checkoutRequestId, amountKes }
[INFO] mpesa.callback.received { checkoutRequestId, resultCode }
[INFO] mpesa.payment.paid { mpesaPaymentId, mpesaReceiptNumber }
[WARN] mpesa.callback.duplicate { checkoutRequestId }
[ERROR] mpesa.callback.failed { checkoutRequestId, error }
```

Never log: consumer secret, passkey, PIN.

---

## 13. Acceptance Criteria

- [ ] STK push received on valid Kenyan number
- [ ] Successful PIN entry activates subscription within 60s
- [ ] Duplicate callback does not double-activate
- [ ] Failed/cancelled payments show correct status in UI
- [ ] Pending payments expire after timeout
- [ ] Receipt number stored and visible to user
