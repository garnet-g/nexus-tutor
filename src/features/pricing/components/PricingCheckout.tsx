"use client";

import { useEffect, useRef, useState } from "react";
import Link from "next/link";
import { CreditCard, Sparkles } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import { inputVariants } from "@/components/ui/Input";
import { PricingPlanComparison } from "@/features/pricing/components/PricingPlanComparison";
import {
  clearPendingPayment,
  savePendingPayment,
} from "@/features/pricing/lib/pendingPaymentStorage";
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
  initialPendingPaymentId?: string | null;
}

const TERMINAL_STATUSES = new Set([
  "verified-paid",
  "verified-failed",
  "expired",
  "refunded",
]);

const POLL_INTERVAL_MS = 2500;

function getBillingCycleSuffix(planCode: string): string {
  if (planCode.includes("daily")) {
    return "/day";
  }
  if (planCode.includes("weekly")) {
    return "/week";
  }
  if (planCode.includes("termly")) {
    return "/term";
  }
  return "/mo";
}

export function PricingCheckout({
  config,
  plans,
  hasUsedTrial,
  currentPlanCode,
  initialPendingPaymentId = null,
}: PricingCheckoutProps) {
  const paidPlans = plans.filter((plan) => plan.planCode !== "free");
  const [selectedPlanId, setSelectedPlanId] = useState(paidPlans[0]?.id ?? "");
  const [phoneNumber, setPhoneNumber] = useState("+254");
  const [isSubmitting, setIsSubmitting] = useState(Boolean(initialPendingPaymentId));
  const [error, setError] = useState<string | null>(null);
  const [checkoutRecoverable, setCheckoutRecoverable] = useState(false);
  const [success, setSuccess] = useState<string | null>(null);
  const [paymentStatus, setPaymentStatus] = useState<string | null>(
    initialPendingPaymentId ? "processing" : null,
  );
  const [isResumingPayment, setIsResumingPayment] = useState(
    Boolean(initialPendingPaymentId),
  );
  const pollTimerRef = useRef<ReturnType<typeof setInterval> | null>(null);

  const [mpesaCode, setMpesaCode] = useState("");
  const [isManualSubmitting, setIsManualSubmitting] = useState(false);
  const [manualError, setManualError] = useState<string | null>(null);
  const [manualSuccess, setManualSuccess] = useState<string | null>(null);

  const selectedPlan = paidPlans.find((plan) => plan.id === selectedPlanId);
  const showManualFallback =
    Boolean(selectedPlan) &&
    (checkoutRecoverable ||
      (paymentStatus !== null && paymentStatus !== "verified-paid"));

  useEffect(() => {
    if (!initialPendingPaymentId) {
      return;
    }

    savePendingPayment({ mpesaPaymentId: initialPendingPaymentId });
    void pollPaymentStatus(initialPendingPaymentId);
    pollTimerRef.current = setInterval(() => {
      void pollPaymentStatus(initialPendingPaymentId);
    }, POLL_INTERVAL_MS);

    return () => {
      stopPolling();
    };
  }, [initialPendingPaymentId]);

  function stopPolling() {
    if (pollTimerRef.current) {
      clearInterval(pollTimerRef.current);
      pollTimerRef.current = null;
    }
  }

  async function pollPaymentStatus(mpesaPaymentId: string) {
    try {
      const response = await fetch(
        `/api/mpesa/status?mpesaPaymentId=${encodeURIComponent(mpesaPaymentId)}`,
      );
      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          status: string;
          statusLabel: string;
          isTerminal: boolean;
          failureHint: string | null;
          planName: string;
        };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not check payment status.");
        stopPolling();
        setIsSubmitting(false);
        return;
      }

      setPaymentStatus(payload.data.status);

      if (payload.data.status === "verified-paid") {
        stopPolling();
        setIsSubmitting(false);
        clearPendingPayment();
        setSuccess(
          `${payload.data.planName} is now active. Thank you for your payment.`,
        );
        return;
      }

      if (TERMINAL_STATUSES.has(payload.data.status)) {
        stopPolling();
        setIsSubmitting(false);
        clearPendingPayment();
        setError(
          payload.data.failureHint ??
            "Payment did not complete. You can try again — no charge was applied.",
        );
      }
    } catch {
      stopPolling();
      setIsSubmitting(false);
      setError(
        "We could not confirm your payment. If M-Pesa shows a charge, contact support with your receipt.",
      );
    }
  }

  function startPolling(mpesaPaymentId: string) {
    savePendingPayment({ mpesaPaymentId });
    setPaymentStatus("processing");
    void pollPaymentStatus(mpesaPaymentId);

    pollTimerRef.current = setInterval(() => {
      void pollPaymentStatus(mpesaPaymentId);
    }, POLL_INTERVAL_MS);
  }

  function clearCheckoutFeedback() {
    setError(null);
    setCheckoutRecoverable(false);
    setSuccess(null);
  }

  function setCheckoutFailure(message: string, options?: { recoverable?: boolean; code?: string }) {
    const recoverable =
      options?.recoverable ??
      (options?.code === "MPESA_PAYMENT_FAILED" ||
        options?.code === "RATE_LIMITED");

    if (recoverable) {
      if (options?.code === "MPESA_PAYMENT_FAILED") {
        setError(
          "M-Pesa is temporarily unavailable. No charge was made — you can try again.",
        );
      } else if (options?.code === "RATE_LIMITED") {
        setError(message);
      } else {
        setError(message);
      }
      setCheckoutRecoverable(true);
      return;
    }

    setError(message);
    setCheckoutRecoverable(false);
  }

  async function handleStartTrial() {
    setIsSubmitting(true);
    clearCheckoutFeedback();

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
    clearCheckoutFeedback();
    setPaymentStatus(null);
    setIsResumingPayment(false);
    stopPolling();

    let pollingStarted = false;

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
        data?: { mpesaPaymentId: string; amountKes: number; expiresAt: string };
        error?: { code?: string; message: string };
      };

      if (!response.ok || !payload.success || !payload.data?.mpesaPaymentId) {
        setCheckoutFailure(payload.error?.message ?? "Payment could not be initiated.", {
          code: payload.error?.code,
          recoverable:
            response.status === 502 ||
            response.status === 429 ||
            payload.error?.code === "MPESA_PAYMENT_FAILED" ||
            payload.error?.code === "RATE_LIMITED",
        });
        return;
      }

      setSuccess("STK push sent. Complete payment on your phone.");
      setIsResumingPayment(false);
      startPolling(payload.data.mpesaPaymentId);
      pollingStarted = true;
    } catch {
      setCheckoutFailure(
        "Network error while reaching M-Pesa. No charge was made — you can try again.",
        { recoverable: true },
      );
    } finally {
      if (!pollingStarted) {
        setIsSubmitting(false);
      }
    }
  }

  async function handleManualReconcile(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!selectedPlan) {
      return;
    }

    setIsManualSubmitting(true);
    setManualError(null);
    setManualSuccess(null);

    try {
      const response = await fetch("/api/mpesa/reconcile-manual", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          subscriptionPlanId: selectedPlan.id,
          mpesaCode,
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: { status: string; activated: boolean; message: string };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setManualError(payload.error?.message ?? "Could not verify this code.");
        return;
      }

      setManualSuccess(payload.data.message);
      setMpesaCode("");

      if (payload.data.activated) {
        stopPolling();
        clearPendingPayment();
        setPaymentStatus("verified-paid");
      }
    } catch {
      setManualError("Network error. Please try again.");
    } finally {
      setIsManualSubmitting(false);
    }
  }

  return (
    <div className="space-y-8">
      <PricingPlanComparison config={config} highlightPlan="premium" compact />

      <SectionCard title="Choose a paid plan">
        <div className="grid gap-3 sm:grid-cols-2">
          {paidPlans.map((plan) => {
            const amount = plan.amountKes;
            const isSelected = plan.id === selectedPlanId;
            const isTermly = plan.planCode === "premium_termly";

            return (
              <button
                key={plan.id}
                type="button"
                onClick={() => setSelectedPlanId(plan.id)}
                className={cn(
                  "relative min-h-[120px] rounded-[18px] border p-5 text-left transition-all hover:scale-[1.01] focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
                  isSelected
                    ? "border-nexus-primary bg-nexus-primary text-nexus-text-inverse shadow-card"
                    : "border-nexus-border bg-nexus-surface text-foreground hover:bg-nexus-sunken",
                )}
              >
                {isTermly && (
                  <span className={cn(
                    "absolute top-3 right-3 rounded-full px-2 py-0.5 text-[9px] font-bold uppercase tracking-wider shadow-sm",
                    isSelected ? "bg-nexus-surface text-nexus-primary" : "bg-nexus-success text-nexus-text-inverse"
                  )}>
                    Save 25%
                  </span>
                )}
                <h2 className="font-heading text-lg font-semibold flex items-center gap-1.5">
                  {plan.name}
                  {plan.planCode === "premium" && (
                    <Sparkles className={cn("size-3.5", isSelected ? "text-nexus-text-inverse" : "text-nexus-primary")} />
                  )}
                </h2>
                <p className="mt-2 font-heading text-2xl font-semibold tabular">
                  KES {amount.toLocaleString()}
                  <span className="text-base font-normal opacity-85 ml-0.5">
                    {getBillingCycleSuffix(plan.planCode)}
                  </span>
                </p>
                <p className="mt-2 text-xs opacity-90 leading-relaxed">
                  {plan.planCode === "family"
                    ? `Up to ${config.limits.familyMaxStudents} students · Parent reports dashboard`
                    : plan.planCode === "premium_termly"
                      ? `${config.limits.premiumNex} Nex · past papers + AI marking (Best Value)`
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
            ? `Subscribe to ${selectedPlan.name} for KES ${selectedPlan.amountKes.toLocaleString()}${getBillingCycleSuffix(selectedPlan.planCode)}.`
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
            <p
              className="text-sm text-nexus-danger"
              role="alert"
              data-testid={checkoutRecoverable ? "checkout-provider-error" : undefined}
            >
              {error}
            </p>
          ) : null}
          {success ? (
            <p className="text-sm text-nexus-success" role="status">
              {success}
            </p>
          ) : null}
          {isResumingPayment ? (
            <p className="text-sm text-muted-foreground" role="status">
              Resuming your pending payment…
            </p>
          ) : null}
          {paymentStatus && !error ? (
            <p className="text-sm text-muted-foreground" role="status">
              {paymentStatus === "provider-pending"
                ? "Confirming payment with M-Pesa…"
                : "Waiting for payment on your phone…"}
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

      {showManualFallback && selectedPlan ? (
        <SectionCard
          title="Pay via Lipa na M-Pesa"
          description="If the STK push doesn't arrive, pay manually using Paybill and confirm your transaction code below."
        >
          <div className="space-y-4">
            <div className="rounded-[14px] border border-nexus-border bg-nexus-sunken p-4 text-sm text-foreground">
              <p>Go to M-Pesa &gt; Lipa na M-Pesa &gt; Paybill</p>
              <p className="mt-1">
                Business number: <span className="font-medium">{process.env.NEXT_PUBLIC_MPESA_PAYBILL ?? "[Paybill]"}</span>
              </p>
              <p className="mt-1">
                Account number: <span className="font-medium">{selectedPlan.planCode}</span>
              </p>
              <p className="mt-1">
                Amount: <span className="font-medium">KES {selectedPlan.amountKes.toLocaleString()}</span>
              </p>
            </div>

            <form onSubmit={handleManualReconcile} className="space-y-3">
              <label className="block space-y-2 text-sm">
                <span className="font-medium text-foreground">M-Pesa transaction code</span>
                <input
                  type="text"
                  value={mpesaCode}
                  onChange={(event) => setMpesaCode(event.target.value.toUpperCase())}
                  placeholder="e.g. QAB1C2D3E4"
                  className={cn(inputVariants(), "min-h-12 uppercase")}
                  required
                />
              </label>
              {manualError ? (
                <p className="text-sm text-nexus-danger" role="alert">
                  {manualError}
                </p>
              ) : null}
              {manualSuccess ? (
                <p className="text-sm text-nexus-success" role="status">
                  {manualSuccess}
                </p>
              ) : null}
              <Button
                type="submit"
                variant="outline"
                disabled={isManualSubmitting || !mpesaCode}
                className="min-h-12"
              >
                {isManualSubmitting ? "Verifying..." : "Confirm transaction code"}
              </Button>
            </form>
          </div>
        </SectionCard>
      ) : null}

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
