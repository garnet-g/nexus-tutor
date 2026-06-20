import Link from "next/link";
import { ArrowRight, BookOpen } from "lucide-react";

import { Badge } from "@/components/ui/Badge";
import { BarMeter } from "@/components/widgets/Charts";
import {
  formatStrandLabel,
  getTopicMasteryLabel,
  getTopicMasteryStatus,
} from "@/lib/learn/masteryStatus";
import type { CurriculumTopic } from "@/types/curriculum";

interface TopicCardProps {
  topic: CurriculumTopic;
  masteryPercentage?: number;
  estimatedMinutes?: number;
}

export function TopicCard({
  topic,
  masteryPercentage = 0,
  estimatedMinutes,
}: TopicCardProps) {
  const status = getTopicMasteryStatus(masteryPercentage);
  const minutes = estimatedMinutes ?? Math.max(topic.lessonCount * 10, 10);

  return (
    <Link
      href={`/learn/${topic.id}`}
      className="group nexus-card-hover flex min-h-12 flex-col rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50"
    >
      <div className="flex items-start justify-between gap-4">
        <div className="min-w-0 space-y-2">
          <div className="flex flex-wrap items-center gap-2">
            <Badge variant="secondary">{formatStrandLabel(topic.code)}</Badge>
            <Badge
              variant={
                status === "mastered"
                  ? "default"
                  : status === "in_progress"
                    ? "outline"
                    : "secondary"
              }
            >
              {getTopicMasteryLabel(status)}
            </Badge>
          </div>
          <h3 className="font-heading text-lg font-semibold text-foreground">
            {topic.title}
          </h3>
          {topic.description ? (
            <p className="line-clamp-2 text-sm text-muted-foreground">
              {topic.description}
            </p>
          ) : null}
        </div>
        <ArrowRight className="size-5 shrink-0 text-nexus-text-muted transition-transform group-hover:translate-x-0.5 group-hover:text-nexus-primary" />
      </div>

      <div className="mt-5 grid gap-3 sm:grid-cols-[1fr_auto] sm:items-end">
        <BarMeter value={masteryPercentage} label="Mastery" />
        <div className="flex flex-wrap gap-3 text-sm text-muted-foreground">
          <span className="inline-flex items-center gap-1.5">
            <BookOpen className="size-4" />
            {topic.lessonCount} lessons
          </span>
          <span>{minutes} min</span>
        </div>
      </div>
    </Link>
  );
}
