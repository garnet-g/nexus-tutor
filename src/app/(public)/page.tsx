import Link from "next/link";

import { Button } from "@/components/ui/Button";
import { NexMark } from "@/components/NexMark";
import { MarketingSection } from "@/features/marketing/components/PublicShell";

const TEACHING_DEMO = [
  {
    from: "nex" as const,
    text: "If 2x + 5 = 13, what could we do to both sides first to get x on its own?",
  },
  { from: "me" as const, text: "Subtract 5?" },
  {
    from: "nex" as const,
    text: "Exactly. Now you try it — what does that leave us with?",
  },
] as const;

const PILLARS = [
  {
    title: "Nex teaches, never just tells",
    description:
      "A Socratic tutor for Explain, Practice, Homework and Revision — grounded in CBC and KCSE, it guides you to the answer so it actually sticks.",
  },
  {
    title: "Knows exactly where you stand",
    description:
      "A 20-question diagnostic builds your Academic Health Score and predicted grade, so every lesson starts where you need it most.",
  },
  {
    title: "Practice that adapts to you",
    description:
      "Ten-question sessions at the difficulty you choose. Mastery updates after every round, so Nex always knows what to teach next.",
  },
] as const;

export default function LandingPage() {
  return (
    <div className="overflow-x-hidden">
      <MarketingSection className="nexus-hero-glow border-b border-border">
        <div className="mx-auto max-w-5xl px-4 pb-16 pt-14 sm:px-6 sm:pb-24 sm:pt-20">
          <div className="grid items-center gap-12 lg:grid-cols-2">
            <div className="flex flex-col items-start gap-6 text-left">
              <span className="inline-flex items-center gap-2 rounded-full bg-nexus-primary-soft px-3 py-1.5 text-xs font-semibold text-nexus-primary">
                <NexMark size={16} />
                Meet Nex · your tutor
              </span>
              <h1 className="font-heading text-4xl font-medium leading-[1.08] tracking-tight text-foreground sm:text-[3.25rem]">
                The tutor who asks the{" "}
                <em className="italic text-nexus-primary">right question</em>,
                not just the answer.
              </h1>
              <p className="max-w-xl text-base leading-relaxed text-muted-foreground sm:text-lg">
                Built for Kenya — CBC &amp; KCSE, from Grade 4 to Form 4. Nex
                teaches the way a great teacher does: one step at a time, until
                it clicks.
              </p>
              <div className="flex w-full flex-col gap-3 sm:w-auto sm:flex-row">
                <Button render={<Link href="/signup" />} size="lg" fullWidth>
                  Start learning free
                </Button>
                <Button
                  render={<Link href="/about" />}
                  variant="secondary"
                  size="lg"
                  fullWidth
                >
                  See how Nex teaches
                </Button>
              </div>
              <ul className="flex flex-wrap gap-x-5 gap-y-2 text-xs text-muted-foreground">
                <TrustItem>Free forever</TrustItem>
                <TrustItem>M-Pesa</TrustItem>
                <TrustItem>CBC + KCSE</TrustItem>
              </ul>
            </div>

            <TeachingDemo />
          </div>
        </div>
      </MarketingSection>

      <section className="mx-auto max-w-5xl px-4 py-16 sm:px-6 sm:py-24">
        <div className="max-w-2xl">
          <h2 className="font-heading text-3xl font-medium tracking-tight text-foreground">
            One companion, from your first question to your final exam.
          </h2>
          <p className="mt-3 text-muted-foreground">
            Nex is the backbone — diagnostics, lessons and practice all feed it,
            so the teaching is always personal to you.
          </p>
        </div>
        <div className="mt-12 grid gap-5 md:grid-cols-3">
          {PILLARS.map((pillar, index) => (
            <article
              key={pillar.title}
              className="rounded-[22px] border border-nexus-border bg-nexus-surface p-6 shadow-card"
            >
              <span className="font-heading text-2xl text-nexus-primary/40 tabular">
                0{index + 1}
              </span>
              <h3 className="mt-3 font-heading text-lg font-semibold text-foreground">
                {pillar.title}
              </h3>
              <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
                {pillar.description}
              </p>
            </article>
          ))}
        </div>
      </section>

      <MarketingSection className="px-4 pb-20 sm:px-6">
        <div className="mx-auto max-w-4xl overflow-hidden rounded-[28px] bg-nexus-primary px-6 py-12 text-center text-nexus-text-inverse shadow-nex sm:px-12 sm:py-16">
          <NexMark size={56} className="mx-auto" />
          <h2 className="mt-5 font-heading text-3xl font-medium">
            Ready to meet Nex?
          </h2>
          <p className="mx-auto mt-3 max-w-xl text-sm leading-relaxed text-nexus-text-inverse/80 sm:text-base">
            Sign up in minutes. Take your diagnostic, get your Health Score, and
            start learning with a tutor that guides — never gives the answer away.
          </p>
          <div className="mt-7">
            <Button
              render={<Link href="/signup" />}
              variant="secondary"
              size="lg"
              className="bg-nexus-text-inverse text-nexus-primary hover:bg-nexus-text-inverse/90"
            >
              Create your free account
            </Button>
          </div>
        </div>
      </MarketingSection>
    </div>
  );
}

function TrustItem({ children }: { children: React.ReactNode }) {
  return (
    <li className="flex items-center gap-1.5">
      <span className="font-bold text-nexus-success">✓</span>
      {children}
    </li>
  );
}

function TeachingDemo() {
  return (
    <div className="rounded-[26px] border border-nexus-border bg-nexus-surface p-4 shadow-float sm:p-5">
      <div className="mb-3 flex items-center gap-3 border-b border-nexus-border pb-3">
        <NexMark size={38} />
        <div className="min-w-0">
          <p className="text-sm font-semibold text-foreground">Nex</p>
          <p className="flex items-center gap-1.5 text-[11px] text-nexus-success">
            <span className="inline-block size-1.5 rounded-full bg-nexus-success" />
            teaching · Linear Equations
          </p>
        </div>
      </div>
      <div className="flex flex-col gap-2.5">
        {TEACHING_DEMO.map((bubble, index) => (
          <div
            key={index}
            className={
              bubble.from === "me"
                ? "ml-auto max-w-[85%] rounded-2xl rounded-br-md bg-nexus-primary px-3.5 py-2.5 text-sm leading-relaxed text-nexus-text-inverse"
                : "max-w-[88%] rounded-2xl rounded-bl-md bg-nexus-primary-soft px-3.5 py-2.5 text-sm leading-relaxed text-foreground"
            }
          >
            {bubble.text}
          </div>
        ))}
        <div className="nex-think flex w-fit items-center gap-1.5 rounded-2xl rounded-bl-md bg-nexus-primary-soft px-4 py-3">
          <i />
          <i />
          <i />
        </div>
      </div>
    </div>
  );
}
