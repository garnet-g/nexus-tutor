"use client";

import Link from "next/link";
import { useMemo, useState } from "react";

import type { LessonContentBlock } from "@/types/curriculum";

import { Field, Input } from "@/features/admin/components/adminForm";
import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import { LessonBlockListEditor } from "@/features/admin/studio/components/LessonBlockListEditor";
import {
  blocksToLessonContent,
  lessonContentToBlocks,
  serializeStudioBlocks,
} from "@/features/admin/studio/lib/lessonBlockStudio";
import { saveStudioLesson, type StudioLessonDetail } from "@/features/admin/studio/lib/studioApi";
import { LessonContentBlocks } from "@/features/learn/components/LessonContentBlocks";
import { lessonContentSchema } from "@/schemas/lessonContentSchemas";
import { Button } from "@/components/ui/Button";

interface LessonStudioShellProps {
  initialLesson: StudioLessonDetail;
}

export function LessonStudioShell({ initialLesson }: LessonStudioShellProps) {
  const [lesson, setLesson] = useState(initialLesson);
  const [title, setTitle] = useState(initialLesson.title);
  const [estimatedMinutes, setEstimatedMinutes] = useState(initialLesson.estimatedMinutes);
  const [blocks, setBlocks] = useState<LessonContentBlock[]>(() =>
    lessonContentToBlocks(initialLesson.content),
  );
  const [showPreview, setShowPreview] = useState(false);
  const [isSaving, setIsSaving] = useState(false);

  const previewContent = useMemo(
    () => blocksToLessonContent(blocks, lesson.content.shortQuiz),
    [blocks, lesson.content.shortQuiz],
  );

  async function handleSave() {
    setIsSaving(true);
    try {
      const serializedBlocks = serializeStudioBlocks(blocks);
      lessonContentSchema.parse({
        blocks: serializedBlocks,
        shortQuiz: lesson.content.shortQuiz,
      });

      const saved = await saveStudioLesson({
        id: lesson.id,
        title: title.trim(),
        estimatedMinutes,
        blocks: serializedBlocks,
        shortQuiz: lesson.content.shortQuiz,
      });

      setLesson(saved);
      setTitle(saved.title);
      setEstimatedMinutes(saved.estimatedMinutes);
      setBlocks(lessonContentToBlocks(saved.content));
      toastSuccess("Draft saved", "Lesson content is stored as a draft.");
    } catch (error) {
      toastError(
        "Could not save lesson",
        error instanceof Error ? error.message : "Check block fields and try again.",
      );
    } finally {
      setIsSaving(false);
    }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Authoring Studio"
        title={title || "Untitled lesson"}
        description={
          <>
            {lesson.curriculumCode} · {lesson.topicTitle} · {lesson.subtopicTitle}
          </>
        }
        actions={
          <div className="flex flex-wrap gap-2">
            <Button
              type="button"
              variant="outline"
              onClick={() => setShowPreview((current) => !current)}
            >
              {showPreview ? "Hide preview" : "Student preview"}
            </Button>
            <Button type="button" onClick={() => void handleSave()} disabled={isSaving}>
              {isSaving ? "Saving…" : "Save draft"}
            </Button>
            <Button variant="outline" render={<Link href="/admin/content" />}>
              Back to content
            </Button>
          </div>
        }
      />

      <div className={showPreview ? "grid gap-6 xl:grid-cols-2" : undefined}>
        <div className="space-y-6">
          <Panel title="Lesson details">
            <div className="grid gap-4 sm:grid-cols-2">
              <Field label="Title" htmlFor="studio-title">
                <Input
                  id="studio-title"
                  value={title}
                  onChange={(event) => setTitle(event.target.value)}
                />
              </Field>
              <Field label="Estimated minutes" htmlFor="studio-minutes">
                <Input
                  id="studio-minutes"
                  type="number"
                  min={5}
                  max={60}
                  value={estimatedMinutes}
                  onChange={(event) => setEstimatedMinutes(Number(event.target.value))}
                />
              </Field>
            </div>
          </Panel>

          <Panel
            title="Lesson blocks"
            description="Build the lesson block by block. Drag cards to reorder, or use Insert block / slash search."
          >
            <LessonBlockListEditor blocks={blocks} onChange={setBlocks} />
          </Panel>
        </div>

        {showPreview ? (
          <Panel title="Student preview" description="Rendered with the same pipeline students see.">
            <div className="max-w-[66ch] space-y-6">
              <header className="space-y-1">
                <p className="text-sm text-muted-foreground">
                  {lesson.topicTitle} · {lesson.subtopicTitle}
                </p>
                <h2 className="font-heading text-2xl font-semibold text-foreground">{title}</h2>
              </header>
              <LessonContentBlocks blocks={previewContent.blocks} topicId={lesson.topicId} />
            </div>
          </Panel>
        ) : null}
      </div>
    </div>
  );
}
