# Nexus Production Readiness Module Audit

Date: 2026-06-19

## Executive Summary

Nexus is not production-ready yet, but it is in a solid pre-release state. The core gates passed for lint, typecheck, unit/integration tests, scope check, cloud Supabase migration/seed verification, and production build. The remaining blockers are mostly around production environment fail-closed behavior, callback/webhook trust, dependency advisories, local Docker/e2e verification, and e2e contract drift.

The app should now be worked as separate modules instead of as one large surface. The most important production split is not just "AI tutor" versus "billing"; it is "student learning surfaces", "privileged server operations", and "external integrations", because that is where release risk concentrates.

## Verification Snapshot

| Gate | Result | Notes |
|---|---:|---|
| `npm run orchestrator:status` | PASS | Active milestone is `PHASE_2_5_CODE_COMPLETE`; next action says batch verification is still needed. |
| `npm run lint` | PASS | ESLint clean. |
| `npm run typecheck` | PASS | TypeScript clean. |
| `npm test` | PASS | 18 files, 157 tests passed. |
| `npm run test:scope-check` | PASS | Scope guard passed. |
| `npm run build` | PASS with warning | Next build succeeds, but warns that `middleware` is deprecated and should become `proxy`. |
| `npm audit --audit-level=moderate` | FAIL | 3 vulnerabilities: high `undici`, moderate `postcss` through Next. |
| `npm run db:reset` | BLOCKED | First blocked by sandbox write to `C:\Users\gar\.supabase`; with approval, failed because Docker Desktop is not available/running. |
| `npx supabase db push --db-url ... --include-seed --yes` | PASS | Applied all 12 migrations to the hosted Supabase project and loaded the seed files. |
| `npx supabase db push --db-url ... --dry-run` | PASS | Hosted database reports "Remote database is up to date." |
| `npx supabase migration list --db-url ...` | PASS | Local and remote migration history match for all 12 migrations. |
| Hosted Supabase seed/RLS smoke | PASS | Seeded counts verified for curriculum, topics, lessons, diagnostic/practice questions, templates, plans, and private `nex-uploads` bucket; no public tables were found without RLS. |
| `npx playwright test` | FAIL/TIMEOUT | Public smoke has a real CTA role mismatch; authenticated tests cannot be trusted until local Supabase is running. |

## Module Breakdown

### 1. Public Marketing, Pricing, Waitlist

Owns public routes: `/`, `/about`, `/pricing`, `/waitlist/teacher`, `/login`, `/signup`.

Key code:
- `src/app/(public)/page.tsx`
- `src/app/(public)/pricing/page.tsx`
- `src/app/(public)/waitlist/teacher/page.tsx`
- `src/app/api/waitlist/teacher/route.ts`
- `src/features/marketing/**`
- `src/features/pricing/**`
- `src/features/auth/**`

Readiness: Amber.

Risks:
- E2E contract fails because the primary CTA is exposed as a button, not a link, even though it visually uses `Link`.
- Pricing reads platform config with fallbacks; hosted DB seed is now verified, but production env preflight and billing-provider configuration are still required before public launch.

Work package:
- Fix CTA semantics and rerun public Playwright smoke.
- Verify SEO, metadata, robots/sitemap, OG images, and production public copy.

### 2. Authentication, Onboarding, User Management

Owns signup/login, Google OAuth callback, roles, student/parent/super-admin profiles, onboarding gates.

Key code:
- `src/server/actions/authActions.ts`
- `src/server/actions/onboardingActions.ts`
- `src/server/actions/profileActions.ts`
- `src/server/services/authService.ts`
- `src/app/auth/callback/route.ts`
- `src/middleware.ts`
- `src/schemas/authSchemas.ts`
- `src/schemas/profileSchemas.ts`

Readiness: Amber.

Strengths:
- Server Actions validate input and re-check sessions.
- Roles are taken from `app_metadata.userRole`.
- Student onboarding and diagnostic gates exist.

Risks:
- `src/middleware.ts` is deprecated under Next 16 and should be migrated to `src/proxy.ts`.
- Route protection is UI-route focused; API routes must each enforce auth independently.
- Super-admin creation and recovery flow are not documented as an operator runbook.

Work package:
- Migrate middleware to proxy.
- Add route/auth contract tests for protected UI and protected APIs.
- Document super-admin bootstrap, demotion, and break-glass recovery.

### 3. Curriculum, Content, Learn

Owns curriculum schema, seeded subjects, lesson rendering, topic tree, and content availability.

Key code:
- `src/lib/curriculum/**`
- `src/server/services/curriculumService.ts`
- `src/features/learn/**`
- `src/app/(student)/learn/**`
- `supabase/seed/curriculum_math.sql`
- `supabase/seed/curriculum_science.sql`
- `supabase/seed/curriculum_english.sql`

Readiness: Amber.

Risks:
- Product docs still describe V1 math-only assumptions while active code and public copy mention Science and English.
- Need a seeded-content completeness check per curriculum, grade, subject, topic, lesson, and practice coverage.

Work package:
- Build content coverage matrix for CBC/KCSE by subject and grade.
- Add seed verification tests for required topics/questions.
- Decide whether Science/English are launch-visible or gated.

### 4. Diagnostic, Academic Health, Mastery

Owns diagnostic attempts, scoring, health score, predicted grade, topic mastery, misconceptions, and diagnostic completion gate.

Key code:
- `src/server/services/diagnosticService.ts`
- `src/lib/diagnostic/**`
- `src/lib/mastery/masteryEngine.ts`
- `src/server/services/misconceptionService.ts`
- `src/features/diagnostic/**`
- `src/app/api/diagnostic-assessments/**`
- `tests/scoringEngine.test.ts`
- `tests/masteryEngine.test.ts`
- `tests/misconceptionPersistence.test.ts`

Readiness: Green/Amber.

Strengths:
- Core tests exist and pass.
- Diagnostic completion gates student dashboard access.
- RLS policies protect student diagnostic data.

Risks:
- Hosted migration plus seed integration is verified, but local Docker reset still could not be run.
- Need live data checks for duplicate completed attempts and health score recalculation consistency.

Work package:
- Run `db:reset` with Docker for local reproducibility.
- Add a "fresh student to diagnostic completion" e2e path.
- Add DB assertion for one completed diagnostic result per student/assessment.

### 5. Nex Text Tutor, Revision Help, AI Responses

Owns chat, mode detection, Socratic tutor engine, curriculum context, memory, model calls, response validation, usage limits.

Key code:
- `src/app/api/nex/chat/route.ts`
- `src/lib/nex/generateNexResponse.ts`
- `src/lib/nex/callNexModel.ts`
- `src/lib/nex/assemblePrompt.ts`
- `src/lib/nex/validateNexResponse.ts`
- `src/lib/nex/detectNexMode.ts`
- `src/lib/nex/loadCurriculumContext.ts`
- `src/lib/nex/loadStudentMemory.ts`
- `tests/nex/goldenConversations.test.ts`

Readiness: Amber.

Strengths:
- Authenticated student-only route.
- Server-side model calls.
- Daily limit checks exist.
- Golden conversation tests exist.

Risks:
- Missing AI keys silently return mock tutor responses.
- Usage count is read-then-update, not atomic, so concurrent requests can exceed limits.
- Homework first-turn safety judge returns false if no model key exists.

Work package:
- Add production fail-closed env validation for `GEMINI_API_KEY` and fallback policy.
- Move usage increments to an atomic Postgres function or single upsert/update.
- Add production-mode tests that prove mock providers cannot be used.

### 6. Camera and Voice Tutor

Owns image upload, OCR/vision extraction, voice transcription, speech synthesis, and multimodal Nex response flow.

Key code:
- `src/app/api/nex/camera/route.ts`
- `src/app/api/nex/voice/route.ts`
- `src/lib/nex/extractImageText.ts`
- `src/lib/nex/voiceTranscribe.ts`
- `src/lib/nex/voiceSynthesize.ts`
- `src/features/nex/components/CameraCaptureButton.tsx`
- `src/features/nex/components/VoicePushToTalk.tsx`
- `supabase/migrations/20250615130000_nex_uploads_storage.sql`

Readiness: Amber/Red.

Strengths:
- Upload size and MIME checks exist.
- Premium/family gating exists.
- Private Supabase bucket with student-scoped policies exists.

Risks:
- Camera extraction prompt is still mathematics-only while public/UI copy says Math, Science, and English.
- Camera and voice have mock fallback behavior that can look successful without real AI keys.
- Audio is returned as base64 in JSON; acceptable for short clips but should be monitored for payload size and latency.

Work package:
- Decide launch subject scope for camera.
- Add production no-mock enforcement.
- Add end-to-end tests with mocked providers and one staging test with real provider keys.

### 7. Practice Sessions

Owns topic/difficulty practice session creation, answer submission, session completion, mastery updates, XP/streak effects, and free/premium daily caps.

Key code:
- `src/app/api/practice-sessions/**`
- `src/server/services/practiceService.ts`
- `src/features/practice/components/PracticeSession.tsx`
- `src/schemas/practiceSchemas.ts`
- `tests/profilePreferences.test.ts`
- `tests/streakBadge.test.ts`

Readiness: Amber.

Strengths:
- Route handlers validate input.
- Daily practice usage counters exist.
- Core unit tests pass.

Risks:
- Practice usage count uses the same non-atomic counter pattern as Nex usage.
- Needs seeded question sufficiency checks per topic/difficulty.

Work package:
- Atomic counter function.
- Content sufficiency seed test.
- E2E path: start practice, answer, complete, verify mastery/result update.

### 8. Past Paper Bank, Past Paper Generation, Mock Exams

Actual current module: AI mock exam generation and exam simulator. A true past-paper bank is not present as a distinct source-of-truth module.

Key code:
- `src/app/api/mock-exams/**`
- `src/app/api/exam-simulator/**`
- `src/server/services/mockExamService.ts`
- `src/lib/mockExams/**`
- `src/features/mockExams/**`
- `src/features/examPrep/components/ExamPrepWizard.tsx`
- `supabase/migrations/20250615140000_mock_exam_tables.sql`
- `tests/mockExamEngine.test.ts`
- `tests/examSimulatorEngine.test.ts`
- `tests/rls/mockExamAccess.test.ts`

Readiness: Amber.

Strengths:
- Mock exam engine and simulator tests pass.
- RLS policies exist for mock exam tables.
- Canonical UX appears to route `/mock-exams` into `/exam-prep`.

Risks:
- No separate past paper ingestion/provenance model.
- Generated exams depend on the practice question bank and fallback generation, not a verified past-paper archive.
- Authenticated e2e was not verified because local Supabase/Docker fixtures were unavailable, even though hosted migrations and seed data are now verified.

Work package:
- Decide whether "past paper bank" is a real launch module or a future content backlog.
- If launch module: add tables for paper source, year, subject, marking scheme, licensing/provenance, and generation traceability.
- Add e2e: generate exam, start simulator, submit, results saved.

### 9. Study Plans and Revision Help

Owns daily goals, exam prep plan generation, recommendations, and study task creation.

Key code:
- `src/app/api/study-plans/route.ts`
- `src/server/services/studyPlanService.ts`
- `src/lib/studyPlan/studyPlanEngine.ts`
- `src/features/studyPlan/components/StudyPlanView.tsx`
- `src/features/examPrep/components/ExamPrepWizard.tsx`

Readiness: Amber.

Risks:
- Needs plan-gating tests for free versus premium/trial.
- Needs behavioral verification that plan tasks update progress and daily goals.

Work package:
- Add tests for premium/trial access.
- Add e2e for generate/regenerate plan.
- Verify daily goal persistence.

### 10. Parent, Family, and Account Relationships

Owns parent dashboard, invite-code linking, family subscription groups, family seats, and parent reports.

Key code:
- `src/app/(parent)/parent/page.tsx`
- `src/app/api/parents/link/route.ts`
- `src/app/api/students/invite-code/route.ts`
- `src/app/api/family/**`
- `src/server/services/parentLinkService.ts`
- `src/server/services/familySubscriptionService.ts`
- `src/features/parent-dashboard/**`
- `tests/rls/parentAccess.test.ts`

Readiness: Amber/Red.

Strengths:
- Parent RLS tests exist and pass.
- Parent read model is linked through `student_parent_links`.

Risks:
- Family seat join is read-then-insert-then-update, so concurrent joins can oversubscribe seats.
- Parent weekly reports depend on notification/email readiness.

Work package:
- Move family join into a transactional Postgres function with row lock or constrained update.
- Add concurrency test for max seats.
- Add parent e2e path with linked student.

### 11. Billing, Subscription, M-Pesa

Owns free/premium/family plans, trials, STK push, callbacks, subscription activation, invoices, billing events.

Key code:
- `src/app/api/subscriptions/trial/route.ts`
- `src/app/api/mpesa/stk-push/route.ts`
- `src/app/api/mpesa/callback/route.ts`
- `src/lib/mpesa/mpesaClient.ts`
- `src/server/services/subscriptionService.ts`
- `src/constants/subscription.constants.ts`
- `supabase/migrations/20250613120200_create_billing_notifications.sql`

Readiness: Red.

Blocking risks:
- M-Pesa STK push silently enters mock mode when Daraja env vars are absent, then marks payment paid and activates subscription.
- M-Pesa callback accepts any JSON payload matching the expected shape, with no route secret/signature/IP allowlist.
- Callback dedupe is not strongly enforced by a unique database constraint.
- Payment initiation is not rate-limited despite the security standard requiring it.

Work package:
- Fail closed in production when Daraja env is missing.
- Add callback verification strategy and reject untrusted callbacks.
- Add DB unique constraint for callback dedupe.
- Add payment rate limiting.
- Run M-Pesa sandbox end-to-end before any paid launch.

### 12. AI and User Communication

Owns SMS, email, Celcom delivery webhook, Resend emails, weekly parent reports, and notification logs.

Key code:
- `src/app/api/celcom/webhook/route.ts`
- `src/app/api/cron/weekly-reports/route.ts`
- `src/lib/celcom/celcomClient.ts`
- `src/lib/resend/resendClient.ts`
- `src/server/services/notificationService.ts`
- `src/server/services/weeklyReportService.ts`

Readiness: Red/Amber.

Risks:
- Celcom delivery webhook accepts unsigned/untrusted JSON and updates delivery logs based on supplied message id.
- Celcom/Resend silently mock in production if keys are missing or `NOTIFICATIONS_MOCK=true`.
- Notification logs store phone/email/body with no implemented retention job, while security docs say 90 days.

Work package:
- Add production no-mock guard.
- Add webhook secret/signature verification.
- Add retention cleanup job and audit.
- Verify weekly parent report cron with `CRON_SECRET`.

### 13. Platform Admin, Beta Invites, Settings

Owns super-admin platform settings, usage stats, beta invites, dynamic pricing/limits/promotions.

Key code:
- `src/app/(super-admin)/admin/**`
- `src/app/api/admin/**`
- `src/features/admin/**`
- `src/server/services/betaInviteService.ts`
- `src/lib/platform/getPlatformSettings.ts`
- `supabase/migrations/20250613140000_create_beta_invites.sql`

Readiness: Amber.

Strengths:
- Admin API routes check authenticated user and super-admin role.
- Platform settings audit log exists.

Risks:
- Need operator runbook for bootstrap and emergency rollback.
- Need tests that pricing page, STK amount, and platform settings update consistently.

Work package:
- Add admin settings e2e with seeded super admin.
- Add config drift test for public pricing and payment amount.

### 14. Infrastructure, Deployment, Security, Observability

Owns Next/Vercel config, headers, Sentry, env readiness, CI, e2e, database migrations.

Key code:
- `next.config.ts`
- `vercel.json`
- `sentry.client.config.ts`
- `sentry.server.config.ts`
- `.github/workflows/**`
- `docs/DEPLOYMENT.md`
- `docs/phase-5-engineering-governance/**`

Readiness: Red/Amber.

Risks:
- `next.config.ts` has no production security headers, despite docs requiring them.
- Dependency audit is not clean.
- `deploy:check` omits e2e, npm audit, DB reset/migration validation, and env validation.
- Hosted Supabase migration/seed state is verified, but local Supabase reset cannot currently be verified without Docker.

Work package:
- Add security headers.
- Add `env:check` or equivalent production preflight.
- Add `audit` and e2e to release gates.
- Run local DB reset once Docker is available.

## Highest Priority Findings

### P0: Production can silently use mock AI, payment, SMS, and email

Evidence:
- `src/lib/nex/callNexModel.ts:146-150` returns a mock response when both AI keys are absent.
- `src/lib/nex/extractImageText.ts:64-69` returns a fake extracted math problem when `GEMINI_API_KEY` is absent or `NEX_MOCK_AI=true`.
- `src/lib/mpesa/mpesaClient.ts:71-77` returns a mock STK checkout when M-Pesa is not configured.
- `src/app/api/mpesa/stk-push/route.ts` then marks mock payments paid and activates subscriptions.
- `src/lib/celcom/celcomClient.ts:25-29` and `src/lib/resend/resendClient.ts:24-28` use mock delivery if keys are missing or `NOTIFICATIONS_MOCK=true`.

Impact:
- A production deploy with missing env can appear to work while tutoring, payments, SMS, and email are fake.

Fix:
- Add fail-closed production env validation.
- Permit mocks only when `NODE_ENV !== "production"` or an explicit non-production flag is set.
- Add a release gate that fails if any mock provider is active in production.

### P0: Payment and notification webhooks are unauthenticated

Evidence:
- `src/app/api/mpesa/callback/route.ts:25-28` parses any request JSON and proceeds without signature, shared secret, or trusted origin verification.
- `src/app/api/celcom/webhook/route.ts:7-10` accepts any JSON and passes it to delivery report handling.
- Security standards require webhook endpoints to validate origin where possible.

Impact:
- A malicious or replayed callback can affect payment state or delivery status. M-Pesa is partly protected by checkout lookup, but the checkout id is returned to the client and should not be treated as a callback secret.

Fix:
- Add provider-supported verification, callback secrets, or strict allowlist strategy.
- Log and reject untrusted callbacks.
- Add tests for unauthenticated callback rejection.

### P1: Local database and full auth e2e verification are blocked

Evidence:
- `npm run db:reset` failed because Docker Desktop is unavailable/running.
- Hosted Supabase was connected successfully; all 12 migrations and seed files were pushed, and remote dry-run now reports the database is up to date.
- Hosted RLS smoke found no public tables without RLS.
- Active milestone status says the next action is batch terminal verification.

Impact:
- Cloud database schema and seed state are now verified, but local reproducibility and seeded-auth e2e coverage are still not proven.

Fix:
- Start Docker Desktop and rerun `npm run db:reset`.
- Then rerun e2e tests with seeded auth fixtures.

### P1: Next 16 middleware migration is pending

Evidence:
- `npm run build` passes but warns that the `middleware` file convention is deprecated.
- Current auth gate lives in `src/middleware.ts`.

Impact:
- Not an immediate runtime break today, but it is a framework drift risk under the repo's "This is NOT the Next.js you know" instruction.

Fix:
- Migrate `src/middleware.ts` to `src/proxy.ts` using the local Next 16 docs and rerun build/e2e.

### P1: Dependency audit is not clean

Evidence:
- `npm audit --audit-level=moderate` reports high `undici` advisories and moderate `postcss` advisory through Next.
- App pins `next` to `16.2.9`.

Impact:
- Release should not ship with a known high advisory without an explicit exception.

Fix:
- Run `npm audit fix` if it only updates lockfile-compatible dependencies.
- For Next-bundled `postcss`, wait for a safe Next patch/canary or document a release exception after exploitability review.

### P1: Required security headers are absent

Evidence:
- Security docs require `X-Frame-Options`, `X-Content-Type-Options`, and `Referrer-Policy`.
- `next.config.ts` contains no `headers()` config.

Impact:
- The app is missing baseline browser hardening.

Fix:
- Add global headers in `next.config.ts`.
- Consider CSP after auditing external domains for Supabase, Google, Gemini/OpenAI calls, Sentry, and media.

### P1: Public CTA e2e fails

Evidence:
- `e2e/smoke.spec.ts` expects a link named "Start learning free".
- Playwright found a button named "Start learning free" instead.

Impact:
- Primary signup CTA semantics are not aligned with route/navigation contract.

Fix:
- Ensure the CTA is exposed as a real link or update the component contract/tests intentionally.

### P1: Counters and family seats are not atomic

Evidence:
- `src/server/services/nexUsageService.ts:36-67` and `114-149` read then update/insert usage counters.
- `src/server/services/familySubscriptionService.ts:73-107` reads seat count, inserts member, then updates seat count.

Impact:
- Concurrent requests can overrun daily limits or family seat limits.

Fix:
- Move both flows to Postgres functions with row locking or atomic constrained updates.
- Add concurrency tests.

### P1: Past paper bank is not actually modeled

Evidence:
- Current code has mock exam sessions and exam simulator, driven by practice questions.
- No distinct past paper source/provenance tables were found.

Impact:
- If "past paper bank" is a launch requirement, the app lacks the data model, upload/ingestion flow, licensing/provenance, marking scheme model, and generation traceability.

Fix:
- Treat as its own module before production, or explicitly move it to backlog and rename the launch surface as "mock exams".

## Recommended Work Order

1. Infra/security release gate: production env fail-closed, webhook verification, security headers, dependency audit decision.
2. DB and e2e verification: local Docker/Supabase reset, seeded auth fixtures, Playwright all green.
3. Billing and communication: Daraja sandbox, Celcom/Resend staging, cron weekly reports.
4. Nex multimodal: no-mock production, camera subject scope, real-provider staging checks.
5. Parent/family: atomic family seats and parent report verification.
6. Content/exam module: decide whether past paper bank exists for launch or mock exams are the launch scope.

## Suggested Orchestrator Phases

### Phase A: Production Gate Hardening

Modules: infrastructure, security, env, webhooks, dependency audit.

Acceptance:
- Production cannot boot with mock payment/AI/notification providers.
- Webhook routes reject untrusted requests.
- Security headers are present.
- `npm audit` has no high findings or has documented exceptions.

### Phase B: Database and Auth Verification

Modules: Supabase migrations, RLS, auth, onboarding, role gates.

Acceptance:
- Hosted Supabase remains migration-clean with `supabase db push --dry-run`.
- `npm run db:reset` passes locally once Docker is available.
- Seeded e2e auth paths pass for student, parent, super-admin.
- RLS tests run against fresh schema.

### Phase C: Billing and Notifications

Modules: subscriptions, M-Pesa, Celcom, Resend, weekly reports.

Acceptance:
- Daraja sandbox STK flow works end to end.
- Failed/cancelled callbacks update state safely.
- Celcom/Resend staging sends real notifications.
- Cron route requires `CRON_SECRET`.

### Phase D: Learning Core

Modules: diagnostic, learn, practice, mastery, study plans.

Acceptance:
- Fresh student completes onboarding to diagnostic to dashboard.
- Practice updates mastery/streak/XP.
- Study plan generation respects plan gates.

### Phase E: Nex and Multimodal

Modules: Nex text, camera, voice, revision help, AI validation.

Acceptance:
- No mock providers in production mode.
- Text/camera/voice calls persist messages and respect daily caps atomically.
- Homework safety and response validation remain green.

### Phase F: Exam and Past Paper Decision

Modules: exam prep, mock exams, exam simulator, possible past paper bank.

Acceptance:
- If mock exams only: rename/position accurately and verify flow.
- If past papers are launch scope: add source/provenance model and generation traceability.
