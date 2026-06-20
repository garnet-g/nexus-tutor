import { Suspense } from "react";
import { redirect } from "next/navigation";

import { PracticeLanding } from "@/features/practice/components/PracticeLanding";
import { PracticePageSkeleton } from "@/components/ui/Skeleton";
import {
  getEffectiveSubscriptionConfigWithFallback,
  getPracticeDailyLimit,
} from "@/lib/platform/getPlatformSettings";
import { getSessionUser } from "@/server/services/authService";
import {
  getPracticeDailyUsageCount,
  getSecondsUntilNairobiMidnight,
  getStudentPlanCode,
} from "@/server/services/nexUsageService";
import {
  getProgressSummary,
  listPracticeTopics,
} from "@/server/services/practiceService";

export default async function PracticePage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const profile = sessionUser.studentProfile;

  const [topics, progress, subscriptionConfig, planCode, dailyUsage] =
    await Promise.all([
      listPracticeTopics(profile.curriculum),
      getProgressSummary(profile.id).catch(() => null),
      getEffectiveSubscriptionConfigWithFallback(),
      getStudentPlanCode(profile.id),
      getPracticeDailyUsageCount(profile.id),
    ]);

  const masteryByTopicId = Object.fromEntries(
    (progress?.topicMastery ?? []).map((entry) => [
      entry.topicId,
      entry.masteryPercentage,
    ]),
  );

  const dailyLimit = getPracticeDailyLimit(subscriptionConfig, planCode);

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          Practice
        </h1>
        <p className="text-muted-foreground">
          Ten focused questions per session. Pick a topic, choose your difficulty,
          and build mastery one step at a time.
        </p>
      </div>

      <Suspense fallback={<PracticePageSkeleton />}>
        <PracticeLanding
          studentId={profile.id}
          topics={topics.map((topic) => ({
            ...topic,
            masteryPercentage: masteryByTopicId[topic.id] ?? 0,
          }))}
          dailyUsage={dailyUsage}
          dailyLimit={dailyLimit}
          retryAfterSeconds={getSecondsUntilNairobiMidnight()}
          planCode={planCode}
        />
      </Suspense>
    </div>
  );
}
