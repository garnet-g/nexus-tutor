"use client";

import Link from "next/link";
import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import {
  Bookmark,
  CheckCircle2,
  ChevronLeft,
  ChevronRight,
} from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import { useToast } from "@/components/ui/Toast";
import type {
  CurriculumLesson,
  LessonShortQuizQuestion,
} from "@/types/curriculum";
import { cn } from "@/lib/utils";

import { LessonContentBlocks } from "@/features/learn/components/LessonContentBlocks";

import "katex/dist/katex.min.css";

interface LessonReaderProps {
  lesson: CurriculumLesson;
  orderedLessonIds: string[];
  initialProgress: {
    status: "in_progress" | "completed" | null;
    completedAt: string | null;
    lastViewedAt: string | null;
  };
}

function bookmarkKey(lessonId: string) {
  return `nexus-lesson-bookmark:${lessonId}`;
}

async function postLessonViewed(lessonId: string) {
  await fetch(`/api/lessons/${lessonId}/viewed`, { method: "POST" });
}

async function postLessonComplete(
  lessonId: string,
  body: { durationSeconds: number; quizPassed?: boolean },
) {
  const response = await fetch(`/api/lessons/${lessonId}/complete`, {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(body),
  });

  if (!response.ok) {
    throw new Error("Could not save lesson progress.");
  }

  return response.json() as Promise<{
    success: boolean;
    data: {
      alreadyCompleted: boolean;
      xpEarned: number;
    };
  }>;
}

function ShortQuizSection({
  questions,
  topicId,
  onComplete,
  disabled,
}: {
  questions: LessonShortQuizQuestion[];
  topicId: string;
  onComplete: () => void;
  disabled: boolean;
}) {
  const [answers, setAnswers] = useState<Record<number, string>>({});
  const [submitted, setSubmitted] = useState(false);

  const score = useMemo(() => {
    if (!submitted) {
      return 0;
    }

    return questions.reduce((total, question, index) => {
      return total + (answers[index] === question.correctAnswer ? 1 : 0);
    }, 0);
  }, [answers, questions, submitted]);

  const passed = submitted && score >= Math.ceil(questions.length * 0.6);

  useEffect(() => {
    if (passed && !disabled) {
      onComplete();
    }
  }, [passed, onComplete, disabled]);

  return (
    <SectionCard title="Quick check" description="A short quiz to lock in what you learned.">
      <div className="space-y-4">
        {questions.map((question, index) => (
          <div
            key={index}
            className="rounded-[18px] border border-nexus-border bg-nexus-surface p-4"
          >
            <p className="font-medium text-foreground">{question.questionText}</p>
            <div className="mt-3 grid gap-2">
              {question.options.map((option) => {
                const selected = answers[index] === option;
                const isCorrect = submitted && option === question.correctAnswer;
                const isWrong =
                  submitted && selected && option !== question.correctAnswer;

                return (
                  <button
                    key={option}
                    type="button"
                    disabled={submitted || disabled}
                    onClick={() =>
                      setAnswers((current) => ({ ...current, [index]: option }))
                    }
                    className={cn(
                      "min-h-12 rounded-xl border px-4 py-3 text-left text-sm transition-colors",
                      selected && !submitted && "border-nexus-primary bg-nexus-primary-soft",
                      isCorrect && "border-nexus-success bg-nexus-success-soft",
                      isWrong && "border-nexus-danger bg-nexus-danger-soft",
                      !selected && !submitted && "border-nexus-border hover:bg-nexus-sunken",
                    )}
                  >
                    {option}
                  </button>
                );
              })}
            </div>
          </div>
        ))}
      </div>

      {!submitted ? (
        <Button
          type="button"
          className="mt-4 min-h-12"
          disabled={disabled || Object.keys(answers).length < questions.length}
          onClick={() => setSubmitted(true)}
        >
          Check answers
        </Button>
      ) : (
        <div className="mt-4 space-y-3">
          <p className="text-sm text-muted-foreground">
            You got {score} of {questions.length} correct.
          </p>
          {passed ? (
            <p className="text-sm font-medium text-nexus-success">
              Nice work — you passed this checkpoint.
            </p>
          ) : (
            <Button
              variant="outline"
              render={<Link href={`/nex?topicId=${topicId}&mode=explain`} />}
              className="min-h-12"
            >
              Review with Nex
            </Button>
          )}
        </div>
      )}
    </SectionCard>
  );
}

export function LessonReader({
  lesson,
  orderedLessonIds,
  initialProgress,
}: LessonReaderProps) {
  const { toast } = useToast();
  const openedAtRef = useRef(0);
  const viewedSentRef = useRef(false);
  const completingRef = useRef(false);
  const [isCompleted, setIsCompleted] = useState(
    initialProgress.status === "completed",
  );
  const [bookmarked, setBookmarked] = useState(
    () =>
      typeof window !== "undefined" &&
      window.localStorage.getItem(bookmarkKey(lesson.id)) === "1",
  );

  const lessonIndex = orderedLessonIds.indexOf(lesson.id);
  const lessonNumber = lessonIndex >= 0 ? lessonIndex + 1 : 1;
  const lessonTotal = orderedLessonIds.length || 1;
  const previousLessonId =
    lessonIndex > 0 ? orderedLessonIds[lessonIndex - 1] : null;
  const nextLessonId =
    lessonIndex >= 0 && lessonIndex < orderedLessonIds.length - 1
      ? orderedLessonIds[lessonIndex + 1]
      : null;
  const hasQuiz = Boolean(lesson.content.shortQuiz?.questions?.length);

  useEffect(() => {
    openedAtRef.current = Date.now();
  }, [lesson.id]);

  useEffect(() => {
    if (viewedSentRef.current) {
      return;
    }

    viewedSentRef.current = true;
    void postLessonViewed(lesson.id).catch(() => {
      viewedSentRef.current = false;
    });
  }, [lesson.id]);

  const completeLesson = useCallback(
    async (quizPassed?: boolean) => {
      if (isCompleted || completingRef.current) {
        return;
      }

      completingRef.current = true;
      const durationSeconds = Math.round(
        (Date.now() - openedAtRef.current) / 1000,
      );

      try {
        const result = await postLessonComplete(lesson.id, {
          durationSeconds,
          quizPassed,
        });

        setIsCompleted(true);

        if (!result.data.alreadyCompleted && result.data.xpEarned > 0) {
          toast({
            tone: "success",
            title: "Lesson complete",
            description: `+${result.data.xpEarned} XP added to your progress.`,
          });
        } else if (!result.data.alreadyCompleted) {
          toast({
            tone: "success",
            title: "Lesson complete",
            description: "Your progress is saved across devices.",
          });
        }
      } catch {
        toast({
          tone: "error",
          title: "Could not save progress",
          description: "Check your connection and try again.",
        });
      } finally {
        completingRef.current = false;
      }
    },
    [isCompleted, lesson.id, toast],
  );

  function toggleBookmark() {
    const next = !bookmarked;
    setBookmarked(next);
    window.localStorage.setItem(bookmarkKey(lesson.id), next ? "1" : "0");
    toast({
      tone: next ? "success" : "info",
      title: next ? "Bookmark saved" : "Bookmark removed",
      description: next
        ? "You can return to this lesson any time from your topic path."
        : undefined,
    });
  }

  return (
    <article className="nexus-enter">
      <div className="sticky top-14 z-10 -mx-4 mb-6 border-b border-nexus-border bg-nexus-background/90 px-4 py-3 backdrop-blur-md sm:-mx-5 sm:px-5 lg:top-14">
        <div className="mx-auto flex max-w-[66ch] items-center justify-between gap-3">
          <p className="text-sm font-medium text-muted-foreground">
            Lesson {lessonNumber} of {lessonTotal}
          </p>
          <div className="h-2 flex-1 overflow-hidden rounded-full bg-nexus-sunken">
            <div
              className="h-full rounded-full bg-nexus-primary transition-[width] duration-500"
              style={{ width: `${(lessonNumber / lessonTotal) * 100}%` }}
            />
          </div>
          <button
            type="button"
            onClick={toggleBookmark}
            aria-pressed={bookmarked}
            aria-label={bookmarked ? "Remove bookmark" : "Bookmark lesson"}
            className="flex size-11 items-center justify-center rounded-xl border border-nexus-border bg-nexus-surface text-nexus-primary"
          >
            <Bookmark className={cn("size-4", bookmarked && "fill-current")} />
          </button>
        </div>
      </div>

      <div className="mx-auto max-w-[66ch] space-y-8">
        <header className="space-y-2">
          <p className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
            {lesson.topicTitle} · {lesson.subtopicTitle}
          </p>
          <div className="flex flex-wrap items-center gap-3">
            <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
              {lesson.title}
            </h1>
            {isCompleted ? (
              <span className="inline-flex items-center gap-1 rounded-full bg-nexus-success-soft px-2.5 py-1 text-xs font-medium text-nexus-success">
                <CheckCircle2 className="size-3.5" />
                Completed
              </span>
            ) : null}
          </div>
          <p className="text-sm text-muted-foreground">
            {lesson.curriculumCode} · {lesson.estimatedMinutes} min read
          </p>
        </header>

        <div className="space-y-6">
          <LessonContentBlocks blocks={lesson.content.blocks} topicId={lesson.topicId} />
        </div>

        {lesson.content.shortQuiz?.questions ? (
          <ShortQuizSection
            questions={lesson.content.shortQuiz.questions}
            topicId={lesson.topicId}
            onComplete={() => void completeLesson(true)}
            disabled={isCompleted}
          />
        ) : null}

        {!hasQuiz && !isCompleted ? (
          <div className="border-t border-nexus-border pt-6">
            <Button
              type="button"
              className="min-h-12"
              onClick={() => void completeLesson()}
            >
              Mark lesson complete
            </Button>
          </div>
        ) : null}

        <div className="flex flex-col gap-3 border-t border-nexus-border pt-6 sm:flex-row sm:justify-between">
          {previousLessonId ? (
            <Button
              variant="outline"
              render={
                <Link href={`/learn/${lesson.topicId}/${previousLessonId}`} />
              }
              className="min-h-12"
            >
              <ChevronLeft className="size-4" data-icon="inline-start" />
              Previous
            </Button>
          ) : (
            <span />
          )}
          {nextLessonId ? (
            <Button
              render={<Link href={`/learn/${lesson.topicId}/${nextLessonId}`} />}
              className="min-h-12"
            >
              Continue to next lesson
              <ChevronRight className="size-4" data-icon="inline-end" />
            </Button>
          ) : (
            <Button render={<Link href={`/learn/${lesson.topicId}`} />} className="min-h-12">
              Back to topic path
            </Button>
          )}
        </div>
      </div>

      <p className="text-xs text-muted-foreground">
        Lesson completion syncs to your account. Bookmarks stay on this device only.
      </p>
    </article>
  );
}
