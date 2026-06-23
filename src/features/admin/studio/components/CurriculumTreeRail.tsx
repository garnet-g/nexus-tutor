"use client";

import Link from "next/link";
import { useMemo, useState } from "react";

import type {
  ContentCoverageCurriculum,
  ContentCoverageSubject,
  ContentCoverageTopic,
} from "@/types/contentAdmin";

import { StatusBadge } from "@/features/admin/components/adminUi";
import { cn } from "@/lib/utils";
import { QUESTION_COVERAGE_TARGET } from "@/types/contentAdmin";

export type StudioTreeSelection =
  | {
      kind: "topic";
      subjectCode: string;
      subjectName: string;
      curriculumCode: ContentCoverageCurriculum["code"];
      topic: ContentCoverageTopic;
    }
  | {
      kind: "subtopic";
      subjectCode: string;
      subjectName: string;
      curriculumCode: ContentCoverageCurriculum["code"];
      topic: ContentCoverageTopic;
      subtopicId: string;
      subtopicTitle: string;
    };

interface CurriculumTreeRailProps {
  subjects: ContentCoverageSubject[];
  selection: StudioTreeSelection | null;
  onSelect: (selection: StudioTreeSelection) => void;
}

function readinessTone(label: ContentCoverageTopic["readinessLabel"]) {
  switch (label) {
    case "PROD_READY":
      return "success" as const;
    case "PRACTICE_READY":
    case "LEARN_READY":
      return "info" as const;
    default:
      return "warning" as const;
  }
}

export function CurriculumTreeRail({ subjects, selection, onSelect }: CurriculumTreeRailProps) {
  const [expandedSubjects, setExpandedSubjects] = useState<Record<string, boolean>>(() =>
    Object.fromEntries(subjects.map((subject) => [subject.code, true])),
  );
  const [expandedTopics, setExpandedTopics] = useState<Record<string, boolean>>({});

  const selectedKey = useMemo(() => {
    if (!selection) {
      return null;
    }

    if (selection.kind === "topic") {
      return `topic:${selection.topic.id}`;
    }

    return `subtopic:${selection.subtopicId}`;
  }, [selection]);

  return (
    <aside className="space-y-3">
      <p className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">
        Curriculum
      </p>
      <div className="space-y-2">
        {subjects.map((subject) => {
          const subjectOpen = expandedSubjects[subject.code] ?? true;

          return (
            <div key={subject.code} className="rounded-xl border border-nexus-border bg-nexus-sunken/40">
              <button
                type="button"
                className="flex w-full items-center justify-between px-3 py-2 text-left text-sm font-medium text-foreground"
                onClick={() =>
                  setExpandedSubjects((current) => ({
                    ...current,
                    [subject.code]: !subjectOpen,
                  }))
                }
              >
                <span>{subject.name}</span>
                <span className="text-xs text-muted-foreground">{subjectOpen ? "−" : "+"}</span>
              </button>

              {subjectOpen ? (
                <div className="space-y-2 border-t border-nexus-border px-2 py-2">
                  {subject.curricula.map((curriculum) => (
                    <div key={`${subject.code}-${curriculum.code}`} className="space-y-1">
                      <p className="px-2 text-xs font-medium text-muted-foreground">
                        {curriculum.code}
                      </p>
                      {curriculum.topics.map((topic) => {
                        const topicOpen = expandedTopics[topic.id] ?? false;
                        const topicSelected = selectedKey === `topic:${topic.id}`;

                        return (
                          <div key={topic.id} className="space-y-1">
                            <div className="flex items-center gap-1">
                              <button
                                type="button"
                                className="px-1 text-xs text-muted-foreground"
                                onClick={() =>
                                  setExpandedTopics((current) => ({
                                    ...current,
                                    [topic.id]: !topicOpen,
                                  }))
                                }
                              >
                                {topicOpen ? "▾" : "▸"}
                              </button>
                              <button
                                type="button"
                                className={cn(
                                  "min-w-0 flex-1 rounded-lg px-2 py-1.5 text-left text-sm",
                                  topicSelected
                                    ? "bg-primary/15 text-foreground"
                                    : "text-muted-foreground hover:bg-nexus-surface hover:text-foreground",
                                )}
                                onClick={() =>
                                  onSelect({
                                    kind: "topic",
                                    subjectCode: subject.code,
                                    subjectName: subject.name,
                                    curriculumCode: curriculum.code,
                                    topic,
                                  })
                                }
                              >
                                <span className="block truncate">{topic.title}</span>
                                <span className="mt-1 flex flex-wrap gap-1">
                                  <StatusBadge tone={readinessTone(topic.readinessLabel)}>
                                    {topic.readinessLabel.replaceAll("_", " ").toLowerCase()}
                                  </StatusBadge>
                                  <StatusBadge tone="neutral">
                                    {topic.questionCounts.easy +
                                      topic.questionCounts.medium +
                                      topic.questionCounts.hard}
                                    /{QUESTION_COVERAGE_TARGET} questions
                                  </StatusBadge>
                                </span>
                              </button>
                            </div>

                            {topicOpen ? (
                              <div className="ml-5 space-y-1">
                                {topic.subtopics.map((subtopic) => {
                                  const subtopicSelected =
                                    selectedKey === `subtopic:${subtopic.id}`;

                                  return (
                                    <button
                                      key={subtopic.id}
                                      type="button"
                                      className={cn(
                                        "w-full rounded-lg px-2 py-1.5 text-left text-sm",
                                        subtopicSelected
                                          ? "bg-primary/15 text-foreground"
                                          : "text-muted-foreground hover:bg-nexus-surface hover:text-foreground",
                                      )}
                                      onClick={() =>
                                        onSelect({
                                          kind: "subtopic",
                                          subjectCode: subject.code,
                                          subjectName: subject.name,
                                          curriculumCode: curriculum.code,
                                          topic,
                                          subtopicId: subtopic.id,
                                          subtopicTitle: subtopic.title,
                                        })
                                      }
                                    >
                                      <span className="block truncate">{subtopic.title}</span>
                                      <span className="mt-1 flex flex-wrap gap-1">
                                        {subtopic.publishedLessonCount > 0 ? (
                                          <StatusBadge tone="success">
                                            {subtopic.publishedLessonCount} published
                                          </StatusBadge>
                                        ) : null}
                                        {subtopic.draftLessonCount > 0 ? (
                                          <StatusBadge tone="warning">
                                            {subtopic.draftLessonCount} draft
                                          </StatusBadge>
                                        ) : null}
                                      </span>
                                    </button>
                                  );
                                })}
                              </div>
                            ) : null}
                          </div>
                        );
                      })}
                    </div>
                  ))}
                </div>
              ) : null}
            </div>
          );
        })}
      </div>

      <Link
        href="/admin/studio/new"
        className="inline-flex text-sm font-medium text-nexus-primary hover:underline"
      >
        New lesson (pick subtopic)
      </Link>
    </aside>
  );
}
