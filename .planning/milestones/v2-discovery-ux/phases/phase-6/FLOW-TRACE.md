# Phase 6 — Flow Trace

**Verdict:** PASS

## Flows traced

### 1. Public teacher waitlist
`/waitlist/teacher` → semantic `h1` "Teacher waitlist" → form submit button visible.  
E2E: `getByRole('heading', { name: /teacher waitlist/i })` — PASS.

### 2. Exam prep labeling
Student `/exam-prep` → H1 "Exam Prep" aligns with `StudentNav` and breadcrumbs "Exam Prep".  
E2E assertion updated; passes when student creds available.

### 3. Study plan — no active plan
`/study-plan` (post-diagnostic) → daily goal placeholder → generate buttons (`AsyncActionButton`) → `StudyPlanEmptyState` with `/practice` and `/learn` CTAs.

### 4. Study plan — plan with incomplete daily goal
Today's goal progress bar → when not complete, inline practice/learn links → task list with per-topic practice deep-links.

### 5. Study plan — zero tasks today
`StudyPlanTaskList` empty branch → practice/learn CTAs (unchanged path, still valid).

## Warnings
- None blocking. Study plan flows require authenticated student with completed diagnostic (manual/UAT).
