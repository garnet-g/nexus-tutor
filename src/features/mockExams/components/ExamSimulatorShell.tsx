"use client";

import { useEffect, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";

import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";
import { remainingSeconds } from "@/lib/mockExams/examSimulatorEngine";
import { cn } from "@/lib/utils";

interface ExamQuestion {
  id: string;
  question_text: string;
  question_type: string;
  options: unknown;
  difficulty: string;
  sort_order: number;
}

interface ExamSimulatorShellProps {
  simulatorSessionId: string;
  endsAt: string;
  questions: ExamQuestion[];
}

function formatTimer(totalSeconds: number): string {
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}:${seconds.toString().padStart(2, "0")}`;
}

export function ExamSimulatorShell({
  simulatorSessionId,
  endsAt,
  questions,
}: ExamSimulatorShellProps) {
  const router = useRouter();
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [secondsLeft, setSecondsLeft] = useState(() =>
    remainingSeconds(new Date(endsAt)),
  );
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [analysis, setAnalysis] = useState<{
    scorePercentage: number;
    weakTopics: string[];
    predictedGrade: string;
    predictedGradeDelta: string;
    summary: string;
  } | null>(null);
  const autoSubmittedRef = useRef(false);

  const currentQuestion = questions[currentIndex];
  const expired = secondsLeft <= 0;

  useEffect(() => {
    const interval = window.setInterval(() => {
      setSecondsLeft(remainingSeconds(new Date(endsAt)));
    }, 1000);

    return () => window.clearInterval(interval);
  }, [endsAt]);

  const answerPayload = useMemo(
    () =>
      questions.map((question) => ({
        questionId: question.id,
        studentAnswer: answers[question.id] ?? "",
      })),
    [answers, questions],
  );

  async function handleSubmit(force = false) {
    if (submitting) {
      return;
    }

    if (!force && !expired && !answers[currentQuestion?.id ?? ""]) {
      setError("Answer the current question or wait for the timer to expire.");
      return;
    }

    setSubmitting(true);
    setError(null);

    try {
      const response = await fetch(`/api/exam-simulator/${simulatorSessionId}/submit`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          answers: answerPayload,
          questionIndex: currentIndex,
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          analysis: {
            scorePercentage: number;
            weakTopics: string[];
            predictedGrade: string;
            predictedGradeDelta: string;
            summary: string;
          };
        };
        error?: { message?: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        throw new Error(payload.error?.message ?? "Could not submit exam.");
      }

      setAnalysis(payload.data.analysis);
    } catch (submitError) {
      setError(
        submitError instanceof Error
          ? submitError.message
          : "Could not submit exam.",
      );
    } finally {
      setSubmitting(false);
    }
  }

  useEffect(() => {
    if (!expired || analysis || submitting || autoSubmittedRef.current) {
      return;
    }

    autoSubmittedRef.current = true;

    async function autoSubmitOnExpiry() {
      if (submitting) {
        return;
      }

      setSubmitting(true);
      setError(null);

      try {
        const response = await fetch(`/api/exam-simulator/${simulatorSessionId}/submit`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            answers: answerPayload,
            questionIndex: currentIndex,
          }),
        });

        const payload = (await response.json()) as {
          success: boolean;
          data?: {
            analysis: {
              scorePercentage: number;
              weakTopics: string[];
              predictedGrade: string;
              predictedGradeDelta: string;
              summary: string;
            };
          };
          error?: { message?: string };
        };

        if (!response.ok || !payload.success || !payload.data) {
          throw new Error(payload.error?.message ?? "Could not submit exam.");
        }

        setAnalysis(payload.data.analysis);
      } catch (submitError) {
        setError(
          submitError instanceof Error
            ? submitError.message
            : "Could not submit exam.",
        );
      } finally {
        setSubmitting(false);
      }
    }

    void autoSubmitOnExpiry();
  }, [
    analysis,
    answerPayload,
    currentIndex,
    expired,
    simulatorSessionId,
    submitting,
  ]);

  if (analysis) {
    return (
      <Card className="space-y-4 p-6">
        <h2 className="text-xl font-semibold text-foreground">Exam analysis</h2>
        <p className="text-3xl font-semibold text-primary">
          {analysis.scorePercentage}%
        </p>
        <p className="text-sm text-muted-foreground">
          Predicted grade: {analysis.predictedGrade} ({analysis.predictedGradeDelta})
        </p>
        <p className="text-sm text-foreground">{analysis.summary}</p>
        {analysis.weakTopics.length > 0 ? (
          <ul className="list-disc space-y-1 pl-5 text-sm text-muted-foreground">
            {analysis.weakTopics.map((topic) => (
              <li key={topic}>{topic}</li>
            ))}
          </ul>
        ) : null}
        <Button type="button" onClick={() => router.push("/progress")} fullWidth>
          View progress
        </Button>
      </Card>
    );
  }

  return (
    <div className="fixed inset-0 z-40 flex flex-col bg-muted">
      <header className="flex items-center justify-between border-b border-border px-4 py-3">
        <div>
          <p className="text-sm font-semibold text-foreground">Exam simulator</p>
          <p className="text-xs text-muted-foreground">
            Question {currentIndex + 1} of {questions.length}
          </p>
        </div>
        <div
          className={cn(
            "rounded-full px-3 py-1 text-sm font-medium",
            expired
              ? "bg-red-100 text-red-700"
              : "bg-primary/10 text-primary",
          )}
          data-testid="exam-simulator-timer"
        >
          {formatTimer(secondsLeft)}
        </div>
      </header>

      <main className="mx-auto flex w-full max-w-2xl flex-1 flex-col gap-4 px-4 py-6">
        {currentQuestion ? (
          <Card className="space-y-4 p-6">
            <p className="text-xs uppercase tracking-wide text-muted-foreground">
              {currentQuestion.difficulty}
            </p>
            <p className="text-base leading-7 text-foreground">
              {currentQuestion.question_text}
            </p>
            <input
              type="text"
              value={answers[currentQuestion.id] ?? ""}
              onChange={(event) =>
                setAnswers((current) => ({
                  ...current,
                  [currentQuestion.id]: event.target.value,
                }))
              }
              disabled={expired || submitting}
              placeholder="Type your answer"
              className="w-full rounded-xl border border-border bg-card px-3 py-2 text-sm"
            />
          </Card>
        ) : null}

        <div className="flex flex-wrap gap-2">
          {questions.map((question, index) => (
            <button
              key={question.id}
              type="button"
              onClick={() => setCurrentIndex(index)}
              className={cn(
                "min-h-10 min-w-10 rounded-lg border text-sm",
                index === currentIndex
                  ? "border-primary bg-primary/10 text-primary"
                  : "border-border text-muted-foreground",
              )}
            >
              {index + 1}
            </button>
          ))}
        </div>

        {error ? (
          <p className="text-sm text-nexus-danger" role="alert">
            {error}
          </p>
        ) : null}

        <div className="mt-auto flex gap-3">
          <Button
            type="button"
            variant="secondary"
            disabled={currentIndex === 0 || submitting}
            onClick={() => setCurrentIndex((index) => Math.max(0, index - 1))}
          >
            Previous
          </Button>
          {currentIndex < questions.length - 1 ? (
            <Button
              type="button"
              className="flex-1"
              disabled={submitting}
              onClick={() => setCurrentIndex((index) => index + 1)}
            >
              Next
            </Button>
          ) : (
            <Button
              type="button"
              className="flex-1"
              disabled={submitting || expired}
              onClick={() => void handleSubmit()}
            >
              {submitting ? "Submitting..." : "Submit exam"}
            </Button>
          )}
        </div>
      </main>
    </div>
  );
}
