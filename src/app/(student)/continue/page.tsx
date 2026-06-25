import { ArrowRight, BookOpen, Target } from "lucide-react";
import Link from "next/link";

import {
  EmptyStudentState,
  LinkedPanel,
  MetricRow,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function ContinueLearningPage() {
  const experience = await requireStudentExperience();

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Today"
        title="Continue learning"
        description="Pick up from your latest lesson, study task, or practice session without digging through the app."
      />

      <MetricRow
        metrics={[
          { label: "Streak", value: experience.progress.currentStreak, detail: "days active" },
          { label: "Level", value: experience.level.level, detail: "current XP level" },
          { label: "Health score", value: experience.progress.healthScore, detail: "latest score" },
          { label: "Saved", value: experience.savedItems.length, detail: "items to revisit" },
        ]}
      />

      <section className="rounded-2xl border border-nexus-border bg-nexus-surface p-5">
        <p className="text-sm font-semibold text-foreground">Best next step</p>
        <Link
          href={experience.snapshot.primaryAction.href}
          className="mt-3 flex items-center gap-4 rounded-2xl bg-nexus-primary-soft p-4 text-nexus-primary"
        >
          <Target className="size-5 flex-none" />
          <span className="min-w-0 flex-1">
            <span className="block text-xs font-semibold uppercase tracking-[0.16em]">
              {experience.snapshot.primaryAction.label}
            </span>
            <span className="block truncate text-lg font-semibold">
              {experience.snapshot.primaryAction.title}
            </span>
          </span>
          <ArrowRight className="size-5" />
        </Link>
      </section>

      <div className="grid gap-4 lg:grid-cols-2">
        {experience.recentLessons.length > 0 ? (
          experience.recentLessons.map((lesson) => (
            <LinkedPanel
              key={lesson.lessonId}
              href={lesson.href}
              title={lesson.lessonTitle}
              description={`${lesson.topicTitle} - ${lesson.status.replace("_", " ")}`}
              eyebrow="Recent lesson"
              icon={BookOpen}
            />
          ))
        ) : (
          <EmptyStudentState
            title="No recent lessons yet"
            description="Open a lesson once and it will appear here for quick access."
            href="/learn"
            label="Browse lessons"
          />
        )}

        {experience.recentPractice.map((session) => (
          <LinkedPanel
            key={session.id}
            href={session.href}
            title={session.topicTitle}
            description={`${session.difficulty} practice - ${session.status.replace("_", " ")}`}
            eyebrow="Recent practice"
            icon={Target}
          />
        ))}
      </div>
    </div>
  );
}
