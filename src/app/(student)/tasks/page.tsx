import Link from "next/link";
import { CheckCircle2, Circle } from "lucide-react";

import {
  EmptyStudentState,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function StudentTasksPage() {
  const experience = await requireStudentExperience();
  const tasks = experience.studyPlan?.tasks ?? [];

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Today"
        title="Tasks"
        description="Your study plan tasks for today, connected to the right topic or practice flow."
        action={{ href: "/study-plan", label: "Study plan" }}
      />

      {tasks.length > 0 ? (
        <section className="divide-y divide-nexus-border rounded-2xl border border-nexus-border bg-nexus-surface">
          {tasks.map((task) => (
            <Link
              key={task.id}
              href={task.topicId ? `/practice?topicId=${task.topicId}` : "/practice"}
              className="flex items-center gap-3 p-4 transition-colors hover:bg-nexus-sunken"
            >
              {task.isCompleted ? (
                <CheckCircle2 className="size-5 flex-none text-nexus-success" />
              ) : (
                <Circle className="size-5 flex-none text-nexus-text-muted" />
              )}
              <span className="min-w-0 flex-1">
                <span className="block font-semibold text-foreground">
                  {task.taskTitle || task.topicTitle || "Study task"}
                </span>
                <span className="block text-sm text-muted-foreground">
                  {task.topicTitle ?? "Practice"}
                </span>
              </span>
              <span className="text-xs text-muted-foreground">
                {task.dailyGoalMinutes}m
              </span>
            </Link>
          ))}
        </section>
      ) : (
        <EmptyStudentState
          title="No tasks for today"
          description="Generate a study plan to get daily tasks based on your diagnostic and practice work."
          href="/study-plan"
          label="Create study plan"
        />
      )}
    </div>
  );
}
