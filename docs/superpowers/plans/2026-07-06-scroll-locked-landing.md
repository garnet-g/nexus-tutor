# Scroll-Locked Storytelling Landing Page Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Replace the reveal-on-scroll landing page at `/` with a scroll-locked storytelling page: three pinned scenes the reader scrubs through (Hero collapse, The Session diagnosis, Marks + Years) followed by an intentionally unpinned release section.

**Architecture:** One reusable client component (`ScrollScene`) implements pinning via `position: sticky` and maps section scroll progress to a 0→1 value exposed through a render prop (and a `--p` CSS variable). Each scene is a self-contained client component that derives per-element animation timing from that progress with a pure `phase()` window function. `page.tsx` stays a thin server component composing scenes. Zero new dependencies.

**Tech Stack:** Next.js 16 App Router (this repo ships a MODIFIED Next.js — follow existing patterns in `src/app/(public)/` exactly; check `node_modules/next/dist/docs/` before using any Next API not already used there), React 19 client components, Tailwind v4, vitest + @testing-library/react (jsdom).

**Spec:** `docs/superpowers/specs/2026-07-06-scroll-locked-landing-design.md`

## Global Constraints

- **Zero new dependencies.** No GSAP, no Framer Motion. Hand-rolled sticky + rAF only.
- **Student voice, zero internal jargon** in any user-visible copy: never "Socratic", "control room", "weak-topic", "mastery". Nex is "your tutor".
- **No em-dashes in copy.** Use periods or commas.
- **Escape apostrophes in JSX text as `&apos;`** (ESLint `react/no-unescaped-entities` is enforced; see existing `Today&apos;s sprint` in git history).
- **Animate only compositor-friendly properties:** `transform`, `opacity`, `clip-path`, SVG `stroke-dashoffset`. Never width/height/top/left in scrubbed animations (the topic-bar `width` fills are the one sanctioned exception, matching the existing panel, since they animate rarely and on tiny elements).
- **Single accent** `#e0883b` on charcoal `#171814`→`#0e0f0c`; cream panel `#fffaf0`/`#d8cab4`; heading font class `font-heading`.
- **Reduced motion / no JS / pre-hydration:** scenes render unpinned, natural height, FINAL state (progress = 1).
- Site header is `sticky top-0` and `h-16` (4rem). Pinned stages use `top-16` + `h-[calc(100dvh-4rem)]`.
- Commands run from repo root. Tests: `npx vitest run <file>` (or `npm test` for all).

---

### Task 1: Unblock `position: sticky` + build the ScrollScene engine

`overflow-x: hidden` on an ancestor turns it into a scroll container, which silently breaks `position: sticky` for ALL descendants (this is why the site header already un-sticks today). `overflow-x: clip` clips without creating a scroll container. Fix the shell, then build the engine.

**Files:**
- Modify: `src/features/marketing/components/PublicShell.tsx` (line 19: `overflow-x-hidden` → `overflow-x-clip`)
- Create: `src/app/(public)/_landing/phase.ts`
- Create: `src/app/(public)/_landing/ScrollScene.tsx`
- Test: `tests/marketing/phase.test.ts`
- Test: `tests/marketing/scrollScene.test.tsx`

**Interfaces:**
- Consumes: `cn` from `@/lib/utils` (existing).
- Produces:
  - `phase(p: number, start: number, end: number): number` — maps scene progress to a local 0→1 window, clamped.
  - `ScrollScene` props: `{ length: number; lengthSm?: number; className?: string; children: (progress: number) => ReactNode }`. `length` is scene scroll length in viewport-heights (`3` = 300vh section). `lengthSm` overrides below 640px. `children` is a render prop receiving progress 0→1; it renders the pinned stage content. Progress is `1` whenever the scene is not pinned (reduced motion, no JS, jsdom).

- [ ] **Step 1: Write the failing tests**

Create `tests/marketing/phase.test.ts`:

```ts
import { describe, expect, it } from "vitest";

import { phase } from "@/app/(public)/_landing/phase";

describe("phase", () => {
  it("is 0 before the window opens", () => {
    expect(phase(0.1, 0.2, 0.5)).toBe(0);
  });

  it("is 1 after the window closes", () => {
    expect(phase(0.9, 0.2, 0.5)).toBe(1);
  });

  it("is linear inside the window", () => {
    expect(phase(0.35, 0.2, 0.5)).toBeCloseTo(0.5);
  });

  it("clamps exactly at the bounds", () => {
    expect(phase(0.2, 0.2, 0.5)).toBe(0);
    expect(phase(0.5, 0.2, 0.5)).toBe(1);
  });

  it("treats a degenerate window as a step", () => {
    expect(phase(0.3, 0.4, 0.4)).toBe(0);
    expect(phase(0.5, 0.4, 0.4)).toBe(1);
  });
});
```

Create `tests/marketing/scrollScene.test.tsx`:

```tsx
import { render, screen } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";

import { ScrollScene } from "@/app/(public)/_landing/ScrollScene";

function stubMatchMedia(matches: boolean) {
  window.matchMedia = vi.fn().mockReturnValue({
    matches,
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
  }) as unknown as typeof window.matchMedia;
}

afterEach(() => {
  vi.restoreAllMocks();
  // @ts-expect-error jsdom has no matchMedia; remove our stub between tests
  delete window.matchMedia;
});

describe("ScrollScene", () => {
  it("renders the final state (progress 1) under prefers-reduced-motion", () => {
    stubMatchMedia(true);
    render(<ScrollScene length={3}>{(p) => <p>progress:{p}</p>}</ScrollScene>);
    expect(screen.getByText("progress:1")).toBeDefined();
  });

  it("renders the final state when matchMedia is unavailable (no-JS-equivalent)", () => {
    render(<ScrollScene length={3}>{(p) => <p>progress:{p}</p>}</ScrollScene>);
    expect(screen.getByText("progress:1")).toBeDefined();
  });

  it("pins to a tall section and scrubs from the top when motion is allowed", () => {
    stubMatchMedia(false);
    vi.spyOn(Element.prototype, "getBoundingClientRect").mockReturnValue({
      top: 0,
      bottom: 2304,
      height: 2304,
      left: 0,
      right: 0,
      width: 0,
      x: 0,
      y: 0,
      toJSON: () => ({}),
    } as DOMRect);
    const { container } = render(
      <ScrollScene length={3}>{(p) => <p>progress:{p}</p>}</ScrollScene>,
    );
    const section = container.querySelector("section");
    expect(section?.style.height).toBe("300vh");
    // jsdom innerHeight is 768: scrollable = 2304 - 768, top = 0 → progress 0
    expect(screen.getByText("progress:0")).toBeDefined();
  });
});
```

- [ ] **Step 2: Run tests to verify they fail**

Run: `npx vitest run tests/marketing/phase.test.ts tests/marketing/scrollScene.test.tsx`
Expected: FAIL — cannot resolve `@/app/(public)/_landing/phase` and `.../ScrollScene`.

- [ ] **Step 3: Implement `phase.ts`**

Create `src/app/(public)/_landing/phase.ts`:

```ts
/**
 * Map scene progress (0..1) onto a local window so per-element timing reads
 * as one expression: phase(p, 0.2, 0.5) is 0 before 20% of the scene, 1
 * after 50%, and linear in between.
 */
export function phase(p: number, start: number, end: number): number {
  if (end <= start) return p >= end ? 1 : 0;
  return Math.min(1, Math.max(0, (p - start) / (end - start)));
}
```

- [ ] **Step 4: Implement `ScrollScene.tsx`**

Create `src/app/(public)/_landing/ScrollScene.tsx`:

```tsx
"use client";

import {
  useEffect,
  useRef,
  useState,
  type CSSProperties,
  type ReactNode,
} from "react";

import { cn } from "@/lib/utils";

interface ScrollSceneProps {
  /** Scene scroll length in viewport heights (3 renders a 300vh section). */
  length: number;
  /** Shorter length used below the 640px breakpoint. */
  lengthSm?: number;
  className?: string;
  /** Stage content, driven by scene progress 0..1. */
  children: (progress: number) => ReactNode;
}

const prefersStatic = () =>
  typeof window.matchMedia !== "function" ||
  window.matchMedia("(prefers-reduced-motion: reduce)").matches;

/**
 * Scroll-locked scene. Renders a tall section whose stage pins below the
 * site header (sticky) while the reader scrubs; progress 0..1 reaches the
 * stage as a --p CSS variable and the render prop.
 *
 * Before hydration, without matchMedia, or under prefers-reduced-motion the
 * scene renders unpinned at natural height in its FINAL state (progress 1),
 * so the page still reads as complete static editorial.
 */
export function ScrollScene({
  length,
  lengthSm,
  className,
  children,
}: ScrollSceneProps) {
  const sectionRef = useRef<HTMLElement | null>(null);
  const [progress, setProgress] = useState(1);
  const [vhLength, setVhLength] = useState<number | null>(null);

  useEffect(() => {
    if (prefersStatic()) return;
    const small = window.innerWidth < 640;
    setVhLength(small && lengthSm ? lengthSm : length);
  }, [length, lengthSm]);

  useEffect(() => {
    if (vhLength === null) return;
    const section = sectionRef.current;
    if (!section) return;

    let raf = 0;
    const update = () => {
      raf = 0;
      const rect = section.getBoundingClientRect();
      const scrollable = rect.height - window.innerHeight;
      const p =
        scrollable > 0 ? Math.min(1, Math.max(0, -rect.top / scrollable)) : 1;
      setProgress(Math.round(p * 1000) / 1000);
    };
    const onScroll = () => {
      if (!raf) raf = requestAnimationFrame(update);
    };

    update();
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    return () => {
      window.removeEventListener("scroll", onScroll);
      window.removeEventListener("resize", onScroll);
      if (raf) cancelAnimationFrame(raf);
    };
  }, [vhLength]);

  const pinned = vhLength !== null;

  return (
    <section
      ref={sectionRef}
      className={className}
      style={
        {
          height: pinned ? `${vhLength * 100}vh` : undefined,
          "--p": progress,
        } as CSSProperties
      }
    >
      <div
        className={cn(
          pinned && "sticky top-16 h-[calc(100dvh-4rem)] overflow-hidden",
        )}
      >
        {children(progress)}
      </div>
    </section>
  );
}
```

- [ ] **Step 5: Fix the sticky-breaking overflow on the shell**

In `src/features/marketing/components/PublicShell.tsx` line 19, change:

```tsx
    <div className="nexus-grain flex min-h-full flex-col overflow-x-hidden bg-background">
```

to:

```tsx
    <div className="nexus-grain flex min-h-full flex-col overflow-x-clip bg-background">
```

- [ ] **Step 6: Run tests to verify they pass**

Run: `npx vitest run tests/marketing/phase.test.ts tests/marketing/scrollScene.test.tsx`
Expected: PASS (8 tests).

- [ ] **Step 7: Commit**

```bash
git add src/app/(public)/_landing/phase.ts src/app/(public)/_landing/ScrollScene.tsx src/features/marketing/components/PublicShell.tsx tests/marketing/phase.test.ts tests/marketing/scrollScene.test.tsx
git commit -m "feat(landing): scroll-scene engine with sticky pinning and reduced-motion fallback"
```

---

### Task 2: SceneHero — the constellation collapses to one topic

**Files:**
- Create: `src/app/(public)/_landing/SceneHero.tsx`
- Modify: `src/app/globals.css` (add one keyframe after the existing `@keyframes nexShimmer` block, around line 381)
- Test: `tests/marketing/sceneHero.test.tsx`

**Interfaces:**
- Consumes: `ScrollScene` and `phase` from Task 1; `NexMark` from `@/components/NexMark`; `Button` from `@/components/ui/Button`.
- Produces: `export function SceneHero(): JSX.Element` — no props. Used by Task 5's `page.tsx`.

- [ ] **Step 1: Write the failing test**

Create `tests/marketing/sceneHero.test.tsx`:

```tsx
import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { SceneHero } from "@/app/(public)/_landing/SceneHero";

// jsdom has no matchMedia, so ScrollScene renders the static final state.
describe("SceneHero", () => {
  it("positions Nexus as a student-voiced tutor", () => {
    render(<SceneHero />);
    expect(screen.getByText("Your AI tutor for KCSE")).toBeDefined();
    expect(screen.getByText(/Revise the/)).toBeDefined();
    expect(screen.getByText("Fraction equations")).toBeDefined();
  });

  it("keeps both calls to action", () => {
    render(<SceneHero />);
    expect(screen.getByRole("link", { name: /Start your diagnosis/ })).toBeDefined();
    expect(screen.getByRole("link", { name: /See revision plans/ })).toBeDefined();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/marketing/sceneHero.test.tsx`
Expected: FAIL — cannot resolve `.../SceneHero`.

- [ ] **Step 3: Add the scroll-cue keyframe to `src/app/globals.css`**

Immediately after the closing brace of `@keyframes nexShimmer`, add:

```css
@keyframes nexusScrollCue {
  0% {
    transform: translateY(0);
    opacity: 0.9;
  }
  70% {
    transform: translateY(10px);
    opacity: 0.2;
  }
  100% {
    transform: translateY(10px);
    opacity: 0;
  }
}
```

- [ ] **Step 4: Implement `SceneHero.tsx`**

Create `src/app/(public)/_landing/SceneHero.tsx`:

```tsx
"use client";

import Link from "next/link";

import { NexMark } from "@/components/NexMark";
import { Button } from "@/components/ui/Button";

import { phase } from "./phase";
import { ScrollScene } from "./ScrollScene";

// Faint school-topic constellation that scatters as the reader scrolls,
// leaving one topic behind: the one this story is about.
const CONSTELLATION = [
  { label: "Quadratic graphs", left: "6%", top: "10%", drift: -46, start: 0.02 },
  { label: "Moles and ratios", left: "30%", top: "6%", drift: -34, start: 0.1 },
  { label: "Set-book evidence", left: "58%", top: "9%", drift: -52, start: 0.05 },
  { label: "Map work", left: "84%", top: "14%", drift: -30, start: 0.14 },
  { label: "Probability", left: "12%", top: "80%", drift: 44, start: 0.08 },
  { label: "Essay structure", left: "38%", top: "88%", drift: 38, start: 0.16 },
  { label: "Titration", left: "66%", top: "86%", drift: 50, start: 0.04 },
  { label: "Vectors", left: "88%", top: "74%", drift: 36, start: 0.12 },
];

export function SceneHero() {
  return (
    <ScrollScene length={2} lengthSm={1.6} className="relative">
      {(p) => {
        const collapse = phase(p, 0, 0.55);
        const focus = phase(p, 0.3, 0.7);
        const underline = phase(p, 0.55, 0.85);
        const cue = 1 - phase(p, 0.02, 0.12);

        return (
          <div className="relative flex h-full min-h-[calc(100dvh-4rem)] items-center overflow-hidden">
            <div className="absolute inset-0 bg-[radial-gradient(circle_at_8%_88%,rgba(224,136,59,0.22),transparent_34rem),linear-gradient(180deg,#1a1b16_0%,#171814_55%,#131410_100%)]" />
            <div className="nexus-scanline absolute inset-0 opacity-[0.12]" />

            <div
              aria-hidden
              className="pointer-events-none absolute inset-0 hidden sm:block"
            >
              {CONSTELLATION.map((word) => {
                const t = phase(collapse, word.start, word.start + 0.5);
                return (
                  <span
                    key={word.label}
                    className="absolute font-mono text-xs uppercase tracking-[0.2em] text-white/25"
                    style={{
                      left: word.left,
                      top: word.top,
                      opacity: 0.9 * (1 - t),
                      transform: `translateY(${word.drift * t}px)`,
                    }}
                  >
                    {word.label}
                  </span>
                );
              })}
            </div>

            <div className="relative mx-auto grid w-full max-w-[1280px] grid-cols-1 items-center gap-14 px-5 py-16 sm:px-8 lg:grid-cols-[1.06fr_0.94fr] lg:px-10">
              <div className="max-w-2xl">
                <div className="mb-9 flex items-center gap-3">
                  <NexMark size={36} />
                  <p className="text-[10px] font-semibold uppercase tracking-[0.28em] text-[#e0883b]">
                    Your AI tutor for KCSE
                  </p>
                </div>

                <h1 className="font-heading text-[clamp(3.2rem,8.4vw,6.8rem)] font-medium leading-[0.88] tracking-[-0.06em] text-[#fbf8f3]">
                  Revise the{" "}
                  <span className="relative whitespace-nowrap">
                    one thing.
                    <span
                      aria-hidden
                      className="absolute inset-x-0 bottom-[0.04em] h-[0.06em] origin-left bg-[#e0883b]"
                      style={{ transform: `scaleX(${underline})` }}
                    />
                  </span>
                  <span className="block text-white/45">Not everything.</span>
                </h1>

                <p className="mt-8 max-w-md text-lg leading-8 text-white/68">
                  Nexus looks at how you study, finds the exact mistake costing
                  you marks, and shows you what to fix next.
                </p>

                <div className="mt-9 flex flex-col gap-3 sm:flex-row">
                  <Button
                    render={<Link href="/signup" />}
                    className="min-h-12 rounded-none bg-[#fbf8f3] px-6 text-[#171814] transition-all duration-300 ease-[cubic-bezier(0.16,1,0.3,1)] hover:-translate-y-0.5 hover:bg-white"
                  >
                    Start your diagnosis
                    <span className="ml-3 flex size-6 items-center justify-center bg-[#171814] text-[#fbf8f3]">
                      &rarr;
                    </span>
                  </Button>
                  <Button
                    render={<Link href="/pricing" />}
                    variant="ghost"
                    className="min-h-12 rounded-none border border-white/15 px-6 text-white/78 transition-all duration-300 ease-[cubic-bezier(0.16,1,0.3,1)] hover:-translate-y-0.5 hover:bg-white/[0.06] hover:text-white"
                  >
                    See revision plans
                  </Button>
                </div>
              </div>

              <figure className="w-full max-w-md border border-white/12 bg-[#0f110e]/85 p-6 shadow-[0_30px_90px_rgba(0,0,0,0.45)] backdrop-blur-sm sm:p-7 lg:justify-self-end">
                <figcaption className="mb-6 flex items-center justify-between border-b border-white/10 pb-4">
                  <span className="flex items-center gap-2.5">
                    <NexMark size={22} />
                    <span className="text-xs font-semibold text-white/80">
                      Nex
                    </span>
                  </span>
                  <span
                    className="font-mono text-[10px] uppercase tracking-[0.2em]"
                    style={{
                      color: `rgba(224,136,59,${0.45 + 0.55 * focus})`,
                      textShadow: `0 0 ${16 * focus}px rgba(224,136,59,0.55)`,
                    }}
                  >
                    Fraction equations
                  </span>
                </figcaption>
                <p className="text-sm leading-6 text-white/45">
                  I keep dropping marks on fraction equations under time
                  pressure.
                </p>
                <p className="mt-5 text-[1.35rem] font-medium leading-8 tracking-[-0.01em] text-[#fbf8f3]">
                  Before any answer: what one move clears every denominator at
                  once?
                </p>
                <p className="mt-6 border-l-2 border-[#e0883b]/70 pl-4 text-xs leading-6 text-white/45">
                  Nex asks first. That question is where the lost marks hide.
                </p>
              </figure>
            </div>

            <div
              aria-hidden
              className="absolute bottom-6 left-1/2 flex -translate-x-1/2 flex-col items-center gap-2"
              style={{ opacity: cue }}
            >
              <span className="font-mono text-[10px] uppercase tracking-[0.24em] text-white/45">
                Scroll
              </span>
              <span className="relative h-8 w-px overflow-hidden bg-white/15">
                <span
                  className="absolute inset-x-0 top-0 h-3 bg-[#e0883b]"
                  style={{ animation: "nexusScrollCue 1.8s ease-out infinite" }}
                />
              </span>
            </div>
          </div>
        );
      }}
    </ScrollScene>
  );
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `npx vitest run tests/marketing/sceneHero.test.tsx`
Expected: PASS (2 tests).

- [ ] **Step 6: Commit**

```bash
git add src/app/(public)/_landing/SceneHero.tsx src/app/globals.css tests/marketing/sceneHero.test.tsx
git commit -m "feat(landing): pinned hero scene with topic constellation collapse"
```

---

### Task 3: SceneSession — the scrubbed diagnosis (centerpiece)

**Files:**
- Create: `src/app/(public)/_landing/SceneSession.tsx`
- Test: `tests/marketing/sceneSession.test.tsx`

**Interfaces:**
- Consumes: `ScrollScene`, `phase` from Task 1.
- Produces: `export function SceneSession(): JSX.Element` — no props. Used by Task 5's `page.tsx`.

Scrub timeline (progress windows within the scene):

| Window | Beat |
|--------|------|
| 0.00–0.08 | Frame heading rises |
| 0.06–0.16 | Student line 1 types on |
| 0.16–0.24 | Working card rises: `½x + ⅓y = 7` |
| 0.24–0.34 | Wrong attempt types on: `x + ⅓y = 14` |
| 0.36–0.44 | Orange strike-through draws across it |
| 0.40–0.48 | Caption fades: "Only the halves got cleared." |
| 0.48–0.58 | Tutor question rises |
| 0.58–0.66 | Student answer types on |
| 0.66–0.76 | SVG ellipses circle ½x and ⅓y |
| 0.78–0.86 | Conversation recedes (fades, slight scale-down) |
| 0.80–0.88 | Finale layer fades in |
| 0.82–0.94 | "6 marks" counts 0→6 |
| 0.88–0.97 | Closing line rises |

- [ ] **Step 1: Write the failing test**

Create `tests/marketing/sceneSession.test.tsx`:

```tsx
import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { SceneSession } from "@/app/(public)/_landing/SceneSession";

// jsdom has no matchMedia, so ScrollScene renders the static final state
// (progress 1): every beat of the session is present, counter at 6.
describe("SceneSession", () => {
  it("tells the full diagnosis in student voice", () => {
    render(<SceneSession />);
    expect(
      screen.getByText(/losing marks in simultaneous equations/),
    ).toBeDefined();
    expect(screen.getByText(/Multiply everything by 6/)).toBeDefined();
    expect(screen.getByText("6 marks")).toBeDefined();
    expect(
      screen.getByText(/You just needed to clear the fractions first/),
    ).toBeDefined();
  });

  it("frames Nex as a tutor that finds the mistake, no jargon", () => {
    render(<SceneSession />);
    expect(
      screen.getByText(/doesn't just give you the answer/i),
    ).toBeDefined();
    expect(screen.queryByText(/Socratic/i)).toBeNull();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/marketing/sceneSession.test.tsx`
Expected: FAIL — cannot resolve `.../SceneSession`.

- [ ] **Step 3: Implement `SceneSession.tsx`**

Create `src/app/(public)/_landing/SceneSession.tsx`:

```tsx
"use client";

import type { CSSProperties, ReactNode } from "react";

import { phase } from "./phase";
import { ScrollScene } from "./ScrollScene";

const rise = (t: number, dy = 18): CSSProperties => ({
  opacity: t,
  transform: `translateY(${(1 - t) * dy}px)`,
});

const typeOn = (t: number): CSSProperties => ({
  clipPath: `inset(0 ${(1 - t) * 100}% 0 0)`,
});

/** Hand-drawn orange ellipse that strokes itself around its children. */
function Circled({ t, children }: { t: number; children: ReactNode }) {
  return (
    <span className="relative inline-block px-1">
      {children}
      <svg
        aria-hidden
        className="absolute -inset-1 h-[calc(100%+0.5rem)] w-[calc(100%+0.5rem)] overflow-visible"
        viewBox="0 0 100 60"
        preserveAspectRatio="none"
      >
        <ellipse
          cx="50"
          cy="30"
          rx="47"
          ry="27"
          pathLength={1}
          fill="none"
          stroke="#e0883b"
          strokeWidth={2.5}
          strokeDasharray={1}
          strokeDashoffset={1 - t}
          strokeLinecap="round"
          vectorEffect="non-scaling-stroke"
          style={{ opacity: t > 0 ? 1 : 0 }}
        />
      </svg>
    </span>
  );
}

export function SceneSession() {
  return (
    <ScrollScene length={4.5} lengthSm={3.5} className="relative">
      {(p) => {
        const heading = phase(p, 0, 0.08);
        const student1 = phase(p, 0.06, 0.16);
        const working = phase(p, 0.16, 0.24);
        const attempt = phase(p, 0.24, 0.34);
        const strike = phase(p, 0.36, 0.44);
        const caption = phase(p, 0.4, 0.48);
        const question = phase(p, 0.48, 0.58);
        const student2 = phase(p, 0.58, 0.66);
        const circle = phase(p, 0.66, 0.76);
        const recede = phase(p, 0.78, 0.86);
        const finale = phase(p, 0.8, 0.88);
        const marks = Math.round(6 * phase(p, 0.82, 0.94));
        const closing = phase(p, 0.88, 0.97);

        return (
          <div className="relative flex h-full min-h-[calc(100dvh-4rem)] items-center overflow-hidden">
            <div className="absolute inset-0 bg-[linear-gradient(180deg,#131410_0%,#181915_100%)]" />

            <div
              className="relative mx-auto w-full max-w-3xl px-5 sm:px-8"
              style={{
                opacity: 1 - recede,
                transform: `scale(${1 - recede * 0.04})`,
              }}
            >
              <div style={rise(heading)}>
                <h2 className="font-heading text-[clamp(2rem,4.6vw,3.6rem)] font-medium leading-[0.95] tracking-[-0.05em] text-[#fbf8f3]">
                  It doesn&apos;t just give you the answer.
                  <span className="block text-white/45">
                    It finds the mistake.
                  </span>
                </h2>
              </div>

              <p
                className="mt-10 max-w-xl text-base leading-7 text-white/40 sm:text-lg sm:leading-8"
                style={typeOn(student1)}
              >
                I keep losing marks in simultaneous equations when there are
                fractions.
              </p>

              <div
                className="mt-7 max-w-md border border-white/12 bg-[#0f110e]/85 p-5 sm:p-6"
                style={rise(working)}
              >
                <p className="font-mono text-[10px] uppercase tracking-[0.2em] text-white/40">
                  Your working
                </p>
                <p className="mt-4 font-heading text-2xl tracking-[-0.01em] text-[#fbf8f3] sm:text-3xl">
                  <Circled t={circle}>½x</Circled> +{" "}
                  <Circled t={circle}>⅓y</Circled> = 7
                </p>
                <span className="relative mt-3 inline-block">
                  <span
                    className="font-heading text-xl text-white/55 sm:text-2xl"
                    style={typeOn(attempt)}
                  >
                    x + ⅓y = 14
                  </span>
                  <span
                    aria-hidden
                    className="absolute left-0 top-1/2 h-[2px] w-full origin-left bg-[#e0883b]"
                    style={{ transform: `scaleX(${strike})` }}
                  />
                </span>
                <p
                  className="mt-2 text-xs leading-5 text-[#e0883b]"
                  style={{ opacity: caption }}
                >
                  Only the halves got cleared.
                </p>
              </div>

              <p className="mt-10 flex gap-4 sm:gap-6" style={rise(question)}>
                <span className="mt-2 hidden h-px w-10 shrink-0 bg-[#e0883b] sm:block" />
                <span className="font-heading text-[clamp(1.3rem,2.6vw,1.9rem)] font-medium leading-[1.25] tracking-[-0.02em] text-[#fbf8f3]">
                  Don&apos;t rush to the answer. What one multiplication clears
                  every fraction at once?
                </span>
              </p>

              <p
                className="mt-8 text-base leading-7 text-white/40 sm:text-lg"
                style={typeOn(student2)}
              >
                Multiply everything by 6.
              </p>
            </div>

            <div
              className="pointer-events-none absolute inset-0 flex items-center justify-center text-center"
              style={{ opacity: finale }}
            >
              <div className="px-5">
                <p className="font-heading text-[clamp(4rem,14vw,10rem)] font-medium leading-[0.85] tracking-[-0.06em] text-[#fbf8f3]">
                  {marks} marks
                </p>
                <p
                  className="mx-auto mt-8 max-w-xl text-lg leading-8 text-white/75 sm:text-xl"
                  style={rise(closing)}
                >
                  That&apos;s 6 marks you were giving away. It was never
                  algebra. You just needed to clear the fractions first.
                </p>
              </div>
            </div>
          </div>
        );
      }}
    </ScrollScene>
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/marketing/sceneSession.test.tsx`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add src/app/(public)/_landing/SceneSession.tsx tests/marketing/sceneSession.test.tsx
git commit -m "feat(landing): scrubbed diagnosis session scene with strike-through and mark counter"
```

---

### Task 4: SceneMarksAndYears — the panel repairs itself, then pulls back to the years

**Files:**
- Create: `src/app/(public)/_landing/SceneMarksAndYears.tsx`
- Test: `tests/marketing/sceneMarksAndYears.test.tsx`

**Interfaces:**
- Consumes: `ScrollScene`, `phase` from Task 1.
- Produces: `export function SceneMarksAndYears(): JSX.Element` — no props. Used by Task 5's `page.tsx`.

Two movements inside one pinned scene:
- **A (p 0→0.5):** cream panel assembles. Grade appears, topic bars fill staggered, the Fraction equations bar completes to 100%, gets a "Fixed today" tag, and its row sinks to the bottom (fixed row heights make translate distances exact). "Marks won back" ticks 0→+12.
- **B (p 0.5→1):** panel recedes; the Form 1→4 spine draws downward and each stage ignites as the line reaches it.

- [ ] **Step 1: Write the failing test**

Create `tests/marketing/sceneMarksAndYears.test.tsx`:

```tsx
import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { SceneMarksAndYears } from "@/app/(public)/_landing/SceneMarksAndYears";

// jsdom has no matchMedia: static final state (progress 1).
describe("SceneMarksAndYears", () => {
  it("shows the repaired panel in student voice", () => {
    render(<SceneMarksAndYears />);
    expect(screen.getByText("Topics still costing you marks")).toBeDefined();
    expect(screen.getByText("Marks won back")).toBeDefined();
    expect(screen.getByText("Fixed today")).toBeDefined();
    expect(screen.getByText("+12")).toBeDefined();
  });

  it("shows the Form 1 to Form 4 journey", () => {
    render(<SceneMarksAndYears />);
    expect(screen.getByText("Form 1")).toBeDefined();
    expect(screen.getByText("Form 4")).toBeDefined();
    expect(screen.getByText("Walk into KCSE ready")).toBeDefined();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/marketing/sceneMarksAndYears.test.tsx`
Expected: FAIL — cannot resolve `.../SceneMarksAndYears`.

- [ ] **Step 3: Implement `SceneMarksAndYears.tsx`**

Create `src/app/(public)/_landing/SceneMarksAndYears.tsx`:

```tsx
"use client";

import { phase } from "./phase";
import { ScrollScene } from "./ScrollScene";

const TOPICS = [
  {
    label: "Fraction equations",
    detail: "Cleared in one honest session",
    value: 74,
    fixed: true,
  },
  {
    label: "Moles and ratios",
    detail: "Picks the formula before reading the question",
    value: 52,
    fixed: false,
  },
  {
    label: "Set-book evidence",
    detail: "Quotes are too thin to carry the point",
    value: 39,
    fixed: false,
  },
];

const YEARS = [
  {
    form: "Form 1",
    title: "Build strong basics",
    copy: "Catch the small gaps before they grow into exam panic.",
  },
  {
    form: "Form 2",
    title: "Connect the topics",
    copy: "Algebra, graphs, rates and grammar stop being strangers.",
  },
  {
    form: "Form 3",
    title: "Fix the gaps before mocks",
    copy: "One honest pass over every topic that still wobbles.",
  },
  {
    form: "Form 4",
    title: "Walk into KCSE ready",
    copy: "Mock rhythm, a predicted grade, and a plan you trust.",
  },
];

/** Fixed row height in px so the reorder translation distances are exact. */
const ROW = 104;

export function SceneMarksAndYears() {
  return (
    <ScrollScene length={3.5} lengthSm={3} className="relative">
      {(p) => {
        const grade = phase(p, 0.02, 0.08);
        const complete = phase(p, 0.28, 0.38);
        const wonBack = Math.round(12 * phase(p, 0.36, 0.48));
        const reorder = phase(p, 0.4, 0.5);
        const handoff = phase(p, 0.5, 0.58);
        const yearsIn = phase(p, 0.55, 0.62);
        const spine = phase(p, 0.58, 0.92);

        return (
          <div className="relative flex h-full min-h-[calc(100dvh-4rem)] items-center overflow-hidden">
            <div className="absolute inset-0 bg-[linear-gradient(180deg,#181915_0%,#15160f_60%,#141510_100%)]" />

            {/* Movement A: the panel repairs itself */}
            <div
              className="relative mx-auto w-full max-w-[1100px] px-5 sm:px-8"
              style={{
                opacity: 1 - handoff,
                transform: `scale(${1 - handoff * 0.06})`,
              }}
            >
              <h2
                className="mb-10 font-heading text-[clamp(2rem,4.6vw,3.6rem)] font-medium leading-[0.95] tracking-[-0.05em] text-[#fbf8f3]"
                style={{ opacity: phase(p, 0, 0.06) }}
              >
                Every session fixes something.
              </h2>

              <div className="grid gap-px overflow-hidden border border-[#d8cab4] bg-[#d8cab4] text-[#171814] shadow-[0_40px_120px_rgba(0,0,0,0.5)] md:grid-cols-[0.82fr_1.18fr]">
                <div
                  className="flex flex-col justify-between gap-8 bg-[#171814] p-6 text-[#fbf8f3] sm:p-8"
                  style={{ opacity: 0.25 + 0.75 * grade }}
                >
                  <div>
                    <p className="font-mono text-[11px] uppercase tracking-[0.2em] text-[#e0883b]">
                      Predicted grade
                    </p>
                    <p className="mt-4 font-mono text-6xl leading-none sm:text-7xl">
                      B-
                    </p>
                    <p className="mt-4 text-sm leading-6 text-white/55">
                      Two topics are all that hold the score below a B.
                    </p>
                  </div>
                  <div className="grid grid-cols-2 gap-px border-t border-white/10 pt-5">
                    <div>
                      <p className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/45">
                        Marks won back
                      </p>
                      <p className="mt-3 font-heading text-4xl leading-none text-[#e0883b]">
                        +{wonBack}
                      </p>
                    </div>
                    <div>
                      <p className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/45">
                        Today&apos;s session
                      </p>
                      <p className="mt-3 font-heading text-4xl leading-none">
                        28m
                      </p>
                    </div>
                  </div>
                </div>

                <div className="bg-[#fffaf0] p-6 sm:p-8">
                  <p className="mb-5 font-mono text-[11px] uppercase tracking-[0.2em] text-[#8b5b2e]">
                    Topics still costing you marks
                  </p>
                  <div
                    className="relative"
                    style={{ height: `${TOPICS.length * ROW}px` }}
                  >
                    {TOPICS.map((topic, index) => {
                      const fill = phase(p, 0.08 + index * 0.07, 0.2 + index * 0.07);
                      const width = topic.fixed
                        ? topic.value * fill + (100 - topic.value) * complete
                        : topic.value * fill;
                      const shift = topic.fixed
                        ? reorder * (TOPICS.length - 1) * ROW
                        : reorder * -ROW;
                      return (
                        <div
                          key={topic.label}
                          className="absolute inset-x-0 grid content-center gap-2 border-t border-[#e2d4bc] sm:grid-cols-[1fr_auto] sm:items-center sm:gap-8"
                          style={{
                            top: `${index * ROW}px`,
                            height: `${ROW}px`,
                            transform: `translateY(${shift}px)`,
                            opacity: topic.fixed ? 1 - reorder * 0.35 : 1,
                          }}
                        >
                          <div>
                            <p className="flex items-center gap-2 text-base font-semibold">
                              {topic.label}
                              {topic.fixed ? (
                                <span
                                  className="bg-[#e0883b] px-2 py-0.5 text-[10px] font-semibold uppercase tracking-[0.14em] text-[#171814]"
                                  style={{ opacity: complete }}
                                >
                                  Fixed today
                                </span>
                              ) : null}
                            </p>
                            <p className="mt-1 text-sm text-[#61594d]">
                              {topic.detail}
                            </p>
                          </div>
                          <div className="min-w-32">
                            <p className="mb-1.5 text-right font-mono text-xs text-[#8b5b2e]">
                              {Math.round(width)}%
                            </p>
                            <div className="h-1 bg-[#e2d4bc]">
                              <div
                                className="h-full bg-[#e0883b]"
                                style={{ width: `${width}%` }}
                              />
                            </div>
                          </div>
                        </div>
                      );
                    })}
                  </div>
                </div>
              </div>
            </div>

            {/* Movement B: pull back to the years */}
            <div
              className="absolute inset-0 flex items-center"
              style={{
                opacity: yearsIn,
                pointerEvents: "none",
              }}
            >
              <div className="mx-auto w-full max-w-[900px] px-5 sm:px-8">
                <h2 className="mb-12 font-heading text-[clamp(2rem,4.6vw,3.6rem)] font-medium leading-[0.95] tracking-[-0.05em] text-[#fbf8f3]">
                  And it stays with you.
                </h2>
                <div className="relative">
                  <div
                    className="absolute left-0 top-1 h-[calc(100%-0.5rem)] w-px origin-top bg-gradient-to-b from-[#e0883b]/70 via-white/15 to-transparent sm:left-[6.5rem]"
                    style={{ transform: `scaleY(${spine})` }}
                  />
                  <div className="space-y-8 sm:space-y-10">
                    {YEARS.map((stage, index) => {
                      const lit = phase(p, 0.6 + index * 0.09, 0.68 + index * 0.09);
                      return (
                        <article
                          key={stage.form}
                          className="grid gap-2 sm:grid-cols-[6.5rem_1fr] sm:gap-10"
                          style={{ opacity: 0.25 + 0.75 * lit }}
                        >
                          <p
                            className="font-mono text-sm sm:pt-1 sm:text-right"
                            style={{
                              color: `rgba(224,136,59,${0.4 + 0.6 * lit})`,
                            }}
                          >
                            {stage.form}
                          </p>
                          <div className="pl-6 sm:pl-10">
                            <h3 className="font-heading text-[clamp(1.4rem,2.8vw,2rem)] font-medium tracking-[-0.03em] text-[#fbf8f3]">
                              {stage.title}
                            </h3>
                            <p className="mt-2 max-w-lg text-sm leading-6 text-white/55 sm:text-base sm:leading-7">
                              {stage.copy}
                            </p>
                          </div>
                        </article>
                      );
                    })}
                  </div>
                </div>
              </div>
            </div>
          </div>
        );
      }}
    </ScrollScene>
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/marketing/sceneMarksAndYears.test.tsx`
Expected: PASS (2 tests).

- [ ] **Step 5: Commit**

```bash
git add src/app/(public)/_landing/SceneMarksAndYears.tsx tests/marketing/sceneMarksAndYears.test.tsx
git commit -m "feat(landing): merged marks-and-years pinned scene with queue repair and form spine"
```

---

### Task 5: Recompose page.tsx, rewrite the positioning guard, full check

**Files:**
- Modify: `tests/marketing/landingPagePositioning.test.ts` (full rewrite)
- Modify: `src/app/(public)/page.tsx` (full rewrite)

**Interfaces:**
- Consumes: `SceneHero` (Task 2), `SceneSession` (Task 3), `SceneMarksAndYears` (Task 4), existing `Reveal`, `Button`, `Link`.
- Produces: the final landing page at `/`.

- [ ] **Step 1: Rewrite the positioning guard (failing first)**

Replace the whole of `tests/marketing/landingPagePositioning.test.ts` with:

```ts
import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

const landingDir = join(process.cwd(), "src/app/(public)/_landing");
const source = [
  readFileSync(join(process.cwd(), "src/app/(public)/page.tsx"), "utf8"),
  ...readdirSync(landingDir)
    .filter((file) => file.endsWith(".tsx"))
    .map((file) => readFileSync(join(landingDir, file), "utf8")),
].join("\n");

describe("public landing page positioning", () => {
  it("positions Nexus as a student-voiced AI tutor for KCSE exam prep", () => {
    expect(source).toContain("Your AI tutor for KCSE");
    expect(source).toContain("Form 1");
    expect(source).toContain("Form 4");
    expect(source).toContain("mock");
    expect(source).toContain("Topics still costing you marks");
  });

  it("bans internal jargon on the public page", () => {
    expect(source).not.toContain("Socratic");
    expect(source).not.toContain("control room");
    expect(source).not.toContain("weak-topic");
    expect(source).not.toContain("mastery");
  });

  it("keeps the public page away from generic three-card marketing structure", () => {
    expect(source).not.toContain("PILLARS.map");
    expect(source).not.toContain("md:grid-cols-3");
    expect(source).not.toContain("One companion, from your first question");
  });
});
```

- [ ] **Step 2: Run it to verify it fails against the old page**

Run: `npx vitest run tests/marketing/landingPagePositioning.test.ts`
Expected: FAIL — old `page.tsx` still contains "control room" and "weak-topic" and lacks "Your AI tutor for KCSE".

- [ ] **Step 3: Rewrite `src/app/(public)/page.tsx`**

Replace the whole file with:

```tsx
import Link from "next/link";

import { Button } from "@/components/ui/Button";

import { Reveal } from "./_landing/Reveal";
import { SceneHero } from "./_landing/SceneHero";
import { SceneMarksAndYears } from "./_landing/SceneMarksAndYears";
import { SceneSession } from "./_landing/SceneSession";

// The page is a playable diagnosis: three pinned scenes the reader scrubs
// through, then a deliberately unpinned release. Scene copy lives with each
// scene component; this file only composes the story.

export default function LandingPage() {
  return (
    <div className="overflow-x-clip bg-[#171814] text-nexus-text-inverse">
      <SceneHero />
      <SceneSession />
      <SceneMarksAndYears />
      <Release />
    </div>
  );
}

/* The release. After three locked scenes this one scrolls normally: the
   diagnosis is done, the reader is free to move. */
function Release() {
  return (
    <section className="relative overflow-hidden px-5 py-32 sm:px-8 lg:px-10 lg:py-48">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_82%_18%,rgba(224,136,59,0.18),transparent_36rem),linear-gradient(180deg,#141510_0%,#0e0f0c_100%)]" />
      <div className="relative mx-auto max-w-[1100px]">
        <Reveal>
          <p className="font-mono text-xs uppercase tracking-[0.24em] text-[#e0883b]">
            11 days to the mock
          </p>
          <h2 className="mt-7 max-w-4xl font-heading text-[clamp(2.8rem,7vw,6rem)] font-medium leading-[0.9] tracking-[-0.055em] text-[#fbf8f3]">
            This time you walk in knowing exactly what you fixed.
          </h2>
        </Reveal>
        <Reveal
          delay={140}
          className="mt-12 flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between"
        >
          <p className="max-w-md text-lg leading-8 text-white/60">
            Give Nex one revision session tonight. Get the next move before
            you close the books.
          </p>
          <Button
            render={<Link href="/signup" />}
            className="min-h-14 w-full shrink-0 rounded-none bg-[#fbf8f3] px-7 text-[#0e0f0c] transition-all duration-300 ease-[cubic-bezier(0.16,1,0.3,1)] hover:-translate-y-0.5 hover:bg-white sm:w-auto"
          >
            Start your diagnosis
            <span className="ml-3 flex size-7 items-center justify-center bg-[#0e0f0c] text-[#fbf8f3]">
              &rarr;
            </span>
          </Button>
        </Reveal>
      </div>
    </section>
  );
}
```

- [ ] **Step 4: Run the positioning guard and the full suite**

Run: `npx vitest run tests/marketing/landingPagePositioning.test.ts`
Expected: PASS (3 tests).

Run: `npm test`
Expected: PASS — no other suite reads the landing page.

- [ ] **Step 5: Typecheck and lint**

Run: `npm run typecheck`
Expected: clean.

Run: `npm run lint`
Expected: clean (watch for `react/no-unescaped-entities` — all JSX apostrophes must be `&apos;`).

- [ ] **Step 6: Commit**

```bash
git add src/app/(public)/page.tsx tests/marketing/landingPagePositioning.test.ts
git commit -m "feat(landing): compose scroll-locked story page and update positioning guard"
```

---

### Task 6: Browser verification and polish

No new files. This task validates the real scroll feel and fixes what the tests cannot see.

- [ ] **Step 1: Start the dev server via the preview tooling** (create `.claude/launch.json` with `npm run dev` on port 3000 if missing) and open `/`.

- [ ] **Step 2: Scrub the story.** Using preview eval, step `window.scrollTo(0, y)` through each scene (hero at ~40%/90%, session at each timeline window, marks-and-years at ~25%/45%/75%) and snapshot/screenshot each stop. Verify:
  - Hero: constellation words drift out; "Fraction equations" glows; underline draws; scroll cue fades.
  - Session: type-ons, strike-through, circles, recede, "6 marks" counter, closing line.
  - Marks + Years: bars fill, "Fixed today" tag, row sinks, +12 ticks, crossfade to spine, stages ignite.
  - Release section scrolls normally; sticky header stays visible throughout (the overflow-x-clip fix).
  - Scrolling BACKWARD rewinds every scene.
- [ ] **Step 3: Console and network check.** No errors in preview console logs.
- [ ] **Step 4: Mobile pass.** Resize to 375×812; verify each scene fits the stage, text is legible, constellation is hidden (sm:block), scenes use the shorter lengths.
- [ ] **Step 5: Reduced-motion pass.** Emulate reduced motion (preview eval: override matchMedia before reload or use devtools emulation via `preview_resize` colorScheme is NOT this — instead verify by temporarily forcing `prefersStatic()` true in eval) and confirm the page renders as static editorial with all final states and natural heights.
- [ ] **Step 6: Fix anything off** (timing windows, sizes, overlaps), re-run `npm test && npm run typecheck && npm run lint`, then commit:

```bash
git add -A
git commit -m "polish(landing): scrub timing and viewport fixes from browser verification"
```

---

## Self-Review Notes

- **Spec coverage:** placement (/), scroll-only interactivity, zero-dep engine (Task 1), hero collapse (Task 2), extended session with wrong-attempt strike-through (Task 3), merged System+Arc (Task 4), unpinned release + positioning guard update (Task 5), verification plan (Task 6). Reduced-motion, mobile, compositor-only properties encoded in Global Constraints and ScrollScene.
- **Known simplification:** topic-bar `width` animates during the fill beat — sanctioned exception noted in Global Constraints (matches existing panel behavior).
- **Type consistency:** `phase(p, start, end)` and `ScrollScene` render-prop signature used identically in Tasks 2–4.
