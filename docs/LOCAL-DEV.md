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

## Dev login accounts

After `npm run db:reset`, fixed local accounts are created automatically (`npm run db:seed-dev-users` also works on its own):

| Role | Email | Password |
|------|-------|----------|
| Student (ready to use) | `student@nexus.local` | `NexusDev1` |
| Super admin | `admin@nexus.local` | `NexusDev1` |

The student account skips onboarding and diagnostic — you land on `/dashboard` after login.

These accounts persist across `npm run dev` restarts. You only need to re-seed after `db:reset` or wiping local Supabase Docker volumes.

If accounts are missing, run:

```powershell
npm run db:seed-dev-users
```

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

Public smoke runs without credentials. Student auth gate tests use the seeded dev student by default:

```powershell
$env:E2E_STUDENT_EMAIL="student@nexus.local"
$env:E2E_STUDENT_PASSWORD="NexusDev1"
npm run test:e2e
```

Run `npm run db:seed-dev-users` first if those accounts do not exist yet.

For CI parity locally:

```powershell
$env:CI="true"
npm run test:e2e:ci
```

Do not commit credentials. For local dev, use the seeded accounts from `npm run db:seed-dev-users` (see Dev login accounts above).

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
NEX_GEMINI_TEXT_MODEL=gemini-3.5-flash
NEX_GEMINI_VISION_MODEL=gemini-3.5-flash
NEX_GEMINI_TTS_MODEL=gemini-3.1-flash-tts
```

- Text + vision: Gemini primary, OpenAI fallback (`callNexModel`)
- Voice STT: Gemini primary, Whisper fallback (`voiceTranscribe`)
- Voice TTS: Gemini preview TTS when available, OpenAI `tts-1` fallback (`voiceSynthesize`)

Without keys, Nex uses mock text responses and mock voice transcript/audio in tests and local dev.
