"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";

import { Button } from "@/components/ui/Button";

export function ReadinessExamCta({
  planCode,
  topicId,
  activeSimulatorSessionId,
  readyMockSessionId,
}: {
  planCode: string;
  topicId: string | null;
  activeSimulatorSessionId: string | null;
  readyMockSessionId: string | null;
}) {
  const router = useRouter();
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);

  const premiumAccess = planCode === "premium" || planCode === "family";

  async function startOrResume() {
    setLoading(true);
    setError(null);

    try {
      if (activeSimulatorSessionId) {
        router.push(`/exam-simulator?sessionId=${activeSimulatorSessionId}`);
        return;
      }

      let mockSessionId = readyMockSessionId;

      if (!mockSessionId) {
        const generateResponse = await fetch("/api/mock-exams/generate", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            examStyle: "kcse_style",
            ...(topicId ? { topicId } : {}),
          }),
        });
        const generateBody = await generateResponse.json();
        if (!generateResponse.ok || !generateBody.success) {
          throw new Error(generateBody.error?.message ?? "Could not generate a mock exam.");
        }
        mockSessionId = generateBody.data.mockExamSessionId as string;
      }

      const startResponse = await fetch("/api/exam-simulator/start", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ mockExamSessionId: mockSessionId }),
      });
      const startBody = await startResponse.json();
      if (!startResponse.ok || !startBody.success) {
        throw new Error(startBody.error?.message ?? "Could not start the exam simulator.");
      }

      router.push(`/exam-simulator?sessionId=${startBody.data.examSimulatorSessionId}`);
    } catch (startError) {
      setError(
        startError instanceof Error
          ? startError.message
          : "Could not start the exam simulator.",
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
        {activeSimulatorSessionId ? "Resume your exam simulator" : "Start a timed mock exam"}
      </p>
      <p className="mt-1 text-sm text-muted-foreground">
        {premiumAccess
          ? "Generate or resume a timed session from your current readiness."
          : "Preview access may limit question count on free plans."}
      </p>
      {error ? <p className="mt-2 text-sm text-destructive">{error}</p> : null}
      <Button className="mt-4 min-h-11" onClick={() => void startOrResume()} disabled={loading}>
        {loading
          ? "Preparing…"
          : activeSimulatorSessionId
            ? "Resume simulator"
            : "Generate and start"}
      </Button>
    </div>
  );
}
