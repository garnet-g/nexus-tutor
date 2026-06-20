"use client";

import { ChevronDown, ChevronUp, StickyNote } from "lucide-react";
import { useState } from "react";

import { cn } from "@/lib/utils";

const STORAGE_KEY = "nexus-nex-scratchpad";

function readScratchpad(): string {
  if (typeof window === "undefined") {
    return "";
  }

  return window.localStorage.getItem(STORAGE_KEY) ?? "";
}

interface NexScratchpadProps {
  className?: string;
}

export function NexScratchpad({ className }: NexScratchpadProps) {
  const [open, setOpen] = useState(false);
  const [notes, setNotes] = useState(readScratchpad);

  function handleChange(value: string) {
    setNotes(value);
    window.localStorage.setItem(STORAGE_KEY, value);
  }

  return (
    <div className={cn("border-t border-border", className)}>
      <button
        type="button"
        onClick={() => setOpen((current) => !current)}
        aria-expanded={open}
        className="flex min-h-12 w-full items-center justify-between gap-2 px-4 py-2 text-sm font-medium text-foreground transition-colors hover:bg-nexus-sunken focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
      >
        <span className="flex items-center gap-2">
          <StickyNote className="size-4 text-nexus-primary" aria-hidden />
          Scratchpad
          <span className="text-xs font-normal text-muted-foreground">
            (saved on this device only)
          </span>
        </span>
        {open ? (
          <ChevronUp className="size-4 text-muted-foreground" aria-hidden />
        ) : (
          <ChevronDown className="size-4 text-muted-foreground" aria-hidden />
        )}
      </button>
      {open ? (
        <div className="px-4 pb-3">
          <textarea
            value={notes}
            onChange={(event) => handleChange(event.target.value)}
            rows={4}
            placeholder="Jot your working here — only you can see this."
            className="min-h-[96px] w-full resize-y rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm text-foreground focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
          />
        </div>
      ) : null}
    </div>
  );
}
