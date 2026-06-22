# Phase 7 — bulk DRAFT generation (Math + English). Paste the block into Cursor.

---

You are the Orchestrator continuing milestone `v2-tier-2-kiswahili-chemistry`, **Phase 7**. Read first:
`.planning/milestones/v2-tier-2-kiswahili-chemistry/IMPLEMENTATION-PLAN.md` (Phase 7),
`.planning/milestones/v2-tier-2-kiswahili-chemistry/KCSE-SYLLABUS-SKELETON-MATH-ENGLISH.md` (§8 prod-ready bar),
and `STATUS.md`. Obey the hard rules in IMPLEMENTATION-PLAN §1 (additive, non-destructive, reuse services, **drafts never auto-publish**, Zod-validate, no new deps).

## Goal of this run
Mass-generate **DRAFT** lessons and question banks for **Mathematics (all Form 1–4 + CBC) and English (low-risk topics, all curricula)**, leaving everything as `is_active=false, review_status='draft'` in the review queue. **Do NOT publish anything. Do NOT run QA. Do NOT touch student-facing state** (the empty-node gate already hides drafts).

## Scope (generate drafts for these only)
- **Mathematics:** every active topic/subtopic for `subjects.code='mathematics'`, both CBC and KCSE. (Skip the deprecated `is_active=false` legacy topics automatically.)
- **English:** these topic codes only (low review burden): `reading_comprehension`, `study_skills`, `grammar`, `nouns_pronouns`, `verbs_tenses`, `phrases_clauses`, `voice_speech`, `prepositions_phrasal_verbs`, `question_tags_agreement`, `punctuation_mechanics`, `word_formation`, `writing_skills`, `functional_writing`, `official_documents`, `short_functional_texts`, `summary_writing` — both curricula.
- **DO NOT generate this run:** Chemistry, Kiswahili, English `creative_composition`/`essay_writing_skills`, and ALL Literature/set-text topics (`literary_appreciation`, `poetry`, `*_set_text`, `oral_*`). These need specialist review or the actual set-text source material; hold them for a later batch.

## Build a thin, additive batch runner (reuse, don't fork)
Create `scripts/generateDrafts.ts` (additive; `npm run content:generate-drafts`). It MUST:
1. Reuse the existing services `generateLessonDraft` and `generateQuestionBankDraft` from `src/server/services/contentGenerationService.ts` — do not write a second generation path or LLM client.
2. **Pre-flight, fail fast:** verify a real LLM key is configured (abort if `callNexModel` would run in mock mode — we will not seed mock content); verify Supabase reachable; resolve a `super_admin` user id for `adminId` (env `ADMIN_USER_ID`, else look up a `super_admin_profiles` row).
3. Accept args: `--subjects=mathematics,english`, `--curricula=CBC,KCSE`, `--topics=<csv|all>`, `--lessons-per-subtopic=1`, `--questions-per-difficulty=7` (→ 21/topic across easy/medium/hard), `--limit=<n>` (cap total topics this run), `--dry-run` (print the plan + estimated model-call count, generate nothing).
4. Derive `gradeLevel` per topic from `topics.min_grade_sort_order` → the curriculum's `grade_levels.code` (e.g. KCSE form_3).
5. **Idempotent / resumable:** skip a subtopic that already has any lesson (draft or published); skip a topic+difficulty that already meets the questions target. Safe to re-run.
6. Generate **drafts only** (the services already insert `is_active=false, review_status='draft'` and log to `content_generation_jobs`). Never call publish.
7. Throttle to avoid rate limits; on a per-item failure, log and continue (don't abort the whole run); print a final report.

## Run it
First `--dry-run` for the full scope and show me the plan + estimated number of model calls and rough cost. **Then run for real** in waves and checkpoint: Math KCSE Form 1 → 2 → 3 → 4, then Math CBC, then English KCSE, then English CBC. Defaults: 1 lesson/subtopic, 21 questions/topic.

## Stop conditions / report back
- Do NOT publish, do NOT export seeds, do NOT run Phase 8.
- When done, give me a table: per subject → topics processed, lessons drafted, questions drafted, failures (with reasons), and any topics that errored and need a retry.
- Remind me these are all drafts awaiting review in `/admin/content`, and that nothing is student-visible until I review→publish and a topic crosses the prod-ready bar.

## Guardrails (restate)
Reuse existing services; additive only; Zod validation already enforced; **never auto-publish**; do not generate the held subjects/topics above; do not modify existing seed files or published rows.
