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
    <ScrollScene length={2} lengthSm={0} className="relative">
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
