"use client";

import Link from "next/link";
import { useRouter } from "next/navigation";
import { useEffect, useState } from "react";
import { MessageCircle } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import { Skeleton } from "@/components/ui/Skeleton";
import type { PracticeCompleteResult } from "@/features/practice/components/PracticeResults";
import { PracticeResults } from "@/features/practice/components/PracticeResults";
import type { PracticeDifficulty } from "@/features/practice/components/PracticeLanding";
import {
  addToReviewQueue,
  removeFromReviewQueue,
  type ReviewQuestion,
} from "@/lib/practice/reviewQueue";
import { cn } from "@/lib/utils";

interface PracticeQuestion {
  practiceQuestionId: string;
  questionText: string;
  questionType: string;
  options: unknown;
  difficulty: string;
  explanation: string;
}

interface FeedbackState {
  isCorrect: boolean;
  explanation: string;
}

interface PracticeRunnerProps {
  studentId: string;
  topicId: string;
  subtopicId?: string;
  topicTitle: string;
  subtopicTitle?: string;
  difficulty: PracticeDifficulty;
  initialMastery: number;
  reviewQuestions?: ReviewQuestion[];
  onReviewQueueChange?: () => void;
}

// SCOPE-FLAG: confidence chips omitted — practiceAnswerSchema has no confidence field.
// SCOPE-FLAG: review sessions are device-local drills; they do not call the practice API or update mastery.

export function PracticeRunner({
  studentId,
  topicId,
  subtopicId,
  topicTitle,
  subtopicTitle,
  difficulty,
  initialMastery,
  reviewQuestions,
  onReviewQueueChange,
}: PracticeRunnerProps) {
  const router = useRouter();
  const isReview = Boolean(reviewQuestions?.length);
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [questions, setQuestions] = useState<PracticeQuestion[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answer, setAnswer] = useState("");
  const [feedback, setFeedback] = useState<FeedbackState | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<PracticeCompleteResult | null>(null);
  const [startedAt] = useState(() => Date.now());
  const [elapsedSeconds, setElapsedSeconds] = useState(0);

  useEffect(() => {
    const timer = window.setInterval(() => {
      setElapsedSeconds(Math.floor((Date.now() - startedAt) / 1000));
    }, 1000);
    return () => window.clearInterval(timer);
  }, [startedAt]);

  useEffect(() => {
    async function startSession() {
      if (isReview && reviewQuestions) {
        setQuestions(
          reviewQuestions.map((question) => ({
            practiceQuestionId: question.practiceQuestionId,
            questionText: question.questionText,
            questionType: question.questionType,
            options: question.options,
            difficulty: question.difficulty,
            explanation:
              question.explanation ?? "Review the core concept for this topic.",
          })),
        );
        setLoading(false);
        return;
      }

      try {
        const response = await fetch("/api/practice-sessions", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            topicId,
            ...(subtopicId ? { subtopicId } : {}),
            difficulty,
            questionCount: 10,
          }),
        });
        const payload = await response.json();

        if (!response.ok || !payload.success) {
          throw new Error(payload.error?.message ?? "Could not start practice.");
        }

        setSessionId(payload.data.practiceSessionId);
        setQuestions(payload.data.questions);
      } catch (startError) {
        setError(
          startError instanceof Error
            ? startError.message
            : "Could not start practice.",
        );
      } finally {
        setLoading(false);
      }
    }

    void startSession();
  }, [difficulty, isReview, reviewQuestions, subtopicId, topicId]);

  const currentQuestion = questions[currentIndex];
  const options = Array.isArray(currentQuestion?.options)
    ? (currentQuestion.options as string[])
    : [];
  const progressPct =
    questions.length > 0
      ? ((currentIndex + (feedback ? 1 : 0)) / questions.length) * 100
      : 0;

  function finishReviewSession(reviewedCount: number) {
    const total = questions.length;
    setResult({
      practiceScore:
        total > 0 ? Math.round((reviewedCount / total) * 100) : 0,
      correctAnswers: reviewedCount,
      incorrectAnswers: Math.max(0, total - reviewedCount),
      healthScore: 0,
      predictedGrade: null,
      currentStreak: 0,
      masteryUpdates: [],
      xpEarned: 0,
    });
    onReviewQueueChange?.();
  }

  async function handleSubmitAnswer() {
    if (!currentQuestion || !answer) {
      return;
    }

    setSubmitting(true);

    try {
      if (isReview) {
        setFeedback({
          isCorrect: true,
          explanation: currentQuestion.explanation,
        });
        return;
      }

      if (!sessionId) {
        return;
      }

      const response = await fetch(`/api/practice-sessions/${sessionId}/answer`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          practiceQuestionId: currentQuestion.practiceQuestionId,
          studentAnswer: answer,
          timeSpentSeconds: Math.max(1, elapsedSeconds),
        }),
      });
      const payload = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error?.message ?? "Could not save answer.");
      }

      if (!payload.data.isCorrect) {
        addToReviewQueue(studentId, {
          practiceQuestionId: currentQuestion.practiceQuestionId,
          questionText: currentQuestion.questionText,
          questionType: currentQuestion.questionType,
          options: currentQuestion.options,
          difficulty: currentQuestion.difficulty,
          explanation: currentQuestion.explanation,
          topicId,
          topicTitle,
        });
        onReviewQueueChange?.();
      }

      setFeedback({
        isCorrect: payload.data.isCorrect,
        explanation: currentQuestion.explanation,
      });
    } catch (submitError) {
      setError(
        submitError instanceof Error
          ? submitError.message
          : "Could not submit answer.",
      );
    } finally {
      setSubmitting(false);
    }
  }

  async function handleNextQuestion() {
    if (!currentQuestion) {
      return;
    }

    if (isReview) {
      removeFromReviewQueue(studentId, currentQuestion.practiceQuestionId);
      onReviewQueueChange?.();
    }

    if (currentIndex < questions.length - 1) {
      setCurrentIndex((index) => index + 1);
      setAnswer("");
      setFeedback(null);
      return;
    }

    if (isReview) {
      finishReviewSession(questions.length);
      return;
    }

    if (!sessionId) {
      return;
    }

    setSubmitting(true);
    try {
      const completeResponse = await fetch(
        `/api/practice-sessions/${sessionId}/complete`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            timeSpentSeconds: Math.max(
              1,
              Math.round((Date.now() - startedAt) / 1000),
            ),
          }),
        },
      );
      const completePayload = await completeResponse.json();

      if (!completeResponse.ok || !completePayload.success) {
        throw new Error(
          completePayload.error?.message ?? "Could not complete session.",
        );
      }

      setResult({
        ...completePayload.data,
      });
    } catch (completeError) {
      setError(
        completeError instanceof Error
          ? completeError.message
          : "Could not complete session.",
      );
    } finally {
      setSubmitting(false);
    }
  }

  if (loading) {
    return (
      <div className="space-y-4">
        <Skeleton variant="line" className="h-3 w-full" />
        <Skeleton variant="card" className="h-48" />
      </div>
    );
  }

  if (result) {
    return (
      <PracticeResults
        topicId={topicId}
        topicTitle={topicTitle}
        initialMastery={initialMastery}
        result={result}
        isReview={isReview}
        onPracticeAgain={() =>
          router.push(
            isReview
              ? "/practice?review=1"
              : `/practice?topicId=${topicId}&difficulty=${difficulty}`,
          )
        }
        onBack={() => router.push("/practice")}
      />
    );
  }

  if (error || !currentQuestion) {
    return (
      <SectionCard title="Could not load practice">
        <p className="text-sm text-muted-foreground">
          {error ?? "No practice questions are available for this topic yet."}
        </p>
        <Button
          variant="outline"
          className="mt-4 min-h-12"
          onClick={() => router.push("/practice")}
        >
          Back to practice
        </Button>
      </SectionCard>
    );
  }

  const lastAnswerCorrect = feedback?.isCorrect ?? false;

  return (
    <div className="space-y-6 nexus-enter">
      <div className="space-y-2">
        <div className="flex items-center justify-between gap-3 text-sm text-muted-foreground">
          <span>
            Question {currentIndex + 1} of {questions.length}
            {isReview
              ? " · Review"
              : ` · ${subtopicTitle ? `${subtopicTitle} · ` : ""}${topicTitle}`}
          </span>
          <span className="tabular">{elapsedSeconds}s</span>
        </div>
        <div className="h-2 overflow-hidden rounded-full bg-nexus-sunken">
          <div
            className="h-full rounded-full bg-nexus-primary transition-[width] duration-300"
            style={{ width: `${progressPct}%` }}
          />
        </div>
      </div>

      {!feedback ? (
        <SectionCard>
          <h2 className="font-heading text-xl font-semibold text-foreground">
            {currentQuestion.questionText}
          </h2>

          <div className="mt-6 space-y-3">
            {currentQuestion.questionType === "multiple_choice" ? (
              options.map((option) => (
                <label
                  key={option}
                  className={cn(
                    "flex min-h-12 cursor-pointer items-center gap-3 rounded-xl border px-4 py-3 transition-colors",
                    answer === option
                      ? "border-nexus-primary bg-nexus-primary-soft"
                      : "border-nexus-border hover:bg-nexus-sunken",
                  )}
                >
                  <input
                    type="radio"
                    name={currentQuestion.practiceQuestionId}
                    value={option}
                    checked={answer === option}
                    onChange={(event) => setAnswer(event.target.value)}
                    className="size-4"
                  />
                  <span>{option}</span>
                </label>
              ))
            ) : (
              <input
                type="text"
                value={answer}
                onChange={(event) => setAnswer(event.target.value)}
                className="min-h-12 w-full rounded-xl border border-nexus-border bg-nexus-surface px-4 py-3"
                placeholder="Type your answer"
              />
            )}
          </div>

          <Button
            type="button"
            className="mt-6 min-h-12"
            disabled={submitting || !answer}
            onClick={() => void handleSubmitAnswer()}
          >
            {submitting ? "Checking..." : isReview ? "Show explanation" : "Submit answer"}
          </Button>
        </SectionCard>
      ) : (
        <SectionCard
          className={cn(
            isReview
              ? "border-nexus-border bg-nexus-surface"
              : lastAnswerCorrect
                ? "border-nexus-success/30 bg-nexus-success-soft"
                : "border-nexus-danger/30 bg-nexus-danger-soft",
          )}
        >
          {!isReview ? (
            <p
              className={cn(
                "text-sm font-semibold uppercase tracking-wide",
                lastAnswerCorrect ? "text-nexus-success" : "text-nexus-danger",
              )}
            >
              {lastAnswerCorrect ? "Correct" : "Not quite"}
            </p>
          ) : (
            <p className="text-sm font-semibold uppercase tracking-wide text-nexus-primary">
              Review note
            </p>
          )}
          <p className="mt-3 text-sm leading-7 text-foreground">
            {feedback.explanation}
          </p>
          <div className="mt-4 flex flex-col gap-2 sm:flex-row sm:flex-wrap">
            {!isReview ? (
              <Button
                variant="outline"
                render={
                  <Link href={`/nex?topicId=${topicId}&mode=explain`} />
                }
                className="min-h-12"
              >
                <MessageCircle className="size-4" data-icon="inline-start" />
                Explain with Nex
              </Button>
            ) : null}
            <Button
              type="button"
              className="min-h-12"
              disabled={submitting}
              onClick={() => void handleNextQuestion()}
            >
              {currentIndex < questions.length - 1 ? "Next question" : "See results"}
            </Button>
          </div>
        </SectionCard>
      )}
    </div>
  );
}
