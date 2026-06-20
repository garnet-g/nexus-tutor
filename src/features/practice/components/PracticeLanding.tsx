"use client";

import { useRouter, useSearchParams } from "next/navigation";
import { useState } from "react";
import { RotateCcw, Target } from "lucide-react";

import { EmptyState } from "@/components/ui/EmptyState";
import { SectionCard } from "@/components/ui/SectionCard";
import { Button } from "@/components/ui/Button";
import { BarMeter } from "@/components/widgets/Charts";
import { PracticeRunner } from "@/features/practice/components/PracticeRunner";
import {
  formatStrandLabel,
  getTopicMasteryLabel,
  getTopicMasteryStatus,
} from "@/lib/learn/masteryStatus";
import { getReviewQueue, getReviewQueueCount } from "@/lib/practice/reviewQueue";
import { cn } from "@/lib/utils";

export type PracticeDifficulty = "easy" | "medium" | "hard";

export interface PracticeTopic {
  id: string;
  title: string;
  code: string;
  masteryPercentage: number;
}

interface PracticeLandingProps {
  studentId: string;
  topics: PracticeTopic[];
  dailyUsage: number;
  dailyLimit: number;
  retryAfterSeconds: number;
  planCode: string;
}

const DIFFICULTIES: Array<{
  value: PracticeDifficulty;
  label: string;
  hint: string;
}> = [
  { value: "easy", label: "Easy", hint: "Build confidence" },
  { value: "medium", label: "Medium", hint: "Balanced challenge" },
  { value: "hard", label: "Hard", hint: "Exam-style push" },
];

export function PracticeLanding({
  studentId,
  topics,
  dailyUsage,
  dailyLimit,
  retryAfterSeconds,
  planCode,
}: PracticeLandingProps) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const [difficulty, setDifficulty] = useState<PracticeDifficulty>("medium");
  const [reviewCount, setReviewCount] = useState(() =>
    getReviewQueueCount(studentId),
  );

  const selectedTopicId = searchParams.get("topicId");
  const sessionDifficulty =
    (searchParams.get("difficulty") as PracticeDifficulty | null) ?? difficulty;
  const reviewMode = searchParams.get("review") === "1";
  const selectedTopic = topics.find((topic) => topic.id === selectedTopicId);
  const sessionsRemaining = Math.max(0, dailyLimit - dailyUsage);
  const atLimit = sessionsRemaining <= 0;
  const reviewQuestions = reviewMode ? getReviewQueue(studentId).slice(0, 10) : [];

  if ((selectedTopic && !atLimit && !reviewMode) || (reviewMode && reviewQuestions.length > 0 && !atLimit)) {
    return (
      <PracticeRunner
        studentId={studentId}
        topicId={reviewMode ? reviewQuestions[0]!.topicId : selectedTopic!.id}
        topicTitle={reviewMode ? "Review queue" : selectedTopic!.title}
        difficulty={sessionDifficulty}
        initialMastery={
          reviewMode
            ? (topics.find((topic) => topic.id === reviewQuestions[0]?.topicId)
                ?.masteryPercentage ?? 0)
            : selectedTopic!.masteryPercentage
        }
        reviewQuestions={reviewMode ? reviewQuestions : undefined}
        onReviewQueueChange={() => setReviewCount(getReviewQueueCount(studentId))}
      />
    );
  }

  if (atLimit) {
    const hours = Math.max(1, Math.ceil(retryAfterSeconds / 3600));
    return (
      <EmptyState
        icon={<Target className="size-6" />}
        title="Daily practice limit reached"
        description={`You have used all ${dailyLimit} free sessions for today. Core access stays free — upgrade for higher limits, or come back in about ${hours} hour${hours === 1 ? "" : "s"}.`}
        primaryAction={
          planCode === "free"
            ? { label: "View Premium plans", href: "/pricing" }
            : undefined
        }
        secondaryAction={{ label: "Back to Today", href: "/dashboard" }}
      />
    );
  }

  return (
    <div className="space-y-6 nexus-enter">
      <SectionCard
        title="Today's practice allowance"
        description="Free forever — sessions reset at midnight Nairobi time."
      >
        <div className="space-y-3">
          <BarMeter
            value={dailyUsage}
            max={dailyLimit}
            label="Sessions used"
            showValue
          />
          <p className="text-sm text-muted-foreground">
            {sessionsRemaining} of {dailyLimit} free session
            {dailyLimit === 1 ? "" : "s"} left today
          </p>
        </div>
      </SectionCard>

      {reviewCount > 0 ? (
        <SectionCard
          title={`Review (${reviewCount})`}
          description="Previously missed questions saved on this device."
        >
          <Button
            variant="outline"
            className="min-h-12"
            onClick={() => router.push("/practice?review=1")}
          >
            <RotateCcw className="size-4" data-icon="inline-start" />
            Start review session
          </Button>
        </SectionCard>
      ) : null}

      <div className="space-y-3">
        <div>
          <h2 className="font-heading text-lg font-semibold text-foreground">
            Choose difficulty
          </h2>
          <p className="text-sm text-muted-foreground">
            Each session includes 10 questions at the level you pick.
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          {DIFFICULTIES.map((level) => (
            <button
              key={level.value}
              type="button"
              onClick={() => setDifficulty(level.value)}
              className={cn(
                "min-h-12 rounded-full border px-4 py-2 text-sm font-medium transition-colors",
                difficulty === level.value
                  ? "border-nexus-primary bg-nexus-primary text-nexus-text-inverse"
                  : "border-nexus-border bg-nexus-surface text-foreground hover:bg-nexus-sunken",
              )}
            >
              {level.label}
            </button>
          ))}
        </div>
        <p className="text-sm text-muted-foreground">
          {DIFFICULTIES.find((level) => level.value === difficulty)?.hint}
        </p>
      </div>

      {topics.length === 0 ? (
        <EmptyState
          title="No practice topics yet"
          description="Complete your diagnostic and check back once Mathematics topics are available."
          primaryAction={{ label: "Go to Learn", href: "/learn" }}
        />
      ) : (
        <div className="grid gap-4 nexus-enter-stagger sm:grid-cols-2">
          {topics.map((topic) => {
            const status = getTopicMasteryStatus(topic.masteryPercentage);
            return (
              <button
                key={topic.id}
                type="button"
                onClick={() =>
                  router.push(
                    `/practice?topicId=${topic.id}&difficulty=${difficulty}`,
                  )
                }
                className="nexus-card-hover rounded-[22px] border border-nexus-border bg-nexus-surface p-5 text-left shadow-card focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
              >
                <div className="flex flex-wrap items-center gap-2">
                  <span className="rounded-full bg-nexus-primary-soft px-2.5 py-1 text-xs font-medium text-nexus-primary">
                    {formatStrandLabel(topic.code)}
                  </span>
                  <span className="text-xs text-muted-foreground">
                    {getTopicMasteryLabel(status)}
                  </span>
                </div>
                <h3 className="mt-3 font-heading text-lg font-semibold text-foreground">
                  {topic.title}
                </h3>
                <div className="mt-4">
                  <BarMeter value={topic.masteryPercentage} label="Mastery" />
                </div>
                <p className="mt-3 text-sm text-nexus-primary">
                  Start {difficulty} session →
                </p>
              </button>
            );
          })}
        </div>
      )}

      <p className="text-xs text-muted-foreground">
        Review queue is saved on this device only and is not synced across browsers.
      </p>
    </div>
  );
}

/** @deprecated Use PracticeLanding — kept for route import stability */
export const PracticeTopicPicker = PracticeLanding;
