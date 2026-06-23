"use client";

import Link from "next/link";
import { useMemo, useState } from "react";

import type { LessonContentBlock } from "@/types/curriculum";
import type { Curriculum } from "@/types/database";

import { Field, Input } from "@/features/admin/components/adminForm";
import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import { LessonBlockListEditor } from "@/features/admin/studio/components/LessonBlockListEditor";
import { LessonVersionsPanel } from "@/features/admin/studio/components/LessonVersionsPanel";
import { StudioAiAssistPanel } from "@/features/admin/studio/components/StudioAiAssistPanel";
import { submitContentForReview } from "@/features/admin/studio/lib/contentReviewApi";
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
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [selectedBlockId, setSelectedBlockId] = useState<string | null>(null);

  const isEditable = lesson.reviewStatus === "draft";

  const previewContent = useMemo(
    () => blocksToLessonContent(blocks, lesson.content.shortQuiz),
    [blocks, lesson.content.shortQuiz],
  );

  async function persistDraft(): Promise<StudioLessonDetail> {
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
    return saved;
  }

  async function handleSave() {
    if (!isEditable) {
      return;
    }

    setIsSaving(true);
    try {
      await persistDraft();
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

  async function handleSubmitForReview() {
    if (!isEditable) {
      return;
    }

    setIsSubmitting(true);
    try {
      await persistDraft();
      const result = await submitContentForReview({ kind: "lesson", id: lesson.id });

      if (result.reviewStatus === "published") {
        toastSuccess("Published", "Auto-approve passed quality gates and published the lesson.");
      } else {
        toastSuccess("Submitted for review", "An admin can approve it from the review queue.");
        setLesson((current) => ({ ...current, reviewStatus: "in_review" }));
      }
    } catch (error) {
      toastError(
        "Could not submit",
        error instanceof Error ? error.message : "Fix quality gate issues and try again.",
      );
    } finally {
      setIsSubmitting(false);
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
            {lesson.reviewStatus === "in_review" ? (
              <span className="mt-1 block text-amber-700">
                In review — editing is locked until changes are requested.
              </span>
            ) : null}
            {lesson.reviewNotes ? (
              <span className="mt-1 block text-amber-700">Reviewer notes: {lesson.reviewNotes}</span>
            ) : null}
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
            {isEditable ? (
              <>
                <Button
                  type="button"
                  onClick={() => void handleSave()}
                  disabled={isSaving || isSubmitting}
                >
                  {isSaving ? "Saving…" : "Save draft"}
                </Button>
                <Button
                  type="button"
                  onClick={() => void handleSubmitForReview()}
                  disabled={isSaving || isSubmitting}
                >
                  {isSubmitting ? "Submitting…" : "Submit for review"}
                </Button>
              </>
            ) : null}
            <Button variant="outline" render={<Link href="/admin/studio/review" />}>
              Review queue
            </Button>
            <Button variant="outline" render={<Link href="/admin/studio" />}>
              Workspace
            </Button>
          </div>
        }
      />

      <LessonVersionsPanel
        lessonId={lesson.id}
        reviewStatus={lesson.reviewStatus}
        onRestored={({ title: restoredTitle, estimatedMinutes: restoredMinutes, blocks: restoredBlocks }) => {
          setTitle(restoredTitle);
          setEstimatedMinutes(restoredMinutes);
          setBlocks(restoredBlocks);
        }}
      />

      <div className={showPreview ? "grid gap-6 xl:grid-cols-[minmax(0,1fr)_280px]" : "grid gap-6 lg:grid-cols-[minmax(0,1fr)_280px]"}>
        <div className="space-y-6 min-w-0">
          <Panel title="Lesson details">
            <div className="grid gap-4 sm:grid-cols-2">
              <Field label="Title" htmlFor="studio-title">
                <Input
                  id="studio-title"
                  value={title}
                  onChange={(event) => setTitle(event.target.value)}
                  disabled={!isEditable}
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
                  disabled={!isEditable}
                />
              </Field>
            </div>
          </Panel>

          <Panel
            title="Lesson blocks"
            description={
              isEditable
                ? "Build the lesson block by block. Drag cards to reorder, or use Insert block / slash search."
                : "Read-only while this lesson is in review."
            }
          >
            {isEditable ? (
              <LessonBlockListEditor
                blocks={blocks}
                onChange={setBlocks}
                selectedBlockId={selectedBlockId}
                onSelectBlock={setSelectedBlockId}
              />
            ) : (
              <LessonContentBlocks blocks={previewContent.blocks} topicId={lesson.topicId} />
            )}
          </Panel>

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

        <div className="space-y-6">
          {isEditable ? (
            <StudioAiAssistPanel
              subtopicId={lesson.subtopicId}
              curriculumCode={lesson.curriculumCode as Curriculum}
              blocks={blocks}
              selectedBlockId={selectedBlockId}
              disabled={!isEditable}
              onApplyDraft={({ title: draftTitle, estimatedMinutes: draftMinutes, blocks: draftBlocks }) => {
                setTitle(draftTitle);
                setEstimatedMinutes(draftMinutes);
                setBlocks(draftBlocks);
              }}
              onApplyBlocks={setBlocks}
              onReplaceBlock={(blockId, block) => {
                setBlocks((current) =>
                  current.map((entry) => (entry.id === blockId ? block : entry)),
                );
              }}
              onInsertAfterBlock={(blockId, insertedBlocks) => {
                setBlocks((current) => {
                  const index = current.findIndex((entry) => entry.id === blockId);
                  if (index < 0) {
                    return [...current, ...insertedBlocks];
                  }
                  const next = [...current];
                  next.splice(index + 1, 0, ...insertedBlocks);
                  return next;
                });
              }}
            />
          ) : null}
        </div>
      </div>
    </div>
  );
}
