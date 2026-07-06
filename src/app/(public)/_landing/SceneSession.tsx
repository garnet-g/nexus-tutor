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
