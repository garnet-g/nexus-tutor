# Mock Exam — "Digital Paper" Exam Room Redesign

**Date:** 2026-06-22
**Status:** Approved (visual brainstorm) → implementation
**Scope:** Redesign the mock-exam taking + results experience into a digital-paper exam room, fix the MCQ functional gap, and align with Design System v2.0.

---

## Problem

The current `ExamSimulatorShell` reads like a low-effort flashcard quiz:

1. **Functional gap:** every question — including `multiple_choice` — renders as a bare text input. Options are ignored, which is poor UX and a grading liability (free text vs. `gradeAnswer`'s option-text match).
2. **Off the design system:** uses generic tokens (`bg-muted`, `bg-red-100`) instead of the emerald/amber/paper palette.
3. **Anticlimactic payoff:** the results screen is a percentage + bullet list, despite the backend producing weak topics, grade deltas, and per-question correctness.

## Approved direction

A KCSE-style **paper rendered inside a scrollable viewport** (like a digital PDF):

- **Exam toolbar** (emerald, sticky): paper title + meta, prominent tabular-nums countdown clock, Submit. Clock shifts to warning/danger near expiry.
- **Paper sheet** on a warm-paper backdrop: exam header ("NEXUS MOCK EXAMINATION", form/curriculum/style/duration), candidate instructions, then numbered questions.
- **Inline answer slots on the sheet:** MCQ → selectable lettered bubbles (stores the option *text*); short-answer/numeric → ruled text input.
- **Mobile (375px):** the sheet **reflows** to screen width — one responsive layout, vertical scroll only, no pinch-zoom. (Direction B from brainstorm.)
- **Results = the marked script:** Nex-led summary banner (score in display serif, predicted-grade delta chip, plain-language Nex line), then the paper returned marked — ✓/✗ per question, the correct answer keyed in green on misses, the student's answer flagged, and the per-question `explanation`. Ends with "Where to focus next" (weak-topic chips) and CTAs.

### Honest deviation from the mockup

The mockup showed per-question marks (`3/4`). `mock_exam_questions` has **no marks column** and `gradeAnswer` is **binary**, so the marked paper shows **✓/✗ + difficulty**, not fabricated partial marks. Per-question marks would require a schema + grading change (future work).

## Architecture / data flow

```
ExamPrepWizard ─POST /api/mock-exams/generate─▶ generateMockExamSession
              ─POST /api/exam-simulator/start─▶ startExamSimulatorSession
              ─▶ /exam-simulator?sessionId=…
exam-simulator/page.tsx (server): loads simulator + questions (NO correct_answer)
   + NEW: loads exam meta (curriculum, grade, style, count) ─▶ <ExamSimulatorShell>
ExamSimulatorShell (client): paper UI ─POST /api/exam-simulator/[id]/submit─▶
   submitExamSimulatorSession ─▶ submitMockExamSession
       returns { resultId, analysis, correctCount, totalCount, review[] }   ← review is NEW
   ─▶ shell renders marked-paper results from `review`
```

### Contract change (additive, backward-compatible)

`submitMockExamSession` result gains `review: MockExamReviewQuestion[]`, built server-side from the exam questions joined with `scored.marked`:

```ts
type MockExamReviewQuestion = {
  questionId: string;
  sortOrder: number;
  questionText: string;
  questionType: "multiple_choice" | "short_answer" | "numeric";
  options: string[] | null;
  difficulty: "easy" | "medium" | "hard";
  topicTitle: string;
  correctAnswer: string;   // stringified from JSONB
  yourAnswer: string | null;
  isCorrect: boolean;
  explanation: string | null;
};
```

`submitExamSimulatorSession` already spreads `...result`, so `review` flows through both submit routes unchanged.

### Security

- Correct answers + explanations are returned **only** in the submit response (post-grading), never in the in-exam question payload (`page.tsx` continues to exclude `correct_answer`).
- All reads stay scoped to `student_id` (service + RLS unchanged).

## Files

| File | Change |
|------|--------|
| `src/server/services/mockExamService.ts` | Expand questions select; build + return `review`; export `MockExamReviewQuestion`. |
| `src/app/(student)/exam-simulator/page.tsx` | Load exam meta; pass `examMeta` to shell. |
| `src/features/mockExams/components/ExamSimulatorShell.tsx` | Full redesign: paper viewport, MCQ rendering, marked-paper results. |
| `tests/mockExamReview.test.ts` (new) | Unit-test the review-builder shape + correctness mapping. |
| `tests/ExamSimulatorShell.test.tsx` (new) | RTL: MCQ renders options, selection captures text, results render marked paper. |

## Out of scope

Per-question marks/partial credit, the builder/wizard visual pass, dark-mode exam theme.
