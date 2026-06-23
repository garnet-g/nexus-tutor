# Authoring Studio

Nexus curriculum content is authored in the **Authoring Studio** at `/admin/studio`. The Studio replaces the legacy `/admin/content` card pipeline.

## Block model

Lessons are stored as structured JSON (`lessons.content`) validated by `lessonContentSchema`. Each lesson is an ordered list of typed blocks (heading, paragraph, rich text, example, tip, callout, image, table, math, chemical equation, comprehension passage, video, inline question, attachment, divider) plus an optional short quiz.

Block `id` fields are stable UUIDs assigned on read/save so future adaptive delivery (Milestone B) can reference individual blocks.

## Workflows

1. **Workspace** (`/admin/studio`) — browse the curriculum tree, manage subtopic lessons, edit topic question banks.
2. **Lesson editor** (`/admin/studio/[lessonId]`) — manual block editor with optional AI assist panel. Saves drafts only.
3. **Review queue** (`/admin/studio/review`) — approve, request changes, or archive items in `in_review`.
4. **Publishing** — submit for review → quality gates → manual approve or auto-approve (platform setting + per-content `author_auto_approve_trusted`). Publish snapshots land in `lesson_versions`.

Students only see `review_status = published` and `is_active = true` content (enforced by RLS).

## AI assist (optional)

The side panel calls `/api/admin/content/assist` with actions: draft lesson, expand section, simplify, rewrite block, generate questions. Output is returned to the editor as editable blocks/questions — **never** auto-published.

## Permissions (Milestone B seams)

| Seam | Today | Future |
|------|-------|--------|
| Role gate | `requireContentAuthor()` → `super_admin` | Add `teacher_author` to `CONTENT_AUTHOR_ROLES` |
| Ownership | `lessons.author_id`, `practice_questions.author_id` | Teacher RLS scoped to own drafts |
| Trust | `author_auto_approve_trusted` per row | Inherited from teacher profile |

Service entry point: `src/server/services/contentAuthorGuard.ts`.

## Key services

- `contentGenerationService` — model generation helpers + script-oriented draft persistence
- `contentAssistService` — non-persisting AI assist actions
- `contentApprovalService` — review state machine + versioning
- `contentQualityGates` — automated publish gates
- `contentStudioService` — workspace list/reorder/bulk save
