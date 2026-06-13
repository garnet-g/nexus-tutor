# Free Trial System

**Version:** 1.0  
**Naming:** `trial`, `freeTrial`, `isTrialActive`, `trialEndsAt`

---

## 1. Purpose

Allow students to experience **premium daily limits** (75 Nex, 20 practice) before paying.

---

## 2. Trial Parameters

| Parameter | Default |
|-----------|---------|
| Duration | 7 days |
| One trial per student | Yes (lifetime) |
| Auto-start on signup | Optional — recommend manual start from dashboard CTA |
| Credit card required | No (M-Pesa first market) |

---

## 3. Lifecycle

```
startFreeTrial(studentId)
    ↓
subscription_trials: is_trial_active = true
student_subscriptions: subscription_status = 'trialing'
    ↓
Premium daily limits unlocked (75 Nex, 20 practice) — not unlimited
    ↓
T-2 days: trial_ending notifications
    ↓
trialEndsAt reached:
    expireFreeTrial()
    ↓
subscription_status = 'expired' → revert to **free forever** daily caps
is_trial_active = false
    ↓
OR convertTrialToSubscription() on M-Pesa payment
    ↓
subscription_status = 'active'
converted_at = now()
```

---

## 4. Functions

```ts
startFreeTrial(studentId: string): Promise<TrialRecord>
checkTrialStatus(studentId: string): Promise<{ isTrialActive: boolean; trialEndsAt: Date }>
expireFreeTrial(studentId: string): Promise<void>
convertTrialToSubscription(studentId: string, mpesaPaymentId: string): Promise<void>
```

---

## 5. Feature Access During Trial

Same daily limits as **Premium Individual** (75 Nex / 20 practice) plus exam study plans and parent weekly email.

---

## 6. Expiry Behavior

On expiry:
- `canUseNex` reverts to **free forever** daily caps (10 Nex, 3 practice)
- Progress data preserved
- Study plans become read-only (cannot regenerate)
- Dashboard shows upgrade banner

Error code: `TRIAL_EXPIRED` when accessing premium-only endpoints.

---

## 7. Conversion

On successful M-Pesa payment during trial:
1. `convertTrialToSubscription()`
2. Set `converted_at`
3. Set `subscription_status = 'active'`
4. Set `current_period_end` = now + 30 days (not trial end date)
5. Log `billing_events: trial_converted`

---

## 8. Database

**Table:** `subscription_trials`
- One row per student (UNIQUE on `student_id`)
- Cannot restart trial if `converted_at` or previous trial expired

---

## 9. Notifications

See [Notification Spec](./notification-spec.md):
- `trial_ending` at T-2 days
- `trial_expired` on expiry day

---

## 10. Acceptance Criteria

- [ ] Student can start trial once
- [ ] Premium features work during trial
- [ ] Trial expiry reverts to free limits
- [ ] M-Pesa payment during trial converts seamlessly
- [ ] Cannot start second trial
