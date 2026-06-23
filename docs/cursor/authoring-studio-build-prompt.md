# Nexus Authoring Studio — Phased Build Prompt (for Cursor multi-agent)

> **Paste this whole file into Cursor as the master prompt.** It defines three
> collaborating subagents and a phase-by-phase plan to replace the current
> card-based admin content pipeline with a production-grade **Authoring Studio**:
> a Blackboard-style block document editor where humans author first, AI assists
> on request, and a configurable approval workflow (manual or auto) backed by
> automated quality gates.
>
> Build **Milestone A (the Authoring Studio)** only. Milestone B (personalized/
> adaptive delivery) is documented at the end as the north star — **do not build
> it now**, but do not preclude it.

---

## 0. How to use this prompt

Run the phases **in order**. For **each phase**, execute this loop:

1. **Coder** implements the phase scope.
2. **Repo Guardian** audits the diff for repo/ecosystem fidelity and end-to-end
   wiring (every route ↔ caller ↔ handler ↔ type lines up).
3. **QA** writes/runs tests and checks the acceptance criteria.
4. A phase is **done** only when all **Verification Gates** (§4) pass and the
   Guardian + QA both sign off. Commit the phase as one atomic commit, then stop
   and report a phase summary before starting the next phase.

Do **not** start a later phase before the current one is green. Do **not**
batch multiple phases into one commit.

---

## 1. Repo ground truth (read before touching anything)

This is an existing Next.js app. **Match its conventions exactly — do not
introduce new patterns, libraries, or styles that aren't already here unless a
phase explicitly says so.**

**Stack**
- Next.js **16.2.9** (App Router), React **19.2.4**, TypeScript strict.
- ⚠️ **`AGENTS.md` warns this is NOT the Next.js you know** — APIs/conventions
  may differ from training data. **Read the relevant guide in
  `node_modules/next/dist/docs/` before writing any Next.js-specific code**
  (routing, server actions, route handlers, caching). Heed deprecation notices.
- Tailwind **v4** (tokens in `src/app/globals.css`, `--nexus-*` design tokens).
- UI primitives: **`@base-ui/react`** (Dialog, Toast, AlertDialog, etc.).
- Validation: **zod v4**. DB: **Supabase** (Postgres + RLS).
- Tests: **vitest** (`tests/`). Lint: **eslint**. Markdown render pipeline:
  `react-markdown` + `remark-gfm` + `remark-math` + `rehype-katex` (already deps).

**Admin area (where the Studio lives)**
- Pages: `src/app/(super-admin)/admin/*`. Layout: `src/app/(super-admin)/layout.tsx`.
- Auth guard: `src/server/services/superAdminGuard.ts`
  (`requireSuperAdmin`, `requireAdminRole`, `ADMIN_ROLES`). Pages redirect to
  `/login` when `!auth.ok`.
- Nav: `src/features/admin/components/AdminNav.tsx` (`NAV_ITEMS`).
- **Shared admin UI primitives (USE THESE — do not re-roll):**
  - `src/features/admin/components/adminUi.tsx` → `PageHeader`, `Panel`,
    `StatCard`, `StatusBadge`, `EmptyState`, `FilterTabs`, `SearchInput`.
  - `src/features/admin/components/adminForm.tsx` → `Field`, `Input`, `Select`,
    `Textarea`, `Checkbox`.
  - `src/features/admin/components/DataTable.tsx` → generic table (search/sort/CSV).
  - `src/features/admin/components/toast.ts` → `adminToast`, `toastSuccess`,
    `toastError`, `toastInfo` (singleton; `<AdminToaster>` already mounted in layout).
  - `src/features/admin/components/ConfirmDialog.tsx` → `useConfirm()`.
  - `src/features/admin/components/CopyButton.tsx`.
  - Button: `src/components/ui/Button.tsx`.

**Current content system (being replaced)**
- Generation service: `src/server/services/contentGenerationService.ts`
  (`generateLessonDraft`, `generateQuestionBankDraft`, `publishDraft`,
  `discardDraft`, `updateDraftLesson`, `updateDraftQuestion`,
  `getDraftLessonForPreview`). Calls the model via
  `src/lib/nex/callNexModel.ts` (Gemini primary, OpenAI fallback).
- Read service: `src/server/services/contentAdminReadService.ts`.
- Routes: `src/app/api/admin/content/{generate,publish,discard,coverage,
  drafts/...}/route.ts`.
- Current UI (to retire): `src/features/admin/components/ContentPipelinePanel.tsx`
  + `src/app/(super-admin)/admin/content/page.tsx`.
- Content schemas: `src/schemas/contentGenerationSchemas.ts`.
- Curriculum scope: `src/lib/curriculum/contentModel.ts`
  (`ACTIVE_SUBJECT_CODES`, readiness helpers), `practiceCoverage.ts`.

**Content model & rendering**
- Types: `src/types/curriculum.ts` → `LessonContent { blocks, shortQuiz }`,
  `LessonContentBlock` union (heading, paragraph, example, tip,
  chemical_equation, comprehension_passage).
- Student renderer: `src/features/learn/components/LessonRenderer.tsx`.

**Data model (Supabase)**
- Migrations: `supabase/migrations/*.sql` (timestamp-prefixed).
- Key tables: `lessons` (`content` JSONB, `review_status` draft|published|archived,
  `is_active`, `sort_order`, `subtopic_id`, `generated_by`, `generated_model`,
  `estimated_minutes`, `updated_at`), `practice_questions`
  (`topic_id`, `subtopic_id`, `question_text`, `question_type`, `options`,
  `correct_answer`, `difficulty`, `explanation`, `is_active`, `review_status`),
  `subjects` / `topics` / `subtopics` / `curricula`, `content_generation_jobs`.
- Admin audit: `src/server/services/adminAuditService.ts` (log privileged actions).

**Conventions (do not deviate)**
- Server logic in `src/server/services/*.ts` with `import "server-only"`.
- DB writes via `createAdminClient()` from `src/lib/supabase/admin.ts`.
- Route handlers: zod-validate input, return `{ success, data?, error? }` shape
  (match existing admin routes exactly), guard with `requireSuperAdmin` /
  `requireAdminRole`.
- Times shown in `Africa/Nairobi`. Money in KES.
- Every privileged mutation writes an admin audit log entry.

---

## 2. The three subagents

### Subagent A — **Repo Guardian** (no-deviation + end-to-end wiring)
**Mandate:** guarantee the work fits the existing repo and ecosystem, and that
everything is wired end to end.

Responsibilities:
- Read `AGENTS.md` and the relevant `node_modules/next/dist/docs/` guides before
  approving any Next.js-specific code; flag any API used against its deprecation
  notice.
- Verify **every new/changed API route has a caller and a handler**, request and
  response payloads match the caller's `fetch` body and the route's zod schema,
  and the TypeScript types align across page → caller → route → service → DB.
- Verify auth guards (`requireSuperAdmin`/`requireAdminRole`) and RLS are present
  on every new surface; no admin table is exposed without service-role access.
- Confirm reuse of the shared `adminUi`/`adminForm`/`toast`/`ConfirmDialog`
  primitives instead of bespoke markup; confirm `--nexus-*` tokens (no off-palette
  colors, no `bg-card`/`bg-primary` panels).
- Confirm existing published lessons/questions still render and existing routes
  still work (no regressions to the student Learn/Practice flow).
- Owns the **`tsc` + `build`** gates. Produces a short audit per phase:
  PASS/BLOCK with file:line findings. **Blocks the phase on any HIGH finding.**

Tools: read-only over the repo + run `npm run typecheck`, `npm run build`,
`npm run lint`. Does **not** write feature code (may suggest diffs).

### Subagent B — **Coder**
**Mandate:** implement each phase's scope following existing patterns exactly.

Responsibilities:
- Implement only the current phase's scope. Small, focused files.
- Reuse shared primitives and services; extend rather than fork.
- Keep server/client boundaries correct (server components fetch; client islands
  for interactivity; never pass functions across the RSC boundary).
- Write zod schemas for every new input; audit-log every privileged mutation.
- Address Guardian/QA findings before the phase closes.

### Subagent C — **QA**
**Mandate:** prove the phase works and didn't break anything.

Responsibilities:
- Write/extend **vitest** tests for new services, schemas, and route contracts
  (mirror the style in `tests/admin/*`).
- Verify each phase's **Acceptance Criteria** explicitly, citing the test or the
  observed route response.
- Run the full admin suite (`npx vitest run tests/admin`) + any new tests and
  confirm green. Regression-check the student Learn/Practice path.
- Owns the **test** gate. Produces a short QA report per phase.

**Hand-off protocol per phase:** Coder → Guardian audit → QA report → fix loop →
all gates green → atomic commit → phase summary → STOP for review.

---

## 3. Global guardrails (apply to every phase)

- **Additive, reversible, no big-bang.** Existing content keeps working at every
  step. The old card pipeline is only removed in the final phase, after the new
  Studio fully replaces it.
- **No schema-breaking changes.** New block types are additive JSON in the
  existing `lessons.content`. New columns are nullable/defaulted. New tables are
  additive.
- **Structured content stays structured** (block JSON, not opaque HTML) so
  Milestone B and Nex can read it later.
- **AI is optional everywhere.** Every authoring action must be fully doable by
  hand. AI never auto-persists to students without passing the approval workflow.
- **One new top-level dependency is allowed: `@tiptap/*`** (editor). No other new
  libraries without calling it out in the phase report for review.

---

## 4. Verification gates (every phase must pass all)

1. `npm run typecheck` — clean.
2. `npm run lint` — clean on changed files.
3. `npx vitest run` (at least `tests/admin` + new tests) — green.
4. `npm run build` — compiles; all routes present; no RSC boundary errors.
5. Guardian audit — no HIGH findings; end-to-end wiring confirmed.
6. Acceptance Criteria for the phase — all met, evidenced by QA.

---

## 5. Phases

### Phase 0 — Content model + renderer foundation (no UX change)
**Goal:** grow the block vocabulary and the renderer so richer content is
storable and viewable, with zero change to existing lessons.

Scope:
- Extend `src/types/curriculum.ts`: add block types **`rich_text`** (markdown
  string), **`image`** (`url`, `alt`, `caption?`), **`table`** (rows/cols),
  **`math_block`** (`latex`, `caption?`), **`callout`** (`variant: info|warning|
  key_point`, `content`), **`video_embed`** (`provider`, `url`, `title?`),
  **`divider`**, **`question`** (inline; reuses practice-question shape:
  `questionText`, `questionType`, `options?`, `correctAnswer`, `explanation?`),
  **`file_attachment`** (`url`, `name`). Add a stable **`id: string`** to every
  block.
- Mirror these in zod (`src/schemas/contentGenerationSchemas.ts` or a new
  `src/schemas/lessonContentSchemas.ts`) as the canonical `lessonContentSchema`.
  Keep backward compatibility: blocks without `id` parse (assign on read).
- Extend `LessonRenderer.tsx` to render every new block type (rich_text via the
  existing markdown+KaTeX pipeline; image/table/callout/divider/math_block/
  video_embed/file_attachment; inline `question` as a self-check widget).
- Add a Supabase Storage bucket for content media (e.g. `content-media`) with an
  admin-write / public-read policy; migration + helper.

Acceptance criteria:
- Existing published lessons render identically (snapshot/regression test).
- A fixture lesson using every new block type renders without error.
- `lessonContentSchema` round-trips all block types; legacy blocks (no `id`) parse.

Guardian focus: renderer covers the full union (no unhandled block type); storage
policy is least-privilege.

---

### Phase 1 — Block document editor (manual authoring core)
**Goal:** a Blackboard-style editor that creates/edits a lesson's blocks by hand,
end to end, **with no AI**.

Scope:
- Add **TipTap** (`@tiptap/react`, `@tiptap/pm`, `@tiptap/starter-kit`, math &
  image extensions as needed). Build custom nodes that map 1:1 to the block model,
  plus a **serializer/deserializer** `LessonContent ⇄ editor doc`.
- Editor features: slash-menu to insert any block, drag/reorder, rich-text
  toolbar (bold/italic/lists/links/inline-math), image upload to `content-media`,
  inline question block editing, block delete/duplicate.
- New route + service to **load/save a lesson draft's content** by lesson id
  (extend `contentGenerationService.updateDraftLesson` or add a sibling); zod
  validated; audit-logged.
- New Studio route `src/app/(super-admin)/admin/studio/...` (or rework
  `/admin/content`) hosting the editor for a single lesson, with a **live student
  preview** toggle reusing `LessonRenderer`.
- "New lesson" creation flow for a chosen subtopic (manual; `review_status='draft'`).

Acceptance criteria:
- An author can create a lesson, add every block type by hand, save, reload, and
  see persisted content — no AI involved.
- Saved content validates against `lessonContentSchema` and renders in preview.
- Round-trip editor→JSON→editor is lossless for all block types.

Guardian focus: serializer correctness; save route caller/handler/types aligned;
client/server boundary (editor is a client island, page stays server where it can).

---

### Phase 2 — Curriculum workspace + question bank manager
**Goal:** authors can navigate the whole curriculum and manage lessons + question
banks without one-card-at-a-time friction.

Scope:
- Left-rail **curriculum tree** (subject → topic → subtopic) with status badges
  (draft / in_review / published) and coverage/readiness (reuse
  `contentAdminReadService` + `contentModel` readiness helpers). Selecting a node
  opens its lessons or question bank.
- **Question bank manager**: a `DataTable`-based, spreadsheet-style editor for a
  topic's `practice_questions` — bulk manual add/edit/inline-edit, difficulty,
  options, correct answer, explanation; bulk save; CSV import/export. Manual entry
  is first-class; AI is not required here.
- CRUD services + zod-validated routes for manual lesson and question
  create/update/reorder; audit-logged.

Acceptance criteria:
- Author can browse the full tree, see accurate status/coverage, create/edit
  lessons and questions anywhere, all by hand.
- Bulk question edits persist and validate; CSV export matches table; import
  validates and reports row errors.

Guardian focus: every tree action maps to a real, guarded route; coverage numbers
match the existing read service (no divergent counting logic).

---

### Phase 3 — Approval workflow + automated gates + auto-approve
**Goal:** configurable publishing — manual approve or auto-approve — backed by
automated quality gates. Replaces the old card review queue.

Scope:
- Add review state **`in_review`** to lessons/questions (`review_status` check
  constraint migration: draft → in_review → published → archived).
- Workflow services: `submitForReview`, `approveAndPublish`, `requestChanges`,
  `archive`; reuse/extend `publishDraft`. All audit-logged.
- **Auto-approve config**: a platform setting (extend the platform-settings
  surface) — global on/off — plus a per-author/per-content trust flag column
  (designed so a future teacher role inherits it). When auto-approve is on and
  gates pass, content publishes without manual review.
- **Automated gates** (run on submit/auto-approve): schema validation, subject
  generation-scope check (`assertSubjectInGenerationScope`), required-block
  completeness, question integrity (mcq options include the correct answer),
  curriculum/grade sanity. Reuse the flagging concept from
  `adminNexReviewService` style where useful. A gate failure blocks publish and
  surfaces actionable errors.
- **Review queue** rebuilt on `DataTable` + `Panel` + `useConfirm` + toasts
  (replaces `ContentPipelinePanel`'s queue). Diff/preview before approve.
- **Lesson versioning**: snapshot content on each publish into a
  `lesson_versions` table (additive); allow viewing/restoring a prior version.

Acceptance criteria:
- With auto-approve OFF: submit → appears in review queue → approve publishes →
  students see it; reject/request-changes returns to draft.
- With auto-approve ON: submit publishes directly **iff** all gates pass; a gate
  failure blocks and reports why.
- Every transition is audit-logged; publish creates a version snapshot.

Guardian focus: state machine is enforced server-side (illegal transitions
rejected); auto-approve cannot bypass gates; no student-facing path reads
non-published content.

---

### Phase 4 — AI assist panel (optional)
**Goal:** AI as an opt-in authoring assistant that emits **editable blocks**, not
an auto-publisher.

Scope:
- Side-panel in the editor with actions: **Draft this lesson**, **Expand this
  section**, **Simplify for grade N**, **Generate N questions for this topic/
  difficulty**, **Rewrite block**. Each returns blocks/questions that land in the
  editor as normal editable blocks the author owns.
- Refactor `contentGenerationService` so generation returns structured blocks to
  the editor (no auto-persist to students); reuse `callNexModel`, the subject
  authoring rules, JSON extraction, and retry/validation already there.
- New zod-validated, audit-logged routes for each assist action returning the
  `{ success, data, error }` shape. Respect existing model cost/usage logging
  (`content_generation_jobs`).

Acceptance criteria:
- Each assist action inserts valid, editable blocks; nothing publishes without the
  Phase 3 workflow.
- Generated output passes `lessonContentSchema`; invalid model output is retried
  then surfaced as a toast error (reuse existing retry pattern).
- A lesson can still be fully authored with the AI panel never opened.

Guardian focus: assist routes never write `is_active=true`/`published`; payloads
match; cost logging intact.

---

### Phase 5 — Roles-designed-in + retire old pipeline
**Goal:** make the permission model teacher-ready and remove the legacy pipeline.

Scope:
- Introduce a **content-author capability** mapped to `super_admin` today, with
  ownership columns (`author_id`) and the trust flag from Phase 3, structured so a
  future `teacher_author` role attaches without rework. **Do not** build teacher
  onboarding/RLS/login — only design the seams (documented).
- Update `AdminNav` to point "Content" at the new Studio; remove
  `ContentPipelinePanel` and now-dead card routes once parity is confirmed.
- Docs: short `docs/` page describing the Studio, the block model, the workflow,
  and the Milestone B seams.

Acceptance criteria:
- All authoring goes through the new Studio; the old card UI is gone; no dead
  routes/handlers remain (Guardian confirms no orphaned callers/handlers).
- Permission checks are centralized and ready for a teacher role (documented).

Guardian focus: nothing references removed components; every surviving route has a
caller; full `build` + `tsc` + tests green after removal.

---

## 6. Definition of done (Milestone A)

- Humans can author rich, Blackboard-style lessons and question banks entirely by
  hand, navigating the whole curriculum freely.
- AI is an optional assist that produces editable blocks, never an auto-publisher.
- Publishing is configurable (manual review **or** auto-approve) and always passes
  automated gates; every transition is audited and versioned.
- Content stays structured (extended block JSON); existing student Learn/Practice
  and Nex flows are unbroken.
- All Verification Gates green at every phase; old pipeline retired.

---

## 7. North star — Milestone B (DO NOT BUILD NOW; design must not preclude it)

Personalized/adaptive delivery on top of the structured content: use the existing
student-data layer (`topic_mastery`, `weak_topics`, `academic_health_scores`,
`diagnostic_results`, `practice_attempts`, exam countdown) to assemble
per-student revision/practice from L1 canonical content, with on-demand,
**cached** generation keyed by (concept + difficulty + misconception) so artifacts
are reused across similar students, and Nex chat (L3) reading the same blocks as
context. Keep block `id`s, structured schema, and clean service boundaries so this
plugs in without rework.
```
