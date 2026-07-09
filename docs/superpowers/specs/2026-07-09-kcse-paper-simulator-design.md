# KCSE Paper Simulator — Exam Prep Rework

**Date:** 2026-07-09
**Status:** Approved design (brainstorming complete)
**Replaces:** MCQ-based mock exam module (`ExamPrepWizard`, `MockExamBuilder`, `mockExamEngine`, `examSimulatorEngine`)

## Problem

The current exam-prep module resamples the `practice_questions` bank (MCQ / numeric / short-answer one-liners) with a difficulty pattern and calls it a "KCSE-style" exam. A real KNEC KCSE Mathematics paper contains zero MCQs: Section I is 16 compulsory short-answer questions (~50 marks, 2–4 marks each, working required), Section II is 8 structured multi-part questions (10 marks each, candidates answer any 5), and marks are awarded for method (M) as well as accuracy (A). Paying students are not getting exam-grade rehearsal.

## Decisions (locked with owner)

1. **Paper fidelity:** full KNEC paper replica — Section I (16 short-answer, ~50 marks) + Section II (choose 5 of 8 structured 10-mark questions), 2h30m timer, marks per question.
2. **Sourcing:** hybrid — hand-approved **parameterized templates** power student-facing generation (zero runtime LLM cost); an internal **LLM-assisted authoring tool** accelerates template creation.
3. **Marking:** auto + self-mark hybrid — final answers per part auto-marked deterministically; post-submission, students self-award method marks against a revealed KNEC-style mark scheme.
4. **Scope:** KCSE replica only. CBC-style, strand-focus, and full-math exam options are scrapped from exam prep. CBC students see an honest "coming soon" state. Strand rehearsal lives in Practice/Revision.
5. **Coverage:** cumulative-to-form papers — a Form 2 student sits a KCSE-format paper drawn from Form 1–2 content; Form 4 gets the full syllabus.
6. **Architecture:** new `examPapers` domain (Approach A). Old mock-exam code deleted; old tables kept read-only for history. The outcome-loop reuse contract survives: `submit → mastery update → health score → predicted grade → next study task`.

## 1. Data model — new `exam_papers` domain

Four new tables:

### `exam_paper_templates`
One row per question template.

| Column | Notes |
|---|---|
| `id` | uuid pk |
| `paper` | `1` or `2` (KCSE Paper 1 / Paper 2) |
| `section` | `I` or `II` |
| `form_level` | 1–4; highest form whose content the question needs (powers cumulative-to-form filtering) |
| `topic_id` | strand link, drives mastery updates |
| `marks` | 2–4 for Section I, 10 for Section II |
| `difficulty` | easy / medium / hard (assembly balance) |
| `review_status` | `draft` \| `approved`; only approved templates enter papers |
| `is_active` | soft retirement |
| `body` | JSONB — see below |

`body` JSONB shape:

```jsonc
{
  "params": [
    { "name": "angle", "type": "int", "min": 20, "max": 70, "constraints": ["angle % 5 == 0"] }
  ],
  "stem": "In the figure, angle ABC = {angle}°. ...", // LaTeX-capable, rendered by MathText
  "parts": [
    {
      "label": "a",
      "prompt": "Calculate angle ACB.",
      "marks": 3,
      "answerType": "numeric",          // v1: numeric | short_answer (expression answers deferred)
      "answerExpr": "180 - 2*angle",     // evaluated by whitelisted evaluator
      "tolerance": 0                      // numeric: |student − answer| <= tolerance; short_answer: normalized exact match
    }
  ],
  "markScheme": [
    { "code": "M1", "text": "Base angles of isosceles triangle equal: {angle}° each" },
    { "code": "A1", "text": "180 − 2×{angle} = {answer_a}°" }
  ]
}
```

### `exam_paper_sessions`
`id`, `student_id`, `paper` (1|2), `form_scope`, `status` (in_progress | submitted | expired), `started_at`, `ends_at` (2h30m), `total_marks`, `verified_marks`, `self_awarded_marks`.

### `exam_paper_session_questions`
Instantiated questions: `session_id`, `template_id`, `question_number`, `section`, `params` JSONB (sampled values), `rendered_stem`, `rendered_parts` (prompts + marks; **computed answers stored server-side only, never sent to the client mid-exam**), `chosen` (Section II 5-of-8 flag), `sort_order`.

### `exam_paper_answers`
Per part: `session_question_id`, `part_label`, `student_answer`, `is_correct` (auto), `auto_marks`, `self_awarded_method_marks`.

## 2. Generation engine — `src/lib/examPapers/` (pure, unit-testable)

- **Instantiation:** seeded RNG samples parameters within constraints; part answers computed by a small whitelisted expression evaluator (no `eval`, no LLM). Same template yields different numbers each sitting.
- **Assembly:** Section I selects 16 approved templates with a strand spread whose marks sum to exactly 50 (hard assembly constraint; template mark values 2–4 make this solvable); Section II selects 8 × 10-mark templates. Filter: `form_level <= student form`. Templates used in the student's recent sessions are excluded so retakes differ.
- **Bank honesty:** generation requires a minimum approved-template threshold per form/paper (enough for assembly plus retake variety). Below threshold the UI shows a "paper bank in progress for Form X" state. No synthetic fallback questions (the current `12 + 8` fallback is deleted with the old engine).

## 3. Marking — auto + self-mark with KNEC semantics

- During the exam students type **final answers per part** (working happens on real paper beside them, as guided by the UI).
- On submit: correct final answer ⇒ full part marks (authentic KNEC convention — correct answer implies method unless working is explicitly demanded).
- Results screen is a **marked paper**: each part reveals its parameterized mark scheme (M1/A1 steps rendered with the actual numbers from that sitting). For wrong/blank parts the student checks off scheme steps they achieved on paper to self-award method marks, capped below the part's accuracy marks.
- Score display is honest: e.g. **"61/100 — 57 verified + 4 self-marked"**.
- **Outcome loop:** mastery updates consume only verified per-topic correctness; total percentage feeds the existing `academic_health_scores` → predicted-grade chain unchanged.

## 4. Student experience

- **Exam prep page:** choose Paper 1 or Paper 2. Form scoping automatic and visible ("Form 2 scope · Form 1–2 content"). Paper anatomy shown before starting (sections, marks, duration). Explicit guidance: *"Sit this like the real thing — pen and paper beside you, type your final answers here."*
- **Sitting UI (mobile-first, 375px):** persistent 2h30m timer; section tabs; question-navigator grid with answered/flagged states; per-part answer inputs with mark badges; dedicated **Section II selection screen** — pick 5 of 8, changeable until a chosen question has answers.
- **Free vs premium:** free plan gets a sample (first ~5 Section I questions, no Section II); premium gets unlimited full papers. Replaces `FREE_MOCK_EXAM_PREVIEW_LIMIT`.
- **CBC students:** honest "CBC exam prep is coming" state instead of a fake paper.

## 5. Authoring tool (internal/admin)

- Admin describes or pastes a raw question → Claude drafts the full template JSON (params, stem, parts, mark scheme) → tool renders 3 random instantiations with computed answers for human review → approve to publish (`review_status: approved`).
- Validation pipeline: JSON schema check + 100-sample parameter fuzz asserting every part's answer evaluates finite/clean under all sampled parameters.
- LLM cost is confined to authoring; the student path is LLM-free.
- **Seed target:** ~30 Section I + ~12 Section II approved Form 1 templates (mined from the existing hand-authored bank) so Form 1 papers generate on day one.

## 6. Migration / scrap plan

- Delete: `ExamPrepWizard`, `MockExamBuilder`, `mockExamEngine.ts`, `examSimulatorEngine.ts`, `ExamSimulatorShell`, old exam-simulator routes and mock-exam API write paths.
- Old mock-exam tables remain read-only for historical data; no new writes.
- Repoint `ReadinessExamCta`, the readiness page, and study-plan exam touchpoints at the new module.
- Update `e2e/kcse-math-mastery.spec.ts` exam-path assertions to the new flow.

## 7. Testing

- **Unit (pure engine):** parameter sampling respects constraints; answer evaluator correctness; assembly section/marks invariants (16 questions ≈ 50 marks; 8 × 10); cumulative-form filtering; recent-template exclusion; auto-marking with tolerance; self-mark caps; honest-score composition.
- **E2E:** sit a full Form-scoped paper → Section II choice → submit → marked paper with mark scheme → self-award → outcome loop (mastery, health score, predicted grade, next study task).

## Out of scope (explicitly)

- AI marking of typed/photographed working (possible future premium add-on).
- CBC paper fidelity research.
- Subjects beyond Mathematics (reuse contracts per milestone README apply).

## Relationship to existing "Practice Papers" feature

The codebase already has a separate, unrelated-mechanism feature at `/practice-papers` (`past_papers` / `past_paper_attempts` / `past_paper_answers` tables, `pastPaperService.ts`): real uploaded past KNEC paper PDFs, transcribed into structured questions with official marking schemes, marked by Gemini vision on typed answers or photographed working. It is **not** wired into the mastery/health-score/predicted-grade loop and is **not** touched by this rework.

Decision: **keep both, distinct roles** — no shared tables, no code deleted from the `past_papers` domain.
- **New `/exam-prep` (this spec):** generated papers from parameterized templates, self-mark against a revealed scheme, unlimited sittings, zero runtime LLM cost, feeds the outcome loop. Optimized for frequent rehearsal.
- **Existing `/practice-papers`:** real past KNEC papers, AI-marks actual student working via Gemini vision. Optimized for authentic-paper practice and photographed working.

Nav/copy on both surfaces should be tightened during this rework so students understand which is which (e.g. exam-prep copy should say "practice papers, freshly generated every time" rather than anything implying it replaces real past papers).
