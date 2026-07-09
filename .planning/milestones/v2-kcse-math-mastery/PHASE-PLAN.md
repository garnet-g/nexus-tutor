---
milestone: v2-kcse-math-mastery
phase: null
agent: planner
version: 1
status: DRAFT
inputs:
  - .planning/milestones/v2-kcse-math-mastery/ARCHITECT-BRIEF.md
outputs:
  - .planning/milestones/v2-kcse-math-mastery/PHASE-PLAN.md
---

# PHASE-PLAN — KCSE Math Mastery

**Architect input:** [ARCHITECT-BRIEF.md](./ARCHITECT-BRIEF.md)  
**Overall verdict:** `APPROVED_TO_BUILD`

## Milestone exit criteria

- [ ] Mobile student IA shows Learn, Help (Nex), and Exam Prep clearly on phone.
- [ ] Exam outcome loop is consistent: mock submit updates health + predicted grade + next study actions.
- [ ] Parent dashboard includes live predicted-grade and latest mock trend.
- [ ] Nex Assessment is visible and updates learning state with valid grading.
- [ ] One closed-loop e2e path passes from diagnostic/readiness to follow-up task generation.

---

## Phase 1 — Mobile exam-prep UX

**Status:** `APPROVED_TO_BUILD`  
**Depends on:** none

### Goal

Make exam-prep and get-help actions first-class on mobile without breaking current routes.

### Tasks

1. Update student mobile/desktop navigation labels and entry points around exam-prep and help.
2. Fix readiness CTA simulator session ID mismatch.
3. Align readiness links/copy to `/exam-prep`.

### File allowlist

```
src/components/student/StudentAppShell.tsx
src/features/student/studentExperience.ts
src/features/student/components/ReadinessExamCta.tsx
src/app/(student)/readiness/page.tsx
```

### Planner verdict

`APPROVED_TO_BUILD`

---

## Phase 2 — KCSE math outcome loop

**Status:** `PENDING`  
**Depends on:** Phase 1

### Goal

Unify grade/outcome semantics and show student+parent proof from mocks.

### Tasks

1. Make predicted-grade display consistent with health-score authority.
2. Add mock history visibility in readiness/exam-prep flow.
3. Ensure mock submission updates next daily-plan actions.
4. Show predicted-grade and latest mock signal in parent dashboard.

### File allowlist

```
src/server/services/mockExamService.ts
src/server/services/studyPlanService.ts
src/features/examPrep/components/ExamPrepWizard.tsx
src/features/student/components/StudentExperienceBlocks.tsx
src/features/parent/**/*
src/app/(student)/exam-prep/page.tsx
src/app/(student)/readiness/page.tsx
```

### Planner verdict

`PENDING`

---

## Phase 3 — Nex as KCSE math teacher

**Status:** `PENDING`  
**Depends on:** Phase 2

### Goal

Make assessment-driven tutoring visible and feed outputs into memory/remediation.

### Tasks

1. Surface assessment mode in Nex UI.
2. Improve assessment grading/state updates in tutor engine.
3. Persist actionable outcomes into weak-topic and plan pathways.

### File allowlist

```
src/features/nex/**/*
src/lib/nex/socraticTutorEngine.ts
src/lib/nex/assemblePrompt.ts
src/lib/nex/loadStudentMemory.ts
src/lib/nex/loadCurriculumContext.ts
src/server/services/misconceptionService.ts
```

### Planner verdict

`PENDING`

---

## Phase 4 — Integration and proof

**Status:** `PENDING`  
**Depends on:** Phase 3

### Goal

Prove the closed KCSE math loop end-to-end and capture reusable contracts.

### Tasks

1. Add/extend e2e for the closed learner loop.
2. Final QA and milestone docs update.
3. Write reusable subject-expansion contracts in milestone README.

### File allowlist

```
e2e/**/*
.planning/milestones/v2-kcse-math-mastery/STATUS.md
.planning/milestones/v2-kcse-math-mastery/README.md
```

### Planner verdict

`PENDING`

---

## Verdict rationale

Phase 1 is scoped for safe, high-leverage UX fixes with clear boundaries. Later phases remain pending to enforce one-phase-at-a-time orchestra execution.
