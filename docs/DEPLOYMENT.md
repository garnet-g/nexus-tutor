# Nexus Staging Deployment

This guide covers deploying Nexus to a **staging** environment using Supabase (database + auth) and Vercel (Next.js hosting).

---

## Prerequisites

- [Supabase CLI](https://supabase.com/docs/guides/cli) installed and logged in
- [Vercel CLI](https://vercel.com/docs/cli) (optional) or Vercel dashboard access
- Node.js 20 LTS
- A dedicated **staging** Supabase project (never use production credentials for preview/staging)

---

## 1. Supabase Staging Setup

### Create the project

1. Create a new project in the [Supabase dashboard](https://supabase.com/dashboard) (e.g. `nexus-staging`).
2. Note the project URL, anon key, and service role key from **Project Settings → API**.

### Link and migrate

```bash
cd nexus
supabase link --project-ref <your-staging-project-ref>
supabase db push
```

This applies all migrations in `supabase/migrations/`, including RLS policies and beta invite tables.

### Auth configuration

In **Authentication → URL Configuration**, set:

| Setting | Staging value |
|---------|---------------|
| Site URL | `https://<your-staging-domain>.vercel.app` |
| Redirect URLs | `https://<your-staging-domain>.vercel.app/auth/callback` |

Enable Email and Google providers as needed. Use Google OAuth credentials scoped to the staging domain.

### Seed data (optional)

```bash
supabase db reset   # local only — never on staging/prod without approval
```

For staging, run idempotent seed scripts or apply content migrations once after `db push`.

---

## 2. Vercel Staging Setup

### Import the repository

1. Import the GitHub repo in [Vercel](https://vercel.com/new).
2. Framework preset: **Next.js**
3. Node.js version: **20.x**
4. Create a **Preview** deployment from a staging branch, or deploy `main` to a staging project.

### Environment variables

Set these in **Vercel → Project → Settings → Environment Variables** for Preview/Staging:

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=https://<project-ref>.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=<anon-key>
SUPABASE_SERVICE_ROLE_KEY=<service-role-key>

# App
NEXT_PUBLIC_APP_URL=https://<your-staging-domain>.vercel.app

# Cron (weekly parent reports — must match Authorization header)
CRON_SECRET=<generate-a-long-random-secret>

# Beta gate (set true to require invite codes on signup)
BETA_INVITE_REQUIRED=true

# Sentry (optional — leave empty to disable)
SENTRY_DSN=
NEXT_PUBLIC_SENTRY_DSN=

# AI
GEMINI_API_KEY=
OPENAI_API_KEY=

# M-Pesa (sandbox for staging)
MPESA_CONSUMER_KEY=
MPESA_CONSUMER_SECRET=
MPESA_PASSKEY=
MPESA_SHORTCODE=
MPESA_CALLBACK_URL=https://<your-staging-domain>.vercel.app/api/mpesa/callback
MPESA_ENV=sandbox

# Notifications (mock adapters used when empty)
CELCOM_PARTNER_ID=
CELCOM_API_KEY=
CELCOM_SHORTCODE=
RESEND_API_KEY=
RESEND_FROM_EMAIL=noreply@nexus.co.ke

# Dev flags (staging)
NEX_MOCK_AI=false
NOTIFICATIONS_MOCK=false
```

Copy values from `.env.example` as a checklist. Never commit secrets to the repository.

### Cron job

`vercel.json` schedules weekly parent reports:

- **Path:** `/api/cron/weekly-reports`
- **Schedule:** `0 5 * * 1` (Mondays 05:00 UTC — 08:00 Kenya / EAT)

Vercel sends `Authorization: Bearer <CRON_SECRET>`. Ensure `CRON_SECRET` is set in Vercel env vars. Cron jobs require a Vercel Pro plan or higher.

---

## 3. Pre-deploy verification

Run locally before pushing:

```bash
npm run deploy:check
```

This runs lint, typecheck, tests, and production build.

---

## 4. CI pipeline

GitHub Actions (`.github/workflows/ci.yml`) runs on every PR:

- ESLint
- TypeScript check
- Vitest
- Scope check
- Production build
- Optional Supabase DB lint (`continue-on-error`)

---

## 5. Post-deploy smoke test

```
[ ] Sign up with a beta invite code (when BETA_INVITE_REQUIRED=true)
[ ] Complete student onboarding
[ ] Run diagnostic assessment
[ ] Trigger a test M-Pesa sandbox payment
[ ] Confirm super-admin can manage beta invites at /admin/beta-invites
[ ] Verify weekly cron endpoint returns 401 without CRON_SECRET
[ ] Check Sentry receives a test error (if DSN configured)
```

---

## 6. Promoting to production

1. Apply the same migrations to the **production** Supabase project (`supabase link` + `supabase db push`).
2. Set production env vars on the production Vercel project.
3. Set `BETA_INVITE_REQUIRED=false` when opening public registration.
4. Switch M-Pesa to `MPESA_ENV=production` with live Daraja credentials.
5. Use production Celcom/Resend keys.

See also: [deployment-standards.md](./phase-5-engineering-governance/deployment-standards.md)
