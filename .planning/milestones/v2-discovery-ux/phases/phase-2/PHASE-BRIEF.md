# Phase 2 — Navigation & Presentation (Sprint 2)

## Criteria
- UX-NAV-01: Breadcrumbs on learn topic, lesson, exam-simulator pages
- UX-NAV-02: Canonical labels consistent (Learn, Assignment Help, Exam Prep)
- UX-NAV-03: Mobile nav unchanged (4 primary + overflow)
- UX-DASH-01: StatCard supports meaning + next-action copy
- UX-DASH-02: Dashboard cards show actionable guidance
- UX-DASH-03: Progress page action-led summary with links
- UX-DASH-04: StudyPlanView action-led copy where applicable

## Allowlist
- src/components/layout/breadcrumbs.tsx (new)
- src/components/layout/stat-card.tsx
- src/features/student/components/StudentNav.tsx
- src/app/(student)/learn/[topicId]/page.tsx
- src/app/(student)/learn/[topicId]/[lessonId]/page.tsx
- src/app/(student)/exam-simulator/page.tsx
- src/app/(student)/dashboard/page.tsx
- src/app/(student)/progress/page.tsx
- src/features/studyPlan/components/StudyPlanView.tsx
- src/features/dashboard/components/DashboardEmptyStates.tsx
- tests/navigation/breadcrumbs.test.ts (new, optional)
