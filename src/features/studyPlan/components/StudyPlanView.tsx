"use client";

import Link from "next/link";
import { useState } from "react";

import { AsyncActionButton } from "@/components/ui/async-action-button";
import type { getActiveStudyPlan } from "@/server/services/studyPlanService";

type ActivePlan = NonNullable<Awaited<ReturnType<typeof getActiveStudyPlan>>>;

const actionLinkClass =
  "inline-flex min-h-11 items-center justify-center rounded-lg px-4 py-2 text-sm font-medium transition-colors";

export function StudyPlanEmptyState() {
  return (
    <div className="rounded-2xl border border-border bg-card p-6">
      <p className="text-sm font-medium text-foreground">No study plan yet</p>
      <p className="mt-2 text-sm text-muted-foreground">
        Generate a plan from your diagnostic results, or start practicing while
        Nexus learns your weak topics.
      </p>
      <div className="mt-4 flex flex-col gap-2 sm:flex-row sm:flex-wrap">
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
    </div>
  );
}

export function StudyPlanActions({ hasPlan }: { hasPlan: boolean }) {
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  async function regeneratePlan(planType: "daily" | "exam") {
    setLoading(true);
    setMessage(null);

    try {
      const response = await fetch("/api/study-plans", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          planType,
          dailyGoalMinutes: 20,
          ...(planType === "exam" ? { examCountdownDays: 14 } : {}),
        }),
      });
      const payload = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error?.message ?? "Could not regenerate plan.");
      }

      window.location.reload();
    } catch (error) {
      setMessage(
        error instanceof Error ? error.message : "Could not regenerate plan.",
      );
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="space-y-3">
      <div className="flex flex-wrap gap-3">
        <AsyncActionButton
          type="button"
          isPending={loading}
          idleLabel={hasPlan ? "Refresh daily plan" : "Generate daily plan"}
          pendingLabel="Generating..."
          onClick={() => void regeneratePlan("daily")}
        />
        <AsyncActionButton
          type="button"
          variant="outline"
          isPending={loading}
          idleLabel="Generate 14-day exam plan"
          pendingLabel="Generating..."
          onClick={() => void regeneratePlan("exam")}
        />
      </div>
      {message ? <p className="text-sm text-destructive">{message}</p> : null}
    </div>
  );
}

function taskPracticeHref(topicId: string | null) {
  if (!topicId) {
    return "/practice";
  }

  return `/practice?topicId=${encodeURIComponent(topicId)}`;
}

export function StudyPlanTaskList({ plan }: { plan: ActivePlan }) {
  return (
    <div className="space-y-4">
      {plan.tasks.length > 0 ? (
        plan.tasks.map((task) => (
          <div
            key={task.id}
            className="rounded-2xl border border-border bg-card p-5"
          >
            <div className="flex items-start justify-between gap-4">
              <div>
                <p className="text-xs uppercase tracking-wide text-muted-foreground">
                  {task.taskType}
                </p>
                <h3 className="mt-1 text-lg font-medium text-foreground">
                  {task.taskTitle}
                </h3>
                {task.topicTitle ? (
                  <p className="mt-1 text-sm text-muted-foreground">
                    {task.topicTitle}
                  </p>
                ) : null}
              </div>
              <span
                className={
                  task.isCompleted
                    ? "rounded-full bg-emerald-100 px-3 py-1 text-xs text-emerald-800"
                    : "rounded-full bg-muted px-3 py-1 text-xs text-foreground/80"
                }
              >
                {task.isCompleted ? "Done" : "Pending"}
              </span>
            </div>
            {!task.isCompleted ? (
              <div className="mt-4">
                <Link
                  href={taskPracticeHref(task.topicId)}
                  className={`${actionLinkClass} bg-primary text-primary-foreground hover:bg-primary/90`}
                >
                  {task.topicId ? "Practice this topic" : "Start practice"}
                </Link>
              </div>
            ) : null}
          </div>
        ))
      ) : (
        <div className="rounded-2xl border border-border bg-card p-6">
          <p className="text-sm font-medium text-foreground">
            No tasks scheduled for today
          </p>
          <p className="mt-2 text-sm text-muted-foreground">
            Generate a daily plan to get weak-topic tasks, or jump straight into
            practice while your plan refreshes.
          </p>
          <div className="mt-4 flex flex-col gap-2 sm:flex-row sm:flex-wrap">
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
        </div>
      )}
    </div>
  );
}
