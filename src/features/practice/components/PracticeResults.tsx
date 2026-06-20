"use client";

import Link from "next/link";
import { Sparkles, Target } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import { BarMeter } from "@/components/widgets/Charts";
import { StatTile } from "@/components/widgets/StatTile";
import { useCountUp } from "@/lib/practice/useCountUp";
import { cn } from "@/lib/utils";

export interface PracticeCompleteResult {
  practiceScore: number;
  correctAnswers: number;
  incorrectAnswers: number;
  healthScore: number;
  predictedGrade: string | null;
  currentStreak: number;
  masteryUpdates: Array<{ topicId: string; masteryPercentage: number }>;
  xpEarned: number;
}

interface PracticeResultsProps {
  topicId: string;
  topicTitle: string;
  initialMastery: number;
  result: PracticeCompleteResult;
  isReview?: boolean;
  onPracticeAgain: () => void;
  onBack: () => void;
}

export function PracticeResults({
  topicId,
  topicTitle,
  initialMastery,
  result,
  isReview = false,
  onPracticeAgain,
  onBack,
}: PracticeResultsProps) {
  const animatedScore = useCountUp(result.practiceScore, !isReview);
  const animatedXp = useCountUp(result.xpEarned, !isReview && result.xpEarned > 0);
  const newMastery = result.masteryUpdates[0]?.masteryPercentage ?? initialMastery;
  const masteryDelta = newMastery - initialMastery;

  return (
    <div className="space-y-6 nexus-enter">
      <SectionCard
        className={cn(
          "border-nexus-success/30 bg-nexus-success-soft/40",
          isReview && "border-nexus-border bg-nexus-surface",
        )}
      >
        <p className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
          {isReview ? "Review complete" : "Session complete"}
        </p>
        <p className="mt-2 font-heading text-4xl font-semibold tabular text-foreground">
          {animatedScore}%
        </p>
        <p className="mt-2 text-sm text-muted-foreground">
          {result.correctAnswers} correct · {result.incorrectAnswers} incorrect
          {!isReview && topicTitle ? ` · ${topicTitle}` : null}
        </p>
      </SectionCard>

      {!isReview ? (
        <div className="grid gap-4 sm:grid-cols-2">
          <StatTile
            label="Mastery change"
            value={
              masteryDelta === 0
                ? "No change"
                : `${masteryDelta > 0 ? "+" : ""}${masteryDelta}%`
            }
            hint={`Now at ${newMastery}%`}
            tone="primary"
            icon={<Target className="size-4" />}
          />
          <StatTile
            label="XP earned"
            value={`+${animatedXp}`}
            hint="Added to your total progress"
            tone="accent"
            icon={<Sparkles className="size-4" />}
          />
        </div>
      ) : null}

      {!isReview && result.masteryUpdates.length > 0 ? (
        <SectionCard title="Topic breakdown">
          {result.masteryUpdates.map((update) => (
            <BarMeter
              key={update.topicId}
              value={update.masteryPercentage}
              label={topicTitle}
            />
          ))}
        </SectionCard>
      ) : null}

      {!isReview ? (
        <SectionCard title="Health snapshot">
          <p className="text-sm text-muted-foreground">
            Health score {result.healthScore}/100
            {result.predictedGrade ? ` · ${result.predictedGrade}` : null}
            {result.currentStreak > 0
              ? ` · ${result.currentStreak}-day streak`
              : null}
          </p>
        </SectionCard>
      ) : null}

      <div className="flex flex-col gap-2 sm:flex-row sm:flex-wrap">
        <Button
          render={<Link href={`/nex?topicId=${topicId}&mode=explain`} />}
          className="min-h-12"
        >
          Review mistakes with Nex
        </Button>
        <Button variant="outline" className="min-h-12" onClick={onPracticeAgain}>
          Practise again
        </Button>
        <Button variant="outline" className="min-h-12" onClick={onBack}>
          Back to practice
        </Button>
        <Button
          variant="ghost"
          render={<Link href="/dashboard" />}
          className="min-h-12"
        >
          Back to Today
        </Button>
      </div>
    </div>
  );
}
