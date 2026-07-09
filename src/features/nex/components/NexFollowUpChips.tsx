"use client";

import { cn } from "@/lib/utils";

import { getFollowUpPromptsForMode } from "@/features/nex/lib/nexTutorPresentation";

import type { NexVisibleMode } from "@/features/nex/components/NexModeSelector";

interface NexFollowUpChipsProps {
  mode: NexVisibleMode;
  topicTitle?: string | null;
  onSelect: (prompt: string) => void;
  disabled?: boolean;
  className?: string;
}

export function NexFollowUpChips({
  mode,
  topicTitle,
  onSelect,
  disabled = false,
  className,
}: NexFollowUpChipsProps) {
  const prompts = getFollowUpPromptsForMode(mode, topicTitle);

  return (
    <div
      className={cn("flex flex-wrap gap-2", className)}
      role="group"
      aria-label="Suggested follow-ups"
    >
      {prompts.map((prompt) => (
        <button
          key={prompt}
          type="button"
          disabled={disabled}
          onClick={() => onSelect(prompt)}
          className={cn(
            "min-h-12 rounded-full border border-nexus-border bg-nexus-surface px-4 py-2 text-sm font-medium text-foreground transition-colors hover:bg-nexus-sunken focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
            disabled && "cursor-not-allowed opacity-50",
          )}
        >
          {prompt}
        </button>
      ))}
    </div>
  );
}
