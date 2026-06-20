import Link from "next/link";

import { SectionCard } from "@/components/ui/SectionCard";
import { BarMeter, RadarChart } from "@/components/widgets/Charts";
import {
  getMasteryPill,
  masteryPillClass,
} from "@/features/progress/lib/masteryPills";
import { cn } from "@/lib/utils";

export interface ProgressTopicMastery {
  topicId: string;
  title: string;
  masteryPercentage: number;
}

interface ProgressMasterySectionProps {
  topics: ProgressTopicMastery[];
}

function shortenLabel(title: string, max = 14): string {
  if (title.length <= max) {
    return title;
  }

  return `${title.slice(0, max - 1)}…`;
}

export function ProgressMasterySection({ topics }: ProgressMasterySectionProps) {
  const sorted = [...topics].sort(
    (left, right) => left.masteryPercentage - right.masteryPercentage,
  );
  const showRadar = sorted.length >= 3;
  const radarLabels = sorted.map((topic) => shortenLabel(topic.title));
  const radarValues = sorted.map((topic) => topic.masteryPercentage);

  return (
    <SectionCard
      title="Topic mastery"
      description="Mathematics topics from your diagnostic and practice results."
      action={
        <Link
          href="/practice"
          className="text-sm font-medium text-nexus-primary transition-colors hover:text-nexus-primary-dark"
        >
          Practice a weak topic →
        </Link>
      }
    >
      {topics.length === 0 ? (
        <p className="text-sm text-muted-foreground">
          Complete your diagnostic to see topic mastery.
        </p>
      ) : (
        <div className="space-y-6">
          {showRadar ? (
            <div className="flex flex-col items-center gap-3">
              <RadarChart
                labels={radarLabels}
                values={radarValues}
                size={240}
                className="max-w-full"
              />
              <p className="text-xs text-muted-foreground">
                Radar view — {sorted.length} topics tracked
              </p>
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">
              Add more topics to unlock the radar view — showing bars for now.
            </p>
          )}

          <div className="space-y-4">
            {sorted.map((topic) => {
              const pill = getMasteryPill(topic.masteryPercentage);

              return (
                <div key={topic.topicId} className="space-y-2">
                  <div className="flex flex-wrap items-center justify-between gap-2">
                    <span className="text-sm font-medium text-foreground">
                      {topic.title}
                    </span>
                    <span
                      className={cn(
                        "rounded-full border px-2.5 py-1 text-xs font-medium",
                        masteryPillClass[pill.status],
                      )}
                    >
                      {pill.label}
                    </span>
                  </div>
                  <BarMeter
                    value={topic.masteryPercentage}
                    label="Mastery"
                    showValue
                  />
                </div>
              );
            })}
          </div>
        </div>
      )}
    </SectionCard>
  );
}
