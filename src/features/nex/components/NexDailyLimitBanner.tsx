"use client";

import { EmptyState } from "@/components/ui/EmptyState";
import { BarMeter } from "@/components/widgets/Charts";
import { SectionCard } from "@/components/ui/SectionCard";
import { MessageCircle } from "lucide-react";
import { formatNexAllowanceSummary } from "@/features/nex/lib/nexTutorPresentation";

interface NexDailyLimitBannerProps {
  dailyUsage: number;
  dailyLimit: number;
  retryAfterSeconds: number;
  planCode: string;
  atLimit: boolean;
  compact?: boolean;
}

function formatResetTime(retryAfterSeconds: number): string {
  const hours = Math.floor(retryAfterSeconds / 3600);
  const minutes = Math.ceil((retryAfterSeconds % 3600) / 60);

  if (hours > 0) {
    return `about ${hours} hour${hours === 1 ? "" : "s"}`;
  }

  return `about ${minutes} minute${minutes === 1 ? "" : "s"}`;
}

export function NexDailyLimitBanner({
  dailyUsage,
  dailyLimit,
  retryAfterSeconds,
  planCode,
  atLimit,
  compact = false,
}: NexDailyLimitBannerProps) {
  const pct =
    dailyLimit > 0
      ? Math.min(100, Math.max(0, (dailyUsage / dailyLimit) * 100))
      : 0;

  if (atLimit) {
    return (
      <EmptyState
        icon={<MessageCircle className="size-6" />}
        title="Daily Nex message limit reached"
        description={`You have used all ${dailyLimit} free messages for today. Limits reset in ${formatResetTime(retryAfterSeconds)} (Nairobi midnight).`}
        primaryAction={
          planCode === "free"
            ? { label: "View Premium plans", href: "/pricing" }
            : undefined
        }
        secondaryAction={{ label: "Back to Today", href: "/dashboard" }}
        className="mx-4 my-4"
      />
    );
  }

  if (compact) {
    return (
      <div className="mx-4 mt-3 rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2">
        <div className="flex items-center justify-between gap-3 text-xs">
          <span className="font-medium text-foreground">
            {formatNexAllowanceSummary(dailyUsage, dailyLimit, true)}
          </span>
          <span className="tabular text-muted-foreground">
            {Math.round(pct)}%
          </span>
        </div>
        <div className="mt-2 h-1.5 overflow-hidden rounded-full bg-nexus-sunken">
          <div
            className="h-full rounded-full bg-nexus-primary transition-[width] duration-700"
            style={{ width: `${pct}%` }}
          />
        </div>
      </div>
    );
  }

  return (
    <SectionCard
      className="mx-4 mt-3 border-0 bg-transparent p-0 shadow-none"
      title="Today's Nex allowance"
      description="Free forever — messages reset at midnight Nairobi time."
    >
      <div className="space-y-2">
        <BarMeter
          value={dailyUsage}
          max={dailyLimit}
          label="Messages used"
          showValue
        />
        <p className="text-xs text-muted-foreground">
          {formatNexAllowanceSummary(dailyUsage, dailyLimit, false)}
        </p>
      </div>
    </SectionCard>
  );
}

/** Compact inline note when approaching limit — optional export for reuse */
export function NexLimitInlineNote({
  remaining,
  dailyLimit,
}: {
  remaining: number;
  dailyLimit: number;
}) {
  if (remaining > 1) {
    return null;
  }

  return (
    <p className="text-xs text-muted-foreground">
      {remaining === 0
        ? "No free messages left today."
        : `${remaining} free message left today of ${dailyLimit}.`}
    </p>
  );
}
