import Link from "next/link";
import {
  BookOpenCheck,
  CalendarCheck,
  Gauge,
  GraduationCap,
  Landmark,
  Phone,
  ShieldCheck,
  Target,
} from "lucide-react";

import { NexMark } from "@/components/NexMark";
import { Button } from "@/components/ui/Button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";
import type {
  KcseMathRevisionHubModel,
  RevisionTopicStatus,
} from "@/lib/revision/kcseMathRevisionEngine";

interface KcseMathRevisionHubProps {
  model: KcseMathRevisionHubModel;
}

function statusLabel(status: RevisionTopicStatus): string {
  if (status === "not_started") return "Not started";
  if (status === "repair") return "Repair";
  if (status === "building") return "Building";
  return "Ready";
}

function statusClassName(status: RevisionTopicStatus): string {
  if (status === "ready") return "bg-nexus-success/10 text-nexus-success";
  if (status === "building") return "bg-nexus-accent/20 text-nexus-text-primary";
  if (status === "repair") return "bg-destructive/10 text-destructive";
  return "bg-muted text-muted-foreground";
}

export function KcseMathRevisionHub({ model }: KcseMathRevisionHubProps) {
  const firstRepairTopic = model.weakTopicRepair[0];

  return (
    <div className="space-y-6">
      <header className="flex flex-col gap-5 rounded-[28px] border border-nexus-border bg-nexus-surface p-5 shadow-card sm:flex-row sm:items-center sm:justify-between">
        <div className="flex items-start gap-3">
          <NexMark size={52} />
          <div className="space-y-1">
            <p className="text-xs font-semibold uppercase tracking-wide text-nexus-primary">
              Maths first · {model.curriculum} · {model.gradeLevel}
            </p>
            <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
              KCSE maths revision
            </h1>
            <p className="max-w-2xl text-sm leading-6 text-muted-foreground">
              One place for syllabus coverage, weak-topic repair, daily revision,
              and KCSE-style practice.
            </p>
          </div>
        </div>
        <div className="grid min-w-40 gap-1 rounded-2xl bg-nexus-sunken p-4">
          <span className="text-xs font-medium text-muted-foreground">
            Exam readiness
          </span>
          <span className="font-heading text-4xl font-semibold text-foreground">
            {model.readiness.score}%
          </span>
          <span className="text-sm font-semibold text-nexus-primary">
            {model.readiness.label}
          </span>
        </div>
      </header>

      <section className="grid gap-4 lg:grid-cols-[1.35fr_0.65fr]">
        <Card className="rounded-[22px]">
          <CardHeader>
            <CardTitle as="h2" className="flex items-center gap-2">
              <BookOpenCheck className="size-5 text-nexus-primary" />
              Syllabus map
            </CardTitle>
            <CardDescription>
              Form-by-form maths coverage with the next action attached.
            </CardDescription>
          </CardHeader>
          <CardContent>
            <div className="space-y-2">
              {model.syllabusMap.map((topic) => (
                <div
                  key={topic.id}
                  className="grid gap-3 rounded-2xl border border-nexus-border bg-nexus-background p-3 sm:grid-cols-[0.55fr_1fr_auto]"
                >
                  <div>
                    <p className="text-xs font-medium text-muted-foreground">
                      {topic.formLevel}
                    </p>
                    <p className="font-semibold text-foreground">{topic.title}</p>
                  </div>
                  <div className="flex items-center gap-3">
                    <div className="h-2 flex-1 overflow-hidden rounded-full bg-nexus-sunken">
                      <div
                        className="h-full rounded-full bg-nexus-primary"
                        style={{ width: `${topic.masteryPercentage}%` }}
                      />
                    </div>
                    <span className="w-10 text-right text-sm font-semibold tabular text-foreground">
                      {topic.masteryPercentage}%
                    </span>
                  </div>
                  <div className="flex flex-wrap items-center gap-2">
                    <span
                      className={`rounded-full px-2 py-1 text-[11px] font-semibold ${statusClassName(
                        topic.status,
                      )}`}
                    >
                      {statusLabel(topic.status)}
                    </span>
                    <Link
                      href={topic.practiceHref}
                      className="text-xs font-semibold text-nexus-primary"
                    >
                      Practice
                    </Link>
                  </div>
                </div>
              ))}
            </div>
          </CardContent>
        </Card>

        <div className="space-y-4">
          <Card className="rounded-[22px]">
            <CardHeader>
              <CardTitle as="h2" className="flex items-center gap-2">
                <Gauge className="size-5 text-nexus-primary" />
                Exam readiness
              </CardTitle>
              <CardDescription>{model.readiness.description}</CardDescription>
            </CardHeader>
            <CardContent className="space-y-3">
              <p className="font-heading text-5xl font-semibold tabular text-foreground">
                {model.readiness.score}
                <span className="text-lg text-muted-foreground">/100</span>
              </p>
              {model.readiness.predictedGrade ? (
                <p className="text-sm text-muted-foreground">
                  Predicted grade:{" "}
                  <span className="font-semibold text-foreground">
                    {model.readiness.predictedGrade}
                  </span>
                </p>
              ) : null}
              <Button render={<Link href="/progress" />} variant="outline" fullWidth>
                View progress
              </Button>
            </CardContent>
          </Card>

          <Card className="rounded-[22px]">
            <CardHeader>
              <CardTitle as="h2" className="flex items-center gap-2">
                <Target className="size-5 text-nexus-primary" />
                KCSE-style practice
              </CardTitle>
              <CardDescription>
                Switch from repair to timed exam pacing when ready.
              </CardDescription>
            </CardHeader>
            <CardContent className="space-y-2">
              <Button render={<Link href={model.practiceLinks.kcseStyle.href} />} fullWidth>
                {model.practiceLinks.kcseStyle.label}
              </Button>
              <Button
                render={<Link href={model.practiceLinks.topicDrill.href} />}
                variant="outline"
                fullWidth
              >
                {model.practiceLinks.topicDrill.label}
              </Button>
            </CardContent>
          </Card>
        </div>
      </section>

      <section className="grid gap-4 lg:grid-cols-2">
        <Card className="rounded-[22px]">
          <CardHeader>
            <CardTitle as="h2" className="flex items-center gap-2">
              <CalendarCheck className="size-5 text-nexus-primary" />
              Daily revision plan
            </CardTitle>
            <CardDescription>
              {model.dailyPlan.dailyGoalMinutes} minutes targeted for today.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            <p className="text-sm font-semibold text-foreground">
              {model.dailyPlan.title}
            </p>
            <div className="space-y-2">
              {model.dailyPlan.items.map((item) => (
                <Link
                  key={item.id}
                  href={item.href}
                  className="flex items-center justify-between gap-3 rounded-xl border border-nexus-border bg-nexus-background p-3 transition-colors hover:bg-nexus-sunken"
                >
                  <span>
                    <span className="block text-sm font-semibold text-foreground">
                      {item.title}
                    </span>
                    <span className="text-xs text-muted-foreground">
                      {item.topicTitle ?? "Study plan"} · {item.minutes} min
                    </span>
                  </span>
                  <span className="text-xs font-semibold text-nexus-primary">
                    {item.isCompleted ? "Done" : "Start"}
                  </span>
                </Link>
              ))}
            </div>
            <Button render={<Link href={model.dailyPlan.planHref} />} variant="outline">
              Adjust study plan
            </Button>
          </CardContent>
        </Card>

        <Card className="rounded-[22px]">
          <CardHeader>
            <CardTitle as="h2" className="flex items-center gap-2">
              <NexMark size={22} className="shadow-none" />
              Weak-topic repair
            </CardTitle>
            <CardDescription>
              Nex should repair the method before sending learners into timed work.
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-3">
            {model.weakTopicRepair.map((topic) => (
              <div
                key={topic.id}
                className="rounded-2xl border border-nexus-border bg-nexus-background p-3"
              >
                <div className="flex items-start justify-between gap-3">
                  <div>
                    <p className="font-semibold text-foreground">{topic.title}</p>
                    <p className="mt-1 text-sm text-muted-foreground">
                      {topic.repairFocus}
                    </p>
                  </div>
                  <span className="text-sm font-semibold tabular text-foreground">
                    {topic.masteryPercentage}%
                  </span>
                </div>
                <div className="mt-3 flex flex-wrap gap-2">
                  <Button render={<Link href={topic.nexHref} />} size="sm">
                    Repair with Nex
                  </Button>
                  <Button
                    render={<Link href={topic.practiceHref} />}
                    variant="outline"
                    size="sm"
                  >
                    Practice {topic.title}
                  </Button>
                </div>
              </div>
            ))}
            {firstRepairTopic ? null : (
              <p className="text-sm text-muted-foreground">
                Finish a diagnostic or practice session to unlock repair topics.
              </p>
            )}
          </CardContent>
        </Card>
      </section>

      <section className="grid gap-4 lg:grid-cols-3">
        <TrustCard
          icon={<GraduationCap className="size-5 text-nexus-primary" />}
          title="School/teacher trust"
          body={model.trustSummary.schoolReadySignal}
        />
        <TrustCard
          icon={<ShieldCheck className="size-5 text-nexus-primary" />}
          title="Parent-friendly pricing"
          body={model.trustSummary.parentPricingSignal}
        />
        <TrustCard
          icon={<Phone className="size-5 text-nexus-primary" />}
          title="Low-data mode"
          body={model.lowDataMode.tips.join(" ")}
        />
      </section>

      <Card className="rounded-[22px]">
        <CardHeader>
          <CardTitle as="h2" className="flex items-center gap-2">
            <Landmark className="size-5 text-nexus-primary" />
            Parent and school privacy line
          </CardTitle>
          <CardDescription>{model.trustSummary.chatPrivacy}</CardDescription>
        </CardHeader>
      </Card>
    </div>
  );
}

function TrustCard({
  icon,
  title,
  body,
}: {
  icon: React.ReactNode;
  title: string;
  body: string;
}) {
  return (
    <Card className="rounded-[22px]">
      <CardHeader>
        <CardTitle as="h2" className="flex items-center gap-2">
          {icon}
          {title}
        </CardTitle>
      </CardHeader>
      <CardContent>
        <p className="text-sm leading-6 text-muted-foreground">{body}</p>
      </CardContent>
    </Card>
  );
}
