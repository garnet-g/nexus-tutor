# Local Development Guide

## Prerequisites

- Node.js 20+
- Docker Desktop (running)
- npm

Supabase CLI is included as a project dependency — no global install required.

## Quick start (Windows PowerShell)

```powershell
cd "C:\Users\gar\Desktop\Garnet Labs\nexus"
npm install
Copy-Item .env.example .env.local
npm run supabase:start
npm run supabase:status
```

Copy `API URL`, `anon key`, and `service_role key` from status output into `.env.local`.

```powershell
npm run db:reset
npm run dev
```

Open http://localhost:3000 · Supabase Studio http://localhost:54323

## Common issues

| Problem | Fix |
|---------|-----|
| `supabase` not recognized | Use `npm run supabase:start` instead of bare `supabase` |
| Docker pipe error | Start Docker Desktop and wait until Running |
| Build fails on admin pages | Set Supabase keys in `.env.local` |
| Nex returns mock responses | Set `GEMINI_API_KEY` or keep `NEX_MOCK_AI=true` |
| Voice push-to-talk silent / mock audio | Set `OPENAI_API_KEY` for TTS, or use mock WAV in dev without keys |

## Useful commands

| Command | Purpose |
|---------|---------|
| `npm run supabase:status` | Show local URLs and keys |
| `npm run db:reset` | Migrations + seed |
| `npm test` | Unit tests (includes 20 Nex golden cases) |
| `npm run test:e2e` | Playwright smoke (dev server auto-starts) |
| `npm run test:e2e:ci` | Build + e2e against `next start` (set `CI=true`) |
| `npm run deploy:check` | Pre-deploy lint + typecheck + test + build |

## E2E authenticated tests (optional)

Public smoke runs without credentials. Student auth gate tests require a seeded student in your local/staging Supabase:

```powershell
$env:E2E_STUDENT_EMAIL="student@example.com"
$env:E2E_STUDENT_PASSWORD="your-test-password"
npm run test:e2e
```

For CI parity locally:

```powershell
$env:CI="true"
npm run test:e2e:ci
```

Do not commit credentials. Use a dedicated test account from `supabase/seed.sql` or create one manually after `db:reset`.

## Beta mode locally

Set in `.env.local`:

```
BETA_INVITE_REQUIRED=true
```

Generate invites at `/admin/beta-invites` (super_admin account required).

## Weekly reports cron

Test locally:

```powershell
curl -H "Authorization: Bearer YOUR_CRON_SECRET" http://localhost:3000/api/cron/weekly-reports
```

See [DEPLOYMENT.md](./DEPLOYMENT.md) for staging/production setup.

## Nex AI keys (text, camera, voice)

Optional in `.env.local` for real model calls:

```
GEMINI_API_KEY=your-gemini-key
OPENAI_API_KEY=your-openai-key
```

- Text + vision: Gemini primary, OpenAI fallback (`callNexModel`)
- Voice STT: Gemini primary, Whisper fallback (`voiceTranscribe`)
- Voice TTS: Gemini preview TTS when available, OpenAI `tts-1` fallback (`voiceSynthesize`)

Without keys, Nex uses mock text responses and mock voice transcript/audio in tests and local dev.
