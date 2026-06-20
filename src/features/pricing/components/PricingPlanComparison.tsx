import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { cn } from "@/lib/utils";

interface PricingPlanComparisonProps {
  config: EffectiveSubscriptionConfig;
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
  highlightPlan = "premium",
  compact = false,
}: PricingPlanComparisonProps) {
  const { limits, pricing, promotion } = config;
  const promoEndsLabel = formatPromoEndsAt(promotion.endsAt);

  const tiers = [
    {
      id: "free" as const,
      name: "Free",
      priceLabel: "KES 0",
      suffix: "/ forever",
      features: [
        `${limits.freeNex} Nex messages per day`,
        `${limits.freePractice} practice sessions per day`,
        "Diagnostic & predicted grade",
        "Daily study recommendations",
      ],
    },
    {
      id: "premium" as const,
      name: "Premium",
      priceLabel: `KES ${pricing.premiumAmountKes.toLocaleString()}`,
      suffix: "/ month",
      features: [
        `${limits.premiumNex} Nex messages per day`,
        `${limits.premiumPractice} practice sessions per day`,
        "14-day exam study plans",
        "7-day free trial (once per student)",
      ],
    },
    {
      id: "family" as const,
      name: "Family",
      priceLabel: `KES ${pricing.familyAmountKes.toLocaleString()}`,
      suffix: "/ month",
      features: [
        `Up to ${limits.familyMaxStudents} student accounts`,
        "Premium limits for each student",
        "Parent dashboard per linked child",
        "Pay with M-Pesa after signup",
      ],
    },
  ];

  return (
    <div className="space-y-4">
      {promotion.isActive && promotion.title ? (
        <div className="rounded-[18px] border border-nexus-success/30 bg-nexus-success-soft/50 px-4 py-3 text-sm text-foreground">
          <p className="font-medium">{promotion.title}</p>
          {promoEndsLabel ? (
            <p className="mt-1 text-muted-foreground">
              Offer ends {promoEndsLabel}
            </p>
          ) : null}
        </div>
      ) : null}

      <div
        className={cn(
          "grid gap-4",
          compact ? "sm:grid-cols-2 lg:grid-cols-3" : "md:grid-cols-3",
        )}
      >
        {tiers.map((tier) => {
          const isHighlighted = tier.id === highlightPlan;

          return (
            <article
              key={tier.id}
              className={cn(
                "rounded-[22px] border border-nexus-border bg-nexus-surface p-5 shadow-card",
                isHighlighted &&
                  "border-nexus-primary ring-2 ring-nexus-primary/15",
              )}
            >
              {isHighlighted ? (
                <p className="mb-2 text-xs font-medium uppercase tracking-wide text-nexus-primary">
                  Most popular
                </p>
              ) : null}
              <h3 className="font-heading text-lg font-semibold text-foreground">
                {tier.name}
              </h3>
              <p className="mt-2 font-heading text-3xl font-semibold tabular text-foreground">
                {tier.priceLabel}
                <span className="text-base font-normal text-muted-foreground">
                  {tier.suffix}
                </span>
              </p>
              <ul className="mt-4 space-y-2 text-sm text-muted-foreground">
                {tier.features.map((feature) => (
                  <li key={feature}>{feature}</li>
                ))}
              </ul>
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
  if (planCode === "family") {
    return config.pricing.familyAmountKes;
  }

  return config.pricing.premiumAmountKes;
}
