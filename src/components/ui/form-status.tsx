"use client";

import type { ReactNode } from "react";

import { cn } from "@/lib/utils";

type FormStatusTone = "error" | "success" | "info";

interface FormStatusProps {
  message?: string | null;
  tone?: FormStatusTone;
  children?: ReactNode;
  className?: string;
}

const toneClassNames: Record<FormStatusTone, string> = {
  error: "border-destructive/30 bg-destructive/10 text-destructive",
  success:
    "border-emerald-500/30 bg-emerald-500/10 text-emerald-700 dark:text-emerald-300",
  info: "border-border bg-muted text-muted-foreground",
};

export function FormStatus({
  message,
  tone = "info",
  children,
  className,
}: FormStatusProps) {
  if (!message && !children) {
    return null;
  }

  return (
    <p
      role={tone === "error" ? "alert" : "status"}
      aria-live={tone === "error" ? "assertive" : "polite"}
      className={cn(
        "rounded-xl border px-3 py-2 text-sm",
        toneClassNames[tone],
        className,
      )}
    >
      {message ?? children}
    </p>
  );
}
