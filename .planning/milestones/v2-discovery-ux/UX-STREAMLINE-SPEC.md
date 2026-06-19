# UX Streamline Implementation Spec

## Outcome

Make Nexus simpler to navigate, more reliable in interactions, and clearer in data presentation without adding scope-creep features.

## Product Principles Applied

- Keep the student journey anchored to three primary jobs:
  - Learn
  - Get help now
  - Prepare for exams
- Preserve existing Nex backend teaching pipeline (`/api/nex/chat` -> `generateNexResponse`)
- Improve trust through predictable form/button behavior and clear state feedback

## Scope

1. Navigation and labeling consistency
2. Form and button reliability contract
3. Profile/account customization settings (high-value, behavior-affecting)
4. Dashboard and progress data presentation refinements
5. Instrumentation for UX friction
6. QA flow tracing and regression gates

## Non-goals

- Teacher dashboard
- Community/social features
- New learning engines
- New payment architecture

## Implementation Track

### Track A: IA and Navigation Simplification

#### A1. Canonical route/label map

- Canonical student entry points:
  - `/learn` -> "Learn"
  - `/assignment-help` -> "Assignment Help"
  - `/exam-prep` -> "Exam Prep"
- Support routes remain secondary:
  - `/progress`, `/study-plan`, `/profile`, `/pricing`

#### A2. File-level changes

- Update nav consistency:
  - `src/features/student/components/StudentNav.tsx`
- Add page-level breadcrumbs for deeper hierarchies:
  - `src/app/(student)/learn/[topicId]/page.tsx`
  - `src/app/(student)/learn/[topicId]/[lessonId]/page.tsx`
  - `src/app/(student)/exam-simulator/page.tsx`
- Ensure route gating parity:
  - `src/middleware.ts`

#### A3. Acceptance checks

- Route labels are identical across dashboard CTAs, nav, page headers
- No duplicate concepts with different names ("Mock Exams" vs "Exam Prep")
- Mobile nav remains max 4 primary tabs + overflow

---

### Track B: Form and Button Reliability Contract

#### B1. Shared UX contract

All forms and async action buttons must include:

- client-side validation + server-side validation
- disabled loading state during submission
- field-level validation messages
- success confirmation and clear next action
- retry-safe handling for duplicate submits
- keyboard accessibility and semantic labels

#### B2. Introduce reusable primitives

- Add form status helpers:
  - `src/components/ui/form-status.tsx` (new)
  - `src/components/ui/field-error.tsx` (new)
- Add async action wrapper:
  - `src/components/ui/async-action-button.tsx` (new)

#### B3. First migration targets

- `src/features/auth/components/AuthForm.tsx`
- `src/features/onboarding/components/OnboardingForm.tsx`
- `src/app/(public)/waitlist/teacher/page.tsx`
- `src/features/mockExams/components/MockExamBuilder.tsx`
- `src/features/examPrep/components/ExamPrepWizard.tsx`

#### B4. API parity checks

- `src/app/api/waitlist/teacher/route.ts`
- `src/app/api/mock-exams/generate/route.ts`
- `src/app/api/exam-simulator/start/route.ts`

Ensure response shape consistency:

```ts
{ success: true, data: {...} }
{ success: false, error: { code: string, message: string, details?: unknown } }
```

---

### Track C: Customizable Account Settings (high-impact only)

#### C1. Settings to add

- preferred explanation depth (`quick` | `standard` | `detailed`)
- preferred session goal minutes
- preferred reminder channel (`sms` | `email` | `off`)
- optional preferred learning tone

#### C2. Data model

- Extend `student_profiles` with nullable columns or a JSONB settings object
- Update:
  - `supabase/migrations/*_student_preferences.sql` (new)
  - `src/features/profile/components/ProfileForm.tsx`
  - `src/app/(student)/profile/page.tsx`
  - `src/server/services/authService.ts` (if profile loading surface needs projection updates)

#### C3. Integration points

- Feed preference context where relevant:
  - `src/features/nex/components/NexChatPanel.tsx` (request payload metadata only)
  - `src/app/api/nex/chat/route.ts` (map preference context into request envelope)
- Do not fork the Socratic engine.

---

### Track D: Data Presentation and Actionability

#### D1. Dashboard card conversion: metric -> meaning -> action

- Update:
  - `src/app/(student)/dashboard/page.tsx`
  - `src/components/layout/stat-card.tsx`
  - `src/features/dashboard/components/DashboardEmptyStates.tsx`

Each major card should answer:

- What is happening?
- Why it matters?
- What should the student do next?

#### D2. Progress page clarity improvements

- `src/app/(student)/progress/page.tsx`
- `src/features/studyPlan/components/StudyPlanView.tsx`

Add action-led summaries (example: "Focus Algebra this week") with one-click links.

---

### Track E: UX Telemetry and Friction Analytics

#### E1. Event taxonomy

Create a lightweight analytics utility:

- `src/lib/analytics/track.ts` (new)

Events:

- `cta_clicked`
- `form_submit_started`
- `form_submit_succeeded`
- `form_submit_failed`
- `api_error_shown`
- `wizard_step_abandoned`

#### E2. Instrumentation insertion points

- `src/features/examPrep/components/ExamPrepWizard.tsx`
- `src/features/mockExams/components/MockExamBuilder.tsx`
- `src/features/auth/components/AuthForm.tsx`
- `src/features/onboarding/components/OnboardingForm.tsx`
- `src/features/dashboard/components/DashboardEmptyStates.tsx`

---

## QA and Release Gates

### Required command suite

```bash
npm run lint
npm run typecheck
npm test
npm run test:scope-check
npm run build
```

### Mandatory flow-trace matrix

| FlowID | Entry | UI Component | API | Handler | Service | DB | Expected |
|---|---|---|---|---|---|---|---|
| UX-01 | `/assignment-help` | `NexChatPanel` | `POST /api/nex/chat` | `src/app/api/nex/chat/route.ts` | `generateNexResponse` | `nex_messages` | Homework mode initializes, responses stream/return |
| UX-02 | `/exam-prep` | `ExamPrepWizard` | `POST /api/mock-exams/generate` | `src/app/api/mock-exams/generate/route.ts` | `mockExamService` | `mock_exam_sessions` | Subject/topic payload valid |
| UX-03 | `/exam-prep` | `ExamPrepWizard` | `POST /api/exam-simulator/start` | `src/app/api/exam-simulator/start/route.ts` | `mockExamService` | `exam_simulator_sessions` | Redirect to simulator works |
| UX-04 | `/waitlist/teacher` | waitlist form | `POST /api/waitlist/teacher` | `src/app/api/waitlist/teacher/route.ts` | direct admin client | `teacher_waitlist` | Validation + duplicate safe behavior |
| UX-05 | `/profile` | `ProfileForm` | profile update route/action | corresponding route/action file | profile service/action | `student_profiles` | Preferences persist and rehydrate |

### Regression flows

- `/nex` direct mode switching still functional
- `/practice?topicId=` deep-link remains functional
- `/mock-exams` redirects to `/exam-prep`
- `/learn` tree navigation remains functional
- onboarding -> diagnostic -> dashboard gating remains functional
- parent dashboard route remains unaffected

---

## Test Plan Additions

### Unit tests

- `tests/examPrep/examPrepWizard.test.ts` (extend)
- `tests/api/waitlistTeacher.test.ts` (extend)
- `tests/profilePreferences.test.ts` (new)
- `tests/formContracts.test.tsx` (new shared form behavior checks)

### E2E tests

- `e2e/discovery-routes.spec.ts` (extend)
- `e2e/form-reliability.spec.ts` (new)
  - disable-on-submit
  - validation message rendering
  - retry behavior

## Execution Order (3 sprints)

### Sprint 1: Reliability foundations

- Track B primitives + migrate 3 highest-traffic forms
- Track E telemetry scaffolding + event emission
- QA gate on form/button reliability

### Sprint 2: Navigation and presentation

- Track A route-label harmonization and breadcrumbs
- Track D dashboard/progress actionability pass
- QA flow-trace on nav and deep links

### Sprint 3: Account customization

- Track C preference schema + profile UI + Nex request context
- Expand regression matrix to include preference persistence and usage

## Definition of Done

- Core flows are navigable with consistent labels and predictable outcomes
- All migrated forms satisfy reliability contract
- Dashboard and progress provide next-action guidance, not raw metrics only
- Preference settings persist and influence session behavior where defined
- All QA flow traces and CI gates pass
