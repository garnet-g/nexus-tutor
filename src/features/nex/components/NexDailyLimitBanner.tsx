"use client";

import { EmptyState } from "@/components/ui/EmptyState";
import { BarMeter } from "@/components/widgets/Charts";
import { SectionCard } from "@/components/ui/SectionCard";
import { MessageCircle } from "lucide-react";

interface NexDailyLimitBannerProps {
  dailyUsage: number;
  dailyLimit: number;
  retryAfterSeconds: number;
  planCode: string;
  atLimit: boolean;
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
}: NexDailyLimitBannerProps) {
  const remaining = Math.max(0, dailyLimit - dailyUsage);

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
          {remaining} of {dailyLimit} free message{dailyLimit === 1 ? "" : "s"}{" "}
          left today
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
