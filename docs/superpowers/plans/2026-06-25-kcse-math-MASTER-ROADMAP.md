# KCSE Mathematics — Full Syllabus Master Roadmap (Form 1–4)

- **Date:** 2026-06-25
- **Status:** Program roadmap — the authoritative plan for completing ALL KCSE math content
- **Builds on:** the proven slice (`integers`, `algebraic_expressions`, `rates_ratio_proportion`)
- **Companion docs (reuse every batch):**
  - Authoring standard: `docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md`
  - Codebase facts: `docs/superpowers/plans/2026-06-25-kcse-math-CURSOR-GROUND-TRUTH.md`
  - Per-topic task template: `docs/superpowers/plans/2026-06-25-kcse-math-content-slice.md`

---

## 1. Goal

Bring **every KCSE-examinable Mathematics topic, Form 1–4, to `PROD_READY`** — comprehensive
lessons + past-paper-complete practice — with **no gaps and nothing left behind**.

## 2. How "no gaps" is guaranteed (the mechanism)

Completeness is enforced structurally, not by memory:

1. **A coverage matrix** (§4) lists every syllabus topic as a row. A topic is "done" ONLY when it
   computes `PROD_READY` (readiness contract) AND passes the schema guard test
   (`tests/content/kcseMathSeedContent.test.ts`, extended per batch). An unfinished topic is a
   visible `todo` row, impossible to forget.
2. **A completeness audit** reconciles three sources so the matrix itself can't be short:
   the repo skeleton ∪ the official KNEC Maths 121 syllabus ∪ real past-paper topic coverage.
   The first reconciliation (repo vs the owner's syllabus overview) is recorded in §3.
3. **Per-batch acceptance gates** (§7) block a batch from "complete" until every topic in it is green.

## 3. Completeness audit — round 1 (repo vs syllabus overview, 2026-06-25)

- The repo skeleton (`curriculum_math_kcse.sql`) covers the full syllabus: **65 real topics**.
- **GCD/HCF** and **LCM** exist as **subtopics of `factors`** (the overview lists them as separate
  topics) — covered, nested.
- **Pythagoras Theorem** is present (`pythagoras_theorem`, Form 2).
- **GAP — Fractions:** the KCSE `fractions` topic was soft-retired in the slice but, unlike the other
  retired generic topics, has **no granular replacement**. **Action: re-instate (`is_active=true`) and
  rebuild `fractions` to the comprehensive bar.** (Keep `algebra`, `geometry`, `trigonometry`,
  `statistics` retired — each is fully replaced by granular topics.)
- **Probability:** one `probability` topic covers the overview's Probability I & II — ensure subtopics
  span sample space, experimental/theoretical, tree diagrams, mutually-exclusive & independent events.
- **Form placement nuances** (`vectors_i` F2 / `vectors_ii` F3; `linear_motion` F2 vs "Kinematics"):
  repo placement is KNEC-valid; no change.
- **Round-2 audit (deferred):** reconcile against owner-supplied past papers to confirm no examinable
  archetype is missing, and to calibrate difficulty.

## 4. Master coverage matrix (65 topics)

Legend: ✅ done · ⟳ re-instate+rebuild · ▢ todo. (Subtopic codes live in `curriculum_math_kcse.sql`;
add finer subtopics per topic as needed — additive only.)

### Form 1 — 21 topics (incl. Fractions re-instated)
✅ `integers` · ✅ `algebraic_expressions` · ✅ `rates_ratio_proportion` · ✅ `fractions`
✅ `natural_numbers` · ✅ `factors` (incl. gcd_hcf, lcm subtopics) · ✅ `divisibility_tests`
✅ `decimals` · ▢ `squares_square_roots` · ▢ `length` · ▢ `area` · ▢ `volume_capacity`
▢ `mass_weight_density` · ▢ `time` · ▢ `linear_equations` · ▢ `commercial_arithmetic_i`
▢ `coordinates_graphs` · ▢ `angles_plane_figures` · ▢ `geometric_constructions`
▢ `scale_drawing` · ▢ `common_solids`

### Form 2 — 20 topics
▢ `cubes_cube_roots` · ▢ `reciprocals` · ▢ `indices_logarithms` · ▢ `gradient_straight_lines`
▢ `reflection_congruence` · ▢ `rotation` · ▢ `similarity_enlargement` · ▢ `pythagoras_theorem`
▢ `trigonometry_i` · ▢ `area_triangle` · ▢ `area_quadrilaterals_polygons` · ▢ `area_part_circle`
▢ `surface_area_solids` · ▢ `volume_solids` · ▢ `quadratic_expressions_equations`
▢ `linear_inequalities` · ▢ `linear_motion` · ▢ `statistics_i` · ▢ `angle_properties_circle`
▢ `vectors_i`

### Form 3 — 15 topics
▢ `quadratic_equations_ii` · ▢ `approximations_errors` · ▢ `trigonometry_ii` · ▢ `surds`
▢ `further_logarithms` · ▢ `commercial_arithmetic_ii` · ▢ `circles_chords_tangents` · ▢ `matrices`
▢ `formulae_variations` · ▢ `sequences_series` · ▢ `vectors_ii` · ▢ `binomial_expansion`
▢ `probability` · ▢ `compound_proportions_rates_work` · ▢ `graphical_methods`

### Form 4 — 10 topics
▢ `matrices_transformations` · ▢ `statistics_ii` · ▢ `loci` · ▢ `trigonometry_iii`
▢ `three_dimensional_geometry` · ▢ `longitudes_latitudes` · ▢ `linear_programming`
▢ `differentiation` · ▢ `area_approximation` · ▢ `integration`

**Status: 3 done · 62 remaining (incl. 1 re-instate).**

## 5. Per-topic workflow (the repeatable recipe)

Identical for every topic; reuses existing docs so each batch is mechanical:

1. Confirm the topic's subtopics vs KNEC; add finer subtopics if needed (additive `ON CONFLICT DO NOTHING`).
2. Author lessons per subtopic (concept → worked-methods → exam-application) to the CONTENT-GUIDE bar.
3. Author practice: ≥7 easy / ≥7 medium / ≥7 hard, mistake-based distractors, explanations.
4. Apply field-correct LaTeX escaping (GROUND-TRUTH §5: `\\` in JSONB, single `\` in plain SQL strings).
5. Append to a per-wave seed file (see §6); keep idempotent.
6. Verify: `db reset`, schema guard test, readiness → `PROD_READY`, render check.

## 6. Sequencing & batching

- **Form-by-form waves:** Wave 1 = Form 1 (finish 17 todo + re-instate `fractions`), Wave 2 = Form 2,
  Wave 3 = Form 3, Wave 4 = Form 4. Matches grade-gating and concept dependencies.
- **Batch size:** ~5 topics per Cursor run (keeps each diff auditable). Each batch = one new seed file,
  e.g. `supabase/seed/curriculum_math_kcse_f1_b1.sql`, registered in `config.toml` after the existing
  content seed. (Splitting by batch file avoids one unwieldy 10k-line seed and keeps audits scoped.)
- **`fractions` re-instate** is its own small first task in Wave 1 (un-retire + rebuild).

## 7. Per-batch acceptance gate (Definition of Done)

A batch is complete only when, for every topic in it:
- ≥3 lessons, every subtopic has a lesson; ≥7 questions/band; `getTopicReadinessLabel` → `PROD_READY`.
- All lesson JSON passes `lessonContentSchema` (guard test extended to the batch's seed file).
- Seed idempotent (`db reset` ×2 identical); math renders as symbols; English regression unaffected.
- `npm test` green. Independent audit (Claude) signs off the batch diff.

## 8. Scale (so expectations are clear)

62 remaining topics × comprehensive depth ≈ **~350–430 lessons** and **~1,600–2,200 questions**.
A multi-session program: ~13 batches of ~5 topics. Each batch is one Cursor run + one audit pass.
The additive, idempotent seed means batches never rework each other.

## 9. Open items / dependencies

- **Past papers (owner):** drive round-2 completeness audit + difficulty calibration; fold into each
  wave's question banks when available (additive, no rework).
- **Final KNEC confirmation:** the 65-topic list is transcribed from KNEC and reconciled with the
  owner's overview; a last cross-check against the official syllabus PDF closes the loop.
- **Probability depth:** ensure the single `probability` topic's subtopics span Probability I + II.
- **Live verification:** the slice's Task 10/11 (DB load + visual) still pending Docker; same gate
  applies to every batch.

## 10. Immediate next action

**Wave 1, Batch 1:** re-instate + rebuild `fractions`, then author `natural_numbers`, `factors`,
`divisibility_tests`, `decimals` to `PROD_READY`. Generate the batch task plan from the per-topic
template (§5), hand to Cursor, audit the result.
