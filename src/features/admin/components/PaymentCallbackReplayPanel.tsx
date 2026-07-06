"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { inputVariants } from "@/components/ui/Input";
import { Panel } from "@/features/admin/components/adminUi";
import { cn } from "@/lib/utils";

interface PaymentCallbackReplayPanelProps {
  canWrite: boolean;
}

export function PaymentCallbackReplayPanel({
  canWrite,
}: PaymentCallbackReplayPanelProps) {
  const [eventId, setEventId] = useState("");
  const [message, setMessage] = useState<string | null>(null);
  const [isSubmitting, setIsSubmitting] = useState(false);

  async function handleReplay(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    if (!canWrite) {
      return;
    }

    setIsSubmitting(true);
    setMessage(null);

    try {
      const response = await fetch("/api/admin/payments/replay-callback", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ eventId }),
      });
      const payload = (await response.json()) as {
        success: boolean;
        data?: { replayed: boolean; reason?: string; status?: string };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setMessage(payload.error?.message ?? "Replay failed.");
        return;
      }

      if (payload.data.replayed) {
        setMessage(`Replay executed. Payment status: ${payload.data.status ?? "unknown"}.`);
      } else {
        setMessage(
          `No-op: ${payload.data.reason ?? "already processed"}${payload.data.status ? ` (${payload.data.status})` : ""}.`,
        );
      }
    } catch {
      setMessage("Network error while replaying callback event.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <Panel
      title="Callback replay"
      description="Idempotent operator replay for stored M-Pesa callback events. Already-processed terminal payments are a no-op."
    >
      <form onSubmit={handleReplay} className="flex flex-col gap-3 sm:flex-row sm:items-end">
        <label className="block flex-1 space-y-2 text-sm">
          <span className="font-medium text-foreground">Callback event ID</span>
          <input
            type="text"
            value={eventId}
            onChange={(event) => setEventId(event.target.value)}
            className={cn(inputVariants(), "min-h-11 font-mono text-sm")}
            placeholder="00000000-0000-4000-8000-000000000000"
            required
            disabled={!canWrite || isSubmitting}
          />
        </label>
        <Button
          type="submit"
          className="min-h-11"
          disabled={!canWrite || isSubmitting || eventId.trim().length === 0}
        >
          {isSubmitting ? "Replaying…" : "Replay callback"}
        </Button>
      </form>
      {message ? (
        <p className="mt-3 text-sm text-muted-foreground" role="status">
          {message}
        </p>
      ) : null}
    </Panel>
  );
}
