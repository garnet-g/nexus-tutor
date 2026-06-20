import { LineChart, ProgressRing } from "@/components/widgets/Charts";
import { SectionCard } from "@/components/ui/SectionCard";
import { StatTile } from "@/components/widgets/StatTile";
import { Activity } from "lucide-react";

interface ProgressHealthCardProps {
  healthScore: number;
  predictedGrade: string | null;
  history: Array<{ label: string; value: number }>;
}

export function ProgressHealthCard({
  healthScore,
  predictedGrade,
  history,
}: ProgressHealthCardProps) {
  const showTrend = history.length >= 2;
  const trendChart = showTrend ? (
    <LineChart points={history} width={360} height={128} className="w-full" />
  ) : null;

  return (
    <SectionCard
      title="Academic health score"
      description="Your rolling readiness based on diagnostic and practice performance."
    >
      <div className="grid gap-6 sm:grid-cols-[auto_1fr] sm:items-center">
        <ProgressRing
          value={healthScore}
          max={100}
          label="Health"
          size={112}
          className="mx-auto sm:mx-0"
        />
        <div className="space-y-4">
          <StatTile
            label="Predicted grade"
            value={predictedGrade ?? "—"}
            hint={`Current score ${healthScore}/100`}
            tone="primary"
            icon={<Activity className="size-4" />}
          />
          {showTrend ? (
            <div className="space-y-2">
              <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                Score trend
              </p>
              {trendChart}
              <p className="text-xs text-muted-foreground">
                {/* DATA-FLAG: points from academic_health_scores.calculated_at snapshots */}
                Based on {history.length} recorded health snapshots.
              </p>
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">
              {/* DATA-FLAG: fewer than 2 snapshots in academic_health_scores — no trend rendered */}
              Trend appears as you practise — complete another session to see
              your score over time.
            </p>
          )}
        </div>
      </div>
    </SectionCard>
  );
}
