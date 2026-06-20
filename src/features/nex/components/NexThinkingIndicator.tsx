"use client";

export function NexThinkingIndicator() {
  return (
    <div
      className="nex-think flex items-center gap-1.5 px-1 py-2"
      aria-live="polite"
      aria-label="Nex is thinking"
    >
      <i aria-hidden />
      <i aria-hidden />
      <i aria-hidden />
      <span className="sr-only">Nex is thinking</span>
    </div>
  );
}
