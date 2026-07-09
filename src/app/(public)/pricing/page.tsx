import Link from "next/link";
import { redirect } from "next/navigation";

import { PricingCheckoutShell } from "@/features/pricing/components/PricingCheckoutShell";
import { PublicPricingDisplay } from "@/features/marketing/components/PublicPricingDisplay";
import {
  getEffectiveSubscriptionConfigWithFallback,
} from "@/lib/platform/getPlatformSettings";
import { createAdminClient } from "@/lib/supabase/admin";
import { getSessionUser } from "@/server/services/authService";
import {
  getStudentPlanCode,
  hasUsedFreeTrial,
} from "@/server/services/subscriptionService";

export const dynamic = "force-dynamic";

export default async function PublicPricingPage() {
  const config = await getEffectiveSubscriptionConfigWithFallback();
  const sessionUser = await getSessionUser();
  const studentProfile = sessionUser?.studentProfile;

  if (sessionUser && !studentProfile) {
    redirect("/login");
  }

  const isStudent = Boolean(studentProfile);

  let pricingPlans: Array<{
    id: string;
    planCode: string;
    name: string;
    amountKes: number;
    billingCycle: string;
  }> = [];

  try {
    const admin = createAdminClient();
    const { data: plans } = await admin
      .from("subscription_plans")
      .select("id, plan_code, name, amount_kes, billing_cycle, is_active")
      .eq("is_active", true)
      .order("amount_kes", { ascending: true });

    pricingPlans =
      plans?.map((plan) => ({
        id: plan.id,
        planCode: plan.plan_code,
        name: plan.name,
        amountKes:
          plan.plan_code === "premium"
            ? config.pricing.premiumAmountKes
            : plan.plan_code === "family"
              ? config.pricing.familyAmountKes
              : plan.amount_kes,
        billingCycle: plan.billing_cycle,
      })) ?? [];
  } catch {
    pricingPlans = [
      {
        id: "premium_daily",
        planCode: "premium_daily",
        name: "Premium Daily",
        amountKes: 20,
        billingCycle: "daily",
      },
      {
        id: "premium_weekly",
        planCode: "premium_weekly",
        name: "Premium Weekly",
        amountKes: 150,
        billingCycle: "weekly",
      },
      {
        id: "premium",
        planCode: "premium",
        name: "Premium Monthly",
        amountKes: config.pricing.premiumAmountKes,
        billingCycle: "monthly",
      },
      {
        id: "premium_termly",
        planCode: "premium_termly",
        name: "Premium Termly",
        amountKes: 2400,
        billingCycle: "termly",
      },
      {
        id: "family",
        planCode: "family",
        name: "Family Monthly",
        amountKes: config.pricing.familyAmountKes,
        billingCycle: "monthly",
      },
    ];
  }

  let planCode = "free";
  let hasUsedTrial = false;

  if (studentProfile) {
    [planCode, hasUsedTrial] = await Promise.all([
      getStudentPlanCode(studentProfile.id),
      hasUsedFreeTrial(studentProfile.id),
    ]);
  }

  return (
    <div className="mx-auto max-w-6xl px-4 py-12 sm:px-6 sm:py-16">
      {isStudent ? (
        <div className="mb-8">
          <Link
            href="/dashboard"
            className="text-sm font-medium text-nexus-primary transition-colors hover:text-nexus-primary-dark"
          >
            ← Back to Today
          </Link>
        </div>
      ) : null}

      <div className="mx-auto max-w-2xl space-y-3 text-center">
        <p className="text-xs font-medium uppercase tracking-[0.14em] text-nexus-primary">
          Pricing
        </p>
        <h1 className="font-heading text-3xl font-bold tracking-tight text-foreground sm:text-4xl">
          {isStudent ? "Choose your plan" : "Simple, honest pricing"}
        </h1>
        <p className="text-base text-muted-foreground">
          {isStudent
            ? "Upgrade for higher daily limits. All amounts load from live platform settings."
            : "Start free forever. Upgrade when you need higher daily limits."}
        </p>
      </div>

      <div className="mt-10">
        {isStudent ? (
          <PricingCheckoutShell
            config={config}
            plans={pricingPlans}
            hasUsedTrial={hasUsedTrial}
            currentPlanCode={planCode}
          />
        ) : (
          <PublicPricingDisplay config={config} plans={pricingPlans} />
        )}
      </div>
    </div>
  );
}
