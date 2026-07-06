# Data retention policy (Phase F4 / PR-107)

This document defines **notification and learning-data** retention for the Nexus product layer. It implements **DEC-006 option (A)**: keep the repository’s established **90-day** notification log retention (`docs/phase-3-business-systems/notification-spec.md`, `docs/phase-5-engineering-governance/security-standards.md`).

## In scope (enforced by `/api/cron/data-retention`)

| Domain | Tables | Retention | Notes |
|--------|--------|-----------|-------|
| Notification delivery logs | `celcom_sms_logs`, `resend_email_logs` | **90 days** | Raw bodies/phones stored in DB only for ops; exports are redacted (PR-058). |
| Notification outbox | `notification_outbox` | **90 days** (`sent`, `dead_letter` only) | Pending/retry rows are retained until resolved. |
| Parent learning summaries | `parent_reports`, `weekly_reports` | **365 days** | Weekly progress payloads for linked parents. |
| View-as evidence | `admin_impersonation_sessions` | **90 days** after `expires_at` | PR-128 impersonation retention. |

## Out of scope — Auth track seam

The following belong to the **auth account lifecycle** track and are **not** implemented here:

- `account_deletion_requests`
- Account email/password changes
- Full user profile erasure

When account deletion ships in the auth track, it must call into shared retention helpers or supersede rows documented above. Until then, cron enforcement covers notification/learning data only.

## Enforcement

- Job: `GET|POST /api/cron/data-retention` (Bearer `CRON_SECRET`, fail-closed when unset)
- Implementation: `src/server/services/retentionEnforcementService.ts`
- Constants: `src/lib/privacy/retentionPolicy.ts`

## Redaction (PR-058)

Operator exports and log snapshots must never include raw phone numbers or message bodies. Use `src/lib/privacy/notificationLogSerializer.ts` and `src/lib/privacy/redaction.ts`.
