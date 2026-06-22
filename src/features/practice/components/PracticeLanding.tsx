"use client";

import { useMemo, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";
import { Lock, RotateCcw, Target } from "lucide-react";

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
import { MIN_QUESTIONS_TO_START_PRACTICE } from "@/lib/curriculum/practiceCoverage";
import { getReviewQueue, getReviewQueueCount } from "@/lib/practice/reviewQueue";
import type {
  PracticeCurriculumSubject,
  PracticeCurriculumTopic,
  PracticeDifficulty,
  PracticeQuestionCounts,
} from "@/types/practice";
import { cn } from "@/lib/utils";

const V1_ACTIVE_SUBJECT_CODE = "mathematics";

interface PracticeLandingProps {
  studentId: string;
  curriculumTree: PracticeCurriculumSubject[];
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

function formatCoverageCounts(counts: PracticeQuestionCounts) {
  return `Easy ${counts.easy} · Medium ${counts.medium} · Hard ${counts.hard}`;
}

function CoverageStatus({
  counts,
  practiceReady,
}: {
  counts: PracticeQuestionCounts;
  practiceReady: Record<PracticeDifficulty, boolean>;
}) {
  const anyReady = practiceReady.easy || practiceReady.medium || practiceReady.hard;

  if (!anyReady) {
    return (
      <span className="text-xs font-medium text-nexus-danger">Needs content</span>
    );
  }

  return (
    <span className="text-xs text-muted-foreground">
      {formatCoverageCounts(counts)}
    </span>
  );
}

export function PracticeLanding({
  studentId,
  curriculumTree,
  dailyUsage,
  dailyLimit,
  retryAfterSeconds,
  planCode,
}: PracticeLandingProps) {
  const router = useRouter();
  const searchParams = useSearchParams();

  const sortedSubjects = useMemo(
    () =>
      [...curriculumTree].sort((a, b) => {
        if (a.code === V1_ACTIVE_SUBJECT_CODE) return -1;
        if (b.code === V1_ACTIVE_SUBJECT_CODE) return 1;
        return a.name.localeCompare(b.name);
      }),
    [curriculumTree],
  );

  const defaultSubject =
    sortedSubjects.find((subject) => subject.code === V1_ACTIVE_SUBJECT_CODE) ??
    sortedSubjects[0];

  const [activeSubjectId, setActiveSubjectId] = useState(defaultSubject?.id ?? "");
  const [selectedTopicId, setSelectedTopicId] = useState<string | null>(
    defaultSubject?.topics[0]?.id ?? null,
  );
  const [selectedSubtopicId, setSelectedSubtopicId] = useState<string | null>(null);
  const [difficulty, setDifficulty] = useState<PracticeDifficulty>("medium");
  const [reviewCount, setReviewCount] = useState(() =>
    getReviewQueueCount(studentId),
  );

  const activeSubject = sortedSubjects.find((subject) => subject.id === activeSubjectId);
  const selectedTopic = activeSubject?.topics.find((topic) => topic.id === selectedTopicId);
  const selectedSubtopic = selectedTopic?.subtopics.find(
    (subtopic) => subtopic.id === selectedSubtopicId,
  );

  const runnerTopicId = searchParams.get("topicId");
  const runnerSubtopicId = searchParams.get("subtopicId");
  const sessionDifficulty =
    (searchParams.get("difficulty") as PracticeDifficulty | null) ?? difficulty;
  const reviewMode = searchParams.get("review") === "1";
  const runnerTopic = activeSubject?.topics.find((topic) => topic.id === runnerTopicId);
  const sessionsRemaining = Math.max(0, dailyLimit - dailyUsage);
  const atLimit = sessionsRemaining <= 0;
  const reviewQuestions = reviewMode ? getReviewQueue(studentId).slice(0, 10) : [];

  const activeCounts = selectedSubtopic?.questionCounts ?? selectedTopic?.questionCounts;
  const activePracticeReady =
    selectedSubtopic?.practiceReady ?? selectedTopic?.practiceReady;
  const canStartSession = Boolean(
    selectedTopic &&
      activeCounts &&
      activePracticeReady?.[difficulty] &&
      !atLimit,
  );

  if ((runnerTopic && !atLimit && !reviewMode) || (reviewMode && reviewQuestions.length > 0 && !atLimit)) {
    return (
      <PracticeRunner
        studentId={studentId}
        topicId={reviewMode ? reviewQuestions[0]!.topicId : runnerTopic!.id}
        subtopicId={reviewMode ? undefined : runnerSubtopicId ?? undefined}
        topicTitle={reviewMode ? "Review queue" : runnerTopic!.title}
        subtopicTitle={
          reviewMode
            ? undefined
            : runnerTopic?.subtopics.find((subtopic) => subtopic.id === runnerSubtopicId)
                ?.title
        }
        difficulty={sessionDifficulty}
        initialMastery={
          reviewMode
            ? (activeSubject?.topics.find(
                (topic) => topic.id === reviewQuestions[0]?.topicId,
              )?.masteryPercentage ?? 0)
            : runnerTopic!.masteryPercentage
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

  function handleSubjectChange(subject: PracticeCurriculumSubject) {
    if (subject.code !== V1_ACTIVE_SUBJECT_CODE) {
      return;
    }

    setActiveSubjectId(subject.id);
    setSelectedTopicId(subject.topics[0]?.id ?? null);
    setSelectedSubtopicId(null);
  }

  function handleTopicSelect(topic: PracticeCurriculumTopic) {
    setSelectedTopicId(topic.id);
    setSelectedSubtopicId(null);
  }

  function handleStartPractice() {
    if (!selectedTopic || !canStartSession) {
      return;
    }

    const params = new URLSearchParams({
      topicId: selectedTopic.id,
      difficulty,
    });

    if (selectedSubtopicId) {
      params.set("subtopicId", selectedSubtopicId);
    }

    router.push(`/practice?${params.toString()}`);
  }

  function hasReadyDifficulty(
    practiceReady: Record<PracticeDifficulty, boolean>,
  ) {
    return practiceReady.easy || practiceReady.medium || practiceReady.hard;
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
            Subject
          </h2>
          <p className="text-sm text-muted-foreground">
            Mathematics is active in V1. Other subjects unlock in a later release.
          </p>
        </div>
        <div className="flex flex-wrap gap-2">
          {sortedSubjects.map((subject) => {
            const isActiveSubject = subject.code === V1_ACTIVE_SUBJECT_CODE;
            const isSelected = subject.id === activeSubjectId;

            return (
              <button
                key={subject.id}
                type="button"
                disabled={!isActiveSubject}
                onClick={() => handleSubjectChange(subject)}
                className={cn(
                  "inline-flex min-h-12 items-center gap-2 rounded-full px-4 py-2 text-sm font-medium transition",
                  isSelected && isActiveSubject
                    ? "bg-nexus-primary text-nexus-text-inverse shadow-card"
                    : isActiveSubject
                      ? "border border-nexus-border bg-nexus-surface text-foreground hover:bg-nexus-sunken"
                      : "cursor-not-allowed border border-dashed border-nexus-border bg-nexus-sunken/60 text-muted-foreground",
                )}
              >
                {!isActiveSubject ? <Lock className="size-4" /> : null}
                {subject.name}
                {!isActiveSubject ? (
                  <span className="text-xs uppercase tracking-wide">V2</span>
                ) : null}
              </button>
            );
          })}
        </div>
      </div>

      {activeSubject?.code === V1_ACTIVE_SUBJECT_CODE ? (
        <>
          <div className="space-y-3">
            <div>
              <h2 className="font-heading text-lg font-semibold text-foreground">
                Topic
              </h2>
              <p className="text-sm text-muted-foreground">
                Choose a topic, then pick a chapter or practice the whole topic.
              </p>
            </div>

            {activeSubject.topics.length === 0 ? (
              <EmptyState
                title="No practice topics yet"
                description="Complete your diagnostic and check back once Mathematics topics are available."
                primaryAction={{ label: "Go to Learn", href: "/learn" }}
              />
            ) : (
              <div className="grid gap-4 nexus-enter-stagger sm:grid-cols-2">
                {activeSubject.topics.map((topic) => {
                  const status = getTopicMasteryStatus(topic.masteryPercentage);
                  const isSelected = topic.id === selectedTopicId;

                  return (
                    <button
                      key={topic.id}
                      type="button"
                      onClick={() => handleTopicSelect(topic)}
                      className={cn(
                        "nexus-card-hover rounded-[22px] border p-5 text-left shadow-card focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
                        isSelected
                          ? "border-nexus-primary bg-nexus-primary-soft/40"
                          : "border-nexus-border bg-nexus-surface",
                      )}
                    >
                      <div className="flex flex-wrap items-center gap-2">
                        <span className="rounded-full bg-nexus-primary-soft px-2.5 py-1 text-xs font-medium text-nexus-primary">
                          {formatStrandLabel(topic.code)}
                        </span>
                        <span className="text-xs text-muted-foreground">
                          {getTopicMasteryLabel(status)}
                        </span>
                        {!hasReadyDifficulty(topic.practiceReady) ? (
                          <span className="text-xs font-medium text-nexus-danger">
                            Needs content
                          </span>
                        ) : (
                          <span className="text-xs font-medium text-nexus-success">
                            Ready
                          </span>
                        )}
                      </div>
                      <h3 className="mt-3 font-heading text-lg font-semibold text-foreground">
                        {topic.title}
                      </h3>
                      <p className="mt-2 text-xs text-muted-foreground">
                        {formatCoverageCounts(topic.questionCounts)} ·{" "}
                        {topic.lessonCount} lessons
                      </p>
                      <div className="mt-4">
                        <BarMeter value={topic.masteryPercentage} label="Mastery" />
                      </div>
                    </button>
                  );
                })}
              </div>
            )}
          </div>

          {selectedTopic ? (
            <div className="space-y-3">
              <div>
                <h2 className="font-heading text-lg font-semibold text-foreground">
                  Chapter / part
                </h2>
                <p className="text-sm text-muted-foreground">
                  Drill into a subtopic or practice across the whole topic.
                </p>
              </div>

              <div className="space-y-2">
                <button
                  type="button"
                  onClick={() => setSelectedSubtopicId(null)}
                  className={cn(
                    "flex w-full min-h-12 items-center justify-between rounded-xl border px-4 py-3 text-left transition-colors",
                    selectedSubtopicId === null
                      ? "border-nexus-primary bg-nexus-primary-soft/40"
                      : "border-nexus-border bg-nexus-surface hover:bg-nexus-sunken",
                  )}
                >
                  <div>
                    <p className="font-medium text-foreground">Whole topic</p>
                    <p className="text-sm text-muted-foreground">
                      All published questions in {selectedTopic.title}
                    </p>
                  </div>
                  <CoverageStatus
                    counts={selectedTopic.questionCounts}
                    practiceReady={selectedTopic.practiceReady}
                  />
                </button>

                {selectedTopic.subtopics.map((subtopic) => (
                  <button
                    key={subtopic.id}
                    type="button"
                    onClick={() => setSelectedSubtopicId(subtopic.id)}
                    className={cn(
                      "flex w-full min-h-12 items-center justify-between rounded-xl border px-4 py-3 text-left transition-colors",
                      selectedSubtopicId === subtopic.id
                        ? "border-nexus-primary bg-nexus-primary-soft/40"
                        : "border-nexus-border bg-nexus-surface hover:bg-nexus-sunken",
                    )}
                  >
                    <div>
                      <p className="font-medium text-foreground">{subtopic.title}</p>
                      <p className="text-sm text-muted-foreground">
                        {subtopic.lessonCount} lesson
                        {subtopic.lessonCount === 1 ? "" : "s"}
                      </p>
                    </div>
                    <CoverageStatus
                      counts={subtopic.questionCounts}
                      practiceReady={subtopic.practiceReady}
                    />
                  </button>
                ))}
              </div>
            </div>
          ) : null}

          {selectedTopic ? (
            <div className="space-y-3">
              <div>
                <h2 className="font-heading text-lg font-semibold text-foreground">
                  Difficulty
                </h2>
                <p className="text-sm text-muted-foreground">
                  Each session includes 10 questions at the level you pick. You need
                  at least {MIN_QUESTIONS_TO_START_PRACTICE} published questions to start.
                </p>
              </div>
              <div className="flex flex-wrap gap-2">
                {DIFFICULTIES.map((level) => {
                  const ready = activePracticeReady?.[level.value] ?? false;

                  return (
                    <button
                      key={level.value}
                      type="button"
                      disabled={!ready}
                      onClick={() => setDifficulty(level.value)}
                      className={cn(
                        "min-h-12 rounded-full border px-4 py-2 text-sm font-medium transition-colors disabled:cursor-not-allowed disabled:opacity-50",
                        difficulty === level.value
                          ? "border-nexus-primary bg-nexus-primary text-nexus-text-inverse"
                          : "border-nexus-border bg-nexus-surface text-foreground hover:bg-nexus-sunken",
                      )}
                    >
                      {level.label}
                      <span className="ml-2 text-xs opacity-80">
                        ({activeCounts?.[level.value] ?? 0})
                      </span>
                    </button>
                  );
                })}
              </div>
              <p className="text-sm text-muted-foreground">
                {DIFFICULTIES.find((level) => level.value === difficulty)?.hint}
              </p>

              <Button
                type="button"
                className="min-h-12"
                disabled={!canStartSession}
                onClick={handleStartPractice}
              >
                {canStartSession
                  ? `Start ${difficulty} session`
                  : "Not enough published questions"}
              </Button>
            </div>
          ) : null}
        </>
      ) : null}

      <p className="text-xs text-muted-foreground">
        Review queue is saved on this device only and is not synced across browsers.
      </p>
    </div>
  );
}

/** @deprecated Use PracticeLanding — kept for route import stability */
export const PracticeTopicPicker = PracticeLanding;

export type { PracticeDifficulty };
