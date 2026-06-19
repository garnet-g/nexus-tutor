import Link from "next/link";

import { Button } from "@/components/ui/Button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";
import { MarketingSection } from "@/features/marketing/components/PublicShell";

const FEATURES = [
  {
    title: "Nex AI Tutor",
    description:
      "Your Socratic study companion for Explain, Practice, Homework, and Revision — grounded in CBC and KCSE curriculum.",
    tag: "Tutor",
    accent: "border-t-primary",
  },
  {
    title: "Diagnostic Assessment",
    description:
      "A 20-question diagnostic builds your Academic Health Score and predicted grade so learning starts where you need it.",
    tag: "Insight",
    accent: "border-t-nexus-secondary",
  },
  {
    title: "Practice Sessions",
    description:
      "Ten-question sessions with difficulty you choose. Mastery updates after every round so Nex knows what to teach next.",
    tag: "Mastery",
    accent: "border-t-nexus-accent",
  },
] as const;

export default function LandingPage() {
  return (
    <div className="overflow-x-hidden">
      <MarketingSection className="nexus-hero-glow border-b border-border">
        <div className="mx-auto max-w-6xl px-4 py-20 sm:px-6 sm:py-28">
          <div className="mx-auto flex max-w-3xl flex-col items-center gap-6 text-center">
            <p className="rounded-full border border-primary/20 bg-primary/5 px-4 py-1 text-xs font-medium uppercase tracking-[0.16em] text-primary">
              CBC &amp; KCSE · Mathematics · Science · English
            </p>
            <h1 className="font-heading text-4xl font-semibold tracking-tight text-foreground sm:text-5xl sm:leading-[1.08]">
              The academic companion that grows with you
            </h1>
            <p className="max-w-2xl text-base leading-relaxed text-muted-foreground sm:text-lg">
              Nexus combines Nex, your AI teacher, with diagnostics, curriculum
              lessons, and practice — built for Kenyan students from Grade 4
              through Form 4.
            </p>
            <div className="flex w-full flex-col items-stretch gap-3 sm:w-auto sm:flex-row sm:justify-center">
              <Button render={<Link href="/signup" />} size="lg">
                Start learning free
              </Button>
              <Button render={<Link href="/pricing" />} variant="outline" size="lg">
                View pricing
              </Button>
            </div>
            <p className="text-sm text-muted-foreground">
              Free forever · 10 Nex messages &amp; 3 practice sessions daily
            </p>
          </div>
        </div>
      </MarketingSection>

      <section className="mx-auto max-w-6xl px-4 py-20 sm:px-6 sm:py-24">
        <div className="mx-auto max-w-2xl text-center">
          <h2 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
            Everything you need to study smarter
          </h2>
          <p className="mt-3 text-muted-foreground">
            Nex is the backbone — every feature feeds personalized teaching.
          </p>
        </div>
        <div className="mt-12 grid gap-6 md:grid-cols-3">
          {FEATURES.map((feature) => (
            <Card
              key={feature.title}
              className={`border-t-4 ${feature.accent} nexus-card-elevated`}
            >
              <CardHeader>
                <CardDescription className="text-xs font-medium uppercase tracking-[0.12em] text-primary">
                  {feature.tag}
                </CardDescription>
                <CardTitle className="font-heading text-xl">{feature.title}</CardTitle>
              </CardHeader>
              <CardContent>
                <p className="text-sm leading-relaxed text-muted-foreground">
                  {feature.description}
                </p>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      <MarketingSection variant="primary" className="px-4 py-20 sm:px-6">
        <div className="mx-auto flex max-w-2xl flex-col items-center gap-6 text-center">
          <h2 className="font-heading text-3xl font-semibold">Ready to meet Nex?</h2>
          <p className="text-sm leading-relaxed text-primary-foreground/85 sm:text-base">
            Sign up in minutes. Complete your diagnostic, get your Health Score,
            and start learning with a tutor that guides — not gives away answers.
          </p>
          <Button
            render={<Link href="/signup" />}
            variant="secondary"
            size="lg"
            className="bg-primary-foreground text-primary hover:bg-primary-foreground/90"
          >
            Create your account
          </Button>
        </div>
      </MarketingSection>
    </div>
  );
}
