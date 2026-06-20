# Content Generation Pipeline — Implementation Plan (for an implementation agent)

**Owner:** Garnet · **Reviewer:** architect (reviews the diff against this spec)
**Goal:** Let a super-admin generate V1 Mathematics lessons + question banks with LLM assistance, review/edit them in-app as **drafts**, **publish** approved content, and **export** it to version-controlled seed files.
**Architecture decision (locked):** HYBRID — draft in DB (`is_active=false`) for fast review, then export published content to seed files so the content model §10.6 ("content via seed/migration, not runtime-only") is satisfied.

> Build into the EXISTING schema and services. Do not invent tables or restate content in UI. Generated content is ALWAYS a draft first — never auto-published. Mathematics only (V1).

---

## 0. Read first

- Content model + JSONB shape: `docs/phase-2-product-systems/curriculum-content-model.md` (§5 lesson blocks, §6 difficulty, §7 practice questions, §10 authoring rules, §11 grade filtering).
- Real schema & reads: `src/server/services/curriculumService.ts` — tables and columns are authoritative:
  - `curricula(id, code, is_active)`
  - `grade_levels(id, curriculum_id, code, display_name, sort_order, is_active)`
  - `subjects(id, code, name, curriculum_id, is_active)`
  - `topics(id, code, title, description, sort_order, subject_id, min_grade_sort_order, is_active)` (+ `prerequisite_topic_ids UUID[]` per content model §8)
  - `subtopics(id, code, title, description, sort_order, topic_id, is_active)`
  - `lessons(id, title, content JSONB, estimated_minutes, sort_order, subtopic_id, is_active)`
  - `practice_questions(question_text, question_type, options, correct_answer, difficulty, explanation, is_active, topic_id, subtopic_id?)`
- LLM client: `src/lib/nex/callNexModel.ts` (Gemini Flash primary, OpenAI fallback, mock when no keys). REUSE it; do not add another LLM client.
- Curriculum visibility helpers: `src/lib/curriculum/contentModel.ts` (`TIER1_SUBJECT_CODES`, `isTopicVisibleForGrade`).
- Existing admin area + auth: `src/app/(super-admin)/layout.tsx`, `src/app/(super-admin)/admin/platform-settings/page.tsx`, and how `super_admin` is gated (`authService` / `studentContext`). REUSE the admin shell + the super-admin guard.
- Lesson rendering for preview: `src/features/learn/components/LessonReader.tsx` / `LessonRenderer` — reuse to preview drafts.
- Conventions: `docs/phase-5-engineering-governance/coding-standards.md`. Tokens only, Server Components default, Zod validation, `@/` alias, services in `src/server/services`, no hardcoded hex.

---

## 1. Guardrails

1. **Super-admin only.** Every generation/publish/export route and the `/admin/content` UI must guard on `super_admin` (reuse the existing admin auth pattern). Auth check is the first line of every handler.
2. **Drafts never auto-publish.** Generation writes `is_active=false` + `review_status='draft'`. Only an explicit Publish action sets `is_active=true`.
3. **Mathematics only / V1 scope.** Generate only for `subjects.code='mathematics'`, CBC Grade 4–9 and KCSE Form 1–4. Do not generate Science/English/Kiswahili. Leave a `// SCOPE-FLAG` if asked otherwise. No banned features.
4. **Validate every LLM output with Zod** before any DB write. Malformed generations are rejected/retried, never inserted raw.
5. **Tokens, Server Components default, Zod, no new LLM deps.** Reuse `callNexModel`. The only acceptable new deps would be small (e.g. a seed-writing helper) — `// DEP-FLAG` and justify; prefer none.
6. **Cost/safety:** generation is admin-triggered per topic/subtopic (no bulk auto-runs without an explicit confirm). Log each generation job.
7. **Done = green:** `npm run lint`, `typecheck`, `test`, `test:scope-check`, then `deploy:check`. (Tests can be light this pass per owner, but typecheck/lint/scope-check must pass.)

---

## 2. Phase 0 — Schema + contracts

Add a Supabase migration (do NOT mutate existing rows' visibility):

- Add `review_status text not null default 'published'` to `lessons` and `practice_questions`. Existing rows = `'published'` (no behavior change). Allowed values: `'draft' | 'published' | 'archived'`.
- Add `generated_by uuid null` (admin id) and `generated_model text null` to both tables for provenance (nullable; hand-authored rows stay null).
- New table `content_generation_jobs(id, admin_id, scope_type text, scope_id uuid, curriculum_code text, status text, lessons_created int, questions_created int, model text, error text, created_at timestamptz default now())` for audit.
- RLS: students keep SELECT only on content (existing). The new `review_status`/provenance columns must not widen student access; students only ever see `is_active=true` (already enforced in `curriculumService`). Generation tables/columns are admin-only.

Types & Zod (`src/schemas/contentGenerationSchemas.ts`): mirror the JSONB lesson shape and question shape EXACTLY:

```ts
// Lesson content (matches curriculum-content-model §5 and parseLessonContent)
LessonBlock = heading{type,content} | paragraph{type,content}
            | example{type,title,steps[],answer} | tip{type,content}
GeneratedLesson = { title, estimatedMinutes, blocks: LessonBlock[],
                    shortQuiz?: { questions: { questionText, options[], correctAnswer }[] } }
GeneratedQuestion = { questionText, questionType: "multiple_choice"|"short_answer",
                      options: string[], correctAnswer, difficulty: "easy"|"medium"|"hard",
                      explanation }
```

These Zod schemas are the contract the LLM output must satisfy.

---

## 3. Phase 1 — Generation service (server)

`src/server/services/contentGenerationService.ts` (server-only):

- `generateLessonDraft({ subtopicId, curriculum, gradeLevel, adminId })`:
  1. Load subtopic + topic + subject context.
  2. Build a strict system prompt: KICD/CBC or KNEC/KCSE aligned (per curriculum), Kenyan contexts in examples, grade-appropriate vocabulary, ONE concept per lesson, and **"return JSON only matching this schema"** (inline the GeneratedLesson shape).
  3. Call `callNexModel({ systemPrompt, messages, maxTokens })`. Parse JSON (strip code fences), `GeneratedLesson.parse(...)`. On failure, one retry with a "your previous output was invalid JSON; return only valid JSON" nudge, then error.
  4. Insert into `lessons` as `is_active=false, review_status='draft', generated_by, generated_model`, with `content` = `{ blocks, shortQuiz }`, computed `sort_order` (append), `estimated_minutes`.
  5. Record a `content_generation_jobs` row.
- `generateQuestionBankDraft({ topicId, subtopicId?, difficulty, count, curriculum, gradeLevel, adminId })`: same pattern → insert N `practice_questions` as drafts. Target per content model §7: ≥20 per topic per difficulty (generate in batches; dedupe near-identical question_text).
- `publishDraft(kind, id, adminId)`: set `review_status='published', is_active=true`. `discardDraft(...)`: set `review_status='archived'` (soft) or delete.
- All functions: super-admin assertion, Zod-validated inputs, explicit return types, no `any`.

API routes (or server actions) under the super-admin boundary, e.g. `src/app/api/admin/content/generate`, `/publish`, `/discard` — each guards super_admin first, validates body with Zod, returns the standard `{ success, data | error }` shape.

---

## 4. Phase 2 — Admin review UI (`/admin/content`)

Under `(super-admin)`, reuse the admin shell. Build with SectionCard/EmptyState/Button/Toast/Skeleton (tokens only):

1. **Coverage browser:** subject → topic → subtopic tree (Mathematics, both curricula) showing per node: published lesson count, draft count, and question-bank coverage per difficulty vs the ≥20 target (use `BarMeter`). This surfaces the content gaps at a glance.
2. **Generate controls:** per subtopic "Generate lesson", per topic "Generate questions (difficulty, count)". Show a loading state + success/error Toast; refresh on completion. Confirm dialog before generating.
3. **Review queue:** list `review_status='draft'` items. For a lesson draft → **preview using the real `LessonRenderer`** (so admins see exactly what students will get), plus an editable form for blocks/quiz; for questions → editable rows. Actions: **Publish** (Toast + remove from queue) or **Discard**.
4. Empty/loading/error states via the shared primitives. Everything keyboard-accessible.

UX rule: nothing a student sees changes until Publish. Drafts are invisible to students (already guaranteed by `is_active=true` filters in `curriculumService`).

---

## 5. Phase 3 — Seed export (satisfies §10.6)

- Script `scripts/exportContent.ts` + `package.json` `"content:export"`: dumps **published** Mathematics content (curricula/grade_levels/subjects/topics/subtopics/lessons/practice_questions) into version-controlled seed files under `supabase/seed/` (SQL or TS, matching the existing seed format — inspect what's there first).
- Idempotent + deterministic ordering so diffs are reviewable in git. Document the loop in the file header: generate → review/publish in-app → `npm run content:export` → commit seed → `npm run db:reset` reproduces any environment.
- This is the bridge that keeps content reproducible and version-controlled even though authoring happens in-app.

---

## 6. Definition of Done (reviewer checklist)

- [ ] Super-admin guard on every generate/publish/export route + the `/admin/content` page (verified, not assumed).
- [ ] Generated content is ALWAYS draft (`is_active=false, review_status='draft'`); students never see drafts; existing published content unaffected by the migration.
- [ ] LLM output is Zod-validated against the exact lesson/question shapes before any insert; malformed output is rejected, not stored.
- [ ] Lesson JSONB matches `parseLessonContent` / content-model §5 exactly (renders in `LessonRenderer` with no shape errors).
- [ ] Reuses `callNexModel` (no second LLM client), the admin shell/auth, and the shared UI primitives; tokens only; dark mode intact.
- [ ] `content:export` produces deterministic, reviewable seed files; `db:reset` applies them; the reproduce loop is documented.
- [ ] Mathematics-only, V1-scope; `test:scope-check` green; `deploy:check` green.
- [ ] Handoff summary lists files changed, the migration, any `// SCOPE-FLAG` / `// DEP-FLAG`, and assumptions.

## 7. Suggested order

`phase-0-schema` → `phase-1-generation-service` → `phase-2-admin-ui` → `phase-3-seed-export`. Hand back after Phase 1 (generation service + one end-to-end draft insert) for an early review checkpoint before building the full UI.
```
