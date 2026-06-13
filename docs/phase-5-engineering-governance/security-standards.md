# Security Standards

**Version:** 1.0

---

## 1. Authentication

- Supabase Auth for all identity
- Session via `@supabase/ssr` cookie pattern
- Google OAuth configured in Supabase dashboard
- Middleware protects `(student)` and `(parent)` route groups
- Never trust client-side role checks alone

---

## 2. Authorization

- RLS on every public table
- `user_metadata` never used in RLS — use profile tables or `app_metadata`
- Parents read-only on linked student data
- Service role restricted to server/webhook contexts
- **`super_admin` only** for `/api/admin/*` and `(super-admin)/*` routes
- `platform_settings` never writable by student/parent JWT

---

## 3. Secrets Management

| Secret | Storage |
|--------|---------|
| `SUPABASE_SERVICE_ROLE_KEY` | Vercel env (server only) |
| `MPESA_*` | Vercel env (server only) |
| `CELCOM_*` | Vercel env (server only) |
| `RESEND_*` | Vercel env (server only) |
| `GEMINI_API_KEY` | Vercel env (server only) — Nex primary |
| `OPENAI_API_KEY` | Vercel env (server only) — Nex fallback |
| `NEXT_PUBLIC_SUPABASE_URL` | Public (OK) |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Public (OK — RLS protects) |

Never commit `.env.local`. Use `.env.example` with empty values.

---

## 4. Input Validation

- Zod validate all API inputs
- Sanitize user content before AI prompts (no prompt injection mitigation V1 beyond system prompt — document as V2 hardening)
- Phone numbers: validate +254 format
- SQL: use Supabase query builder — no raw string concatenation

---

## 5. Payment Security

- M-Pesa callbacks logged but PIN never stored
- Idempotent payment processing
- Amount verification against plan before activation
- Rate limit payment initiation

---

## 6. AI Safety

- Server-side Nex calls only
- Log all conversations in `nex_messages`
- Content safety rules in [Nex AI Spec](../phase-2-product-systems/nex-ai-specification.md)
- Rate limit prevents abuse/cost overrun

---

## 7. Data Privacy

- Student data accessible only to student and linked parents
- No PII in application logs (truncate phone/email)
- SMS/email logs retained 90 days
- Kenya Data Protection Act awareness — minimal data collection

---

## 8. Headers (Vercel)

```
X-Frame-Options: DENY
X-Content-Type-Options: nosniff
Referrer-Policy: strict-origin-when-cross-origin
```

Configure via `next.config.ts` headers.

---

## 9. Dependency Security

- Run `npm audit` before releases
- Pin major dependency versions
- Review new packages before adding

---

## 10. Incident Response

1. Rotate compromised secrets immediately
2. Revoke Supabase sessions if auth breach suspected
3. Check `mpesa_callbacks` and `nex_messages` for anomalies
4. Notify affected users per Kenya regulations (manual V1)

---

## 11. Pre-Deploy Security Checklist

```
[ ] RLS enabled on all new tables
[ ] No secrets in client bundle (check build output)
[ ] Webhook endpoints validate origin where possible
[ ] Admin client not imported in client components
[ ] CORS not overly permissive on API routes
[ ] Error responses do not leak stack traces in production
```
