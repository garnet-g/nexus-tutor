---
milestone: v2-tier-1
phase: null
agent: planner
version: 1
status: DRAFT
supersedes: null
inputs:
  - .planning/milestones/v2-tier-1/ARCHITECT-BRIEF.md
  - docs/product-governance/mvp-feature-scope-lock.md
  - docs/phase-5-engineering-governance/coding-agent-rules.md
outputs:
  - .planning/milestones/v2-tier-1/PHASE-PLAN.md
---

# PHASE-PLAN — V2 Tier 1 (High-Engagement PRD Features)

**Architect input:** [ARCHITECT-BRIEF.md](./ARCHITECT-BRIEF.md)  
**Scope authority:** [mvp-feature-scope-lock.md §4 Tier 1](../../docs/product-governance/mvp-feature-scope-lock.md#4-v2-backlog-)  
**Overall verdict:** `APPROVED_TO_BUILD` (Phase 0 only; Phases 2.1–2.5 `PENDING`)

## Milestone exit criteria

- [ ] Phase 0 PASS — V1 beta hardening complete; FEASIBILITY-UAT signed off; CI includes e2e
- [ ] Phase 2.1 PASS — Nex Assessment Mode live in-chat; misconceptions persist and feed Nex memory
- [ ] Phase 2.2 PASS — Ask Nex with Camera in Homework + Explain; vision → Nex pipeline
- [ ] Phase 2.3 PASS — AI Mock Exams + Exam Simulator with timer, marking, and analysis
- [ ] Phase 2.4 PASS — Science + English active content in Learn; Nex tutors all three subjects
- [ ] Phase 2.5 PASS — Push-to-talk Voice Tutor through existing Nex pipeline
- [ ] `npm run test:scope-check` passes with V2 routes allowlisted per active phase
- [ ] No Nex teaching feature bypasses `generateNexResponse` pipeline
- [ ] No hardcoded 799/2499 in API handlers; premium gates use `getEffectiveSubscriptionConfig()`

---

## Phase 0 — Beta Hardening (V1 Launch Gate)

**Status:** `APPROVED_TO_BUILD`  
**Depends on:** V1 Private Beta build (waves 0–10 complete)

### Goal

Close remaining V1 acceptance gaps so private beta can ship: UAT sign-off, streak badge, expanded Playwright coverage, and e2e in CI.

### Criterion IDs

| ID | Description |
|----|-------------|
| BETA-UAT-01 | `.planning/FEASIBILITY-UAT.md` go/no-go checklist fully checked; sign-off table completed |
| BETA-UAT-02 | All five student personas + two parent flows pass on staging |
| BETA-E2E-01 | Playwright suite covers public pages + mobile overflow (existing smoke retained) |
| BETA-E2E-02 | Playwright suite adds authenticated student smoke (login → onboarding redirect or dashboard gate) |
| BETA-E2E-03 | GitHub Actions CI job runs `npm run test:e2e` with `PLAYWRIGHT_BASE_URL` against built app |
| BETA-GAME-01 | `seven_day_streak` badge upserted to `student_badges` when `current_streak` reaches 7 |
| BETA-GAME-02 | Progress page shows ≥3 achievable badges: `first_diagnostic_complete`, `first_practice_complete`, `seven_day_streak` |
| BETA-GAME-03 | Streak increment uses Africa/Nairobi date boundary (existing logic preserved) |
| BETA-CI-01 | CI pipeline: lint → typecheck → test → scope-check → build → e2e (fail on any step) |

### Tasks

1. Walk `.planning/FEASIBILITY-UAT.md` against staging; record pass/fail per checklist row; complete sign-off table.
2. Fix any P0/P1 defects discovered during UAT (scope: auth, diagnostic gate, Nex limits, RLS only — no V2 features).
3. In `practiceService.updateStudentStreak`, upsert `student_badges` with `badge_code: "seven_day_streak"` when `currentStreak === 7` (mirror `first_practice_complete` pattern); keep existing Celcom SMS notification.
4. Add unit test asserting streak-day-7 awards badge idempotently (`onConflict: student_id,badge_code`).
5. Extend `e2e/smoke.spec.ts` or add `e2e/student-gate.spec.ts`: authenticated fixture signs in test student, asserts incomplete-onboarding redirect or dashboard diagnostic gate.
6. Add Playwright auth fixture (`e2e/fixtures/auth.ts`) using env `E2E_STUDENT_EMAIL` / `E2E_STUDENT_PASSWORD` (document in `docs/LOCAL-DEV.md`; no secrets in repo).
7. Update `.github/workflows/ci.yml`: install Playwright browsers, `npm run build`, start `next start` on port 3000, run `npm run test:e2e` with `CI=true`.
8. Update `playwright.config.ts` webServer for CI: `npm run start` after build when `process.env.CI`.
9. Add `npm run test:e2e:ci` script in `package.json` wrapping build + start + playwright for local parity.
10. Verify `npm run deploy:check` still passes; document e2e prereqs in `docs/LOCAL-DEV.md`.

### File allowlist

```
.planning/FEASIBILITY-UAT.md
.github/workflows/ci.yml
e2e/**
playwright.config.ts
package.json
package-lock.json
docs/LOCAL-DEV.md
src/server/services/practiceService.ts
src/server/services/diagnosticService.ts
src/app/(student)/progress/page.tsx
tests/streakBadge.test.ts
```

### Out of scope

- Any V2 feature routes (`/api/nex/camera`, assessment mode UI, mock exams, voice)
- New Supabase migrations (badge table already exists)
- Full persona E2E automation (UAT remains manual for payment/M-Pesa flows)
- Staging environment provisioning (assume exists per `docs/DEPLOYMENT.md`)
- Product scope lock amendments

### Verification

```bash
npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build
npm run test:e2e:ci
```

Manual: execute FEASIBILITY-UAT personas 1–5 + parent flows A–B on staging; confirm BETA-UAT-01/02.

### Planner verdict

`APPROVED_TO_BUILD`

---

## Phase 2.1 — Assessment Mode + Misconception Persistence

**Status:** `PENDING`  
**Depends on:** Phase 0 PASS (QA-REPORT)

### Goal

Expose Nex Assessment Mode in-chat with a session state machine, golden-test coverage, and durable misconception persistence that feeds `loadStudentMemory`.

### Criterion IDs

| ID | Description |
|----|-------------|
| V2-ASSESS-01 | `detectNexMode` returns `assessment` for patterns in `nex-ai-specification.md` §10 |
| V2-ASSESS-02 | `NexChatPanel` includes Assessment mode; `NexMode` / `NexSessionMode` types extended |
| V2-ASSESS-03 | `nex_sessions.metadata` tracks assessment state: `questionIndex`, `correctCount`, `assessmentStatus` (`in_progress` \| `completed`) |
| V2-ASSESS-04 | Assessment responses assembled via `assemblePrompt` + assessment mode prompt from `nex-prompting-framework.md` §7 |
| V2-ASSESS-05 | `generateNexResponse` + `validateNexResponse` handle assessment mode (no full answer before attempt) |
| V2-ASSESS-06 | ≥3 golden conversation fixtures under `tests/nex/golden-conversations/assessment-*.json` pass |
| V2-ASSESS-07 | Assessment completion updates `topic_mastery` with assessment-weighted signal per `mastery-tracking-engine.md` |
| V2-MISC-01 | Detected misconceptions appended to `student_profiles.metadata.commonErrors[]` (deduped, max 20) |
| V2-MISC-02 | `loadStudentMemory` returns persisted `commonErrors` in Nex context block |
| V2-MISC-03 | `updateSocraticState` misconception flag triggers persistence on assessment + homework modes |
| V2-MISC-04 | Unit tests for misconception merge/dedup logic |

### Tasks

1. Extend `src/lib/nex/types.ts`: add `assessment` to `NexMode`; define `AssessmentSessionMetadata` fields merged into `NexSessionMetadata`.
2. Add `ASSESSMENT_PATTERNS` to `detectNexMode.ts`; include `assessment` in score map; export `isAssessmentRequest`.
3. Update `socraticTutorEngine.ts` with `updateAssessmentState` (question advance, scoring hints, completion).
4. Wire assessment branch in `generateNexResponse.ts` and `assemblePrompt.ts` (mode prompt §7 + misconception overlay §9).
5. Extend `validateNexResponse.ts` for assessment answer-disclosure rules.
6. Add `persistStudentMisconception(studentId, errorCode, description)` in `src/server/services/nexUsageService.ts` or new `misconceptionService.ts`; update `student_profiles.metadata`.
7. Call persistence from Nex chat route after misconception detection in assessment/homework flows.
8. Update `NexChatPanel.tsx` mode selector (5 modes); welcome copy mentions assessment.
9. Update `src/schemas/nexSchemas.ts` and `src/app/api/nex/chat/route.ts` for assessment session mode + metadata round-trip.
10. Add golden fixtures: `assessment-fractions-misconception.json`, `assessment-linear-equations.json`, `assessment-completion-summary.json`.
11. Add `tests/misconceptionPersistence.test.ts` and extend `tests/nex/goldenConversations.test.ts`.
12. Update `scripts/scope-check.ts` to allow assessment mode in UI (no banned route — uses existing `/api/nex/chat`).

### File allowlist

```
src/lib/nex/detectNexMode.ts
src/lib/nex/types.ts
src/lib/nex/socraticTutorEngine.ts
src/lib/nex/generateNexResponse.ts
src/lib/nex/assemblePrompt.ts
src/lib/nex/validateNexResponse.ts
src/lib/nex/loadStudentMemory.ts
src/features/nex/components/NexChatPanel.tsx
src/app/api/nex/chat/route.ts
src/schemas/nexSchemas.ts
src/server/services/nexUsageService.ts
src/server/services/misconceptionService.ts
tests/nex/golden-conversations/assessment-*.json
tests/nex/goldenConversations.test.ts
tests/misconceptionPersistence.test.ts
tests/detectNexMode.test.ts
scripts/scope-check.ts
```

### Out of scope

- Camera upload, voice I/O, mock exams
- Dedicated `student_misconceptions` table (V2.1 uses `metadata` JSONB per schema doc)
- Multi-subject assessment beyond mathematics
- Confidence / learning-style fields (scope lock V2 deferral)
- Changing onboarding diagnostic (remains V1 separate flow)

### Verification

```bash
npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build
npm test -- tests/nex/goldenConversations.test.ts tests/misconceptionPersistence.test.ts
```

Manual: Nex → Assessment mode → 3-question mini-assessment → verify misconception appears on next session context (server logs or debug endpoint).

### Planner verdict

`PENDING`

---

## Phase 2.2 — Camera (Homework + Explain)

**Status:** `PENDING`  
**Depends on:** Phase 2.1 PASS

### Goal

Enable Ask Nex with Camera for Homework and Explain modes: image upload to Supabase Storage, Gemini vision extraction, then standard Nex pipeline.

### Criterion IDs

| ID | Description |
|----|-------------|
| V2-CAMERA-01 | `POST /api/nex/camera` accepts authenticated multipart image (max 5MB, jpeg/png/webp) |
| V2-CAMERA-02 | Supabase Storage bucket `nex-uploads` with RLS: student owns `/{studentId}/*` |
| V2-CAMERA-03 | Vision step extracts problem text; result passed as `studentMessage` to `generateNexResponse` |
| V2-CAMERA-04 | Camera UI available only in Homework + Explain modes on `NexChatPanel` |
| V2-CAMERA-05 | Premium/trial gating per `subscription-system.md` camera row; free tier shows upgrade CTA |
| V2-CAMERA-06 | Uploaded images never exposed to other students; service role upload, signed read URL ≤1h |
| V2-CAMERA-07 | Scope-check allowlists `/api/nex/camera`; no client-side API keys |
| V2-CAMERA-08 | E2E smoke: camera button renders on Nex page (mock file input; no live vision in CI) |

### Tasks

1. Migration `supabase/migrations/*_nex_uploads_storage.sql`: bucket + RLS policies per `technical-architecture.md` §4.5.
2. Create `src/lib/nex/extractImageText.ts` — Gemini vision call with curriculum scope guard.
3. Create `src/app/api/nex/camera/route.ts` — auth, rate limit, storage upload, vision extract, invoke `generateNexResponse`.
4. Create `src/schemas/cameraSchemas.ts` — Zod validation for metadata (mode, topicId, sessionId).
5. Add `CameraCaptureButton` component; integrate into `NexChatPanel` for homework/explain only.
6. Add premium check via `getEffectiveSubscriptionConfig()` + student subscription service.
7. Update `scripts/scope-check.ts`: remove `/api/nex/camera` from banned list.
8. Update `docs/phase-1-foundation/api-standards.md` camera section (implementation note only if already stubbed).
9. Add `tests/extractImageText.test.ts` with mocked Gemini response.
10. Add e2e test: camera affordance visible when mode is homework.

### File allowlist

```
supabase/migrations/*_nex_uploads_storage.sql
src/lib/nex/extractImageText.ts
src/app/api/nex/camera/route.ts
src/schemas/cameraSchemas.ts
src/features/nex/components/CameraCaptureButton.tsx
src/features/nex/components/NexChatPanel.tsx
src/server/services/nexUsageService.ts
scripts/scope-check.ts
tests/extractImageText.test.ts
e2e/nex-camera.spec.ts
docs/phase-1-foundation/api-standards.md
```

### Out of scope

- Voice input/output
- Camera in Practice, Revision, or Assessment modes (Phase 2.1)
- OCR for handwritten non-Latin scripts
- Offline image queue
- Science/English-specific vision tuning (Phase 2.4)
- Video capture

### Verification

```bash
npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build
npm run test:e2e -- e2e/nex-camera.spec.ts
```

Manual: premium student photographs textbook problem → Nex returns Socratic homework guidance (not full answer).

### Planner verdict

`PENDING`

---

## Phase 2.3 — Mock Exams + Exam Simulator

**Status:** `PASS`  
**Depends on:** Phase 2.2 PASS

### Goal

Deliver AI Mock Exams (generated papers) and Exam Simulator (timed conditions, auto-marking, performance analysis) for mathematics, CBC + KCSE variants.

### Criterion IDs

| ID | Description |
|----|-------------|
| V2-MOCK-01 | `POST /api/mock-exams/generate` creates `mock_exam_sessions` with question set from `practice_questions` + AI generation fallback |
| V2-MOCK-02 | `POST /api/mock-exams/[id]/submit` auto-marks and stores `mock_exam_results` |
| V2-MOCK-03 | Mock exam options: KCSE-style, CBC-style, topic-specific, full math paper |
| V2-MOCK-04 | Premium gating on generate; free tier preview (≤5 questions) or CTA |
| V2-SIM-01 | `POST /api/exam-simulator/start` starts timed session with `ends_at` server clock |
| V2-SIM-02 | Exam Simulator UI: fullscreen-style timer, question navigation, submit lock at expiry |
| V2-SIM-03 | Post-exam analysis: score, weak topics, predicted grade delta |
| V2-SIM-04 | Results feed `topic_mastery` and `academic_health_scores` recalculation |
| V2-SIM-05 | RLS: students read/write own sessions only |
| V2-SIM-06 | Scope-check allowlists `/api/mock-exams/*` and `/api/exam-simulator/*` |

### Tasks

1. Migration `*_mock_exam_tables.sql`: `mock_exam_sessions`, `mock_exam_questions`, `mock_exam_results`, `exam_simulator_sessions` per `database-schema.md` patterns.
2. Create `src/lib/mockExams/mockExamEngine.ts` — question selection, difficulty mix, curriculum filter.
3. Create `src/lib/mockExams/examSimulatorEngine.ts` — timer enforcement, auto-submit on expiry.
4. API routes: `src/app/api/mock-exams/generate/route.ts`, `[id]/submit/route.ts`, `src/app/api/exam-simulator/start/route.ts`, `[id]/submit/route.ts`.
5. Schemas: `src/schemas/mockExamSchemas.ts`.
6. Services: `src/server/services/mockExamService.ts`.
7. UI: `src/app/(student)/mock-exams/page.tsx`, `src/app/(student)/exam-simulator/page.tsx`.
8. Features: `src/features/mockExams/components/MockExamBuilder.tsx`, `ExamSimulatorShell.tsx`.
9. Add StudentNav links; premium badges on builder.
10. Tests: `tests/mockExamEngine.test.ts`, `tests/examSimulatorEngine.test.ts`.
11. Update `scripts/scope-check.ts` banned-route exceptions.
12. Update RLS tests in `tests/rls/`.

### File allowlist

```
supabase/migrations/*_mock_exam_tables.sql
src/lib/mockExams/mockExamEngine.ts
src/lib/mockExams/examSimulatorEngine.ts
src/app/api/mock-exams/**
src/app/api/exam-simulator/**
src/schemas/mockExamSchemas.ts
src/server/services/mockExamService.ts
src/features/mockExams/**
src/app/(student)/mock-exams/**
src/app/(student)/exam-simulator/**
src/features/student/components/StudentNav.tsx
scripts/scope-check.ts
tests/mockExamEngine.test.ts
tests/examSimulatorEngine.test.ts
tests/rls/mockExamAccess.test.ts
```

### Out of scope

- Multi-subject mock exams (math only until Phase 2.4)
- Proctored/live exam anti-cheat
- Printable PDF export
- Leaderboards / social sharing
- Nex chat during simulator (locked screen)
- Voice read-aloud of questions (Phase 2.5)

### Verification

```bash
npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build
npm test -- tests/mockExamEngine.test.ts tests/examSimulatorEngine.test.ts
```

Manual: premium student generates KCSE mock (20 Q) → completes in simulator with 45-min timer → analysis updates progress.

### Planner verdict

`PASS`

---

## Phase 2.4 — Science + English Content

**Status:** `PASS`  
**Depends on:** Phase 2.3 PASS

### Goal

Activate Science and English subjects in Learn with seeded CBC/KCSE curriculum; extend Nex to tutor all three subjects with subject-aware context.

### Criterion IDs

| ID | Description |
|----|-------------|
| V2-CONTENT-01 | `subjects` rows `science`, `english` active; visible in Learn subject tree |
| V2-CONTENT-02 | Minimum manifest per subject: 3 topics × 3 lessons × 21 practice questions (CBC + KCSE variants) |
| V2-CONTENT-03 | `SubjectTree` filters by `student_profiles.curriculum` and `grade_level` |
| V2-CONTENT-04 | Diagnostic remains math-only (V1); subject-specific health scores display on progress for new subjects after first practice |
| V2-CONTENT-05 | `loadCurriculumContext` resolves science/english lesson excerpts |
| V2-CONTENT-06 | Nex base prompt subject scope updated: mathematics, science, english — decline others |
| V2-CONTENT-07 | `generate-curriculum-seed.mjs` or SQL seeds for `supabase/seed/curriculum_science.sql`, `curriculum_english.sql` |
| V2-CONTENT-08 | Scope-check: no Kiswahili/Cambridge activation (Tier 1 lock = Science + English only) |

### Tasks

1. Author `docs/phase-2-product-systems/science-content-manifest.md` and `english-content-manifest.md` (mirror math manifest structure).
2. Seed migrations/SQL: topics, subtopics, lessons, practice_questions for both subjects.
3. Update `src/server/services/curriculumService.ts` for multi-subject tree.
4. Update `src/features/learn/components/SubjectTree.tsx`, `TopicList.tsx` for subject switcher.
5. Update `src/lib/nex/loadCurriculumContext.ts` — subject from topic → subject_id join.
6. Update `assemblePrompt.ts` base scope line; `validateNexResponse.ts` subject guard.
7. Update mock exam engine to optionally filter by subject (math default preserved).
8. Add `tests/curriculumService.test.ts` for science/english tree counts.
9. Run seed against local Supabase; verify Learn browse at 375px.
10. Update `mvp-feature-scope-lock.md` conflict register only if Orchestrator approves (documentation task — flag, do not self-amend).

### File allowlist

```
docs/phase-2-product-systems/science-content-manifest.md
docs/phase-2-product-systems/english-content-manifest.md
supabase/seed/curriculum_science.sql
supabase/seed/curriculum_english.sql
supabase/migrations/*_science_english_subjects.sql
scripts/generate-curriculum-seed.mjs
src/server/services/curriculumService.ts
src/features/learn/components/SubjectTree.tsx
src/features/learn/components/TopicList.tsx
src/lib/nex/loadCurriculumContext.ts
src/lib/nex/assemblePrompt.ts
src/lib/nex/validateNexResponse.ts
src/types/curriculum.ts
tests/curriculumService.test.ts
```

### Out of scope

- Kiswahili subject
- Cambridge curriculum
- Science/English diagnostic assessments (math diagnostic unchanged)
- Video lessons
- Camera subject-specific tuning beyond base vision prompt
- Full KCSE paper breadth (minimum manifest only)

### Verification

```bash
npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build
npm test -- tests/curriculumService.test.ts
```

Manual: student browses Science → completes lesson → asks Nex explain question in science → curriculum-grounded response.

### Planner verdict

`PASS`

---

## Phase 2.5 — Voice (Push-to-Talk)

**Status:** `CODE_COMPLETE`  
**Depends on:** Phase 2.4 PASS

### Goal

Add push-to-talk Voice Tutor: browser captures audio, server transcribes, Nex pipeline responds, TTS streams back — no parallel chat system.

### Criterion IDs

| ID | Description |
|----|-------------|
| V2-VOICE-01 | `POST /api/nex/voice` accepts audio blob (webm/opus, max 30s / 2MB) |
| V2-VOICE-02 | STT via Gemini or OpenAI Whisper fallback; Kenya English locale hint |
| V2-VOICE-03 | Transcript fed to `generateNexResponse` with active session mode |
| V2-VOICE-04 | TTS response audio returned (base64 or streaming URL); text also in `nex_messages` |
| V2-VOICE-05 | Push-to-talk UI on Nex page; press-hold-release; works at 375px |
| V2-VOICE-06 | Premium gating + daily Nex message limits count voice turns |
| V2-VOICE-07 | No API keys in client; audio processed server-side only |
| V2-VOICE-08 | Scope-check allowlists `/api/nex/voice` |
| V2-VOICE-09 | Golden test: voice transcript mock → Nex response validation path |

### Tasks

1. Create `src/lib/nex/voiceTranscribe.ts` and `src/lib/nex/voiceSynthesize.ts` (Gemini primary, OpenAI fallback).
2. Create `src/app/api/nex/voice/route.ts` — auth, rate limit, STT → generateNexResponse → TTS.
3. Create `src/schemas/voiceSchemas.ts`.
4. Create `src/features/nex/components/VoicePushToTalk.tsx`; integrate in `NexChatPanel`.
5. Log voice messages in `nex_messages` with `metadata.inputType: "voice"`.
6. Premium gate via subscription service; increment Nex usage counter.
7. Update `scripts/scope-check.ts`.
8. Add `tests/voicePipeline.test.ts` with mocked STT/TTS.
9. Mobile UX: microphone permission handling, 48px touch target, haptic-free fallback label.
10. Document env vars (`GEMINI_API_KEY`, `OPENAI_API_KEY`) in `docs/LOCAL-DEV.md`.

### File allowlist

```
src/lib/nex/voiceTranscribe.ts
src/lib/nex/voiceSynthesize.ts
src/app/api/nex/voice/route.ts
src/schemas/voiceSchemas.ts
src/features/nex/components/VoicePushToTalk.tsx
src/features/nex/components/NexChatPanel.tsx
src/server/services/nexUsageService.ts
scripts/scope-check.ts
tests/voicePipeline.test.ts
docs/LOCAL-DEV.md
docs/phase-1-foundation/api-standards.md
```

### Out of scope

- Always-on voice / wake word
- Voice in mock exams or exam simulator
- Offline STT
- Kiswahili STT (English primary per PRD mobile-first)
- Custom voice personas / celebrity voices
- Replacing text chat UI

### Verification

```bash
npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build
npm test -- tests/voicePipeline.test.ts
```

Manual: premium student push-to-talk “Explain fractions” → hears Nex reply; message appears in chat history.

### Planner verdict

`CODE_COMPLETE` — batch terminal verification deferred

---

## Parallel workstreams (optional)

| Stream | Phases | Notes |
|--------|--------|-------|
| — | — | **No parallel build.** Single `APPROVED_TO_BUILD` phase at a time per HANDOFF-PROTOCOL. Phase 2.4 content authoring may be **drafted** in parallel with 2.3 but not merged until 2.3 PASS. |

## Verdict rationale

**Phase 0 `APPROVED_TO_BUILD`:** V1 Private Beta is code-complete (wave 10 PASS) but launch gate items remain open per `mvp-feature-scope-lock.md` §5: FEASIBILITY-UAT checklist unchecked, `seven_day_streak` badge not awarded (notification-only in `practiceService.ts`), e2e limited to public smoke, CI omits Playwright. These are bounded, testable fixes with no V2 scope bleed.

**Phases 2.1–2.5 `PENDING`:** Each unlocks previously banned V2 Tier 1 scope (scope lock §3 → §4). Sequential dependency follows Architect recommendation: Assessment + misconception flywheel first (feeds all Nex modes) → Camera (highest engagement, uses pipeline) → Mock Exams (consumes practice question bank) → Multi-subject content (expands Learn + Nex context) → Voice (mobile-first capstone). Planner will flip next phase to `APPROVED_TO_BUILD` only after prior QA-REPORT `PASS`.

**Blocked items:** None. Product input not required for Phase 0. Phase 2.4 requires content manifest authorship but not product scope change (Tier 1 explicitly lists Science + English).
