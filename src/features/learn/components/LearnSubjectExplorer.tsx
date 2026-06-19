"use client";

import { useMemo, useState } from "react";

import { SubjectTree } from "@/features/learn/components/SubjectTree";
import type { CurriculumSubject, CurriculumTopic } from "@/types/curriculum";
import { cn } from "@/lib/utils";

interface LearnSubjectExplorerProps {
  subjects: CurriculumSubject[];
  topicsBySubjectId: Record<string, CurriculumTopic[]>;
}

export function LearnSubjectExplorer({
  subjects,
  topicsBySubjectId,
}: LearnSubjectExplorerProps) {
  const [activeSubjectCode, setActiveSubjectCode] = useState(
    subjects[0]?.code ?? "mathematics",
  );

  const visibleSubjects = useMemo(
    () => subjects.filter((subject) => subject.code === activeSubjectCode),
    [activeSubjectCode, subjects],
  );

  if (subjects.length === 0) {
    return <SubjectTree subjects={[]} topicsBySubjectId={{}} />;
  }

  return (
    <div className="space-y-4">
      <div className="flex flex-wrap gap-2">
        {subjects.map((subject) => (
          <button
            key={subject.id}
            type="button"
            onClick={() => setActiveSubjectCode(subject.code)}
            className={cn(
              "min-h-11 rounded-full px-4 py-2 text-sm font-medium transition",
              subject.code === activeSubjectCode
                ? "bg-primary text-primary-foreground"
                : "border border-border bg-card text-foreground/80 hover:border-border",
            )}
          >
            {subject.name}
          </button>
        ))}
      </div>

      <SubjectTree subjects={visibleSubjects} topicsBySubjectId={topicsBySubjectId} />
    </div>
  );
}
