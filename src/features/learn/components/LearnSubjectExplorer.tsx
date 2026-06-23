"use client";

import { useMemo, useState } from "react";

import { EmptyState } from "@/components/ui/EmptyState";
import { SectionCard } from "@/components/ui/SectionCard";
import { ProgressRing } from "@/components/widgets/Charts";
import { TopicCard } from "@/features/learn/components/TopicCard";
import { averageMastery } from "@/lib/learn/masteryStatus";
import type { CurriculumSubject, CurriculumTopic } from "@/types/curriculum";
import { cn } from "@/lib/utils";

const PRIMARY_SUBJECT_CODE = "mathematics";

interface LearnSubjectExplorerProps {
  subjects: CurriculumSubject[];
  topicsBySubjectId: Record<string, CurriculumTopic[]>;
  topicMasteryById: Record<string, number>;
}

export function LearnSubjectExplorer({
  subjects,
  topicsBySubjectId,
  topicMasteryById,
}: LearnSubjectExplorerProps) {
  const sortedSubjects = useMemo(
    () =>
      [...subjects].sort((a, b) => {
        if (a.code === PRIMARY_SUBJECT_CODE) return -1;
        if (b.code === PRIMARY_SUBJECT_CODE) return 1;
        return a.name.localeCompare(b.name);
      }),
    [subjects],
  );

  const [activeSubjectCode, setActiveSubjectCode] = useState(
    sortedSubjects[0]?.code ?? "",
  );

  const activeSubject = sortedSubjects.find(
    (subject) => subject.code === activeSubjectCode,
  );
  const activeTopics = activeSubject
    ? (topicsBySubjectId[activeSubject.id] ?? [])
    : [];
  const aggregateMastery = averageMastery(
    topicMasteryById,
    activeTopics.map((topic) => topic.id),
  );

  if (subjects.length === 0) {
    return (
      <EmptyState
        title="No subjects yet"
        description="Your curriculum content is still being set up. Complete onboarding or check back after your diagnostic."
        primaryAction={{ label: "Go to Today", href: "/dashboard" }}
      />
    );
  }

  return (
    <div className="space-y-6 nexus-enter">
      <div className="flex flex-wrap gap-2">
        {sortedSubjects.map((subject) => {
          const isSelected = subject.code === activeSubjectCode;

          return (
            <button
              key={subject.id}
              type="button"
              aria-label={subject.name}
              onClick={() => setActiveSubjectCode(subject.code)}
              className={cn(
                "inline-flex min-h-12 items-center gap-2 rounded-full border px-4 py-2 text-sm font-medium transition active:translate-y-px",
                isSelected
                  ? "bg-nexus-primary text-nexus-text-inverse shadow-card"
                  : "border-nexus-border bg-nexus-surface text-foreground hover:bg-nexus-sunken",
              )}
            >
              {subject.name}
              <span
                aria-hidden="true"
                className="rounded-full bg-nexus-sunken px-2 py-0.5 text-xs font-medium text-muted-foreground"
              >
                {subject.topicCount} topic{subject.topicCount === 1 ? "" : "s"}
              </span>
            </button>
          );
        })}
      </div>

      {activeSubject ? (
        <>
          <SectionCard
            title={activeSubject.name}
            description="Work through topics in order or jump to what you need today."
          >
            <div className="flex flex-col items-start gap-4 sm:flex-row sm:items-center">
              <ProgressRing
                value={aggregateMastery}
                max={100}
                label="Overall"
                size={104}
              />
              <div>
                <p className="font-heading text-lg font-semibold text-foreground">
                  {activeTopics.length} topics ready
                </p>
                <p className="mt-1 text-sm text-muted-foreground">
                  Mastery updates as you complete lessons, practice, and checkpoints.
                </p>
              </div>
            </div>
          </SectionCard>

          {activeTopics.length === 0 ? (
            <EmptyState
              title="Topics coming soon"
              description={`${activeSubject.name} topics for your grade are being prepared. Try practice or ask Nex while we finish publishing content.`}
              primaryAction={{ label: "Start practice", href: "/practice" }}
              secondaryAction={{ label: "Ask Nex", href: "/nex" }}
            />
          ) : (
            <div className="grid gap-4 nexus-enter-stagger sm:grid-cols-2">
              {activeTopics.map((topic) => (
                <TopicCard
                  key={topic.id}
                  topic={topic}
                  masteryPercentage={topicMasteryById[topic.id] ?? 0}
                />
              ))}
            </div>
          )}
        </>
      ) : null}
    </div>
  );
}
