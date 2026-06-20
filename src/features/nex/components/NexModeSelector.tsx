"use client";

import {
  BookOpen,
  Lightbulb,
  RotateCcw,
  Target,
  type LucideIcon,
} from "lucide-react";

import type { NexMode } from "@/lib/nex/types";
import { cn } from "@/lib/utils";

/** V1 in-scope text modes only — assessment is server-detectable but not selectable here. */
export type NexVisibleMode = Exclude<NexMode, "assessment">;

interface ModeOption {
  value: NexVisibleMode;
  label: string;
  description: string;
  icon: LucideIcon;
}

export const NEX_VISIBLE_MODES: ModeOption[] = [
  {
    value: "explain",
    label: "Explain",
    description: "Break down concepts step by step",
    icon: Lightbulb,
  },
  {
    value: "practice",
    label: "Practice",
    description: "Quick questions to test yourself",
    icon: Target,
  },
  {
    value: "homework",
    label: "Homework",
    description: "Hints that guide, not answers",
    icon: BookOpen,
  },
  {
    value: "revision",
    label: "Revision",
    description: "Plans and recap for exams",
    icon: RotateCcw,
  },
];

interface NexModeSelectorProps {
  value: NexVisibleMode;
  onChange: (mode: NexVisibleMode) => void;
  disabled?: boolean;
}

export function NexModeSelector({
  value,
  onChange,
  disabled = false,
}: NexModeSelectorProps) {
  return (
    <div
      className="grid grid-cols-2 gap-2 sm:grid-cols-4"
      role="radiogroup"
      aria-label="Nex session mode"
    >
      {NEX_VISIBLE_MODES.map((mode) => {
        const Icon = mode.icon;
        const isActive = value === mode.value;

        return (
          <button
            key={mode.value}
            type="button"
            role="radio"
            aria-checked={isActive}
            disabled={disabled}
            onClick={() => onChange(mode.value)}
            className={cn(
              "flex min-h-12 flex-col items-start rounded-xl border px-3 py-2.5 text-left transition-colors focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
              isActive
                ? "border-nexus-primary bg-nexus-primary text-nexus-text-inverse shadow-card"
                : "border-nexus-border bg-nexus-surface text-foreground hover:bg-nexus-sunken",
              disabled && "cursor-not-allowed opacity-60",
            )}
          >
            <span className="flex items-center gap-1.5 text-sm font-semibold">
              <Icon className="size-4 shrink-0" aria-hidden />
              {mode.label}
            </span>
            <span
              className={cn(
                "mt-1 line-clamp-2 text-xs leading-snug",
                isActive ? "text-nexus-text-inverse/80" : "text-muted-foreground",
              )}
            >
              {mode.description}
            </span>
          </button>
        );
      })}
    </div>
  );
}

export function toVisibleMode(mode: NexMode): NexVisibleMode {
  if (mode === "assessment") {
    return "homework";
  }

  return mode;
}
