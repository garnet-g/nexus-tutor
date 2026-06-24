import Link from "next/link";

import { NexMark } from "@/components/NexMark";
import { Button } from "@/components/ui/Button";

import { Reveal } from "./_landing/Reveal";

// The story is one student's night before a topic finally clicks. Each constant
// below is a beat in that arc, not a feature grid.

const SLOW_DOWN = [
  {
    speaker: "student" as const,
    line: "I keep losing marks in simultaneous equations when the coefficients are fractions.",
  },
  {
    speaker: "nex" as const,
    line: "Then we do not start with the answer. What single multiplication clears every denominator in one half x plus one third y equals 7?",
  },
  {
    speaker: "student" as const,
    line: "Multiply everything by 6.",
  },
  {
    speaker: "nex" as const,
    line: "Good. That was never an algebra problem. It was a denominator problem hiding inside one.",
  },
];

const WEAK_TOPICS = [
  { label: "Quadratic graphs", detail: "Confuses the turning point with the roots", progress: "74%" },
  { label: "Moles and ratios", detail: "Picks the formula before reading the question", progress: "52%" },
  { label: "Set-book evidence", detail: "Quotes are too thin to carry the point", progress: "39%" },
];

const ARC = [
  {
    form: "Form 1",
    title: "Build the base",
    copy: "Nex finds the missing foundations early, before they harden into exam panic two years later.",
  },
  {
    form: "Form 2",
    title: "Link the topics",
    copy: "Revision starts connecting algebra, graphs, rates, grammar and science instead of treating each as an island.",
  },
  {
    form: "Form 3",
    title: "Repair the patterns",
    copy: "The system keeps a running queue of the topics that need one more honest pass before mock pressure arrives.",
  },
  {
    form: "Form 4",
    title: "Exam mode",
    copy: "Mock rhythm, predicted grade, revision sprints and Nex tutoring all work from a single plan.",
  },
];

export default function LandingPage() {
  return (
    <div className="overflow-x-hidden bg-[#171814] text-nexus-text-inverse">
      <StuckHero />
      <SlowDown />
      <Diagnosis />
      <Repair />
      <Arc />
      <ExamReady />
    </div>
  );
}

/* Beat 1 - Stuck. A clean, cinematic hero that fits one viewport. */
function StuckHero() {
  return (
    <section className="relative flex min-h-[calc(100dvh-4rem)] items-center overflow-hidden">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_8%_88%,rgba(224,136,59,0.22),transparent_34rem),linear-gradient(180deg,#1a1b16_0%,#171814_55%,#131410_100%)]" />
      <div className="nexus-scanline absolute inset-0 opacity-[0.12]" />
      <div className="relative mx-auto grid w-full max-w-[1280px] grid-cols-1 items-center gap-14 px-5 py-16 sm:px-8 lg:grid-cols-[1.06fr_0.94fr] lg:px-10">
        <div className="max-w-2xl">
          <Reveal className="mb-9 flex items-center gap-3">
            <NexMark size={36} />
            <p className="text-[10px] font-semibold uppercase tracking-[0.28em] text-[#e0883b]">
              AI revision control room
            </p>
          </Reveal>

          <Reveal delay={80}>
            <h1 className="font-heading text-[clamp(3.2rem,8.4vw,6.8rem)] font-medium leading-[0.88] tracking-[-0.06em] text-[#fbf8f3]">
              Revise the one thing.
              <span className="block text-white/45">Not everything.</span>
            </h1>
          </Reveal>

          <Reveal delay={170}>
            <p className="mt-8 max-w-md text-lg leading-8 text-white/68">
              Nexus reads a single study session, finds the exact mistake costing
              you marks, and hands you the next move.
            </p>
          </Reveal>

          <Reveal delay={240} className="mt-9 flex flex-col gap-3 sm:flex-row">
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
          </Reveal>
        </div>

        <Reveal delay={320} className="lg:justify-self-end">
          <figure className="w-full max-w-md border border-white/12 bg-[#0f110e]/85 p-6 shadow-[0_30px_90px_rgba(0,0,0,0.45)] backdrop-blur-sm sm:p-7">
            <figcaption className="mb-6 flex items-center justify-between border-b border-white/10 pb-4">
              <span className="flex items-center gap-2.5">
                <NexMark size={22} />
                <span className="text-xs font-semibold text-white/80">Nex</span>
              </span>
              <WorkingDots />
            </figcaption>
            <p className="text-sm leading-6 text-white/45">
              I keep dropping marks on fraction equations under time pressure.
            </p>
            <p className="mt-5 text-[1.35rem] font-medium leading-8 tracking-[-0.01em] text-[#fbf8f3]">
              Before any answer: what one move clears every denominator at once?
            </p>
            <p className="mt-6 border-l-2 border-[#e0883b]/70 pl-4 text-xs leading-6 text-white/45">
              Nex asks before it answers. That question is where the real error
              shows up.
            </p>
          </figure>
        </Reveal>
      </div>
    </section>
  );
}

/* Beat 2 - The slow-down. The Socratic exchange told as a screenplay, not a chat panel. */
function SlowDown() {
  return (
    <section className="relative px-5 py-28 sm:px-8 lg:px-10 lg:py-40">
      <div className="absolute inset-0 bg-[linear-gradient(180deg,#131410_0%,#181915_100%)]" />
      <div className="relative mx-auto max-w-3xl">
        <Reveal>
          <h2 className="font-heading text-[clamp(2.4rem,5.4vw,4.4rem)] font-medium leading-[0.95] tracking-[-0.05em] text-[#fbf8f3]">
            It refuses to just give you the answer.
          </h2>
          <p className="mt-6 max-w-xl text-lg leading-8 text-white/60">
            Most revision rushes to the solution. Nex slows the student down until
            the actual misunderstanding has nowhere left to hide.
          </p>
        </Reveal>

        <div className="mt-16 space-y-10">
          {SLOW_DOWN.map((turn, index) => (
            <Reveal key={turn.line} delay={index * 60}>
              {turn.speaker === "student" ? (
                <p className="max-w-xl text-lg leading-8 text-white/40">
                  {turn.line}
                </p>
              ) : (
                <p className="flex gap-4 sm:gap-6">
                  <span className="mt-2 hidden h-px w-10 shrink-0 bg-[#e0883b] sm:block" />
                  <span className="font-heading text-[clamp(1.5rem,3vw,2.1rem)] font-medium leading-[1.25] tracking-[-0.02em] text-[#fbf8f3]">
                    {turn.line}
                  </span>
                </p>
              )}
            </Reveal>
          ))}
        </div>
      </div>
    </section>
  );
}

/* Beat 3 - The turn. The diagnosis lands. */
function Diagnosis() {
  return (
    <section className="relative px-5 py-32 sm:px-8 lg:px-10 lg:py-48">
      <div className="absolute inset-0 bg-[radial-gradient(circle_at_50%_30%,rgba(224,136,59,0.14),transparent_40rem),linear-gradient(180deg,#181915_0%,#15160f_100%)]" />
      <div className="relative mx-auto max-w-4xl text-center">
        <Reveal>
          <p className="text-[10px] font-semibold uppercase tracking-[0.3em] text-[#e0883b]">
            The diagnosis
          </p>
          <p className="mt-8 font-heading text-[clamp(4.5rem,15vw,11rem)] font-medium leading-[0.82] tracking-[-0.06em] text-[#fbf8f3]">
            6 marks lost
          </p>
        </Reveal>
        <Reveal delay={140}>
          <p className="mx-auto mt-10 max-w-2xl text-[clamp(1.4rem,3.4vw,2.2rem)] font-medium leading-[1.3] tracking-[-0.02em] text-white/80">
            It was never algebra. It was denominator-clearing under time pressure.
          </p>
        </Reveal>
        <Reveal delay={240}>
          <p className="mx-auto mt-10 inline-flex flex-wrap items-center justify-center gap-x-2 text-sm leading-7 text-white/50">
            <span className="font-mono uppercase tracking-[0.18em] text-[#e0883b]">
              Next drill
            </span>
            <span className="text-white/70">
              8 fraction-equation questions before the next mock exam.
            </span>
          </p>
        </Reveal>
      </div>
    </section>
  );
}

/* Beat 4 - The repair. Light breaks the dark; the single product surface appears. */
function Repair() {
  return (
    <section className="relative px-5 py-28 sm:px-8 lg:px-10 lg:py-36">
      <div className="absolute inset-0 bg-[linear-gradient(180deg,#15160f_0%,#171814_100%)]" />
      <div className="relative mx-auto max-w-[1180px]">
        <Reveal className="mx-auto mb-14 max-w-2xl text-center">
          <h2 className="font-heading text-[clamp(2.4rem,5.4vw,4.2rem)] font-medium leading-[0.95] tracking-[-0.05em] text-[#fbf8f3]">
            Then the system goes to work.
          </h2>
          <p className="mt-6 text-lg leading-8 text-white/60">
            Every session updates one living queue: the weak-topic list still
            costing you marks, ranked by how much they cost.
          </p>
        </Reveal>

        <Reveal delay={120}>
          <div className="grid gap-px overflow-hidden border border-[#d8cab4] bg-[#d8cab4] text-[#171814] shadow-[0_40px_120px_rgba(0,0,0,0.5)] md:grid-cols-[0.82fr_1.18fr]">
            <div className="flex flex-col justify-between gap-8 bg-[#171814] p-7 text-[#fbf8f3] sm:p-9">
              <div>
                <p className="font-mono text-[11px] uppercase tracking-[0.2em] text-[#e0883b]">
                  Predicted grade
                </p>
                <p className="mt-5 font-mono text-7xl leading-none">B-</p>
                <p className="mt-5 text-sm leading-6 text-white/55">
                  Algebra and stoichiometry are the only two topics holding the
                  score below a B.
                </p>
              </div>
              <div className="grid grid-cols-2 gap-px border-t border-white/10 pt-6">
                <div>
                  <p className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/45">
                    Mastery shift
                  </p>
                  <p className="mt-3 font-heading text-4xl leading-none text-[#e0883b]">
                    +12
                  </p>
                </div>
                <div>
                  <p className="font-mono text-[10px] uppercase tracking-[0.18em] text-white/45">
                    Today&apos;s sprint
                  </p>
                  <p className="mt-3 font-heading text-4xl leading-none">28m</p>
                </div>
              </div>
            </div>

            <div className="bg-[#fffaf0] p-7 sm:p-9">
              <p className="mb-6 font-mono text-[11px] uppercase tracking-[0.2em] text-[#8b5b2e]">
                Active weak-topic queue
              </p>
              <div className="space-y-5">
                {WEAK_TOPICS.map((item) => (
                  <div
                    key={item.label}
                    className="grid gap-3 border-t border-[#e2d4bc] pt-5 sm:grid-cols-[1fr_auto] sm:items-center sm:gap-8"
                  >
                    <div>
                      <p className="text-base font-semibold">{item.label}</p>
                      <p className="mt-1 text-sm text-[#61594d]">{item.detail}</p>
                    </div>
                    <div className="min-w-32">
                      <p className="mb-1.5 text-right font-mono text-xs text-[#8b5b2e]">
                        {item.progress}
                      </p>
                      <div className="h-1 bg-[#e2d4bc]">
                        <div
                          className="h-full bg-[#e0883b]"
                          style={{ width: item.progress }}
                        />
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </div>
        </Reveal>
      </div>
    </section>
  );
}

/* Beat 5 - The arc. Form 1 to Form 4 as an asymmetric spine, never four equal cards. */
function Arc() {
  return (
    <section className="relative px-5 py-28 sm:px-8 lg:px-10 lg:py-40">
      <div className="absolute inset-0 bg-[linear-gradient(180deg,#171814_0%,#141510_100%)]" />
      <div className="relative mx-auto max-w-[1100px]">
        <Reveal className="max-w-2xl">
          <h2 className="font-heading text-[clamp(2.4rem,5.4vw,4.4rem)] font-medium leading-[0.95] tracking-[-0.05em] text-[#fbf8f3]">
            It grows up with you.
          </h2>
          <p className="mt-6 text-lg leading-8 text-white/60">
            From Form 1 foundations to Form 4 exam mode, it is the same system,
            sharpening a little more every year the student stays with it.
          </p>
        </Reveal>

        <div className="relative mt-20">
          <div className="absolute left-0 top-2 hidden h-[calc(100%-1rem)] w-px bg-gradient-to-b from-[#e0883b]/60 via-white/12 to-transparent sm:left-[7.5rem] sm:block" />
          <div className="space-y-14">
            {ARC.map((stage, index) => (
              <Reveal key={stage.form} delay={index * 70}>
                <article className="grid gap-5 sm:grid-cols-[7.5rem_1fr] sm:gap-12">
                  <div className="flex items-start gap-4 sm:flex-col sm:items-end sm:gap-2 sm:pt-1">
                    <p className="font-mono text-sm text-[#e0883b]">{stage.form}</p>
                    <p className="font-mono text-xs text-white/30">
                      0{index + 1}
                    </p>
                  </div>
                  <div
                    className="relative border-l border-white/10 pl-7 sm:border-l-0 sm:pl-0"
                    style={{ marginLeft: `${index % 2 === 1 ? 2.5 : 0}rem` }}
                  >
                    <h3 className="font-heading text-[clamp(1.8rem,3.6vw,2.6rem)] font-medium tracking-[-0.03em] text-[#fbf8f3]">
                      {stage.title}
                    </h3>
                    <p className="mt-4 max-w-lg text-base leading-7 text-white/55">
                      {stage.copy}
                    </p>
                  </div>
                </article>
              </Reveal>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

/* Beat 6 - Exam-ready. The arc resolves, then the single closing call. */
function ExamReady() {
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
        <Reveal delay={140} className="mt-12 flex flex-col gap-6 sm:flex-row sm:items-center sm:justify-between">
          <p className="max-w-md text-lg leading-8 text-white/60">
            Give Nex one revision session tonight. Get the next move before you
            close the books.
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

function WorkingDots() {
  return (
    <span className="flex items-center gap-1.5" aria-hidden>
      {[0, 1, 2].map((i) => (
        <span
          key={i}
          className="size-1.5 rounded-full bg-[#e0883b]"
          style={{ animation: `nexShimmer 1.4s ${i * 0.2}s infinite` }}
        />
      ))}
    </span>
  );
}
