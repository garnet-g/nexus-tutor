"use client";

import { useState } from "react";

import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";

interface PricingPlan {
  id: string;
  planCode: string;
  name: string;
  amountKes: number;
}

interface PricingCheckoutProps {
  config: EffectiveSubscriptionConfig;
  plans: PricingPlan[];
}

export function PricingCheckout({ config, plans }: PricingCheckoutProps) {
  const paidPlans = plans.filter((plan) => plan.planCode !== "free");
  const [selectedPlanId, setSelectedPlanId] = useState(paidPlans[0]?.id ?? "");
  const [phoneNumber, setPhoneNumber] = useState("+254");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const selectedPlan = paidPlans.find((plan) => plan.id === selectedPlanId);

  function resolveDisplayAmount(planCode: string): number {
    if (planCode === "family") {
      return config.pricing.familyAmountKes;
    }
    return config.pricing.premiumAmountKes;
  }

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
    <div className="space-y-6">
      <section className="grid gap-4 sm:grid-cols-2">
        {paidPlans.map((plan) => {
          const amount = resolveDisplayAmount(plan.planCode);
          const isSelected = plan.id === selectedPlanId;

          return (
            <button
              key={plan.id}
              type="button"
              onClick={() => setSelectedPlanId(plan.id)}
              className={`rounded-2xl border p-6 text-left transition ${
                isSelected
                  ? "border-primary bg-primary text-primary-foreground"
                  : "border-border bg-card text-foreground hover:border-border"
              }`}
            >
              <h2 className="text-lg font-medium">{plan.name}</h2>
              <p className="mt-2 text-2xl font-semibold">
                KES {amount.toLocaleString()}
                <span className="text-base font-normal opacity-70">/mo</span>
              </p>
              <p className="mt-2 text-sm opacity-80">
                {plan.planCode === "family"
                  ? `Up to ${config.limits.familyMaxStudents} students · ${config.limits.premiumNex} Nex/day each`
                  : `${config.limits.premiumNex} Nex messages · ${config.limits.premiumPractice} practice sessions per day`}
              </p>
            </button>
          );
        })}
      </section>

      {config.promotion.isActive && config.promotion.title ? (
        <section className="rounded-2xl border border-nexus-success/30 bg-nexus-success/10 p-4 text-sm text-nexus-secondary">
          {config.promotion.title}
        </section>
      ) : null}

      <section className="rounded-2xl border border-border bg-card p-6">
        <h2 className="text-lg font-medium text-foreground">Free plan limits</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          {config.limits.freeNex} Nex messages and {config.limits.freePractice} practice
          sessions per day — free forever.
        </p>
        <button
          type="button"
          onClick={handleStartTrial}
          disabled={isSubmitting}
          className="mt-4 rounded-lg border border-border px-4 py-2 text-sm font-medium text-foreground hover:bg-muted disabled:opacity-60"
        >
          Start 7-day premium trial
        </button>
      </section>

      <form
        onSubmit={handleCheckout}
        className="rounded-2xl border border-border bg-card p-6"
      >
        <h2 className="text-lg font-medium text-foreground">Pay with M-Pesa</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          {selectedPlan
            ? `Subscribe to ${selectedPlan.name} for KES ${resolveDisplayAmount(selectedPlan.planCode).toLocaleString()}/month.`
            : "Select a plan to continue."}
        </p>
        <label className="mt-4 block space-y-1 text-sm">
          <span className="text-muted-foreground">M-Pesa phone number</span>
          <input
            type="tel"
            value={phoneNumber}
            onChange={(event) => setPhoneNumber(event.target.value)}
            className="w-full rounded-lg border border-border px-3 py-2"
            required
          />
        </label>
        {error ? <p className="mt-2 text-sm text-red-600">{error}</p> : null}
        {success ? <p className="mt-2 text-sm text-nexus-success">{success}</p> : null}
        <button
          type="submit"
          disabled={isSubmitting || !selectedPlanId}
          className="mt-4 rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-60"
        >
          {isSubmitting ? "Processing..." : "Send STK push"}
        </button>
      </form>
    </div>
  );
}
