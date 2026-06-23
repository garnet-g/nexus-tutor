"use client";

import { useMemo, useState } from "react";

import type { LessonBlockType, LessonContentBlock } from "@/types/curriculum";

import { LessonBlockEditorCard } from "@/features/admin/studio/components/LessonBlockEditorCard";
import {
  createDefaultBlock,
  STUDIO_BLOCK_MENU,
} from "@/features/admin/studio/lib/lessonBlockStudio";
import { Button } from "@/components/ui/Button";
import { cn } from "@/lib/utils";

interface LessonBlockListEditorProps {
  blocks: LessonContentBlock[];
  onChange: (blocks: LessonContentBlock[]) => void;
  selectedBlockId?: string | null;
  onSelectBlock?: (blockId: string | null) => void;
}

function reorderBlocks(
  blocks: LessonContentBlock[],
  fromIndex: number,
  toIndex: number,
): LessonContentBlock[] {
  if (fromIndex === toIndex || fromIndex < 0 || toIndex < 0) {
    return blocks;
  }

  const next = [...blocks];
  const [moved] = next.splice(fromIndex, 1);
  next.splice(toIndex, 0, moved);
  return next;
}

export function LessonBlockListEditor({
  blocks,
  onChange,
  selectedBlockId = null,
  onSelectBlock,
}: LessonBlockListEditorProps) {
  const [dragIndex, setDragIndex] = useState<number | null>(null);
  const [slashQuery, setSlashQuery] = useState("");
  const [slashOpen, setSlashOpen] = useState(false);

  const filteredMenu = useMemo(() => {
    const query = slashQuery.trim().toLowerCase();
    if (!query) {
      return STUDIO_BLOCK_MENU;
    }

    return STUDIO_BLOCK_MENU.filter(
      (item) =>
        item.label.toLowerCase().includes(query) || item.type.toLowerCase().includes(query),
    );
  }, [slashQuery]);

  function updateBlock(index: number, block: LessonContentBlock) {
    onChange(blocks.map((current, currentIndex) => (currentIndex === index ? block : current)));
  }

  function insertBlock(type: LessonBlockType, index = blocks.length) {
    const next = [...blocks];
    next.splice(index, 0, createDefaultBlock(type));
    onChange(next);
    setSlashOpen(false);
    setSlashQuery("");
  }

  function duplicateBlock(index: number) {
    const source = blocks[index];
    const duplicate = {
      ...structuredClone(source),
      id: crypto.randomUUID(),
    };
    const next = [...blocks];
    next.splice(index + 1, 0, duplicate);
    onChange(next);
  }

  function deleteBlock(index: number) {
    onChange(blocks.filter((_, currentIndex) => currentIndex !== index));
  }

  return (
    <div className="space-y-4">
      {blocks.map((block, index) => (
        <div
          key={block.id ?? `${block.type}-${index}`}
          draggable
          onDragStart={() => setDragIndex(index)}
          onDragOver={(event) => event.preventDefault()}
          onDrop={() => {
            if (dragIndex === null) {
              return;
            }
            onChange(reorderBlocks(blocks, dragIndex, index));
            setDragIndex(null);
          }}
          className={cn(
            "rounded-2xl border border-nexus-border bg-nexus-surface",
            dragIndex === index && "opacity-60",
            selectedBlockId && block.id === selectedBlockId && "ring-2 ring-primary/40",
          )}
        >
          <div
            className="flex flex-wrap items-center justify-between gap-2 border-b border-nexus-border px-4 py-3"
            onClick={() => onSelectBlock?.(block.id ?? null)}
            onKeyDown={(event) => {
              if (event.key === "Enter" || event.key === " ") {
                onSelectBlock?.(block.id ?? null);
              }
            }}
            role={onSelectBlock ? "button" : undefined}
            tabIndex={onSelectBlock ? 0 : undefined}
          >
            <div className="flex items-center gap-2">
              <span
                className="cursor-grab text-xs text-muted-foreground"
                title="Drag to reorder"
                aria-hidden
              >
                ⋮⋮
              </span>
              <p className="text-xs font-semibold uppercase tracking-wide text-nexus-primary">
                {block.type.replaceAll("_", " ")}
              </p>
            </div>
            <div className="flex flex-wrap gap-1">
              <Button
                type="button"
                size="sm"
                variant="outline"
                disabled={index === 0}
                onClick={() => onChange(reorderBlocks(blocks, index, index - 1))}
              >
                Up
              </Button>
              <Button
                type="button"
                size="sm"
                variant="outline"
                disabled={index === blocks.length - 1}
                onClick={() => onChange(reorderBlocks(blocks, index, index + 1))}
              >
                Down
              </Button>
              <Button type="button" size="sm" variant="outline" onClick={() => duplicateBlock(index)}>
                Duplicate
              </Button>
              <Button
                type="button"
                size="sm"
                variant="destructive"
                onClick={() => deleteBlock(index)}
              >
                Delete
              </Button>
            </div>
          </div>
          <div className="p-4">
            <LessonBlockEditorCard
              block={block}
              index={index}
              onChange={(nextBlock) => updateBlock(index, nextBlock)}
            />
          </div>
        </div>
      ))}

      <div className="rounded-2xl border border-dashed border-nexus-border bg-nexus-sunken/40 p-4">
        <div className="flex flex-wrap items-center gap-2">
          <Button type="button" variant="outline" onClick={() => setSlashOpen((open) => !open)}>
            Insert block
          </Button>
          <span className="text-sm text-muted-foreground">or type / to search block types</span>
        </div>

        {slashOpen ? (
          <div className="mt-3 space-y-2">
            <input
              value={slashQuery}
              onChange={(event) => setSlashQuery(event.target.value)}
              placeholder="/heading, /image, /question…"
              className="w-full rounded-lg border border-nexus-border bg-nexus-surface px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
            />
            <div className="grid gap-1 sm:grid-cols-2">
              {filteredMenu.map((item) => (
                <button
                  key={item.type}
                  type="button"
                  onClick={() => insertBlock(item.type)}
                  className="rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-left text-sm hover:bg-nexus-sunken"
                >
                  <span className="font-medium text-foreground">{item.label}</span>
                  <span className="mt-0.5 block text-xs text-muted-foreground">{item.hint}</span>
                </button>
              ))}
            </div>
          </div>
        ) : null}
      </div>
    </div>
  );
}
