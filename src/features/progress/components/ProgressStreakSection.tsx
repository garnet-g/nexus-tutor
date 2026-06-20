import { Flame } from "lucide-react";

import { SectionCard } from "@/components/ui/SectionCard";
import { MiniStat, StreakHeatmap } from "@/components/widgets/StatWidgets";

interface ProgressStreakSectionProps {
  currentStreak: number;
  longestStreak: number;
}

export function ProgressStreakSection({
  currentStreak,
  longestStreak,
}: ProgressStreakSectionProps) {
  return (
    <SectionCard
      title="Study streak"
      description="Recent active days — keep it going with a short session today."
    >
      <div className="space-y-4">
        <div className="grid gap-4 sm:grid-cols-2">
          <MiniStat
            icon={<Flame className="size-4" />}
            value={`${currentStreak} days`}
            label="Current streak"
            tone="accent"
          />
          <MiniStat
            icon={<Flame className="size-4" />}
            value={`${longestStreak} days`}
            label="Best streak"
            tone="primary"
          />
        </div>
        <StreakHeatmap currentStreak={currentStreak} weeks={5} />
        <p className="text-xs text-muted-foreground">
          Grid shows your most recent streak days (not a full calendar history).
        </p>
      </div>
    </SectionCard>
  );
}
