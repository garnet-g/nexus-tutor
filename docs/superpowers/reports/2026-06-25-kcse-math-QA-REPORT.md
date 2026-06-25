# KCSE Math Content Slice — QA Report (Phase D)

- **Date:** 2026-06-25
- **Branch:** `feat/kcse-math-content-slice`
- **QA agent:** Independent verification (did not author implementation)
- **Authority:** `docs/superpowers/specs/2026-06-25-kcse-math-content-slice-design.md`, `docs/superpowers/plans/2026-06-25-kcse-math-content-slice.md`, `docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md`

---

## 0. AUDIT CORRECTION (added 2026-06-25, post-QA, by orchestrator audit)

> The original Phase-D QA below was run against a **corrupted seed file** and so reported
> several wrong figures. This section supersedes the original where they conflict. Two real
> defects were found and **fixed**; the rest of the implementation is sound.

### Defects found and fixed after QA

1. **Seed file encoding corruption (BLOCKER) — fixed in `64a0811`.**
   `supabase/seed/curriculum_math_kcse_content.sql` was a mix of UTF-16LE and UTF-8 with
   **27,698 NUL bytes** (would fail `psql`/`db reset`) plus **4 em-dashes** mangled into
   `U+FFFD`+control-char sequences (broke 2 lesson JSON casts). Because Docker was down, the
   live load never ran, so this slipped past QA. **Also why QA's counts were wrong:** QA grepped
   the corrupted file, whose UTF-16 regions don't match an ASCII `INSERT` pattern, so it
   **undercounted**. Fixed: normalized to clean UTF-8 (0 NUL, valid UTF-8), em-dashes restored.

2. **LaTeX escaping over-correction (rendering defect) — fixed in `0a08d4f`.**
   Commit `7759e38` doubled backslashes in **all** practice-question fields. That is correct for
   the **JSONB** fields (`options`, `correct_answer`) but **wrong** for the **plain SQL string**
   fields (`question_text`, `explanation`), where KaTeX needs a single `\frac`. 48 non-JSONB
   strings were de-doubled so practice math renders.

### Corrected counts (verified against the repaired file)

| Topic | Lessons | All subtopics covered | Questions (E/M/H) | PROD_READY (static) |
| --- | ---: | --- | --- | --- |
| `integers` | 10 | ✅ 4/4 | 16 / 16 / 18 = 50 | ✅ |
| `algebraic_expressions` | 5 | ✅ 3/3 | 8 / 9 / 8 = 25 | ✅ |
| `rates_ratio_proportion` | 5 | ✅ 4/4 | 9 / 9 / 7 = 25 | ✅ |
| **Total** | **20** | — | **100** | — |

(Original QA reported 15 lessons / 75 questions — an artifact of the corruption.)

### Independent verification added
- All **20 lessons validate against the real `lessonContentSchema`** (new permanent guard:
  `tests/content/kcseMathSeedContent.test.ts`).
- All **100 questions** parse; every `correct_answer` matches one of its 4 options.
- Both added subtopics (`integer_applications`, `percentage_applications`) are inserted before
  the lessons that reference them; all other referenced subtopics exist in the skeleton seed.
- Full suite: **384 tests pass**.

### Corrected verdict

**Static / code: PASS.** All three topics meet the `PROD_READY` bar; renderer wiring complete;
escaping correct per-field; seed is clean, idempotent-by-construction, schema-valid.
**Live verification (Task 10 DB load + Task 11 visual/English-regression): STILL PENDING** —
requires Docker, which is unavailable. This is the only outstanding item before a full
production sign-off.

---

## 1. What was done

| Check | Method | Result |
| --- | --- | --- |
| Full test suite | `npm test` (Vitest) | **PASS** — 81 files, 382 tests |
| `db:reset` × 2 (idempotency) | `npm run db:reset` | **BLOCKED** — Docker Desktop not running (`dockerDesktopLinuxEngine` pipe missing) |
| Task 10 SQL queries | Live DB | **BLOCKED** — same Docker dependency |
| Seed static analysis | Python regex over `curriculum_math_kcse_content.sql` | **DONE** — counts, LaTeX scan, structure review |
| File existence | Glob + grep | **PASS** — all expected artifacts present |
| Soft-retire scope | Read seed header | **PASS** — scoped to `c.code='KCSE' AND s.code='mathematics'` |
| `basic_factorisation` omission | Grep seed | **PASS** — not present; authored within existing subtopics |
| Visual / English regression (Task 11) | Preview walkthrough | **NOT RUN** — no local app + DB session in this QA pass |

### Commits reviewed on branch

```
6a8c3b4 feat(content): add shared MathText markdown+KaTeX renderer
7681cf4 feat(learn): render math in paragraph/example/tip/callout/inline-question
1062d6a feat(practice): render math in question text and options
532981d feat(mock-exams): render math in question text and options
0d8da98 feat(seed): scaffold KCSE math content seed; soft-retire legacy topics
997b85b feat(content): author KCSE Form 1 Integers lessons and practice
01029c3 feat(content): author KCSE Form 1 Algebraic Expressions lessons and practice
5fb4abe feat(content): author KCSE Form 1 Rates, Ratio & Proportion lessons and practice
2124edc test(curriculum): encode KCSE math slice readiness bar
```

### Files verified

| Artifact | Status |
| --- | --- |
| `src/components/content/MathText.tsx` | Present; matches plan (remark-gfm + remark-math + rehype-katex, inline/block variants) |
| `tests/content/mathText.test.tsx` | Present; LaTeX + plain-text tests |
| `tests/curriculum/kcseMathSliceReadiness.test.ts` | Present; pure-function readiness bar only |
| `supabase/seed/curriculum_math_kcse_content.sql` | Present; 15 lesson inserts, 75 practice inserts, 90 `NOT EXISTS` guards |
| `supabase/config.toml` wiring | Present; `./seed/curriculum_math_kcse_content.sql` immediately after `curriculum_math_kcse.sql` |
| `LessonContentBlocks.tsx` | `MathText` routed for paragraph, example steps/answer, tip, callout, inline question |
| `PracticeRunner.tsx` | `MathText` on question text + options |
| `ExamSimulatorShell.tsx` | `MathText` on question text + options |

---

## 2. Per-topic counts (static seed analysis)

> **Note:** Live Task 10 SQL was not executed. Counts below are from parsing `curriculum_math_kcse_content.sql`. Totals meet plan thresholds; DB confirmation pending Docker.

### Lessons per subtopic

**`integers` (5 lessons total)**

| Subtopic | Lessons |
| --- | ---: |
| `number_line_integers` | 1 |
| `operations_integers` | 2 |
| `order_of_operations` | 1 |
| `integer_applications` | 1 |

**`algebraic_expressions` (5 lessons total)**

| Subtopic | Lessons |
| --- | ---: |
| `forming_expressions` | 2 |
| `simplification` | 2 |
| `substitution` | 1 |

**`rates_ratio_proportion` (5 lessons total)**

| Subtopic | Lessons |
| --- | ---: |
| `rates` | 1 |
| `ratio_proportion` | 2 |
| `percentage` | 1 |
| `percentage_applications` | 1 |

### Practice questions per difficulty band

| Topic | easy | medium | hard | Total |
| --- | ---: | ---: | ---: | ---: |
| `integers` | 8 | 8 | 8 | 24 |
| `algebraic_expressions` | 8 | 9 | 8 | 25 |
| `rates_ratio_proportion` | 9 | 9 | 8 | 26 |

All bands ≥ 7 per topic. All subtopics have ≥ 1 lesson. Each topic has ≥ 3 lessons total.

### Added vs omitted subtopics

| Code | Status |
| --- | --- |
| `integer_applications` | **Added** |
| `percentage_applications` | **Added** |
| `basic_factorisation` | **Omitted** (per CONTENT-GUIDE §5 — KNEC Form 1 uncertainty) |

---

## 3. What is broken or regressed

| Issue | Severity | Evidence |
| --- | --- | --- |
| `npm run db:reset` fails | **Blocker for seed sign-off** | Docker Desktop unavailable in QA environment |
| LaTeX escaping in 2 practice questions | **Medium** | Single-backslash `\frac` in question text (see §5) |
| No integration test tying seed → `PROD_READY` | **Low** | Readiness test uses synthetic counts, not DB or seed-derived fixtures |
| English content visual regression | **Unverified** | Task 11 not executed |

**Not broken:** `npm test` full suite passes (382/382). No test failures observed.

---

## 4. What was done incorrectly or incompletely

### LaTeX escaping defects

Two practice questions use **single** backslash `\frac` in SQL string literals (should be `\\frac` per CONTENT-GUIDE §3):

1. `Simplify $\frac{6x}{2} + 4x$.` — `algebraic_expressions` / `simplification` (hard)
2. `$\frac{3}{4}$ as a percentage?` — `rates_ratio_proportion` / `percentage` (easy)

These will likely render as literal `\frac` in the UI after seed load, not as fractions.

Additional practice questions use single-backslash `\times`, `\div`, `\text`, `\circ` in question strings (e.g. `Evaluate $(-4) \times 3$.`). Lesson JSON bodies generally use correct doubled backslashes (`\\frac`, `\\times`). Practice-question escaping is inconsistent.

### Content depth vs comprehensive bar

Static quality sample (gold-standard exemplar + grep):

- **Strengths:** Kenyan contexts (KES, temperature, trader scenarios); worked `example` blocks in all 15 lessons; `callout` warnings (9); inline `question` self-checks; mistake-based distractors in sampled questions; correct doubled backslashes in lesson JSON (e.g. `Integers on the Number Line`).
- **Gaps vs CONTENT-GUIDE §2/§6:**
  - `shortQuiz` present in **1 of 15** lessons only (exemplar lesson). Guide recommends ending lessons with shortQuiz and/or inline questions — most lessons rely on inline `question` only.
  - Several subtopics have only **1 lesson** (`substitution`, `order_of_operations`, `rates`, `percentage`, both application subtopics). Meets numeric floor (≥3/topic, ≥1/subtopic) but below the pedagogical target of concept → methods → application as separate lessons per subtopic.
  - `math_block` used in only 3 lessons (sparse vs guide recommendation for key formulas).

### Readiness test scope

`tests/curriculum/kcseMathSliceReadiness.test.ts` encodes the **function contract** with `subtopicCount: 3`, but slice topics have **3–4 subtopics** each. It does not assert the three topic codes reach `PROD_READY` from real or fixture-derived counts. Plan Task 9 Step 1 matches implementation, but Definition of Done item “3 slice topics … `PROD_READY`” is not automatically enforced by CI.

### `curriculum_math.sql` ON CONFLICT safety

Confirmed: topic `ON CONFLICT (subject_id, code) DO UPDATE` sets only `min_grade_sort_order`, `sort_order`, `title`, `description` — **does not touch `is_active`**. Soft-retire should survive `db reset` once Docker is available.

---

## 5. Skipped / deferred and why

| Item | Reason |
| --- | --- |
| `db:reset` × 2 + idempotency | Docker Desktop not running |
| Task 10 SQL queries (legacy `is_active`, live counts) | No Supabase Postgres instance |
| Task 11 visual walkthrough (math lesson, practice, English regression) | Requires running app + seeded DB; not attempted without Docker |
| Live `PROD_READY` label check per topic | Depends on DB queries or seed integration test |

---

## 6. Sign-off

### Verdict: **FAIL**

Phase D **code and static content structure** are largely complete and tests pass, but the slice **cannot be signed off for production** until blockers below are cleared.

### Required follow-ups (in order)

1. **Start Docker Desktop** and run `npm run db:reset` twice — confirm zero SQL errors and identical row counts on second run.
2. **Run Task 10 SQL** — confirm legacy topics `is_active = false` and static counts match DB.
3. **Fix LaTeX escaping** in the two `\frac` practice questions (and audit remaining single-backslash `\times`/`\text`/`\circ` in practice strings).
4. **Task 11 preview** — math lesson fraction rendering, practice session math, English lesson + practice regression.
5. **(Recommended)** Add seed-derived or DB integration test asserting `getTopicReadinessLabel` → `PROD_READY` for all three topic codes with actual subtopic counts (4, 3, 4).
6. **(Recommended)** Add `shortQuiz` to more lessons or document conscious omission; deepen single-lesson subtopics toward concept/methods/application split.

### Definition of Done checklist

| Criterion | Status |
| --- | --- |
| `MathText` exists, tested; routed in lessons, practice, mock exams | **PASS** |
| English content visually unchanged | **NOT VERIFIED** |
| 3 topics: ≥3 lessons, every subtopic, ≥7/band, `PROD_READY` | **STATIC PASS** / **DB UNVERIFIED** |
| Legacy KCSE topics soft-retired; no DELETE/rename; CBC untouched | **PASS** (static) |
| Seed idempotent; `config.toml` updated; `db:reset` clean | **NOT VERIFIED** |
| LaTeX correctly escaped; renders as symbols | **PARTIAL FAIL** (2+ questions) |
| `npm test` passes | **PASS** |

---

*QA performed independently on branch `feat/kcse-math-content-slice`.*
