# Technical Architecture

**Version:** 1.0  
**Stack:** Next.js 16.2.9 · TypeScript · Tailwind · shadcn/ui · Supabase · Vercel · Nex (Gemini Flash primary, OpenAI fallback)

---

## 1. Architecture Rules

### 1.1 Core Principles

1. **Single Next.js app** — App Router only. No separate Express/Fastify backend.
2. **Supabase is the system of record** — Auth, Postgres, RLS, Storage (future).
3. **Server-first for secrets** — M-Pesa, Celcom, Resend, OpenAI service calls run on the server only.
4. **Feature-based organization** — Code grouped by product domain, not by technical layer alone.
5. **No duplicate systems** — One auth flow, one payment flow, one notification pipeline per provider.
6. **Kenya-first defaults** — Currency KES, phone +254, M-Pesa primary, Celcom SMS, Resend email.

### 1.2 Layer Boundaries

```
┌─────────────────────────────────────────────────────────┐
│  Browser (Client Components)                            │
│  - UI, forms, optimistic updates                        │
│  - Supabase anon/publishable key ONLY                   │
│  - NO service role, NO provider secrets                 │
└───────────────────────┬─────────────────────────────────┘
                        │ fetch / Server Actions
┌───────────────────────▼─────────────────────────────────┐
│  Next.js Server (Server Components, Route Handlers)     │
│  - Auth session validation                              │
│  - Business logic orchestration                         │
│  - Provider integrations (M-Pesa, Celcom, Resend, AI) │
└───────────────────────┬─────────────────────────────────┘
                        │ service role (server only)
┌───────────────────────▼─────────────────────────────────┐
│  Supabase (Postgres + Auth + RLS)                       │
│  - Persistent data                                      │
│  - Row-level security enforcement                       │
└─────────────────────────────────────────────────────────┘
```

---

## 1.3 Nex System

Nex is a dedicated subsystem — not a generic chat wrapper. The Socratic Tutor Engine sits between the student and the language model.

**Authority:** [`nex-socratic-tutor-engine.md`](../phase-2-product-systems/nex-socratic-tutor-engine.md) · [`nex-prompting-framework.md`](../phase-2-product-systems/nex-prompting-framework.md)

Nex is the **backbone of the app**. All learning systems feed Nex or execute Nex recommendations.

### Pipeline (V1)

```
Student
    ↓
Mode Detection                    ← required
    ↓
Socratic Tutor Engine             ← required
    ↓
Curriculum Context                ← optional (skip if no topic match)
    ↓
Student Memory                    ← optional (skip on first session / if empty)
    ↓
Gemini Flash                      ← primary (GEMINI_API_KEY)
    ↓  (on failure)
OpenAI                            ← fallback (OPENAI_API_KEY)
    ↓
Response Validator                ← required (block + regenerate once on fail)
    ↓
Student
```

**V1 note:** There is no abstract Model Router in code — primary/fallback is hardcoded in `lib/nex/callNexModel.ts`. A real router is V2+.

### Stage Responsibilities

| Stage | Required V1 | Location | Responsibility |
|-------|-------------|----------|----------------|
| Mode Detection | Yes | `lib/nex/detectNexMode.ts` | Classify → explain \| practice \| homework \| revision (assessment = V2) |
| Socratic Tutor Engine | Yes | `lib/nex/socraticTutorEngine.ts` | Hint level (max 3 before Level 4), misconception triggers |
| Curriculum Context | Optional | `lib/nex/loadCurriculumContext.ts` | Lesson excerpts when topic known |
| Student Memory | Optional | `lib/nex/loadStudentMemory.ts` | Derived from `topic_mastery`, `diagnostic_results`, recent activity — not full chat history |
| Gemini Flash | Yes | `lib/nex/callNexModel.ts` | Primary model |
| OpenAI | Fallback | `lib/nex/callNexModel.ts` | Used only if Gemini fails |
| Response Validator | Yes | `lib/nex/validateNexResponse.ts` | Block invalid response → regenerate once → safe fallback message |

### Code Layout

```
src/lib/nex/
├── generateNexResponse.ts      # Orchestrator
├── detectNexMode.ts
├── socraticTutorEngine.ts
├── loadCurriculumContext.ts    # skippable
├── loadStudentMemory.ts        # skippable
├── callNexModel.ts             # Gemini Flash → OpenAI fallback (V1)
├── validateNexResponse.ts
├── assemblePrompt.ts           # Templates from nex-prompting-framework.md
└── types.ts
```

### Model Rule

Gemini Flash is the **V1 primary**. OpenAI is **fallback only**. The Socratic Tutor Engine and prompting framework are the product IP — never bypass the pipeline from UI or route handlers.

### Response Validator (V1)

On validation failure: **block response → regenerate once** with stricter mode instructions. If second attempt fails, return a safe generic message (`NEX_RESPONSE_FAILED` logged).

Homework first-turn check uses **regex/heuristics + LLM judge** when ambiguous (see [Prompting Framework §12.1](../phase-2-product-systems/nex-prompting-framework.md#121-homework-answer-disclosure-validation-v1)).

---

## 2. Folder Structure

Aligned with [Naming Guidelines §17](../product-governance/naming-guidelines.md).

```
nexus/
├── docs/                          # This documentation set
├── supabase/
│   ├── migrations/                # Timestamped SQL migrations
│   ├── seed/                      # Dev seed data (curriculum, questions)
│   └── config.toml
├── src/
│   ├── app/                       # Next.js App Router
│   │   ├── (public)/              # Landing, pricing, about, login, signup
│   │   ├── (student)/             # Student authenticated routes
│   │   ├── (parent)/              # Parent authenticated routes
│   │   ├── (super-admin)/         # Platform control panel (super_admin only)
│   │   └── api/                   # Route handlers (kebab-case)
│   │       ├── nex/
│   │       ├── mpesa/
│   │       ├── celcom/
│   │       ├── resend/
│   │       ├── students/
│   │       ├── parents/
│   │       ├── study-plans/
│   │       ├── practice-sessions/
│   │       ├── progress/
│   │       ├── diagnostic-assessments/
│   │       └── admin/             # super_admin platform settings
│   ├── components/                # Shared UI (shadcn + Nexus wrappers)
│   │   └── ui/                    # shadcn primitives
│   ├── features/                  # Domain feature modules
│   │   ├── auth/
│   │   ├── onboarding/
│   │   ├── student-dashboard/
│   │   ├── nex/
│   │   ├── learn/
│   │   ├── practice/
│   │   ├── progress/
│   │   ├── parent-dashboard/
│   │   ├── payments/
│   │   ├── notifications/
│   │   ├── subscriptions/
│   │   └── platform-admin/
│   ├── lib/                       # Shared utilities
│   │   ├── platform/
│   │   │   └── getPlatformSettings.ts  # Runtime pricing + limits
│   │   ├── supabase/
│   │   │   ├── client.ts          # Browser client
│   │   │   ├── server.ts          # Server client (cookies)
│   │   │   └── admin.ts           # Service role (server only)
│   │   ├── mpesa/
│   │   ├── celcom/
│   │   ├── resend/
│   │   └── nex/                   # AI prompt assembly, mode routing
│   ├── server/                    # Server-only business logic
│   │   ├── services/              # Domain services (no React)
│   │   └── actions/               # Server Actions (thin wrappers)
│   ├── types/                     # Shared TypeScript types
│   ├── constants/                 # Domain constants (one file per domain)
│   └── schemas/                   # Zod validation schemas
├── public/
└── .env.local                     # Never committed
```

### Feature Module Internal Structure

Each feature folder follows:

```
features/nex/
├── components/       # NexChatPanel, NexMessageBubble, etc.
├── hooks/              # useNexSession, useNexChat
├── services/           # Client-safe helpers only
└── types.ts            # Feature-local types (re-export shared from src/types)
```

---

## 3. Server / Client Boundaries

### 3.1 Client Components (`"use client"`)

**Allowed:**
- Interactive UI (chat input, practice timer, streak animation)
- Client-side form state
- Supabase browser client for **read operations permitted by RLS**
- Calling Route Handlers and Server Actions

**Forbidden:**
- `SUPABASE_SERVICE_ROLE_KEY`
- `MPESA_*`, `CELCOM_*`, `RESEND_*`, `GEMINI_API_KEY`
- Direct M-Pesa STK push initiation
- Bypassing RLS with elevated credentials

### 3.2 Server Components (default)

**Allowed:**
- Initial data fetch via Supabase server client
- Rendering protected pages after session check
- Passing serializable props to client components

### 3.3 Route Handlers (`src/app/api/**`)

**Use for:**
- Webhook/callback endpoints (M-Pesa, Celcom delivery reports)
- External integrations requiring raw request bodies
- Operations that must not be Server Actions

**Pattern:**
```ts
// src/app/api/mpesa/callback/route.ts
export async function POST(request: Request) {
  // 1. Validate callback authenticity
  // 2. Parse payload
  // 3. Idempotent update via service role
  // 4. Return provider-expected response
}
```

### 3.4 Server Actions

**Use for:**
- Form submissions from authenticated users
- Mutations initiated by UI (start practice, send Nex message)

**Rules:**
- Always validate session at start
- Validate input with Zod schemas from `src/schemas/`
- Return typed `{ success, data?, error? }` — never throw to client for expected errors

### 3.5 Supabase Edge Functions

**V1 default:** Do not use Edge Functions unless a specific need arises (e.g., scheduled jobs). Prefer Next.js Route Handlers + Supabase Postgres.

---

## 4. Supabase Usage Rules

### 4.1 Clients

| Client | File | Where Used | Key |
|--------|------|------------|-----|
| Browser | `lib/supabase/client.ts` | Client Components | `NEXT_PUBLIC_SUPABASE_ANON_KEY` |
| Server | `lib/supabase/server.ts` | RSC, Server Actions, Route Handlers | Anon key + cookie session |
| Admin | `lib/supabase/admin.ts` | Server only — callbacks, admin ops | `SUPABASE_SERVICE_ROLE_KEY` |

**Never import `admin.ts` from client code.**

### 4.2 Database Access Rules

1. **RLS enabled on every `public` table** — no exceptions.
2. **Students read/write own rows** via `auth.uid() = user_id` or join through `student_profiles`.
3. **Parents read linked student data** via `student_parent_links`.
4. **Service role only for:**
   - M-Pesa/Celcom/Resend webhooks
   - Subscription activation after verified payment
   - Background jobs (future)
5. **Never use `user_metadata` in RLS policies** — use `app_metadata.userRole` or profile tables.
6. **Migrations via Supabase CLI** — `supabase migration new <name>`; never hand-invent timestamps.

### 4.3 Auth Integration

- Supabase Auth is the identity provider.
- `student_profiles.user_id` and `parent_profiles.user_id` FK → `auth.users.id`.
- On signup, create profile row in same transaction (DB trigger or server action).
- Google OAuth supported per MVP.

### 4.4 Realtime

**V1:** Not required. Defer Realtime subscriptions unless Nex chat needs live multi-device sync.

### 4.5 Storage

**V1:** Not required (no camera upload). When added in V2, bucket policies mirror RLS ownership model.

---

## 5. API Route Patterns

### 5.1 Naming

Kebab-case, domain-grouped. See [API Standards](./api-standards.md).

```
/api/nex/chat
/api/mpesa/initiate
/api/mpesa/callback
```

### 5.2 Handler Structure

Every Route Handler follows:

```ts
export async function POST(request: Request) {
  try {
    // 1. Auth or webhook verification
    // 2. Parse + validate body (Zod)
    // 3. Call server service
    // 4. Return JSON with consistent shape
  } catch (error) {
    return NextResponse.json(
      { success: false, error: { code: 'INTERNAL_ERROR', message: '...' } },
      { status: 500 }
    );
  }
}
```

### 5.3 Response Envelope

```ts
// Success
{ success: true, data: T }

// Error
{ success: false, error: { code: string, message: string, details?: unknown } }
```

### 5.4 HTTP Status Codes

| Status | When |
|--------|------|
| 200 | Success (including idempotent callback replay) |
| 201 | Resource created |
| 400 | Validation failure |
| 401 | Missing/invalid session |
| 403 | Valid session, insufficient permission |
| 404 | Resource not found |
| 409 | Conflict (duplicate payment, already completed diagnostic) |
| 429 | Rate limit (Nex chat free tier) |
| 500 | Unexpected server error |

### 5.5 Idempotency

- Payment callbacks: dedupe by `checkoutRequestId` + `mpesaReceiptNumber`
- Diagnostic completion: one active result per student per curriculum
- Nex messages: append-only; no update-in-place

---

## 6. Auth / Session Rules

### 6.1 Roles

Allowed values (`userRole` in `app_metadata` or profile):

```
student | parent | super_admin
```

**V1 builds:** `student`, `parent`, `super_admin` (internal). Super admin manages platform settings — not public signup.

### 6.2 Session Flow

```
Signup/Login (Supabase Auth)
    → Session cookie set by @supabase/ssr
    → Middleware validates session on protected routes
    → Profile loaded (student_profiles | parent_profiles)
    → Feature gates checked (diagnostic complete, subscription status)
```

### 6.3 Middleware (`src/middleware.ts`)

Protect route groups:

| Route Group | Required Role |
|-------------|---------------|
| `(student)/*` | `student` |
| `(parent)/*` | `parent` |
| `(super-admin)/*` | `super_admin` |
| `/api/admin/*` | `super_admin` |
| `/api/nex/*` (except health) | authenticated student |
| `/api/mpesa/initiate` | authenticated student or parent |
| `/api/mpesa/callback` | webhook (no session; signature validation) |

### 6.4 Onboarding Gate

Students **cannot access dashboard** until:

1. Curriculum + grade selected
2. Diagnostic assessment completed
3. Academic Health Score generated

Redirect incomplete students to `/onboarding`.

### 6.5 Parent–Student Linking

- Parent account links to student via invite code or email verification (V1: invite code).
- Parent RLS policies join through `student_parent_links`.
- Parent cannot modify student answers or impersonate student sessions.

### 6.6 Subscription Gate

**Freemium:** free forever with daily caps. Premium/Family raise limits — see [Subscription System](../phase-3-business-systems/subscription-system.md).

| Feature | Free (daily) | Premium / Family (daily) |
|---------|--------------|----------------------------|
| Nex chat messages | 10 | 75 |
| Practice sessions | 3 | 20 |
| Exam study plan | — | ✓ |
| Parent weekly email | — | ✓ |

Family plan: **KES 2,499**, up to **4 students**, premium limits per student.

Check limits server-side before Nex/practice calls. Return `429 RATE_LIMITED` when cap hit.

### 6.7 Session Security

- Short JWT expiry for sensitive apps; refresh via Supabase SSR helpers.
- Logout clears all session cookies.
- Delete user: revoke sessions before deletion (Supabase tokens remain valid until expiry otherwise).

---

## 7. Environment Variables

See [Naming Guidelines §19](../product-governance/naming-guidelines.md). Summary:

| Variable | Exposure |
|----------|----------|
| `NEXT_PUBLIC_*` | Browser-safe only |
| `SUPABASE_SERVICE_ROLE_KEY` | Server only |
| `GEMINI_API_KEY`, `OPENAI_API_KEY`, `MPESA_*`, `CELCOM_*`, `RESEND_*` | Server only |

---

## 8. External Services

| Service | Purpose | Integration Location |
|---------|---------|---------------------|
| Supabase | Auth, DB, RLS | `lib/supabase/` |
| Gemini Flash | Nex primary model | `lib/nex/callNexModel.ts` |
| OpenAI | Nex fallback model | `lib/nex/callNexModel.ts` |
| Nex System | Socratic tutoring pipeline | `lib/nex/` (server only) |
| M-Pesa Daraja | STK push, payments | `lib/mpesa/` |
| Celcom | SMS, OTP | `lib/celcom/` |
| Resend | Transactional email | `lib/resend/` |
| Vercel | Hosting, preview deploys | Project settings |

**No additional payment providers, SMS providers, or email providers in V1.**
