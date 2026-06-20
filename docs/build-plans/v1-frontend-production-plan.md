# V1 Front-End Production Plan (for an implementation agent)

**Owner:** Garnet (product) · **Reviewer:** architect (will review the diff against this spec)
**Status:** Ready to implement · **Scope authority:** [mvp-feature-scope-lock.md](../product-governance/mvp-feature-scope-lock.md)
**Goal:** Take the student app from "functional prototype" to a polished, premium V1 product — without expanding scope.

> **You are implementing into an existing Next.js 16 / React 19 / Tailwind v4 / Supabase app.** Read before writing. Reuse what exists. Do not invent APIs, do not hardcode colors, do not add features the scope lock bans. Every phase has acceptance criteria the reviewer will check.

---

## 0. Read these first (do not skip)

Before any code, open and understand:

- Design system & tokens: [`docs/phase-4-ux/design-system.md`](../phase-4-ux/design-system.md) and `src/app/globals.css` (the emerald token system — `@theme inline` maps `--color-nexus-*`, fonts `--font-display` Fraunces / `--font-sans` Hanken, shadows `--shadow-card|float|nex`).
- Coding standards: [`docs/phase-5-engineering-governance/coding-standards.md`](../phase-5-engineering-governance/coding-standards.md).
- **Scope lock (hard limits): [`docs/product-governance/mvp-feature-scope-lock.md`](../product-governance/mvp-feature-scope-lock.md) §2 (in), §3 (banned).**
- Existing shell & components you MUST reuse:
  - `src/components/student/StudentAppShell.tsx` (sidebar, top bar, ⌘K, mobile nav)
  - `src/components/student/CommandPalette.tsx`
  - `src/components/NexMark.tsx`, `src/components/widgets/StatWidgets.tsx` (`GoalRing`, `StreakHeatmap`, `MiniStat`), `src/lib/gamification.ts`
  - `src/components/ui/Button.tsx` (Base UI — uses `render={<Link/>}` prop, variants: default/primary/outline/secondary/ghost/link), `src/components/ui/Card.tsx`
  - `src/components/icons.tsx` (inline) — but `lucide-react` is available and used across the app; prefer lucide for utility icons.
- Existing server services (DO NOT rewrite — call them):
  - `curriculumService`: `getSubjectsForStudent(curriculum, gradeLevel)`, `getTopics(subjectId, curriculum, gradeLevel)`, `getTopicDetail(...)`, `getLesson(...)`
  - `practiceService`: `startPracticeSession`, `submitPracticeAnswer`, `completePracticeSession`, `getProgressSummary(studentId)`, `listPracticeTopics(curriculum)`
  - `diagnosticService`: `getLatestHealthScore(studentId)`
  - `studyPlanService`: `getActiveStudyPlan(studentId)`, `generateStudyPlanForStudent(...)`
  - `nexUsageService`: `getNexDailyUsageCount`, `getPracticeDailyUsageCount`, `getStudentPlanCode`
  - `weeklyReportService`: `generateWeeklyReportForLink(...)`
  - **Confirm each function's exact params/return type at the source before calling.** Do not guess shapes.
- Existing feature components to extend (not replace): `src/features/learn/components/LearnSubjectExplorer.tsx`, `src/features/nex/components/NexChatPanel.tsx`, `src/features/dashboard/components/*`.

---

## 1. Global guardrails (apply to every change)

1. **Scope.** Build ONLY V1 in-scope features (§2 of scope lock). Mathematics only. If a task seems to require a banned feature (§9 list below), STOP and leave a `// SCOPE-FLAG:` comment + note in your summary. Do not scaffold or stub banned features.
2. **Tokens, never hex.** Use `bg-nexus-*`, `text-nexus-*`, `shadow-card|float|nex`, `font-display`, `font-heading`, `tabular`. No raw hex in components. Dark mode must keep working (tokens already invert under `.dark`).
3. **Server Components by default.** Add `"use client"` only on leaf components that need interactivity. Data fetching stays in server components / services. Props down, callbacks up.
4. **Types.** Strict TS, explicit return types on exported functions, no `any` (use `unknown` + Zod). Reuse existing types from `src/types`, `src/schemas`.
5. **A11y.** Keyboard-operable, visible focus rings, `aria-current` on active nav, labelled controls, touch targets ≥48px, respects `prefers-reduced-motion`.
6. **Mobile-first.** Everything must work and look intentional at 375px, then scale up. No content stranded in empty desktop columns — use the right max-widths and multi-column composition.
7. **No new dependencies without flagging.** If you believe one is needed (see §8), add a `// DEP-FLAG:` note and justify; do not silently install. Charts/sparklines: build as lightweight inline SVG components (consistent with `GoalRing`/`StreakHeatmap`) — no chart library.
8. **Done = green.** After each phase run `npm run lint`, `npm run typecheck`, `npm test`, and `npm run test:scope-check`. The whole task must end with `npm run deploy:check` passing. Do not mark complete on red.
9. **Small commits** per phase with clear messages. Do not commit secrets. Do not force-push.

---

## 2. Shared foundation (build first — Phase 0)

These primitives are reused by every later phase. Put shared UI in `src/components/ui` or `src/components/widgets`.

- **`Skeleton`** (`src/components/ui/Skeleton.tsx`): token-based shimmer block; variants for text line, card, ring. Use in every async route's `loading.tsx`.
- **`EmptyState`** (`src/components/ui/EmptyState.tsx`): icon/illustration slot, title, body, primary + secondary CTA. Replace every bare "No X yet" text. Warm, inviting copy.
- **`Toast`** provider (`src/components/ui/Toast.tsx`, client): minimal context + `useToast()`; success/info/error tones using tokens. No dependency. Mount once in the student shell.
- **`StatTile` / `SectionCard`**: standardize the card pattern (`rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card`) so screens stop hand-rolling cards.
- **Inline SVG chart primitives** (`src/components/widgets/Charts.tsx`): `Sparkline`, `LineChart`, `RadarChart`, `BarMeter`, `ProgressRing` (generalize `GoalRing`). Pure SVG, token strokes, `prefers-reduced-motion` aware.
- **Motion utilities**: subtle entrance (`fade+rise`, staggered) via CSS classes in `globals.css` (`tw-animate-css` is installed) — page sections rise in ~180ms; count-up + ring-fill on mount; hover lift on interactive cards. Respect reduced-motion.
- **Theme toggle** (`src/components/ThemeToggle.tsx`, client): toggles `.dark` on `<html>`, persists to `localStorage` (`nexus-theme`), respects system default on first load. Add to the shell top bar and Profile.
- **`loading.tsx` + `error.tsx`** for each student route group using `Skeleton`/`EmptyState`.

**Acceptance:** these render in isolation, are token-only, reduced-motion safe, and used by ≥2 later phases.

---

## 3. Phase A — Learn + lesson experience (in scope)

Current state: `learn/page.tsx` → `LearnSubjectExplorer`; topic and lesson routes exist (`learn/[topicId]`, `learn/[topicId]/[lessonId]`) backed by `curriculumService.getTopics/getTopicDetail/getLesson`. Math only.

Build:

1. **Subject header**: per-subject `ProgressRing` showing aggregate mastery (derive from `getProgressSummary().topicMastery`). For V1 there is effectively one active subject (Mathematics); design so additional subjects (greyed "Coming in V2") could slot in but are NOT activated.
2. **Topic cards** (`LearnSubjectExplorer` upgrade): each card shows topic title, CBC **strand** tag, lesson count, estimated minutes, a mastery `ProgressRing` (or `BarMeter`), and a clear state — *Not started / In progress / Mastered*. Hover lift, full-card tap target, `ArrowRight` affordance.
3. **Topic detail = a learning path**: render the topic's lessons as an ordered vertical path (nodes connected by a rail): each lesson node shows status (locked/available/done), title, type (Notes / Worked examples / Short quiz), and minutes. End node = **mastery checkpoint** (the lesson's short quiz). Mature visual style — not childish. Mobile = single column path; desktop = path on the left, sticky topic summary card (mastery, "Practise this topic", "Ask Nex about this topic") on the right.
4. **Lesson reader** (`learn/[topicId]/[lessonId]`): clean reading column (max ~66ch), `font-display` title, token typography. Render notes + worked examples from `getLesson(...)`. Features:
   - **Key-formula / callout** styling for emphasised blocks.
   - **Step-reveal** worked examples (each step expandable; "show next step").
   - **Inline "Ask Nex about this"** affordance on each section/paragraph → deep-links to `/nex?topicId=...&mode=explain` (Nex already accepts `topicId` + `mode` via search params). No new Nex capability — just pre-fills context.
   - **End-of-lesson short quiz** (uses existing lesson quiz data) → on pass, mark progress and surface a "Continue to next lesson" CTA.
   - **Bookmark** + **resume**: persist last-read lesson per topic (server if a table exists; otherwise `localStorage` keyed by student — flag if unsure).
   - Sticky lightweight progress bar (lesson N of M) + prev/next.
5. **Loading/empty/error**: skeletons for topic/lesson; `EmptyState` if a topic has no lessons seeded yet.

**Acceptance:**
- Topic tree browsable for the student's curriculum; lessons render notes + examples (scope §5).
- Mastery rings reflect real `getProgressSummary` data.
- "Ask Nex about this" deep-links with topic context and does not add any banned Nex mode.
- Reader is readable at 375px and composed (not empty) on desktop. Keyboard + reduced-motion safe.

---

## 4. Phase B — Practice session + results (in scope)

Current state: `practice/page.tsx` lists topics; services `startPracticeSession`, `submitPracticeAnswer`, `completePracticeSession` exist. Free = 3 sessions/day (read from `getEffectiveSubscriptionConfig`), 10 questions per session.

Build:

1. **Practice landing**: topic picker (cards w/ mastery + difficulty selector Easy/Medium/Hard), daily-usage meter ("2 of 3 free sessions left today" from `getPracticeDailyUsageCount` + config). If limit reached → `EmptyState` with upgrade CTA (no hard paywall on core access — respect "freemium forever").
2. **Session runner** (`"use client"`, e.g. `src/features/practice/components/PracticeRunner.tsx`):
   - One question at a time; top progress bar (Q n/10) + optional per-question timer (display only).
   - Answer entry (MCQ and/or input per question schema). **Confidence chip** (Guessing / Unsure / Confident) before submit — store with the answer if the schema supports it; otherwise omit (flag).
   - On submit → call `submitPracticeAnswer`; show **instant feedback**: correct/incorrect with token semantic colors, the worked reason, and an **"Explain with Nex"** deep-link (`/nex?...&mode=explain`).
   - Smooth transition to next; no full-page reloads.
3. **Results screen**: final score (count-up), per-topic/sub-skill breakdown (`BarMeter`), **mastery delta** vs previous, **XP earned** with a tasteful count-up/celebration (reduced-motion: static), and CTAs: "Review mistakes with Nex", "Practise again", "Back to Today". Use `completePracticeSession` output.
4. **Review queue (light spaced-repetition)**: surface previously-missed questions as a "Review (N)" entry on the practice landing. Keep it simple and within existing data; if no store exists for missed-question recall, implement minimal persistence or flag. **Do NOT** build a separate SRS engine — keep V1-minimal.

**Acceptance:**
- Session = 10 questions, difficulty selectable; results show score + weak areas; mastery updates (scope §5).
- Daily free-session cap enforced in UI and reflects server count.
- Instant feedback + Nex deep-link work; XP/level reflect on dashboard you-strip after completion.

---

## 5. Phase C — Nex chat polish (in scope: text, 4 modes only)

Current state: `nex/page.tsx` → `NexChatPanel` (props: `initialMode`, `topicId`, `cameraEnabled`, `voiceEnabled`, `learningPreferences`). **Read `NexChatPanel.tsx` fully before changing.** Modes in scope: Explain, Practice, Homework, Revision. **Assessment mode, camera, voice = V2 BANNED** — leave existing gated affordances as-is (they already show "Premium/Upgrade"); do not activate or expand them.

Build (presentation only — do not change tutoring/limit logic):

1. **Mode selector as cards/segmented control** (replace the dropdown): 4 mode chips with icon + one-line description; clear active state in `nexus-primary`.
2. **Rich message rendering**: render Markdown safely; **math via KaTeX** (see DEP-FLAG §8) for inline/blocked LaTeX; code/quote/list styling; preserve Nex bubble style (`bg-nexus-primary-soft`, `--shadow-nex`, `NexMark`). Student bubble = `bg-nexus-primary text-nexus-text-inverse`.
3. **Thinking state**: use the existing `nex-think` shimmer (not a spinner).
4. **Suggested follow-up chips** under Nex's latest message ("Give me a hint", "Show an example", "Quiz me on this", "Explain differently") that insert the prompt — within existing message flow and daily limits.
5. **Warm empty state**: when no messages, show `NexMark` + a grid of starter prompts (mode-aware) instead of a blank panel.
6. **Daily-limit UI**: show remaining free Nex messages (from `getNexDailyUsageCount` + config) and a graceful capped state with upgrade CTA + reset time (`getSecondsUntilNairobiMidnight`). Enforcement stays server-side; UI only reflects it.
7. **Math scratchpad** (optional, in scope as a UI aid): a collapsible local notepad/whiteboard for the student's own working. Local only; no new backend. Skip if time-boxed.

**Acceptance:**
- 4 text modes selectable; homework gating and limits unchanged; math renders correctly; no camera/voice/assessment activation; empty state is inviting. Logged-message behavior untouched.

---

## 6. Phase D — Progress + data viz + badges (in scope)

Current state: `progress/page.tsx` already richer (health score, streak, XP, subject scores, topic mastery, badges). Upgrade to premium data presentation using the §2 chart primitives.

Build:

1. **Health score trend** `LineChart` over time — only if historical points exist (e.g., diagnostic + practice snapshots). **If no time-series source exists, do NOT fabricate** — show current score with context and a "trend appears as you practise" note. Confirm data availability first.
2. **Subject/topic `RadarChart`** of mastery across topics (from `getProgressSummary().topicMastery`).
3. **Topic mastery** `BarMeter` list with status pills (Needs work / Developing / Mastered) using semantic tokens.
4. **Streak heatmap** (reuse `StreakHeatmap`) + best streak.
5. **XP / level** progression (reuse `gamification.ts`) with next-level bar.
6. **Badges**: render earned vs locked with real unlock state (diagnostic, first practice, 7-day streak per scope §5). Earned badges get a subtle unlock treatment; locked are greyed with criteria tooltip. Minimal gamification only — **no leaderboards**.
7. **Weekly report view** (in-app): present the data behind `weeklyReportService` as a clean, shareable summary card (study time, score, weak topics, activity). Email sending stays server-side; this is the in-app view.

**Acceptance:** all charts are token-only inline SVG, reflect real data, degrade gracefully when sparse, and are reduced-motion safe. No fabricated trends. No leaderboard.

---

## 7. Phase E — Study Plan, Profile, Pricing/Subscription polish (in scope)

1. **Study Plan** (`study-plan/page.tsx`): present `getActiveStudyPlan` as a real plan — today's tasks as an interactive checklist, daily-goal `GoalRing`, exam-countdown card (premium/trial gating per config). "Generate daily plan" / "Generate exam plan" call existing actions; show loading + success `Toast`. Replace bare empty text with `EmptyState`.
2. **Profile**: clean account section, edit form polish, learning-preferences UI (within existing schema), theme toggle, plan/usage summary, sign-out. Keep existing server actions.
3. **Pricing / Subscription**: premium cards read **live** values from the plans API/config (never hardcode amounts — scope rule), clear Free vs Premium vs Family comparison, M-Pesa checkout entry preserved. Trial CTA (7-day) where applicable.

**Acceptance:** amounts come from config/API; gating matches scope launch defaults; forms keep working; consistent shell + tokens.

---

## 8. Dependencies & technical notes

- **KaTeX** (Nex math): recommended new dependency `katex` (+ minimal React rendering, or `rehype-katex`/`remark-math` if you introduce a markdown pipeline). `// DEP-FLAG:` it, justify (a math tutor needs correct math), security-check, and document. **Fallback if not approved:** render LaTeX in a styled monospace block (degraded but safe). Do not block the phase on this.
- **No chart library.** Build inline SVG primitives (§2).
- **No confetti library.** If you want a celebration moment, do it with a small CSS/SVG burst, reduced-motion aware. Optional.
- **Toasts/skeletons/empty states:** hand-built, token-based. No new deps.

---

## 9. SCOPE GUARDRAILS — do NOT build in V1 (per scope lock §3)

Leave a `// SCOPE-FLAG:` if any task drifts toward these. Do not scaffold or stub:

- AI **Mock Exams**, **Exam Simulator** (and any "exam bank of past papers" experience) — **V2**.
- **Ask Nex with Camera**, **AI Voice Tutor** — **V2** (existing gated affordances stay gated; do not activate).
- **Nex in-chat Assessment Mode** — **V2** (onboarding diagnostic is the V1 assessment).
- **Leaderboards** — **V2**.
- **Science / English / Kiswahili active content** — **V2** (Math only; you may style "coming soon" but not activate).
- Teacher dashboards, school portals, study groups, career/university planners — **V2**.

> The existing routes `exam-prep`, `mock-exams`, `exam-simulator`, `assignment-help` appear to pre-date or stretch the scope lock. **Do not deepen them.** Flag them for the reviewer; leave behavior as-is unless told otherwise.

**Pending product decision (reviewer/owner will resolve):** whether to formally expand V1 to include an Exam Bank / mock-exam experience. If approved, it ships as a separate spec with its own scope-lock update (§7 process) — NOT as part of this pass.

---

## 10. Definition of Done (reviewer checklist)

The reviewer (architect) will check the diff against all of the below. Self-verify before handing back:

- [ ] `npm run deploy:check` passes (lint + typecheck + test + build) and `npm run test:scope-check` is green.
- [ ] No raw hex in components; all colors via `nexus-*` tokens; dark mode verified on every new screen.
- [ ] No `"use client"` on data-fetching components; client only on interactive leaves.
- [ ] Reused `StudentAppShell`, `NexMark`, `GoalRing`/`StreakHeatmap`, `Button`/`Card`, `gamification.ts`, and the new Phase-0 primitives — no duplicate shells/navs/cards.
- [ ] Every async route has `loading.tsx` (skeleton) and a sensible `error.tsx`; every empty state uses `EmptyState` with warm copy + CTA.
- [ ] Real data only — no fabricated charts/trends; sparse states degrade gracefully.
- [ ] 375px works for every screen; desktop is composed (no stranded narrow columns); touch targets ≥48px; visible focus; `prefers-reduced-motion` respected.
- [ ] **Zero V1-banned features** added/stubbed; all drift left as `// SCOPE-FLAG:` with notes.
- [ ] New deps limited to approved `// DEP-FLAG:` items, justified + documented.
- [ ] Short, scoped commits; summary lists files changed per phase + any flags/assumptions.

## 11. Suggested order & branching

`phase-0-foundation` → `phase-a-learn` → `phase-b-practice` → `phase-c-nex` → `phase-d-progress` → `phase-e-plan-profile-pricing`. One branch/PR per phase if possible (easier review); otherwise clearly delimit phases in the summary. Hand back after Phase 0 + Phase A for an early review checkpoint before continuing.
