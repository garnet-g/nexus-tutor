"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useState } from "react";
import { BookOpen, Target } from "lucide-react";

import { EmptyState } from "@/components/ui/EmptyState";
import { SectionCard } from "@/components/ui/SectionCard";
import { Button } from "@/components/ui/Button";
import { useToast } from "@/components/ui/Toast";
import { AsyncActionButton } from "@/components/ui/async-action-button";
import type { getActiveStudyPlan } from "@/server/services/studyPlanService";
import { cn } from "@/lib/utils";

type ActivePlan = NonNullable<Awaited<ReturnType<typeof getActiveStudyPlan>>>;

export function StudyPlanEmptyState() {
  return (
    <EmptyState
      icon={<BookOpen className="size-6" />}
      title="No study plan yet"
      description="Generate a daily plan from your diagnostic results, or start practicing while Nexus learns your weak topics."
      primaryAction={{ label: "Generate daily plan", href: "#study-plan-actions" }}
      secondaryAction={{ label: "Start practice", href: "/practice" }}
    />
  );
}

interface StudyPlanActionsProps {
  hasPlan: boolean;
  canGenerateExamPlan: boolean;
}

export function StudyPlanActions({
  hasPlan,
  canGenerateExamPlan,
}: StudyPlanActionsProps) {
  const router = useRouter();
  const { toast } = useToast();
  const [loadingType, setLoadingType] = useState<"daily" | "exam" | null>(
    null,
  );
  const [message, setMessage] = useState<string | null>(null);

  async function regeneratePlan(planType: "daily" | "exam") {
    setLoadingType(planType);
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

      toast({
        tone: "success",
        title: planType === "exam" ? "Exam plan ready" : "Daily plan ready",
        description: payload.data?.title ?? "Your study plan has been updated.",
      });
      router.refresh();
    } catch (error) {
      const errorMessage =
        error instanceof Error ? error.message : "Could not regenerate plan.";
      setMessage(errorMessage);
      toast({
        tone: "error",
        title: "Could not generate plan",
        description: errorMessage,
      });
    } finally {
      setLoadingType(null);
    }
  }

  return (
    <SectionCard
      id="study-plan-actions"
      title="Refresh your plan"
      description="Daily plans prioritise weak topics. Exam plans span 14 days (Premium/trial)."
    >
      <div className="flex flex-col gap-3 sm:flex-row sm:flex-wrap">
        <AsyncActionButton
          type="button"
          isPending={loadingType === "daily"}
          idleLabel={hasPlan ? "Refresh daily plan" : "Generate daily plan"}
          pendingLabel="Generating..."
          className="min-h-12"
          onClick={() => void regeneratePlan("daily")}
        />
        {canGenerateExamPlan ? (
          <AsyncActionButton
            type="button"
            variant="outline"
            isPending={loadingType === "exam"}
            idleLabel="Generate 14-day exam plan"
            pendingLabel="Generating..."
            className="min-h-12"
            onClick={() => void regeneratePlan("exam")}
          />
        ) : (
          <Button
            variant="outline"
            render={<Link href="/pricing" />}
            className="min-h-12"
          >
            Upgrade for exam plan
          </Button>
        )}
      </div>
      {message ? (
        <p className="mt-3 text-sm text-nexus-danger" role="alert">
          {message}
        </p>
      ) : null}
    </SectionCard>
  );
}

function taskPracticeHref(topicId: string | null) {
  if (!topicId) {
    return "/practice";
  }

  return `/practice?topicId=${encodeURIComponent(topicId)}`;
}

export function StudyPlanTaskList({ plan }: { plan: ActivePlan }) {
  const router = useRouter();
  const { toast } = useToast();
  const [pendingTaskId, setPendingTaskId] = useState<string | null>(null);

  async function toggleTask(taskId: string, completed: boolean) {
    setPendingTaskId(taskId);

    try {
      const response = await fetch(`/api/study-plans/tasks/${taskId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ completed }),
      });
      const payload = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error?.message ?? "Could not update task.");
      }

      router.refresh();
    } catch (error) {
      toast({
        tone: "error",
        title: "Could not update task",
        description:
          error instanceof Error ? error.message : "Please try again.",
      });
    } finally {
      setPendingTaskId(null);
    }
  }

  if (plan.tasks.length === 0) {
    return (
      <EmptyState
        icon={<Target className="size-6" />}
        title="No tasks scheduled for today"
        description="Generate a daily plan to get weak-topic tasks, or jump straight into practice."
        primaryAction={{ label: "Start practice", href: "/practice" }}
        secondaryAction={{ label: "Browse Learn", href: "/learn" }}
      />
    );
  }

  return (
    <SectionCard title={plan.title} description="Today's checklist">
      <ul className="space-y-3">
        {plan.tasks.map((task) => {
          const isPending = pendingTaskId === task.id;

          return (
            <li
              key={task.id}
              className={cn(
                "rounded-xl border border-nexus-border bg-nexus-surface p-4 transition-colors",
                task.isCompleted && "border-nexus-success/30 bg-nexus-success-soft/30",
              )}
            >
              <div className="flex items-start gap-3">
                <input
                  type="checkbox"
                  checked={task.isCompleted}
                  disabled={isPending}
                  onChange={(event) =>
                    void toggleTask(task.id, event.target.checked)
                  }
                  className="mt-1 size-5 shrink-0 rounded border-nexus-border accent-[var(--nexus-primary)] focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
                  aria-label={`Mark ${task.taskTitle} as ${task.isCompleted ? "incomplete" : "complete"}`}
                />
                <div className="min-w-0 flex-1">
                  <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                    {task.taskType.replaceAll("_", " ")}
                  </p>
                  <p
                    className={cn(
                      "mt-1 font-medium text-foreground",
                      task.isCompleted && "line-through opacity-70",
                    )}
                  >
                    {task.taskTitle}
                  </p>
                  {task.topicTitle ? (
                    <p className="mt-1 text-sm text-muted-foreground">
                      {task.topicTitle}
                    </p>
                  ) : null}
                  {!task.isCompleted && task.topicId ? (
                    <Button
                      variant="ghost"
                      size="sm"
                      render={<Link href={taskPracticeHref(task.topicId)} />}
                      className="mt-3 min-h-12 px-0 text-nexus-primary hover:bg-transparent"
                    >
                      Practice this topic →
                    </Button>
                  ) : null}
                </div>
              </div>
            </li>
          );
        })}
      </ul>
    </SectionCard>
  );
}
