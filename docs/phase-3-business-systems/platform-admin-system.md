# Platform Admin System

**Version:** 1.0  
**Role:** `super_admin`  
**Purpose:** Change pricing, daily limits, and promotions without code deploys.

---

## 1. Overview

Super admins manage **live commercial settings** from an internal control panel. Students always see current values from the database — not hardcoded constants.

Use cases:

- Promotional pricing (e.g. Premium 699 for a holiday campaign)
- Temporary limit boosts (e.g. free Nex 15/day during exam season)
- Family seat adjustments
- Enable/disable plans without redeploying

**Rule:** `src/constants/subscription.constants.ts` holds **launch defaults only** (fallback if DB read fails). Runtime always prefers `platform_settings` + `subscription_plans`.

---

## 2. Super Admin Role

| Field | Value |
|-------|-------|
| `userRole` in `app_metadata` | `super_admin` |
| Access | Internal only — not self-signup |
| Provisioning | Manual via Supabase Auth admin or seed script |

**Distinct from:**

| Role | Access |
|------|--------|
| `student` | Student app |
| `parent` | Parent dashboard |
| `super_admin` | Platform control panel + all settings below |

Do not expose super admin signup in public UI.

---

## 3. Control Panel (V1)

Route group: `(super-admin)/`

| Screen | Route | Actions |
|--------|-------|---------|
| Platform Settings | `/admin/platform-settings` | Edit daily limits, family seats, promotion banner |
| Subscription Plans | `/admin/subscription-plans` | Edit `amount_kes`, plan active flag, display name |
| Settings Audit Log | `/admin/platform-settings/audit` | Read-only change history |

**V1 scope:** Web panel, desktop-first, super_admin auth required. No mobile app.

---

## 4. Configurable Settings

### 4.1 Daily usage limits (`platform_settings`)

| setting_key | Type | Launch default |
|-------------|------|----------------|
| `free_daily_nex_message_limit` | integer | 10 |
| `free_daily_practice_session_limit` | integer | 3 |
| `premium_daily_nex_message_limit` | integer | 75 |
| `premium_daily_practice_session_limit` | integer | 20 |
| `family_max_students` | integer | 4 |

### 4.2 Plan pricing (`subscription_plans`)

| plan_code | Editable fields |
|-----------|-----------------|
| `premium` | `amount_kes`, `name`, `is_active`, `promotion_label` |
| `family` | `amount_kes`, `name`, `is_active`, `promotion_label` |
| `free` | `is_active` only (always 0 KES) |

### 4.3 Promotions (`platform_settings`)

| setting_key | Type | Example |
|-------------|------|---------|
| `promotion_is_active` | boolean | `true` |
| `promotion_title` | string | `Exam Season — Premium KES 699` |
| `promotion_ends_at` | timestamptz | Campaign end |
| `promotion_premium_amount_kes` | integer | Optional override; when set, M-Pesa uses this instead of `subscription_plans.amount_kes` until `promotion_ends_at` |

When `promotion_premium_amount_kes` is active and not expired → checkout and pricing page show promotional price. Audit log records every change.

---

## 5. Runtime Resolution

```ts
// lib/platform/getPlatformSettings.ts
export async function getEffectiveSubscriptionConfig() {
  const settings = await loadPlatformSettings(); // cached 60s in Redis/memory
  const plans = await loadSubscriptionPlans();

  return {
    limits: {
      freeNex: settings.free_daily_nex_message_limit ?? DEFAULTS.freeNex,
      freePractice: settings.free_daily_practice_session_limit ?? DEFAULTS.freePractice,
      premiumNex: settings.premium_daily_nex_message_limit ?? DEFAULTS.premiumNex,
      premiumPractice: settings.premium_daily_practice_session_limit ?? DEFAULTS.premiumPractice,
      familyMaxStudents: settings.family_max_students ?? DEFAULTS.familyMaxStudents,
    },
    pricing: {
      premiumAmountKes: resolvePromoPrice(plans.premium, settings),
      familyAmountKes: plans.family.amount_kes,
    },
    promotion: {
      isActive: settings.promotion_is_active,
      title: settings.promotion_title,
      endsAt: settings.promotion_ends_at,
    },
  };
}
```

**M-Pesa initiate** must call `getEffectiveSubscriptionConfig()` for `amount_kes` — never hardcode 799 in route handlers.

**Rate limit checks** must use resolved limits — never hardcode 10/75 in Nex routes.

---

## 6. Caching

| Layer | TTL | Invalidation |
|-------|-----|--------------|
| In-memory / edge cache | 60 seconds | On successful PATCH from admin |
| Client pricing page | Revalidate on navigation | — |

After admin saves settings → purge cache immediately so changes apply within seconds.

---

## 7. Audit Log

Every super admin write creates a row in `platform_settings_audit_log`:

```ts
{
  superAdminUserId,
  changeType: 'platform_setting' | 'subscription_plan' | 'promotion',
  settingKey,
  previousValue,
  newValue,
  changeReason,        // optional admin note: "December promo"
  createdAt,
}
```

Audit log is **append-only**. No deletes.

---

## 8. API Routes

See [API Standards — Admin](../phase-1-foundation/api-standards.md#19-admin-routes-super_admin).

All routes require `app_metadata.userRole === 'super_admin'`.

---

## 9. Security Rules

1. Super admin routes return `403` for student/parent tokens
2. RLS: `platform_settings` and audit log — **no** student/parent policies; super_admin via server + service role only
3. Never expose super admin panel URL in public sitemap
4. All changes logged with `super_admin_user_id`
5. Validate bounds server-side (e.g. limits 1–500, prices 1–100000 KES)
6. Rate limit admin PATCH: 30/hour per admin

---

## 10. Acceptance Criteria

- [ ] Super admin can change premium price from 799 to 699 without deploy
- [ ] Pricing page and M-Pesa STK use new amount within 60s
- [ ] Super admin can change free/premium daily Nex limits
- [ ] Rate limiting uses new limits after cache purge
- [ ] Every change appears in audit log with previous/new values
- [ ] Student/parent cannot read or write platform settings via API
- [ ] Promotion override expires automatically at `promotion_ends_at`

---

## 11. Related Documents

- [Subscription System](./subscription-system.md)
- [Database Schema — Platform Admin](../phase-1-foundation/database-schema.md#310-platform-admin)
- [Security Standards](../phase-5-engineering-governance/security-standards.md)
