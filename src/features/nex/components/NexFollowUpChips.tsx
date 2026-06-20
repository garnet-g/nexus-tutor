"use client";

import { cn } from "@/lib/utils";

export const NEX_FOLLOW_UP_PROMPTS = [
  "Give me a hint",
  "Show an example",
  "Quiz me on this",
  "Explain differently",
] as const;

interface NexFollowUpChipsProps {
  onSelect: (prompt: string) => void;
  disabled?: boolean;
  className?: string;
}

export function NexFollowUpChips({
  onSelect,
  disabled = false,
  className,
}: NexFollowUpChipsProps) {
  return (
    <div
      className={cn("flex flex-wrap gap-2", className)}
      role="group"
      aria-label="Suggested follow-ups"
    >
      {NEX_FOLLOW_UP_PROMPTS.map((prompt) => (
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
