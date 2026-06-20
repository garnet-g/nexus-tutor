"use client";

import Link from "next/link";
import { useMemo } from "react";
import {
  CheckCircle2,
  Circle,
  Lock,
  MessageCircle,
  Target,
} from "lucide-react";

import { EmptyState } from "@/components/ui/EmptyState";
import { SectionCard } from "@/components/ui/SectionCard";
import { Button } from "@/components/ui/Button";
import { ProgressRing } from "@/components/widgets/Charts";
import {
  getCompletedLessonIds,
  getLessonPathStatus,
  inferLessonType,
} from "@/lib/learn/lessonProgress";
import {
  getTopicMasteryStatus,
  getTopicMasteryLabel,
} from "@/lib/learn/masteryStatus";
import type { CurriculumTopicDetail } from "@/types/curriculum";

interface TopicLearningPathProps {
  topic: CurriculumTopicDetail;
  studentId: string;
  masteryPercentage?: number;
}

export function TopicLearningPath({
  topic,
  studentId,
  masteryPercentage = 0,
}: TopicLearningPathProps) {
  const orderedLessons = useMemo(
    () =>
      topic.subtopics.flatMap((subtopic) =>
        subtopic.lessons.map((lesson) => ({
          ...lesson,
          subtopicTitle: subtopic.title,
        })),
      ),
    [topic.subtopics],
  );

  const orderedLessonIds = orderedLessons.map((lesson) => lesson.id);
  const completedLessonIds = getCompletedLessonIds(studentId);
  const masteryStatus = getTopicMasteryStatus(masteryPercentage);
  const totalMinutes = orderedLessons.reduce(
    (sum, lesson) => sum + lesson.estimatedMinutes,
    0,
  );

  if (orderedLessons.length === 0) {
    return (
      <EmptyState
        title="Lessons coming soon"
        description="This topic is being prepared for your curriculum. Check back after the next content update, or practise related skills in the meantime."
        primaryAction={{ label: "Start practice", href: "/practice" }}
        secondaryAction={{ label: "Ask Nex", href: `/nex?topicId=${topic.id}&mode=explain` }}
      />
    );
  }

  return (
    <div className="grid gap-8 lg:grid-cols-[minmax(0,1fr)_320px]">
      <div className="space-y-6 nexus-enter">
        <div className="space-y-2">
          <p className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
            {topic.subjectName}
          </p>
          <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
            {topic.title}
          </h1>
          {topic.description ? (
            <p className="max-w-2xl text-muted-foreground">{topic.description}</p>
          ) : null}
        </div>

        <ol className="relative space-y-0">
          {orderedLessons.map((lesson, index) => {
            const status = getLessonPathStatus(
              lesson.id,
              orderedLessonIds,
              completedLessonIds,
            );
            const isLast = index === orderedLessons.length - 1;
            const lessonType = inferLessonType({
              title: lesson.title,
              hasExamples: /example|worked/i.test(lesson.title),
              hasQuiz: /quiz|check|checkpoint/i.test(lesson.title),
            });

            return (
              <li key={lesson.id} className="relative flex gap-4 pb-8">
                {!isLast ? (
                  <span
                    aria-hidden
                    className="absolute left-[17px] top-10 h-[calc(100%-12px)] w-px bg-nexus-border"
                  />
                ) : null}

                <div className="relative z-[1] mt-1 flex size-9 flex-none items-center justify-center rounded-full border border-nexus-border bg-nexus-surface">
                  {status === "done" ? (
                    <CheckCircle2 className="size-5 text-nexus-success" />
                  ) : status === "locked" ? (
                    <Lock className="size-4 text-nexus-text-muted" />
                  ) : (
                    <Circle className="size-4 text-nexus-primary" />
                  )}
                </div>

                <div className="min-w-0 flex-1">
                  {status === "locked" ? (
                    <div className="rounded-[22px] border border-dashed border-nexus-border bg-nexus-sunken/60 p-4 opacity-80">
                      <p className="font-medium text-foreground">{lesson.title}</p>
                      <p className="mt-1 text-sm text-muted-foreground">
                        Complete the previous lesson to unlock.
                      </p>
                    </div>
                  ) : (
                    <Link
                      href={`/learn/${topic.id}/${lesson.id}`}
                      className="nexus-card-hover block rounded-[22px] border border-nexus-border bg-nexus-surface p-4 shadow-card focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
                    >
                      <div className="flex flex-wrap items-center gap-2">
                        <span className="rounded-full bg-nexus-primary-soft px-2.5 py-1 text-xs font-medium text-nexus-primary">
                          {lessonType}
                        </span>
                        <span className="text-xs text-muted-foreground">
                          {lesson.estimatedMinutes} min
                        </span>
                      </div>
                      <p className="mt-2 font-medium text-foreground">
                        {lesson.title}
                      </p>
                      <p className="mt-1 text-sm text-muted-foreground">
                        {lesson.subtopicTitle}
                      </p>
                    </Link>
                  )}
                </div>
              </li>
            );
          })}

          <li className="relative flex gap-4">
            <div className="mt-1 flex size-9 flex-none items-center justify-center rounded-full border border-nexus-border bg-nexus-accent-soft">
              <Target className="size-4 text-nexus-warning" />
            </div>
            <div className="rounded-[22px] border border-nexus-border bg-nexus-accent-soft/40 p-4">
              <p className="font-medium text-foreground">Mastery checkpoint</p>
              <p className="mt-1 text-sm text-muted-foreground">
                Finish the lesson quizzes to prove you understand this topic.
              </p>
            </div>
          </li>
        </ol>
      </div>

      <aside className="lg:sticky lg:top-24 lg:self-start">
        <SectionCard
          title="Topic summary"
          description={`${orderedLessons.length} lessons · ${totalMinutes} min total`}
        >
          <div className="flex flex-col items-center gap-4">
            <ProgressRing
              value={masteryPercentage}
              max={100}
              label="Mastery"
              size={112}
            />
            <p className="text-sm text-muted-foreground">
              {getTopicMasteryLabel(masteryStatus)}
            </p>
          </div>

          <div className="mt-6 space-y-2">
            <Button
              render={<Link href={`/practice?topicId=${topic.id}`} />}
              className="min-h-12 w-full"
            >
              Practise this topic
            </Button>
            <Button
              variant="outline"
              render={
                <Link href={`/nex?topicId=${topic.id}&mode=explain`} />
              }
              className="min-h-12 w-full"
            >
              <MessageCircle className="size-4" data-icon="inline-start" />
              Ask Nex about this
            </Button>
          </div>
        </SectionCard>
      </aside>
    </div>
  );
}
