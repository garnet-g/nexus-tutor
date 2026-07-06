# FABLEPROD — Production-Readiness Remediation Directive (Cursor Handoff)

**Mission:** Close every open non-auth remediation item so Nexus is ready to charge monthly subscriptions. Work through Phases F1→F8 **in order, in one continuous run**, each phase building on the last. Write an honest, evidence-backed execution report to `fablefix.md` as you go (not at the end). An external auditor (Claude) will independently verify every claim in `fablefix.md` against the code afterward — **a false "done" is a program failure; an honest "not done" is acceptable.**

---

## 0. Authority documents — read these BEFORE any code

| Document | Why |
|---|---|
| `.planning/milestones/production-readiness/REMEDIATION-LEDGER.md` | The authoritative spec for every PR-### item below. **Before implementing any item, re-read its ledger row.** If this file and the ledger disagree, the ledger wins. |
| `.planning/milestones/production-readiness/DECISION-REGISTER.md` | Locked decisions (DEC-001…016). Items below cite DEC numbers; implement to the decision, do not re-decide. |
| `.planning/milestones/production-readiness/COORDINATION.md` | Two-track split. Defines the auth-track surfaces you MUST NOT touch (§2 below). |
| `nexus-map.md` | Ground-truth map of routes, APIs, and behavior claims. |
| `node_modules/next/dist/docs/` | **This repo runs Next.js 16.2.9 with breaking changes vs. your training data.** Read the relevant guide (headers, metadata, route handlers, proxy, caching, instrumentation) before writing any Next-specific code. Never write Next.js code from memory. |
| `AGENTS.md` | Repo conventions. |

---

## 1. Non-negotiable operating rules (anti-assumption protocol)

1. **Read before write.** Never edit a file you have not opened in this run. Never reference a function, table, column, env var, or route you have not located with search and opened. If you catch yourself typing an API you "remember", stop and verify it in `node_modules/next/dist/docs/` or the actual source.
2. **Cite evidence.** Every claim in `fablefix.md` needs `file:line` references or a command + output. No naked assertions.
3. **Reuse before build.** This codebase already has hardened primitives from completed Phases 00–05. Search for them first:
   - Rate limiting: `consume_rate_limit` RPC + `rate_limit_buckets` table (migration `supabase/migrations/20260702090000_atomic_usage_and_seats.sql`) — do NOT invent a second limiter.
   - Admin mutation guards: `enforceAdminMutationGuards` (Phase 05, PR-049) — extend it, don't fork it.
   - Session revocation: `sessionRevocationService.ts`, `sessionFreshnessService.ts` exist (read-only for you; see §2).
   - Payments: `src/lib/mpesa/paymentStateMachine.ts`, `src/server/services/paymentReconciliationService.ts`, `src/server/services/subscriptionService.ts`.
   - Notifications: `src/server/services/notificationService.ts`.
4. **TDD per item.** For every code item: write the failing test first (the ledger's ACCEPT column tells you what it must prove), watch it fail, implement minimally, watch it pass, then commit. Test files live beside existing suites (`tests/**`, `e2e/**` — mirror existing structure and naming).
5. **One commit per item**, message format: `fix(PR-047): durable burst limits on payment endpoints`. Never batch multiple PR-### into one commit. Commit `fablefix.md` updates with the item's commit.
6. **Migrations:** new SQL goes in `supabase/migrations/` with a correctly ordered timestamp and is verified with local `npm run db:reset`. **NEVER run `supabase db push --linked` or any command against the remote/production Supabase project.** Remote deployment is a human decision made after audit.
7. **Do not edit** anything under `.planning/` (including the ledger — status updates happen after external audit), `STATUS.md`, `RELEASE-EVIDENCE.md`. Your only report surface is `fablefix.md`.
8. **If blocked** (missing credential, Docker down, ambiguous policy not covered by a DEC): record it in `fablefix.md` under the item as `BLOCKED` with exactly what you needed, choose the most conservative safe behavior if a default is unavoidable, mark it as an ASSUMPTION, and move on. Never silently guess.
9. **Scope fence:** if a fix seems to require touching a forbidden surface (§2), implement only the in-scope part, record the boundary in `fablefix.md`, and mark the item `PARTIAL`.
10. **Windows environment.** Shell is PowerShell; paths use `C:\...`. `npm run db:reset` requires Docker Desktop running.

---

## 2. Forbidden surfaces — owned by the parallel Auth & Account track (Codex)

A second agent owns auth/account hardening on branch `codex/auth-account-hardening`. Per `COORDINATION.md`, you MUST NOT create, edit, or delete:

- Login/signup/OAuth/recovery/logout code: `src/app/(public)/login/**`, signup routes, `src/app/auth/**`, `AuthForm`, `authActions`, `authService`, `betaInviteService`, `signupCompensation`, `sessionRevocationService`, `sessionFreshnessService` (you may **call** existing exported functions; you may not modify them).
- Account lifecycle: account deletion, email/identity change, password management, `account_deletion_requests` migration, account-center UI.
- Admin **account control**: ban/unban, role-mutation enforcement onto Auth metadata *where it intersects account lifecycle* — note PR-028/PR-075 below define exactly which slice IS yours.
- `tests/auth/**`, `AUTH-ACCOUNT-*.md`, `phases/phase-A…E/**`.
- The untracked file `supabase/migrations/20260704101558_account_deletion_requests.sql` is the auth track's work-in-progress. **Never `git add` it** — stage files explicitly per item, never `git add -A`/`git add .`.

If an item below appears to require these, do the non-account part only and document the seam.

---

## 3. Subagent architecture — mandatory

Run every item through **two strictly separated roles**. If your runtime supports parallel subagents, spawn them; if not, execute as two sequential passes with a hard context switch (finish the Coder pass fully, then perform the Tracer pass as if you had never seen the Coder's reasoning — re-derive everything from the code on disk).

### Role A — CODER
- Reads the ledger row, the cited DEC decisions, and every file it will touch.
- Writes the failing test, implements, makes gates pass, commits.
- Writes the "What was done" section of the item's `fablefix.md` entry.

### Role B — TRACER (end-to-end wiring verifier)
The Tracer's job is to prove the feature is **actually wired in**, not merely that files were created. The Tracer must NOT trust the Coder's notes. For each item the Tracer independently:

1. **Traces the full chain from entry to effect**, recording `file:line` for every hop:
   `UI trigger (component/page) → route or server action → handler → service → DB table/RPC/RLS policy → response → UI state change`.
2. **Checks for orphans:** new function/endpoint/table with zero callers = NOT wired. New UI with no backend = NOT wired. Flags them.
3. **Checks both directions:** the caller passes what the handler validates; the handler returns what the caller renders; error paths surface to the user, not just to the console.
4. **Runs the acceptance check** from the ledger's ACCEPT column (the actual test/command, not a thought experiment) and pastes the real output summary.
5. **Verdict:** `DONE_VERIFIED` only if the trace chain is complete AND the acceptance check passed in this run. Otherwise `PARTIAL` / `NOT_DONE` with the specific missing link.
6. Writes the "Trace chain" and "Verdict" sections of the item's `fablefix.md` entry.

**Disagreement rule:** if Tracer verdict ≠ Coder claim, the Coder fixes and the Tracer re-traces (max 2 cycles). If still failing, record `PARTIAL` honestly and move on. Do not loop forever; do not paper over.

---

## 4. Verification gates

**After every phase** (all must pass before the next phase starts; paste real output tails into `fablefix.md`):

```
npm run typecheck        # expect: exit 0, no output
npm run lint             # expect: exit 0 (warnings noted in report)
npm test                 # expect: 0 failures (baseline 2026-07-06: 551 passed, 13 skipped — your count must be ≥ baseline and growing)
npm run test:scope-check # expect: PASS
npm run build            # expect: production build success, all routes emitted
```

**Where an item's acceptance needs a browser:** `npm run test:e2e` (Playwright; `test:e2e:ci` builds first). **After the final phase:** `npm run deploy:check` and paste the full result.

If a gate fails, fix it before proceeding. If you must proceed with a red gate (true blockage), the phase and all its items are capped at `PARTIAL` and the failure goes in `fablefix.md` verbatim.

---

## 5. Reporting contract — `fablefix.md`

Create `fablefix.md` at repo root **before Phase F1** and update it **after every item** (never batch at the end — if the run dies, the report must survive). Exact structure:

```markdown
# FABLEFIX — Remediation Execution Report
Run started: <date/time> · Agent: Cursor · Source directive: fableprod.md

## Phase F<N> — <title>
Started: <ts> · Finished: <ts>

### Gate results (real output tails)
<typecheck/lint/test/scope-check/build outputs>

### PR-### — <short title>
- **Status:** DONE_VERIFIED | PARTIAL | NOT_DONE | BLOCKED | OUT_OF_SCOPE_AUTH_TRACK
- **What was done:** <files created/modified, migrations, tests added — with paths>
- **Trace chain (Tracer):** <entry → … → effect, each hop file:line>
- **Acceptance evidence:** <test name(s) + command + real result>
- **Assumptions made:** <every default you chose without explicit spec; "none" only if truly none>
- **Invented/uncertain:** <anything you could not verify against code/docs/ledger — APIs guessed, behavior inferred, copy authored without product input>
- **Not done / remaining:** <specific missing pieces, or "nothing">
- **Commit:** <hash> <message>

### Phase F<N> summary
Done-verified: X · Partial: Y · Not done: Z · Blocked: W

## FINAL — Master table
| Item | Phase | Status | One-line note |
(one row for every PR-### in this directive — all 89)

## FINAL — Honesty audit
- Global assumptions list
- Self-audit: places most likely to contain hallucinated/unverified behavior (be specific — the auditor starts here)
- Where the run stopped, if early
- deploy:check final output
```

---

## 6. The phases

Execute in this order. Item lines give: problem → required outcome → acceptance (from the ledger; re-read the row for full context). "Start at" = verified real paths to open first.

---

### Phase F1 — Payment & billing trust leftovers (4 items)

Money path first. Phase 03/05 built the core (state machine, reconciliation, callbacks, `consume_rate_limit` RPC); these finish it.

- **PR-047 (P1)** — Payment endpoints lack burst limits → durable abuse limits keyed by account / phone hash / IP HMAC → *Accept:* burst test gets `429` + `Retry-After`. Start at `src/app/api/mpesa/stk-push/route.ts`, `src/app/api/mpesa/status/route.ts`; **reuse `consume_rate_limit`** (see §1.3), mirror how Phase 05 wired other routes.
- **PR-123 (P1)** — Reload during pending payment leaves user stranded → recoverable pending UI + status poll endpoint → *Accept:* reload mid-payment shows resumable pending state (ties to completed PR-113; read its ledger row for the poll contract). Start at `src/features/pricing/components/PricingCheckout.tsx`, `src/app/api/mpesa/status/route.ts`, `src/lib/mpesa/paymentStateMachine.ts`.
- **PR-140 (P1)** — Provider-down checkout UX weak → explicit pending/error/recover states in UI → *Accept:* Playwright: provider down ⇒ recoverable message, no dead end. Start at `/pricing` UI + `PricingCheckout.tsx`.
- **PR-077 (P2)** — No webhook replay tooling → idempotent operator replay tool (admin-guarded; replaying an already-processed callback must be a no-op via the payment state machine) → *Accept:* replay-tool test on a fixture callback event. Start at `src/app/api/mpesa/callback/[secret]/route.ts`, `paymentReconciliationService.ts`; put the operator surface under `/admin` with `enforceAdminMutationGuards`.

---

### Phase F2 — Admin control plane: real authorization, rollouts, durable audit (7 items)

Currently several admin controls are decorative. This phase makes the control plane truthful. Policies: DEC-001 (rollout precedence), DEC-008 (canonical role claim), DEC-009 (fail-closed audit).

- **PR-028 (P1)** — `/admin/roles` writes a ledger row but never updates the canonical runtime claim → role change updates `app_metadata.userRole` + ledger coherently (DEC-008) → *Accept:* role PATCH ⇒ JWT refresh ⇒ access actually changes. Start at `src/app/api/admin/roles/route.ts`. **Boundary:** role *enforcement mechanics* are yours; ban/revoke-on-role-change session handling belongs to Auth track — call the existing exported revocation function if needed, do not modify it.
- **PR-075 (P2)** — No last-admin/self-demotion/bootstrap guards → adversarial lockout protections → *Accept:* demoting the last super-admin is blocked. Same roles service as PR-028.
- **PR-029 (P1)** — Rollout rows exist but no feature gate consumes them → server-enforced rollouts block/allow routes and APIs per DEC-001 precedence → *Accept:* rollout off ⇒ direct URL gets 404/403; on ⇒ cohort only.
- **PR-030 (P1)** — Admin entitlement debug hardcodes `featureEnabled: true` → debug output = the real evaluated server decision → *Accept:* debug matches gate for an off rollout. (Grep `featureEnabled` to find it.)
- **PR-031 (P1)** — `recordAdminAudit()` swallows insert failures → critical mutations fail closed or durable outbox per DEC-009 → *Accept:* simulated audit-DB failure ⇒ mutation blocked or reliably retriable.
- **PR-032 (P1)** — Audit inserts check thrown exceptions only, not Supabase `{ error }` → handle `{ error }` returns → *Accept:* unit test: returned error ⇒ visible failure. (Supabase JS returns errors in the result object; it does not throw — audit every `.insert(` in the audit service.)
- **PR-049b (P2)** — Admin routes bypassing `requireAdminApi` lack burst/origin guards → extend `enforceAdminMutationGuards` to `requireContentAuthor` + raw-`getUser` admin routes (content-studio, platform-settings, beta-invites) → *Accept:* content-studio/settings burst adversarial test.

---

### Phase F3 — Student utilities: make paid features real (13 items)

The churn bucket — features a subscriber clicks and finds hollow. Everything here needs full UI→DB wiring; this is where the Tracer earns its keep.

- **PR-033 (P1)** — Study Search doesn't query lesson/question text → indexed curriculum-aware search with visibility scoping → *Accept:* search returns published lesson hit; drafts/answer keys excluded. Start at the `/study-search` page + search API; check existing content tables before adding indexes (Postgres FTS per `supabase-postgres-best-practices` — prefer `tsvector` + GIN over `ILIKE`).
- **PR-034 (P1)** — Lesson bookmarks are browser-local only → bookmarks write server `student_saved_items` → *Accept:* bookmark a lesson ⇒ appears on `/saved`.
- **PR-035 (P1)** — Practice save not connected to `/saved` → save/unsave practice items server-backed → *Accept:* save question ⇒ `/saved` lists it. (Share the `student_saved_items` model with PR-034 — one table, typed item kinds. DRY.)
- **PR-036 (P1)** — Mistake journal never auto-populated → wrong answers upsert idempotently to `student_mistake_journal` on practice/mock completion → *Accept:* complete practice with a miss ⇒ journal row (re-run ⇒ no duplicate).
- **PR-038 (P1)** — Focus sessions: manual complete, no timer → persisted timer with server-validated elapsed credit → *Accept:* timer race test; click-only complete earns no credit.
- **PR-101 (P2)** — Completed focus sessions can be cancelled → state machine: complete is terminal → *Accept:* PATCH cancel after complete ⇒ `409`.
- **PR-039 (P1)** — Offline packs record-only, no service worker/cache → installable offline: manifest + SW + cache, purge on logout → *Accept:* Playwright offline test: pack opens with network disabled.
- **PR-104 (P1)** — Logout doesn't purge offline caches → SW/IDB purge on logout and account switch → *Accept:* logout ⇒ offline pack inaccessible. **Boundary:** the purge *hook* into logout may only call exported auth APIs; do not edit auth internals — if a callback point doesn't exist, implement purge as its own module triggered from your SW/storage layer and document the seam.
- **PR-105 (P1)** — Account switch may leak cached data → per-user cache namespace isolation (key every cache/IDB store by user id) → *Accept:* switch user ⇒ prior user's data absent.
- **PR-040 (P1)** — Concept Library is four static `/learn` links → published concept/reference library + authoring lifecycle → *Accept:* library browse/search works; Studio publish path exists. (Largest item in F3 — reuse content-studio publishing patterns; check DEC-002 readiness gates.)
- **PR-041 (P1)** — Learning Memory copy overstates editability → accurate projection + provenance; reset only if promised → *Accept:* UI copy matches the read-only projection; reset (if kept) works.
- **PR-102 (P2)** — Raw internal metadata rendered in Nex Memory UI → redacted/summarized presentation → *Accept:* snapshot test: no raw JSON blobs.
- **PR-063 (P2)** — Readiness page has bare simulator links → session-aware generate/resume/start CTAs → *Accept:* readiness with eligibility ⇒ starts a session.

---

### Phase F4 — Parent, family, notifications (15 items)

Parents pay the bills. Policies: DEC-006 (retention). **Boundary:** parent *account* lifecycle (email/password/deletion) is Auth track; parent *product* surfaces (dashboard, preferences, links, notifications) are yours.

- **PR-037 (P1)** — `parent_visible` weekly goal not shown on parent dashboard → parent sees goal only for linked students when visible → *Accept:* linked + visible ⇒ rendered; unlinked ⇒ hidden.
- **PR-062 (P2)** — Weekly goal parent rendering + RLS → *Accept:* cross-family isolation test (parent A never sees family B data — write it as a real RLS test, see PR-084 pattern).
- **PR-059 (P2)** — No parent unlink/revoke UI → unlink with confirmation + immediate access revocation → *Accept:* unlink ⇒ parent loses student data access immediately.
- **PR-060 (P2)** — No parent settings page → parent settings for contact/notification preferences (product prefs only — no email/password/identity, that's Auth track) → *Accept:* parent edits preferences ⇒ persisted.
- **PR-061 (P2)** — No notification preferences → channel/event/frequency preferences → *Accept:* suppressed event never sends.
- **PR-129 (P1)** — No bounded retry/backoff for notifications → retry with idempotency keys → *Accept:* provider fail ⇒ retries then exhausted, no duplicates.
- **PR-130 (P1)** — No dead-letter path → operator recovery for exhausted sends → *Accept:* DLQ row visible in admin health. Start at `notificationService.ts`; design outbox → retry → DLQ as one state machine, not three bolt-ons.
- **PR-131 (P2)** — Weekly report cron can double-fire → idempotent per student/week (unique key, upsert) → *Accept:* double cron ⇒ one report.
- **PR-132 (P2)** — Timezone/week-boundary ambiguity → documented TZ (Africa/Nairobi unless a DEC says otherwise — if you choose it, record as ASSUMPTION) + boundary tests → *Accept:* TZ boundary unit test.
- **PR-057 (P2)** — Notification retention unverified → documented + enforced retention per DEC-006 → *Accept:* retention job test + policy doc.
- **PR-058 (P2)** — Message body/phone PII in logs/exports → redaction per policy → *Accept:* log snapshot test: no raw phone/body.
- **PR-107 (P1)** — No unified retention/deletion policy → documented + enforced retention for PII/learning records → *Accept:* deletion-request test + audit. **Boundary:** account-deletion *flow* is Auth track (`account_deletion_requests` is theirs); your scope is the retention policy doc + enforcement jobs for notification/learning data. Mark the seam in the report.
- **PR-128 (P2)** — View-as impersonation retention unclear → retention/redaction for view-as evidence → *Accept:* policy test + audit rows.
- **PR-133 (P2)** — Member removal/subscription-lapse lifecycle incomplete → seat reclaim + access removal on lapse → *Accept:* sub cancel ⇒ members lose family entitlements. Start at family service + `subscriptionService.ts`; Phase 05 seat RPCs exist — reuse.
- **PR-134 (P2)** — Resubscription/relink edge cases → documented owner-change policy + handling → *Accept:* family lifecycle integration test.

---

### Phase F5 — Admin operational workflows (10 items)

Admin pages that advertise operations must execute them, with audit + idempotency. Depends on F2's real audit/rollout plumbing. Policy: DEC-013 (communications scope).

- **PR-066 (P2)** — `/admin/reports` no CSV export → authorized CSV download per report link → *Accept:* report click ⇒ valid CSV + audit row.
- **PR-126 (P2)** — CSV formula injection → escape formula-leading cells (`=`, `+`, `-`, `@`) → *Accept:* cell `=cmd` exports safely. (Do with PR-066, same module.)
- **PR-067 (P2)** — `/admin/communications` templates only → campaign sender OR the DEC-013 narrowed UI (read the DEC; implement what it locked) → *Accept:* send preview count + idempotent send.
- **PR-068 (P2)** — `/admin/experiments` ledger only → deterministic assignment + exposure metrics, obeying DEC-001 precedence with F2's rollout service → *Accept:* experiment obeys rollout precedence.
- **PR-069 (P2)** — `/admin/bulk-actions` no executor → typed allowlisted commands with approval → *Accept:* approved bulk ⇒ executes with audit.
- **PR-070 (P2)** — `/admin/approvals` ledger only → approval gates the executor; direct call blocked → *Accept:* bypassing approval API ⇒ `403`.
- **PR-125 (P2)** — No four-eyes separation → requester cannot approve own bulk job → *Accept:* same-actor approve ⇒ `403`. (Design PR-069/070/125 as one approval-workflow module.)
- **PR-071 (P2)** — `/admin/saved-views` partial → saved filters reapply to target page → *Accept:* load view ⇒ page query matches.
- **PR-072 (P2)** — `/admin/search` partial → useful entity search with role filter → *Accept:* returns authorized snippets only.
- **PR-073 (P2)** — `/admin/content-calendar` partial → real review/publish calendar → *Accept:* calendar reflects review-queue dates.

---

### Phase F6 — Content & product truth (10 items)

Stop the app overselling itself. Policies: DEC-002 (PROD_READY definition), DEC-007 (mock-exam language).

- **PR-042 (P1)** — `isTopicPracticeReady()` uses a 5-question band threshold → `PROD_READY` requires 21 questions/topic + lessons per DEC-002; "session-startable" is a separate, honest state → *Accept:* coverage test fails under-target. Start at `contentModel.ts` (grep for it).
- **PR-043 (P1)** — `getTopicReadinessLabel()` can show ready early → labels match DEC-002 → *Accept:* label unit tests per threshold matrix.
- **PR-135 (P1)** — No executable coverage matrix → DB-driven coverage report per grade/subject/topic, wired as `npm run test:coverage-matrix` (add the script) → *Accept:* fails under-target.
- **PR-136 (P1)** — Under-covered topics can be published as ready → Studio publish gate blocks false PROD_READY → *Accept:* publish under-target ⇒ blocked.
- **PR-106 (P2)** — Mock exams may imply official past papers → accurate language per DEC-007 → *Accept:* copy audit: no false licensing claims.
- **PR-050 (P1)** — V1 scope-lock doc bans now-live features → update `mvp-feature-scope-lock.md` to reference map + current routes → *Accept:* no banned-live contradiction.
- **PR-051 (P1)** — Docs claim Next.js 15 → governance docs say 16.2.9 → *Accept:* doc grep clean.
- **PR-052 (P1)** — Screen inventory omits routes → inventory matches the 69-page scan → *Accept:* route-count reconciliation (script it: glob `src/app/**/page.tsx` vs. doc).
- **PR-053 (P1)** — User-flow docs omit student/admin utilities → flows cover map journeys → *Accept:* checklist complete.
- **PR-141 (P2)** — Platform-settings 60s cache undocumented → staleness documented for operators → *Accept:* ops doc mentions the window.

---

### Phase F7 — Browser security, observability, performance, a11y (20 items)

Policies: DEC-005 (perf thresholds), DEC-011 (screen-reader gate = Windows Narrator + Edge). **Read the Next 16 headers/metadata/instrumentation docs first** — config shape changed vs. your training data.

Security headers (all in `next.config.ts`; one coherent headers block, env-aware, tested together):
- **PR-019 (P1)** — No CSP → environment-aware CSP per Next 16 guide → header tests + Nex multimodal smoke (see PR-139).
- **PR-020 (P1)** — No frame protection → `frame-ancestors` (or `X-Frame-Options`) → header test public + app routes.
- **PR-021 (P1)** — `X-Content-Type-Options: nosniff` → header assertion.
- **PR-022 (P1)** — `Referrer-Policy` → header assertion.
- **PR-023 (P1)** — `Permissions-Policy` allowing camera/mic only where Nex needs them → header assertion + camera journey works.
- **PR-024 (P1)** — HSTS only in valid HTTPS production context → staging/prod header test.
- **PR-139 (P1)** — CSP may break camera/mic → verify with multimodal smoke → camera E2E green under the new headers. **Do not mark PR-019 done until this passes.**
- **PR-103 (P1)** — Private response cache leakage → `Cache-Control: private/no-store` on authenticated routes → header tests on student/admin pages.

SEO/metadata:
- **PR-025 (P1)** — `src/app/robots.ts` (new) → admin/private routes disallowed → `/robots.txt` test.
- **PR-026 (P1)** — `src/app/sitemap.ts` (new) → public routes only → sitemap content test.
- **PR-027 (P1)** — Web manifest + OG/Twitter + canonical in `src/app/layout.tsx` → metadata tests; Lighthouse SEO ≥95.

Observability & perf:
- **PR-097 (P1)** — Client Sentry unverified on Next 16 → `instrumentation-client.ts` + server wiring per current `@sentry/nextjs` docs → deliberate error visible (record env limits honestly if no staging access).
- **PR-098 (P1)** — Release tags, PII redaction, non-public source maps → Sentry event carries release/env tags.
- **PR-045 (P1)** — No provider probes → timeout-bounded probes per enabled provider (AI/M-Pesa/SMS/email/cron/migrations/latency) in `src/lib/health/probes.ts`, surfaced on `/admin/health` → probe matrix tests with mocked timeouts.
- **PR-064 (P2)** — Duplicate `getStudentChromeData` + experience loads → ≤1 session/profile lookup per request (React `cache()` / request-scoped memo per Next 16 docs) → single-fetch timing test.
- **PR-065 (P2)** — No query/latency instrumentation → server timing + budgets → p95 dashboard ≤800ms evidence (lab evidence acceptable per DEC-005; state environment).
- **PR-087 (P1)** — No Lighthouse budgets → `lighthouserc.js` + DEC-005 thresholds → `npx lhci autorun` PASS (add dev-dependency; if sandbox can't run Chrome, mark BLOCKED with exact error).
- **PR-074 (P2)** — Missing route-specific error recovery → error boundaries + retry for provider/401/chunk failures (`error.tsx` per route group, Next 16 conventions) → Playwright forced-error recovery test.

Accessibility:
- **PR-138 (P1)** — Keyboard/focus gaps on utilities → full keyboard path on student utilities + Nex → axe + manual keyboard checklist (automate axe in Playwright; record what needs a human).
- **PR-137 (P1)** — Manual screen-reader gate (DEC-011: Narrator + Edge) → this needs a human. Prepare the journey checklist + automated a11y evidence, then mark `BLOCKED (human gate)` in the report — that is the honest verdict.

---

### Phase F8 — Release proof (10 items)

Independent end-to-end evidence. Build on the seeded local stack (`npm run db:reset`, dev users from `scripts/seed-dev-users.ts`; see `e2e/support-admin-login.spec.ts` for the established login-flow pattern).

- **PR-079 (P1)** — `e2e/parent-journey.spec.ts`: parent link + dashboard → green.
- **PR-080 (P1)** — `e2e/admin-journey.spec.ts`: support + super-admin smoke → green.
- **PR-081 (P1)** — `e2e/studio.spec.ts`: Studio publish path (including F6's coverage gate) → green.
- **PR-082 (P1)** — `e2e/student-utilities.spec.ts`: primary journeys for F3's features → green.
- **PR-083 (P1)** — Billing + multimodal: pricing/checkout smoke (mock provider mode per `src/lib/env/providerModes.ts`) + expand `e2e/nex-camera.spec.ts` → green.
- **PR-084 (P1)** — RLS tests execute against a reset DB (not migration-text reads) → `tests/rls/` suite green after `npm run db:reset`.
- **PR-085 (P1)** — Concurrency suite → `tests/concurrency/` parallel-invariant tests (quota caps, seat claims, invite reservation, rate limits — the Phase 05 RPCs give you the invariants) → green.
- **PR-086 (P1)** — Real-provider staging checks → you cannot reach production sandboxes from this run: write the staging checklist + exact commands, mark `BLOCKED (human gate)`.
- **PR-076 (P2)** — Payment reconciliation runbook → documented + dry-run against local fixtures → dry-run output recorded in `fablefix.md` (NOT in RELEASE-EVIDENCE.md — that file is off-limits).
- **PR-078 (P2)** — Provider outage runbooks (AI/payment/cron) → written + tabletop dry-run recorded in `fablefix.md`.

---

## 7. Finish line

1. Run `npm run deploy:check` — paste full output into `fablefix.md`.
2. Run `npm run test:e2e:ci` — paste summary.
3. Complete the FINAL master table (all 89 items) and the Honesty audit.
4. Final commit: `docs(fablefix): final remediation execution report`.

Do not update ledger statuses, STATUS.md, or RELEASE-EVIDENCE.md — the external audit does that after verifying your report. Your success is measured by the accuracy of `fablefix.md`, not by how many items claim DONE.
