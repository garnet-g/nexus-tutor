"use client";

import { ChevronDown, ChevronUp, Send, StickyNote } from "lucide-react";
import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { cn } from "@/lib/utils";

const STORAGE_KEY = "nexus-nex-scratchpad";

function readScratchpad(): string {
  if (typeof window === "undefined") {
    return "";
  }

  return window.localStorage.getItem(STORAGE_KEY) ?? "";
}

interface NexScratchpadProps {
  onSendNotes?: (notes: string) => void;
  disabled?: boolean;
  className?: string;
}

export function NexScratchpad({
  onSendNotes,
  disabled = false,
  className,
}: NexScratchpadProps) {
  const [open, setOpen] = useState(false);
  const [notes, setNotes] = useState(readScratchpad);
  const trimmedNotes = notes.trim();

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
        <span className="flex min-w-0 items-center gap-2">
          <StickyNote className="size-4 shrink-0 text-nexus-primary" aria-hidden />
          <span>Scratchpad</span>
          <span className="hidden text-xs font-normal text-muted-foreground sm:inline">
            saved on this device only
          </span>
        </span>
        {open ? (
          <ChevronUp className="size-4 text-muted-foreground" aria-hidden />
        ) : (
          <ChevronDown className="size-4 text-muted-foreground" aria-hidden />
        )}
      </button>
      {open ? (
        <div className="space-y-2 px-4 pb-3">
          <textarea
            value={notes}
            onChange={(event) => handleChange(event.target.value)}
            rows={4}
            placeholder="Jot your working here. Only you can see this until you send it."
            className="min-h-[96px] w-full resize-y rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm text-foreground focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
          />
          <div className="flex flex-wrap items-center justify-between gap-2">
            <p className="text-xs text-muted-foreground">
              Saved on this device only
            </p>
            {onSendNotes ? (
              <Button
                type="button"
                variant="secondary"
                size="sm"
                disabled={disabled || trimmedNotes.length === 0}
                onClick={() => onSendNotes(trimmedNotes)}
              >
                <Send className="size-3.5" aria-hidden />
                Send working to Nex
              </Button>
            ) : null}
          </div>
        </div>
      ) : null}
    </div>
  );
}
