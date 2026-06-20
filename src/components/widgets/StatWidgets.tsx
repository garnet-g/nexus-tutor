import { streakToGrid } from "@/lib/gamification";
import { cn } from "@/lib/utils";
import { ProgressRing } from "@/components/widgets/Charts";

interface GoalRingProps {
  value: number;
  max: number;
  label?: string;
  unit?: string;
  size?: number;
}

/** Circular progress ring — daily goal, readiness, etc. */
export function GoalRing({
  value,
  max,
  label,
  unit,
  size = 96,
}: GoalRingProps) {
  return (
    <ProgressRing
      value={value}
      max={max}
      label={label}
      unit={unit}
      size={size}
    />
  );
}

interface StreakHeatmapProps {
  currentStreak: number;
  weeks?: number;
}

/** GitHub-style activity grid; lights up the most recent streak days. */
export function StreakHeatmap({ currentStreak, weeks = 5 }: StreakHeatmapProps) {
  const grid = streakToGrid(currentStreak, weeks);

  return (
    <div className="flex flex-wrap gap-1" aria-hidden>
      {grid.map((active, index) => (
        <span
          key={index}
          className={cn(
            "size-3.5 rounded-[4px]",
            active ? "bg-nexus-primary" : "bg-nexus-sunken",
          )}
          style={
            active
              ? {
                  opacity: 0.55 + (0.45 * (index % 7)) / 6,
                }
              : undefined
          }
        />
      ))}
    </div>
  );
}

interface MiniStatProps {
  icon: React.ReactNode;
  value: React.ReactNode;
  label: string;
  tone?: "primary" | "accent";
}

export function MiniStat({ icon, value, label, tone = "primary" }: MiniStatProps) {
  return (
    <div className="flex items-center gap-3">
      <span
        className={cn(
          "flex size-9 flex-none items-center justify-center rounded-xl",
          tone === "primary"
            ? "bg-nexus-primary-soft text-nexus-primary"
            : "bg-nexus-accent-soft text-nexus-warning",
        )}
      >
        {icon}
      </span>
      <div className="min-w-0 leading-tight">
        <p className="font-heading text-lg font-medium tabular text-foreground">
          {value}
        </p>
        <p className="text-xs text-muted-foreground">{label}</p>
      </div>
    </div>
  );
}
