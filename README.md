# Nexus — AI-powered study companion for CBC/KCSE (Kenya)

## Stack

- Next.js 16 (App Router) · TypeScript · Tailwind · shadcn/ui
- Supabase (Auth, Postgres, RLS)
- Nex AI tutor (Gemini Flash primary, OpenAI fallback)

## Local development

### Prerequisites

- Node.js 20+
- [Supabase CLI](https://supabase.com/docs/guides/cli)
- Docker (for local Supabase)

### Setup

**Windows (PowerShell):** Supabase is not required globally — use the npm scripts below (they run the local CLI from `node_modules`).

```powershell
# Install dependencies (includes Supabase CLI)
npm install

# Copy environment variables
Copy-Item .env.example .env.local

# Start local Supabase (Postgres, Auth, Studio) — requires Docker Desktop running
npm run supabase:start

# Reset DB with migrations + seed
npm run db:reset

# Paste keys from `npm run supabase:status` into .env.local, then:
npm run dev
```

**macOS / Linux:**

```bash
npm install
cp .env.example .env.local
npm run supabase:start
npm run db:reset
npm run dev
```

After `npm run supabase:start`, run `npm run supabase:status` and copy `API URL`, `anon key`, and `service_role key` into `.env.local`.

Open [http://localhost:3000](http://localhost:3000). Supabase Studio: [http://localhost:54323](http://localhost:54323).

### Scripts

| Command | Description |
|---------|-------------|
| `npm run dev` | Start dev server |
| `npm run supabase:start` | Start local Supabase (Docker required) |
| `npm run supabase:status` | Show local URLs and API keys |
| `npm run db:reset` | Apply migrations + seed data |
| `npm run build` | Production build |
| `npm run lint` | ESLint |
| `npm run typecheck` | TypeScript check |
| `npm test` | Vitest unit/integration tests |
| `npm run test:scope-check` | MVP scope guardrails |

## Project structure

See [docs/phase-1-foundation/technical-architecture.md](docs/phase-1-foundation/technical-architecture.md).

## Documentation

Full product and engineering docs: [docs/README.md](docs/README.md).

Local setup troubleshooting: [docs/LOCAL-DEV.md](docs/LOCAL-DEV.md) · Staging deploy: [docs/DEPLOYMENT.md](docs/DEPLOYMENT.md)

## Agent workflow

Wave planning artifacts live in `.planning/waves/`. See `.planning/templates/` for Overseer and QA report formats.
