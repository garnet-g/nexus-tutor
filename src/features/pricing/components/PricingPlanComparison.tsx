"use client";

import { useState } from "react";
import { Check, Sparkles } from "lucide-react";
import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { cn } from "@/lib/utils";

interface PricingPlan {
  id: string;
  planCode: string;
  name: string;
  amountKes: number;
  billingCycle: string;
}

interface PricingPlanComparisonProps {
  config: EffectiveSubscriptionConfig;
  plans?: PricingPlan[];
  highlightPlan?: "free" | "premium" | "family";
  compact?: boolean;
}

function formatPromoEndsAt(endsAt: string | null): string | null {
  if (!endsAt) {
    return null;
  }

  const date = new Date(endsAt);
  if (Number.isNaN(date.getTime())) {
    return null;
  }

  return date.toLocaleDateString("en-KE", {
    weekday: "short",
    month: "short",
    day: "numeric",
  });
}

export function PricingPlanComparison({
  config,
  plans = [],
  highlightPlan = "premium",
  compact = false,
}: PricingPlanComparisonProps) {
  const { limits, pricing, promotion } = config;
  const promoEndsLabel = formatPromoEndsAt(promotion.endsAt);

  // Default fallback plans if dynamic list is empty
  const activePlans = plans.length > 0 ? plans : [
    { id: "premium_daily", planCode: "premium_daily", name: "Premium Daily", amountKes: pricing.premiumDailyAmountKes, billingCycle: "daily" },
    { id: "premium_weekly", planCode: "premium_weekly", name: "Premium Weekly", amountKes: pricing.premiumWeeklyAmountKes, billingCycle: "weekly" },
    { id: "premium", planCode: "premium", name: "Premium Monthly", amountKes: pricing.premiumAmountKes, billingCycle: "monthly" },
    { id: "premium_termly", planCode: "premium_termly", name: "Premium Termly", amountKes: pricing.premiumTermlyAmountKes, billingCycle: "termly" },
    { id: "family", planCode: "family", name: "Family Monthly", amountKes: pricing.familyAmountKes, billingCycle: "monthly" },
  ];

  // Selected billing cycle state for the interactive Premium Tutor card
  const [premiumCycle, setPremiumCycle] = useState<"daily" | "weekly" | "monthly" | "termly">("termly");

  // Helper to find amount for a billing cycle
  const getPremiumPlanAmount = (cycle: "daily" | "weekly" | "monthly" | "termly") => {
    const code = cycle === "monthly" ? "premium" : `premium_${cycle}`;
    const plan = activePlans.find((p) => p.planCode === code);
    return plan
      ? plan.amountKes
      : cycle === "daily"
        ? pricing.premiumDailyAmountKes
        : cycle === "weekly"
          ? pricing.premiumWeeklyAmountKes
          : cycle === "monthly"
            ? pricing.premiumAmountKes
            : pricing.premiumTermlyAmountKes;
  };

  const currentPremiumPrice = getPremiumPlanAmount(premiumCycle);

  const getPremiumSuffix = () => {
    switch (premiumCycle) {
      case "daily": return "/ day";
      case "weekly": return "/ week";
      case "monthly": return "/ month";
      case "termly": return "/ term (4 months)";
    }
  };

  const tiers = [
    {
      id: "free" as const,
      name: "Free Trial",
      priceLabel: "KES 0",
      suffix: " / forever",
      description: "Perfect for students starting out to explore guided study tools.",
      features: [
        `${limits.freeNex} AI chat messages per day`,
        `${limits.freePractice} practice topics per day`,
        "Baseline predicted grade diagnostic",
        "Personalized study recommendations",
      ],
      isPopular: false,
      badge: null,
    },
    {
      id: "premium" as const,
      name: "Premium Tutor",
      priceLabel: `KES ${currentPremiumPrice.toLocaleString()}`,
      suffix: ` ${getPremiumSuffix()}`,
      description: "Full exam prep suite with unlimited support, hints, and past papers.",
      features: [
        `${limits.premiumNex} AI chat messages per day`,
        `${limits.premiumPractice} practice sessions per day`,
        "AI Past Paper Repository & step-by-step marking",
        "7-day free trial on monthly option (once per student)",
        "Dynamic curriculum exam study plans",
      ],
      isPopular: true,
      badge: premiumCycle === "termly" ? "Best Value (Save 25%)" : "Highly Recommended",
    },
    {
      id: "family" as const,
      name: "Family Group",
      priceLabel: `KES ${pricing.familyAmountKes.toLocaleString()}`,
      suffix: " / month",
      description: "Ideal plan for parents managing tutoring and tracking multiple students.",
      features: [
        `Up to ${limits.familyMaxStudents} student profiles`,
        "Premium benefits unlocked for each student",
        "Parent dashboard with performance reports",
        "Lipa na M-Pesa automated billing integration",
      ],
      isPopular: false,
      badge: "Parent Favorite",
    },
  ];

  return (
    <div className="space-y-6">
      {promotion.isActive && promotion.title ? (
        <div className="relative overflow-hidden rounded-[20px] border border-nexus-success/20 bg-nexus-success-soft/30 px-5 py-4 shadow-sm backdrop-blur-md">
          <div className="absolute top-0 right-0 h-full w-32 bg-gradient-to-l from-nexus-success/10 to-transparent pointer-events-none" />
          <div className="flex items-center gap-2">
            <Sparkles className="size-4 text-nexus-success animate-pulse" />
            <p className="font-semibold text-foreground text-sm">{promotion.title}</p>
          </div>
          {promoEndsLabel ? (
            <p className="mt-1 text-xs text-muted-foreground">
              Offer ends {promoEndsLabel}
            </p>
          ) : null}
        </div>
      ) : null}

      <div
        className={cn(
          "grid gap-6 items-stretch",
          compact ? "sm:grid-cols-2 lg:grid-cols-3" : "md:grid-cols-3",
        )}
      >
        {tiers.map((tier) => {
          const isHighlighted = tier.id === highlightPlan;

          return (
            <article
              key={tier.id}
              className={cn(
                "relative flex flex-col justify-between rounded-[24px] border border-nexus-border bg-nexus-surface/80 p-6 shadow-[0_4px_24px_rgba(0,0,0,0.02)] transition-all hover:translate-y-[-2px] hover:shadow-[0_8px_32px_rgba(0,0,0,0.04)] backdrop-blur-md",
                isHighlighted &&
                  "border-nexus-primary/60 shadow-[0_8px_30px_rgba(var(--primary-rgb),0.06)] scale-[1.01] bg-nexus-surface-raised ring-4 ring-nexus-primary/5",
              )}
            >
              {isHighlighted && (
                <div className="absolute -top-3.5 left-1/2 -translate-x-1/2 flex items-center gap-1 rounded-full bg-nexus-primary px-4 py-1 text-[11px] font-bold uppercase tracking-wider text-nexus-text-inverse shadow-sm">
                  <Sparkles className="size-3" />
                  Most Popular
                </div>
              )}

              <div className="space-y-4">
                <div className="flex justify-between items-start">
                  <h3 className="font-heading text-xl font-bold tracking-tight text-foreground">
                    {tier.name}
                  </h3>
                  {tier.badge && (
                    <span className={cn(
                      "rounded-full px-2.5 py-0.5 text-[10px] font-bold tracking-wide shadow-sm",
                      tier.id === "premium" && premiumCycle === "termly"
                        ? "bg-nexus-success text-nexus-text-inverse"
                        : "bg-muted text-muted-foreground"
                    )}>
                      {tier.badge}
                    </span>
                  )}
                </div>

                <p className="text-xs text-muted-foreground line-clamp-2">
                  {tier.description}
                </p>

                {/* Sub-selector tabs specifically inside the Premium card */}
                {tier.id === "premium" && (
                  <div className="flex rounded-xl bg-nexus-sunken/60 p-1 mt-3 gap-0.5 border border-nexus-border/40">
                    {(["daily", "weekly", "monthly", "termly"] as const).map((cycle) => (
                      <button
                        key={cycle}
                        type="button"
                        onClick={() => setPremiumCycle(cycle)}
                        className={cn(
                          "flex-1 text-[10px] font-bold py-1.5 px-2 rounded-lg transition-all whitespace-nowrap",
                          premiumCycle === cycle
                            ? "bg-nexus-surface text-nexus-primary shadow-sm border border-nexus-border/50"
                            : "text-muted-foreground hover:text-foreground"
                        )}
                      >
                        {cycle === "termly" ? "Termly (-25%)" : cycle.charAt(0).toUpperCase() + cycle.slice(1)}
                      </button>
                    ))}
                  </div>
                )}

                <div className="pt-2">
                  <p className="font-heading text-4xl font-black tracking-tight tabular text-foreground">
                    {tier.priceLabel}
                    <span className="text-sm font-semibold text-muted-foreground ml-1">
                      {tier.suffix}
                    </span>
                  </p>
                  
                  {tier.id === "premium" && premiumCycle === "termly" && (
                    <p className="mt-1 text-[11px] font-medium text-nexus-success">
                      Save KES 796 compared to 4 monthly payments (KES 3,196 value)
                    </p>
                  )}
                </div>

                <div className="h-px bg-gradient-to-r from-transparent via-nexus-border to-transparent" />

                <ul className="space-y-2.5 text-xs text-muted-foreground">
                  {tier.features.map((feature) => (
                    <li key={feature} className="flex items-start gap-2.5">
                      <span className="flex size-4 shrink-0 items-center justify-center rounded-full bg-nexus-primary/10 text-nexus-primary mt-0.5">
                        <Check className="size-2.5 stroke-[3]" />
                      </span>
                      <span>{feature}</span>
                    </li>
                  ))}
                </ul>
              </div>
            </article>
          );
        })}
      </div>
    </div>
  );
}

export function formatPlanAmountKes(
  config: EffectiveSubscriptionConfig,
  planCode: string,
): number {
  if (planCode === "premium_daily") {
    return config.pricing.premiumDailyAmountKes;
  }

  if (planCode === "premium_weekly") {
    return config.pricing.premiumWeeklyAmountKes;
  }

  if (planCode === "premium_termly") {
    return config.pricing.premiumTermlyAmountKes;
  }

  if (planCode === "family") {
    return config.pricing.familyAmountKes;
  }

  return config.pricing.premiumAmountKes;
}
