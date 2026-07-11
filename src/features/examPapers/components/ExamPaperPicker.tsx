"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

import { Button } from "@/components/ui/Button";

type GenerateResponse =
  | { status: "cbc_unavailable" }
  | { status: "insufficient_bank"; formScope: number }
  | { status: "generated"; sessionId: string; endsAt: string; totalMarks: number; isSample: boolean };

export function ExamPaperPicker({ gradeLevel }: { gradeLevel: string }) {
  const router = useRouter();
  const [loadingPaper, setLoadingPaper] = useState<1 | 2 | null>(null);
  const [message, setMessage] = useState<string | null>(null);

  async function startPaper(paper: 1 | 2) {
    setLoadingPaper(paper);
    setMessage(null);

    try {
      const response = await fetch("/api/exam-papers/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ paper }),
      });
      const body = await response.json();

      if (!response.ok || !body.success) {
        throw new Error(body.error?.message ?? "Could not start the exam paper.");
      }

      const data = body.data as GenerateResponse;

      if (data.status === "cbc_unavailable") {
        setMessage("Exam prep for CBC is coming soon.");
        return;
      }
      if (data.status === "insufficient_bank") {
        setMessage(`The Paper ${paper} question bank for ${gradeLevel} is still being built. Check back soon.`);
        return;
      }

      router.push(`/exam-papers/${data.sessionId}`);
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Could not start the exam paper.");
    } finally {
      setLoadingPaper(null);
    }
  }

  return (
    <div className="space-y-4">
      <p className="text-sm text-muted-foreground">
        Freshly generated every time — Section I (16 short-answer questions, 50 marks) and
        Section II (choose 5 of 8 structured questions, 50 marks), scoped to {gradeLevel} content.
      </p>

      <div className="grid gap-4 sm:grid-cols-2">
        {[1, 2].map((paper) => (
          <div key={paper} className="rounded-2xl border border-nexus-border bg-nexus-surface p-4">
            <p className="text-lg font-semibold text-foreground">KCSE Mathematics Paper {paper}</p>
            <p className="mt-1 text-sm text-muted-foreground">2 hours 30 minutes · 100 marks</p>
            <Button
              className="mt-4 min-h-11 w-full"
              onClick={() => void startPaper(paper as 1 | 2)}
              disabled={loadingPaper !== null}
            >
              {loadingPaper === paper ? "Preparing…" : `Start Paper ${paper}`}
            </Button>
          </div>
        ))}
      </div>

      {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
    </div>
  );
}
