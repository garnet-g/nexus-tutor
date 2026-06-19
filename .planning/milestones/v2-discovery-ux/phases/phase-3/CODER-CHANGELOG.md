# Phase 3 — Coder Changelog

**Milestone:** v2-discovery-ux  
**Phase:** 3 — Account Customization (Track C)  
**Date:** 2026-06-16

## Summary

Shipped student learning preferences end-to-end: JSONB storage on `student_profiles`, validated schema + DB mapping, mobile-first `ProfileForm` with reliability primitives, session rehydration via `authService`, and Nex chat preference hints through the existing `generateNexResponse` pipeline (no Socratic fork). Also expanded `e2e/form-reliability.spec.ts` with authenticated ProfileForm learning preferences end-to-end coverage (pending submit + validation/rehydration). Fixed the pending-state E2E stall by intercepting Next server-action requests instead of Supabase REST calls.

## Criteria

| ID | Status | Notes |
|----|--------|-------|
| UX-PREF-01 | ✅ | `learning_preferences` JSONB column + CHECK constraint |
| UX-PREF-02 | ✅ | ProfileForm: depth, goal minutes, reminder channel, tone |
| UX-PREF-03 | ✅ | `updateProfileAction` persists; `getSessionUser` loads via `select("*")` |
| UX-PREF-04 | ✅ | NexChatPanel sends metadata; route reads DB; `assemblePrompt` hints |
| UX-PREF-05 | ✅ | `tests/profilePreferences.test.ts` |
| UX-TEST-01 | ✅ | `e2e/form-reliability.spec.ts` (teacher waitlist + authenticated profile preferences) |

## Files changed

### New
- `supabase/migrations/20250616130000_student_preferences.sql`
- `tests/profilePreferences.test.ts`
- `e2e/form-reliability.spec.ts`

### Modified
- `src/schemas/profileSchemas.ts` — learning preference schemas, DB parse/map, hint builder
- `src/schemas/nexSchemas.ts` — optional `learningPreferences` on chat request
- `src/types/database.ts` — `learning_preferences` on `StudentProfile`
- `src/server/actions/profileActions.ts` — persist preferences with field errors
- `src/server/services/authService.ts` — default preferences on student create
- `src/features/profile/components/ProfileForm.tsx` — preferences UI + FieldError/FormStatus/AsyncActionButton
- `src/features/nex/components/NexChatPanel.tsx` — POST metadata
- `src/app/api/nex/chat/route.ts` — load preferences from profile, pass to pipeline
- `src/lib/nex/assemblePrompt.ts` — `learningPreferenceHints` section
- `src/lib/nex/generateNexResponse.ts` — pass hints without forking engine
- `src/app/(student)/nex/page.tsx` — pass preferences to NexChatPanel
- `src/app/(student)/assignment-help/page.tsx` — pass preferences to NexChatPanel

## Design decisions

1. **JSONB over columns** — single `learning_preferences` object matches UX spec C2; CHECK constraint enforces shape at DB level.
2. **Server is source of truth** — chat route reads `student_profiles.learning_preferences`; client metadata is supplementary.
3. **Hints in assemblePrompt only** — brief overlay text; `generateNexResponse` and Socratic engine unchanged.
4. **RLS unchanged** — existing `student_profiles_update_own` policy covers preference updates.

## Verification

```bash
npm run lint
npm run typecheck
npm test
npm run test:scope-check
npm run build
npm run test:e2e -- e2e/form-reliability.spec.ts
```
