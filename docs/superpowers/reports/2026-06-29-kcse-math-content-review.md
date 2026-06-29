# KCSE Mathematics — Content Quality Review (full read)

- **Date:** 2026-06-29
- **Scope:** Every authored question (~2,600 across Forms 1–4) read for math correctness, answer validity, and pedagogy. Lessons sampled per topic.
- **Reviewer:** Claude (independent content read, not just structural audit).

> **RESOLVED 2026-06-29** — all items below fixed in migration
> `supabase/migrations/20260629120000_kcse_math_content_fixes.sql`, deployed to hosted and
> verified (15/15 corrected via REST query).

## Verdict

**The content is genuinely high quality, well-structured, and authentically KCSE-style.** Questions progress easy→medium→hard, use real Kenyan contexts (KES, matatu, kiosk, shamba), and explanations are concise and method-focused. Lessons follow concept → worked-methods → exam-application.

**Error rate ≈ 0.5%** — 13 questions with a wrong marked answer, plus 1 rendering glitch and 1 minor calibration nit. All are listed below with the correction. None are systemic; they're isolated arithmetic/sign slips.

---

## Category A — wrong answer, but the CORRECT value is already one of the options
*(Fix = change `correct_answer` to the existing correct option.)*

| Form · Topic | Question | Marked | Correct |
|---|---|---|---|
| F1 · area | Rectangle 20×12 with two quarter-circles r=6 removed (π=3.14) | `103.44` | **`183.48`** (240 − 56.52) |
| F2 · rotation | Rotate (2,3) by 270° anticlockwise about O | `(-3,2)` | **`(3,-2)`** (270° ACW = 90° CW) |
| F2 · volume_solids | Ball r=9 melted into cone r=6,h=18 — same volume? | `Yes` | **`No`** (sphere 972π ≠ cone 216π) |
| F2 · angle_properties_circle | Centre = 3x, inscribed = x+10; find x | `10` | **`20`** (3x = 2(x+10)) |
| F3 · binomial_expansion | (3−2x)³, coefficient of x² | `-36` | **`36`** (C(3,2)·3·(−2)² = +36) |
| F3 · binomial_expansion | (2+x)⁴, coefficient of x³ | `32` | **`8`** (C(4,3)·2¹ = 8; 32 is the x¹ coeff) |
| F4 · statistics_ii | Variance doubles when all values ×? | `2` | **`√2`** (variance scales by k²) |

## Category B — wrong answer AND the correct value is NOT among the options
*(Fix = correct one distractor to the right value, then point `correct_answer` at it.)*

| Form · Topic | Question | Marked | Correct (not currently an option) |
|---|---|---|---|
| F2 · statistics_i | Grouped mean: f=2 (mid 4.5), f=3 (mid 14.5) | `10.2` | **`10.5`** (52.5 ÷ 5) |
| F3 · approximations_errors | Rectangle 12±0.2 by 8±0.2, max absolute area error | `3.2` | **`≈4.0`** (12·0.2 + 8·0.2) |
| F3 · matrices | A=[2 1; 1 3], b=[5; 7]; find y | `1` | **`1.8`** (x=1.6, y=1.8) |
| F3 · sequences_series | GP a=3, r=½, S₄ | `4.875` | **`5.625`** (3+1.5+0.75+0.375) |
| F3 · vectors_ii | AP:PB = 3:1, A(2,6), P(5,3); find B | `(6,1)` | **`(6,2)`** (B = P + ⅓·AP) |
| F4 · trigonometry_iii | sin 2x = 0, 0 ≤ x ≤ 180°, number of solutions | `4` | **`3`** (x = 0, 90, 180) |

## Category C — rendering / calibration (not wrong answers)

| Form · Topic | Issue | Note |
|---|---|---|
| F1 · scale_drawing | A **distractor** option is `$\frac{1}{3}$` with a single backslash | Renders as a control char (KaTeX). It's a wrong option anyway, so grading is unaffected, but it looks broken. Change to `$\\frac{1}{3}$`. (Slipped all guards because `\f` is a valid JSON escape.) |
| F3 · trigonometry_ii | Two sides 8, 5, included 150° → side c marked `12.4` | Cosine rule gives ≈`12.58` (≈12.6). `12.4` is the closest option, so it's a minor calibration slip, not broken. |

---

## Patterns worth noting
- **`binomial_expansion` (F3)** had two of the errors (both coefficient slips) — worth a careful re-check of that topic.
- The **63-question expanded topics** (statistics_i, angle_properties_circle, and several F3 topics) carry a slightly higher error density than the standard 21-question topics.
- The **slice `integers` topic** still contains 50 question inserts that are 25 questions duplicated (the DB correctly holds 25 unique). Cosmetic in the file.

## Recommended fix
A single small migration (or a Cursor pass) that updates the `correct_answer` for the Category-A rows, and updates one option + the answer for each Category-B row, plus the `scale_drawing` backslash. ~14 targeted `UPDATE`/re-insert statements. After fixing, extend the guard test to (a) flag JSONB strings whose decoded value contains control chars (catches the `\f` under-escape class), and consider a spot-check that flags answers not present in options after JSON decode (already covered) — these were all answer-value errors, which only a human/AI read catches.
