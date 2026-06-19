---
milestone: v2-discovery-ux
phase: null
agent: planner
version: 1
status: APPROVED_TO_BUILD
inputs:
  - .cursor/plans/discovery_ux_orchestra_c597d405.plan.md
  - docs/product-governance/mvp-feature-scope-lock.md
outputs:
  - .planning/milestones/v2-discovery-ux/PHASE-PLAN.md
---

# PHASE-PLAN — V2 Discovery UX

**Verdict:** `APPROVED_TO_BUILD`

## Phase 1 — Route foundation

### Criteria
- DISC-ROUTE-01: `/assignment-help` renders NexChatPanel with `initialMode="homework"`
- DISC-ROUTE-02: `/exam-prep` shell page exists
- DISC-ROUTE-03: `/nex` reads `mode` and `topicId` searchParams
- DISC-ROUTE-04: middleware protects `/assignment-help` and `/exam-prep`
- DISC-ROUTE-05: `/mock-exams` redirects to `/exam-prep`; nav updated

### Allowlist
- src/app/(student)/assignment-help/page.tsx
- src/app/(student)/exam-prep/page.tsx
- src/app/(student)/nex/page.tsx
- src/app/(student)/mock-exams/page.tsx
- src/middleware.ts
- src/features/student/components/StudentNav.tsx

## Phase 2 — Exam prep wizard

### Criteria
- DISC-EXAM-01: Grade chip read-only from profile
- DISC-EXAM-02: Subject dropdown from getSubjectsForStudent
- DISC-EXAM-03: Strand/Topic dropdown from getTopics
- DISC-EXAM-04: Exam style selection with subject-aware defaults
- DISC-EXAM-05: subjectCode passed to generate API
- DISC-EXAM-06: Start Exam Preparation triggers simulator flow

### Allowlist
- src/features/examPrep/components/ExamPrepWizard.tsx
- src/features/mockExams/components/MockExamBuilder.tsx
- src/app/(student)/exam-prep/page.tsx

## Phase 3 — Dashboard empty states

### Criteria
- DISC-DASH-01: Empty state cards when no activity
- DISC-DASH-02: CTAs to learn, practice, assignment-help, exam-prep
- DISC-DASH-03: Hidden when user has activity
- DISC-DASH-04: Stat cards unchanged for active users

### Allowlist
- src/features/dashboard/components/DashboardEmptyStates.tsx
- src/app/(student)/dashboard/page.tsx

## Phase 4 — Teacher waitlist

### Criteria
- DISC-WAIT-01: teacher_waitlist migration with RLS
- DISC-WAIT-02: Public form at /waitlist/teacher
- DISC-WAIT-03: POST API with validation
- DISC-WAIT-04: Links from onboarding and signup

### Allowlist
- supabase/migrations/*_teacher_waitlist.sql
- src/app/(public)/waitlist/teacher/page.tsx
- src/app/api/waitlist/teacher/route.ts
- src/schemas/waitlistSchemas.ts
- src/features/onboarding/components/OnboardingForm.tsx
- src/features/auth/components/AuthForm.tsx
- scripts/scope-check.ts

## Phase 5 — Tests

### Criteria
- DISC-TEST-01: examPrepWizard unit tests
- DISC-TEST-02: waitlist API unit tests
- DISC-TEST-03: e2e discovery-routes.spec.ts

### Allowlist
- tests/examPrep/examPrepWizard.test.ts
- tests/api/waitlistTeacher.test.ts
- e2e/discovery-routes.spec.ts
