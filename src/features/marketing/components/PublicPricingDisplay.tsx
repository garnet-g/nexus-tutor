import Link from "next/link";

import { Button } from "@/components/ui/Button";
import { PricingPlanComparison } from "@/features/pricing/components/PricingPlanComparison";
import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";

interface PublicPricingDisplayProps {
  config: EffectiveSubscriptionConfig;
}

export function PublicPricingDisplay({ config }: PublicPricingDisplayProps) {
  return (
    <div className="flex flex-col gap-8">
      <PricingPlanComparison config={config} highlightPlan="premium" />

      <div className="flex flex-col items-center gap-3 text-center">
        <Button render={<Link href="/signup" />} size="lg" className="min-h-12 px-8">
          Create your free account
        </Button>
        <p className="text-sm text-muted-foreground">
          Prices load from live platform settings — no hidden fees.
        </p>
      </div>
    </div>
  );
}
