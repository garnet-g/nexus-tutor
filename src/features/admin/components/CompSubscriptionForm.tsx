"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Field, Input, Select, Textarea } from "@/features/admin/components/adminForm";
import { Panel } from "@/features/admin/components/adminUi";
import { useConfirm } from "@/features/admin/components/ConfirmDialog";
import { toastError, toastSuccess } from "@/features/admin/components/toast";

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
  const { confirm, dialog } = useConfirm();

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();

    const ok = await confirm({
      title: `Grant ${planCode} comp?`,
      description: "This grants the plan with no payment taken. The action is audited.",
      confirmLabel: "Apply comp",
    });
    if (!ok) {
      return;
    }

    setIsSubmitting(true);

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
        toastError("Could not apply comp subscription", payload.error?.message);
        return;
      }

      toastSuccess(
        "Comp subscription granted",
        `${payload.data.planCode} (${payload.data.status}).`,
      );
      setReason("");
      setExpiresAt("");
    } catch {
      toastError("Network error", "Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <Panel
      title="Comp subscription"
      description="Manually grant a plan. This is a comp only — no payment is taken."
    >
      {dialog}
      <form onSubmit={handleSubmit} className="space-y-4">
        <Field label="Plan">
          <Select
            value={planCode}
            onChange={(event) => setPlanCode(event.target.value as CompPlanCode)}
          >
            {PLAN_OPTIONS.map((option) => (
              <option key={option.value} value={option.value}>
                {option.label}
              </option>
            ))}
          </Select>
        </Field>

        <Field label="Reason">
          <Textarea
            value={reason}
            onChange={(event) => setReason(event.target.value)}
            required
            minLength={3}
            maxLength={500}
            rows={3}
            placeholder="Why is this comp being granted?"
          />
        </Field>

        <Field label="Expires at (optional)">
          <Input
            type="datetime-local"
            value={expiresAt}
            onChange={(event) => setExpiresAt(event.target.value)}
          />
        </Field>

        <Button type="submit" disabled={isSubmitting} variant="primary">
          {isSubmitting ? "Applying…" : "Apply comp subscription"}
        </Button>
      </form>
    </Panel>
  );
}
