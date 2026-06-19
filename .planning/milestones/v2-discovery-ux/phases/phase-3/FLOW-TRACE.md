# Phase 3 FLOW-TRACE — Learning Preferences

## Goal
Verify that learning preferences are wired end-to-end:
UI -> ProfileForm -> Server action -> Supabase row -> Rehydration -> Nex hinting.

## Flow trace matrix

| FlowID | UI entry | UI Component | API/Action | Handler/Service | DB tables | Expected outcome |
|--------|-----------|--------------|-------------|------------------|-----------|-------------------|
| PREF-01 | `/profile` | ProfileForm (preferences section) | Server action `updateProfileAction` | `src/server/actions/profileActions.ts` -> `learningPreferencesToDb()` | `student_profiles` | Invalid sessionGoalMinutes shows field error and aria-describedby wiring. |
| PREF-02 | `/profile` | ProfileForm | Server action `updateProfileAction` | `updateProfileAction` | `student_profiles` | Valid preferences persist and inputs rehydrate on reload. |
| PREF-03 | `/nex` and `/assignment-help` | NexChatPanel | `POST /api/nex/chat` | `src/app/api/nex/chat/route.ts` + `assemblePrompt` | `student_profiles` | Nex system prompt includes brief learning preference hints; no Socratic engine fork. |
| PREF-04 | `/nex` | NexChatPanel | same | same | `student_profiles` | Preferences don’t break existing Nex modes (Explain/Practice/Homework/Revision/Assessment). |
| PREF-05 | `/profile` | ProfileForm submit | same | same | `student_profiles` | AsyncActionButton disables while server action pending; pending behavior covered by e2e (skips if E2E creds absent). |
| SEC-01 | any | ProfileForm | same | RLS enforced in DB | `student_profiles` | Student can only update their own row (RLS assumed via existing update policy). |

## Regression checks
- Teacher waitlist reliability remains intact (public `/waitlist/teacher`).
- Scope-check stays green.
- Unit tests for preference schema mapping pass: `tests/profilePreferences.test.ts`.

## Verdict
PASS when Phase 3 coder changes + QA suite pass.

