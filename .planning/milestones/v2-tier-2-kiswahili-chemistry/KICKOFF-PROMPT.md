# Cursor kickoff prompt — paste the block below into Cursor

---

You are the **Orchestrator** for the Nexus Agent Orchestra (see `AGENTS.md`). Execute the milestone **`v2-tier-2-kiswahili-chemistry`** end to end.

## Source of truth — read these IN FULL before doing anything; they override your assumptions
- `.planning/milestones/v2-tier-2-kiswahili-chemistry/IMPLEMENTATION-PLAN.md`
- `.planning/milestones/v2-tier-2-kiswahili-chemistry/KCSE-SYLLABUS-SKELETON-MATH-ENGLISH.md`
- `.planning/milestones/v2-tier-2-kiswahili-chemistry/STATUS.md`
- `AGENTS.md` and the role playbooks in `.planning/agents/`
- Before ANY route/page code, read the relevant guide in `node_modules/next/dist/docs/` — this Next.js differs from your training data.

## Goal
Add **Kiswahili** + a **standalone Chemistry** subject; fill **Math + English to the full KCSE syllabus**; unlock the content pipeline + Nex tutor for the new subjects; add additive lesson block types; and gate visibility so **no empty node ever reaches a student**. Scope = backend + seed + UI surfacing + Nex unblock. **Do NOT generalize the Math-only engines** (diagnostics / mock-exam / revision hub).

## Hard rules (violating any → stop and fix)
- **Purely additive, non-destructive.** Only `INSERT ... ON CONFLICT`, `ALTER ... ADD COLUMN IF NOT EXISTS`, new files/constants/union members, appended allow-lists. NEVER `DROP`/`DELETE`/`TRUNCATE`/`UPDATE` existing content rows, rename a `code`, change a column type, or edit a committed migration.
- **Do not modify** `supabase/seed/curriculum_math.sql`, `curriculum_science.sql`, `curriculum_english.sql`, or existing rows in `seed.sql`. New content goes in NEW files.
- **Never rename/delete an existing topic or subtopic `code`** (they are FK-by-value). Existing codes are listed in the skeleton doc §4 — keep verbatim.
- **No new dependencies.** Reuse `callNexModel`, the admin shell + super-admin guard, shared UI primitives, and the existing draft/publish/export services.
- **Do not invent syllabus content.** Use ONLY the topic/subtopic lists in the docs. If a fact you need is not in the docs, STOP and ask.
- Drafts never auto-publish; RLS stays `is_active=true` for students; visibility gating is DERIVED from published-content counts (never set unready topics `is_active=false` — that breaks generation).

## Execution — one phase at a time, in order
`Phase 0 → 1 → 2 → 3 → 4 → 5 → 6 → 6.5 → 7 → 8` (defined in IMPLEMENTATION-PLAN; the Math/English skeleton extends Phase 1; empty-node gating is Phase 6.5).

For each phase: **Planner** confirms the file allowlist + criteria against the plan → **Coder** implements ONLY within that allowlist → run `npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build` and fix until green → **QA** verifies that phase's Verification block → commit with a message referencing the phase → update `STATUS.md`. Do not start the next phase until the current one is green and committed. Write a `CODER-CHANGELOG.md` and `QA-REPORT.md` per phase using `.planning/templates/`.

## Human gates — STOP and ask me; do not proceed autonomously past these
1. **Phase 1 skeleton sign-off.** Before committing the subject/topic/subtopic seeds (Kiswahili, Chemistry, and the KCSE Math/English fill-out), present the full topic + subtopic lists you will seed (from the docs) and the **English set-text titles** you need from me. Do NOT invent set-text titles. Wait for my confirmation.
2. **Phase 7 content generation.** Build and verify the generate→review→publish→export loop on ONE sample topic per new subject, but do NOT mass-generate or publish content without me. Phase 6.5 (empty-node gating) MUST be live first so nothing half-built shows to students.

## First action
Read the three milestone docs + `AGENTS.md`, then give me a **one-screen execution summary** — the phase list, the two human gates, and exactly what you need from me for Phase 1 — BEFORE writing any code.
