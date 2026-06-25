# Content Authoring Guide — KCSE Math Slice (Form 1)

> How to author the actual lessons and questions to the "comprehensive, worth-paying-for" bar.
> Read the ground-truth pack first (`…CURSOR-GROUND-TRUTH.md`) for schema/SQL/escaping facts.
> **Author original, KCSE-style content.** Do not copy copyrighted past papers verbatim.

---

## 1. The comprehensive bar (what "done" means per topic)

- Every subtopic the topic needs is present and has lessons (start from KNEC structure; add finer
  subtopics where it aids understanding — additive only).
- Each subtopic is taught with enough lessons to be **fully understood**, using the default shape:
  1. **Concept** — what/why, definitions, key formulas (`math_block`/`callout`), simple examples.
  2. **Worked methods** — multiple `example` blocks (step-reveal) covering each technique/method.
  3. **Exam application** — KCSE-style problems + a `callout(variant:"warning")` of common mistakes +
     1–2 inline `question` self-checks.
  A simple subtopic may merge into 2 lessons; a heavy one may need 3–4. Use judgement, not a fixed count.
- Practice bank per topic: **≥7 easy, ≥7 medium, ≥7 hard** (≥21/topic), covering every question
  archetype for the topic. Expand toward 20/band later when past papers arrive.
- Qualitative test: *a student who finishes the topic can answer any past-paper question on it.*

## 2. Block-usage guidance

- Lead a lesson with a `heading`, then `paragraph`s for explanation.
- Key formula/definition → `callout(variant:"key_point")` or a `math_block`.
- Every method gets a worked `example` (`steps[]` = one method-mark per step; `answer` = final).
- "Watch out" content → `callout(variant:"warning")`.
- End teaching lessons with 1–2 inline `question` self-checks and/or a `shortQuiz` (≤5 Qs).
- Keep numbers Kenyan-relevant where natural (KES, local contexts) — matches existing house style.
- `estimated_minutes`: 8–15 typical. `sort_order`: sequential within the subtopic.

## 3. Math notation rules

- Inline math in any text field: `$ … $` with **doubled backslashes** in the JSON (`$\\frac{3}{4}$`).
- Standalone displayed formula: a `math_block` with `latex` (no `$`), backslashes doubled.
- Prefer real notation over ASCII once Phase 1 lands: `$\\frac{3}{4}$` not `3/4`, `$2^{3}$` not `2^3`,
  `$\\sqrt{2}$` not `sqrt(2)`, `$\\times$`/`$\\div$` for operators where clarity helps.
- Practice question `question_text`, `options`, and `correct_answer` may also use `$…$` (Phase 1 makes
  practice/exam render it). Keep `correct_answer` exactly equal to one `options` entry (string match).

## 4. Question authoring rules

- All practice questions are `multiple_choice` (matches the engine). 4 options is the norm.
- **Distractors must be plausible** — each wrong option should reflect a specific likely mistake
  (sign error, wrong order of operations, inverted fraction, etc.), not random numbers.
- `explanation` states the method/why briefly (one or two sentences) — this is shown after answering.
- Difficulty calibration:
  - **easy** = single-step, direct application of one rule.
  - **medium** = 2–3 steps or a small twist (negatives, brackets, unit change).
  - **hard** = multi-step / word problem / combines techniques / exam-style.
- Spread questions across the topic's subtopics; don't pile all hard questions on one subtopic.

## 5. KNEC syllabus reference — the 3 slice topics (Form 1)

Use these as the authoritative breakdown. Existing subtopic codes are in `curriculum_math_kcse.sql`.
Candidate additions are marked "ADD?" — confirm against the KNEC Maths 121 syllabus before adding;
if uncertain, author within existing subtopics and report rather than invent.

### `integers` (sort_order 4, Form 1)
- `number_line_integers` — represent integers on a number line; order/compare; positive/negative/zero.
- `operations_integers` — add/subtract/multiply/divide integers; sign rules; combined operations.
- `order_of_operations` — BODMAS/BIDMAS with integers and brackets.
- ADD? `integer_applications` — real-life (temperature, altitude/sea level, money gains/losses).

### `algebraic_expressions` (sort_order 7, Form 1)
- `forming_expressions` — translate word statements into algebraic expressions.
- `simplification` — collect like terms; expand/remove brackets; simplify.
- `substitution` — evaluate expressions for given values (incl. negatives).
- ADD? `basic_factorisation` — common-factor factorisation (confirm Form 1 in KNEC; else defer).

### `rates_ratio_proportion` (sort_order 8, Form 1)
- `rates` — quantity per unit (speed, price per kg, rate of work); unit rates.
- `ratio_proportion` — simplify/share in a ratio; direct & inverse proportion; unitary method.
- `percentage` — convert fractions/decimals ↔ %; percentage of a quantity; increase/decrease.
- ADD? `percentage_applications` — profit/loss, discount, commission (simple, Form 1 level).

## 6. GOLD-STANDARD EXEMPLAR — copy this quality & shape

This is one complete **concept lesson** for `integers → number_line_integers`. Replicate this
standard (clarity, structure, math notation, self-check) for every lesson you author. Note the
doubled backslashes and doubled apostrophes.

**Lesson SQL (idempotent):**
```sql
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Integers on the Number Line', '{
  "blocks": [
    {"type":"heading","content":"Integers on the Number Line"},
    {"type":"paragraph","content":"Integers are whole numbers and their opposites: $\\\\ldots, -3, -2, -1, 0, 1, 2, 3, \\\\ldots$ Numbers greater than zero are positive; numbers less than zero are negative; zero is neither."},
    {"type":"math_block","latex":"\\\\ldots\\\\; -3 \\\\; -2 \\\\; -1 \\\\; 0 \\\\; 1 \\\\; 2 \\\\; 3 \\\\; \\\\ldots","caption":"A number line: values increase to the right."},
    {"type":"callout","variant":"key_point","content":"On a number line, a number to the right is always greater. So $-1 > -3$, even though 3 looks bigger than 1."},
    {"type":"paragraph","content":"We use integers every day: a temperature of $-4^{\\\\circ}\\\\text{C}$, a debt of KES 200 written as $-200$, or 50 m below sea level as $-50$."},
    {"type":"example","title":"Order these from smallest to largest: $2, -5, 0, -1, 3$","steps":["Place each on the number line in your mind: the further left, the smaller.","The most negative is $-5$, then $-1$, then $0$, then $2$, then $3$."],"answer":"$-5, -1, 0, 2, 3$"},
    {"type":"callout","variant":"warning","content":"A common mistake is thinking $-5 > -1$ because 5 > 1. With negatives it is the opposite: $-5 < -1$."},
    {"type":"question","questionText":"Which number is greater: $-7$ or $-2$?","questionType":"multiple_choice","options":["$-7$","$-2$","They are equal","Cannot tell"],"correctAnswer":"$-2$","explanation":"On the number line $-2$ is to the right of $-7$, so $-2 > -7$."}
  ],
  "shortQuiz": {
    "questions": [
      {"questionText":"Which of these is the smallest integer?","options":["$-3$","$-10$","$0$","$4$"],"correctAnswer":"$-10$"}
    ]
  }
}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'number_line_integers'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers on the Number Line'
);
```

> Note the **four** backslashes (`\\\\`) in the SQL above: two for the JSON escape, doubled again
> because this snippet is written for direct paste. In the actual `.sql` file you write, you need the
> string that yields JSON `\\` — i.e. type `\\` in the SQL file (PostgreSQL keeps it literal), which the
> JSON parser turns into `\`. **Verify by reset+query (plan Phase 3): the rendered lesson must show a real
> fraction/symbol, not a literal backslash.** If symbols show as literal `\frac`, you have too few
> backslashes; if JSON fails to parse, you have a stray single backslash.

**Three calibrated questions (one per band) for `operations_integers`:**
```sql
-- easy
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-3) + (-5)$.', 'multiple_choice', '["$-8$","$8$","$-2$","$2$"]'::jsonb, '"$-8$"'::jsonb, 'easy', 'Adding two negatives: add the sizes and keep the negative sign.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-3) + (-5)$.');
-- medium
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-6) \\times 4 \\div (-2)$.', 'multiple_choice', '["$12$","$-12$","$-48$","$48$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Left to right: $-6 \\times 4 = -24$; $-24 \\div -2 = 12$ (negative ÷ negative = positive).'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-6) \\times 4 \\div (-2)$.');
-- hard
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'At dawn the temperature was $-4^{\\circ}\\text{C}$. By noon it rose by $11^{\\circ}\\text{C}$, then fell $6^{\\circ}\\text{C}$ by evening. What was the evening temperature?', 'multiple_choice', '["$1^{\\circ}\\text{C}$","$-1^{\\circ}\\text{C}$","$9^{\\circ}\\text{C}$","$21^{\\circ}\\text{C}$"]'::jsonb, '"$1^{\\circ}\\text{C}$"'::jsonb, 'hard', '$-4 + 11 = 7$; $7 - 6 = 1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text LIKE 'At dawn the temperature was %');
```

## 7. Per-topic acceptance checklist (Cursor self-checks before handing back)

For each of `integers`, `algebraic_expressions`, `rates_ratio_proportion`:
- [ ] Every subtopic has ≥1 lesson; ≥3 lessons total on the topic; concept→methods→application covered.
- [ ] Worked `example` for every major method named in §5.
- [ ] ≥7 easy + ≥7 medium + ≥7 hard practice questions; distractors are mistake-based; explanations present.
- [ ] All math uses `$…$`/`math_block` with correctly doubled backslashes; renders as symbols, not raw LaTeX.
- [ ] All inserts idempotent; `db reset` twice yields identical counts.
- [ ] `getTopicReadinessLabel` → `PROD_READY` (verified by the content test in the plan).
