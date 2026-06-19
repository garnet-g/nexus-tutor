import { redirect } from "next/navigation";

import { PageHeader } from "@/components/layout/page-header";
import { StatCard } from "@/components/layout/stat-card";
import {
  DashboardEmptyStates,
  shouldShowDashboardEmptyState,
} from "@/features/dashboard/components/DashboardEmptyStates";
import { getEffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { getSessionUser } from "@/server/services/authService";
import { getLatestHealthScore } from "@/server/services/diagnosticService";
import { getProgressSummary } from "@/server/services/practiceService";
import { getActiveStudyPlan } from "@/server/services/studyPlanService";

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

  const dailyGoalCompleted = studyPlan?.dailyGoal?.isCompleted ?? false;
  const dailyGoalMinutes = studyPlan?.dailyGoal?.dailyGoalMinutes ?? 20;
  const dailyGoalProgress = studyPlan?.dailyGoal
    ? `${studyPlan.dailyGoal.minutesCompleted}/${studyPlan.dailyGoal.dailyGoalMinutes} min`
    : `0/${dailyGoalMinutes} min`;

  const firstName = profile.full_name?.split(" ")[0];
  const showEmptyState = shouldShowDashboardEmptyState({
    topicMastery: progress.topicMastery,
    totalXp: progress.totalXp,
    currentStreak: progress.currentStreak,
    hasStudyPlanTasks: (studyPlan?.tasks.length ?? 0) > 0,
  });

  return (
    <div className="flex flex-col gap-10">
      <PageHeader
        eyebrow="Dashboard"
        title={`Welcome back${firstName ? `, ${firstName}` : ""}`}
        description={`${profile.curriculum} · ${profile.grade_level}${profile.target_grade ? ` · Target ${profile.target_grade}` : ""}`}
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Academic Health Score"
          value={`${Number(health?.health_score ?? 0)}/100`}
          description={`Predicted ${profile.curriculum} grade: ${health?.predicted_grade ?? "—"}`}
          insight="Your health score reflects diagnostic and practice performance across subjects."
          href="/progress"
          linkLabel="Review progress"
          accent="primary"
        />
        <StatCard
          label="Streak"
          value={`${progress.currentStreak} days`}
          description={
            progress.currentStreak > 0
              ? "You are building a daily learning habit."
              : "Start a session today to begin your streak."
          }
          insight="Short daily sessions beat occasional long cramming for retention."
          href="/learn"
          linkLabel="Learn today"
          accent="accent"
        />
        <StatCard
          label="Recommended topic"
          value={recommendedTopic}
          description="Based on your study plan and weakest mastery areas."
          insight={`Focus on ${recommendedTopic} to lift your overall health score.`}
          href={practiceHref}
          linkLabel="Practice this topic"
          accent="secondary"
        />
        <StatCard
          label="Today's goal"
          value={dailyGoalProgress}
          description={
            dailyGoalCompleted
              ? "Daily goal complete — great work."
              : `${Math.max(0, dailyGoalMinutes - (studyPlan?.dailyGoal?.minutesCompleted ?? 0))} minutes left today.`
          }
          insight="Hitting your daily goal keeps your study plan on track."
          href="/study-plan"
          linkLabel="View study plan"
        />
      </section>

      <DashboardEmptyStates showEmptyState={showEmptyState} />

      <section className="grid gap-4 sm:grid-cols-2">
        <StatCard
          label="Free daily limits"
          value={`${subscriptionConfig.limits.freeNex} Nex messages`}
          description={`${subscriptionConfig.limits.freePractice} practice sessions per day`}
          insight="Upgrade for unlimited Nex help and mock exams when you need more."
        />
        <StatCard
          label="Premium from"
          value={
            <>
              KES {subscriptionConfig.pricing.premiumAmountKes.toLocaleString()}
              <span className="text-base font-normal text-muted-foreground">/mo</span>
            </>
          }
          description={
            subscriptionConfig.promotion.isActive && subscriptionConfig.promotion.title
              ? subscriptionConfig.promotion.title
              : `Family plan KES ${subscriptionConfig.pricing.familyAmountKes.toLocaleString()}/mo`
          }
          insight="Premium unlocks full Exam Prep tools and higher daily limits."
          href="/pricing"
          linkLabel="View plans"
          accent="primary"
        />
      </section>
    </div>
  );
}
