"use client";

import { useCallback, useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";
import { Camera, Clock } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import type { PastPaperDetail } from "@/server/services/pastPaperService";

interface PracticePaperAttemptSimulatorProps {
  paper: PastPaperDetail;
  attemptId: string;
}

interface QuestionState {
  answerText: string;
  imageFile: File | null;
  imagePreviewUrl: string | null;
}

function formatTime(totalSeconds: number): string {
  const minutes = Math.floor(totalSeconds / 60);
  const seconds = totalSeconds % 60;
  return `${minutes}:${seconds.toString().padStart(2, "0")}`;
}

function fileToBase64(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = () => {
      const result = reader.result as string;
      resolve(result.split(",")[1] ?? "");
    };
    reader.onerror = reject;
    reader.readAsDataURL(file);
  });
}

export function PracticePaperAttemptSimulator({
  paper,
  attemptId,
}: PracticePaperAttemptSimulatorProps) {
  const router = useRouter();
  const [answers, setAnswers] = useState<Record<string, QuestionState>>(() =>
    Object.fromEntries(
      paper.questions.map((q) => [
        q.id,
        { answerText: "", imageFile: null, imagePreviewUrl: null },
      ]),
    ),
  );
  const [secondsRemaining, setSecondsRemaining] = useState(
    paper.durationMinutes * 60,
  );
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const submittedRef = useRef(false);

  const handleSubmit = useCallback(async () => {
    if (submittedRef.current) {
      return;
    }
    submittedRef.current = true;
    setIsSubmitting(true);
    setError(null);

    try {
      const submitResponse = await fetch(
        `/api/past-papers/attempts/${attemptId}/submit`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            answers: paper.questions.map((q) => ({
              questionId: q.id,
              studentAnswer: answers[q.id]?.answerText || undefined,
            })),
          }),
        },
      );

      const submitPayload = (await submitResponse.json()) as {
        success: boolean;
        error?: { message: string };
      };

      if (!submitResponse.ok || !submitPayload.success) {
        setError(submitPayload.error?.message ?? "Could not submit attempt.");
        submittedRef.current = false;
        setIsSubmitting(false);
        return;
      }

      for (const question of paper.questions) {
        const state = answers[question.id];
        if (!state) {
          continue;
        }

        const hasImage = Boolean(state.imageFile);
        const hasText = Boolean(state.answerText.trim());
        if (!hasImage && !hasText) {
          continue;
        }

        const imageBase64 = state.imageFile
          ? await fileToBase64(state.imageFile)
          : undefined;

        await fetch(`/api/past-papers/attempts/${attemptId}/mark`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            questionId: question.id,
            studentAnswer: state.answerText || undefined,
            imageBase64,
            mimeType: state.imageFile?.type,
          }),
        }).catch(() => undefined);
      }

      router.push(`/practice-papers/attempts/${attemptId}/results`);
    } catch {
      setError("Network error while submitting. Please try again.");
      submittedRef.current = false;
      setIsSubmitting(false);
    }
  }, [answers, attemptId, paper.questions, router]);

  useEffect(() => {
    const timer = setInterval(() => {
      setSecondsRemaining((value) => {
        if (value <= 1) {
          clearInterval(timer);
          void handleSubmit();
          return 0;
        }
        return value - 1;
      });
    }, 1000);

    return () => clearInterval(timer);
  }, [handleSubmit]);

  function updateAnswerText(questionId: string, value: string) {
    setAnswers((prev) => ({
      ...prev,
      [questionId]: { ...prev[questionId]!, answerText: value },
    }));
  }

  function updateAnswerImage(questionId: string, file: File | null) {
    setAnswers((prev) => ({
      ...prev,
      [questionId]: {
        ...prev[questionId]!,
        imageFile: file,
        imagePreviewUrl: file ? URL.createObjectURL(file) : null,
      },
    }));
  }

  return (
    <div className="space-y-6">
      <div className="sticky top-0 z-10 flex items-center justify-between rounded-[18px] border border-nexus-border bg-nexus-surface px-4 py-3 shadow-card">
        <div>
          <h1 className="font-heading text-lg font-semibold text-foreground">
            {paper.name}
          </h1>
          <p className="text-sm text-muted-foreground">
            {paper.subjectName} · {paper.totalMarks} marks
          </p>
        </div>
        <div className="flex items-center gap-2 text-foreground">
          <Clock className="size-5" />
          <span className="font-heading text-xl font-semibold tabular">
            {formatTime(secondsRemaining)}
          </span>
        </div>
      </div>

      {error ? (
        <p className="text-sm text-nexus-danger" role="alert">
          {error}
        </p>
      ) : null}

      <div className="space-y-4">
        {paper.questions.map((question, index) => (
          <SectionCard
            key={question.id}
            title={`Question ${question.questionNumber}`}
            description={`${question.marks} marks`}
          >
            <div className="space-y-3">
              <p className="text-sm text-foreground">{question.questionText}</p>
              <textarea
                value={answers[question.id]?.answerText ?? ""}
                onChange={(event) =>
                  updateAnswerText(question.id, event.target.value)
                }
                rows={3}
                placeholder="Type your answer, or upload a photo of your working below."
                className="w-full rounded-[14px] border border-nexus-border bg-background p-3 text-sm text-foreground"
              />
              <label className="inline-flex cursor-pointer items-center gap-2 text-sm text-nexus-primary">
                <Camera className="size-4" />
                {answers[question.id]?.imageFile
                  ? "Photo attached — tap to replace"
                  : "Upload photo of handwritten working"}
                <input
                  type="file"
                  accept="image/*"
                  capture="environment"
                  className="hidden"
                  onChange={(event) =>
                    updateAnswerImage(
                      question.id,
                      event.target.files?.[0] ?? null,
                    )
                  }
                />
              </label>
              {answers[question.id]?.imagePreviewUrl ? (
                // eslint-disable-next-line @next/next/no-img-element
                <img
                  src={answers[question.id]?.imagePreviewUrl ?? ""}
                  alt={`Working for question ${index + 1}`}
                  className="max-h-48 rounded-[12px] border border-nexus-border object-contain"
                />
              ) : null}
            </div>
          </SectionCard>
        ))}
      </div>

      <Button
        type="button"
        className="min-h-12 w-full"
        disabled={isSubmitting}
        onClick={() => void handleSubmit()}
      >
        {isSubmitting ? "Submitting..." : "Submit paper"}
      </Button>
    </div>
  );
}
