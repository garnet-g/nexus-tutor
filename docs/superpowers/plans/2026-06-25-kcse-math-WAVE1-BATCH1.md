# KCSE Math — Wave 1, Batch 1 (Cursor-ready plan)

> **Implementing agent (Cursor): zero prior context.** Read these first, fully:
> - `docs/superpowers/plans/2026-06-25-kcse-math-CURSOR-GROUND-TRUTH.md` (schema, seed SQL patterns, **LaTeX escaping by field**, hard rules)
> - `docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md` (authoring bar + gold-standard exemplar)
> - `docs/superpowers/plans/2026-06-25-kcse-math-MASTER-ROADMAP.md` (where this batch sits)
>
> Branch: create `feat/kcse-math-f1-b1` off `main`. Commit per task. If the repo diverges from these
> docs, **STOP and report** — do not improvise. Stay strictly in scope.

**Goal:** Bring 5 Form 1 topics to `PROD_READY`: re-instate + rebuild **`fractions`**, then author
**`natural_numbers`**, **`factors`**, **`divisibility_tests`**, **`decimals`**.

**Output seed file:** `supabase/seed/curriculum_math_kcse_f1_b1.sql` (new), registered in
`supabase/config.toml` `[db.seed] sql_paths` **immediately after** `./seed/curriculum_math_kcse_content.sql`.

**Per-topic bar (all 5):** every subtopic has ≥1 lesson; ≥3 lessons/topic; lessons follow
concept → worked-methods → exam-application; **≥7 easy + ≥7 medium + ≥7 hard** practice questions
with mistake-based distractors + explanations; `getTopicReadinessLabel` → `PROD_READY`. LaTeX:
`\\` inside JSONB (lesson `content`, `options`, `correct_answer`); single `\` in plain SQL strings
(`question_text`, `explanation`).

---

### Task 0: Scaffold batch seed file + wiring

- [ ] Create `supabase/seed/curriculum_math_kcse_f1_b1.sql` with a header comment.
- [ ] Add to `supabase/config.toml` `sql_paths` after `"./seed/curriculum_math_kcse_content.sql"`:
  `"./seed/curriculum_math_kcse_f1_b1.sql"`.
- [ ] Commit: `chore(seed): scaffold Form 1 Batch 1 seed file`.

### Task 1: Re-instate + rebuild `fractions` (special — has shallow legacy content)

Context: `fractions` (KCSE) exists in `curriculum_math.sql` with shallow legacy subtopics
(`simplifying`, `operations`, `word_problems`) and was **soft-retired** (`is_active=false`) by
`curriculum_math_kcse_content.sql`. We re-activate the topic, retire the legacy subtopics, and build
fresh comprehensive content under **new subtopic codes** (keeps it idempotent — new content never
collides with the deactivation).

- [ ] **Re-activate the topic** (idempotent):
```sql
UPDATE public.topics t SET is_active = true
FROM public.subjects s, public.curricula c
WHERE t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions';
```
- [ ] **Retire legacy fractions subtopics + their lessons** (scoped to the OLD subtopic codes, so it
  never touches the new ones — idempotent):
```sql
UPDATE public.subtopics st SET is_active=false
FROM public.topics t, public.subjects s, public.curricula c
WHERE st.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
  AND st.code IN ('simplifying','operations','word_problems');

UPDATE public.lessons l SET is_active=false
FROM public.subtopics st, public.topics t, public.subjects s, public.curricula c
WHERE l.subtopic_id=st.id AND st.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
  AND st.code IN ('simplifying','operations','word_problems');

UPDATE public.practice_questions pq SET is_active=false
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions';
```
- [ ] **Add NEW subtopics** (additive) covering the syllabus (proper/improper, operations, BODMAS,
  word problems), e.g. `fraction_types`, `fraction_operations`, `fraction_bodmas`,
  `fraction_word_problems` (use the subtopic INSERT pattern from GROUND-TRUTH §4, `t.code='fractions'`).
- [ ] **Author lessons** (concept→methods→application) under the new subtopics, to the CONTENT-GUIDE bar.
- [ ] **Author practice questions**: ≥7 easy / ≥7 medium / ≥7 hard for `fractions` (the deactivation
  above only hit legacy questions; new ones are active).
- [ ] `npm run db:reset` → no errors. Commit: `feat(content): re-instate and rebuild KCSE Form 1 Fractions`.

### Task 2: `natural_numbers`

Existing subtopics (skeleton): `place_values`, `number_operations`, `number_line`. Cover place value,
rounding off, operations & order, word problems. Add finer subtopics only if needed (additive).

- [ ] Author lessons (every subtopic, ≥3 total, concept→methods→application).
- [ ] Author ≥7/≥7/≥7 questions.
- [ ] `npm run db:reset` clean. Commit: `feat(content): author KCSE Form 1 Natural Numbers`.

### Task 3: `factors`

Existing subtopics: `prime_factors`, `gcd_hcf`, `lcm` (GCD/HCF and LCM live here — do NOT make new
top-level topics for them). Cover factors of composite numbers, prime factorisation, GCD/HCF, LCM,
and applications.

- [ ] Author lessons (every subtopic, ≥3 total).
- [ ] Author ≥7/≥7/≥7 questions.
- [ ] `npm run db:reset` clean. Commit: `feat(content): author KCSE Form 1 Factors (incl. GCD/HCF, LCM)`.

### Task 4: `divisibility_tests`

Existing subtopics: `tests_2_3_4_5`, `tests_6_8_9_10_11`, `applications`. Cover the divisibility rules
and their use in simplification/factorisation.

- [ ] Author lessons (every subtopic, ≥3 total).
- [ ] Author ≥7/≥7/≥7 questions.
- [ ] `npm run db:reset` clean. Commit: `feat(content): author KCSE Form 1 Divisibility Tests`.

### Task 5: `decimals`

Existing subtopics: `place_value_decimals`, `operations_decimals`, `recurring_decimals`. Cover
decimal place value, operations, conversion to/from fractions, recurring decimals, standard form.

- [ ] Author lessons (every subtopic, ≥3 total).
- [ ] Author ≥7/≥7/≥7 questions.
- [ ] `npm run db:reset` clean. Commit: `feat(content): author KCSE Form 1 Decimals`.

### Task 6: Verify the batch (acceptance gate)

- [ ] Extend the seed schema guard test to also validate this batch file. In
  `tests/content/kcseMathSeedContent.test.ts`, add `curriculum_math_kcse_f1_b1.sql` to the set of
  files whose lesson JSON is validated against `lessonContentSchema` (refactor the single-file read
  into an array of files; assert every lesson parses).
- [ ] Run `npx vitest run tests/content/kcseMathSeedContent.test.ts` → PASS.
- [ ] `npm run db:reset` twice → identical counts (idempotency).
- [ ] Run the coverage SQL (MASTER-ROADMAP / slice plan Task 10 style) for the 5 topics: each has
  ≥3 lessons, every subtopic covered, ≥7 questions/band; legacy `fractions` content inactive; topic active.
- [ ] `npm test` → full suite green.
- [ ] **Update progress:** in `docs/superpowers/plans/2026-06-25-kcse-math-MASTER-ROADMAP.md` §4,
  flip these 5 topics from `▢`/`⟳` to `✅`. Commit: `docs(roadmap): mark Form 1 Batch 1 complete`.

### Handback (for owner → Claude audit)
Report: commit list; per-topic counts (lessons/subtopic, questions/band); confirmation legacy fractions
content is inactive and the topic is active; idempotency result; any deviations; `npm test` result.
Then proceed per the batch-runner doc (next).
