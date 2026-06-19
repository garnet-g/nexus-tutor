import Link from "next/link";
import { redirect } from "next/navigation";

import {
  StudyPlanActions,
  StudyPlanEmptyState,
  StudyPlanTaskList,
} from "@/features/studyPlan/components/StudyPlanView";
import { getSessionUser } from "@/server/services/authService";
import { getActiveStudyPlan } from "@/server/services/studyPlanService";

const actionLinkClass =
  "inline-flex min-h-11 items-center justify-center rounded-lg px-4 py-2 text-sm font-medium transition-colors";

export default async function StudyPlanPage() {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  if (!sessionUser.studentProfile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const plan = await getActiveStudyPlan(sessionUser.studentProfile.id);

  return (
    <div className="space-y-8">
      <div className="space-y-2">
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          Study plan
        </h1>
        <p className="text-muted-foreground">
          Daily goals and weak-topic prioritization based on your diagnostic and
          practice performance.
        </p>
      </div>

      <section className="rounded-2xl border border-border bg-card p-6">
        <h2 className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
          Today&apos;s goal
        </h2>
        {plan?.dailyGoal ? (
          <div className="mt-3 space-y-2">
            <p className="text-2xl font-semibold text-foreground">
              {plan.dailyGoal.minutesCompleted}/{plan.dailyGoal.dailyGoalMinutes}{" "}
              minutes
            </p>
            <div className="h-2 overflow-hidden rounded-full bg-muted">
              <div
                className="h-full rounded-full bg-primary"
                style={{
                  width: `${Math.min(
                    100,
                    Math.round(
                      (plan.dailyGoal.minutesCompleted /
                        plan.dailyGoal.dailyGoalMinutes) *
                        100,
                    ),
                  )}%`,
                }}
              />
            </div>
            <p className="text-sm text-muted-foreground">
              {plan.dailyGoal.isCompleted
                ? "Daily goal complete."
                : "Complete lessons or practice to reach your goal."}
            </p>
            {!plan.dailyGoal.isCompleted ? (
              <div className="flex flex-col gap-2 pt-2 sm:flex-row sm:flex-wrap">
                <Link
                  href="/practice"
                  className={`${actionLinkClass} bg-primary text-primary-foreground hover:bg-primary/90`}
                >
                  Start practice
                </Link>
                <Link
                  href="/learn"
                  className={`${actionLinkClass} border border-border text-foreground hover:bg-muted`}
                >
                  Browse Learn
                </Link>
              </div>
            ) : null}
          </div>
        ) : (
          <p className="mt-3 text-sm text-muted-foreground">
            Your daily goal will appear after your first diagnostic or plan
            generation.
          </p>
        )}
      </section>

      <StudyPlanActions hasPlan={Boolean(plan)} />

      {plan ? (
        <div className="space-y-4">
          <h2 className="text-lg font-medium text-foreground">{plan.title}</h2>
          <StudyPlanTaskList plan={plan} />
        </div>
      ) : (
        <StudyPlanEmptyState />
      )}
    </div>
  );
}
