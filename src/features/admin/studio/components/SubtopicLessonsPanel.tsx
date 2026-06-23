"use client";

import Link from "next/link";
import { useEffect, useState } from "react";

import { DataTable, type Column } from "@/features/admin/components/DataTable";
import { EmptyState, Panel, StatusBadge } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import {
  fetchSubtopicLessons,
  reorderSubtopicLessons,
  type SubtopicLessonsResponse,
} from "@/features/admin/studio/lib/studioWorkspaceApi";
import type { StudioLessonSummary, StudioReviewStatus } from "@/types/contentStudio";
import { Button } from "@/components/ui/Button";

interface SubtopicLessonsPanelProps {
  subtopicId: string;
  subtopicTitle: string;
  topicTitle: string;
}

function reviewTone(status: StudioReviewStatus) {
  switch (status) {
    case "published":
      return "success" as const;
    case "draft":
      return "warning" as const;
    default:
      return "neutral" as const;
  }
}

export function SubtopicLessonsPanel({
  subtopicId,
  subtopicTitle,
  topicTitle,
}: SubtopicLessonsPanelProps) {
  const [data, setData] = useState<SubtopicLessonsResponse | null>(null);
  const [lessons, setLessons] = useState<StudioLessonSummary[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSavingOrder, setIsSavingOrder] = useState(false);

  useEffect(() => {
    let active = true;

    fetchSubtopicLessons(subtopicId)
      .then((response) => {
        if (!active) {
          return;
        }
        setData(response);
        setLessons(response.lessons);
      })
      .catch((error: unknown) => {
        if (!active) {
          return;
        }
        toastError(
          "Could not load lessons",
          error instanceof Error ? error.message : undefined,
        );
      })
      .finally(() => {
        if (active) {
          setIsLoading(false);
        }
      });

    return () => {
      active = false;
    };
  }, [subtopicId]);

  async function moveLesson(lessonId: string, direction: -1 | 1) {
    const index = lessons.findIndex((lesson) => lesson.id === lessonId);
    const targetIndex = index + direction;
    if (index < 0 || targetIndex < 0 || targetIndex >= lessons.length) {
      return;
    }

    const next = [...lessons];
    const [moved] = next.splice(index, 1);
    next.splice(targetIndex, 0, moved);
    setLessons(next);

    setIsSavingOrder(true);
    try {
      await reorderSubtopicLessons(
        subtopicId,
        next.map((lesson) => lesson.id),
      );
      toastSuccess("Lesson order saved");
    } catch (error) {
      toastError(
        "Could not save order",
        error instanceof Error ? error.message : undefined,
      );
      setLessons(data?.lessons ?? []);
    } finally {
      setIsSavingOrder(false);
    }
  }

  const columns: Column<StudioLessonSummary>[] = [
    {
      key: "title",
      header: "Lesson",
      sortable: true,
      searchValue: (row) => row.title,
      render: (row) => (
        <div className="space-y-1">
          <p className="font-medium text-foreground">{row.title}</p>
          <p className="text-xs text-muted-foreground">{row.estimatedMinutes} min</p>
        </div>
      ),
    },
    {
      key: "status",
      header: "Status",
      render: (row) => (
        <StatusBadge tone={reviewTone(row.reviewStatus)}>{row.reviewStatus}</StatusBadge>
      ),
      searchValue: (row) => row.reviewStatus,
    },
    {
      key: "actions",
      header: "Actions",
      render: (row) => (
        <div className="flex flex-wrap gap-1">
          <Button
            type="button"
            size="sm"
            variant="outline"
            render={<Link href={`/admin/studio/${row.id}`} />}
          >
            Edit
          </Button>
          <Button
            type="button"
            size="sm"
            variant="outline"
            disabled={isSavingOrder}
            onClick={() => void moveLesson(row.id, -1)}
          >
            Up
          </Button>
          <Button
            type="button"
            size="sm"
            variant="outline"
            disabled={isSavingOrder}
            onClick={() => void moveLesson(row.id, 1)}
          >
            Down
          </Button>
        </div>
      ),
    },
  ];

  return (
    <Panel
      title={subtopicTitle}
      description={`${topicTitle} · ${data?.context.curriculumCode ?? ""} · reorder lessons or open the block editor.`}
      action={
        <Button
          size="sm"
          render={
            <Link
              href={`/admin/studio/new?subtopicId=${encodeURIComponent(subtopicId)}`}
            />
          }
        >
          New lesson
        </Button>
      }
    >
      {isLoading ? (
        <p className="text-sm text-muted-foreground">Loading lessons…</p>
      ) : lessons.length === 0 ? (
        <EmptyState
          title="No lessons yet"
          description="Create a manual draft lesson for this subtopic."
          action={
            <Button
              render={
                <Link
                  href={`/admin/studio/new?subtopicId=${encodeURIComponent(subtopicId)}`}
                />
              }
            >
              New lesson
            </Button>
          }
        />
      ) : (
        <DataTable
          columns={columns}
          rows={lessons}
          getRowKey={(row) => row.id}
          searchable
          searchPlaceholder="Search lessons…"
        />
      )}
    </Panel>
  );
}
