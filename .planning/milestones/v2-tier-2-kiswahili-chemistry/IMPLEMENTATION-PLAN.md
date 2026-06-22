---
milestone: v2-tier-2-kiswahili-chemistry
phase: all
agent: architect+planner
version: 1
status: APPROVED_TO_BUILD
inputs:
  - src/server/services/contentGenerationService.ts
  - src/server/services/contentAdminReadService.ts
  - src/server/services/curriculumService.ts
  - src/lib/curriculum/contentModel.ts
  - src/lib/nex/assemblePrompt.ts
  - src/lib/nex/validateNexResponse.ts
  - src/schemas/contentGenerationSchemas.ts
  - src/types/curriculum.ts
  - src/features/learn/components/LessonReader.tsx
  - scripts/exportContent.ts
  - scripts/scope-check.ts
  - supabase/config.toml
outputs:
  - supabase/migrations/2026*_add_kiswahili_chemistry_subjects.sql
  - supabase/migrations/2026*_lesson_block_types_additive.sql (none — JSONB, no DDL)
  - supabase/seed/curriculum_kiswahili.sql
  - supabase/seed/curriculum_chemistry.sql
---

# IMPLEMENTATION PLAN — Add Kiswahili + Standalone Chemistry (Tier 2)

> **Audience:** Cursor coding agents executing under the Nexus Agent Orchestra (`AGENTS.md`).
> **Read this entire file before writing any code.** Every change you make must be traceable to a
> numbered task here. **Do not infer, assume, or invent anything not written in this document.**
> If a fact you need is not in this plan, STOP and ask the orchestrator — do not guess.

---

## 0. Locked decisions (do not relitigate)

These were decided by the product owner (Garnet). Build to exactly these:

| # | Decision | Consequence |
|---|----------|-------------|
| D1 | **Add Kiswahili + a standalone Chemistry subject only.** | Do NOT split the existing `science` subject. Do NOT touch `science`, `mathematics`, or `english` rows/topics. Chemistry is a NEW subject with `code = 'chemistry'`, independent of the existing `chemistry_basics` topic that lives under `science`. |
| D2 | **Content comes from the AI generate→review→publish→export loop.** | The plan unlocks the existing pipeline for the new subjects. Lessons/questions are generated as drafts, human-reviewed, published, then exported to seed. The topic/subtopic **skeleton** is seeded by hand (see Phase 1). |
| D3 | **Extend the lesson schema with new block types (additively).** | Add `chemical_equation` and `comprehension_passage` block types as new, optional members. Existing block types and existing lessons are untouched. |
| D4 | **Full vertical: backend + seed + UI surfacing + Nex unblock.** | New subjects must appear in Learn/Practice, be generatable in `/admin/content`, and Nex must teach them. **Generalizing the Math-only revision/diagnostic/mock-exam engines is OUT OF SCOPE** (see §3). |

---

## 1. Absolute non-negotiables (every phase, every agent)

1. **Purely additive, never destructive.** You may only:
   - `INSERT ... ON CONFLICT DO NOTHING` / `ON CONFLICT DO UPDATE` (additive upserts),
   - `ALTER TABLE ... ADD COLUMN IF NOT EXISTS`,
   - add new union members / new constants / new files,
   - append to allow-lists.
   You may **NEVER** `DROP`, `DELETE`, `TRUNCATE`, rename a column, change a column type, alter an existing CHECK constraint, or `UPDATE` existing content rows. No exceptions.
2. **Do not modify existing seed files** `supabase/seed/curriculum_math.sql`, `curriculum_science.sql`, `curriculum_english.sql`, or the Mathematics/Science/English rows in `supabase/seed.sql`. New subjects get NEW seed files.
3. **Migrations are forward-only and idempotent.** Every new migration must be safe to run twice. Use `IF NOT EXISTS` and `ON CONFLICT`. Never edit an already-committed migration file.
4. **No new runtime dependencies.** Everything needed is already installed (`zod`, `katex`, `react-markdown`, `remark-math`, `rehype-katex`, `@supabase/supabase-js`). If you believe a dep is required, STOP and ask — do not `npm install`.
5. **Reuse, do not fork.** Reuse `callNexModel` (the only LLM client), the existing admin shell + super-admin guard, the shared UI primitives, and the existing draft/publish/export services. Do not create a second generation service or a second LLM client.
6. **Server Components default; Zod-validate every LLM output and every API body; tokens only (no hardcoded hex); `@/` import alias; services in `src/server/services`.** (From `docs/phase-5-engineering-governance/coding-standards.md`.)
7. **Drafts are never student-visible.** Generated content is always `is_active=false, review_status='draft'` until an explicit Publish. RLS already enforces `is_active=true` for `authenticated`; do not weaken it.
8. **Definition of done per phase =** `npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build` all green. The final phase additionally runs `npm run test:e2e:ci`.
9. **Next.js version caveat:** per `AGENTS.md`, this repo runs a Next.js whose APIs may differ from your training data. Before writing any route/page code, read the relevant guide in `node_modules/next/dist/docs/`. Do not assume App Router conventions from memory.

---

## 2. Verified current state (ground truth — file:line)

This is the factual map of the codebase as it exists. **Trust these references over your priors.** If a line number has drifted, match on the quoted symbol, not the number.

### 2.1 Database schema (already supports new subjects with zero DDL)

The curriculum tables are fully generic — they key on `subjects.code`, not on hardcoded subject names:

- `public.subjects(id, curriculum_id, code, name, is_active)` — `UNIQUE (curriculum_id, code)` — `supabase/migrations/20250613120000_create_core_schema.sql`.
- `public.topics(id, subject_id, code, title, description, sort_order, is_active, min_grade_sort_order DEFAULT 1)` — `UNIQUE (subject_id, code)`. `min_grade_sort_order` added in `20250614120000_add_topic_min_grade_sort_order.sql`.
- `public.subtopics(id, topic_id, code, title, description, sort_order, is_active)` — `UNIQUE (topic_id, code)`.
- `public.lessons(id, subtopic_id, title, content JSONB, estimated_minutes, sort_order, is_active, created_at, updated_at, review_status DEFAULT 'published' CHECK IN (draft,published,archived), generated_by, generated_model, published_by)` — `content` JSONB holds the blocks; **adding block types needs NO schema change.**
- `public.practice_questions(id, topic_id, subtopic_id, question_text, question_type, options JSONB, correct_answer JSONB, difficulty CHECK IN (easy,medium,hard), explanation, is_active, review_status, generated_by, generated_model, published_by)`.
- `public.content_generation_jobs(...)` — audit log — `20250616140000_content_generation_pipeline.sql`.
- RLS: `lessons_read` / `practice_questions_read` are `FOR SELECT TO authenticated USING (is_active = true)` — `20250616150000_content_pipeline_rls_hardening.sql`. **Do not change.**

**Conclusion:** new subjects need only data (subject + topic + subtopic rows) — no new tables, no column changes. The only DDL-ish work is the additive subject INSERT migration in Phase 1.

### 2.2 Existing subject catalog

`mathematics`, `english` (both CBC+KCSE), and a single combined `science` (CBC+KCSE) whose topics include `chemistry_basics`, `biology_basics`, `physics_basics`. **Kiswahili does not exist and is actively banned (see 2.4).** Grade levels: CBC `grade_4..grade_9` (sort_order 1..6), KCSE `form_1..form_4` (sort_order 1..4) — `supabase/seed.sql`.

### 2.3 Scope locks that block new subjects (exact locations)

| # | File:symbol | Current behavior | Must become |
|---|-------------|------------------|-------------|
| L1 | `src/server/services/contentGenerationService.ts:20` `MATHEMATICS_SUBJECT_CODE` + `:79` `assertMathematicsScope()` (called `:235`, `:291`) | Throws `SCOPE_VIOLATION` unless subject code is `mathematics`. | Allow an allow-list of subject codes. |
| L2 | `src/server/services/contentGenerationService.ts:92-138` `buildLessonSystemPrompt` + `:140-183` `buildQuestionBankSystemPrompt` | Hardcode "Mathematics" and "Mathematics standards". | Subject-aware (derive from `context.subjectName` / `subjectCode`). |
| L3 | `src/server/services/contentAdminReadService.ts:16` `MATHEMATICS_SUBJECT_CODE` (used `:60`) | Coverage browser reads `mathematics` only. | Read all generation-scope subjects. |
| L4 | `src/lib/curriculum/contentModel.ts:1` `TIER1_SUBJECT_CODES = ["mathematics","science","english"]` | Gate for which subjects appear in Learn (`curriculumService.ts:107` `.in("code", [...TIER1_SUBJECT_CODES])`). | Append `"kiswahili"`, `"chemistry"`. |
| L5 | `scripts/scope-check.ts:46-49` `BANNED_SUBJECT_CODES` (`/['"]kiswahili['"]/`, `/['"]cambridge['"]/`) checked vs seed files `:109-125` | CI fails if a seed file activates `kiswahili`. | Remove ONLY `kiswahili` from the banned list. Keep `cambridge` banned. Add the new seed files to `seedPaths`. |
| L6 | `src/lib/nex/assemblePrompt.ts:43`, `:66` | Base prompt tells Nex to decline Kiswahili and limits scope to "Mathematics, Science, English". | Include Kiswahili + Chemistry in allowed scope. |
| L7 | `src/lib/nex/validateNexResponse.ts:20-22` `OUT_OF_SCOPE_DECLINE_PATTERNS = [/\b(history|kiswahili|cambridge|french|german)\b/i]` | Treats `kiswahili` as an out-of-scope topic. | Remove ONLY `kiswahili` from the alternation. Keep `history`, `cambridge`, `french`, `german`. |
| L8 | `scripts/exportContent.ts:18-19` `OUTPUT_PATH` (curriculum_math.sql), `MATHEMATICS_CODE` (used in every `render*Insert`) | Exports only Mathematics to one file. | Parameterize per subject → per-file export; keep math output byte-identical. |
| L9 | `supabase/config.toml:71` `[db.seed] sql_paths` | Lists math/science/english seeds only. | Append the two new seed files in deterministic order. |
| L10 | `src/features/admin/components/ContentPipelinePanel.tsx:67,409,521-532` | Hardcoded "Mathematics (V1)" copy + empty-state. | Subject-aware copy; no longer Math-only. |
| L11 | `src/features/onboarding/components/OnboardingForm.tsx:116` | "Nexus beta focuses on **mathematics only**". | Update copy to reflect available subjects (see Phase 6). |

### 2.4 Lesson block model (for D3 — additive block types)

- Type union: `src/types/curriculum.ts:1-46` — `LessonBlockType`, the four block interfaces, `LessonContentBlock`, `LessonContent`.
- Zod contract: `src/schemas/contentGenerationSchemas.ts:3-30` (`lessonBlockSchema` is a `z.discriminatedUnion("type", ...)`), `:38-47` `generatedLessonSchema`. Also `updateDraftLessonRequestSchema:145` reuses `lessonBlockSchema`.
- Renderer: `src/features/learn/components/LessonReader.tsx:373-426` is a `switch (block.type)` with `default: return null` (so unknown blocks render nothing — old content is safe). `WorkedExampleBlock` is the `example` renderer.
- Parser: `curriculumService.ts:22 parseLessonContent` simply passes `blocks` through as an array — it does not enforce block types, so new types flow through to the renderer.
- KaTeX is already wired (`katex`, `rehype-katex`, `remark-math` in `package.json`) — chemistry equations can render with it.

### 2.5 The content pipeline (already built — reuse it)

Generate → review/publish → export → commit → `db:reset`. Documented in `docs/build-plans/content-pipeline-plan.md`. Services: `contentGenerationService.ts` (`generateLessonDraft`, `generateQuestionBankDraft`, `publishDraft`, `discardDraft`, `updateDraftLesson`, `updateDraftQuestion`, `getDraftLessonForPreview`). Admin UI: `/admin/content` (`ContentPipelinePanel.tsx`). Export: `scripts/exportContent.ts` (`npm run content:export`). Coverage targets: `src/lib/curriculum/practiceCoverage.ts` (`TOPIC_QUESTION_COVERAGE_TARGET = 20`, `MIN_QUESTIONS_TO_START_PRACTICE = 5`) and `contentModel.ts` (`MIN_TOPICS_PER_SUBJECT = 3`, `MIN_LESSONS_PER_TOPIC = 3`, `MIN_PRACTICE_QUESTIONS_PER_TOPIC = 21`).

---

## 3. Explicitly OUT OF SCOPE (do not touch)

Leaving these alone is part of "additive". Touching them is a plan violation.

- **Do not split or modify the `science` subject** or its topics/subtopics/lessons (D1).
- **Do not generalize the Math-only engines** (D4):
  - `src/server/services/diagnosticService.ts:598` hardcodes `subject?.code === "mathematics"` for academic-health; diagnostics are seeded for Mathematics only in `supabase/seed.sql`. Kiswahili/Chemistry will have **no diagnostic** this milestone — that is acceptable and intended.
  - `src/server/services/mockExamService.ts` and the revision engine (`kcseMathRevisionEngine`, `KcseMathRevisionHub`) are Mathematics-only and stay so.
  - The REVISION-mode prompt line `assemblePrompt.ts:138` ("{curriculum} Mathematics") is engine territory — leave it; it does not block Kiswahili/Chemistry teaching in EXPLAIN/HOMEWORK/PRACTICE modes.
- **Do not change RLS, billing, auth, or pricing.**
- **Do not auto-publish content.** Human review gate stays.

If Kiswahili/Chemistry must reach feature parity with Math (diagnostics, mock exams, revision hub), that is a **separate future milestone** — note it in `STATUS.md`, do not build it here.

---

## 4. Subject + skeleton data contract (Phase 1 input — must be human-verified)

> **HALLUCINATION GUARD.** The topic/subtopic skeleton is the ONE place an agent could invent
> syllabus content. Agents MUST NOT invent topics. The skeleton below is a **starter scaffold** that
> Garnet must verify against the official **KNEC KCSE Chemistry syllabus** and **KICD Kiswahili
> syllabus** BEFORE Phase 1 is committed. Treat any topic not present in those official documents as
> invalid. If the owner has not signed off the skeleton, STOP at Phase 1 and request sign-off.

Subject rows to create (both via migration, both curricula where applicable — see Phase 1 for the CBC-vs-KCSE rule):

| Subject | `code` | `name` | Curricula |
|---------|--------|--------|-----------|
| Chemistry | `chemistry` | `Chemistry` | `KCSE` only (Chemistry is a KCSE/secondary subject; CBC uses integrated `science`). |
| Kiswahili | `kiswahili` | `Kiswahili` | `CBC` and `KCSE` (Kiswahili runs across both). |

**Starter skeleton (VERIFY before use).** Codes are `snake_case`, stable, and must never change once published. `min_grade_sort_order` uses the curriculum's `grade_levels.sort_order` (KCSE: form_1=1..form_4=4; CBC: grade_4=1..grade_9=6).

Chemistry (KCSE, Form 1–4) — example topic set:
`introduction_to_chemistry` (1), `simple_classification_of_substances` (1), `acids_bases_indicators` (1), `air_and_combustion` (2), `water_and_hydrogen` (2), `structure_of_the_atom_periodic_table` (2), `chemical_families` (3), `structure_and_bonding` (3), `salts` (3), `effect_of_electric_current_on_substances` (3), `carbon_and_its_compounds` (4), `nitrogen_and_its_compounds` (4), `sulphur_and_its_compounds` (4), `chlorine_and_its_compounds` (4), `the_mole` (3), `organic_chemistry_i` (4), `metals` (4), `acids_bases_and_salts` (3), `energy_changes_in_chemical_reactions` (4), `reaction_rates_and_reversible_reactions` (4), `electrochemistry` (4), `radioactivity` (4). Each topic gets ≥3 subtopics from the official syllabus.

Kiswahili (KCSE, Form 1–4) — example topic set across the three KNEC papers:
`sarufi_na_matumizi_ya_lugha` (Karatasi 102/1), `insha` (102/1), `ufahamu` (102/2), `ufupisho` (102/2), `matumizi_ya_lugha` (102/2), `isimu_jamii` (102/2), `fasihi_simulizi` (102/3), `ushairi` (102/3), `riwaya` (set text, 102/3), `tamthilia` (set text, 102/3), `hadithi_fupi` (set text, 102/3), `methali_na_misemo` (1). CBC Kiswahili (grade 4–9) uses a lighter set: `kusoma`, `kuandika`, `kusikiliza_na_kuzungumza`, `sarufi`, `msamiati`.

**Each topic needs ≥3 subtopics** (to satisfy `MIN_TOPICS_PER_SUBJECT`/`MIN_LESSONS_PER_TOPIC` downstream). The skeleton seed files contain ONLY subjects/topics/subtopics — **no lessons, no questions** (those come from the AI loop).

---

## 5. Phased build plan

Phases are independently shippable and ordered by dependency. Each must end green (§1.8). Do not start phase N+1 until phase N is committed and green.

---

### Phase 0 — Generation-scope constant (foundation, no behavior change to existing subjects)

**Goal:** Introduce a single source of truth for "which subjects may use the content pipeline", without yet changing any user-facing behavior.

**Tasks**

1. In `src/lib/curriculum/contentModel.ts`, ADD (do not remove anything):
   ```ts
   /** Subjects whose content may be generated via the admin pipeline AND surfaced to students. */
   export const ACTIVE_SUBJECT_CODES = [
     "mathematics",
     "science",
     "english",
     "kiswahili",
     "chemistry",
   ] as const;
   export type ActiveSubjectCode = (typeof ACTIVE_SUBJECT_CODES)[number];
   ```
   Keep `TIER1_SUBJECT_CODES` exported for backward compatibility, but in Phase 6 the Learn gate switches to `ACTIVE_SUBJECT_CODES`. (Do not delete `TIER1_SUBJECT_CODES`; other code/tests may reference it — grep first.)

**File allowlist**
```
src/lib/curriculum/contentModel.ts
```
**Out of scope:** any consumer changes (later phases).
**Verification:** `npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build`.

---

### Phase 1 — Subject + skeleton seed (additive migration + new seed files)

**Goal:** Create the Kiswahili and Chemistry subjects and their verified topic/subtopic skeletons so the generation pipeline has nodes to target. **No lessons, no questions.**

**Pre-req gate:** Skeleton in §4 has been verified/signed-off by Garnet against official KNEC/KICD syllabi. If not, STOP.

**Tasks**

1. **New migration** `supabase/migrations/20260622090000_add_kiswahili_chemistry_subjects.sql` — insert the two subjects additively. Mirror the exact pattern of `20250615150000_science_english_subjects.sql`:
   ```sql
   -- Activate Kiswahili (CBC+KCSE) and standalone Chemistry (KCSE) subjects. Additive only.
   INSERT INTO public.subjects (curriculum_id, code, name, is_active)
   SELECT c.id, 'kiswahili', 'Kiswahili', true
   FROM public.curricula c
   WHERE c.code IN ('CBC', 'KCSE')
   ON CONFLICT (curriculum_id, code) DO UPDATE
     SET name = EXCLUDED.name, is_active = true;

   INSERT INTO public.subjects (curriculum_id, code, name, is_active)
   SELECT c.id, 'chemistry', 'Chemistry', true
   FROM public.curricula c
   WHERE c.code = 'KCSE'
   ON CONFLICT (curriculum_id, code) DO UPDATE
     SET name = EXCLUDED.name, is_active = true;
   ```
2. **New seed file** `supabase/seed/curriculum_kiswahili.sql` — topics + subtopics only, mirroring the exact INSERT/JOIN/`ON CONFLICT` shape used in `supabase/seed/curriculum_science.sql` (topics: `ON CONFLICT (subject_id, code) DO UPDATE SET ...`; subtopics: `ON CONFLICT (topic_id, code) DO NOTHING`). One `INSERT` per topic and per subtopic, `WHERE c.code = '<curriculum>' AND s.code = 'kiswahili'`. Header comment: `-- Kiswahili curriculum seed (CBC + KCSE) — skeleton only; lessons/questions via content pipeline`.
3. **New seed file** `supabase/seed/curriculum_chemistry.sql` — same shape, `s.code = 'chemistry'`, `c.code = 'KCSE'` only. Header comment analogous.
4. **Register seeds** in `supabase/config.toml` `[db.seed] sql_paths` (currently `["./seed.sql", "./seed/curriculum_math.sql", "./seed/curriculum_science.sql", "./seed/curriculum_english.sql"]`) — append in deterministic order:
   ```toml
   sql_paths = ["./seed.sql", "./seed/curriculum_math.sql", "./seed/curriculum_science.sql", "./seed/curriculum_english.sql", "./seed/curriculum_chemistry.sql", "./seed/curriculum_kiswahili.sql"]
   ```
5. **Unblock scope-check for seeds** (`scripts/scope-check.ts`):
   - In `BANNED_SUBJECT_CODES` (`:46-49`), remove ONLY the `/['"]kiswahili['"]/` entry. **Keep** `/['"]cambridge['"]/`.
   - In `seedPaths` (`:109-114`), append `join(ROOT, 'supabase/seed/curriculum_chemistry.sql')` and `join(ROOT, 'supabase/seed/curriculum_kiswahili.sql')` so the new files are still scanned for `cambridge`.

**File allowlist**
```
supabase/migrations/20260622090000_add_kiswahili_chemistry_subjects.sql   (new)
supabase/seed/curriculum_kiswahili.sql                                    (new)
supabase/seed/curriculum_chemistry.sql                                    (new)
supabase/config.toml
scripts/scope-check.ts
```
**Out of scope:** lessons, questions, diagnostics, any TS service/UI.
**Verification:** `npm run test:scope-check` (must still pass and now scan new seeds) → then `supabase db reset` locally (or `npm run setup:local`) and confirm via SQL that the new subjects + topics + subtopics exist and `science/math/english` counts are unchanged. Then the standard green gate.

---

### Phase 2 — Generalize the generation + admin-read services

**Goal:** Let `/admin/content` browse and generate drafts for Kiswahili + Chemistry, with subject-appropriate prompts.

**Tasks**

1. `src/server/services/contentGenerationService.ts`:
   - Replace the hard lock. Change `MATHEMATICS_SUBJECT_CODE` usage so `assertMathematicsScope` becomes `assertSubjectInGenerationScope(subjectCode)` that checks membership in `ACTIVE_SUBJECT_CODES` (import from `@/lib/curriculum/contentModel`). Keep throwing `"SCOPE_VIOLATION"` for anything outside it. Update both call sites (`:235`, `:291`). Do not change the error string (UI/route handlers may switch on it — grep `SCOPE_VIOLATION` first and preserve behavior).
   - Make `buildLessonSystemPrompt`/`buildQuestionBankSystemPrompt` subject-aware: replace literal `"Mathematics"` with `context.subjectName`, and the `standards` string with a helper:
     ```ts
     function standardsLabel(curriculum: Curriculum, subjectName: string): string {
       return curriculum === "CBC"
         ? `KICD/CBC ${subjectName} standards`
         : `KNEC/KCSE ${subjectName} standards`;
     }
     ```
   - Add subject-specific authoring guidance (append to the rules list, keyed off `context.subjectCode`):
     - `chemistry`: "Use correct IUPAC names and balanced equations. When a chemical equation is central, emit a `chemical_equation` block. State units. Reference Kenyan industrial/real-life contexts (e.g. soda ash at Magadi) where natural."
     - `kiswahili`: "Andika kwa Kiswahili sanifu. Kwa ufahamu, tumia kizuizi cha `comprehension_passage`. Usitumie mtindo wa mfano wa hatua za hesabu; tumia mifano ya lugha, sarufi, na fasihi." (Author in standard Kiswahili; for comprehension use the `comprehension_passage` block; do not use the math worked-step style.)
     - default (mathematics/science/english): keep current behavior.
   - The lesson-prompt's required-blocks instruction must stop demanding a "worked example with steps" for non-Math subjects. Make the required-block guidance conditional: Math/Science keep the worked `example` requirement; Kiswahili requires heading + paragraph(s) + (where relevant) `comprehension_passage` + tip; Chemistry requires heading + paragraph + at least one worked `example` OR `chemical_equation` + tip.
   - Do NOT change the JSON-only / retry / dedupe / insert-as-draft logic, the `recordGenerationJob` calls, or the return shapes.
2. `src/server/services/contentAdminReadService.ts`:
   - `MATHEMATICS_SUBJECT_CODE` (`:16`, used `:60`) → read all subjects in `ACTIVE_SUBJECT_CODES`. The coverage browser must return a subject dimension. Prefer the smallest change: add a `subjectCode` parameter (default keeps current behavior) and a function to list coverage across active subjects. Confirm the calling route `src/app/api/admin/content/coverage/route.ts` and `ContentPipelinePanel.tsx` consume the new shape (Phase 5 of this file covers the panel copy; the data wiring happens here).
3. Inspect and update the generate route(s) under `src/app/api/admin/content/` (`generate`, `publish`, `discard`) only if they hardcode `mathematics`. They validate with `generateContentRequestSchema` (`contentGenerationSchemas.ts:122`) which is subject-agnostic (keyed on `subtopicId`/`topicId`), so likely no change — **grep to confirm** before editing.

**File allowlist**
```
src/server/services/contentGenerationService.ts
src/server/services/contentAdminReadService.ts
src/app/api/admin/content/coverage/route.ts        (only if shape changes)
src/app/api/admin/content/generate/route.ts        (only if it hardcodes mathematics)
src/server/services/__tests__/*                      (add/extend unit tests)
```
**Out of scope:** new block types (Phase 3), export (Phase 4), Nex (Phase 5).
**Verification:** add unit tests proving (a) generation is allowed for `chemistry`/`kiswahili` and still rejected for an unknown code, (b) the prompt for `kiswahili` does not contain "Mathematics" and is in Kiswahili register, (c) existing math generation output is unchanged. Standard green gate.

---

### Phase 3 — Additive lesson block types (`chemical_equation`, `comprehension_passage`)

**Goal:** Support chemistry equations and Kiswahili passages as first-class blocks, without disturbing existing blocks or lessons.

**Tasks**

1. `src/types/curriculum.ts` — ADD to the union and add interfaces (do not modify existing ones):
   ```ts
   export interface LessonChemicalEquationBlock {
     type: "chemical_equation";
     equation: string;          // e.g. "2H_2 + O_2 -> 2H_2O" (KaTeX-renderable)
     caption?: string;
   }
   export interface LessonComprehensionPassageBlock {
     type: "comprehension_passage";
     title?: string;
     passage: string;
   }
   ```
   Extend `LessonBlockType` and `LessonContentBlock` to include the two new types.
2. `src/schemas/contentGenerationSchemas.ts` — ADD two `z.object` members to the `lessonBlockSchema` discriminated union (do not change existing members):
   ```ts
   const lessonChemicalEquationBlockSchema = z.object({
     type: z.literal("chemical_equation"),
     equation: z.string().min(1),
     caption: z.string().min(1).optional(),
   });
   const lessonComprehensionPassageBlockSchema = z.object({
     type: z.literal("comprehension_passage"),
     title: z.string().min(1).optional(),
     passage: z.string().min(1),
   });
   ```
   Add both to the `z.discriminatedUnion("type", [...])` array. `updateDraftLessonRequestSchema` reuses `lessonBlockSchema`, so it inherits them automatically — verify.
3. `src/features/learn/components/LessonReader.tsx` — ADD two `case` arms in the `switch (block.type)` (`:373-426`), before `default`:
   - `case "chemical_equation"`: render `block.equation` via the existing KaTeX path (mirror how math is rendered elsewhere; `rehype-katex`/`remark-math` are already deps) with optional `caption`. Use design tokens only.
   - `case "comprehension_passage"`: render optional `title` + `passage` in a readable passage container (tokens only). Keep an "Ask Nex" affordance consistent with `paragraph`.
   Keep `default: return null` (safety for any future unknown type).
4. If a separate admin draft-editor renders/edition blocks (check `ContentPipelinePanel.tsx` for a block editor), add edit affordances for the two new block types there too; if it edits raw JSON, no change needed — **grep first**.

**File allowlist**
```
src/types/curriculum.ts
src/schemas/contentGenerationSchemas.ts
src/features/learn/components/LessonReader.tsx
src/features/admin/components/ContentPipelinePanel.tsx   (only if it has a typed block editor)
src/**/__tests__/*                                       (renderer + schema tests)
```
**Out of scope:** generation prompts already emit these (Phase 2); export (Phase 4).
**Verification:** unit test that `generatedLessonSchema.parse` accepts a lesson containing each new block and still rejects malformed ones; render test that `LessonReader` displays both new blocks and that a lesson with only legacy blocks renders identically (snapshot). Standard green gate.

---

### Phase 4 — Generalize the seed-export pipeline

**Goal:** `npm run content:export` writes a per-subject seed file for every active subject, keeping `curriculum_math.sql` byte-identical to today's output.

**Tasks**

1. `scripts/exportContent.ts`:
   - Replace the module-level `OUTPUT_PATH`/`MATHEMATICS_CODE` hardcoding with a config list:
     ```ts
     const EXPORT_TARGETS: Array<{ subjectCode: string; outputFile: string; curricula: CurriculumCode[] }> = [
       { subjectCode: "mathematics", outputFile: "curriculum_math.sql",      curricula: ["CBC", "KCSE"] },
       { subjectCode: "kiswahili",   outputFile: "curriculum_kiswahili.sql", curricula: ["CBC", "KCSE"] },
       { subjectCode: "chemistry",   outputFile: "curriculum_chemistry.sql", curricula: ["KCSE"] },
     ];
     ```
   - Parameterize `renderTopicInsert`/`renderSubtopicInsert`/`renderLessonInsert`/`renderQuestionInsert` to take `subjectCode` instead of the constant `MATHEMATICS_CODE`. Parameterize `exportCurriculumMath` → `exportSubject(subjectCode, curricula)` returning the SQL string. The lesson/question queries keep `is_active=true AND review_status='published'` filters.
   - `main()` loops `EXPORT_TARGETS`, writes each file. **Math output must be unchanged** — verify by exporting before/after your change and diffing `curriculum_math.sql` (zero diff required).
   - Keep `sqlLiteral`/`sqlJsonb` (they already serialize arbitrary JSONB, so the new block types export correctly with no change).
2. Optionally add granular npm scripts (`content:export` stays the all-subjects entry point). Do not remove `content:export`.

**File allowlist**
```
scripts/exportContent.ts
package.json                 (only to add optional scripts; keep content:export)
```
**Out of scope:** running the export against real data (that is Phase 7, an operational step).
**Verification:** run export on a DB seeded with only Math published content → diff `curriculum_math.sql` against git HEAD → must be empty. Standard green gate.

---

### Phase 5 — Unblock Nex tutor for Kiswahili + Chemistry

**Goal:** Nex teaches Kiswahili and Chemistry instead of declining them, while keeping curriculum-grounding and Socratic rules intact.

**Tasks**

1. `src/lib/nex/assemblePrompt.ts`:
   - `:43` — change the scope line to: `- Subject scope: Mathematics, Science, English, Kiswahili, and Chemistry. Politely decline subjects outside this list (e.g. History, Cambridge/IGCSE, French, German).`
   - `:66` (EXPLAIN mode) — change "outside Mathematics, Science, English" to "outside Mathematics, Science, English, Kiswahili, or Chemistry".
   - For Kiswahili grounding, mirror the existing English guard in `buildCurriculumContextBlock` (`:233`): add a branch so when `context.subjectCode === "kiswahili"` the instruction is in Kiswahili and forbids ghost-writing full insha ("Ongoza mwanafunzi kupanga na kuhariri insha; usimwandikie insha nzima."). Keep the English branch as-is.
   - **Do not** change the REVISION-mode "{curriculum} Mathematics" line (`:138`) — out of scope (§3).
2. `src/lib/nex/validateNexResponse.ts:20-22` — remove ONLY `kiswahili` from `OUT_OF_SCOPE_DECLINE_PATTERNS`. Result: `/\b(history|cambridge|french|german)\b/i`. Keep the surrounding pass-logic (`:56-61`) intact.
3. Grep the rest of `src/lib/nex/**` for any other `kiswahili`/"Mathematics, Science, English" scope strings (e.g. `loadCurriculumContext.ts`, `types.ts`, `extractImageText.ts`) and update them consistently. **Do not** remove general safety, anti-cheating, or hallucination-prevention language.

**File allowlist**
```
src/lib/nex/assemblePrompt.ts
src/lib/nex/validateNexResponse.ts
src/lib/nex/loadCurriculumContext.ts     (only if it carries subject-scope strings)
src/lib/nex/__tests__/*                    (tests)
```
**Out of scope:** revision/diagnostic engines.
**Verification:** unit tests — (a) `validateNexResponse` no longer flags a Kiswahili teaching turn as out-of-scope, (b) `history`/`cambridge` still recognized as out-of-scope, (c) Socratic homework guards unchanged. Standard green gate.

---

### Phase 6 — Surface subjects in student UI

**Goal:** Kiswahili + Chemistry appear in Learn and Practice for the right curricula, and onboarding copy is accurate.

**Tasks**

1. `src/server/services/curriculumService.ts:107` — switch the subject-list gate from `TIER1_SUBJECT_CODES` to `ACTIVE_SUBJECT_CODES` (import from `@/lib/curriculum/contentModel`). This is the single change that makes new subjects appear in Learn. Confirm the re-export at `:19` (`export { isTopicVisibleForGrade, TIER1_SUBJECT_CODES }`) — add `ACTIVE_SUBJECT_CODES` to the re-export if consumers import it from here.
2. Verify subject ordering: the query orders by `name` — Chemistry/Kiswahili will slot alphabetically; confirm the Learn explorer (`LearnSubjectExplorer.tsx`) and Practice landing (`PracticeLanding.tsx`) render N subjects generically (they should, since they map over the returned list). Fix only genuine Math-only assumptions found by grep.
3. Grade visibility: Chemistry topics are KCSE-only and use `min_grade_sort_order` against `form_*`. A CBC student will not see Chemistry because the subject has no CBC row (Phase 1). Confirm `getSubjectsForStudent`/equivalent filters by the student's `curriculum_id` (it does — `:102 .eq("curriculum_id", curriculumId)`).
4. `src/features/onboarding/components/OnboardingForm.tsx:116` — replace "Nexus beta focuses on **mathematics only**" with copy reflecting the available subjects (e.g. "Nexus covers Mathematics, Science, English, Kiswahili, and Chemistry." — but pull the list from a constant, do not hardcode if a constant exists). Run the `design:ux-copy` skill if wording review is wanted.
5. `ContentPipelinePanel.tsx:67,409,521-532` — replace Math-only strings with subject-aware copy now that Phase 2 returns multi-subject coverage. Empty-state should reference the selected subject, not "Mathematics".

**File allowlist**
```
src/server/services/curriculumService.ts
src/features/learn/components/LearnSubjectExplorer.tsx       (only if Math-hardcoded)
src/features/practice/components/PracticeLanding.tsx          (only if Math-hardcoded)
src/features/onboarding/components/OnboardingForm.tsx
src/features/admin/components/ContentPipelinePanel.tsx
src/**/__tests__/*
```
**Out of scope:** diagnostics gating (Kiswahili/Chemistry simply have no diagnostic; ensure the UI degrades gracefully — see QA).
**Verification:** e2e/integration — a KCSE student sees Chemistry + Kiswahili in Learn; a CBC student sees Kiswahili but NOT Chemistry; Practice shows the new subjects only where published questions ≥ `MIN_QUESTIONS_TO_START_PRACTICE`. Standard green gate + `npm run test:e2e:ci`.

---

### Phase 6.5 — Empty-node gating (no empty/shallow topic ever reaches a student)

**Goal:** Make student visibility derive from published-content counts, so a topic appears in Learn/Practice only once it crosses the prod-ready bar. Prevents empty Kiswahili/Chemistry/new-Math-topic shells from showing.

**Full spec:** `KCSE-SYLLABUS-SKELETON-MATH-ENGLISH.md §8` (the bar in §8.1, the gate in §8.2, exact touch points in §8.3). Build to that section.

**Tasks (summary — see §8.3 for detail)**

1. Add pure predicates `isTopicLearnReady` / `isTopicPracticeReady` to `src/lib/curriculum/contentModel.ts` using existing constants (`MIN_LESSONS_PER_TOPIC`, `MIN_QUESTIONS_TO_START_PRACTICE`). Additive — do not change existing exports.
2. `src/server/services/curriculumService.ts`: count published lessons (per topic + per subtopic) and published questions (per topic, per difficulty); filter the Learn topic list by `isTopicLearnReady`; drop subjects with zero learn-ready topics. ADD to existing `is_active` filters, do not remove them.
3. Practice read path (`src/features/practice/**` + its service): filter by `isTopicPracticeReady`, reusing `practiceCoverage` helpers (grep for existing question-count checks and extend).
4. Admin: per-topic readiness badge (PROD-READY / LEARN-READY / PRACTICE-READY / NOT READY) in `ContentPipelinePanel.tsx` + `contentAdminReadService.ts`, using the same predicates.

**Non-negotiable:** skeleton topics stay `is_active=true` (generation needs them); visibility is a *separate derived concept*. Never set unready topics `is_active=false`.

**File allowlist**
```
src/lib/curriculum/contentModel.ts
src/server/services/curriculumService.ts
src/features/practice/**                              (read path only)
src/server/services/practiceService.ts               (if it lists topics)
src/features/admin/components/ContentPipelinePanel.tsx
src/server/services/contentAdminReadService.ts
src/**/__tests__/*
```
**Out of scope:** changing generation, RLS, or any write path.
**Verification:** unit tests on boundary cases (2 vs 3 lessons; 4 vs 5 questions/difficulty; a subtopic with no lesson blocks the topic); integration — a skeleton-only subject returns ZERO student-visible topics; after publishing 3 lessons + 21 questions to one topic, only that topic appears; existing Math with published lessons stays visible. Standard green gate + `npm run test:e2e:ci`.

---

### Phase 7 — Operational: generate, review, publish, export, commit

**Goal:** Populate real content through the now-unlocked pipeline. This phase is run by Garnet (+ a subject expert reviewer), assisted by an agent — it is NOT pure coding.

**Steps**

1. Local: `npm run setup:local` (start Supabase + `db reset` to load skeleton).
2. In `/admin/content`, for each Kiswahili + Chemistry subtopic: generate lesson drafts; for each topic per difficulty: generate question banks (target ≥ `MIN_PRACTICE_QUESTIONS_PER_TOPIC = 21`, i.e. ≥7 per difficulty, aiming for the 20/topic/difficulty coverage target).
3. **Subject-expert review** every draft (chemistry accuracy + safe-practical wording; Kiswahili idiom, sarufi, and set-text accuracy). Publish only what passes. Discard the rest. **No bulk auto-publish.**
4. `npm run content:export` → writes `curriculum_kiswahili.sql` + `curriculum_chemistry.sql` (and re-writes `curriculum_math.sql` byte-identically).
5. Commit the seed files. `npm run db:reset` must reproduce identical published content.
6. Record coverage in `STATUS.md` (topics, lessons, questions-per-difficulty per subject).

**Verification:** `db:reset` reproduces content; coverage meets the `contentModel.ts` minimums for every published topic; spot-check rendering of `chemical_equation` and `comprehension_passage` blocks in the student Learn view.

---

### Phase 8 — Production-readiness QA gate

**Goal:** Prove the milestone is additive, non-destructive, and production-ready. Use a QA agent (`.planning/agents/QA.md`) and the `QA-REPORT.md` template.

**Checklist (all must pass)**

- [ ] **Non-destructive proof:** `git diff` of `supabase/seed/curriculum_math.sql`, `curriculum_science.sql`, `curriculum_english.sql`, and the existing rows in `seed.sql` is EMPTY. No migration contains `DROP`/`DELETE`/`TRUNCATE`/`ALTER ... DROP`/type changes (grep the new migration).
- [ ] **Idempotency:** running `supabase db reset` twice yields identical row counts; the new migration re-runs without error.
- [ ] **Existing subjects unchanged:** Math/Science/English subject, topic, subtopic, lesson, and question counts are identical pre/post (capture counts before, compare after).
- [ ] **RLS intact:** an authenticated student still cannot read `review_status='draft'` rows; `content_generation_jobs` remains admin-only.
- [ ] **Scope-check:** `npm run test:scope-check` passes; `cambridge` is still banned; the new seed files are scanned.
- [ ] **Curriculum correctness:** Chemistry exists for KCSE only; Kiswahili for CBC+KCSE; a CBC student never sees Chemistry.
- [ ] **Nex:** declines History/Cambridge; teaches Kiswahili + Chemistry; Socratic homework guards and hallucination-grounding unchanged.
- [ ] **Block types:** legacy lessons render identically; new blocks render correctly; malformed blocks are rejected by Zod at generation.
- [ ] **No empty nodes:** every student-visible topic is at least LEARN-READY or PRACTICE-READY (per `KCSE-SYLLABUS-SKELETON-MATH-ENGLISH.md §8.1`); a skeleton-only subject shows zero topics; no empty/short topic renders in Learn or Practice.
- [ ] **Engines untouched:** diagnostics/mock-exam/revision remain Math-only and do not crash when a student is on Kiswahili/Chemistry (graceful "not available yet" rather than error).
- [ ] **Full gate:** `npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build && npm run test:e2e:ci` all green.
- [ ] **Provenance:** every generated row has `generated_by`/`generated_model`; every published row has `published_by`.
- [ ] Use a **subagent** to independently re-verify the non-destructive and RLS claims against the diff.

---

## 6. Migration & file manifest (what gets created/changed)

| Path | Phase | New/Changed | Nature |
|------|-------|-------------|--------|
| `src/lib/curriculum/contentModel.ts` | 0,6 | Changed | Add `ACTIVE_SUBJECT_CODES`; re-export |
| `supabase/migrations/20260622090000_add_kiswahili_chemistry_subjects.sql` | 1 | New | Additive subject INSERTs |
| `supabase/seed/curriculum_kiswahili.sql` | 1 | New | Topic/subtopic skeleton |
| `supabase/seed/curriculum_chemistry.sql` | 1 | New | Topic/subtopic skeleton |
| `supabase/config.toml` | 1 | Changed | Append seed paths |
| `scripts/scope-check.ts` | 1 | Changed | Unban `kiswahili`; scan new seeds |
| `src/server/services/contentGenerationService.ts` | 2 | Changed | Scope allow-list; subject-aware prompts |
| `src/server/services/contentAdminReadService.ts` | 2 | Changed | Multi-subject coverage |
| `src/app/api/admin/content/*` | 2 | Maybe | Only if Math-hardcoded |
| `src/types/curriculum.ts` | 3 | Changed | Two new block interfaces |
| `src/schemas/contentGenerationSchemas.ts` | 3 | Changed | Two new Zod block members |
| `src/features/learn/components/LessonReader.tsx` | 3 | Changed | Two new render cases |
| `scripts/exportContent.ts` | 4 | Changed | Per-subject export |
| `src/lib/nex/assemblePrompt.ts` | 5 | Changed | Scope strings + Kiswahili branch |
| `src/lib/nex/validateNexResponse.ts` | 5 | Changed | Drop `kiswahili` from decline regex |
| `src/server/services/curriculumService.ts` | 6, 6.5 | Changed | Gate → `ACTIVE_SUBJECT_CODES`; published-content visibility filter |
| `src/lib/curriculum/contentModel.ts` (predicates) | 6.5 | Changed | `isTopicLearnReady` / `isTopicPracticeReady` |
| `src/features/practice/**` + `practiceService.ts` | 6.5 | Changed | Practice-ready topic filter |
| `src/features/onboarding/components/OnboardingForm.tsx` | 6 | Changed | Subject copy |
| `src/features/admin/components/ContentPipelinePanel.tsx` | 6 | Changed | Subject-aware copy |

> Migration timestamp `20260622090000` is a placeholder later than the latest existing migration
> (`20250616160000`). If another migration lands first, bump to the next free timestamp — never reuse
> or reorder an existing one.

## 7. Risks & mitigations

| Risk | Severity | Mitigation |
|------|----------|------------|
| Agent invents syllabus topics | High | §4 hallucination guard + Garnet sign-off gate before Phase 1 commit. |
| Math export output drifts | Med | Phase 4 requires a zero-diff check on `curriculum_math.sql`. |
| Chemistry factual errors / unsafe practicals | High | Subject-expert review gate in Phase 7; no auto-publish. |
| Breaking existing students (destructive change) | High | §1 non-negotiables + Phase 8 non-destructive proof + subagent re-verify. |
| New block type crashes old renderer | Low | `default: return null` already safe; Phase 3 adds explicit cases + render tests. |
| Student on Kiswahili/Chemistry hits a Math-only engine | Med | Phase 8 checks graceful degradation, not errors. |

## 8. How to execute (orchestrator)

Run phases in order via the Agent Orchestra. For each phase: Planner confirms the file allowlist + criterion IDs against this plan → Coder implements within the allowlist only → QA verifies the phase gate → commit. Do not batch phases. After Phase 8, update `.planning/milestones/v2-tier-2-kiswahili-chemistry/STATUS.md` and note the deferred "engine parity for new subjects" as a future milestone.
