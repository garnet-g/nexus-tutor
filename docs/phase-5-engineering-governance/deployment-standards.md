# Deployment Standards

**Version:** 1.0  
**Hosting:** Vercel · **Database/Auth:** Supabase

---

## 1. Environments

| Environment | Branch | Supabase | URL |
|-------------|--------|----------|-----|
| Development | local | Local or dev project | localhost:3000 |
| Preview | PR branches | Dev project | *.vercel.app |
| Production | main | Prod project | nexus.app |

Never point preview deployments at production Supabase.

---

## 2. Vercel Configuration

- Framework: Next.js
- Node version: 20 LTS
- Environment variables set per environment in Vercel dashboard
- Preview deployments require approval before production promote (recommended)

---

## 3. Supabase Migrations

### Deploy Flow

```bash
# Local development
supabase migration new create_student_profiles
supabase db reset          # local only
supabase db push           # dev project

# Production (via CI or manual with approval)
supabase db push --linked  # prod project
```

**Rules:**
1. Test migrations on dev before prod
2. Never edit applied migration files — create new migration to fix
3. Backup prod before destructive changes
4. RLS policies deployed with tables

---

## 4. Environment Variables Checklist

### Required (All Environments)

```env
NEXT_PUBLIC_APP_NAME=Nexus
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
GEMINI_API_KEY=
OPENAI_API_KEY=
```

### Production Additional

```env
MPESA_CONSUMER_KEY=
MPESA_CONSUMER_SECRET=
MPESA_SHORTCODE=
MPESA_PASSKEY=
MPESA_CALLBACK_URL=https://nexus.app/api/mpesa/callback
MPESA_ENV=production

CELCOM_PARTNER_ID=
CELCOM_API_KEY=
CELCOM_SHORTCODE=
CELCOM_CALLBACK_URL=

RESEND_API_KEY=
RESEND_FROM_EMAIL=
```

---

## 5. M-Pesa Daraja Setup

1. Register callback URL in Safaricom portal
2. Production URL must be HTTPS
3. Sandbox for dev/preview; production credentials only on prod
4. Verify callback reachable before go-live

---

## 6. Domain & SSL

- Custom domain on Vercel
- SSL automatic via Vercel
- Redirect www → apex or vice versa (choose one)

---

## 7. CI Pipeline (Recommended)

```yaml
# On PR
- lint
- typecheck
- test
- build

# On merge to main
- deploy to Vercel production
- run supabase migrations (manual gate or automated with approval)
```

---

## 8. Rollback

| Layer | Rollback |
|-------|----------|
| Vercel | Redeploy previous deployment from dashboard |
| Database | Forward-fix migration only — no down migrations in prod |
| Feature flag | Env var toggle if implemented |

---

## 9. Monitoring (V1 Minimal)

- Vercel Analytics (web vitals)
- Supabase dashboard (DB metrics, auth logs)
- Application error logging (Vercel logs or Sentry V2)
- M-Pesa callback failure alerts (manual log review V1)

---

## 10. Release Checklist

```
[ ] All migrations applied to prod Supabase
[ ] Env vars set on Vercel prod
[ ] M-Pesa callback URL points to prod
[ ] Celcom/Resend credentials are production
[ ] Seed data loaded (curriculum, questions, plans)
[ ] Manual QA on prod smoke test
[ ] Rollback plan documented
```

---

## 11. Seed Data Deployment

Curriculum content deployed via:
1. `supabase/seed/` for dev
2. Production seed script run once at launch (idempotent upserts)
3. Content updates via new seed migration — not manual SQL in prod console

---

## 12. Do Not

- Push to GitHub without user permission
- Run destructive DB commands on production without approval
- Deploy with RLS disabled
- Use production M-Pesa credentials in preview environments
