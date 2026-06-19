# Phase 3 — Account Customization (Sprint 3)

## Criteria
- UX-PREF-01: student_profiles stores learning preferences (JSONB or columns)
- UX-PREF-02: ProfileForm exposes depth, goal minutes, reminder channel, tone
- UX-PREF-03: Preferences persist and rehydrate on profile load
- UX-PREF-04: Nex chat request includes preference metadata (no engine fork)
- UX-PREF-05: Unit tests for preference schema and persistence mapping
- UX-TEST-01: e2e/form-reliability.spec.ts or extended discovery tests

## Allowlist
- supabase/migrations/*_student_preferences.sql
- src/schemas/profileSchemas.ts (new or extend)
- src/features/profile/components/ProfileForm.tsx
- src/app/(student)/profile/page.tsx
- src/server/services/authService.ts
- src/server/actions/profileActions.ts (new if needed)
- src/features/nex/components/NexChatPanel.tsx
- src/app/api/nex/chat/route.ts
- src/lib/nex/assemblePrompt.ts (preference hints only, minimal)
- tests/profilePreferences.test.ts
- e2e/form-reliability.spec.ts
