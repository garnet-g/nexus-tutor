"use client";

import { useMemo, useState } from "react";
import { Lock } from "lucide-react";

import { EmptyState } from "@/components/ui/EmptyState";
import { SectionCard } from "@/components/ui/SectionCard";
import { ProgressRing } from "@/components/widgets/Charts";
import { TopicCard } from "@/features/learn/components/TopicCard";
import { averageMastery } from "@/lib/learn/masteryStatus";
import type { CurriculumSubject, CurriculumTopic } from "@/types/curriculum";
import { cn } from "@/lib/utils";

// SCOPE-FLAG: Science and English subjects exist in Tier 1 seeds but remain inactive in V1 per scope lock §3.
const V1_ACTIVE_SUBJECT_CODE = "mathematics";

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
        if (a.code === V1_ACTIVE_SUBJECT_CODE) return -1;
        if (b.code === V1_ACTIVE_SUBJECT_CODE) return 1;
        return a.name.localeCompare(b.name);
      }),
    [subjects],
  );

  const [activeSubjectCode, setActiveSubjectCode] = useState(
    sortedSubjects.find((subject) => subject.code === V1_ACTIVE_SUBJECT_CODE)
      ?.code ?? sortedSubjects[0]?.code ?? V1_ACTIVE_SUBJECT_CODE,
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
          const isActiveSubject = subject.code === V1_ACTIVE_SUBJECT_CODE;
          const isSelected = subject.code === activeSubjectCode;

          return (
            <button
              key={subject.id}
              type="button"
              disabled={!isActiveSubject}
              onClick={() => {
                if (isActiveSubject) {
                  setActiveSubjectCode(subject.code);
                }
              }}
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

      {activeSubject?.code === V1_ACTIVE_SUBJECT_CODE ? (
        <>
          <SectionCard
            title={activeSubject.name}
            description="Your active V1 subject. Work through topics in order or jump to what you need today."
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
              description="Mathematics topics for your grade are being prepared. Try practice or ask Nex while we finish seeding content."
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
