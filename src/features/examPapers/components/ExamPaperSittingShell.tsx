"use client";

import { useEffect, useMemo, useState } from "react";
import { useRouter } from "next/navigation";

import { Button } from "@/components/ui/Button";
import { MathText } from "@/components/content/MathText";
import { remainingSeconds } from "@/lib/examPapers/sessionTiming";
import { cn } from "@/lib/utils";

interface SittingPart {
  label: string;
  prompt: string;
  marks: number;
  answerType: "numeric" | "short_answer";
}

interface SittingQuestion {
  sessionQuestionId: string;
  questionNumber: number;
  section: "I" | "II";
  chosen: boolean;
  renderedStem: string;
  parts: SittingPart[];
}

interface SittingView {
  sessionId: string;
  paper: 1 | 2;
  status: string;
  endsAt: string;
  totalMarks: number;
  questions: SittingQuestion[];
}

export function ExamPaperSittingShell({
  sessionId,
  initialView,
}: {
  sessionId: string;
  initialView: SittingView;
}) {
  const router = useRouter();
  const [view, setView] = useState(initialView);
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [activeQuestionId, setActiveQuestionId] = useState<string | null>(
    initialView.questions.find((q) => q.section === "I")?.sessionQuestionId ?? null,
  );
  const [sectionTwoChoice, setSectionTwoChoice] = useState<Set<string>>(new Set());
  const [savingChoice, setSavingChoice] = useState(false);
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [secondsLeft, setSecondsLeft] = useState(() => remainingSeconds(new Date(initialView.endsAt)));

  const sectionOne = view.questions.filter((q) => q.section === "I");
  const sectionTwoAll = view.questions.filter((q) => q.section === "II");
  const sectionTwoChosen = sectionTwoAll.filter((q) => q.chosen);
  const needsSectionTwoChoice = sectionTwoAll.length > 0 && sectionTwoChosen.length !== 5;

  useEffect(() => {
    const interval = setInterval(() => {
      setSecondsLeft(remainingSeconds(new Date(view.endsAt)));
    }, 1000);
    return () => clearInterval(interval);
  }, [view.endsAt]);

  const answeredCount = useMemo(
    () =>
      view.questions
        .filter((q) => q.chosen)
        .reduce((count, question) => {
          const allAnswered = question.parts.every(
            (part) => (answers[`${question.sessionQuestionId}::${part.label}`] ?? "").trim().length > 0,
          );
          return allAnswered ? count + 1 : count;
        }, 0),
    [answers, view.questions],
  );

  function setAnswer(sessionQuestionId: string, partLabel: string, value: string) {
    setAnswers((prev) => ({ ...prev, [`${sessionQuestionId}::${partLabel}`]: value }));
  }

  async function saveSectionTwoChoice() {
    if (sectionTwoChoice.size !== 5) {
      setError("Choose exactly 5 Section II questions.");
      return;
    }
    setSavingChoice(true);
    setError(null);
    try {
      const response = await fetch(`/api/exam-papers/${sessionId}/choose-section-ii`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ sessionQuestionIds: [...sectionTwoChoice] }),
      });
      const body = await response.json();
      if (!response.ok || !body.success) {
        throw new Error(body.error?.message ?? "Could not save your Section II choice.");
      }
      setView((prev) => ({
        ...prev,
        questions: prev.questions.map((q) =>
          q.section === "II" ? { ...q, chosen: sectionTwoChoice.has(q.sessionQuestionId) } : q,
        ),
      }));
    } catch (choiceError) {
      setError(choiceError instanceof Error ? choiceError.message : "Could not save your Section II choice.");
    } finally {
      setSavingChoice(false);
    }
  }

  async function handleSubmit() {
    setSubmitting(true);
    setError(null);
    try {
      const payload = {
        answers: Object.entries(answers).map(([key, studentAnswer]) => {
          const [sessionQuestionId, partLabel] = key.split("::");
          return { sessionQuestionId, partLabel, studentAnswer };
        }),
      };
      const response = await fetch(`/api/exam-papers/${sessionId}/submit`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      const body = await response.json();
      if (!response.ok || !body.success) {
        throw new Error(body.error?.message ?? "Could not submit your paper.");
      }
      router.push(`/exam-papers/${sessionId}/results`);
    } catch (submitError) {
      setError(submitError instanceof Error ? submitError.message : "Could not submit your paper.");
      setSubmitting(false);
    }
  }

  useEffect(() => {
    if (secondsLeft <= 0 && !submitting) {
      // eslint-disable-next-line react-hooks/set-state-in-effect
      void handleSubmit();
    }
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [secondsLeft]);

  function formatTimer(total: number): string {
    const safe = Math.max(0, total);
    const hours = Math.floor(safe / 3600);
    const minutes = Math.floor((safe % 3600) / 60);
    const seconds = safe % 60;
    return `${hours}:${minutes.toString().padStart(2, "0")}:${seconds.toString().padStart(2, "0")}`;
  }

  const activeQuestion = view.questions.find((q) => q.sessionQuestionId === activeQuestionId) ?? null;

  return (
    <div className="space-y-4 pb-24">
      <div className="sticky top-0 z-10 flex items-center justify-between rounded-xl border border-nexus-border bg-nexus-surface px-4 py-3">
        <p className="text-sm font-semibold text-foreground">
          Paper {view.paper} · {answeredCount}/{view.questions.filter((q) => q.chosen).length} answered
        </p>
        <p className={cn("font-mono text-sm", secondsLeft < 120 ? "text-destructive" : "text-foreground")}>
          {formatTimer(secondsLeft)}
        </p>
      </div>

      {needsSectionTwoChoice ? (
        <div className="space-y-3 rounded-xl border border-nexus-border bg-nexus-surface p-4">
          <p className="text-sm font-semibold text-foreground">Choose 5 of 8 Section II questions</p>
          <div className="grid grid-cols-4 gap-2">
            {sectionTwoAll.map((question) => {
              const selected = sectionTwoChoice.has(question.sessionQuestionId);
              return (
                <button
                  key={question.sessionQuestionId}
                  type="button"
                  className={cn(
                    "min-h-11 rounded-lg border text-sm font-medium",
                    selected ? "border-nexus-accent bg-nexus-accent/10" : "border-nexus-border",
                  )}
                  onClick={() =>
                    setSectionTwoChoice((prev) => {
                      const next = new Set(prev);
                      if (next.has(question.sessionQuestionId)) {
                        next.delete(question.sessionQuestionId);
                      } else if (next.size < 5) {
                        next.add(question.sessionQuestionId);
                      }
                      return next;
                    })
                  }
                >
                  Q{question.questionNumber}
                </button>
              );
            })}
          </div>
          <Button className="min-h-11 w-full" onClick={() => void saveSectionTwoChoice()} disabled={savingChoice}>
            {savingChoice ? "Saving…" : `Confirm choice (${sectionTwoChoice.size}/5)`}
          </Button>
        </div>
      ) : null}

      <div className="grid grid-cols-6 gap-2">
        {[...sectionOne, ...sectionTwoChosen].map((question) => {
          const allAnswered = question.parts.every(
            (part) => (answers[`${question.sessionQuestionId}::${part.label}`] ?? "").trim().length > 0,
          );
          return (
            <button
              key={question.sessionQuestionId}
              type="button"
              className={cn(
                "min-h-11 rounded-lg border text-sm font-medium",
                activeQuestionId === question.sessionQuestionId
                  ? "border-nexus-accent bg-nexus-accent/10"
                  : allAnswered
                    ? "border-emerald-500/50 bg-emerald-500/10"
                    : "border-nexus-border",
              )}
              onClick={() => setActiveQuestionId(question.sessionQuestionId)}
            >
              {question.questionNumber}
            </button>
          );
        })}
      </div>

      {activeQuestion ? (
        <div className="space-y-4 rounded-xl border border-nexus-border bg-nexus-surface p-4">
          <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            Question {activeQuestion.questionNumber} · Section {activeQuestion.section}
          </p>
          <MathText>{activeQuestion.renderedStem}</MathText>

          {activeQuestion.parts.map((part) => (
            <div key={part.label} className="space-y-1">
              <p className="text-sm text-foreground">
                ({part.label}) <MathText inline>{part.prompt}</MathText>{" "}
                <span className="text-xs text-muted-foreground">[{part.marks} marks]</span>
              </p>
              <input
                type="text"
                inputMode={part.answerType === "numeric" ? "decimal" : "text"}
                className="min-h-11 w-full rounded-lg border border-nexus-border bg-background px-3 text-sm"
                value={answers[`${activeQuestion.sessionQuestionId}::${part.label}`] ?? ""}
                onChange={(event) =>
                  setAnswer(activeQuestion.sessionQuestionId, part.label, event.target.value)
                }
                placeholder="Final answer"
              />
            </div>
          ))}
        </div>
      ) : null}

      {error ? <p className="text-sm text-destructive">{error}</p> : null}

      <div className="fixed inset-x-0 bottom-0 border-t border-nexus-border bg-background p-4">
        <Button className="min-h-11 w-full" onClick={() => void handleSubmit()} disabled={submitting}>
          {submitting ? "Submitting…" : "Submit paper"}
        </Button>
      </div>
    </div>
  );
}
