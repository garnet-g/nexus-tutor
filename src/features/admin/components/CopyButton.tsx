"use client";

import { useState } from "react";

import { cn } from "@/lib/utils";

interface CopyButtonProps {
  value: string;
  /** Accessible label, e.g. "Copy invite code". */
  label?: string;
  className?: string;
}

/** Inline click-to-copy control. Shows a transient "Copied" state. */
export function CopyButton({ value, label = "Copy", className }: CopyButtonProps) {
  const [copied, setCopied] = useState(false);

  async function handleCopy() {
    try {
      await navigator.clipboard.writeText(value);
      setCopied(true);
      window.setTimeout(() => setCopied(false), 1500);
    } catch {
      // Clipboard can be unavailable (insecure context); fail silently.
    }
  }

  return (
    <button
      type="button"
      onClick={handleCopy}
      aria-label={label}
      title={label}
      className={cn(
        "inline-flex items-center gap-1 rounded-md px-1.5 py-0.5 text-xs font-medium text-muted-foreground transition-colors hover:bg-nexus-sunken hover:text-foreground focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-primary/30",
        className,
      )}
    >
      {copied ? (
        <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" strokeWidth="2.4" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
          <path d="m20 6-11 11-5-5" />
        </svg>
      ) : (
        <svg viewBox="0 0 24 24" width="13" height="13" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
          <rect x="9" y="9" width="13" height="13" rx="2" />
          <path d="M5 15H4a2 2 0 0 1-2-2V4a2 2 0 0 1 2-2h9a2 2 0 0 1 2 2v1" />
        </svg>
      )}
      {copied ? "Copied" : ""}
    </button>
  );
}
