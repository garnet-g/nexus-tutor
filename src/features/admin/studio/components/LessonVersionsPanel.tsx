"use client";

import { useEffect, useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import {
  fetchLessonVersions,
  restoreLessonVersion,
  type LessonVersionSummary,
} from "@/features/admin/studio/lib/contentReviewApi";
import type { LessonContentBlock } from "@/types/curriculum";

import { lessonContentToBlocks } from "@/features/admin/studio/lib/lessonBlockStudio";

interface LessonVersionsPanelProps {
  lessonId: string;
  reviewStatus: "draft" | "in_review";
  onRestored: (input: {
    title: string;
    estimatedMinutes: number;
    blocks: LessonContentBlock[];
  }) => void;
}

export function LessonVersionsPanel({
  lessonId,
  reviewStatus,
  onRestored,
}: LessonVersionsPanelProps) {
  const [versions, setVersions] = useState<LessonVersionSummary[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isRestoring, setIsRestoring] = useState<string | null>(null);

  useEffect(() => {
    let cancelled = false;

    async function load() {
      setIsLoading(true);
      try {
        const data = await fetchLessonVersions(lessonId);
        if (!cancelled) {
          setVersions(data);
        }
      } catch {
        if (!cancelled) {
          setVersions([]);
        }
      } finally {
        if (!cancelled) {
          setIsLoading(false);
        }
      }
    }

    void load();

    return () => {
      cancelled = true;
    };
  }, [lessonId]);

  async function handleRestore(versionId: string) {
    if (reviewStatus !== "draft") {
      toastError("Restore unavailable", "Only draft lessons can be restored.");
      return;
    }

    setIsRestoring(versionId);
    try {
      const restored = await restoreLessonVersion({ lessonId, versionId });
      onRestored({
        title: restored.title,
        estimatedMinutes: restored.estimatedMinutes,
        blocks: lessonContentToBlocks(restored.content),
      });
      toastSuccess("Version restored", "Draft content was replaced with the selected version.");
    } catch (error) {
      toastError(
        "Could not restore version",
        error instanceof Error ? error.message : "Try again.",
      );
    } finally {
      setIsRestoring(null);
    }
  }

  if (isLoading) {
    return (
      <Panel title="Published versions">
        <p className="text-sm text-muted-foreground">Loading version history…</p>
      </Panel>
    );
  }

  if (versions.length === 0) {
    return null;
  }

  return (
    <Panel title="Published versions">
      <ul className="divide-y divide-nexus-border">
        {versions.map((version) => (
          <li key={version.id} className="flex flex-wrap items-center justify-between gap-3 py-3">
            <div className="text-sm">
              <p className="font-medium text-foreground">
                v{version.versionNumber} · {version.title}
              </p>
              <p className="text-muted-foreground">
                {new Date(version.createdAt).toLocaleString()} · {version.estimatedMinutes} min
              </p>
            </div>
            <Button
              type="button"
              variant="outline"
              size="sm"
              disabled={reviewStatus !== "draft" || isRestoring === version.id}
              onClick={() => void handleRestore(version.id)}
            >
              {isRestoring === version.id ? "Restoring…" : "Restore to draft"}
            </Button>
          </li>
        ))}
      </ul>
    </Panel>
  );
}
