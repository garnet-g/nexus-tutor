import { Award, Lock } from "lucide-react";

import { SectionCard } from "@/components/ui/SectionCard";
import { cn } from "@/lib/utils";

const ACHIEVABLE_BADGES = [
  {
    code: "first_diagnostic_complete",
    label: "First diagnostic",
    criteria: "Complete your diagnostic assessment",
  },
  {
    code: "first_practice_complete",
    label: "First practice",
    criteria: "Finish one full practice session",
  },
  {
    code: "seven_day_streak",
    label: "7-day streak",
    criteria: "Study seven days in a row",
  },
] as const;

interface ProgressBadgesSectionProps {
  earnedBadges: string[];
  badgeEarnedAt: Record<string, string | undefined>;
}

export function ProgressBadgesSection({
  earnedBadges,
  badgeEarnedAt,
}: ProgressBadgesSectionProps) {
  const earnedSet = new Set(earnedBadges);
  const extraBadges = earnedBadges.filter(
    (code) => !ACHIEVABLE_BADGES.some((badge) => badge.code === code),
  );

  return (
    <SectionCard
      title="Badges"
      description="Earn badges as you complete diagnostics, practice, and daily streaks."
    >
      <div className="grid gap-3 sm:grid-cols-3">
        {ACHIEVABLE_BADGES.map((badge) => {
          const earned = earnedSet.has(badge.code);
          const earnedAt = badgeEarnedAt[badge.code];

          return (
            <div
              key={badge.code}
              title={earned ? undefined : badge.criteria}
              className={cn(
                "flex min-h-[88px] flex-col justify-between rounded-[18px] border p-4 transition-colors",
                earned
                  ? "border-nexus-success/40 bg-nexus-success-soft/50 shadow-card"
                  : "border-dashed border-nexus-border bg-nexus-sunken/40 text-muted-foreground",
              )}
            >
              <div className="flex items-start justify-between gap-2">
                <Award
                  className={cn(
                    "size-5 shrink-0",
                    earned ? "text-nexus-success" : "opacity-40",
                  )}
                  aria-hidden
                />
                {!earned ? (
                  <Lock className="size-4 opacity-50" aria-hidden />
                ) : null}
              </div>
              <div>
                <p
                  className={cn(
                    "text-sm font-semibold",
                    earned ? "text-foreground" : "text-muted-foreground",
                  )}
                >
                  {badge.label}
                </p>
                <p className="mt-1 text-xs leading-snug">
                  {earned
                    ? earnedAt
                      ? `Earned ${new Date(earnedAt).toLocaleDateString("en-KE")}`
                      : "Earned"
                    : badge.criteria}
                </p>
              </div>
            </div>
          );
        })}
      </div>

      {extraBadges.length > 0 ? (
        <div className="mt-4 flex flex-wrap gap-2">
          {extraBadges.map((code) => (
            <span
              key={code}
              className="rounded-full border border-nexus-border bg-nexus-surface px-3 py-1 text-xs font-medium text-foreground"
            >
              {code.replaceAll("_", " ")}
            </span>
          ))}
        </div>
      ) : null}
    </SectionCard>
  );
}
