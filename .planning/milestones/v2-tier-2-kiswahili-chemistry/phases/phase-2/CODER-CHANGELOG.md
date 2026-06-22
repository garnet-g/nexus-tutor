---
milestone: v2-tier-2-kiswahili-chemistry
phase: 2
agent: coder
version: 1
status: COMPLETE
---

# Coder Changelog — Phase 2

## Criteria addressed

| ID | Status | Notes |
|----|--------|-------|
| Generation scope allow-list | done | `assertSubjectInGenerationScope` uses `ACTIVE_SUBJECT_CODES` |
| Subject-aware prompts | done | Lesson + question prompts keyed on subjectCode/subjectName |
| Multi-subject admin read | done | `getSubjectContentCoverage`, `getActiveSubjectsContentCoverage` |
| Coverage route | done | `?subject=` and `?all=true` query params; default math backward compat |
| Unit tests | done | `tests/contentGenerationScope.test.ts` |

## Files touched

| File | Change |
|------|--------|
| `src/server/services/contentGenerationService.ts` | Scope + prompts |
| `src/server/services/contentAdminReadService.ts` | Multi-subject coverage |
| `src/app/api/admin/content/coverage/route.ts` | Optional subject/all params |
| `tests/contentGenerationScope.test.ts` | New scope + prompt tests |

## Deviations from plan

- None
