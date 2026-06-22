"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel } from "@/features/admin/components/adminUi";

type CompPlanCode = "premium" | "family" | "free";

interface CompSubscriptionFormProps {
  studentId: string;
}

const PLAN_OPTIONS: { value: CompPlanCode; label: string }[] = [
  { value: "premium", label: "Premium" },
  { value: "family", label: "Family" },
  { value: "free", label: "Free" },
];

export function CompSubscriptionForm({ studentId }: CompSubscriptionFormProps) {
  const [planCode, setPlanCode] = useState<CompPlanCode>("premium");
  const [reason, setReason] = useState("");
  const [expiresAt, setExpiresAt] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSubmitting(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch(`/api/admin/users/${studentId}/comp`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          planCode,
          reason,
          expiresAt: expiresAt ? new Date(expiresAt).toISOString() : null,
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: { planCode: string; status: string };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not apply comp subscription.");
        return;
      }

      setSuccess(
        `Granted ${payload.data.planCode} (${payload.data.status}).`,
      );
      setReason("");
      setExpiresAt("");
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <Panel
      title="Comp subscription"
      description="Manually grant a plan. This is a comp only — no payment is taken."
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <label className="block space-y-1.5 text-sm">
          <span className="text-muted-foreground">Plan</span>
          <select
            value={planCode}
            onChange={(event) => setPlanCode(event.target.value as CompPlanCode)}
            className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
          >
            {PLAN_OPTIONS.map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </select>
        </label>

        <label className="block space-y-1.5 text-sm">
          <span className="text-muted-foreground">Reason</span>
          <textarea
            value={reason}
            onChange={(event) => setReason(event.target.value)}
            required
            minLength={3}
            maxLength={500}
            rows={3}
            placeholder="Why is this comp being granted?"
            className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
          />
        </label>

        <label className="block space-y-1.5 text-sm">
          <span className="text-muted-foreground">Expires at (optional)</span>
          <input
            type="datetime-local"
            value={expiresAt}
            onChange={(event) => setExpiresAt(event.target.value)}
            className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
          />
        </label>

        {error ? <p className="text-sm text-nexus-danger">{error}</p> : null}
        {success ? <p className="text-sm text-primary">{success}</p> : null}

        <Button type="submit" disabled={isSubmitting} variant="primary">
          {isSubmitting ? "Applying…" : "Apply comp subscription"}
        </Button>
      </form>
    </Panel>
  );
}
