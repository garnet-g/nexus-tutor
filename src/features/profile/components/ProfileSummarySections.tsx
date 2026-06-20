import Link from "next/link";
import { MessageCircle, Target } from "lucide-react";

import { SectionCard } from "@/components/ui/SectionCard";
import { Button } from "@/components/ui/Button";
import { BarMeter } from "@/components/widgets/Charts";
import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import {
  getNexDailyLimit,
  getPracticeDailyLimit,
} from "@/lib/platform/getPlatformSettings";

interface ProfileUsageSummaryProps {
  planCode: string;
  nexUsage: number;
  practiceUsage: number;
  config: EffectiveSubscriptionConfig;
}

export function ProfileUsageSummary({
  planCode,
  nexUsage,
  practiceUsage,
  config,
}: ProfileUsageSummaryProps) {
  const nexLimit = getNexDailyLimit(config, planCode);
  const practiceLimit = getPracticeDailyLimit(config, planCode);
  const nexRemaining = Math.max(0, nexLimit - nexUsage);
  const practiceRemaining = Math.max(0, practiceLimit - practiceUsage);

  return (
    <SectionCard
      title="Today's usage"
      description="Resets at midnight Nairobi time. Core learning stays free — upgrade for higher limits."
    >
      <div className="space-y-4">
        <div className="space-y-2">
          <BarMeter
            value={nexUsage}
            max={nexLimit}
            label="Nex messages"
            showValue
          />
          <p className="text-xs text-muted-foreground">
            {nexRemaining} of {nexLimit} free message
            {nexLimit === 1 ? "" : "s"} left today
          </p>
        </div>
        <div className="space-y-2">
          <BarMeter
            value={practiceUsage}
            max={practiceLimit}
            label="Practice sessions"
            showValue
          />
          <p className="text-xs text-muted-foreground">
            {practiceRemaining} of {practiceLimit} session
            {practiceLimit === 1 ? "" : "s"} left today
          </p>
        </div>
        {planCode === "free" ? (
          <Button render={<Link href="/pricing" />} className="min-h-12">
            View Premium plans
          </Button>
        ) : null}
      </div>
    </SectionCard>
  );
}

interface ProfileAccountSummaryProps {
  curriculum: string;
  gradeLevel: string;
  planCode: string;
  email: string | null;
  fullName: string;
}

export function ProfileAccountSummary({
  curriculum,
  gradeLevel,
  planCode,
  email,
  fullName,
}: ProfileAccountSummaryProps) {
  return (
    <SectionCard title="Account" description={`Signed in as ${fullName}`}>
      <dl className="grid gap-4 sm:grid-cols-2">
        <div>
          <dt className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            Curriculum
          </dt>
          <dd className="mt-1 font-medium text-foreground">{curriculum}</dd>
        </div>
        <div>
          <dt className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            Grade
          </dt>
          <dd className="mt-1 font-medium text-foreground">{gradeLevel}</dd>
        </div>
        <div>
          <dt className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            Plan
          </dt>
          <dd className="mt-1 font-medium capitalize text-foreground">
            {planCode}
          </dd>
        </div>
        <div>
          <dt className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
            Email
          </dt>
          <dd className="mt-1 font-medium text-foreground">{email ?? "—"}</dd>
        </div>
      </dl>
      <div className="mt-4 flex flex-wrap gap-2">
        <Button
          variant="outline"
          size="sm"
          render={<Link href="/nex" />}
          className="min-h-12"
        >
          <MessageCircle className="size-4" data-icon="inline-start" />
          Open Nex
        </Button>
        <Button
          variant="outline"
          size="sm"
          render={<Link href="/practice" />}
          className="min-h-12"
        >
          <Target className="size-4" data-icon="inline-start" />
          Practice
        </Button>
      </div>
    </SectionCard>
  );
}
