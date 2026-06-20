"use client";

import { useState } from "react";
import Link from "next/link";
import { CreditCard, Sparkles } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import { inputVariants } from "@/components/ui/Input";
import {
  formatPlanAmountKes,
  PricingPlanComparison,
} from "@/features/pricing/components/PricingPlanComparison";
import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { cn } from "@/lib/utils";

interface PricingPlan {
  id: string;
  planCode: string;
  name: string;
  amountKes: number;
}

interface PricingCheckoutProps {
  config: EffectiveSubscriptionConfig;
  plans: PricingPlan[];
  hasUsedTrial: boolean;
  currentPlanCode: string;
}

export function PricingCheckout({
  config,
  plans,
  hasUsedTrial,
  currentPlanCode,
}: PricingCheckoutProps) {
  const paidPlans = plans.filter((plan) => plan.planCode !== "free");
  const [selectedPlanId, setSelectedPlanId] = useState(paidPlans[0]?.id ?? "");
  const [phoneNumber, setPhoneNumber] = useState("+254");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const selectedPlan = paidPlans.find((plan) => plan.id === selectedPlanId);

  async function handleStartTrial() {
    setIsSubmitting(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch("/api/subscriptions/trial", {
        method: "POST",
      });
      const payload = (await response.json()) as {
        success: boolean;
        data?: { trialEndsAt: string };
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        setError(payload.error?.message ?? "Could not start trial.");
        return;
      }

      setSuccess(
        `Trial started. Premium access until ${new Date(payload.data?.trialEndsAt ?? "").toLocaleDateString()}.`,
      );
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  async function handleCheckout(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSubmitting(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch("/api/mpesa/stk-push", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          subscriptionPlanId: selectedPlanId,
          phoneNumber,
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: { mpesaPaymentId: string; isMock?: boolean };
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        setError(payload.error?.message ?? "Payment could not be initiated.");
        return;
      }

      setSuccess(
        payload.data?.isMock
          ? "Mock payment completed. Your plan is now active."
          : "STK push sent. Complete payment on your phone.",
      );
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <div className="space-y-8">
      <PricingPlanComparison config={config} highlightPlan="premium" compact />

      <SectionCard title="Choose a paid plan">
        <div className="grid gap-3 sm:grid-cols-2">
          {paidPlans.map((plan) => {
            const amount = formatPlanAmountKes(config, plan.planCode);
            const isSelected = plan.id === selectedPlanId;

            return (
              <button
                key={plan.id}
                type="button"
                onClick={() => setSelectedPlanId(plan.id)}
                className={cn(
                  "min-h-[120px] rounded-[18px] border p-5 text-left transition-colors focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
                  isSelected
                    ? "border-nexus-primary bg-nexus-primary text-nexus-text-inverse shadow-card"
                    : "border-nexus-border bg-nexus-surface text-foreground hover:bg-nexus-sunken",
                )}
              >
                <h2 className="font-heading text-lg font-semibold">{plan.name}</h2>
                <p className="mt-2 font-heading text-2xl font-semibold tabular">
                  KES {amount.toLocaleString()}
                  <span className="text-base font-normal opacity-80">/mo</span>
                </p>
                <p className="mt-2 text-sm opacity-90">
                  {plan.planCode === "family"
                    ? `Up to ${config.limits.familyMaxStudents} students`
                    : `${config.limits.premiumNex} Nex · ${config.limits.premiumPractice} practice/day`}
                </p>
              </button>
            );
          })}
        </div>
      </SectionCard>

      {currentPlanCode === "free" ? (
        <SectionCard
          title="7-day Premium trial"
          description="Try exam study plans and higher daily limits — once per student."
        >
          {hasUsedTrial ? (
            <p className="text-sm text-muted-foreground">
              You have already used your free trial.
            </p>
          ) : (
            <Button
              type="button"
              variant="outline"
              className="min-h-12"
              disabled={isSubmitting}
              onClick={() => void handleStartTrial()}
            >
              <Sparkles className="size-4" data-icon="inline-start" />
              Start 7-day premium trial
            </Button>
          )}
        </SectionCard>
      ) : null}

      <SectionCard
        title="Pay with M-Pesa"
        description={
          selectedPlan
            ? `Subscribe to ${selectedPlan.name} for KES ${formatPlanAmountKes(config, selectedPlan.planCode).toLocaleString()}/month.`
            : "Select a plan to continue."
        }
      >
        <form onSubmit={handleCheckout} className="space-y-4">
          <label className="block space-y-2 text-sm">
            <span className="font-medium text-foreground">M-Pesa phone number</span>
            <input
              type="tel"
              value={phoneNumber}
              onChange={(event) => setPhoneNumber(event.target.value)}
              className={cn(inputVariants(), "min-h-12")}
              required
            />
          </label>
          {error ? (
            <p className="text-sm text-nexus-danger" role="alert">
              {error}
            </p>
          ) : null}
          {success ? (
            <p className="text-sm text-nexus-success" role="status">
              {success}
            </p>
          ) : null}
          <Button
            type="submit"
            disabled={isSubmitting || !selectedPlanId}
            className="min-h-12"
          >
            <CreditCard className="size-4" data-icon="inline-start" />
            {isSubmitting ? "Processing..." : "Send STK push"}
          </Button>
        </form>
      </SectionCard>

      <p className="text-center text-sm text-muted-foreground">
        <Link href="/dashboard" className="text-nexus-primary hover:underline">
          Back to Today
        </Link>
        {" · "}
        Core learning stays free — upgrade only raises daily limits.
      </p>
    </div>
  );
}
