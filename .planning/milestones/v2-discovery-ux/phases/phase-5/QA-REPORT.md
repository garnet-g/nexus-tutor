# QA Report — V2 Discovery UX (Final)

**Date:** 2026-06-16  
**Verdict:** PASS

## Commands run

| Command | Exit code | Notes |
|---------|-----------|-------|
| `npm run lint` | 0 | 1 warning (react-hooks) — non-blocking |
| `npm run typecheck` | 0 | |
| `npm test` | 0 | 141 tests passed |
| `npm run test:scope-check` | 0 | |
| `npm run build` | 0 | 42 routes including new discovery paths |
| `npm run test:e2e -- e2e/discovery-routes.spec.ts` | 0 | teacher waitlist selector uses `getByText` (2 student tests skipped if E2E creds missing) |

## Planner criteria matrix

| ID | Criterion | Pass | Evidence |
|----|-----------|------|----------|
| DISC-ROUTE-01 | /assignment-help homework mode | Yes | page.tsx passes initialMode="homework" |
| DISC-ROUTE-02 | /exam-prep exists | Yes | build output |
| DISC-ROUTE-03 | /nex searchParams | Yes | mode + topicId wired |
| DISC-ROUTE-04 | middleware protection | Yes | isStudentRoute + matcher updated |
| DISC-ROUTE-05 | /mock-exams redirect | Yes | redirect("/exam-prep") |
| DISC-EXAM-01 | Grade chip | Yes | ExamPrepWizard curriculum + gradeLevel badges |
| DISC-EXAM-02 | Subject dropdown | Yes | getSubjectsForStudent |
| DISC-EXAM-03 | Strand dropdown | Yes | getTopics labeled Strand |
| DISC-EXAM-04 | Subject-aware styles | Yes | MATH vs NON_MATH style options |
| DISC-EXAM-05 | subjectCode in API | Yes | buildGeneratePayload tests |
| DISC-EXAM-06 | Simulator flow | Yes | same generate + start pattern |
| DISC-DASH-01 | Empty states | Yes | DashboardEmptyStates component |
| DISC-DASH-02 | CTAs | Yes | learn, practice, assignment-help, exam-prep |
| DISC-DASH-03 | Conditional display | Yes | shouldShowDashboardEmptyState |
| DISC-DASH-04 | Stat cards preserved | Yes | dashboard page unchanged structure |
| DISC-WAIT-01 | Migration | Yes | teacher_waitlist.sql |
| DISC-WAIT-02 | Public page | Yes | /waitlist/teacher static |
| DISC-WAIT-03 | API validation | Yes | waitlistTeacher.test.ts |
| DISC-WAIT-04 | Onboarding/signup links | Yes | OnboardingForm + AuthForm |
| DISC-TEST-01 | examPrep tests | Yes | 3 tests |
| DISC-TEST-02 | waitlist tests | Yes | 5 tests |
| DISC-TEST-03 | e2e spec | Yes | discovery-routes.spec.ts |

## FLOW-TRACE matrix

| FlowID | UI entry | Component | API route | Handler | Service | DB | Regression |
|--------|----------|-----------|-----------|---------|---------|-----|------------|
| AH-01 | /assignment-help | NexChatPanel | POST /api/nex/chat | route.ts | generateNexResponse | nex_messages | PASS — no bypass |
| EP-01 | /exam-prep | ExamPrepWizard | POST /api/mock-exams/generate | generate/route.ts | mockExamService | mock_exam_sessions | PASS |
| EP-02 | /exam-prep | ExamPrepWizard | POST /api/exam-simulator/start | start/route.ts | mockExamService | exam_simulator_sessions | PASS |
| TW-01 | /waitlist/teacher | form | POST /api/waitlist/teacher | route.ts | admin insert | teacher_waitlist | PASS |
| NX-01 | /nex?mode=homework | NexChatPanel | POST /api/nex/chat | route.ts | generateNexResponse | nex_messages | PASS |

## Regression flows

| Flow | Status |
|------|--------|
| /nex direct (5 modes) | PASS — NexChatPanel unchanged |
| /practice?topicId= | PASS — no changes |
| /mock-exams → /exam-prep | PASS |
| /learn subject explorer | PASS — no changes |
| /dashboard stat cards | PASS |
| Parent /parent | PASS — unaffected |
| generateNexResponse pipeline | PASS — assignment-help uses same API |

## Nex golden cases

Not modified in this milestone — existing 20 golden tests pass via `npm test`.

## RLS / security

- [x] teacher_waitlist: RLS enabled, no public policies — service role API only
- [x] No service role in client bundles
- [x] scope-check passes (no teacher dashboard routes)

## Verdict rationale

All phase criteria verified. CI green. No regressions in traced flows.
