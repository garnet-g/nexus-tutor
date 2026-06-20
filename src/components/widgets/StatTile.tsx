import { cn } from "@/lib/utils";

interface StatTileProps {
  label: string;
  value: React.ReactNode;
  hint?: string;
  icon?: React.ReactNode;
  tone?: "primary" | "accent" | "neutral";
  className?: string;
}

const toneStyles = {
  primary: "bg-nexus-primary-soft text-nexus-primary",
  accent: "bg-nexus-accent-soft text-nexus-warning",
  neutral: "bg-nexus-sunken text-nexus-text-secondary",
} as const;

export function StatTile({
  label,
  value,
  hint,
  icon,
  tone = "neutral",
  className,
}: StatTileProps) {
  return (
    <div
      className={cn(
        "rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card",
        className,
      )}
    >
      <div className="flex items-start gap-3">
        {icon ? (
          <span
            className={cn(
              "flex size-10 flex-none items-center justify-center rounded-xl",
              toneStyles[tone],
            )}
          >
            {icon}
          </span>
        ) : null}
        <div className="min-w-0">
          <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            {label}
          </p>
          <p className="mt-1 font-heading text-2xl font-semibold tabular text-foreground">
            {value}
          </p>
          {hint ? (
            <p className="mt-1 text-sm text-muted-foreground">{hint}</p>
          ) : null}
        </div>
      </div>
    </div>
  );
}
