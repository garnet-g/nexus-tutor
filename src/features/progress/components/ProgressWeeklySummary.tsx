import { CalendarRange, Clock3, TrendingDown } from "lucide-react";

import { SectionCard } from "@/components/ui/SectionCard";
import { StatTile } from "@/components/widgets/StatTile";
import type { StudentWeeklySummary } from "@/server/services/weeklyReportService";

interface ProgressWeeklySummaryProps {
  summary: StudentWeeklySummary;
}

function formatWeekRange(weekStart: string, weekEnd: string): string {
  const start = new Date(`${weekStart}T12:00:00`);
  const end = new Date(`${weekEnd}T12:00:00`);

  const startLabel = start.toLocaleDateString("en-KE", {
    month: "short",
    day: "numeric",
  });
  const endLabel = end.toLocaleDateString("en-KE", {
    month: "short",
    day: "numeric",
  });

  return `${startLabel} – ${endLabel}`;
}

function formatActivityLabel(activityType: string): string {
  switch (activityType) {
    case "practice":
      return "Practice";
    case "learn":
      return "Learn";
    case "nex":
      return "Nex chat";
    default:
      return activityType.replaceAll("_", " ");
  }
}

export function ProgressWeeklySummary({ summary }: ProgressWeeklySummaryProps) {
  const weakTopicsLabel =
    summary.weakTopics.length > 0
      ? summary.weakTopics.slice(0, 3).join(", ")
      : "None flagged this week";

  return (
    <SectionCard
      title="This week's summary"
      description={`${formatWeekRange(summary.weekStart, summary.weekEnd)} · in-app view (email reports stay separate)`}
    >
      <div className="space-y-4">
        <div className="grid gap-3 sm:grid-cols-2">
          <StatTile
            label="Study time"
            value={`${summary.studyMinutes} min`}
            hint="Logged study sessions this week"
            tone="primary"
            icon={<Clock3 className="size-4" />}
          />
          <StatTile
            label="Health score"
            value={`${summary.healthScore}/100`}
            hint={summary.predictedGrade ?? "Latest snapshot"}
            tone="accent"
            icon={<CalendarRange className="size-4" />}
          />
        </div>

        <div className="rounded-xl border border-nexus-border bg-nexus-sunken/50 px-4 py-3">
          <p className="flex items-center gap-2 text-xs font-medium uppercase tracking-wide text-muted-foreground">
            <TrendingDown className="size-3.5" aria-hidden />
            Focus topics
          </p>
          <p className="mt-2 text-sm text-foreground">{weakTopicsLabel}</p>
        </div>

        {summary.activityBreakdown.length > 0 ? (
          <div className="space-y-2">
            <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
              Recent activity
            </p>
            <ul className="space-y-1.5">
              {summary.activityBreakdown.map((entry) => (
                <li
                  key={entry.activityType}
                  className="flex items-center justify-between gap-3 text-sm"
                >
                  <span className="text-foreground">
                    {formatActivityLabel(entry.activityType)}
                  </span>
                  <span className="tabular text-muted-foreground">
                    {entry.minutes} min
                  </span>
                </li>
              ))}
            </ul>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">
            {/* DATA-FLAG: no study_time_logs rows yet this week — breakdown omitted */}
            No logged study time this week yet. Practice or learn to populate
            your weekly summary.
          </p>
        )}
      </div>
    </SectionCard>
  );
}
