import Link from "next/link";
import { redirect } from "next/navigation";

import { PageHeader } from "@/components/layout/page-header";
import { StatCard } from "@/components/layout/stat-card";
import { Badge } from "@/components/ui/Badge";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";
import { Progress } from "@/components/ui/Progress";
import {
  getMasteryBand,
  getMasteryBandLabel,
} from "@/lib/mastery/masteryEngine";
import { cn } from "@/lib/utils";
import { getSessionUser } from "@/server/services/authService";
import { getProgressSummary } from "@/server/services/practiceService";

const ACHIEVABLE_BADGES = [
  { code: "first_diagnostic_complete", label: "First diagnostic" },
  { code: "first_practice_complete", label: "First practice" },
  { code: "seven_day_streak", label: "7-day streak" },
] as const;

function bandBadgeVariant(band: ReturnType<typeof getMasteryBand>) {
  switch (band) {
    case "mastered":
      return "default" as const;
    case "strong":
      return "secondary" as const;
    case "developing":
      return "outline" as const;
    default:
      return "destructive" as const;
  }
}

export default async function ProgressPage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const summary = await getProgressSummary(sessionUser.studentProfile.id);

  const weakestTopic = summary.topicMastery
    .slice()
    .sort((left, right) => left.masteryPercentage - right.masteryPercentage)[0];

  const focusTopicTitle = weakestTopic?.title ?? null;
  const focusTopicId = weakestTopic?.topicId ?? null;
  const practiceHref = focusTopicId
    ? `/practice?topicId=${focusTopicId}`
    : "/practice";
  const learnHref = focusTopicId ? `/learn/${focusTopicId}` : "/learn";

  return (
    <div className="flex flex-col gap-10">
      <PageHeader
        eyebrow="Progress"
        title="Your learning journey"
        description="Track your health score, mastery, streak, and badges."
      />

      <Card className="nexus-card-elevated border-primary/20 bg-primary/5">
        <CardHeader>
          <CardTitle className="font-heading text-xl">
            {focusTopicTitle
              ? `Focus on ${focusTopicTitle} this week`
              : "Build your first mastery milestone"}
          </CardTitle>
          <CardDescription>
            {focusTopicTitle && weakestTopic
              ? `${focusTopicTitle} is at ${weakestTopic.masteryPercentage}% mastery — targeted practice will lift your health score fastest.`
              : "Complete a diagnostic or practice session to unlock personalized focus areas."}
          </CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col gap-2 sm:flex-row sm:flex-wrap">
          <Link
            href={practiceHref}
            className="inline-flex min-h-11 items-center justify-center rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground transition-colors hover:bg-primary/90"
          >
            {focusTopicTitle ? `Practice ${focusTopicTitle}` : "Start practice"}
          </Link>
          <Link
            href={learnHref}
            className="inline-flex min-h-11 items-center justify-center rounded-lg border border-border px-4 py-2 text-sm font-medium text-foreground transition-colors hover:bg-muted"
          >
            {focusTopicTitle ? `Review ${focusTopicTitle} lessons` : "Browse Learn"}
          </Link>
          <Link
            href="/exam-prep"
            className="inline-flex min-h-11 items-center justify-center rounded-lg border border-border px-4 py-2 text-sm font-medium text-foreground transition-colors hover:bg-muted"
          >
            Exam Prep
          </Link>
        </CardContent>
      </Card>

      <section className="grid gap-4 sm:grid-cols-3">
        <StatCard
          label="Health score"
          value={`${summary.healthScore}/100`}
          description={summary.predictedGrade ?? "—"}
          insight="A higher health score means you are on track for your target grade."
          href="/exam-prep"
          linkLabel="Prepare for exams"
          accent="primary"
        />
        <StatCard
          label="Streak"
          value={`${summary.currentStreak} days`}
          description={`Best: ${summary.longestStreak} days`}
          insight="Consistency compounds — even 15 minutes daily makes a difference."
          href="/learn"
          linkLabel="Learn today"
          accent="accent"
        />
        <StatCard
          label="XP"
          value={summary.totalXp}
          description={`Level ${summary.currentLevel}`}
          insight="XP grows as you complete lessons, practice, and diagnostics."
          href="/study-plan"
          linkLabel="See study plan"
          accent="secondary"
        />
      </section>

      <Card className="nexus-card-elevated">
        <CardHeader>
          <CardTitle className="font-heading text-xl">Subject health scores</CardTitle>
          <CardDescription>
            Math uses your diagnostic baseline. Science and English scores appear after your first practice.
          </CardDescription>
        </CardHeader>
        <CardContent>
          <div className="grid gap-3 sm:grid-cols-3">
            {summary.subjectHealthScores.length > 0 ? (
              summary.subjectHealthScores.map((subject) => (
                <div
                  key={subject.subjectCode}
                  className="rounded-xl border border-border bg-muted/50 px-4 py-3"
                >
                  <p className="text-sm font-medium text-foreground">{subject.subjectName}</p>
                  <p className="mt-1 font-heading text-2xl font-semibold text-foreground">
                    {subject.healthScore}/100
                  </p>
                  <p className="text-sm text-muted-foreground">{subject.predictedGrade ?? "—"}</p>
                </div>
              ))
            ) : (
              <p className="text-sm text-muted-foreground sm:col-span-3">
                Complete practice in a subject to see subject-specific health scores.
              </p>
            )}
          </div>
        </CardContent>
      </Card>

      <Card className="nexus-card-elevated">
        <CardHeader className="flex-row items-center justify-between">
          <div>
            <CardTitle className="font-heading text-xl">Topic mastery</CardTitle>
          </div>
          <Link
            href="/practice"
            className="text-sm font-medium text-primary transition-colors hover:text-primary/80"
          >
            Practice a weak topic →
          </Link>
        </CardHeader>
        <CardContent className="flex flex-col gap-4">
          {summary.topicMastery.length > 0 ? (
            summary.topicMastery.map((topic) => {
              const band = getMasteryBand(topic.masteryPercentage);

              return (
                <div key={topic.topicId} className="flex flex-col gap-2">
                  <div className="flex items-center justify-between gap-3 text-sm">
                    <span className="font-medium text-foreground">{topic.title}</span>
                    <Badge variant={bandBadgeVariant(band)}>
                      {topic.masteryPercentage}% · {getMasteryBandLabel(band)}
                    </Badge>
                  </div>
                  <Progress value={topic.masteryPercentage} className="w-full" />
                </div>
              );
            })
          ) : (
            <p className="text-sm text-muted-foreground">
              Complete your diagnostic to see topic mastery.
            </p>
          )}
        </CardContent>
      </Card>

      <Card className="nexus-card-elevated">
        <CardHeader>
          <CardTitle className="font-heading text-xl">Badges</CardTitle>
          <CardDescription>
            Earn badges as you complete diagnostics, practice, and daily streaks.
          </CardDescription>
        </CardHeader>
        <CardContent className="flex flex-col gap-4">
          <div className="flex flex-wrap gap-2">
            {ACHIEVABLE_BADGES.map((badge) => {
              const earned = summary.badges.includes(badge.code);

              return (
                <Badge
                  key={badge.code}
                  variant={earned ? "default" : "outline"}
                  className={cn(!earned && "border-dashed text-muted-foreground")}
                >
                  {badge.label}
                  {earned ? " · earned" : ""}
                </Badge>
              );
            })}
          </div>
          {summary.badges.some(
            (badge) =>
              !ACHIEVABLE_BADGES.some((achievable) => achievable.code === badge),
          ) ? (
            <div className="flex flex-wrap gap-2">
              {summary.badges
                .filter(
                  (badge) =>
                    !ACHIEVABLE_BADGES.some(
                      (achievable) => achievable.code === badge,
                    ),
                )
                .map((badge) => (
                  <Badge key={badge} variant="secondary">
                    {badge.replaceAll("_", " ")}
                  </Badge>
                ))}
            </div>
          ) : null}
        </CardContent>
      </Card>
    </div>
  );
}
