"use client";

import { useState } from "react";

import { PricingCheckout } from "@/features/pricing/components/PricingCheckout";
import { readPendingPayment } from "@/features/pricing/lib/pendingPaymentStorage";
import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";

interface PricingPlan {
  id: string;
  planCode: string;
  name: string;
  amountKes: number;
}

interface PricingCheckoutShellProps {
  config: EffectiveSubscriptionConfig;
  plans: PricingPlan[];
  hasUsedTrial: boolean;
  currentPlanCode: string;
}

export function PricingCheckoutShell(props: PricingCheckoutShellProps) {
  const [initialPendingPaymentId] = useState(
    () => readPendingPayment()?.mpesaPaymentId ?? null,
  );

  return (
    <PricingCheckout
      {...props}
      initialPendingPaymentId={initialPendingPaymentId}
    />
  );
}
