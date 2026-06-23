"use client";

import Link from "next/link";
import { useMemo, useState } from "react";

import type { ContentReviewQueueItem } from "@/types/contentAdmin";
import type { LessonContent } from "@/types/curriculum";

import { Button } from "@/components/ui/Button";
import { DataTable, type Column } from "@/features/admin/components/DataTable";
import { useConfirm } from "@/features/admin/components/ConfirmDialog";
import { Field, Input } from "@/features/admin/components/adminForm";
import { EmptyState, PageHeader, Panel } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import {
  approveReviewItem,
  archiveReviewItem,
  fetchReviewLessonPreview,
  requestReviewChanges,
} from "@/features/admin/studio/lib/contentReviewApi";
import { LessonContentBlocks } from "@/features/learn/components/LessonContentBlocks";

interface ContentReviewQueuePanelProps {
  initialQueue: ContentReviewQueueItem[];
}

export function ContentReviewQueuePanel({ initialQueue }: ContentReviewQueuePanelProps) {
  const { confirm, dialog } = useConfirm();
  const [queue, setQueue] = useState(initialQueue);
  const [selectedId, setSelectedId] = useState<string | null>(
    initialQueue[0]?.id ?? null,
  );
  const [changeNotes, setChangeNotes] = useState("");
  const [lessonPreview, setLessonPreview] = useState<{
    title: string;
    content: LessonContent;
    estimatedMinutes: number;
    curriculumCode: string;
    topicTitle: string;
    subtopicTitle: string;
    topicId: string;
  } | null>(null);
  const [isLoadingPreview, setIsLoadingPreview] = useState(false);
  const [isActing, setIsActing] = useState(false);

  const selectedItem = useMemo(
    () => queue.find((item) => item.id === selectedId) ?? null,
    [queue, selectedId],
  );

  async function loadLessonPreview(lessonId: string) {
    setIsLoadingPreview(true);
    try {
      const preview = await fetchReviewLessonPreview(lessonId);
      setLessonPreview({
        title: preview.title,
        content: preview.content,
        estimatedMinutes: preview.estimatedMinutes,
        curriculumCode: preview.curriculumCode,
        topicTitle: preview.topicTitle,
        subtopicTitle: preview.subtopicTitle,
        topicId: preview.topicId,
      });
    } catch (error) {
      setLessonPreview(null);
      toastError(
        "Could not load preview",
        error instanceof Error ? error.message : "Try again.",
      );
    } finally {
      setIsLoadingPreview(false);
    }
  }

  function handleSelect(item: ContentReviewQueueItem) {
    setSelectedId(item.id);
    setChangeNotes("");
    setLessonPreview(null);

    if (item.kind === "lesson") {
      void loadLessonPreview(item.id);
    }
  }

  function removeFromQueue(id: string) {
    setQueue((current) => current.filter((item) => item.id !== id));
    setSelectedId((current) => (current === id ? null : current));
    setLessonPreview(null);
  }

  async function handleApprove(item: ContentReviewQueueItem) {
    const approved = await confirm({
      title: "Approve and publish?",
      description: `This will publish the ${item.kind} and make it visible to students.`,
      confirmLabel: "Approve",
    });

    if (!approved) {
      return;
    }

    setIsActing(true);
    try {
      await approveReviewItem({ kind: item.kind, id: item.id });
      removeFromQueue(item.id);
      toastSuccess("Published", "Content is now live for students.");
    } catch (error) {
      toastError(
        "Could not approve",
        error instanceof Error ? error.message : "Try again.",
      );
    } finally {
      setIsActing(false);
    }
  }

  async function handleRequestChanges(item: ContentReviewQueueItem) {
    setIsActing(true);
    try {
      await requestReviewChanges({
        kind: item.kind,
        id: item.id,
        notes: changeNotes.trim() || undefined,
      });
      removeFromQueue(item.id);
      toastSuccess("Returned to draft", "The author can edit and resubmit.");
    } catch (error) {
      toastError(
        "Could not return to draft",
        error instanceof Error ? error.message : "Try again.",
      );
    } finally {
      setIsActing(false);
    }
  }

  async function handleArchive(item: ContentReviewQueueItem) {
    const archived = await confirm({
      title: "Archive this item?",
      description: "It will be removed from the review queue and hidden from students.",
      confirmLabel: "Archive",
      destructive: true,
    });

    if (!archived) {
      return;
    }

    setIsActing(true);
    try {
      await archiveReviewItem({ kind: item.kind, id: item.id });
      removeFromQueue(item.id);
      toastSuccess("Archived", "Content was archived.");
    } catch (error) {
      toastError(
        "Could not archive",
        error instanceof Error ? error.message : "Try again.",
      );
    } finally {
      setIsActing(false);
    }
  }

  const columns: Column<ContentReviewQueueItem>[] = [
    {
      key: "kind",
      header: "Type",
      render: (item) => (item.kind === "lesson" ? "Lesson" : "Question"),
    },
    {
      key: "title",
      header: "Title",
      render: (item) =>
        item.kind === "lesson"
          ? item.title
          : item.questionText.slice(0, 80) + (item.questionText.length > 80 ? "…" : ""),
    },
    {
      key: "curriculum",
      header: "Curriculum",
      render: (item) => item.curriculumCode,
    },
    {
      key: "topic",
      header: "Topic",
      render: (item) => item.topicTitle,
    },
    {
      key: "submitted",
      header: "Submitted",
      render: (item) =>
        item.submittedAt ? new Date(item.submittedAt).toLocaleString() : "—",
    },
    {
      key: "review",
      header: "",
      render: (item) => (
        <Button type="button" variant="outline" size="sm" onClick={() => handleSelect(item)}>
          Review
        </Button>
      ),
    },
  ];

  return (
    <div className="space-y-6">
      {dialog}

      <PageHeader
        eyebrow="Authoring Studio"
        title="Review queue"
        description="Approve content before it goes live, or return it to draft with notes."
        actions={
          <Button variant="outline" render={<Link href="/admin/studio" />}>
            Back to workspace
          </Button>
        }
      />

      <div className="grid gap-6 xl:grid-cols-[minmax(0,1.2fr)_minmax(0,1fr)]">
        <Panel title={`Pending review (${queue.length})`} padded={queue.length === 0}>
          {queue.length === 0 ? (
            <EmptyState title="Nothing in review" description="Submitted drafts will appear here." />
          ) : (
            <DataTable
              columns={columns}
              rows={queue}
              getRowKey={(item) => item.id}
              rowClassName="cursor-pointer"
              emptyMessage="No items awaiting review."
            />
          )}
        </Panel>

        <Panel title="Preview & actions" padded={!selectedItem}>
          {!selectedItem ? (
            <EmptyState title="Select an item" description="Choose a row to preview and review." />
          ) : (
            <div className="space-y-5">
              <div className="space-y-1 text-sm">
                <p className="font-medium text-foreground">
                  {selectedItem.kind === "lesson"
                    ? selectedItem.title
                    : selectedItem.questionText}
                </p>
                <p className="text-muted-foreground">
                  {selectedItem.curriculumCode} · {selectedItem.topicTitle}
                  {selectedItem.subtopicTitle ? ` · ${selectedItem.subtopicTitle}` : ""}
                </p>
                {selectedItem.reviewNotes ? (
                  <p className="text-amber-700">Prior notes: {selectedItem.reviewNotes}</p>
                ) : null}
              </div>

              {selectedItem.kind === "lesson" ? (
                isLoadingPreview ? (
                  <p className="text-sm text-muted-foreground">Loading lesson preview…</p>
                ) : lessonPreview ? (
                  <div className="max-h-[420px] overflow-y-auto rounded-xl border border-nexus-border bg-background p-4">
                    <LessonContentBlocks
                      blocks={lessonPreview.content.blocks}
                      topicId={lessonPreview.topicId}
                    />
                  </div>
                ) : (
                  <p className="text-sm text-muted-foreground">No preview loaded.</p>
                )
              ) : (
                <div className="space-y-3 rounded-xl border border-nexus-border bg-background p-4 text-sm">
                  <p>
                    <span className="font-medium">Type:</span> {selectedItem.questionType}
                  </p>
                  <p>
                    <span className="font-medium">Difficulty:</span> {selectedItem.difficulty}
                  </p>
                  {selectedItem.options?.length ? (
                    <ul className="list-disc space-y-1 pl-5">
                      {selectedItem.options.map((option) => (
                        <li
                          key={option}
                          className={
                            option === selectedItem.correctAnswer
                              ? "font-medium text-emerald-700"
                              : undefined
                          }
                        >
                          {option}
                          {option === selectedItem.correctAnswer ? " (correct)" : ""}
                        </li>
                      ))}
                    </ul>
                  ) : (
                    <p>
                      <span className="font-medium">Answer:</span> {selectedItem.correctAnswer}
                    </p>
                  )}
                  {selectedItem.explanation ? (
                    <p>
                      <span className="font-medium">Explanation:</span> {selectedItem.explanation}
                    </p>
                  ) : null}
                </div>
              )}

              <Field label="Request-changes notes (optional)" htmlFor="review-notes">
                <Input
                  id="review-notes"
                  value={changeNotes}
                  onChange={(event) => setChangeNotes(event.target.value)}
                  placeholder="What should the author fix?"
                />
              </Field>

              <div className="flex flex-wrap gap-2">
                <Button
                  type="button"
                  onClick={() => void handleApprove(selectedItem)}
                  disabled={isActing}
                >
                  Approve & publish
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => void handleRequestChanges(selectedItem)}
                  disabled={isActing}
                >
                  Request changes
                </Button>
                <Button
                  type="button"
                  variant="outline"
                  onClick={() => void handleArchive(selectedItem)}
                  disabled={isActing}
                >
                  Archive
                </Button>
              </div>
            </div>
          )}
        </Panel>
      </div>
    </div>
  );
}
