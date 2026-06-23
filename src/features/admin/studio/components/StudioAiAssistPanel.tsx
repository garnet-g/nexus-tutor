"use client";

import { useMemo, useState } from "react";

import type { LessonContentBlock } from "@/types/curriculum";
import type { Curriculum } from "@/types/database";
import { GRADE_LEVELS_BY_CURRICULUM } from "@/types/contentAdmin";

import { Field, Select } from "@/features/admin/components/adminForm";
import { Panel } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import { normalizeStudioBlocks } from "@/features/admin/studio/lib/lessonBlockStudio";
import {
  assistDraftLesson,
  assistExpandSection,
  assistRewriteBlock,
  assistSimplifyLesson,
} from "@/features/admin/studio/lib/studioAssistApi";
import { Button } from "@/components/ui/Button";

interface StudioAiAssistPanelProps {
  subtopicId: string;
  curriculumCode: Curriculum;
  blocks: LessonContentBlock[];
  selectedBlockId: string | null;
  disabled?: boolean;
  onApplyDraft: (input: {
    title: string;
    estimatedMinutes: number;
    blocks: LessonContentBlock[];
  }) => void;
  onApplyBlocks: (blocks: LessonContentBlock[]) => void;
  onReplaceBlock: (blockId: string, block: LessonContentBlock) => void;
  onInsertAfterBlock: (blockId: string, blocks: LessonContentBlock[]) => void;
}

export function StudioAiAssistPanel({
  subtopicId,
  curriculumCode,
  blocks,
  selectedBlockId,
  disabled = false,
  onApplyDraft,
  onApplyBlocks,
  onReplaceBlock,
  onInsertAfterBlock,
}: StudioAiAssistPanelProps) {
  const gradeOptions = GRADE_LEVELS_BY_CURRICULUM[curriculumCode];
  const [gradeLevel, setGradeLevel] = useState(gradeOptions[0] ?? "Form 1");
  const [simplifyGrade, setSimplifyGrade] = useState(gradeOptions[0] ?? "Form 1");
  const [rewriteInstruction, setRewriteInstruction] = useState("");
  const [busyAction, setBusyAction] = useState<string | null>(null);

  const selectedBlock = useMemo(
    () => blocks.find((block) => block.id === selectedBlockId) ?? null,
    [blocks, selectedBlockId],
  );

  async function runAction(action: string, task: () => Promise<void>) {
    setBusyAction(action);
    try {
      await task();
    } catch (error) {
      toastError(
        "AI assist failed",
        error instanceof Error ? error.message : "Try again or edit manually.",
      );
    } finally {
      setBusyAction(null);
    }
  }

  return (
    <Panel
      title="AI assist"
      description="Optional drafting help. Output lands as editable blocks — nothing publishes automatically."
    >
      <div className="space-y-4">
        <Field label="Target grade" htmlFor="assist-grade">
          <Select
            id="assist-grade"
            value={gradeLevel}
            onChange={(event) => setGradeLevel(event.target.value)}
            disabled={disabled || busyAction !== null}
          >
            {gradeOptions.map((grade) => (
              <option key={grade} value={grade}>
                {grade}
              </option>
            ))}
          </Select>
        </Field>

        <div className="flex flex-col gap-2">
          <Button
            type="button"
            variant="outline"
            disabled={disabled || busyAction !== null}
            onClick={() =>
              void runAction("draft", async () => {
                const draft = await assistDraftLesson({
                  subtopicId,
                  curriculum: curriculumCode,
                  gradeLevel,
                });
                onApplyDraft({
                  title: draft.title,
                  estimatedMinutes: draft.estimatedMinutes,
                  blocks: normalizeStudioBlocks(draft.blocks),
                });
                toastSuccess("Draft inserted", "Review and edit the generated blocks.");
              })
            }
          >
            {busyAction === "draft" ? "Drafting…" : "Draft this lesson"}
          </Button>

          <Button
            type="button"
            variant="outline"
            disabled={disabled || busyAction !== null || !selectedBlockId}
            onClick={() =>
              void runAction("expand", async () => {
                if (!selectedBlockId) {
                  return;
                }
                const expanded = await assistExpandSection({
                  subtopicId,
                  curriculum: curriculumCode,
                  gradeLevel,
                  blockId: selectedBlockId,
                  blocks: serializeStudioBlocksForAssist(blocks),
                });
                onInsertAfterBlock(
                  selectedBlockId,
                  normalizeStudioBlocks(expanded.blocks),
                );
                toastSuccess("Section expanded", "New blocks were added after the selected block.");
              })
            }
          >
            {busyAction === "expand" ? "Expanding…" : "Expand selected section"}
          </Button>

          <Field label="Simplify for grade" htmlFor="assist-simplify-grade">
            <Select
              id="assist-simplify-grade"
              value={simplifyGrade}
              onChange={(event) => setSimplifyGrade(event.target.value)}
              disabled={disabled || busyAction !== null}
            >
              {gradeOptions.map((grade) => (
                <option key={grade} value={grade}>
                  {grade}
                </option>
              ))}
            </Select>
          </Field>

          <Button
            type="button"
            variant="outline"
            disabled={disabled || busyAction !== null || blocks.length === 0}
            onClick={() =>
              void runAction("simplify", async () => {
                const simplified = await assistSimplifyLesson({
                  subtopicId,
                  curriculum: curriculumCode,
                  targetGradeLevel: simplifyGrade,
                  blocks: serializeStudioBlocksForAssist(blocks),
                });
                onApplyBlocks(normalizeStudioBlocks(simplified.blocks));
                toastSuccess("Lesson simplified", "Blocks were replaced with the simplified version.");
              })
            }
          >
            {busyAction === "simplify" ? "Simplifying…" : "Simplify lesson"}
          </Button>

          <Field label="Rewrite instruction" htmlFor="assist-rewrite">
            <textarea
              id="assist-rewrite"
              className="min-h-[72px] w-full rounded-xl border border-nexus-border bg-background px-3 py-2 text-sm"
              value={rewriteInstruction}
              onChange={(event) => setRewriteInstruction(event.target.value)}
              placeholder="e.g. Use a Kenyan market example"
              disabled={disabled || busyAction !== null || !selectedBlock}
            />
          </Field>

          <Button
            type="button"
            variant="outline"
            disabled={disabled || busyAction !== null || !selectedBlock?.id}
            onClick={() =>
              void runAction("rewrite", async () => {
                if (!selectedBlock?.id) {
                  return;
                }
                const rewritten = await assistRewriteBlock({
                  subtopicId,
                  curriculum: curriculumCode,
                  gradeLevel,
                  block: selectedBlock,
                  instruction: rewriteInstruction.trim() || undefined,
                });
                onReplaceBlock(
                  selectedBlock.id,
                  normalizeStudioBlocks([rewritten.block])[0],
                );
                toastSuccess("Block rewritten", "Review the updated block.");
              })
            }
          >
            {busyAction === "rewrite" ? "Rewriting…" : "Rewrite selected block"}
          </Button>
        </div>

        {selectedBlock ? (
          <p className="text-xs text-muted-foreground">
            Selected: <span className="font-medium">{selectedBlock.type}</span> block
          </p>
        ) : (
          <p className="text-xs text-muted-foreground">
            Select a block in the editor to expand or rewrite it.
          </p>
        )}
      </div>
    </Panel>
  );
}

function serializeStudioBlocksForAssist(blocks: LessonContentBlock[]): LessonContentBlock[] {
  return normalizeStudioBlocks(blocks);
}
