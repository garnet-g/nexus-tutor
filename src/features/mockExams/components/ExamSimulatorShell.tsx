"use client";

import { useCallback, useEffect, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { Check, X } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { remainingSeconds } from "@/lib/mockExams/examSimulatorEngine";
import type { MockExamReviewQuestion } from "@/lib/mockExams/mockExamEngine";
import { cn } from "@/lib/utils";

interface ExamQuestion {
  id: string;
  question_text: string;
  question_type: string;
  options: unknown;
  difficulty: string;
  sort_order: number;
}

interface ExamMeta {
  curriculum: string;
  gradeLevel: string;
  examStyle: string;
  questionCount: number;
}

interface ExamSimulatorShellProps {
  simulatorSessionId: string;
  endsAt: string;
  questions: ExamQuestion[];
  examMeta: ExamMeta;
}

interface SubmitAnalysis {
  scorePercentage: number;
  weakTopics: string[];
  predictedGrade: string;
  predictedGradeDelta: string;
  summary: string;
}

interface SubmitData {
  analysis: SubmitAnalysis;
  review: MockExamReviewQuestion[];
  correctCount: number;
  totalCount: number;
  expired?: boolean;
}

const EXAM_STYLE_LABELS: Record<string, string> = {
  kcse_style: "KCSE-style",
  cbc_style: "CBC-style",
  topic_specific: "Strand focus",
  full_math: "Full mathematics paper",
};

const WARNING_THRESHOLD_SECONDS = 120;

function formatTimer(totalSeconds: number): string {
  const safe = Math.max(0, totalSeconds);
  const minutes = Math.floor(safe / 60);
  const seconds = safe % 60;
  return `${minutes}:${seconds.toString().padStart(2, "0")}`;
}

function parseOptions(options: unknown): string[] | null {
  return Array.isArray(options) ? options.map((option) => String(option)) : null;
}

function optionLetter(index: number): string {
  return String.fromCharCode(65 + index);
}

function isMultipleChoice(questionType: string, options: string[] | null): boolean {
  return questionType === "multiple_choice" && Array.isArray(options) && options.length > 0;
}

export function ExamSimulatorShell({
  simulatorSessionId,
  endsAt,
  questions,
  examMeta,
}: ExamSimulatorShellProps) {
  const router = useRouter();
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [secondsLeft, setSecondsLeft] = useState(() =>
    remainingSeconds(new Date(endsAt)),
  );
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [confirmOpen, setConfirmOpen] = useState(false);
  const [result, setResult] = useState<SubmitData | null>(null);
  const [reviewFilter, setReviewFilter] = useState<"all" | "mistakes">("all");
  const autoSubmittedRef = useRef(false);

  const expired = secondsLeft <= 0;
  const answeredCount = useMemo(
    () => questions.filter((question) => (answers[question.id] ?? "").trim().length > 0).length,
    [answers, questions],
  );

  useEffect(() => {
    const interval = window.setInterval(() => {
      setSecondsLeft(remainingSeconds(new Date(endsAt)));
    }, 1000);
    return () => window.clearInterval(interval);
  }, [endsAt]);

  const submitExam = useCallback(async () => {
    if (submitting) {
      return;
    }
    setSubmitting(true);
    setError(null);
    setConfirmOpen(false);

    try {
      const response = await fetch(`/api/exam-simulator/${simulatorSessionId}/submit`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          answers: questions.map((question) => ({
            questionId: question.id,
            studentAnswer: answers[question.id] ?? "",
          })),
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: SubmitData;
        error?: { message?: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        throw new Error(payload.error?.message ?? "Could not submit exam.");
      }

      setResult(payload.data);
    } catch (submitError) {
      setError(
        submitError instanceof Error ? submitError.message : "Could not submit exam.",
      );
    } finally {
      setSubmitting(false);
    }
  }, [answers, questions, simulatorSessionId, submitting]);

  // Auto-submit once when the timer runs out.
  useEffect(() => {
    if (!expired || result || autoSubmittedRef.current) {
      return;
    }
    autoSubmittedRef.current = true;
    void submitExam();
  }, [expired, result, submitExam]);

  function setAnswer(questionId: string, value: string) {
    setAnswers((current) => ({ ...current, [questionId]: value }));
  }

  function handleSubmitClick() {
    if (expired || answeredCount === questions.length) {
      void submitExam();
      return;
    }
    setConfirmOpen(true);
  }

  if (result) {
    return (
      <ExamResults
        data={result}
        examMeta={examMeta}
        filter={reviewFilter}
        onFilterChange={setReviewFilter}
        onViewProgress={() => router.push("/progress")}
        onPractise={() => router.push("/practice")}
        onBack={() => router.push("/exam-prep")}
      />
    );
  }

  const timerTone = expired
    ? "bg-nexus-danger-soft text-nexus-danger"
    : secondsLeft <= WARNING_THRESHOLD_SECONDS
      ? "bg-nexus-accent-soft text-nexus-warning"
      : "bg-card text-primary";

  return (
    <div className="fixed inset-0 z-40 flex flex-col bg-muted">
      {/* Exam toolbar — sticky command bar */}
      <header className="flex items-center justify-between gap-3 border-b border-nexus-border-strong bg-primary px-4 py-3 text-primary-foreground sm:px-6">
        <div className="min-w-0">
          <p className="truncate font-heading text-sm font-semibold sm:text-base">
            {examMeta.gradeLevel} · {EXAM_STYLE_LABELS[examMeta.examStyle] ?? "Mock exam"}
          </p>
          <p className="text-xs text-primary-foreground/70">
            {answeredCount} of {questions.length} answered
          </p>
        </div>
        <div className="flex items-center gap-2 sm:gap-3">
          <span
            role="timer"
            data-testid="exam-simulator-timer"
            className={cn(
              "rounded-lg px-3 py-1.5 text-sm font-bold tabular-nums sm:text-base",
              timerTone,
            )}
          >
            {expired ? "Time up" : formatTimer(secondsLeft)}
          </span>
          <Button
            type="button"
            onClick={handleSubmitClick}
            disabled={submitting}
            className="bg-nexus-accent text-nexus-text-primary hover:bg-nexus-accent/90"
            size="sm"
          >
            {submitting ? "Submitting…" : "Submit paper"}
          </Button>
        </div>
      </header>

      {/* Scrollable paper viewport */}
      <main className="flex-1 overflow-y-auto px-3 py-6 sm:px-6 sm:py-8">
        <div className="mx-auto w-full max-w-2xl rounded-xl border border-border bg-card p-6 shadow-[var(--shadow-card)] sm:p-9">
          {/* Paper header */}
          <div className="border-b-2 border-foreground pb-4 text-center">
            <h1 className="font-heading text-lg font-semibold tracking-tight sm:text-xl">
              NEXUS MOCK EXAMINATION
            </h1>
            <p className="mt-1 text-xs text-muted-foreground sm:text-sm">
              {examMeta.gradeLevel} · {examMeta.curriculum} ·{" "}
              {EXAM_STYLE_LABELS[examMeta.examStyle] ?? "Mock exam"} ·{" "}
              {examMeta.questionCount} questions
            </p>
          </div>

          <div className="my-5 rounded-r-lg border-l-4 border-primary bg-muted px-4 py-3 text-xs text-muted-foreground sm:text-sm">
            <span className="font-semibold text-foreground">Instructions to candidates:</span>{" "}
            Answer <span className="font-semibold">ALL</span> questions in the spaces
            provided. Your paper submits automatically when the timer reaches zero.
          </div>

          <ol className="space-y-7">
            {questions.map((question, index) => {
              const options = parseOptions(question.options);
              const mcq = isMultipleChoice(question.question_type, options);
              const selected = answers[question.id] ?? "";

              return (
                <li key={question.id} className="scroll-mt-20">
                  <div className="flex items-start justify-between gap-3">
                    <p className="text-sm leading-relaxed text-foreground sm:text-base">
                      <span className="font-semibold">{index + 1}.</span>{" "}
                      {question.question_text}
                    </p>
                    <span className="mt-0.5 shrink-0 rounded-full bg-muted px-2 py-0.5 text-[10px] font-medium uppercase tracking-wide text-muted-foreground">
                      {question.difficulty}
                    </span>
                  </div>

                  {mcq && options ? (
                    <div
                      role="radiogroup"
                      aria-label={`Question ${index + 1} options`}
                      className="mt-3 flex flex-col gap-2 pl-4"
                    >
                      {options.map((option, optionIndex) => {
                        const isSelected = selected === option;
                        return (
                          <button
                            key={option}
                            type="button"
                            role="radio"
                            aria-checked={isSelected}
                            onClick={() => setAnswer(question.id, option)}
                            disabled={expired || submitting}
                            className={cn(
                              "flex w-full items-center gap-3 rounded-xl border px-4 py-2.5 text-left text-sm transition-colors disabled:opacity-60",
                              isSelected
                                ? "border-primary bg-accent font-medium text-primary"
                                : "border-border hover:border-primary/40",
                            )}
                          >
                            <span
                              className={cn(
                                "flex size-6 shrink-0 items-center justify-center rounded-full border text-xs font-semibold",
                                isSelected
                                  ? "border-primary bg-primary text-primary-foreground"
                                  : "border-muted-foreground/40 text-muted-foreground",
                              )}
                            >
                              {optionLetter(optionIndex)}
                            </span>
                            {option}
                          </button>
                        );
                      })}
                    </div>
                  ) : (
                    <div className="mt-3 pl-4">
                      <input
                        type="text"
                        inputMode={
                          question.question_type === "numeric" ? "decimal" : "text"
                        }
                        aria-label={`Answer for question ${index + 1}`}
                        value={selected}
                        onChange={(event) => setAnswer(question.id, event.target.value)}
                        disabled={expired || submitting}
                        placeholder="Write your answer"
                        className="w-full rounded-lg border border-border bg-muted px-3 py-2 text-sm text-foreground outline-none transition-colors focus:border-primary focus:ring-2 focus:ring-primary/20 disabled:opacity-60"
                      />
                    </div>
                  )}
                </li>
              );
            })}
          </ol>

          {error ? (
            <p className="mt-6 text-sm text-nexus-danger" role="alert">
              {error}
            </p>
          ) : null}

          <div className="mt-8 border-t border-border pt-6">
            <Button
              type="button"
              variant="primary"
              fullWidth
              onClick={handleSubmitClick}
              disabled={submitting || expired}
            >
              {submitting ? "Submitting…" : "Submit paper"}
            </Button>
          </div>
        </div>
      </main>

      {/* Unanswered-questions confirmation */}
      {confirmOpen ? (
        <div className="fixed inset-0 z-50 flex items-end justify-center bg-foreground/40 p-4 sm:items-center">
          <div
            role="alertdialog"
            aria-label="Confirm submission"
            className="w-full max-w-sm rounded-2xl bg-card p-6 shadow-[var(--shadow-float)]"
          >
            <h2 className="font-heading text-lg font-semibold text-foreground">
              Submit with {questions.length - answeredCount} unanswered?
            </h2>
            <p className="mt-2 text-sm text-muted-foreground">
              Unanswered questions are marked wrong. You can keep working until the timer
              runs out.
            </p>
            <div className="mt-5 flex gap-3">
              <Button
                type="button"
                variant="secondary"
                fullWidth
                onClick={() => setConfirmOpen(false)}
              >
                Keep working
              </Button>
              <Button type="button" variant="primary" fullWidth onClick={() => void submitExam()}>
                Submit paper
              </Button>
            </div>
          </div>
        </div>
      ) : null}
    </div>
  );
}

function ExamResults({
  data,
  examMeta,
  filter,
  onFilterChange,
  onViewProgress,
  onPractise,
  onBack,
}: {
  data: SubmitData;
  examMeta: ExamMeta;
  filter: "all" | "mistakes";
  onFilterChange: (filter: "all" | "mistakes") => void;
  onViewProgress: () => void;
  onPractise: () => void;
  onBack: () => void;
}) {
  const { analysis, review, correctCount, totalCount } = data;
  const mistakeCount = review.filter((question) => !question.isCorrect).length;
  const visible = filter === "mistakes" ? review.filter((q) => !q.isCorrect) : review;
  const gradeChanged =
    analysis.predictedGradeDelta && analysis.predictedGradeDelta !== "unchanged";

  return (
    <div className="space-y-5">
      {/* Nex-led summary */}
      <section className="flex items-start gap-4 rounded-2xl bg-primary p-6 text-primary-foreground shadow-[var(--shadow-nex)]">
        <div className="nex-mark size-10" aria-hidden />
        <div className="min-w-0 flex-1">
          <div className="flex flex-wrap items-baseline gap-x-3 gap-y-1">
            <span className="font-heading text-4xl font-semibold tabular-nums text-nexus-accent">
              {analysis.scorePercentage}%
            </span>
            <span className="text-sm text-primary-foreground/80">
              {correctCount} of {totalCount} correct · Predicted grade{" "}
              <span className="font-semibold text-primary-foreground">
                {analysis.predictedGrade}
              </span>
            </span>
            {gradeChanged ? (
              <span className="rounded-full bg-nexus-success px-2.5 py-0.5 text-xs font-semibold text-white">
                {analysis.predictedGradeDelta} ↑
              </span>
            ) : null}
          </div>
          <p className="mt-2 text-sm leading-relaxed text-primary-foreground/90">
            {analysis.summary}
          </p>
        </div>
      </section>

      {/* Filter tabs */}
      <div className="flex gap-2">
        <FilterTab active={filter === "all"} onClick={() => onFilterChange("all")}>
          Marked paper
        </FilterTab>
        <FilterTab
          active={filter === "mistakes"}
          onClick={() => onFilterChange("mistakes")}
          disabled={mistakeCount === 0}
        >
          Only my mistakes ({mistakeCount})
        </FilterTab>
      </div>

      {/* Marked paper */}
      <section className="rounded-xl border border-border bg-card p-5 shadow-[var(--shadow-card)] sm:p-7">
        <div className="border-b-2 border-foreground pb-3 text-center">
          <h2 className="font-heading text-base font-semibold sm:text-lg">
            Your marked paper
          </h2>
          <p className="mt-0.5 text-xs text-muted-foreground">
            {examMeta.curriculum} · {EXAM_STYLE_LABELS[examMeta.examStyle] ?? "Mock exam"}
          </p>
        </div>

        {visible.length === 0 ? (
          <p className="py-8 text-center text-sm text-muted-foreground">
            No mistakes on this paper — every question correct.
          </p>
        ) : (
          <ol className="divide-y divide-border">
            {visible.map((question) => (
              <MarkedQuestion key={question.questionId} question={question} />
            ))}
          </ol>
        )}
      </section>

      {/* Where to focus next */}
      <section className="rounded-xl border border-border bg-card p-5 shadow-[var(--shadow-card)]">
        <h3 className="font-heading text-base font-semibold">Where to focus next</h3>
        {analysis.weakTopics.length > 0 ? (
          <div className="mt-3 flex flex-wrap gap-2">
            {analysis.weakTopics.map((topic) => (
              <span
                key={topic}
                className="rounded-full bg-nexus-danger-soft px-3 py-1 text-xs font-medium text-nexus-danger"
              >
                {topic}
              </span>
            ))}
          </div>
        ) : (
          <p className="mt-2 text-sm text-muted-foreground">
            Strong across every topic in this paper — keep the momentum.
          </p>
        )}
        <div className="mt-5 flex flex-col gap-2 sm:flex-row">
          <Button type="button" variant="primary" fullWidth onClick={onPractise}>
            Practise weak topics
          </Button>
          <Button type="button" variant="secondary" fullWidth onClick={onViewProgress}>
            View progress
          </Button>
          <Button type="button" variant="ghost" fullWidth onClick={onBack}>
            Back to Exam Prep
          </Button>
        </div>
      </section>
    </div>
  );
}

function MarkedQuestion({ question }: { question: MockExamReviewQuestion }) {
  const options = question.options;
  const isMcq = isMultipleChoice(question.questionType, options);

  return (
    <li className="py-4">
      <div className="flex items-start justify-between gap-3">
        <p className="text-sm leading-relaxed text-foreground">
          <span className="font-semibold">{question.sortOrder + 1}.</span>{" "}
          {question.questionText}
        </p>
        <StatusBadge correct={question.isCorrect} />
      </div>

      {isMcq && options ? (
        <div className="mt-3 flex flex-col gap-2 pl-4">
          {options.map((option, optionIndex) => {
            const isCorrectOption =
              option.trim().toLowerCase() === question.correctAnswer.trim().toLowerCase();
            const isYourAnswer =
              question.yourAnswer != null &&
              option.trim().toLowerCase() === question.yourAnswer.trim().toLowerCase();

            return (
              <div
                key={option}
                className={cn(
                  "flex items-center gap-3 rounded-xl border px-4 py-2.5 text-sm",
                  isCorrectOption
                    ? "border-nexus-success bg-nexus-success-soft text-nexus-success"
                    : isYourAnswer
                      ? "border-nexus-danger bg-nexus-danger-soft text-nexus-danger"
                      : "border-border text-muted-foreground",
                )}
              >
                <span className="flex size-6 shrink-0 items-center justify-center rounded-full border border-current/30 text-xs font-semibold">
                  {optionLetter(optionIndex)}
                </span>
                <span className="flex-1">{option}</span>
                {isCorrectOption ? (
                  <span className="text-xs font-semibold">Correct answer</span>
                ) : isYourAnswer ? (
                  <span className="text-xs font-semibold">Your answer</span>
                ) : null}
              </div>
            );
          })}
        </div>
      ) : (
        <div className="mt-3 space-y-1.5 pl-4 text-sm">
          <p
            className={cn(
              question.isCorrect ? "text-nexus-success" : "text-nexus-danger",
            )}
          >
            <span className="text-muted-foreground">Your answer:</span>{" "}
            {question.yourAnswer ?? "— (blank)"}
          </p>
          {!question.isCorrect ? (
            <p className="text-nexus-success">
              <span className="text-muted-foreground">Correct answer:</span>{" "}
              {question.correctAnswer}
            </p>
          ) : null}
        </div>
      )}

      {!question.isCorrect && question.explanation ? (
        <div className="mt-3 ml-4 rounded-r-lg border-l-[3px] border-nexus-accent bg-muted px-3 py-2 text-xs text-muted-foreground">
          <span className="font-semibold uppercase tracking-wide text-nexus-warning">
            Why
          </span>
          <p className="mt-1 leading-relaxed">{question.explanation}</p>
        </div>
      ) : null}
    </li>
  );
}

function StatusBadge({ correct }: { correct: boolean }) {
  return (
    <span
      className={cn(
        "inline-flex shrink-0 items-center gap-1 rounded-full px-2.5 py-0.5 text-xs font-semibold",
        correct
          ? "bg-nexus-success-soft text-nexus-success"
          : "bg-nexus-danger-soft text-nexus-danger",
      )}
    >
      {correct ? <Check className="size-3.5" /> : <X className="size-3.5" />}
      {correct ? "Correct" : "Incorrect"}
    </span>
  );
}

function FilterTab({
  active,
  disabled,
  onClick,
  children,
}: {
  active: boolean;
  disabled?: boolean;
  onClick: () => void;
  children: React.ReactNode;
}) {
  return (
    <button
      type="button"
      onClick={onClick}
      disabled={disabled}
      aria-pressed={active}
      className={cn(
        "rounded-full border px-4 py-1.5 text-xs font-medium transition-colors disabled:opacity-40",
        active
          ? "border-primary bg-accent text-primary"
          : "border-border bg-card text-muted-foreground hover:text-foreground",
      )}
    >
      {children}
    </button>
  );
}
