# Phase 6 — UX Polish & Coverage

## Criteria
- UX-POL-01: Canonical "Exam Prep" label on exam-prep page H1
- UX-POL-02: Study plan no-plan empty state with practice/learn CTAs
- UX-POL-03: Daily goal section includes action links when incomplete
- UX-POL-04: Study tasks with topicId link to practice deep-link
- UX-POL-05: CardTitle supports semantic headings; waitlist uses h1
- UX-POL-06: FieldError uses aria-live assertive
- UX-POL-07: StudyPlanActions uses AsyncActionButton
- UX-TEST-02: formContracts unit tests for reliability primitives
- UX-TEST-03: discovery-routes uses semantic heading assertion for waitlist

## Allowlist
- src/app/(student)/exam-prep/page.tsx
- src/app/(student)/study-plan/page.tsx
- src/features/studyPlan/components/StudyPlanView.tsx
- src/components/ui/Card.tsx
- src/app/(public)/waitlist/teacher/page.tsx
- src/components/ui/field-error.tsx
- e2e/discovery-routes.spec.ts
- tests/ui/formContracts.test.tsx
