# Notification Specification

**Version:** 1.0  
**SMS:** Celcom · **Email:** Resend

---

## 1. Architecture

```
Trigger Event (server)
    ↓
Notification Service
    ├── sendCelcomSms() → celcom_sms_logs
    └── sendResendEmail() → resend_email_logs
```

All notifications are **server-triggered**. Client never calls SMS/email APIs directly with secrets.

---

## 2. Celcom SMS Templates

### Template Registry (`sms_templates`)

| template_code | Trigger | SMS Body |
|---------------|---------|----------|
| `welcome_student` | Student signup complete | `Karibu Nexus, {{studentName}}! Nex is ready to help you learn. Start your diagnostic today: {{appUrl}}` |
| `diagnostic_complete` | Diagnostic submitted | `Great work {{studentName}}! Your Academic Health Score is {{healthScore}}%. Log in to see your study plan: {{appUrl}}` |
| `payment_success` | M-Pesa paid | `Nexus: Payment of KES {{amountKes}} received. Ref: {{mpesaReceiptNumber}}. Your {{planName}} plan is now active.` |
| `payment_failed` | M-Pesa failed | `Nexus: Payment of KES {{amountKes}} was not completed. Try again: {{appUrl}}/subscription` |
| `trial_ending` | 2 days before trial end | `Nexus: Your free trial ends in {{daysRemaining}} days. Upgrade to keep unlimited Nex access: {{appUrl}}/subscription` |
| `trial_expired` | Trial expired | `Nexus: Your trial has ended. Upgrade to Premium for unlimited tutoring: {{appUrl}}/subscription` |
| `weekly_streak` | 7-day streak achieved | `Nexus: {{studentName}}, you've hit a 7-day study streak! Keep going! 🔥` |
| `parent_link_success` | Parent linked to student | `Nexus: You are now linked to {{studentName}}'s progress. View dashboard: {{appUrl}}/parent` |
| `otp_verification` | Phone verification (if enabled) | `Nexus: Your verification code is {{otpCode}}. Valid for 10 minutes.` |

### SMS Statuses

```
queued → sent → delivered
              → failed
```

### Celcom Functions

```ts
sendCelcomSms({ phoneNumber, templateCode, templateVariables })
sendCelcomOtp({ phoneNumber, otpCode })
logCelcomSms()
handleCelcomDeliveryReport()
```

---

## 3. Resend Email Templates

### Template Registry (`email_templates`)

| template_code | Trigger | Subject |
|---------------|---------|---------|
| `welcome_student` | Signup (if email provided) | `Welcome to Nexus, {{studentName}}!` |
| `welcome_parent` | Parent signup | `Welcome to Nexus Parent Corner` |
| `payment_receipt` | M-Pesa paid | `Nexus Payment Receipt — KES {{amountKes}}` |
| `parent_weekly_report` | Weekly cron (Sunday 6pm EAT) | `{{studentName}}'s Weekly Progress Report` |
| `trial_ending` | 2 days before trial end | `Your Nexus trial ends in {{daysRemaining}} days` |
| `subscription_expired` | Subscription expired | `Your Nexus Premium subscription has expired` |
| `password_reset` | Supabase auth reset | Handled by Supabase Auth email OR Resend wrapper |

### Email Body Structure (HTML)

All emails share layout:
- Nexus header (logo + brand color)
- Content block with variables
- CTA button → `{{appUrl}}`
- Footer: support email, unsubscribe (transactional exempt)

### `parent_weekly_report` Content

```
Hi {{parentName}},

Here's {{studentName}}'s progress this week:

Study Time: {{weeklyStudyMinutes}} minutes
Academic Health Score: {{healthScore}}%
Predicted Grade: {{predictedGrade}}
Weak Areas: {{weeklyWeakTopics}}

View full dashboard → {{appUrl}}/parent
```

### Email Statuses

```
queued → sent → delivered → opened
              → failed
              → bounced
```

---

## 4. Trigger Matrix

| Event | SMS | Email | Recipients |
|-------|-----|-------|------------|
| Student signup | ✓ welcome | ✓ welcome | Student |
| Diagnostic complete | ✓ | — | Student (if phone) |
| M-Pesa success | ✓ | ✓ receipt | Payer phone + email |
| M-Pesa failed | ✓ | — | Payer phone |
| Trial ending (T-2) | ✓ | ✓ | Student |
| Trial expired | ✓ | ✓ | Student |
| 7-day streak | ✓ | — | Student |
| Parent link | ✓ | — | Parent |
| Weekly report | — | ✓ | Parent (premium) |
| Subscription expired | — | ✓ | Student |

---

## 5. When NOT to Notify

- Every Nex message (too noisy)
- Every practice session completion
- Marketing blasts (V2)
- Duplicate events within 1 hour (dedupe by `template_code + recipient + hour`)

---

## 6. Logging Rules

### Required Log Fields

Every send attempt writes to provider log table:

```ts
{
  templateCode,
  phoneNumber | recipientEmail,
  smsBody | emailSubject,
  smsStatus | emailStatus,
  providerMessageId,  // celcomMessageId | resendEmailId
  sentAt,
  errorMessage?,      // on failure
  studentId?,         // if applicable
  parentId?
}
```

### Log Levels

| Level | When |
|-------|------|
| INFO | Send initiated, send success |
| WARN | Retry attempt, delivery delayed |
| ERROR | Provider API failure, invalid template |
| DEBUG | Template rendered body (dev only, no PII in prod logs) |

### PII Rules

- **Do log:** template code, status, provider IDs, truncated phone (`+2547***5678`)
- **Do not log:** full message body in production app logs (DB log OK with retention policy)
- **Retention:** 90 days for SMS/email logs

### Failure Handling

```ts
try {
  await sendCelcomSms(...);
} catch (error) {
  await logCelcomSms({ ..., smsStatus: 'failed' });
  // Do not block payment activation on SMS failure
  logger.error('CELCOM_SMS_FAILED', { templateCode, error });
}
```

Notifications are **best-effort** — never fail payment activation because SMS failed.

---

## 7. API Routes

| Route | Purpose |
|-------|---------|
| `POST /api/celcom/send` | Internal send |
| `POST /api/celcom/callback` | Delivery report webhook |
| `POST /api/resend/send` | Internal send |

---

## 8. Environment Variables

```env
CELCOM_PARTNER_ID=
CELCOM_API_KEY=
CELCOM_SHORTCODE=
CELCOM_CALLBACK_URL=

RESEND_API_KEY=
RESEND_FROM_EMAIL=noreply@nexus.app
```

---

## 9. Acceptance Criteria

- [ ] Payment success triggers SMS within 30 seconds
- [ ] Parent weekly email sent Sunday 6pm EAT for premium linked parents
- [ ] All sends logged with status
- [ ] Failed SMS does not block core flows
- [ ] No duplicate welcome SMS on retry
- [ ] Templates use Nexus naming (healthScore, Nex, not chatbot)
