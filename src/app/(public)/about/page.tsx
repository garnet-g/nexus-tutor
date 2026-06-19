import Link from "next/link";

import { PageHeader } from "@/components/layout/page-header";
import { Button } from "@/components/ui/Button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";

const PRINCIPLES = [
  {
    title: "Nex-first",
    body: "Nex is the backbone of Nexus — not a chatbot bolted onto content. Every system feeds personalized teaching.",
  },
  {
    title: "Mobile-first",
    body: "Built for 375px screens first. Learning should work on the phone students actually use.",
  },
  {
    title: "Kenya-first",
    body: "KES pricing, M-Pesa payments, +254 numbers, and curriculum grounded in CBC and KCSE.",
  },
  {
    title: "Freemium forever",
    body: "Core learning never expires. Daily caps, not paywalls — because trust is earned through teaching.",
  },
  {
    title: "Student-first",
    body: "Outcomes over feature count. Understanding beats correct answers. Guidance beats solution delivery.",
  },
  {
    title: "Parent-visible outcomes",
    body: "Parents see progress, health scores, and weak topics — not chat logs.",
  },
] as const;

export default function AboutPage() {
  return (
    <div className="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16">
      <PageHeader
        eyebrow="Our mission"
        title="The most trusted academic companion from Grade 4 to university admission"
        description="Nexus exists so every Kenyan student has a patient, curriculum-grounded teacher in their pocket. V1 focuses on Mathematics, Science, and English for CBC and KCSE — with Nex leading diagnostics, lessons, practice, and revision."
      />

      <section className="mt-12 grid gap-4 sm:grid-cols-2">
        {PRINCIPLES.map((principle) => (
          <Card key={principle.title} className="nexus-card-elevated">
            <CardHeader>
              <CardTitle className="font-heading text-lg">{principle.title}</CardTitle>
            </CardHeader>
            <CardContent>
              <CardDescription className="text-sm leading-relaxed">
                {principle.body}
              </CardDescription>
            </CardContent>
          </Card>
        ))}
      </section>

      <Card className="mt-12 nexus-card-elevated">
        <CardHeader>
          <CardTitle className="font-heading text-xl">Teaching principles</CardTitle>
        </CardHeader>
        <CardContent className="flex flex-col gap-6">
          <ul className="flex flex-col gap-2 text-sm text-muted-foreground">
            <li>Understanding over correct answers</li>
            <li>Guidance over solution delivery</li>
            <li>Confidence building over error detection</li>
            <li>Learning process over task completion</li>
            <li>Adaptive teaching for every student</li>
          </ul>
          <Button render={<Link href="/signup" />}>Join Nexus</Button>
        </CardContent>
      </Card>
    </div>
  );
}
