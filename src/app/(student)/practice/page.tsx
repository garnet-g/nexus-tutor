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
import { listPracticeCurriculumTree } from "@/server/services/practiceService";

export default async function PracticePage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const profile = sessionUser.studentProfile;

  const [curriculumTree, subscriptionConfig, planCode, dailyUsage] =
    await Promise.all([
      listPracticeCurriculumTree(
        profile.curriculum,
        profile.grade_level,
        profile.id,
      ),
      getEffectiveSubscriptionConfigWithFallback(),
      getStudentPlanCode(profile.id),
      getPracticeDailyUsageCount(profile.id),
    ]);

  const dailyLimit = getPracticeDailyLimit(subscriptionConfig, planCode);

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          Practice
        </h1>
        <p className="text-muted-foreground">
          Ten focused questions per session. Pick a subject, topic, and chapter,
          then choose your difficulty.
        </p>
      </div>

      <Suspense fallback={<PracticePageSkeleton />}>
        <PracticeLanding
          studentId={profile.id}
          curriculumTree={curriculumTree}
          dailyUsage={dailyUsage}
          dailyLimit={dailyLimit}
          retryAfterSeconds={getSecondsUntilNairobiMidnight()}
          planCode={planCode}
        />
      </Suspense>
    </div>
  );
}
