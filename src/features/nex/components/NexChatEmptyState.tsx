"use client";

import { NexMark } from "@/components/NexMark";
import type { NexVisibleMode } from "@/features/nex/components/NexModeSelector";
import { cn } from "@/lib/utils";

const STARTER_PROMPTS: Record<NexVisibleMode, string[]> = {
  explain: [
    "Explain fractions like I'm in Form 1",
    "What is the Pythagoras theorem?",
    "Help me understand linear equations",
  ],
  practice: [
    "Give me a medium algebra question",
    "Quiz me on geometry basics",
    "One practice question on percentages",
  ],
  homework: [
    "I'm stuck on a homework problem — can you guide me?",
    "Check my working without giving the final answer",
    "What should I try first for this word problem?",
  ],
  revision: [
    "Build a 30-minute revision plan for tomorrow",
    "What should I revise before my mock exam?",
    "Summarise the key topics I should review",
  ],
};

interface NexChatEmptyStateProps {
  mode: NexVisibleMode;
  onSelectPrompt: (prompt: string) => void;
  disabled?: boolean;
}

export function NexChatEmptyState({
  mode,
  onSelectPrompt,
  disabled = false,
}: NexChatEmptyStateProps) {
  const prompts = STARTER_PROMPTS[mode];

  return (
    <div className="flex flex-col items-center px-2 py-8 text-center sm:py-10">
      <NexMark size={56} className="mb-4" />
      <h2 className="font-heading text-lg font-semibold text-foreground">
        What would you like to work on?
      </h2>
      <p className="mt-2 max-w-sm text-sm leading-relaxed text-muted-foreground">
        Pick a starter below or type your own question. Nex guides you with
        hints — not just answers.
      </p>
      <div className="mt-6 grid w-full max-w-md gap-2">
        {prompts.map((prompt) => (
          <button
            key={prompt}
            type="button"
            disabled={disabled}
            onClick={() => onSelectPrompt(prompt)}
            className={cn(
              "min-h-12 rounded-xl border border-nexus-border bg-nexus-surface px-4 py-3 text-left text-sm text-foreground transition-colors hover:border-nexus-primary/40 hover:bg-nexus-primary-soft focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
              disabled && "cursor-not-allowed opacity-50",
            )}
          >
            {prompt}
          </button>
        ))}
      </div>
    </div>
  );
}
