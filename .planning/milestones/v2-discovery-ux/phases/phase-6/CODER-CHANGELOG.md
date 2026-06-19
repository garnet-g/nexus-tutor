# Phase 6 — Coder Changelog

## Summary
UX polish pass: harmonized Exam Prep labeling, study plan empty/action CTAs, semantic waitlist heading, form reliability a11y, and contract tests.

## Changes

### Label harmonization (UX-POL-01)
- `src/app/(student)/exam-prep/page.tsx` — H1 changed from "Prepare for Exams" to "Exam Prep" (matches nav/breadcrumbs).

### Study plan UX (UX-POL-02–04, UX-POL-07)
- `src/features/studyPlan/components/StudyPlanView.tsx`
  - Added `StudyPlanEmptyState` with practice/learn CTAs when no plan exists.
  - `StudyPlanActions` migrated to `AsyncActionButton` with pending labels.
  - Pending tasks link to `/practice?topicId=…` when `topicId` is set.
- `src/app/(student)/study-plan/page.tsx`
  - Renders `StudyPlanEmptyState` when no active plan.
  - Daily goal section shows practice/learn links when goal incomplete.

### Accessibility (UX-POL-05–06)
- `src/components/ui/Card.tsx` — `CardTitle` accepts optional `as` prop (`h1`–`h3`).
- `src/app/(public)/waitlist/teacher/page.tsx` — `CardTitle as="h1"` for semantic heading.
- `src/components/ui/field-error.tsx` — `aria-live="assertive"` on alerts.

### Tests (UX-TEST-02–03)
- `tests/ui/formContracts.test.tsx` — FieldError + AsyncActionButton contracts.
- `e2e/discovery-routes.spec.ts` — semantic heading assertions for waitlist and exam-prep.

## Verification
- `npm run typecheck` — pass
- `npm test` — 157 passed
- `npm run build` — pass
- `npm run test:e2e -- e2e/discovery-routes.spec.ts` — 1 passed, 3 skipped (no student creds)
