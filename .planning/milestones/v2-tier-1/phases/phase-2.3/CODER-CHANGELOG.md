---
milestone: v2-tier-1
phase: 2.3
agent: coder
status: READY_FOR_QA
---

# CODER-CHANGELOG — Phase 2.3 Mock Exams + Exam Simulator

## Summary

AI mock exams from the practice question bank (with fallback items) and a timed exam simulator with auto-marking, post-exam analysis, and mastery/health score updates.

## Deliverables

- Migration `20250615140000_mock_exam_tables.sql` (sessions, questions, results, simulator + RLS)
- `mockExamEngine.ts` — style-based question selection, preview cap, scoring
- `examSimulatorEngine.ts` — timer, expiry, grade delta analysis
- APIs: `/api/mock-exams/generate`, `/api/mock-exams/[id]/submit`, `/api/exam-simulator/start`, `/api/exam-simulator/[id]/submit`
- `mockExamService.ts` — generation, simulator lifecycle, mastery + health score flywheel
- UI: `/mock-exams`, `/exam-simulator`, `MockExamBuilder`, `ExamSimulatorShell`
- StudentNav + middleware routes; scope-check allowlists
- Tests: `mockExamEngine`, `examSimulatorEngine`, `rls/mockExamAccess`

## Criteria

V2-MOCK-01 through V2-MOCK-04 and V2-SIM-01 through V2-SIM-06 addressed.
