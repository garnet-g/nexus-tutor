import Link from "next/link";
import { CalendarClock, Sparkles } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import { GoalRing } from "@/components/widgets/StatWidgets";

interface StudyPlanDailyGoalProps {
  minutesCompleted: number;
  dailyGoalMinutes: number;
  isCompleted: boolean;
}

export function StudyPlanDailyGoal({
  minutesCompleted,
  dailyGoalMinutes,
  isCompleted,
}: StudyPlanDailyGoalProps) {
  return (
    <SectionCard
      title="Today's goal"
      description="Lessons and practice count toward your daily minutes."
    >
      <div className="flex flex-col items-center gap-4 sm:flex-row sm:items-start">
        <GoalRing
          value={minutesCompleted}
          max={dailyGoalMinutes}
          label="min"
          size={112}
        />
        <div className="space-y-2 text-center sm:text-left">
          <p className="font-heading text-2xl font-semibold tabular text-foreground">
            {minutesCompleted}/{dailyGoalMinutes} minutes
          </p>
          <p className="text-sm text-muted-foreground">
            {isCompleted
              ? "Daily goal complete — great consistency."
              : "Complete lessons or practice to reach your goal."}
          </p>
          {!isCompleted ? (
            <div className="flex flex-col gap-2 pt-1 sm:flex-row sm:flex-wrap">
              <Button render={<Link href="/practice" />} className="min-h-12">
                Start practice
              </Button>
              <Button
                variant="outline"
                render={<Link href="/learn" />}
                className="min-h-12"
              >
                Browse Learn
              </Button>
            </div>
          ) : null}
        </div>
      </div>
    </SectionCard>
  );
}

interface StudyPlanExamCountdownProps {
  examCountdownDays: number | null;
  targetCompletionDate: string | null;
  planTitle: string | null;
  canAccessExamPlan: boolean;
}

export function StudyPlanExamCountdown({
  examCountdownDays,
  targetCompletionDate,
  planTitle,
  canAccessExamPlan,
}: StudyPlanExamCountdownProps) {
  if (!canAccessExamPlan) {
    return (
      <SectionCard
        title="Exam countdown plan"
        description="Premium and trial students get structured exam prep schedules."
      >
        <p className="text-sm text-muted-foreground">
          Exam study plans are included with Premium or Family — core learning
          stays free forever.
        </p>
        <Button render={<Link href="/pricing" />} className="mt-4 min-h-12">
          <Sparkles className="size-4" data-icon="inline-start" />
          View upgrade options
        </Button>
      </SectionCard>
    );
  }

  if (!examCountdownDays && !targetCompletionDate) {
    return (
      <SectionCard
        title="Exam countdown"
        description="Generate a 14-day exam plan when you are preparing for mocks or finals."
      >
        <p className="text-sm text-muted-foreground">
          No active exam plan yet — use &ldquo;Generate 14-day exam plan&rdquo;
          below when you are ready.
        </p>
      </SectionCard>
    );
  }

  const targetLabel = targetCompletionDate
    ? new Date(`${targetCompletionDate}T12:00:00`).toLocaleDateString("en-KE", {
        weekday: "short",
        month: "short",
        day: "numeric",
      })
    : null;

  return (
    <SectionCard
      className="border-nexus-primary/20 bg-nexus-primary-soft/20"
      title={planTitle ?? "Exam study plan"}
      description="Premium exam countdown — stay on track toward your target date."
    >
      <div className="flex items-start gap-3">
        <span className="flex size-11 items-center justify-center rounded-xl bg-nexus-primary-soft text-nexus-primary">
          <CalendarClock className="size-5" aria-hidden />
        </span>
        <div>
          {examCountdownDays ? (
            <p className="font-heading text-2xl font-semibold tabular text-foreground">
              {examCountdownDays} days
            </p>
          ) : null}
          {targetLabel ? (
            <p className="text-sm text-muted-foreground">
              Target completion: {targetLabel}
            </p>
          ) : null}
        </div>
      </div>
    </SectionCard>
  );
}
