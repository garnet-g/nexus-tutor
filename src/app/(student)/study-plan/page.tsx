import { redirect } from "next/navigation";

import {
  StudyPlanActions,
  StudyPlanEmptyState,
  StudyPlanTaskList,
} from "@/features/studyPlan/components/StudyPlanView";
import {
  StudyPlanDailyGoal,
  StudyPlanExamCountdown,
} from "@/features/studyPlan/components/StudyPlanSections";
import { getSessionUser } from "@/server/services/authService";
import {
  canAccessExamStudyPlan,
  getStudentPlanCode,
} from "@/server/services/subscriptionService";
import { getActiveStudyPlan } from "@/server/services/studyPlanService";

export default async function StudyPlanPage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const profile = sessionUser.studentProfile;
  const [plan, planCode] = await Promise.all([
    getActiveStudyPlan(profile.id),
    getStudentPlanCode(profile.id),
  ]);

  const canGenerateExamPlan = canAccessExamStudyPlan(planCode);
  const isUpperForm =
    profile.grade_level.toLowerCase().includes("form 3") ||
    profile.grade_level.toLowerCase().includes("form 4");

  return (
    <div className="space-y-6 nexus-enter">
      <header className="space-y-2">
        <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
          Study plan
        </p>
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          Your daily roadmap
        </h1>
        <p className="text-muted-foreground">
          Daily goals and weak-topic prioritisation from your diagnostic and
          practice performance.
        </p>
        {isUpperForm ? (
          <p className="inline-flex rounded-full border border-border px-3 py-1 text-xs font-medium text-foreground">
            KCSE exam countdown active for {profile.grade_level}
          </p>
        ) : null}
      </header>

      <div className="grid gap-6 lg:grid-cols-2">
        {plan?.dailyGoal ? (
          <StudyPlanDailyGoal
            minutesCompleted={plan.dailyGoal.minutesCompleted}
            dailyGoalMinutes={plan.dailyGoal.dailyGoalMinutes}
            isCompleted={plan.dailyGoal.isCompleted}
          />
        ) : (
          <StudyPlanDailyGoal
            minutesCompleted={0}
            dailyGoalMinutes={20}
            isCompleted={false}
          />
        )}

        <StudyPlanExamCountdown
          examCountdownDays={plan?.examCountdownDays ?? null}
          targetCompletionDate={plan?.targetCompletionDate ?? null}
          planTitle={plan?.planType === "exam" ? plan.title : null}
          canAccessExamPlan={canGenerateExamPlan}
        />
      </div>

      <StudyPlanActions
        hasPlan={Boolean(plan)}
        canGenerateExamPlan={canGenerateExamPlan}
      />

      {plan ? <StudyPlanTaskList plan={plan} /> : <StudyPlanEmptyState />}
    </div>
  );
}
