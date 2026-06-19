"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";

interface DiagnosticQuestion {
  diagnosticQuestionId: string;
  topicId: string;
  questionText: string;
  questionType: string;
  options: unknown;
  difficulty: string;
}

interface DiagnosticAssessment {
  id: string;
  title: string;
  questionCount: number;
  isCompleted: boolean;
}

interface SubmitResult {
  healthScore: number;
  predictedGrade: string;
  strongTopics: string[];
  weakTopics: string[];
  recommendedTopics: string[];
}

export function DiagnosticFlow() {
  const router = useRouter();
  const [assessment, setAssessment] = useState<DiagnosticAssessment | null>(null);
  const [attemptId, setAttemptId] = useState<string | null>(null);
  const [questions, setQuestions] = useState<DiagnosticQuestion[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [result, setResult] = useState<SubmitResult | null>(null);

  useEffect(() => {
    async function bootstrap() {
      try {
        const listResponse = await fetch("/api/diagnostic-assessments");
        const listPayload = await listResponse.json();

        if (!listResponse.ok || !listPayload.success) {
          throw new Error(
            listPayload.error?.message ?? "Could not load diagnostic.",
          );
        }

        const available = (listPayload.data.assessments as DiagnosticAssessment[]).find(
          (item) => !item.isCompleted,
        );

        if (!available) {
          router.replace("/dashboard");
          return;
        }

        setAssessment(available);

        const startResponse = await fetch(
          `/api/diagnostic-assessments/${available.id}/start`,
          { method: "POST" },
        );
        const startPayload = await startResponse.json();

        if (!startResponse.ok || !startPayload.success) {
          throw new Error(
            startPayload.error?.message ?? "Could not start diagnostic.",
          );
        }

        setAttemptId(startPayload.data.diagnosticAttemptId);
        setQuestions(startPayload.data.questions);
      } catch (bootstrapError) {
        setError(
          bootstrapError instanceof Error
            ? bootstrapError.message
            : "Something went wrong.",
        );
      } finally {
        setLoading(false);
      }
    }

    void bootstrap();
  }, [router]);

  const currentQuestion = questions[currentIndex];
  const progress = useMemo(() => {
    if (questions.length === 0) {
      return 0;
    }

    return Math.round(((currentIndex + 1) / questions.length) * 100);
  }, [currentIndex, questions.length]);

  async function handleSubmit() {
    if (!assessment || !attemptId) {
      return;
    }

    setSubmitting(true);
    setError(null);

    try {
      const response = await fetch(
        `/api/diagnostic-assessments/${assessment.id}/submit`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            diagnosticAttemptId: attemptId,
            answers: questions.map((question) => ({
              diagnosticQuestionId: question.diagnosticQuestionId,
              studentAnswer: answers[question.diagnosticQuestionId] ?? "",
            })),
          }),
        },
      );

      const payload = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error?.message ?? "Could not submit diagnostic.");
      }

      setResult(payload.data as SubmitResult);
    } catch (submitError) {
      setError(
        submitError instanceof Error
          ? submitError.message
          : "Could not submit diagnostic.",
      );
    } finally {
      setSubmitting(false);
    }
  }

  if (loading) {
    return (
      <div className="rounded-2xl border border-border bg-card p-8 text-center text-muted-foreground">
        Preparing your diagnostic assessment...
      </div>
    );
  }

  if (result) {
    return (
      <div className="space-y-6">
        <section className="rounded-2xl border border-nexus-success/30 bg-nexus-success/10 p-6">
          <h2 className="text-2xl font-semibold text-emerald-950">
            Diagnostic complete
          </h2>
          <p className="mt-2 text-nexus-secondary">
            Academic Health Score: {result.healthScore}/100
          </p>
          <p className="text-nexus-secondary">Predicted grade: {result.predictedGrade}</p>
        </section>

        <section className="grid gap-4 sm:grid-cols-2">
          <div className="rounded-2xl border border-border bg-card p-6">
            <h3 className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
              Strong topics
            </h3>
            <ul className="mt-3 space-y-1 text-sm text-foreground/80">
              {result.strongTopics.length > 0 ? (
                result.strongTopics.map((topic) => <li key={topic}>✓ {topic}</li>)
              ) : (
                <li>None yet — keep practicing.</li>
              )}
            </ul>
          </div>
          <div className="rounded-2xl border border-border bg-card p-6">
            <h3 className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
              Focus next
            </h3>
            <ul className="mt-3 space-y-1 text-sm text-foreground/80">
              {result.recommendedTopics.map((topic) => (
                <li key={topic}>→ {topic}</li>
              ))}
            </ul>
          </div>
        </section>

        <button
          type="button"
          onClick={() => router.push("/dashboard")}
          className="inline-flex h-10 items-center rounded-lg bg-primary px-4 text-sm font-medium text-primary-foreground hover:bg-primary/90"
        >
          Go to dashboard
        </button>
      </div>
    );
  }

  if (error) {
    return (
      <div className="rounded-2xl border border-red-200 bg-red-50 p-6 text-red-900">
        {error}
      </div>
    );
  }

  if (!currentQuestion) {
    return (
      <div className="rounded-2xl border border-border bg-card p-6 text-muted-foreground">
        No diagnostic questions are available yet.
      </div>
    );
  }

  const options = Array.isArray(currentQuestion.options)
    ? (currentQuestion.options as string[])
    : [];

  return (
    <div className="space-y-6">
      <div>
        <p className="text-sm text-muted-foreground">
          Question {currentIndex + 1} of {questions.length}
        </p>
        <div className="mt-2 h-2 overflow-hidden rounded-full bg-muted">
          <div
            className="h-full rounded-full bg-primary transition-all"
            style={{ width: `${progress}%` }}
          />
        </div>
      </div>

      <section className="rounded-2xl border border-border bg-card p-6">
        <p className="text-xs uppercase tracking-wide text-muted-foreground">
          {currentQuestion.difficulty}
        </p>
        <h2 className="mt-2 text-xl font-medium text-foreground">
          {currentQuestion.questionText}
        </h2>

        <div className="mt-6 space-y-3">
          {currentQuestion.questionType === "multiple_choice" ? (
            options.map((option) => (
              <label
                key={option}
                className="flex cursor-pointer items-center gap-3 rounded-xl border border-border px-4 py-3 hover:border-primary/40"
              >
                <input
                  type="radio"
                  name={currentQuestion.diagnosticQuestionId}
                  value={option}
                  checked={
                    answers[currentQuestion.diagnosticQuestionId] === option
                  }
                  onChange={(event) =>
                    setAnswers((current) => ({
                      ...current,
                      [currentQuestion.diagnosticQuestionId]: event.target.value,
                    }))
                  }
                />
                <span>{option}</span>
              </label>
            ))
          ) : (
            <input
              type="text"
              value={answers[currentQuestion.diagnosticQuestionId] ?? ""}
              onChange={(event) =>
                setAnswers((current) => ({
                  ...current,
                  [currentQuestion.diagnosticQuestionId]: event.target.value,
                }))
              }
              className="w-full rounded-xl border border-border px-4 py-3"
              placeholder="Type your answer"
            />
          )}
        </div>
      </section>

      <div className="flex items-center justify-between">
        <button
          type="button"
          disabled={currentIndex === 0}
          onClick={() => setCurrentIndex((index) => index - 1)}
          className="rounded-lg border border-border px-4 py-2 text-sm disabled:opacity-40"
        >
          Previous
        </button>

        {currentIndex < questions.length - 1 ? (
          <button
            type="button"
            onClick={() => setCurrentIndex((index) => index + 1)}
            className="rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground"
          >
            Next
          </button>
        ) : (
          <button
            type="button"
            disabled={submitting}
            onClick={() => void handleSubmit()}
            className="rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground disabled:opacity-60"
          >
            {submitting ? "Submitting..." : "Submit diagnostic"}
          </button>
        )}
      </div>
    </div>
  );
}
