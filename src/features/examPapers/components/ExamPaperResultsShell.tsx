"use client";

import { useMemo, useState } from "react";

import { Button } from "@/components/ui/Button";
import { MathText } from "@/components/content/MathText";

interface ResultPart {
  label: string;
  prompt: string;
  marks: number;
  studentAnswer: string | null;
  isCorrect: boolean;
  autoMarks: number;
  selfAwardedMethodMarks: number;
  computedAnswer: string;
}

interface ResultQuestion {
  sessionQuestionId: string;
  questionNumber: number;
  section: "I" | "II";
  renderedStem: string;
  markScheme: Array<{ code: string; text: string }>;
  parts: ResultPart[];
}

interface ResultsView {
  sessionId: string;
  status: string;
  totalMarks: number;
  verifiedMarks: number;
  selfAwardedMarks: number;
  combinedMarks: number;
  percentage: number;
  questions: ResultQuestion[];
}

export function ExamPaperResultsShell({
  sessionId,
  initialResults,
}: {
  sessionId: string;
  initialResults: ResultsView;
}) {
  const [results, setResults] = useState(initialResults);
  const [claims, setClaims] = useState<Record<string, number>>({});
  const [submitting, setSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const alreadySelfMarked = results.status === "self_marked";

  const selfMarkableParts = useMemo(
    () =>
      results.questions.flatMap((question) =>
        question.parts
          .filter((part) => part.marks - part.autoMarks > 0)
          .map((part) => ({ question, part, cap: part.marks - part.autoMarks })),
      ),
    [results.questions],
  );

  function toggleClaim(sessionQuestionId: string, partLabel: string, cap: number) {
    const key = `${sessionQuestionId}::${partLabel}`;
    setClaims((prev) => ({ ...prev, [key]: prev[key] === cap ? 0 : cap }));
  }

  async function submitSelfMarks() {
    setSubmitting(true);
    setError(null);
    try {
      const claimsPayload = selfMarkableParts.map(({ question, part }) => ({
        sessionQuestionId: question.sessionQuestionId,
        partLabel: part.label,
        claimedMethodMarks: claims[`${question.sessionQuestionId}::${part.label}`] ?? 0,
      }));

      const response = await fetch(`/api/exam-papers/${sessionId}/self-mark`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ claims: claimsPayload }),
      });
      const body = await response.json();
      if (!response.ok || !body.success) {
        throw new Error(body.error?.message ?? "Could not save your self-marking.");
      }

      const resultsResponse = await fetch(`/api/exam-papers/${sessionId}/results`);
      const resultsBody = await resultsResponse.json();
      if (resultsResponse.ok && resultsBody.success) {
        setResults(resultsBody.data);
      }
    } catch (selfMarkError) {
      setError(selfMarkError instanceof Error ? selfMarkError.message : "Could not save your self-marking.");
    } finally {
      setSubmitting(false);
    }
  }

  return (
    <div className="space-y-6">
      <div className="rounded-2xl border border-nexus-border bg-nexus-surface p-5">
        <p className="text-3xl font-semibold text-foreground">
          {results.combinedMarks}/{results.totalMarks}
        </p>
        <p className="mt-1 text-sm text-muted-foreground">
          {results.verifiedMarks} verified + {results.selfAwardedMarks} self-marked · {results.percentage}%
        </p>
      </div>

      {results.questions.map((question) => (
        <div key={question.sessionQuestionId} className="space-y-3 rounded-xl border border-nexus-border p-4">
          <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
            Question {question.questionNumber} · Section {question.section}
          </p>
          <MathText>{question.renderedStem}</MathText>

          {question.parts.map((part) => {
            const cap = part.marks - part.autoMarks;
            const key = `${question.sessionQuestionId}::${part.label}`;
            const claimed = claims[key] ?? part.selfAwardedMethodMarks;

            return (
              <div key={part.label} className="space-y-1 border-t border-nexus-border pt-3">
                <p className="text-sm text-foreground">
                  ({part.label}) <MathText inline>{part.prompt}</MathText> [{part.marks} marks]
                </p>
                <p className="text-sm text-muted-foreground">
                  Your answer: {part.studentAnswer ?? "(blank)"} ·{" "}
                  {part.isCorrect ? "Correct" : `Correct answer: ${part.computedAnswer}`}
                </p>
                {question.markScheme.length > 0 ? (
                  <ul className="list-disc space-y-0.5 pl-5 text-sm text-muted-foreground">
                    {question.markScheme.map((step) => (
                      <li key={step.code}>
                        <span className="font-mono text-xs">{step.code}</span>{" "}
                        <MathText inline>{step.text}</MathText>
                      </li>
                    ))}
                  </ul>
                ) : null}
                {cap > 0 && !alreadySelfMarked ? (
                  <label className="flex items-center gap-2 text-sm text-foreground">
                    <input
                      type="checkbox"
                      checked={claimed === cap}
                      onChange={() => toggleClaim(question.sessionQuestionId, part.label, cap)}
                    />
                    I showed the correct method above ({cap} mark{cap === 1 ? "" : "s"})
                  </label>
                ) : cap > 0 ? (
                  <p className="text-sm text-foreground">Self-awarded: {part.selfAwardedMethodMarks} marks</p>
                ) : null}
              </div>
            );
          })}
        </div>
      ))}

      {error ? <p className="text-sm text-destructive">{error}</p> : null}

      {!alreadySelfMarked && selfMarkableParts.length > 0 ? (
        <Button className="min-h-11 w-full" onClick={() => void submitSelfMarks()} disabled={submitting}>
          {submitting ? "Saving…" : "Confirm self-marking"}
        </Button>
      ) : null}
    </div>
  );
}
