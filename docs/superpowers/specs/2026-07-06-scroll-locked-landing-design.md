# Scroll-Locked Storytelling Landing Page

**Date:** 2026-07-06
**Status:** Approved by user (brainstorming session)
**Replaces:** the current reveal-on-scroll landing page at `src/app/(public)/page.tsx`

## Concept

The landing page becomes a playable diagnosis. Scroll = time: pinned scenes turn the
reader's scroll wheel into a scrubber that plays each scene forward and backward. The
reader drives one student's session the same way Nex reads it, and the moment the
diagnosis resolves, the page "unlocks" (final section scrolls normally) as the release
of tension.

This page lives at `/` (replaces the current home). A separate conversion-focused
marketing page may be built later at its own route; it is out of scope here.

## Decisions locked during brainstorming

1. **Placement:** replaces `/` home.
2. **Interactivity:** scroll drives everything — no click/tap moments. Works identically
   on mobile.
3. **Engine:** hand-rolled, zero new dependencies. `position: sticky` pinning + a scroll
   progress hook writing a `--p` CSS variable. No GSAP, no Framer Motion.
4. **Script:** existing 6 beats re-cut into 3 pinned scenes + 1 unpinned release.
5. **Voice:** all copy is student-facing. No internal/dev jargon on the public page.
   Never say "Socratic" — just "tutor". No "control room", "weak-topic queue",
   "mastery shift". Say what the student experiences.

## Scene lineup

### Scene 1 — Hero: "the one thing" (pinned, ~200vh)

Opens visually as today (headline, subhead, CTAs, Nex card). As the reader scrolls:

- A faint constellation of school-topic words (Quadratic graphs, Moles and ratios,
  Set-book evidence, etc.) scatters and fades until **one** topic remains, glowing
  amber — demonstrating "Revise the one thing. Not everything."
- Eyebrow copy changes from "AI revision control room" to **"Your AI tutor for KCSE"**.
- Subhead (student voice): "Nexus looks at how you study, finds the exact mistake
  costing you marks, and shows you what to fix next."
- A subtle scroll cue signals the page responds to scrolling.

### Scene 2 — The Session (pinned, ~450vh, centerpiece)

The old "slow-down" + "diagnosis" beats merged into one continuous scene on a single
screen. Scrub sequence:

1. Student line writes on: "I keep losing marks in simultaneous equations when there
   are fractions."
2. The working appears: `½x + ⅓y = 7`, and the student's **wrong first attempt writes
   itself out, then gets struck through in orange**.
3. Nex asks: "Don't rush to the answer. What one multiplication clears every fraction
   at once?"
4. Student: "Multiply everything by 6."
5. An orange hand-drawn SVG stroke **circles the fractions** in the original working
   (stroke-dashoffset driven by scroll).
6. The working recedes; **"6 marks"** counts up 0→6 (JS via render-prop progress),
   framed as marks found: "That's 6 marks you were giving away. It was never algebra.
   You just needed to clear the fractions first."

Section frame copy: "It doesn't just give you the answer. It finds the mistake."

Scrolling backwards rewinds the entire diagnosis.

### Scene 3 — Your marks, your years (merged System + Arc, pinned, ~350vh)

One pinned scene in two movements:

**Movement A — the panel assembles.** The cream repair panel from the current page,
re-copied for students:

- "Active weak-topic queue" → **"Topics still costing you marks"**
- "Mastery shift" → **"Marks won back"**
- "Predicted grade" stays (students know this term)
- Bars fill to their percentages one after another; then the fixed topic **sinks to the
  bottom of the list** and the marks-won-back number ticks up.

**Movement B — pull back to the years.** The panel shrinks/recedes and the Form 1→4
spine draws downward with scroll; each stage ignites as the line reaches it:

- Form 1 — "Build strong basics"
- Form 2 — "Connect the topics"
- Form 3 — "Fix the gaps before mocks"
- Form 4 — "Walk into KCSE ready"

Frame: "Every session fixes something. And it stays with you."

### Scene 4 — Release (NOT pinned)

Scrolls normally, on purpose — the release of scroll-tension closes the story. Existing
copy unchanged: "11 days to the mock" / "This time you walk in knowing exactly what you
fixed." + signup CTA.

## Architecture

All new files live in the existing `src/app/(public)/_landing/` folder.

- **`ScrollScene.tsx`** (client): the one reusable engine. Renders a tall section
  (`height: N * 100vh`) containing a sticky stage (`position: sticky; top: 0;
  height: 100dvh`). A passive scroll listener, throttled with rAF, computes scene
  progress 0→1 and (a) writes it to a `--p` CSS variable on the stage and (b) exposes
  it via render-prop for JS-driven bits (the count-up number).
- **`phase.ts`**: tiny util `phase(p, start, end)` mapping global scene progress to a
  local 0→1 window, so "circle draws from 55%→70% of the scene" is one expression.
- **Scene components:** `SceneHero.tsx`, `SceneSession.tsx`, `SceneMarksAndYears.tsx`
  (client). The final release section stays server-rendered.
- **`page.tsx`** remains a thin server component composing the scenes. Copy constants
  stay in/near `page.tsx` or move alongside their scene component.
- `Reveal.tsx` remains for the unpinned release section.

## Guardrails

- **Reduced motion / pre-hydration:** with `prefers-reduced-motion: reduce` (or before
  JS loads), pinning is disabled: sections collapse to natural height and render their
  **final** state. The page reads as clean static editorial; nothing is lost but motion.
- **Mobile:** sticky + `100dvh` works natively on iOS/Android. Scene scroll distances
  shorten on small viewports. Each scene's content fits one viewport by design.
- **Performance:** animate only `transform`, `opacity`, `clip-path`, and SVG
  `stroke-dashoffset` — all compositor-friendly. One passive scroll listener per pinned
  scene. No layout-triggering properties in any scrubbed animation.
- **Aesthetic constraints (standing user preferences):** dark cinematic, continuous
  gradients with no visible section seams, single amber accent `#e0883b` on charcoal
  `#171814`→`#0e0f0c`, no trust bars, no 3-card grids, no em-dashes in copy, Geist
  typography.

## Test impact

`tests/marketing/landingPagePositioning.test.ts` currently pins `"AI revision control
room"` and `"weak-topic"` — both are jargon this redesign removes. The guard must be
updated in the same change to pin the new student-friendly positioning (e.g. "Your AI
tutor for KCSE", "Topics still costing you marks") while keeping the existing
protections: `Form 1`, `Form 4`, `mock exam` must appear; `PILLARS.map`,
`md:grid-cols-3`, and the generic tagline stay banned.

## Verification plan

- Drive the page in the preview browser: scrub to key scroll positions and snapshot
  each scene state (hero collapse, strike-through, circle draw, count-up, queue
  reorder, spine draw, release).
- Check `prefers-reduced-motion` renders the static final-state page.
- Check mobile viewport (375×812) for fit and scroll feel.
- Run the updated positioning test and the existing vitest suite.
