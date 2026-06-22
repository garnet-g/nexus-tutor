---
milestone: v2-tier-2-kiswahili-chemistry
phase: 1
agent: coder
version: 1
status: COMPLETE
inputs:
  - IMPLEMENTATION-PLAN.md
  - KCSE-SYLLABUS-SKELETON-MATH-ENGLISH.md
outputs:
  - supabase/migrations/20260622090000_add_kiswahili_chemistry_subjects.sql
  - supabase/seed/curriculum_kiswahili.sql
  - supabase/seed/curriculum_chemistry.sql
  - supabase/seed/curriculum_math_kcse.sql
  - supabase/seed/curriculum_english_kcse.sql
  - supabase/config.toml
  - scripts/scope-check.ts
---

# Coder Changelog — Phase 1

## Criteria addressed

| ID | Status | Notes |
|----|--------|-------|
| P1-1 | done | Migration adds `kiswahili` (CBC+KCSE) and `chemistry` (KCSE) subjects |
| P1-2 | done | `curriculum_kiswahili.sql` — CBC 5 + KCSE 12 topics, 51 subtopics |
| P1-3 | done | `curriculum_chemistry.sql` — 22 KCSE topics, 66 subtopics |
| P1-4 | done | `curriculum_math_kcse.sql` — 65 new KCSE topics, 195 subtopics; deprecates 4 placeholders |
| P1-5 | done | `curriculum_english_kcse.sql` — 28 new KCSE topics, 84 subtopics; set-text placeholders |
| P1-6 | done | `config.toml` sql_paths order per KCSE-SYLLABUS §2 |
| P1-7 | done | `scope-check.ts` — removed `kiswahili` ban; added 4 new seed paths |
| P1-8 | done | Skeleton only — no lessons or questions in new seed files |

## Files touched

| File | Change |
|------|--------|
| `supabase/migrations/20260622090000_add_kiswahili_chemistry_subjects.sql` | New — additive subject INSERTs |
| `supabase/seed/curriculum_kiswahili.sql` | New — CBC + KCSE topic/subtopic skeleton |
| `supabase/seed/curriculum_chemistry.sql` | New — KCSE Chemistry skeleton |
| `supabase/seed/curriculum_math_kcse.sql` | New — full KCSE Math skeleton + deprecation UPDATE |
| `supabase/seed/curriculum_english_kcse.sql` | New — full KCSE English skeleton |
| `supabase/config.toml` | Updated `[db.seed] sql_paths` |
| `scripts/scope-check.ts` | Unbanned kiswahili; extended seedPaths |

## Topic counts (new seed files only)

| Subject | Curriculum | Topics | Subtopics |
|---------|------------|--------|-----------|
| Chemistry | KCSE | 22 | 66 |
| Kiswahili | CBC | 5 | 15 |
| Kiswahili | KCSE | 12 | 36 |
| Kiswahili | **Total** | **17** | **51** |
| Mathematics | KCSE (new) | 65 | 195 |
| English | KCSE (new) | 28 | 84 |

**Math deprecation:** `algebra`, `geometry`, `trigonometry`, `statistics` set `is_active=false` via UPDATE at end of `curriculum_math_kcse.sql`. `fractions` unchanged and stays active.

**English set-text titles:** `the_novel_set_text`, `the_play_set_text`, `short_stories_set_text` use title `(placeholder for current texts)` per owner sign-off B.

**Skipped (no duplicate):** Math `fractions`; English `reading_comprehension`, `grammar`, `writing_skills` — remain in existing seed files.

## Migrations

| Migration | Purpose |
|-----------|---------|
| `20260622090000_add_kiswahili_chemistry_subjects.sql` | Activate Kiswahili (CBC+KCSE) and Chemistry (KCSE) subject rows |

## Deviations from plan

- **Math deprecation mechanism:** Owner sign-off C referenced `ON CONFLICT DO UPDATE SET is_active=false`, but existing placeholder topics live in `curriculum_math.sql` and cannot be deactivated via INSERT upsert. Used an additive `UPDATE ... SET is_active = false` block at end of `curriculum_math_kcse.sql` instead (same outcome, idempotent on re-seed).
- **Chemistry/Kiswahili subtopics:** Derived from standard KNEC/KICD syllabus strands where IMPLEMENTATION-PLAN §4 listed topics only (≥3 subtopics per topic).

## Follow-ups for QA

- Run `supabase db reset` and verify row counts: KCSE math has 5 existing + 65 new topics (4 deprecated active=false); KCSE english has 3 existing + 28 new; chemistry KCSE-only; kiswahili CBC+KCSE.
- Confirm `npm run test:scope-check` passes (verified locally).
- Confirm existing `curriculum_math.sql`, `curriculum_science.sql`, `curriculum_english.sql` are byte-unchanged.
- Confirm no lessons/questions in new skeleton files.
