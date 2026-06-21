"use client";

import { CheckCircle2, Circle, History, Lightbulb } from "lucide-react";

import type { NexVisibleMode } from "@/features/nex/components/NexModeSelector";
import {
  formatResumedSessionLabel,
  getModeHelperText,
} from "@/features/nex/lib/nexTutorPresentation";
import type { NexMode } from "@/lib/nex/types";
import { cn } from "@/lib/utils";

interface NexTutorContextProps {
  mode: NexVisibleMode;
  resumedMode?: NexMode | null;
  resumedSessionStartedAt?: string | null;
  showResumeBanner?: boolean;
  onNewChat?: () => void;
}

export function NexTutorContext({
  mode,
  resumedMode = null,
  resumedSessionStartedAt = null,
  showResumeBanner = false,
  onNewChat,
}: NexTutorContextProps) {
  return (
    <div className="space-y-2">
      <p className="flex items-start gap-2 rounded-xl border border-nexus-border bg-nexus-sunken/60 px-3 py-2 text-xs leading-relaxed text-muted-foreground">
        <Lightbulb className="mt-0.5 size-3.5 shrink-0 text-nexus-primary" aria-hidden />
        <span>{getModeHelperText(mode)}</span>
      </p>
      {showResumeBanner && resumedMode ? (
        <div className="flex flex-wrap items-center justify-between gap-2 rounded-xl border border-nexus-primary/20 bg-nexus-primary-soft/50 px-3 py-2 text-xs text-nexus-primary">
          <span className="flex items-center gap-2 font-medium">
            <History className="size-3.5" aria-hidden />
            {formatResumedSessionLabel(resumedMode, resumedSessionStartedAt)}
          </span>
          {onNewChat ? (
            <button
              type="button"
              onClick={onNewChat}
              className="font-semibold text-nexus-primary underline-offset-4 hover:underline focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
            >
              Start fresh
            </button>
          ) : null}
        </div>
      ) : null}
    </div>
  );
}

const HOMEWORK_STEPS = [
  "Hint 1",
  "Hint 2",
  "Hint 3",
  "Full solution",
] as const;

export function NexHomeworkHintLadder({
  className,
}: {
  className?: string;
}) {
  return (
    <div
      className={cn(
        "rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2",
        className,
      )}
      aria-label="Homework hint ladder"
    >
      <div className="mb-2 flex items-center gap-2 text-xs font-semibold text-foreground">
        <CheckCircle2 className="size-3.5 text-nexus-primary" aria-hidden />
        Homework hint ladder
      </div>
      <ol className="grid grid-cols-2 gap-2 sm:grid-cols-4">
        {HOMEWORK_STEPS.map((step, index) => (
          <li
            key={step}
            className="flex items-center gap-1.5 rounded-lg bg-nexus-sunken px-2 py-1.5 text-[11px] font-medium text-muted-foreground"
          >
            <Circle
              className={cn(
                "size-2.5",
                index === 0 ? "fill-nexus-primary text-nexus-primary" : "text-nexus-border-strong",
              )}
              aria-hidden
            />
            {step}
          </li>
        ))}
      </ol>
    </div>
  );
}
