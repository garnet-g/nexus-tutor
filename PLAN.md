# Nexus Production Readiness Remediation Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use subagent-driven-development or the repo's Nexus Agent Orchestra before coding. This plan is the source of truth for production-readiness remediation. Track execution with checkbox syntax and phase artifacts.

**Goal:** Fix every actionable production-readiness issue found in `docs/PRODUCTION_READINESS_MODULE_AUDIT.md`, or document an explicit release exception with evidence.

**Architecture:** Work through the existing Nexus agent orchestra. A Supervisor/Orchestrator owns end-to-end module mapping, a Planner approves one phase at a time with an explicit file allowlist, a Coder implements only the approved phase, QA verifies with command evidence, and a Gap Analyst checks for missed, broken, overbuilt, or unverified work.

**Tech Stack:** Next.js 16 App Router, React 19, TypeScript, Supabase/Postgres/RLS/Storage, Vitest, Playwright, Vercel, M-Pesa Daraja, Celcom SMS, Resend email, Gemini/OpenAI provider clients.

---

## 1. Mission and Non-Negotiables

Production readiness is not complete until every finding in `docs/PRODUCTION_READINESS_MODULE_AUDIT.md` is either:

- fixed and verified,
- assigned to a later approved phase with a blocker,
- or documented as a named release exception with owner, risk, expiry date, and mitigation.

Agents must not begin coding until they have read:

- `AGENTS.md`
- `.planning/agents/ORCHESTRATOR.md`
- `.planning/agents/PLANNER.md`
- `.planning/agents/QA.md`
- `.planning/milestones/v2-tier-1/STATUS.md`
- `docs/PRODUCTION_READINESS_MODULE_AUDIT.md`
- `docs/product-governance/mvp-feature-scope-lock.md`
- `docs/phase-5-engineering-governance/coding-agent-rules.md`
- `docs/phase-5-engineering-governance/testing-standards.md`

Before touching middleware/proxy behavior, agents must read the local Next.js 16 docs from `node_modules/next/dist/docs/`. This repo explicitly warns that Next.js behavior may differ from older assumptions.

Secrets rule:

- Do not commit secrets, service role keys, database passwords, provider tokens, webhook secrets, or real production credentials.
- `.env.local` is local-only and must stay out of committed artifacts.
- Production readiness means env validation and provider wiring, not storing provider secrets in the repo.

Scope rule:

- Do not build a true past-paper bank in this remediation pass.
- The launch scope is generated mock exams and exam simulator.
- True past-paper bank source/provenance, licensing, ingestion, marking scheme, and traceability are post-launch backlog unless the product owner creates a separate plan.

---

## 2. Required Subagent Architecture

All work must flow through `.planning/milestones/production-readiness/`.

Create this artifact structure before coding:

```text
.planning/milestones/production-readiness/
  ARCHITECT-BRIEF.md
  PHASE-PLAN.md
  GAP-REPORT.md
  STATUS.md
  phases/
    phase-1/
      CODER-CHANGELOG.md
      QA-REPORT.md
      GAP-REPORT.md
    phase-2/
      CODER-CHANGELOG.md
      QA-REPORT.md
      GAP-REPORT.md
```

Add more `phase-N` folders as phases are approved.

### Supervisor / Orchestrator

Responsibilities:

- Own the whole remediation effort.
- Keep this plan, the audit, and phase artifacts aligned.
- Ensure every changed route has its caller, handler, service, schema, database policy, test, and doc impact mapped.
- Ensure Coder never starts before Planner returns `APPROVED_TO_BUILD`.
- Ensure one phase is implemented at a time unless Planner explicitly marks tasks as parallel-safe.
- Own final signoff.

Before each phase, Supervisor must create a route/module map entry in the active `PHASE-PLAN.md`:

```markdown
## Affected Surface Map

| Surface | Path | Caller | Handler | Service/Helper | DB/RLS | Tests | Docs |
|---|---|---|---|---|---|---|---|
| Example | `/api/example` | `src/features/...` | `src/app/api/.../route.ts` | `src/server/services/...` | `supabase/migrations/...` | `tests/...` | `docs/...` |
```

### Planner / Scope Controller

Responsibilities:

- Work readonly.
- Convert the audit finding into one approved phase.
- Produce phase goal, criterion IDs, tasks, file allowlist, out-of-scope list, verification commands, and verdict.
- Output exactly one of: `APPROVED_TO_BUILD`, `CHANGES_REQUIRED`, or `BLOCKED`.

Planner hard rules:

- No Coder work without `APPROVED_TO_BUILD`.
- Every approved phase must include an explicit file allowlist.
- Every approved phase must map to one or more audit findings.
- Every approved phase must include tests that would fail before the fix where practical.
- Do not allow feature expansion beyond this plan.

### Coder

Responsibilities:

- Read only the approved phase section, file allowlist, and required source docs.
- Modify only files in the phase allowlist.
- Write or update tests before implementation where practical.
- Update `.planning/milestones/production-readiness/phases/phase-N/CODER-CHANGELOG.md`.
- Report any blocker instead of guessing.

Coder changelog must include:

```markdown
# Phase N Coder Changelog

## Files Changed

## Behavior Changed

## Tests Added or Updated

## Commands Run

## Known Gaps or Concerns
```

### QA

Responsibilities:

- Work readonly except for generated test/build artifacts.
- Read `PHASE-PLAN.md` and `CODER-CHANGELOG.md`.
- Run required verification commands.
- Map command results to phase criteria.
- Write `.planning/milestones/production-readiness/phases/phase-N/QA-REPORT.md`.

QA report must include:

```markdown
# Phase N QA Report

**Verdict:** PASS | FAIL

## Criteria Evidence

## Commands

| Command | Exit Code | Result | Notes |
|---|---:|---|---|

## Failures

## Required Fixes for Coder
```

### Gap Analyst

Responsibilities:

- Work readonly.
- Review the diff, changed behavior, and QA report after every phase.
- Identify missed audit items, broken flows, insufficient tests, route/caller/handler drift, accidental scope creep, and release exceptions that lack evidence.
- Write `.planning/milestones/production-readiness/phases/phase-N/GAP-REPORT.md`.

Gap report must answer:

- Which findings from `PRODUCTION_READINESS_MODULE_AUDIT.md` did this phase claim to fix?
- Which routes, APIs, callers, handlers, services, schemas, migrations, tests, and docs changed?
- Which expected affected surfaces were not touched, and why?
- Did the phase introduce any new mock behavior, unauthenticated mutation, RLS bypass, service-role client exposure, or untested route?
- Did any command fail, skip, timeout, or depend on missing local services?
- Did the phase overbuild beyond approved scope?
- What exact fix list goes back to Coder?

---

## 3. Global Acceptance Gates

Run these after every phase when applicable:

```bash
npm run lint
npm run typecheck
npm test
npm run test:scope-check
npm run build
```

Run these for release signoff and for phases that touch their surfaces:

```bash
npm run test:e2e
npm audit --audit-level=moderate
npx supabase db push --db-url "$DATABASE_URL" --dry-run
npm run db:reset
```

Gate rules:

- `npm run db:reset` is required once Docker is available. If Docker is not available, QA must record the blocker and must still verify hosted Supabase with the dry-run command.
- `npm run test:e2e` is required for route, auth, public CTA, billing, mock exam, onboarding, diagnostic, practice, study plan, parent, and admin changes.
- `npm audit --audit-level=moderate` must pass or have a documented release exception for every remaining advisory.
- A skipped, timed-out, or blocked command is not a pass.
- Any failing gate must be assigned back to Coder or documented as a release exception approved by Supervisor.

---

## 4. Phase 1: Production Gate Hardening

### Audit Findings Covered

- P0: Production can silently use mock AI, payment, SMS, and email.
- P1: Required security headers are absent.
- P1: Dependency audit is not clean.
- Infrastructure/deployment module: `deploy:check` omits env validation and audit.

### Required Changes

- Add production env preflight validation.
- Wire env preflight and dependency audit into `deploy:check`.
- Add global security headers in `next.config.ts`.
- Fail closed in production when AI, M-Pesa, Celcom, or Resend config is missing.
- Keep non-production mock mode available for local development and tests.
- Preserve Celcom env naming:
  - `CELCOM_PARTNER_ID`
  - `CELCOM_API_KEY`
  - `CELCOM_SHORTCODE`

### Affected Surface Map

Planner must map these surfaces before approval:

- AI provider clients: `src/lib/nex/callNexModel.ts`, `src/lib/nex/extractImageText.ts`, `src/lib/nex/voiceTranscribe.ts`, `src/lib/nex/voiceSynthesize.ts`
- Payment provider: `src/lib/mpesa/mpesaClient.ts`, `src/app/api/mpesa/stk-push/route.ts`
- Notification providers: `src/lib/celcom/celcomClient.ts`, `src/lib/resend/resendClient.ts`
- Deployment scripts: `package.json`, `scripts/**`
- Environment docs: `.env.example`, `docs/DEPLOYMENT.md`, `docs/phase-5-engineering-governance/deployment-standards.md`
- Security config: `next.config.ts`
- Tests: provider/env tests under `tests/**`

### Required Behavior

- In production, `NEX_MOCK_AI=true` fails env preflight.
- In production, `NOTIFICATIONS_MOCK=true` fails env preflight.
- In production, missing AI provider config fails before a fake tutor/camera/voice success can be returned.
- In production, missing M-Pesa config fails before a payment can be marked paid or a subscription can be activated.
- In production, missing Celcom or Resend config fails before fake delivery can be reported as success.
- In development and test, existing mock paths remain available unless a test explicitly sets production mode.
- Security headers include at minimum:
  - `X-Frame-Options`
  - `X-Content-Type-Options`
  - `Referrer-Policy`
  - `Permissions-Policy`

### Required Tests

- Production env preflight fails when required vars are missing.
- Production env preflight fails when mock flags are enabled.
- Production env preflight accepts the Celcom trio named above.
- Provider clients reject production mock fallback.
- `npm run build` passes.
- `npm audit --audit-level=moderate` passes or records an approved exception.

### Phase 1 Done Criteria

- `deploy:check` includes lint, typecheck, unit tests, scope check, build, env preflight, and audit.
- Production cannot silently use mock AI, payment, SMS, or email.
- Security headers are present.
- QA report has command evidence.
- Gap Analyst has no open blockers for this phase.

---

## 5. Phase 2: Webhook Trust and Billing Safety

### Audit Findings Covered

- P0: Payment and notification webhooks are unauthenticated.
- Billing module: callback dedupe is not strongly enforced.
- Billing module: payment initiation is not rate-limited.

### Required Changes

- Add M-Pesa callback trust verification.
- Add Celcom webhook trust verification.
- Add database-enforced callback dedupe.
- Add payment initiation rate limiting.
- Preserve best-effort notification behavior after successful payment activation.

### Affected Surface Map

Planner must map these surfaces before approval:

- `src/app/api/mpesa/callback/route.ts`
- `src/app/api/mpesa/stk-push/route.ts`
- `src/app/api/celcom/webhook/route.ts`
- `src/lib/mpesa/mpesaClient.ts`
- `src/server/services/subscriptionService.ts`
- `src/server/services/notificationService.ts`
- `supabase/migrations/**`
- webhook and billing tests under `tests/**`

### Required Behavior

- `/api/mpesa/callback` rejects untrusted requests before parsing or mutating payment state.
- `/api/celcom/webhook` rejects untrusted requests before mutating SMS delivery logs.
- Valid webhook requests are accepted and remain idempotent.
- Duplicate M-Pesa callback cannot create duplicate callback rows or duplicate subscription activation.
- Failed, cancelled, and expired M-Pesa callbacks update payment state safely.
- Payment initiation is rate-limited per appropriate actor/IP/session using the repo's existing rate-limit pattern if one exists.

### Verification Strategy

- Use a shared webhook secret unless provider-supported signature verification is already documented and available.
- Store required secret names in `.env.example` and deployment docs.
- Do not store real webhook secret values.

### Required Tests

- Missing webhook secret/header returns rejection and no mutation.
- Invalid webhook secret/header returns rejection and no mutation.
- Valid M-Pesa callback is accepted.
- Valid Celcom delivery report is accepted.
- Duplicate M-Pesa callback is idempotent.
- Failed/cancelled payment sends the expected best-effort notification path without blocking state update.
- Payment initiation rate limit test covers repeated requests.

### Phase 2 Done Criteria

- Webhooks reject untrusted requests.
- Dedupe is enforced at the database or transaction level.
- Payment initiation is rate-limited.
- QA has evidence for valid and invalid callback behavior.
- Gap Analyst finds no unauthenticated mutation remaining in the covered routes.

---

## 6. Phase 3: Next 16 Auth, Routing, and Public CTA

### Audit Findings Covered

- P1: Next 16 middleware migration is pending.
- P1: Public CTA e2e fails.
- Auth/onboarding module: API route auth must be verified independently.

### Required Changes

- Migrate deprecated `src/middleware.ts` behavior to Next 16 `src/proxy.ts`.
- Preserve public/protected route behavior.
- Fix landing CTA semantics so Playwright can find a real link named `Start learning free`.
- Add protected UI and API route auth contract tests.

### Affected Surface Map

Planner must map these surfaces before approval:

- `src/middleware.ts`
- `src/proxy.ts`
- `src/app/(public)/page.tsx`
- protected route groups under `src/app/(student)`, `src/app/(parent)`, `src/app/(super-admin)`
- protected API routes under `src/app/api/**`
- `e2e/smoke.spec.ts`
- auth route tests under `tests/**` or `e2e/**`
- local Next docs under `node_modules/next/dist/docs/`

### Required Behavior

- Public routes remain public.
- Student routes require a student session.
- Parent routes require a parent session.
- Super-admin routes require a super-admin session.
- Protected API routes that mutate or expose protected data reject unauthenticated callers.
- Build output no longer warns that `middleware` should become `proxy`.
- Landing page CTA is accessible as a link named `Start learning free`.

### Required Tests

- Public smoke passes.
- Protected UI route redirects unauthenticated users.
- Protected API route rejects unauthenticated requests.
- Role mismatch is rejected for at least student, parent, and super-admin surfaces.
- `npm run build` has no middleware deprecation warning.

### Phase 3 Done Criteria

- `src/middleware.ts` is removed or no longer used.
- `src/proxy.ts` implements the route gate according to Next 16 docs.
- Public CTA e2e passes.
- Auth contract tests cover UI and API routes.
- Gap Analyst confirms no protected route was accidentally made public.

---

## 7. Phase 4: Database, RLS, Atomic Counters, and Local Reproducibility

### Audit Findings Covered

- P1: Counters and family seats are not atomic.
- P1: Local database and full auth e2e verification are blocked.
- Database/RLS module needs fresh local reproducibility.

### Required Changes

- Make Nex daily usage increments atomic.
- Make practice daily usage increments atomic.
- Make family seat joins atomic and seat-limited.
- Preserve existing RLS protections.
- Verify hosted Supabase migration state and local reset when Docker is available.

### Affected Surface Map

Planner must map these surfaces before approval:

- `src/server/services/nexUsageService.ts`
- `src/server/services/familySubscriptionService.ts`
- `supabase/migrations/**`
- RLS tests under `tests/rls/**`
- usage and family tests under `tests/**`
- docs that describe database verification

### Required Behavior

- Concurrent Nex message increments cannot lose updates.
- Concurrent practice session increments cannot lose updates.
- Concurrent family joins cannot exceed `family_groups.max_seats`.
- A student already on a family plan cannot join another family plan.
- Hosted Supabase dry-run remains clean.
- Local `npm run db:reset` passes when Docker is running.

### Implementation Constraints

- Prefer Postgres functions or atomic constrained updates over application read-then-write flows.
- Add migrations under `supabase/migrations/`.
- Do not weaken existing RLS policies to make tests pass.
- Do not use service role in client code.

### Required Tests

- Concurrent Nex usage test.
- Concurrent practice usage test.
- Concurrent family join seat-limit test.
- Existing RLS tests still pass.
- Hosted migration dry-run reports up to date.
- Local reset result is recorded; if Docker is unavailable, QA records blocker and runs hosted dry-run.

### Phase 4 Done Criteria

- No read-then-write daily counter race remains.
- No read-then-insert-then-update family seat race remains.
- RLS test suite remains green.
- Supabase migration state is verified.
- Gap Analyst confirms no database policy was weakened.

---

## 8. Phase 5: Learning Core and Content Coverage

### Audit Findings Covered

- Curriculum/content module needs coverage checks.
- Diagnostic flow needs fresh student verification.
- Practice sessions need mastery/streak/XP verification.
- Study plans need plan-gating and progress verification.

### Required Changes

- Add seeded-content coverage checks.
- Verify onboarding to diagnostic to dashboard.
- Verify practice answer/complete flow persists mastery, streak, XP, and usage.
- Verify study plan generation/regeneration gates and progress persistence.
- Align Science/English launch visibility with actual seed coverage.

### Affected Surface Map

Planner must map these surfaces before approval:

- `src/server/services/curriculumService.ts`
- `src/server/services/diagnosticService.ts`
- `src/server/services/practiceService.ts`
- `src/server/services/studyPlanService.ts`
- `src/lib/curriculum/**`
- `src/lib/diagnostic/**`
- `src/lib/mastery/**`
- `src/lib/studyPlan/**`
- `src/app/api/diagnostic-assessments/**`
- `src/app/api/practice-sessions/**`
- `src/app/api/study-plans/route.ts`
- `supabase/seed/**`
- `tests/**`
- `e2e/**`

### Required Behavior

- Content coverage matrix proves required curriculum, grade levels, subjects, topics, subtopics, lessons, diagnostic questions, and practice questions exist.
- Fresh student can complete onboarding, diagnostic, and reach dashboard.
- Practice session records answers and completion.
- Practice completion updates mastery/streak/XP according to current service behavior.
- Study plan access respects free/trial/premium rules.
- Science/English are either launch-visible with coverage or explicitly gated from launch surfaces.

### Required Tests

- Seed coverage test for required curriculum tables.
- Diagnostic completion path.
- Practice session start, answer, complete path.
- Study plan generate/regenerate access tests.
- E2E or integration fixture for fresh student path.

### Phase 5 Done Criteria

- Content coverage is machine-checked.
- Core learning path has end-to-end evidence.
- Study plan gates are tested.
- Gap Analyst confirms public copy does not promise unsupported learning scope.

---

## 9. Phase 6: Nex Text, Camera, Voice, and Revision Help

### Audit Findings Covered

- Nex text/camera/voice can return mock success in production.
- Camera prompt is math-only while product scope mentions Math, Science, and English.
- Nex and practice usage caps depend on Phase 4 atomic counters.

### Required Changes

- Remove production mock success for text, camera, and voice.
- Keep golden tutor behavior green.
- Align camera subject scope with Math, Science, and English or gate unsupported subjects.
- Ensure Nex calls persist expected messages/results and respect atomic daily caps.
- Document audio payload size/failure behavior.

### Affected Surface Map

Planner must map these surfaces before approval:

- `src/app/api/nex/chat/route.ts`
- `src/app/api/nex/camera/route.ts`
- `src/app/api/nex/voice/route.ts`
- `src/lib/nex/callNexModel.ts`
- `src/lib/nex/extractImageText.ts`
- `src/lib/nex/voiceTranscribe.ts`
- `src/lib/nex/voiceSynthesize.ts`
- `src/lib/nex/validateNexResponse.ts`
- `src/lib/nex/detectNexMode.ts`
- `tests/nex/**`
- Nex e2e or integration tests

### Required Behavior

- Missing AI keys fail closed in production.
- Text tutor persists messages and respects daily caps.
- Camera route validates file size and MIME type and fails predictably on provider failure.
- Voice route validates audio and fails predictably on transcription or synthesis failure.
- Homework first-turn safety and response validation stay green.
- Camera subject behavior matches launch scope.

### Required Tests

- Golden conversations pass.
- Production no-mock tests pass.
- Camera mocked-provider test passes.
- Voice mocked-provider test passes.
- Daily cap behavior uses Phase 4 atomic usage functions.
- Staging checklist exists for one real provider smoke test.

### Phase 6 Done Criteria

- No production Nex mock path can silently succeed.
- Text/camera/voice behavior is tested.
- Camera scope is not misleading.
- Gap Analyst confirms no direct client LLM calls were introduced.

---

## 10. Phase 7: Billing, Notifications, Reports, and Admin

### Audit Findings Covered

- Billing module is red until Daraja sandbox is verified.
- Notification module is red/amber until Celcom and Resend staging sends are verified.
- Weekly reports depend on cron secret enforcement.
- Notification retention does not match 90-day security docs.
- Admin settings need pricing/payment consistency tests.

### Required Changes

- Verify Daraja sandbox path before paid launch.
- Verify Celcom and Resend staging sends before notification launch.
- Ensure weekly report cron requires `CRON_SECRET`.
- Add notification retention cleanup for old SMS/email logs.
- Add admin pricing/payment drift tests.

### Affected Surface Map

Planner must map these surfaces before approval:

- `src/app/api/mpesa/stk-push/route.ts`
- `src/app/api/subscriptions/trial/route.ts`
- `src/app/api/cron/weekly-reports/route.ts`
- `src/app/api/admin/**`
- `src/lib/mpesa/mpesaClient.ts`
- `src/lib/celcom/celcomClient.ts`
- `src/lib/resend/resendClient.ts`
- `src/server/services/subscriptionService.ts`
- `src/server/services/notificationService.ts`
- `src/server/services/weeklyReportService.ts`
- `src/lib/platform/getPlatformSettings.ts`
- `supabase/migrations/**`
- billing, notification, cron, and admin tests

### Required Behavior

- Paid launch is blocked until Daraja sandbox evidence is recorded.
- Notification launch is blocked until Celcom and Resend staging evidence is recorded.
- Weekly report cron rejects missing or invalid `CRON_SECRET`.
- Notification logs older than 90 days can be cleaned according to security docs.
- Platform pricing/settings changes are reflected consistently in public pricing and payment amount.

### Required Tests

- Cron route rejects missing/invalid secret.
- Retention cleanup removes old notification logs and preserves recent logs.
- Admin settings update flows affect pricing and STK amount consistently.
- Daraja sandbox checklist or integration evidence is attached to QA report.
- Celcom/Resend staging checklist or integration evidence is attached to QA report.

### Phase 7 Done Criteria

- Paid and notification launch gates have evidence.
- Cron secret behavior is tested.
- Retention behavior is implemented and tested.
- Admin pricing/payment drift is tested.
- Gap Analyst confirms no fake production provider success remains.

---

## 11. Phase 8: Mock Exams and Past Paper Scope Lock

### Audit Findings Covered

- P1: Past paper bank is not actually modeled.
- Exam module uses mock exam generation and exam simulator, not a verified past-paper archive.

### Required Changes

- Treat current launch scope as generated mock exams and exam simulator.
- Do not build a true past-paper bank in this remediation pass.
- Remove or clarify UI/docs wording that implies a verified past-paper archive exists.
- Document true past-paper bank as post-launch backlog.

### Affected Surface Map

Planner must map these surfaces before approval:

- `src/app/api/mock-exams/**`
- `src/app/api/exam-simulator/**`
- `src/server/services/mockExamService.ts`
- `src/lib/mockExams/**`
- `src/features/mockExams/**`
- `src/features/examPrep/components/ExamPrepWizard.tsx`
- public or product docs mentioning past papers
- `tests/mockExamEngine.test.ts`
- `tests/examSimulatorEngine.test.ts`
- `tests/rls/mockExamAccess.test.ts`
- exam e2e tests

### Required Behavior

- `/mock-exams`, `/exam-prep`, and `/exam-simulator` remain functional.
- Generated mock exam flow is represented honestly.
- No launch copy claims a real past-paper archive unless the feature exists.
- Post-launch backlog describes the real past-paper bank requirements:
  - paper source,
  - year,
  - subject,
  - marking scheme,
  - licensing/provenance,
  - ingestion workflow,
  - generation traceability.

### Required Tests

- Generate mock exam.
- Start simulator.
- Submit exam.
- Results save and remain scoped to the right student.
- RLS mock exam access tests remain green.
- Copy/docs scan confirms no unsupported past-paper claim remains.

### Phase 8 Done Criteria

- Launch scope is mock exams, not a fake past-paper bank.
- Exam flow is tested.
- Past-paper bank backlog is documented.
- Gap Analyst confirms no unsupported production claim remains.

---

## 12. Final Release Criteria

Production readiness is signed off only when all of these are true:

- All P0 findings are fixed and verified.
- All P1 findings are fixed or documented as explicit release exceptions.
- `deploy:check` includes lint, typecheck, unit tests, scope check, build, env preflight, and audit.
- E2E public smoke passes.
- Authenticated e2e paths pass for student, parent, and super-admin.
- Hosted Supabase dry-run is clean.
- Local `db:reset` is verified when Docker is available.
- No production mock provider path can silently succeed.
- Webhooks reject untrusted requests.
- Security headers are present.
- Atomic counters and family seats are verified under concurrency.
- Billing, notification, cron, and admin release gates have evidence.
- Mock exams are launch-honest and the real past-paper bank is backlog.
- Gap Analyst has no open missed, broken, overbuilt, or unverified blockers.

Final Supervisor signoff must include:

```markdown
# Production Readiness Final Signoff

## Fixed Audit Findings

## Approved Release Exceptions

## Verification Commands and Evidence

## Remaining Non-Launch Backlog

## Final Verdict

READY_FOR_PRODUCTION | NOT_READY
```

---

## 13. Cursor Handoff Prompt

Use this prompt to start the Cursor orchestration session:

```text
You are the Supervisor/Orchestrator for Nexus production-readiness remediation.

Read, in order:
1. AGENTS.md
2. PLAN.md
3. .planning/agents/ORCHESTRATOR.md
4. .planning/agents/PLANNER.md
5. .planning/agents/QA.md
6. .planning/milestones/v2-tier-1/STATUS.md
7. docs/PRODUCTION_READINESS_MODULE_AUDIT.md

Create .planning/milestones/production-readiness/STATUS.md, ARCHITECT-BRIEF.md, and PHASE-PLAN.md.

Do not code yet.

First task:
- Produce Phase 1 Production Gate Hardening as an APPROVED_TO_BUILD phase only if it has a file allowlist, affected surface map, tests, and verification commands.
- Dispatch Coder only after Planner approval.
- After Coder finishes, dispatch QA and Gap Analyst.
- Do not proceed to Phase 2 until QA and Gap Analyst have no blockers.
```

