"use client";

import Link from "next/link";
import { useEffect, useMemo, useRef, useState } from "react";
import { useRouter } from "next/navigation";

import { AsyncActionButton } from "@/components/ui/async-action-button";
import { Card } from "@/components/ui/Card";
import { FormStatus } from "@/components/ui/form-status";
import { track } from "@/lib/analytics/track";
import type { MockExamStyle } from "@/schemas/mockExamSchemas";
import type { Tier1SubjectCode } from "@/lib/curriculum/contentModel";
import type { CurriculumSubject, CurriculumTopic } from "@/types/curriculum";

interface ExamPrepWizardProps {
  curriculum: string;
  gradeLevel: string;
  subjects: CurriculumSubject[];
  topicsBySubjectId: Record<string, CurriculumTopic[]>;
  premiumAccess: boolean;
}

const MATH_STYLE_OPTIONS: Array<{
  value: MockExamStyle;
  label: string;
  description: string;
}> = [
  {
    value: "kcse_style",
    label: "KCSE-style",
    description: "20-question KNEC-style paper",
  },
  {
    value: "cbc_style",
    label: "CBC-style",
    description: "15-question competency-based paper",
  },
  {
    value: "topic_specific",
    label: "Strand focus",
    description: "10 questions from one strand",
  },
  {
    value: "full_math",
    label: "Full math paper",
    description: "25-question mixed mathematics paper",
  },
];

const NON_MATH_STYLE_OPTIONS: Array<{
  value: MockExamStyle;
  label: string;
  description: string;
}> = [
  {
    value: "cbc_style",
    label: "CBC-style",
    description: "15-question competency-based paper",
  },
  {
    value: "topic_specific",
    label: "Strand focus",
    description: "10 questions from one strand",
  },
];

function defaultExamStyle(subjectCode: string): MockExamStyle {
  if (subjectCode === "mathematics") {
    return "kcse_style";
  }
  return "topic_specific";
}

export function buildGeneratePayload(input: {
  examStyle: MockExamStyle;
  subjectCode: Tier1SubjectCode;
  topicId: string;
  topics: CurriculumTopic[];
}): {
  examStyle: MockExamStyle;
  subjectCode: Tier1SubjectCode;
  topicId?: string;
} {
  const needsTopic =
    input.examStyle === "topic_specific" ||
    input.subjectCode !== "mathematics";

  return {
    examStyle: input.examStyle,
    subjectCode: input.subjectCode,
    ...(needsTopic && input.topicId ? { topicId: input.topicId } : {}),
  };
}

export function ExamPrepWizard({
  curriculum,
  gradeLevel,
  subjects,
  topicsBySubjectId,
  premiumAccess,
}: ExamPrepWizardProps) {
  const router = useRouter();
  const [subjectId, setSubjectId] = useState(subjects[0]?.id ?? "");
  const selectedSubject = subjects.find((subject) => subject.id === subjectId);
  const subjectCode = (selectedSubject?.code ?? "mathematics") as Tier1SubjectCode;
  const topics = useMemo(
    () => topicsBySubjectId[subjectId] ?? [],
    [topicsBySubjectId, subjectId],
  );

  const styleOptions =
    subjectCode === "mathematics" ? MATH_STYLE_OPTIONS : NON_MATH_STYLE_OPTIONS;

  const [examStyle, setExamStyle] = useState<MockExamStyle>(() =>
    defaultExamStyle(subjectCode),
  );
  const [topicId, setTopicId] = useState(topics[0]?.id ?? "");
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const lastStepRef = useRef<"subject" | "style" | "start">("subject");
  const completedRef = useRef(false);

  const effectiveTopicId = useMemo(() => {
    if (topics.some((topic) => topic.id === topicId)) {
      return topicId;
    }
    return topics[0]?.id ?? "";
  }, [topicId, topics]);

  function handleSubjectChange(nextSubjectId: string) {
    track("cta_clicked", { location: "exam_prep_wizard", action: "subject_changed" });
    setSubjectId(nextSubjectId);
    const nextSubject = subjects.find((subject) => subject.id === nextSubjectId);
    const nextCode = nextSubject?.code ?? "mathematics";
    setExamStyle(defaultExamStyle(nextCode));
    const nextTopics = topicsBySubjectId[nextSubjectId] ?? [];
    setTopicId(nextTopics[0]?.id ?? "");
  }

  async function handleStart() {
    if (!selectedSubject) {
      setError("Select a subject to continue.");
      return;
    }

    if (
      (examStyle === "topic_specific" || subjectCode !== "mathematics") &&
      !effectiveTopicId
    ) {
      setError("Select a strand to continue.");
      return;
    }

    setLoading(true);
    setError(null);
    track("form_submit_started", { form: "exam_prep_wizard" });

    try {
      const payload = buildGeneratePayload({
        examStyle,
        subjectCode,
        topicId: effectiveTopicId,
        topics,
      });

      const response = await fetch("/api/mock-exams/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });

      const generateResult = (await response.json()) as {
        success: boolean;
        data?: {
          mockExamSessionId: string;
          isPreview: boolean;
          questionCount: number;
        };
        error?: { message?: string };
      };

      if (!response.ok || !generateResult.success || !generateResult.data) {
        throw new Error(
          generateResult.error?.message ?? "Could not generate mock exam.",
        );
      }

      const startResponse = await fetch("/api/exam-simulator/start", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          mockExamSessionId: generateResult.data.mockExamSessionId,
          durationMinutes: 45,
        }),
      });

      const startResult = (await startResponse.json()) as {
        success: boolean;
        data?: { simulatorSessionId: string };
        error?: { message?: string };
      };

      if (!startResponse.ok || !startResult.success || !startResult.data) {
        throw new Error(
          startResult.error?.message ?? "Could not start simulator.",
        );
      }

      router.push(
        `/exam-simulator?sessionId=${startResult.data.simulatorSessionId}`,
      );
      completedRef.current = true;
      track("form_submit_succeeded", { form: "exam_prep_wizard" });
    } catch (startError) {
      const message =
        startError instanceof Error
          ? startError.message
          : "Something went wrong.";
      setError(message);
      track("form_submit_failed", { form: "exam_prep_wizard" });
      track("api_error_shown", { form: "exam_prep_wizard", message });
    } finally {
      setLoading(false);
    }
  }

  const showStrandPicker =
    examStyle === "topic_specific" || subjectCode !== "mathematics";

  useEffect(() => {
    const step: "subject" | "style" | "start" = loading
      ? "start"
      : showStrandPicker
        ? "style"
        : "subject";
    lastStepRef.current = step;
  }, [loading, showStrandPicker]);

  useEffect(() => {
    return () => {
      if (completedRef.current) {
        return;
      }
      track("wizard_step_abandoned", {
        wizard: "exam_prep",
        step: lastStepRef.current,
      });
    };
  }, []);

  return (
    <Card className="space-y-6 p-6">
      {!premiumAccess ? (
        <div className="rounded-xl border border-dashed border-border bg-muted px-4 py-3 text-sm text-muted-foreground">
          Free preview includes up to 5 questions.{" "}
          <Link
            href="/pricing"
            className="font-medium text-primary underline-offset-4 hover:underline"
          >
            Upgrade to Premium
          </Link>{" "}
          for full-length mock exams.
        </div>
      ) : (
        <p className="text-sm text-muted-foreground">
          Premium mock exams use your curriculum question bank with exam-style
          difficulty mixing.
        </p>
      )}

      <div className="flex flex-wrap items-center gap-2">
        <span className="rounded-full bg-primary/10 px-3 py-1 text-xs font-medium text-primary">
          {curriculum}
        </span>
        <span className="rounded-full border border-border px-3 py-1 text-xs font-medium text-foreground">
          {gradeLevel}
        </span>
      </div>

      <label className="block text-sm text-muted-foreground">
        Subject
        <select
          value={subjectId}
          onChange={(event) => handleSubjectChange(event.target.value)}
          className="mt-2 w-full rounded-xl border border-border bg-card px-3 py-2 text-sm text-foreground"
        >
          {subjects.map((subject) => (
            <option key={subject.id} value={subject.id}>
              {subject.name}
            </option>
          ))}
        </select>
      </label>

      {showStrandPicker ? (
        <label className="block text-sm text-muted-foreground">
          Strand
          <select
            value={effectiveTopicId}
            onChange={(event) => setTopicId(event.target.value)}
            className="mt-2 w-full rounded-xl border border-border bg-card px-3 py-2 text-sm text-foreground"
          >
            {topics.length === 0 ? (
              <option value="">No strands available</option>
            ) : (
              topics.map((topic) => (
                <option key={topic.id} value={topic.id}>
                  {topic.title}
                </option>
              ))
            )}
          </select>
        </label>
      ) : null}

      <div className="grid gap-3">
        {styleOptions.map((option) => (
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

      <FormStatus message={error} tone="error" className="text-nexus-danger" />

      <AsyncActionButton
        type="button"
        onClick={handleStart}
        isPending={loading}
        fullWidth
        idleLabel="Start Exam Preparation"
        pendingLabel="Starting preparation..."
      />
    </Card>
  );
}
