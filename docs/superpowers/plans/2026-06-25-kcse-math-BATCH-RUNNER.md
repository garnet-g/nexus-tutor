# KCSE Math — Batch Runner (carry-on plan for Cursor)

> Use this to execute **every remaining batch** after Wave 1 Batch 1, one batch at a time, until the
> master coverage matrix is fully `✅`. It is a loop: pick the next batch → run the standard procedure
> → pass the gate → mark progress → checkpoint → next batch.
>
> **Read once, fully:** `…-CURSOR-GROUND-TRUTH.md`, `…-CONTENT-GUIDE.md`, `…-MASTER-ROADMAP.md`,
> and the worked example `…-WAVE1-BATCH1.md`. Stay in scope; STOP-and-report on any divergence.

## How to know where you are (state lives in git, not memory)

The single source of truth for progress is the coverage matrix in
`docs/superpowers/plans/2026-06-25-kcse-math-MASTER-ROADMAP.md` §4. A topic marked `✅` is done.
**The next batch = the next group of un-done topics in the Batch Queue below.** After finishing a
batch you flip its topics to `✅` and commit — so the next run (even cold) reads the matrix and knows
exactly what's left.

## Batch Queue (13 batches; ~5 topics each)

Each batch → one new seed file `supabase/seed/curriculum_math_kcse_<id>.sql`, registered in
`config.toml` after the previous batch's file. Branch per batch: `feat/kcse-math-<id>`.

| Batch id | Topics |
|---|---|
| `f1_b1` *(done via WAVE1-BATCH1.md)* | fractions(reinstate), natural_numbers, factors, divisibility_tests, decimals |
| `f1_b2` | squares_square_roots, length, area, volume_capacity, mass_weight_density |
| `f1_b3` | time, linear_equations, commercial_arithmetic_i, coordinates_graphs, angles_plane_figures |
| `f1_b4` | geometric_constructions, scale_drawing, common_solids |
| `f2_b1` | cubes_cube_roots, reciprocals, indices_logarithms, gradient_straight_lines, reflection_congruence |
| `f2_b2` | rotation, similarity_enlargement, pythagoras_theorem, trigonometry_i, area_triangle |
| `f2_b3` | area_quadrilaterals_polygons, area_part_circle, surface_area_solids, volume_solids, quadratic_expressions_equations |
| `f2_b4` | linear_inequalities, linear_motion, statistics_i, angle_properties_circle, vectors_i |
| `f3_b1` | quadratic_equations_ii, approximations_errors, trigonometry_ii, surds, further_logarithms |
| `f3_b2` | commercial_arithmetic_ii, circles_chords_tangents, matrices, formulae_variations, sequences_series |
| `f3_b3` | vectors_ii, binomial_expansion, probability, compound_proportions_rates_work, graphical_methods |
| `f4_b1` | matrices_transformations, statistics_ii, loci, trigonometry_iii, three_dimensional_geometry |
| `f4_b2` | longitudes_latitudes, linear_programming, differentiation, area_approximation, integration |

> `probability` (in `f3_b3`): ensure subtopics cover BOTH Probability I (sample space, simple events,
> experimental vs theoretical) AND Probability II (tree diagrams, mutually-exclusive, independent).

## Standard per-batch procedure

For the current batch id with its topic list:

1. **Branch:** `git checkout main && git pull` (if remote) then `git checkout -b feat/kcse-math-<id>`.
2. **Scaffold:** create `supabase/seed/curriculum_math_kcse_<id>.sql`; register it in `config.toml`
   `sql_paths` immediately after the previous batch's seed file. Commit.
3. **Per topic** (repeat for each of the ~5):
   - Confirm subtopics vs the skeleton (`curriculum_math_kcse.sql`); add finer subtopics if it aids
     understanding (additive `ON CONFLICT (topic_id, code) DO NOTHING`).
   - Author lessons per subtopic (concept → worked-methods → exam-application) to the CONTENT-GUIDE bar.
   - Author practice: **≥7 easy / ≥7 medium / ≥7 hard**, mistake-based distractors, explanations.
   - LaTeX escaping by field: `\\` in JSONB (`content`, `options`, `correct_answer`); single `\` in
     plain SQL strings (`question_text`, `explanation`).
   - All inserts idempotent (lesson `NOT EXISTS` on `(subtopic_id, title)`; question `NOT EXISTS` on
     `(topic_id, question_text)`). Commit per topic.
4. **Gate** (the batch is not done until ALL pass):
   - Add the batch seed file to the validation list in `tests/content/kcseMathSeedContent.test.ts`;
     `npx vitest run tests/content/kcseMathSeedContent.test.ts` → PASS (all lessons schema-valid).
   - `npm run db:reset` twice → identical counts (idempotency); no SQL errors.
   - Coverage SQL for each topic: ≥3 lessons, every subtopic covered, ≥7 questions/band → `PROD_READY`.
   - `npm test` → full suite green.
5. **Mark progress:** flip the batch's topics to `✅` in MASTER-ROADMAP §4. Commit
   `docs(roadmap): mark <id> complete`.
6. **Checkpoint:** write a short batch report (commit list, per-topic counts, deviations) for owner →
   Claude audit. **Recommended: pause for audit after each batch; mandatory: pause after each wave.**
7. **Next:** move to the next batch id in the queue. Repeat until all 13 are `✅`.

## Global rules (same as the slice)

- Never `DELETE` or rename a topic/subtopic `code`; soft-retire with `is_active=false` only.
- Never touch CBC, other subjects, or topics outside the current batch.
- Never invent syllabus topics/subtopics; if unsure, author within existing subtopics and report.
- Every batch on its own branch; commit frequently; keep diffs auditable.
- If anything in the repo contradicts the docs, STOP and report.

## Definition of done (whole program)

All 65 topics `✅` in the matrix; each `PROD_READY`; `npm test` green; all batch seeds idempotent and
registered; legacy generic topics remain retired; `fractions` re-instated. Final: round-2 completeness
audit against owner past papers, and live DB/visual verification (Docker) per the slice's Task 10/11.
