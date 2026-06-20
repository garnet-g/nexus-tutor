import { Sparkles } from "lucide-react";

import { SectionCard } from "@/components/ui/SectionCard";
import { BarMeter } from "@/components/widgets/Charts";
import { levelFromXp } from "@/lib/gamification";

interface ProgressXpSectionProps {
  totalXp: number;
}

export function ProgressXpSection({ totalXp }: ProgressXpSectionProps) {
  const levelInfo = levelFromXp(totalXp);
  const xpToNext = levelInfo.levelSize - levelInfo.intoLevel;

  return (
    <SectionCard
      title="XP & level"
      description="Earn XP from practice sessions and milestones."
    >
      <div className="space-y-4">
        <div className="flex items-baseline justify-between gap-3">
          <p className="font-heading text-3xl font-semibold tabular text-foreground">
            Level {levelInfo.level}
          </p>
          <p className="text-sm text-muted-foreground">
            <Sparkles className="mr-1 inline size-4 text-nexus-warning" />
            {totalXp} XP total
          </p>
        </div>
        <BarMeter
          value={levelInfo.intoLevel}
          max={levelInfo.levelSize}
          label={`${xpToNext} XP to level ${levelInfo.level + 1}`}
          showValue
        />
      </div>
    </SectionCard>
  );
}
