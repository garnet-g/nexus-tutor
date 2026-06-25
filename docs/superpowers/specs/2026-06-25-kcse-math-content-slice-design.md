# KCSE Mathematics — Comprehensive Content (Form 1 Gold-Standard Slice)

- **Date:** 2026-06-25
- **Status:** Approved design — ready for implementation plan
- **Author:** Architecture/design session (owner: garnet-g)
- **Implementation model:** Authored by an external coding agent (Cursor); audited against this spec in Claude Code.

---

## 1. Context & problem

Nexus models learning content as `subjects → topics → subtopics → lessons`, with
`practice_questions` attached to a topic/subtopic. Lesson bodies are JSONB
(`{"blocks":[...], "shortQuiz":{...}}`) rendered by a rich 15-block renderer.

Mathematics today is **broad but shallow**:

- `supabase/seed/curriculum_math.sql` — CBC topics plus **5 legacy generic KCSE topics**
  (`algebra`, `fractions`, `geometry`, `trigonometry`, `statistics`) with placeholder
  content and 168 mixed questions.
- `supabase/seed/curriculum_math_kcse.sql` — the **full KNEC Maths 121 syllabus skeleton**
  (~44 topics, 65 topic/subtopic inserts) with thin placeholder lessons and **zero
  practice questions**.

By the codebase's own readiness contract (`src/lib/curriculum/contentModel.ts`,
`src/lib/curriculum/practiceCoverage.ts`), **no math topic is `PROD_READY`**.

The product goal: a student opens Mathematics and finds **every KCSE-examinable topic per
the KNEC syllabus**, each topic opening into subtopics and lessons broken down finely enough
to *fully* teach it, plus practice that covers every past-paper question archetype —
"comprehensive and worth paying for."

The browse experience (subject → topics → subtopics → lessons) **already exists** and
needs no new navigation:
- `/learn` → `LearnSubjectExplorer`
- `/learn/[topicId]` → `TopicLearningPath`
- `/learn/[topicId]/[lessonId]` → `LessonReader`

## 2. Goals

1. Take **3 Form 1 KCSE Mathematics topics** to a **comprehensive** standard (defined in §4),
   establishing the gold-standard pattern the rest of the syllabus will follow.
2. Make math notation render correctly everywhere students read it (contained renderer fix, §5).
3. Cleanly remove the legacy generic KCSE math topics from the student view, non-destructively (§6).
4. Keep all content version-controlled, idempotent, and re-runnable as seed.

## 3. Non-goals (explicit out of scope)

- CBC content (revisit later).
- The other ~41 KCSE math topics (filled incrementally in later sessions).
- Reworking the admin content-generation pipeline (known-broken; separate future effort).
- New content block types or an image/diagram asset pipeline (use `table` / `math_block` / text).
- Subjects other than Mathematics.

## 4. The "comprehensive" bar (replaces fixed lesson counts)

The codebase thresholds are a **floor**, not the target:
`MIN_LESSONS_PER_TOPIC = 3` (every subtopic covered), `MIN_PRACTICE_QUESTIONS_PER_TOPIC = 21`,
`MIN_QUESTIONS_TO_START_PRACTICE = 5` per difficulty band; `getTopicReadinessLabel(...)` must
return `PROD_READY` for each slice topic.

The **target**, per topic, is variable and quality-driven:

- **Subtopics:** as many as the topic genuinely needs. Begin from the KNEC skeleton and **add
  finer subtopics** wherever a breakdown aids understanding. No fixed number.
- **Lessons per subtopic:** enough to *fully teach* it. Default pedagogical shape:
  1. **Concept** — definitions, why it matters, key formulas, simple illustrative examples.
  2. **Worked methods** — multiple worked examples (step-reveal UX) showing techniques/method marks.
  3. **Exam application** — KCSE-style problems, common mistakes/traps, exam technique.
  A simple subtopic may need 2 lessons; a heavy one 3–4.
- **Practice questions:** cover **every question archetype** for the topic, spread across
  easy/medium/hard. Driven by the topic's real exam footprint, not a flat 21. Recommended
  starting depth: **≥7 per difficulty band per topic (≥21/topic)**, expanding toward the
  codebase coverage target (`TOPIC_QUESTION_COVERAGE_TARGET = 20`/band) in the past-paper pass.
- **Worked examples** for every major method/technique KCSE tests.
- **Qualitative bar:** a student who completes a topic's lessons + practice can answer *any*
  past-paper question on that topic.

### 4.1 Authoring source & sequence

Author **now** from the KNEC Maths 121 syllabus + KCSE domain knowledge, verified with targeted
web research on current syllabus structure and standard question styles. **Author original,
KCSE-style** lessons and questions — do **not** reproduce copyrighted past papers verbatim.
A later pass uses owner-supplied past papers + marking schemes as a **coverage checklist and
calibration source** to expand/tune the banks. The seed is additive/idempotent, so expansion
carries no rework penalty.

## 5. Renderer enhancement (contained)

**Problem:** LaTeX only renders in `rich_text` and `math_block` blocks. It does **not** render in
the fields math depends on most:
- Lessons: `paragraph`, `example` steps + `answer`, `tip`, `callout`, inline `question` text/options.
- Practice: question text + options (`src/features/practice/components/PracticeRunner.tsx`).
- Mock exams: question text + options (`src/features/mockExams/components/ExamSimulatorShell.tsx`).

**Design:** Extract one shared, inline-safe math/markdown renderer reusing the existing stack
(`remark-gfm` + `remark-math` + `rehype-katex`, already used by `MarkdownContent` in
`src/features/learn/components/LessonContentBlocks.tsx`). Route the fields above through it.

- New shared component (e.g. `src/components/content/MathText.tsx`) with an **inline** variant
  (no block `<p>` margins; suitable for option buttons and table cells) and a **block** variant.
- Preserve existing UX: the `example` "show next step" progressive reveal stays; only the text
  *inside* each step/answer becomes math-aware.
- `katex/dist/katex.min.css` is already imported where needed; ensure it loads on practice/exam
  surfaces too.

**Known risk — markdown reinterpretation of existing prose.** Routing existing plain-text content
through markdown can change rendering for strings containing markdown-significant characters
(`*`, `_`, `#`, leading `1.`). Mitigation: markdown passes ordinary prose through unchanged in the
overwhelming majority of cases; **regression-check an existing English lesson and an English
practice session** in preview (§8) to confirm no disturbance. If a real problem surfaces, scope a
follow-up (e.g. minimal escaping) — do not expand this slice.

## 6. Removal / retire plan (non-destructive)

- **Keep** the KNEC topic/subtopic skeleton (`curriculum_math_kcse.sql`) as the backbone.
- **Soft-retire** the 5 legacy generic KCSE topics (`algebra`, `fractions`, `geometry`,
  `trigonometry`, `statistics`) by setting `is_active = false` in the new seed. Students stop
  seeing them; their question rows and the export script stay intact and reversible.
- **Verify** that `curriculum_math.sql`'s `ON CONFLICT (...) DO UPDATE` for those topics does
  **not** reset `is_active` — otherwise a `db reset` would un-retire them. The existing pattern
  updates `title/description/sort_order/min_grade_sort_order` only; confirm before relying on it.
- **No hard `DELETE`** and **no rename** of any existing topic/subtopic `code` (codes are
  referenced by value by lessons/questions and the export script).

## 7. Content architecture & seed wiring

- New file: **`supabase/seed/curriculum_math_kcse_content.sql`** containing, for the slice:
  - any **additive** new subtopics (`ON CONFLICT (topic_id, code) DO NOTHING`),
  - the authored **lessons** (guarded with `NOT EXISTS` on `(subtopic_id, title)` like existing seeds),
  - the authored **practice questions**,
  - the **soft-retire** `UPDATE`s for the 5 legacy topics.
- Register in `supabase/config.toml` `[db.seed] sql_paths` **after** `curriculum_math_kcse.sql`
  so topics/subtopics exist before this file adds lessons/questions.
- Idempotent: re-running `supabase db reset` produces the same result with no duplicates.
- Lesson `content` JSONB must validate against `src/schemas/lessonContentSchemas.ts`
  (`lessonContentSchema`). Practice questions must satisfy `practice_questions` constraints
  (`difficulty ∈ {easy,medium,hard}`, valid `question_type`, `options`/`correct_answer` JSONB).

### 7.1 Proposed per-topic structure (starting point — refine during planning)

All three are `min_grade_sort_order = 1` (Form 1). Subtopic additions are additive only.

- **`integers`** (existing: `number_line_integers`, `operations_integers`, `order_of_operations`)
  - candidate added subtopic: `integer_applications` (real-life: temperature, altitude, money).
- **`algebraic_expressions`** (existing: `forming_expressions`, `simplification`, `substitution`)
  - candidate added subtopic: `basic_factorisation` (common-factor) — confirm it is Form 1 in KNEC.
- **`rates_ratio_proportion`** (existing: `rates`, `ratio_proportion`, `percentage`)
  - candidate added subtopic: `percentage_applications` (profit/loss, discount).

Final subtopic/lesson counts are determined by the comprehensive bar (§4), not fixed here.

## 8. Verification

- **Unit/contract tests:**
  - Extend content/curriculum tests to assert each of the 3 topics computes `PROD_READY`
    via `getTopicReadinessLabel`.
  - New test for the shared math renderer: renders LaTeX (e.g. `\frac{3}{4}`) to KaTeX output
    **and** passes plain text through unchanged.
- **Seed integrity:** `supabase db reset` runs clean; re-run produces no duplicates; the 5 legacy
  topics are `is_active = false`; slice topics show lessons + questions.
- **Preview walkthrough:**
  - Open a new math lesson with a worked example containing fractions/indices — confirm rendering.
  - Run a practice session on a slice topic — confirm question + option math renders.
  - **Regression:** open an existing English lesson and English practice session — confirm prose
    is undisturbed by the renderer change.
- **Full `vitest` suite** passes before completion.

## 9. Risks & mitigations

| Risk | Mitigation |
| --- | --- |
| Markdown reinterprets existing prose | Preview regression check on English content (§5, §8). |
| `db reset` un-retires legacy topics | Verify `ON CONFLICT` doesn't touch `is_active` (§6). |
| Content depth subjective / inconsistent | The comprehensive bar (§4) + per-topic plan in the implementation plan define "done". |
| Authoring ahead of past papers misses archetypes | Foundational Form 1 topics have stable archetypes; later past-paper audit pass closes gaps. |
| Grade-gating hides topics | `isTopicVisibleForGrade` shows grade+1; acceptable, tunable if owner wants full syllabus visible to all. |

## 10. Implementation & audit workflow

Implementation is performed by an external agent (Cursor) from the implementation plan derived
from this spec. The owner relays the agent's output here for **audit against this spec**: correctness
of seed structure/idempotency, schema validity of lesson JSON and questions, renderer change
correctness and backward compatibility, `PROD_READY` achievement, and content quality against the
comprehensive bar. Keep changes scoped to this spec; flag scope creep.
