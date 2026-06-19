---
milestone: v2-tier-1
phase: 2.4
agent: coder
status: READY_FOR_QA
---

# CODER-CHANGELOG — Phase 2.4 Science + English

## Summary

Activated Science and English in Learn with seeded CBC/KCSE curriculum (3 topics × 3 lessons × 21 practice questions per subject). Nex now tutors all three Tier 1 subjects with subject-aware curriculum context.

## Deliverables

- Content manifests: `science-content-manifest.md`, `english-content-manifest.md`
- Migration `20250615150000_science_english_subjects.sql`
- Seeds: `curriculum_science.sql`, `curriculum_english.sql` via extended `generate-curriculum-seed.mjs`
- `contentModel.ts` — Tier 1 subject codes + grade visibility helpers
- Multi-subject Learn UI with `LearnSubjectExplorer` subject switcher
- `loadCurriculumContext` — subject join + lesson block extraction
- Nex prompt scope: mathematics, science, english; English ghostwriting guard
- Per-subject health scores on Progress after first practice
- Mock exam optional `subjectCode` filter (math default)
- Scope-check bans Kiswahili/Cambridge in subject seeds
- `tests/curriculumService.test.ts`

## Criteria

V2-CONTENT-01 through V2-CONTENT-08 addressed.
