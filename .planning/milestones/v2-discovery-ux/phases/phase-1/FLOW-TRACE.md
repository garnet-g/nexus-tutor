# Phase-1 Reliability Flow Trace — v2-discovery-ux

Date: 2026-06-16  
Scope: Sprint-1 touched UX paths, cross-phase flow integrity

## Verdict

**PASS** — No BLOCKER-level integration breaks found in the six requested flows.  
All traced paths resolve from UI trigger to backend handling and data touchpoint (or intentionally use server actions/OAuth instead of API routes).

## Evidence Inputs

- Existing QA/build outcomes (phase artifacts):
  - `npm run lint` PASS
  - `npm run typecheck` PASS
  - `npm test` PASS (15 files / 141 tests)
  - `npm run test:scope-check` PASS
  - `npm run build` PASS
- Targeted code inspection across:
  - UX entry components/pages
  - API routes
  - server actions/services
  - DB touchpoint functions and Supabase operations

## Flow Matrix (UI -> API -> handler -> service -> data touchpoints)

| Flow | UI trigger/path | API | Handler | Service | Data touchpoints | Status | Notes |
|---|---|---|---|---|---|---|---|
| 1) Auth form submit + Google path | `AuthForm` (`/login`, `/signup`) submit + Google CTA | **Direct server action / OAuth callback** (no `/api/*` hop) | `loginAction` / `signupAction` / `signInWithGoogleAction`, plus `/auth/callback` GET route | `authService` (`getSessionUser`, `setUserRole`, `createStudentProfile`, `createParentProfile`, `getPostAuthRedirectPath`), `betaInviteService` (signup path) | Supabase Auth (`signInWithPassword`, `signUp`, `signInWithOAuth`, `exchangeCodeForSession`) + profile tables (`student_profiles`, `parent_profiles`) | **WIRED** | Google flow is routed via Supabase OAuth callback and profile creation/redirect is connected end-to-end. |
| 2) Onboarding form validation + submit path | `OnboardingForm` submit | **Direct server action** (no `/api/*`) | `completeOnboardingAction` | `authService.getSessionUser`, `authService.getPostAuthRedirectPath` | `student_profiles` update (`curriculum`, `grade_level`, `school_name`, `target_grade`) | **WIRED** | Client validation gates submit; server-side schema validates again; redirect to post-auth destination is connected. |
| 3) Teacher waitlist submit path | `/waitlist/teacher` form submit | `POST /api/waitlist/teacher` | Route handler in `src/app/api/waitlist/teacher/route.ts` | `createAdminClient` + `teacherWaitlistSchema` | `teacher_waitlist` read (`maybeSingle`) + insert (with duplicate handling + rate-limit gate) | **WIRED** | Response contract `{ success, data/error }` consumed by UI and error/success states are surfaced. |
| 4) ExamPrepWizard generate -> simulator start flow | `ExamPrepWizard` “Start Exam Preparation” | `POST /api/mock-exams/generate` then `POST /api/exam-simulator/start` | Two API handlers (`generate`, `start`) | `mockExamService.generateMockExamSession`, `mockExamService.startExamSimulatorSession` | `practice_questions`, `mock_exam_sessions`, `mock_exam_questions`, `exam_simulator_sessions`, auth/profile checks (`student_profiles`) | **WIRED** | Successful chain ends in navigation to `/exam-simulator?sessionId=...`; simulator page resolves session/questions from DB. |
| 5) MockExamBuilder generate -> simulator start flow | `MockExamBuilder` “Generate & start simulator” | `POST /api/mock-exams/generate` then `POST /api/exam-simulator/start` | Same two API handlers as Flow 4 | Same `mockExamService` chain as Flow 4 | Same data tables as Flow 4 | **WIRED** | Mirrors Flow 4 and reaches same simulator shell route with valid session guard checks. |
| 6) Dashboard empty-state CTA navigation targets | `DashboardEmptyStates` CTA buttons in student dashboard | N/A for click itself | Next.js route navigation via `Link` | N/A | Route files present for `/learn`, `/practice`, `/assignment-help`, `/exam-prep` | **WIRED** | All CTA destinations exist and are in-app routes. |

## Telemetry Resilience Check (tracking sink absent)

Status: **PASS (no UX breakage expected)**.

- Telemetry calls use `track(...)` from `src/lib/analytics/track.ts`.
- Guard: `if (typeof window === "undefined") return;` prevents server-side/runtime misuse.
- Sink behavior: events are emitted via `window.dispatchEvent(new CustomEvent("nexus:analytics", ...))`.
- With no listener/sink attached, dispatch is a no-op from UX perspective; form submits, navigation, and API flows continue unaffected.
- No flow logic is gated on telemetry response values (tracking is side-effect only).

## Findings

### BLOCKERS

None.

### WARNINGS

1. Auth/onboarding flows intentionally bypass `/api/*` in favor of server actions and OAuth callback route. This is valid, but tests that assume an API hop would miss these paths unless action-level coverage remains in place.

## Requirement Mapping (requested flow set)

| Requirement Slice | Integration Path | Status | Issue |
|---|---|---|---|
| Auth submit + Google | `AuthForm` -> server actions/OAuth callback -> `authService` -> Supabase Auth + profile tables -> redirect | WIRED | — |
| Onboarding submit | `OnboardingForm` -> `completeOnboardingAction` -> `authService` -> `student_profiles` update -> redirect | WIRED | — |
| Teacher waitlist submit | Waitlist UI -> `/api/waitlist/teacher` -> route validation/rate-limit -> Supabase `teacher_waitlist` | WIRED | — |
| ExamPrepWizard to simulator | Wizard UI -> `/api/mock-exams/generate` -> `mockExamService.generateMockExamSession` -> `/api/exam-simulator/start` -> `startExamSimulatorSession` -> simulator page load | WIRED | — |
| MockExamBuilder to simulator | Builder UI -> same generate/start APIs -> same service chain -> simulator page load | WIRED | — |
| Dashboard empty CTAs | Dashboard empty-state buttons -> route transitions to `/learn`, `/practice`, `/assignment-help`, `/exam-prep` | WIRED | — |
| Telemetry sink absence | UI actions -> `track()` -> browser event dispatch without listeners | WIRED | — |

## Final PASS/FAIL

**PASS** — No integration blockers detected for Sprint-1 reliability UX paths in this milestone slice.
