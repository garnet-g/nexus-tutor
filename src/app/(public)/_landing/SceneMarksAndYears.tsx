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
                className="mb-6 font-heading text-[clamp(2rem,4.6vw,3.6rem)] font-medium leading-[0.95] tracking-[-0.05em] text-[#fbf8f3] sm:mb-10"
                style={{ opacity: phase(p, 0, 0.06) }}
              >
                Every session fixes something.
              </h2>

              <div className="grid gap-px overflow-hidden border border-[#d8cab4] bg-[#d8cab4] text-[#171814] shadow-[0_40px_120px_rgba(0,0,0,0.5)] md:grid-cols-[0.82fr_1.18fr]">
                <div
                  className="flex flex-col justify-between gap-5 bg-[#171814] p-5 text-[#fbf8f3] sm:gap-8 sm:p-8"
                  style={{ opacity: 0.25 + 0.75 * grade }}
                >
                  <div>
                    <p className="font-mono text-[11px] uppercase tracking-[0.2em] text-[#e0883b]">
                      Predicted grade
                    </p>
                    <p className="mt-4 font-mono text-5xl leading-none sm:text-7xl">
                      B-
                    </p>
                    <p className="mt-4 hidden text-sm leading-6 text-white/55 sm:block">
                      Two topics are all that hold the score below a B.
                    </p>
                  </div>
                  <div className="grid grid-cols-2 gap-px border-t border-white/10 pt-5">
                    <div>
                      <p className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/45">
                        Marks won back
                      </p>
                      <p className="mt-3 font-heading text-3xl leading-none text-[#e0883b] sm:text-4xl">
                        +{wonBack}
                      </p>
                    </div>
                    <div>
                      <p className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/45">
                        Today&apos;s session
                      </p>
                      <p className="mt-3 font-heading text-3xl leading-none sm:text-4xl">
                        28m
                      </p>
                    </div>
                  </div>
                </div>

                <div className="bg-[#fffaf0] p-5 sm:p-8">
                  <p className="mb-5 font-mono text-[11px] uppercase tracking-[0.2em] text-[#8b5b2e]">
                    Topics still costing you marks
                  </p>
                  <div
                    className="relative"
                    style={{ height: `${TOPICS.length * ROW}px` }}
                  >
                    {TOPICS.map((topic, index) => {
                      const fill = phase(
                        p,
                        0.08 + index * 0.07,
                        0.2 + index * 0.07,
                      );
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
                            <p className="mt-1 hidden text-sm text-[#61594d] sm:block">
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
                      const lit = phase(
                        p,
                        0.6 + index * 0.09,
                        0.68 + index * 0.09,
                      );
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
