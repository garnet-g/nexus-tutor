# CODER-CHANGELOG — Phase 1–5 (Discovery UX)

## Criteria addressed
- DISC-ROUTE-01 through DISC-ROUTE-05
- DISC-EXAM-01 through DISC-EXAM-06
- DISC-DASH-01 through DISC-DASH-04
- DISC-WAIT-01 through DISC-WAIT-04
- DISC-TEST-01 through DISC-TEST-03

## Files touched
| File | Change |
|------|--------|
| src/app/(student)/assignment-help/page.tsx | New dedicated homework entry |
| src/app/(student)/exam-prep/page.tsx | Exam prep wizard page |
| src/app/(student)/mock-exams/page.tsx | Redirect to /exam-prep |
| src/app/(student)/nex/page.tsx | searchParams deep-link support |
| src/middleware.ts | Route protection for new paths |
| src/features/student/components/StudentNav.tsx | Exam Prep + Assignment Help nav |
| src/features/examPrep/components/ExamPrepWizard.tsx | Grade/Subject/Strand wizard |
| src/features/mockExams/components/MockExamBuilder.tsx | subjectCode props |
| src/features/dashboard/components/DashboardEmptyStates.tsx | Empty state CTAs |
| src/app/(student)/dashboard/page.tsx | Integrate empty states |
| supabase/migrations/20250616120000_teacher_waitlist.sql | Waitlist table |
| src/schemas/waitlistSchemas.ts | Zod schema |
| src/app/api/waitlist/teacher/route.ts | POST API + rate limit |
| src/app/(public)/waitlist/teacher/page.tsx | Public form |
| src/features/onboarding/components/OnboardingForm.tsx | Waitlist link |
| src/features/auth/components/AuthForm.tsx | Waitlist link on signup |
| tests/examPrep/examPrepWizard.test.ts | Unit tests |
| tests/api/waitlistTeacher.test.ts | Schema + empty state tests |
| e2e/discovery-routes.spec.ts | E2E discovery routes |

## Deviations from plan
- None

## Follow-ups for QA
- Full CI suite + FLOW-TRACE matrix

## Additional fixes (post-initial QA)
- Updated `e2e/discovery-routes.spec.ts` to assert teacher waitlist title using `getByText` instead of `getByRole('heading')`, since `CardTitle` renders a `div` (no semantic heading). Verified via `npm run test:e2e -- e2e/discovery-routes.spec.ts`.
