import Link from "next/link";
import { redirect } from "next/navigation";
import {
  ArrowRight,
  Circle,
  Flame,
  Sparkles,
  Target,
  Zap,
} from "lucide-react";

import { NexMark } from "@/components/NexMark";
import {
  GoalRing,
  StreakHeatmap,
} from "@/components/widgets/StatWidgets";
import {
  DashboardEmptyStates,
} from "@/features/dashboard/components/DashboardEmptyStates";
import { shouldShowDashboardEmptyState } from "@/features/dashboard/dashboardEmptyState";
import { levelFromXp } from "@/lib/gamification";
import { getEffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { getSessionUser } from "@/server/services/authService";
import { getLatestHealthScore } from "@/server/services/diagnosticService";
import { getProgressSummary } from "@/server/services/practiceService";
import { getActiveStudyPlan } from "@/server/services/studyPlanService";

function nairobiGreeting(): string {
  const hour = Number(
    new Intl.DateTimeFormat("en-KE", {
      hour: "numeric",
      hour12: false,
      timeZone: "Africa/Nairobi",
    }).format(new Date()),
  );
  if (hour < 12) return "Morning";
  if (hour < 17) return "Afternoon";
  return "Evening";
}

export default async function StudentDashboardPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  if (!profile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const [subscriptionConfig, health, progress, studyPlan] = await Promise.all([
    getEffectiveSubscriptionConfig(),
    getLatestHealthScore(profile.id),
    getProgressSummary(profile.id),
    getActiveStudyPlan(profile.id),
  ]);

  const recommendedTask = studyPlan?.tasks.find((task) => task.topicTitle);
  const weakestTopic = progress.topicMastery
    .slice()
    .sort((left, right) => left.masteryPercentage - right.masteryPercentage)[0];

  const recommendedTopic =
    recommendedTask?.topicTitle ?? weakestTopic?.title ?? "Algebra";
  const recommendedTopicId =
    recommendedTask?.topicId ?? weakestTopic?.topicId ?? null;
  const practiceHref = recommendedTopicId
    ? `/practice?topicId=${recommendedTopicId}`
    : "/practice";

  const dailyGoalMinutes = studyPlan?.dailyGoal?.dailyGoalMinutes ?? 20;
  const minutesCompleted = studyPlan?.dailyGoal?.minutesCompleted ?? 0;
  const minutesLeft = Math.max(0, dailyGoalMinutes - minutesCompleted);

  const healthScore = Number(health?.health_score ?? 0);
  const predictedGrade = health?.predicted_grade ?? null;
  const streak = progress.currentStreak;
  const { level, intoLevel, levelSize, progress: levelProgress } = levelFromXp(
    progress.totalXp,
  );
  const firstName = profile.full_name?.split(" ")[0];

  const subline =
    streak > 0
      ? `You're on a ${streak}-day streak. Ready for ${recommendedTopic} today?`
      : `Let's start strong — ${recommendedTopic} is a great place to begin today.`;

  const nexScoreLine = predictedGrade
    ? `You're tracking a ${predictedGrade}. A focused push on ${recommendedTopic} moves you higher.`
    : `Keep practising ${recommendedTopic} and your score will climb.`;

  const planTasks = (studyPlan?.tasks ?? [])
    .filter((task) => task.topicTitle)
    .slice(0, 3);

  const showEmptyState = shouldShowDashboardEmptyState({
    topicMastery: progress.topicMastery,
    totalXp: progress.totalXp,
    currentStreak: progress.currentStreak,
    hasStudyPlanTasks: (studyPlan?.tasks.length ?? 0) > 0,
  });

  const weakTopicForBrush =
    weakestTopic && weakestTopic.title !== recommendedTopic
      ? weakestTopic.title
      : null;

  return (
    <div className="space-y-6">
      {/* Greeting — Nex speaking */}
      <header className="flex items-start gap-3">
        <NexMark size={52} />
        <div className="min-w-0">
          <h1 className="font-heading text-2xl font-medium leading-tight text-foreground sm:text-[1.75rem]">
            {nairobiGreeting()}
            {firstName ? `, ${firstName}` : ""}.
          </h1>
          <p className="mt-1 text-sm leading-snug text-muted-foreground">
            {subline}
          </p>
        </div>
      </header>

      <div className="grid gap-5 lg:grid-cols-3">
        {/* Main column */}
        <div className="space-y-5 lg:col-span-2">
          {/* Hero — Health Score */}
          <section className="relative overflow-hidden rounded-[28px] bg-gradient-to-br from-nexus-primary to-nexus-primary-dark p-6 text-nexus-text-inverse shadow-nex">
            <div className="pointer-events-none absolute -right-10 -top-10 size-44 rounded-full border-[20px] border-white/[0.06]" />
            {predictedGrade ? (
              <span className="absolute right-5 top-5 inline-flex items-center gap-1 rounded-full bg-nexus-accent px-2.5 py-1 text-[11px] font-bold text-nexus-text-primary">
                Predicted {predictedGrade}
              </span>
            ) : null}
            <p className="text-xs font-medium text-nexus-text-inverse/80">
              Academic Health
            </p>
            <p className="mt-1 font-heading text-6xl font-medium leading-none tabular">
              {healthScore}
              <span className="text-xl text-nexus-text-inverse/70">/100</span>
            </p>
            <div className="mt-4 h-1.5 w-full max-w-sm overflow-hidden rounded-full bg-white/15">
              <div
                className="h-full rounded-full bg-nexus-accent transition-all"
                style={{ width: `${Math.min(100, Math.max(0, healthScore))}%` }}
              />
            </div>
            <p className="mt-4 max-w-md text-sm leading-relaxed text-nexus-text-inverse/90">
              {nexScoreLine}
            </p>
          </section>

          {showEmptyState ? (
            <DashboardEmptyStates showEmptyState={showEmptyState} />
          ) : (
            <section className="rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card">
              <div className="mb-3 flex items-center justify-between">
                <h2 className="text-sm font-semibold text-foreground">
                  Today&apos;s plan
                </h2>
                <Link
                  href="/study-plan"
                  className="text-xs font-semibold text-nexus-primary"
                >
                  Study plan
                </Link>
              </div>
              <ul className="space-y-1">
                {planTasks.length > 0 ? (
                  planTasks.map((task, index) => (
                    <li key={`${task.topicId ?? task.topicTitle}-${index}`}>
                      <Link
                        href={
                          task.topicId
                            ? `/practice?topicId=${task.topicId}`
                            : "/practice"
                        }
                        className="group flex items-center gap-3 rounded-xl px-2 py-2.5 transition-colors hover:bg-nexus-sunken"
                      >
                        <Circle className="size-5 flex-none text-nexus-border-strong group-hover:text-nexus-primary" />
                        <span className="flex-1 text-sm font-medium text-foreground">
                          {task.topicTitle}
                        </span>
                        <ArrowRight className="size-4 text-nexus-text-muted opacity-0 transition-opacity group-hover:opacity-100" />
                      </Link>
                    </li>
                  ))
                ) : (
                  <li>
                    <Link
                      href={practiceHref}
                      className="group flex items-center gap-3 rounded-xl px-2 py-2.5 transition-colors hover:bg-nexus-sunken"
                    >
                      <Circle className="size-5 flex-none text-nexus-border-strong group-hover:text-nexus-primary" />
                      <span className="flex-1 text-sm font-medium text-foreground">
                        Practise {recommendedTopic}
                      </span>
                      <ArrowRight className="size-4 text-nexus-text-muted opacity-0 transition-opacity group-hover:opacity-100" />
                    </Link>
                  </li>
                )}
              </ul>
            </section>
          )}

          {/* Continue learning */}
          <Link
            href={practiceHref}
            className="flex items-center gap-4 rounded-[22px] border border-nexus-border border-l-[3px] border-l-nexus-primary bg-nexus-surface p-5 shadow-card transition-transform active:scale-[0.99]"
          >
            <span className="flex size-12 flex-none items-center justify-center rounded-2xl bg-nexus-primary-soft text-nexus-primary">
              <Target className="size-5" />
            </span>
            <span className="min-w-0">
              <span className="block text-[11px] font-semibold uppercase tracking-wide text-nexus-text-muted">
                Continue learning
              </span>
              <span className="block font-heading text-lg font-medium text-foreground">
                {recommendedTopic}
              </span>
            </span>
            <ArrowRight className="ml-auto size-5 text-nexus-text-muted" />
          </Link>

          {/* Nex suggests */}
          {weakTopicForBrush ? (
            <Link
              href="/learn"
              className="flex items-center gap-4 rounded-[22px] border border-nexus-accent/40 bg-nexus-accent-soft p-5 transition-transform active:scale-[0.99]"
            >
              <span className="flex size-12 flex-none items-center justify-center rounded-2xl bg-nexus-accent text-nexus-text-primary">
                <Sparkles className="size-5" />
              </span>
              <span className="min-w-0">
                <span className="block text-[11px] font-semibold uppercase tracking-wide text-nexus-warning">
                  Nex suggests
                </span>
                <span className="block font-heading text-lg font-medium text-foreground">
                  Brush up: {weakTopicForBrush}
                </span>
                <span className="block text-xs text-muted-foreground">
                  Your weakest area right now
                </span>
              </span>
              <ArrowRight className="ml-auto size-5 text-nexus-text-muted" />
            </Link>
          ) : null}
        </div>

        {/* Right rail */}
        <aside className="space-y-4">
          {/* Daily goal */}
          <div className="flex items-center gap-4 rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card">
            <GoalRing value={minutesCompleted} max={dailyGoalMinutes} unit="m" />
            <div>
              <p className="text-sm font-semibold text-foreground">
                Today&apos;s goal
              </p>
              <p className="mt-0.5 text-xs text-muted-foreground">
                {minutesLeft > 0
                  ? `${minutesLeft} min to go`
                  : "Goal complete — nice work."}
              </p>
            </div>
          </div>

          {/* Streak */}
          <div className="rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card">
            <div className="mb-3 flex items-center gap-2">
              <Flame className="size-4 text-nexus-accent" />
              <p className="text-sm font-semibold text-foreground">
                <span className="tabular">{streak}</span>-day streak
              </p>
            </div>
            <StreakHeatmap currentStreak={streak} />
            <p className="mt-3 text-xs text-muted-foreground">
              Short daily sessions beat cramming. Keep the chain alive.
            </p>
          </div>

          {/* Level / XP */}
          <div className="rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card">
            <div className="mb-2 flex items-center justify-between">
              <div className="flex items-center gap-2">
                <Zap className="size-4 text-nexus-primary" />
                <p className="text-sm font-semibold text-foreground">
                  Level {level}
                </p>
              </div>
              <p className="text-xs text-muted-foreground tabular">
                {intoLevel}/{levelSize} XP
              </p>
            </div>
            <div className="h-2 w-full overflow-hidden rounded-full bg-nexus-sunken">
              <div
                className="h-full rounded-full bg-nexus-primary transition-all"
                style={{ width: `${Math.round(levelProgress * 100)}%` }}
              />
            </div>
          </div>

          {/* Upgrade */}
          <Link
            href="/pricing"
            className="block rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card"
          >
            <p className="text-sm font-semibold text-foreground">Go Premium</p>
            <p className="mt-1 text-xs text-muted-foreground">
              Free gives you {subscriptionConfig.limits.freeNex} Nex messages
              &amp; {subscriptionConfig.limits.freePractice} practice sessions a
              day. Upgrade for unlimited Nex, mock exams and more.
            </p>
            <span className="mt-3 inline-flex items-center gap-1 text-xs font-semibold text-nexus-primary">
              View plans <ArrowRight className="size-3.5" />
            </span>
          </Link>
        </aside>
      </div>
    </div>
  );
}
