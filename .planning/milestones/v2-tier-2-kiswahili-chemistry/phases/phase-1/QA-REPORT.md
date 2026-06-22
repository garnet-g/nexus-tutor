# QA Report — Phase 1

**Milestone:** v2-tier-2-kiswahili-chemistry  
**Phase:** 1  
**Date:** 2026-06-22  
**Verdict:** PASS

## Commands run

| Command | Exit code | Notes |
|---------|-----------|-------|
| `npm run lint` | 0 | Clean |
| `npm run typecheck` | 0 | Clean |
| `npm test` | 0 | 218 tests passed |
| `npm run test:scope-check` | 0 | kiswahili unbanned; 4 new seeds scanned |
| `npm run build` | 0 | Build succeeded |

## Criteria verification

| Criterion | Expected | Actual | Pass |
|-----------|----------|--------|------|
| Subject migration | Kiswahili CBC+KCSE, Chemistry KCSE | `20260622090000_add_kiswahili_chemistry_subjects.sql` | yes |
| Kiswahili skeleton | 17 topics (5 CBC + 12 KCSE) | `curriculum_kiswahili.sql` | yes |
| Chemistry skeleton | 22 KCSE topics | `curriculum_chemistry.sql` | yes |
| Math KCSE fill-out | Official §3 topics; deprecate 4 generics | 65 new topics; UPDATE deprecates algebra/geometry/trigonometry/statistics | yes |
| English KCSE fill-out | §5 topics; set-text placeholders | 28 new topics; placeholder titles on set-text codes | yes |
| Existing seeds untouched | No edits to curriculum_math/science/english.sql | Verified via git diff | yes |
| config.toml order | Per KCSE-SYLLABUS §2 | math_kcse after math; english_kcse after english | yes |
| Skeleton only | No lessons/questions in new seeds | Grep: no lesson inserts | yes |

## Owner sign-off applied

- Set-text titles: `(placeholder for current texts)`
- Math: generic placeholders deprecated; fractions retained
- Subtopics: from docs (Math/English) or KNEC/KICD derivation (Chemistry/Kiswahili)

## Note

Math deprecation uses `UPDATE ... SET is_active = false` because placeholders pre-exist in `curriculum_math.sql` (cannot INSERT fresh rows with `is_active=false` without conflicting upsert semantics). Idempotent on re-seed.

## Verdict rationale

All Phase 1 allowlist files present. Scope-check passes. CI green. Existing seed files unchanged.
