"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

import { Button } from "@/components/ui/Button";

export function ReadinessExamCta({
  planCode,
  activeExamPaperSessionId,
}: {
  planCode: string;
  activeExamPaperSessionId: string | null;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const premiumAccess = planCode === "premium" || planCode === "family";

  async function startOrResume() {
    setLoading(true);
    setError(null);

    try {
      if (activeExamPaperSessionId) {
        router.push(`/exam-papers/${activeExamPaperSessionId}`);
        return;
      }

      const response = await fetch("/api/exam-papers/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ paper: 1 }),
      });
      const body = await response.json();
      if (!response.ok || !body.success) {
        throw new Error(body.error?.message ?? "Could not start the exam paper.");
      }
      if (body.data.status !== "generated") {
        throw new Error(
          body.data.status === "cbc_unavailable"
            ? "Exam prep for CBC is coming soon."
            : "The question bank for your form is still being built.",
        );
      }

      router.push(`/exam-papers/${body.data.sessionId}`);
    } catch (startError) {
      setError(
        startError instanceof Error
          ? startError.message
          : "Could not start the exam paper.",
      );
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="rounded-2xl border border-nexus-border bg-nexus-surface p-4">
      <p className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
        Timed practice
      </p>
      <p className="mt-2 text-lg font-semibold text-foreground">
        {activeExamPaperSessionId ? "Resume your KCSE Paper 1" : "Start a full KCSE Paper 1"}
      </p>
      <p className="mt-1 text-sm text-muted-foreground">
        {premiumAccess
          ? "Generate or resume a full timed paper from your current readiness."
          : "Free plan gives you a 5-question sample."}
      </p>
      {error ? <p className="mt-2 text-sm text-destructive">{error}</p> : null}
      <Button className="mt-4 min-h-11" onClick={() => void startOrResume()} disabled={loading}>
        {loading ? "Preparing…" : activeExamPaperSessionId ? "Resume paper" : "Generate and start"}
      </Button>
    </div>
  );
}
