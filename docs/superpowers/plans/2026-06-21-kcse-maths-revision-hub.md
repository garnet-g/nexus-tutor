# KCSE Maths Revision Hub Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Build a maths-first KCSE revision hub that connects syllabus coverage, readiness, daily plans, practice, weak-topic repair, parent trust, and low-data study behavior through existing Nexus services and routes.

**Architecture:** Add a pure revision engine for deterministic tests, a server service that assembles existing progress/study-plan/practice data, and a server-rendered student route at `/revision`. Parent trust uses safe aggregate revision signals only; chat transcripts remain private.

**Tech Stack:** Next.js App Router server components, Supabase service helpers, Vitest, React Testing Library, existing Nexus UI primitives.

---

### Task 1: Revision Engine

**Files:**
- Create: `src/lib/revision/kcseMathRevisionEngine.ts`
- Test: `tests/revision/kcseMathRevisionEngine.test.ts`

- [ ] Write a failing test that proves readiness score combines health and topic mastery, maps topics to Form 1-4 syllabus rows, and surfaces the weakest maths topics first.
- [ ] Run `npx vitest run tests/revision/kcseMathRevisionEngine.test.ts` and confirm it fails because the module does not exist.
- [ ] Implement the engine with stable thresholds: repair below 50, building below 75, ready at 75 and above.
- [ ] Re-run the test and confirm it passes.

### Task 2: Revision Hub UI

**Files:**
- Create: `src/features/revision/components/KcseMathRevisionHub.tsx`
- Test: `tests/revision/KcseMathRevisionHub.test.tsx`

- [ ] Write a failing component test that renders the eight maths-first surfaces: syllabus map, readiness score, daily plan, KCSE practice, weak-topic repair, school trust, parent pricing, and low-data mode.
- [ ] Run `npx vitest run tests/revision/KcseMathRevisionHub.test.tsx` and confirm it fails because the component does not exist.
- [ ] Implement a server-safe presentational component using existing links to `/practice`, `/nex`, `/study-plan`, and `/exam-prep`.
- [ ] Re-run the component test and confirm it passes.

### Task 3: Server Service And Route

**Files:**
- Create: `src/server/services/kcseMathRevisionService.ts`
- Create: `src/app/(student)/revision/page.tsx`
- Create: `src/app/(student)/revision/loading.tsx`
- Modify: `src/components/student/StudentAppShell.tsx`

- [ ] Add a service that resolves the active student profile into a revision hub model using existing progress, active study-plan tasks, and KCSE maths topics.
- [ ] Add the `/revision` page with the same student auth and diagnostic guard pattern as other student routes.
- [ ] Add the route to desktop and mobile student navigation.
- [ ] Verify route imports compile with `npx tsc --noEmit --pretty false`.

### Task 4: Parent-Safe Trust Summary

**Files:**
- Modify: `src/server/services/parentLinkService.ts`
- Modify: `src/features/parent-dashboard/components/ParentDashboard.tsx`

- [ ] Add optional revision readiness fields to linked student overview: maths readiness label, readiness score, and next repair topic.
- [ ] Render those fields in the parent dashboard without exposing chat messages or tutor prompts.
- [ ] Keep the existing parent link flow and `/api/parents/link` caller unchanged.

### Task 5: Verification

**Commands:**
- `npx vitest run tests/revision/kcseMathRevisionEngine.test.ts tests/revision/KcseMathRevisionHub.test.tsx`
- `npx vitest run tests/examPrep/examPrepWizard.test.ts tests/nex/NexChatPanel.test.tsx tests/mockExamEngine.test.ts`
- `npx tsc --noEmit --pretty false`
- `npm run lint`
- `npm run test:scope-check`
- `npm run build`

- [ ] Run all affected tests and gates.
- [ ] Fix any regressions in the touched routes, callers, and handlers.
- [ ] Report the exact verification evidence.
