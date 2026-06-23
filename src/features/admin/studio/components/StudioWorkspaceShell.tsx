"use client";

import Link from "next/link";
import { useState } from "react";

import type { ContentCoverageSubject } from "@/types/contentAdmin";

import { Button } from "@/components/ui/Button";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  CurriculumTreeRail,
  type StudioTreeSelection,
} from "@/features/admin/studio/components/CurriculumTreeRail";
import { SubtopicLessonsPanel } from "@/features/admin/studio/components/SubtopicLessonsPanel";
import { TopicQuestionBankPanel } from "@/features/admin/studio/components/TopicQuestionBankPanel";

interface StudioWorkspaceShellProps {
  subjects: ContentCoverageSubject[];
}

export function StudioWorkspaceShell({ subjects }: StudioWorkspaceShellProps) {
  const [selection, setSelection] = useState<StudioTreeSelection | null>(null);

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Authoring Studio"
        title="Curriculum workspace"
        description="Browse the full curriculum tree, manage subtopic lessons, and edit topic question banks by hand."
        actions={
          <Button variant="outline" render={<Link href="/admin/studio/review" />}>
            Review queue
          </Button>
        }
      />

      <div className="grid gap-6 lg:grid-cols-[280px_minmax(0,1fr)]">
        <CurriculumTreeRail
          subjects={subjects}
          selection={selection}
          onSelect={setSelection}
        />

        <div className="min-w-0">
          {!selection ? (
            <p className="rounded-2xl border border-dashed border-nexus-border bg-nexus-sunken/30 px-5 py-10 text-sm text-muted-foreground">
              Select a topic to manage its question bank, or a subtopic to manage lessons.
            </p>
          ) : selection.kind === "topic" ? (
            <TopicQuestionBankPanel
              key={selection.topic.id}
              topicId={selection.topic.id}
              topicTitle={selection.topic.title}
            />
          ) : (
            <SubtopicLessonsPanel
              key={selection.subtopicId}
              subtopicId={selection.subtopicId}
              subtopicTitle={selection.subtopicTitle}
              topicTitle={selection.topic.title}
            />
          )}
        </div>
      </div>
    </div>
  );
}
