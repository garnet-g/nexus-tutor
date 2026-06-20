import { cn } from "@/lib/utils";

interface NexMarkProps {
  size?: number;
  className?: string;
}

/**
 * The Nex mark — the AI's consistent "face" across chat, nav, milestones and
 * parent reports. Presentational only. See Design System v2.0 §7.
 */
export function NexMark({ size = 40, className }: NexMarkProps) {
  return (
    <span
      className={cn("nex-mark", className)}
      style={{ width: size, height: size }}
      aria-hidden
    />
  );
}
