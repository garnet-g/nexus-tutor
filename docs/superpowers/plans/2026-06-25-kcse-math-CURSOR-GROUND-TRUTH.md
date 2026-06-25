# Cursor Ground-Truth Pack — KCSE Math Content Slice

> **Read this entirely before writing any code.** It is the factual contract for the codebase.
> Do **not** infer schema, file locations, or conventions from memory — everything you need is here
> or must be verified against the live repo. If something here conflicts with what you find in the
> repo, **stop and report the discrepancy** rather than guessing.

Companion docs:
- Design/why: `docs/superpowers/specs/2026-06-25-kcse-math-content-slice-design.md`
- What to build, step-by-step: `docs/superpowers/plans/2026-06-25-kcse-math-content-slice.md`
- How to author the content: `docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md`

---

## 1. Data model (verified from `supabase/migrations/20250613120000_create_core_schema.sql` and `…120100_create_learning_tables.sql`)

Hierarchy: `curricula → subjects → topics → subtopics → lessons`; `practice_questions` attach to a topic (and optionally a subtopic).

```
subjects(id, curriculum_id, code, name, is_active)            UNIQUE(curriculum_id, code)
topics(id, subject_id, code, title, description, sort_order,  UNIQUE(subject_id, code)
       is_active, min_grade_sort_order)                       -- min_grade_sort_order added in 20250614120000
subtopics(id, topic_id, code, title, description, sort_order, is_active)   UNIQUE(topic_id, code)
lessons(id, subtopic_id, title, content JSONB, estimated_minutes, sort_order, is_active, …)
practice_questions(id, topic_id, subtopic_id?, question_text, question_type,
                   options JSONB, correct_answer JSONB NOT NULL,
                   difficulty CHECK IN ('easy','medium','hard'), explanation, is_active)
```

- `lessons.content` defaults to `'[]'` but the renderer/schema expect an **object**: `{"blocks":[…], "shortQuiz":{…}?}`.
- `practice_questions.question_type` used everywhere in seeds = `'multiple_choice'` (208/208 in math seed). `options` is a JSON array of strings; `correct_answer` is a JSON **scalar string** that must exactly equal one option.
- The two KCSE grade sort orders relevant here: `form_1=1, form_2=2, form_3=3, form_4=4` (from `supabase/seed.sql`). All three slice topics are `min_grade_sort_order = 1` (Form 1).

## 2. Lesson content JSON schema (verified from `src/schemas/lessonContentSchemas.ts`)

`lessonContentSchema` = `{ blocks: Block[] (min 1), shortQuiz?: { questions: Q[] (1–5) } }`.
Block is a **discriminated union on `type`**. Allowed block types and their required fields:

| `type` | Required fields | Renders math? (after Phase 1) |
| --- | --- | --- |
| `heading` | `content` | no (plain) |
| `paragraph` | `content` | **yes (Phase 1 adds)** |
| `example` | `title`, `steps: string[] (min 1)`, `answer` | **yes in steps+answer (Phase 1 adds)** |
| `tip` | `content` | **yes (Phase 1 adds)** |
| `callout` | `variant: 'info'\|'warning'\|'key_point'`, `content` | **yes (Phase 1 adds)** |
| `rich_text` | `markdown` | yes (already) |
| `math_block` | `latex`, `caption?` | yes (already; renders `$$latex$$`) |
| `table` | `rows: string[][] (min 1)`, `caption?` | cells plain |
| `chemical_equation` | `equation`, `caption?` | yes (already) |
| `comprehension_passage` | `passage`, `title?` | no (plain) |
| `image` | `url`, `alt`, `caption?` | n/a |
| `video_embed` | `provider`, `url`, `title?` | n/a |
| `divider` | — | n/a |
| `question` (inline self-check) | `questionText`, `questionType: 'multiple_choice'\|'short_answer'`, `options?`, `correctAnswer`, `explanation?` | **yes (Phase 1 adds)** |
| `file_attachment` | `url`, `name` | n/a |

`question` block superRefine rules (enforced): multiple_choice needs ≥2 `options` and `correctAnswer` must match one option (case-insensitive); short_answer must NOT include `options`.

`shortQuiz.questions[]` shape: `{ questionText, options: string[] (min 2), correctAnswer }`.

**You can validate any candidate lesson JSON** by ensuring it parses with `lessonContentSchema` — see the plan's content-validation test task.

## 3. Readiness contract — what "PROD_READY" means in code

From `src/lib/curriculum/contentModel.ts` and `src/lib/curriculum/practiceCoverage.ts`:

- `MIN_LESSONS_PER_TOPIC = 3`; a topic is **learn-ready** when it has ≥3 published lessons AND **every subtopic has at least one lesson**.
- `MIN_QUESTIONS_TO_START_PRACTICE = 5` (per difficulty band); a topic is **practice-ready** when at least one difficulty band has ≥5 questions. `MIN_PRACTICE_QUESTIONS_PER_TOPIC = 21`.
- `getTopicReadinessLabel({publishedLessonCount, subtopicCount, subtopicsWithLesson, questionCounts})` returns `'PROD_READY'` only when **both** learn-ready and practice-ready.
- Coverage targets (stretch): `TOPIC_QUESTION_COVERAGE_TARGET = 20`/band, `SUBTOPIC_QUESTION_COVERAGE_TARGET = 10`/band.

**Slice acceptance:** each of the 3 topics must compute `PROD_READY`. Author **≥7 questions in each of easy/medium/hard per topic** (≥21/topic) so every band clears the start-practice floor with margin.

## 4. Seed conventions (verbatim patterns — copy these exactly)

All examples are real patterns from `supabase/seed/curriculum_math.sql`. **Idempotency is mandatory** — `supabase db reset` may run repeatedly.

**Topic upsert** (note: `DO UPDATE` does NOT touch `is_active`, so a later soft-retire sticks):
```sql
INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'integers', 'Integers', 'KCSE Mathematics — Integers.', 4, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;
```
(For this slice the topics already exist via `curriculum_math_kcse.sql`; you only ADD subtopics/lessons/questions and soft-retire legacy topics.)

**Subtopic insert (additive):**
```sql
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'integer_applications', 'Integers in Real Life', 'Real-life integer problems.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
ON CONFLICT (topic_id, code) DO NOTHING;
```

**Lesson insert (idempotent via NOT EXISTS on subtopic_id + title):**
```sql
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Integers on the Number Line', '<JSON>'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'number_line_integers'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers on the Number Line'
);
```

**Practice question insert (idempotent via NOT EXISTS on topic_id + question_text):**
```sql
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate (-3) + (-5).', 'multiple_choice', '["-8","8","-2","2"]'::jsonb, '"-8"'::jsonb, 'easy', 'Adding two negatives: add magnitudes, keep the sign.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
JOIN public.subtopics st ON st.topic_id = t.id AND st.code = 'operations_integers'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'Evaluate (-3) + (-5).'
);
```
(Existing math seed omits `subtopic_id`; including it is allowed and preferred for sharper mastery tracking. If a join makes a row fragile, fall back to topic-only like the existing seed.)

**Soft-retire legacy KCSE topics (scope to KCSE so CBC topics of the same code are untouched):**
```sql
UPDATE public.topics t
SET is_active = false
FROM public.subjects s, public.curricula c
WHERE t.subject_id = s.id AND s.curriculum_id = c.id
  AND c.code = 'KCSE' AND s.code = 'mathematics'
  AND t.code IN ('algebra','fractions','geometry','trigonometry','statistics');
```
> ⚠️ Codes `algebra`, `fractions`, `geometry` also exist under **CBC** — the `c.code = 'KCSE'` filter is mandatory. Do **not** `DELETE` and do **not** rename any code.

## 5. CRITICAL: LaTeX inside JSON inside SQL (the #1 footgun)

Math renders via KaTeX using `$…$` (inline) and `$$…$$` (block) delimiters. LaTeX uses backslashes
(`\frac`, `\sqrt`, `\times`). Inside a JSON string, a backslash **must be doubled** (`\\`), or the JSON
is invalid / silently mangled (`\f` = form-feed!).

To render the inline fraction ¾ in a paragraph, the layers are:

- Desired rendered markdown: `$\frac{3}{4}$`
- In JSON: `"content": "$\\frac{3}{4}$"`  ← double backslash
- In SQL (`…'::jsonb`, PostgreSQL `standard_conforming_strings` is ON): the single-quoted string keeps `\\` literally, so write it exactly as the JSON: `'{"type":"paragraph","content":"... $\\frac{3}{4}$ ..."}'::jsonb`
- Any literal apostrophe in content must be doubled for SQL: `Grace's` → `Grace''s`.

Quick reference: `\\frac{a}{b}`, `\\sqrt{x}`, `\\times`, `\\div`, `x^{2}`, `a_{1}`, `\\frac{1}{2}(a+b)h`.
For a standalone displayed formula prefer a `math_block` (`latex` field, no `$` delimiters needed — the
renderer wraps it in `$$…$$`); there too, backslashes are doubled in the JSON string.

## 6. Renderer architecture (Phase 1 target)

- `src/features/learn/components/LessonContentBlocks.tsx` — renders each block. Today `paragraph`,
  `example` steps/answer, `tip`, `callout`, and inline `question` text/options are **plain text**;
  `rich_text`/`math_block`/`chemical_equation` already use `ReactMarkdown` + `remark-math` + `rehype-katex`.
- `src/features/practice/components/PracticeRunner.tsx` — question text + options rendered **plain**.
- `src/features/mockExams/components/ExamSimulatorShell.tsx` — question text + options rendered **plain**.
- `src/lib/content/questionText.ts` — `formatStudentQuestionText` only strips label prefixes; no markdown.

Phase 1 introduces **one** shared component (`src/components/content/MathText.tsx`) wrapping the existing
markdown+KaTeX pipeline, with an `inline` variant (no block `<p>`/margins, safe inside buttons & cells),
and routes the plain-text fields above through it. `katex/dist/katex.min.css` is imported in
`LessonContentBlocks.tsx`; ensure it is imported wherever `MathText` is used on practice/exam surfaces
(import it inside `MathText.tsx` so every consumer gets it).

## 7. Hard rules (MUST / NEVER)

- **NEVER** `DELETE` or rename an existing topic/subtopic `code`. Soft-retire with `is_active=false` only.
- **ALWAYS** make seed inserts idempotent (`ON CONFLICT … DO NOTHING` / `NOT EXISTS`). Re-running must not duplicate.
- **ALWAYS** scope legacy retire and any topic-level writes to `c.code = 'KCSE'`.
- **NEVER** touch CBC content, other subjects, or topics outside the 3 in scope.
- **ALWAYS** double backslashes in LaTeX-in-JSON and double apostrophes in SQL strings.
- **NEVER** invent syllabus topics/subtopics. Use the KNEC structure in the content guide; if unsure, report.
- **ALWAYS** keep changes scoped to this spec. If you discover work that seems needed but isn't in the plan, **report it — do not silently expand scope.**

## 8. Verify-don't-assume checklist (run these against the live repo)

- [x] Topic `ON CONFLICT DO UPDATE` does not reset `is_active` — **confirmed** in `curriculum_math.sql:215-219`.
- [ ] Confirm the 3 topics + their existing subtopics exist in `curriculum_math_kcse.sql` with the exact codes
      used here (`integers`: `number_line_integers`, `operations_integers`, `order_of_operations`;
      `algebraic_expressions`: `forming_expressions`, `simplification`, `substitution`;
      `rates_ratio_proportion`: `rates`, `ratio_proportion`, `percentage`).
- [ ] Confirm `supabase/config.toml` `[db.seed] sql_paths` order; append the new content file **after** `./seed/curriculum_math_kcse.sql`.
- [ ] Confirm the project's test runner command (it uses **vitest**; tests live under `tests/`). Use `npx vitest run <path>`.
- [ ] Confirm whether `basic_factorisation` belongs to Form 1 in the current KNEC syllabus before adding it (see content guide §5).
