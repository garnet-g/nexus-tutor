import { redirect } from "next/navigation";

import { ProgressBadgesSection } from "@/features/progress/components/ProgressBadgesSection";
import { ProgressFocusCard } from "@/features/progress/components/ProgressFocusCard";
import { ProgressHealthCard } from "@/features/progress/components/ProgressHealthCard";
import { ProgressMasterySection } from "@/features/progress/components/ProgressMasterySection";
import { ProgressStreakSection } from "@/features/progress/components/ProgressStreakSection";
import { ProgressWeeklySummary } from "@/features/progress/components/ProgressWeeklySummary";
import { ProgressXpSection } from "@/features/progress/components/ProgressXpSection";
import { getSessionUser } from "@/server/services/authService";
import { getHealthScoreHistory } from "@/server/services/diagnosticService";
import { getProgressSummary } from "@/server/services/practiceService";
import { getStudentWeeklySummary } from "@/server/services/weeklyReportService";

export default async function ProgressPage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const profile = sessionUser.studentProfile;

  const [summary, healthHistory, weeklySummary] = await Promise.all([
    getProgressSummary(profile.id),
    getHealthScoreHistory(profile.id),
    getStudentWeeklySummary(profile.id),
  ]);

  const weakestTopic = summary.topicMastery
    .slice()
    .sort((left, right) => left.masteryPercentage - right.masteryPercentage)[0];

  return (
    <div className="space-y-6 nexus-enter">
      <header className="space-y-2">
        <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
          Progress
        </p>
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          Your learning journey
        </h1>
        <p className="text-muted-foreground">
          Health score, mastery, streak, XP, and badges — all from your real
          activity.
        </p>
      </header>

      <ProgressFocusCard
        focusTopicTitle={weakestTopic?.title ?? null}
        focusTopicId={weakestTopic?.topicId ?? null}
        focusMastery={weakestTopic?.masteryPercentage ?? null}
      />

      <div className="grid gap-6 lg:grid-cols-2">
        <div className="space-y-6">
          <ProgressHealthCard
            healthScore={summary.healthScore}
            predictedGrade={summary.predictedGrade}
            history={healthHistory}
          />
          <ProgressXpSection totalXp={summary.totalXp} />
          <ProgressWeeklySummary summary={weeklySummary} />
        </div>

        <div className="space-y-6">
          <ProgressStreakSection
            currentStreak={summary.currentStreak}
            longestStreak={summary.longestStreak}
          />
          <ProgressMasterySection topics={summary.topicMastery} />
          <ProgressBadgesSection
            earnedBadges={summary.badges}
            badgeEarnedAt={summary.badgeEarnedAt}
          />
        </div>
      </div>
    </div>
  );
}
