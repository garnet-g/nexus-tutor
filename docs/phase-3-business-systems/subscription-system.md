# Subscription System

**Version:** 1.1  
**Model:** Freemium — **free forever** with daily usage caps; paid plans raise those caps.

---

## 1. Monetization Model

### Freemium (Free Forever)

Every student gets a permanent **free** plan. It never expires.

- Full access to core learning (Learn, Diagnostic, Health Score, Progress, basic Nex)
- **Daily usage limits** reset at midnight `Africa/Nairobi`
- When a limit is hit → `429 RATE_LIMITED` + upgrade CTA to Premium
- Downgrade from paid → returns to free limits; **all progress data preserved**

Paid plans do **not** replace free — they **raise daily limits** and unlock premium-only features.

---

## 2. Plans & Pricing

| plan_code | Name | Price (KES/month) | Seats | V1 Status |
|-----------|------|-------------------|-------|-----------|
| `free` | Free | **0 — forever** | 1 student | Active |
| `premium` | Premium Individual | **799** | 1 student | Active |
| `family` | Family | **2,499** | **Up to 4 students** | Active |
| `school` | School | Custom | — | **V2** |

Seed `subscription_plans` with launch defaults: `0`, `799`, `2499`. **Super admins can change live values** via [Platform Admin System](./platform-admin-system.md) without redeploying.

---

## 3. Daily Usage Limits

Limits are enforced **server-side** from `platform_settings` (with constant fallbacks).

| Limit | Free (daily) | Premium / Family (daily) | Launch default |
|-------|----------------|---------------------------|----------------|
| **Nex chat messages** | configurable | configurable | 10 / 75 |
| **Practice sessions** | configurable | configurable | 3 / 20 |
| **Exam study plan generation** | — | Unlimited | — |
| **Daily topic recommendation** | ✓ | ✓ | — |

### Launch defaults (`src/constants/subscription.constants.ts`)

Used **only as fallback** if DB unavailable:

```ts
export const DEFAULT_FREE_DAILY_NEX_MESSAGE_LIMIT = 10;
export const DEFAULT_FREE_DAILY_PRACTICE_SESSION_LIMIT = 3;
export const DEFAULT_PREMIUM_DAILY_NEX_MESSAGE_LIMIT = 75;
export const DEFAULT_PREMIUM_DAILY_PRACTICE_SESSION_LIMIT = 20;
export const DEFAULT_FAMILY_MAX_STUDENTS = 4;
export const DEFAULT_PREMIUM_AMOUNT_KES = 799;
export const DEFAULT_FAMILY_AMOUNT_KES = 2499;
```

**Runtime:** always call `getEffectiveSubscriptionConfig()` from `lib/platform/getPlatformSettings.ts`.

---

## 4. Feature Matrix

| Feature | Free | Premium | Family (4 seats) |
|---------|------|---------|------------------|
| Learn content | ✓ | ✓ | ✓ per student |
| Diagnostic + Health Score | ✓ | ✓ | ✓ |
| Predicted grade (dashboard) | ✓ | ✓ | ✓ |
| Nex chat | 10/day | 75/day | 75/day per student |
| Practice sessions | 3/day | 20/day | 20/day per student |
| Daily topic recommendation | ✓ | ✓ | ✓ |
| Exam study plan | — | ✓ | ✓ |
| Parent weekly email report | — | ✓ | ✓ |
| Parent in-app dashboard | ✓ when linked | ✓ | ✓ |
| Camera tutoring | V2 | V2 | V2 |
| AI mock exams | V2 | V2 | V2 |

---

## 5. Subscription Statuses

```
trialing | active | past_due | cancelled | expired
```

| Status | Meaning |
|--------|---------|
| `trialing` | Free trial — premium limits for 7 days |
| `active` | Paid plan current |
| `past_due` | Renewal failed — grace period |
| `cancelled` | Cancelled — access until period end |
| `expired` | Paid period ended → **revert to free forever limits** |

---

## 6. Lifecycle

```
Signup → free plan (forever, daily caps)
    ↓
Optional: startFreeTrial() → premium limits for 7 days
    ↓
Trial ends → back to free daily caps OR M-Pesa payment
    ↓
M-Pesa payment success → active (premium or family)
    ↓
Period end without renewal → expired → free forever daily caps
```

---

## 7. Activation Rules

Subscription becomes `active` when **all** true:

1. `mpesa_payments.payment_status = 'paid'`
2. `mpesa_receipt_number` present
3. Idempotent activation not already processed
4. Matching `subscription_plan_id`

```ts
student_subscriptions.subscription_status = 'active'
student_subscriptions.current_period_start = now()
student_subscriptions.current_period_end = now() + 30 days
// Family: link up to 4 student seats under billing account
```

---

## 8. Family Plan

- **KES 2,499 / month**
- **Up to 4 student accounts** per family subscription
- Each linked student receives **premium daily limits** (75 Nex / 20 practice)
- Parent initiates M-Pesa payment; students linked via invite code
- **V1:** Basic linking; no household analytics dashboard

---

## 9. Server Checks

```ts
const config = await getEffectiveSubscriptionConfig();
const limits = config.limits;

const nexCount = await getNexMessageCountToday(studentId);
if (nexCount >= limits.freeNex /* or premium based on plan */) throw RATE_LIMITED;
```

M-Pesa amount at checkout:

```ts
const { pricing } = await getEffectiveSubscriptionConfig();
const amountKes = planCode === 'premium'
  ? pricing.premiumAmountKes   // includes active promotion override
  : pricing.familyAmountKes;
```

Premium-only features (exam study plan):

```ts
if (!hasPremiumAccess(studentId)) throw SUBSCRIPTION_REQUIRED;
```

---

## 10. Downgrade / Expiry

On `expired` or cancellation after period end:

- Revert to **free forever** daily caps (10 Nex, 3 practice)
- Preserve all progress, mastery, health score, history
- Show upgrade prompt when limits hit

---

## 11. Database Tables

- `subscription_plans` — seed with `free`, `premium` (799), `family` (2499)
- `student_subscriptions`
- `subscription_trials`
- `billing_events`
- `invoices`

---

## 12. Platform Admin

Super admins change prices, daily limits, and promotions from `/admin/platform-settings`. See [Platform Admin System](./platform-admin-system.md).

---

## 13. Acceptance Criteria

- [ ] Free user can use Nexus indefinitely within daily caps
- [ ] Free user hits Nex/practice limit with clear upgrade CTA (Premium KES 799)
- [ ] Super admin can change premium price (e.g. 799 → 699) without deploy
- [ ] M-Pesa and pricing page reflect new amount within 60s
- [ ] Family plan supports up to 4 students with premium limits each
- [ ] Expired paid subscription reverts to free caps, not locked out
- [ ] All limits enforced server-side
