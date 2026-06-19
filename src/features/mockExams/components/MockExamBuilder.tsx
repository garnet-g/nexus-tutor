"use client";

import Link from "next/link";
import { useEffect, useRef, useState } from "react";
import { useRouter } from "next/navigation";

import { AsyncActionButton } from "@/components/ui/async-action-button";
import { Card } from "@/components/ui/Card";
import { FormStatus } from "@/components/ui/form-status";
import { track } from "@/lib/analytics/track";
import type { Tier1SubjectCode } from "@/lib/curriculum/contentModel";
import type { MockExamStyle } from "@/schemas/mockExamSchemas";

interface TopicOption {
  id: string;
  title: string;
}

interface MockExamBuilderProps {
  topics: TopicOption[];
  premiumAccess: boolean;
  subjectCode?: Tier1SubjectCode;
  initialExamStyle?: MockExamStyle;
  initialTopicId?: string;
}

const STYLE_OPTIONS: Array<{ value: MockExamStyle; label: string; description: string }> = [
  { value: "kcse_style", label: "KCSE-style", description: "20-question KNEC-style mathematics paper" },
  { value: "cbc_style", label: "CBC-style", description: "15-question competency-based paper" },
  { value: "topic_specific", label: "Topic focus", description: "10 questions from one topic" },
  { value: "full_math", label: "Full math paper", description: "25-question mixed mathematics paper" },
];

export function MockExamBuilder({
  topics,
  premiumAccess,
  subjectCode = "mathematics",
  initialExamStyle = "kcse_style",
  initialTopicId,
}: MockExamBuilderProps) {
  const router = useRouter();
  const [examStyle, setExamStyle] = useState<MockExamStyle>(initialExamStyle);
  const [topicId, setTopicId] = useState(
    initialTopicId ?? topics[0]?.id ?? "",
  );
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const lastStepRef = useRef<"style" | "topic" | "start">("style");
  const completedRef = useRef(false);

  async function handleGenerate() {
    track("cta_clicked", { location: "mock_exam_builder", action: "generate_clicked" });
    setLoading(true);
    setError(null);
    track("form_submit_started", { form: "mock_exam_builder" });

    try {
      const response = await fetch("/api/mock-exams/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          examStyle,
          subjectCode,
          ...(examStyle === "topic_specific" ? { topicId } : {}),
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          mockExamSessionId: string;
          isPreview: boolean;
          questionCount: number;
        };
        error?: { message?: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        throw new Error(payload.error?.message ?? "Could not generate mock exam.");
      }

      const startResponse = await fetch("/api/exam-simulator/start", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          mockExamSessionId: payload.data.mockExamSessionId,
          durationMinutes: 45,
        }),
      });

      const startPayload = (await startResponse.json()) as {
        success: boolean;
        data?: { simulatorSessionId: string };
        error?: { message?: string };
      };

      if (!startResponse.ok || !startPayload.success || !startPayload.data) {
        throw new Error(startPayload.error?.message ?? "Could not start simulator.");
      }

      router.push(
        `/exam-simulator?sessionId=${startPayload.data.simulatorSessionId}`,
      );
      completedRef.current = true;
      track("form_submit_succeeded", { form: "mock_exam_builder" });
    } catch (generateError) {
      const message =
        generateError instanceof Error
          ? generateError.message
          : "Something went wrong.";
      setError(message);
      track("form_submit_failed", { form: "mock_exam_builder" });
      track("api_error_shown", { form: "mock_exam_builder", message });
    } finally {
      setLoading(false);
    }
  }

  useEffect(() => {
    if (loading) {
      lastStepRef.current = "start";
      return;
    }
    lastStepRef.current = examStyle === "topic_specific" ? "topic" : "style";
  }, [examStyle, loading]);

  useEffect(() => {
    return () => {
      if (completedRef.current) {
        return;
      }
      track("wizard_step_abandoned", {
        wizard: "mock_exam_builder",
        step: lastStepRef.current,
      });
    };
  }, []);

  return (
    <Card className="space-y-6 p-6">
      {!premiumAccess ? (
        <div className="rounded-xl border border-dashed border-border bg-muted px-4 py-3 text-sm text-muted-foreground">
          Free preview includes up to 5 questions.{" "}
          <Link href="/pricing" className="font-medium text-primary underline-offset-4 hover:underline">
            Upgrade to Premium
          </Link>{" "}
          for full-length mock exams.
        </div>
      ) : (
        <p className="text-sm text-muted-foreground">
          Premium mock exams use your curriculum question bank with exam-style difficulty mixing.
        </p>
      )}

      <div className="grid gap-3">
        {STYLE_OPTIONS.map((option) => (
          <label
            key={option.value}
            className="flex cursor-pointer gap-3 rounded-xl border border-border p-4 hover:border-primary/40"
          >
            <input
              type="radio"
              name="examStyle"
              value={option.value}
              checked={examStyle === option.value}
              onChange={() => setExamStyle(option.value)}
              className="mt-1"
            />
            <span>
              <span className="block text-sm font-medium text-foreground">
                {option.label}
              </span>
              <span className="block text-sm text-muted-foreground">
                {option.description}
              </span>
            </span>
          </label>
        ))}
      </div>

      {examStyle === "topic_specific" ? (
        <label className="block text-sm text-muted-foreground">
          Topic
          <select
            value={topicId}
            onChange={(event) => setTopicId(event.target.value)}
            className="mt-2 w-full rounded-xl border border-border bg-card px-3 py-2 text-sm text-foreground"
          >
            {topics.map((topic) => (
              <option key={topic.id} value={topic.id}>
                {topic.title}
              </option>
            ))}
          </select>
        </label>
      ) : null}

      <FormStatus message={error} tone="error" className="text-nexus-danger" />

      <AsyncActionButton
        type="button"
        onClick={handleGenerate}
        isPending={loading}
        fullWidth
        idleLabel="Generate & start simulator"
        pendingLabel="Building paper..."
      />
    </Card>
  );
}
