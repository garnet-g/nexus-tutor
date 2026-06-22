"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel } from "@/features/admin/components/adminUi";
import { cn } from "@/lib/utils";

type FlagStatus = "open" | "resolved" | "escalated";

type NexFlag = {
  id: string;
  messageId: string | null;
  sessionId: string | null;
  studentId: string | null;
  studentName: string | null;
  reason: string | null;
  source: "student" | "admin" | "system";
  status: FlagStatus;
  notes: string | null;
  resolvedBy: string | null;
  resolvedAt: string | null;
  createdAt: string;
  messagePreview: string | null;
  messageRole: "student" | "nex" | null;
};

interface NexFlagReviewPanelProps {
  initialFlags: NexFlag[];
  canWrite: boolean;
}

const STATUS_OPTIONS: { value: FlagStatus | ""; label: string }[] = [
  { value: "open", label: "Open" },
  { value: "escalated", label: "Escalated" },
  { value: "resolved", label: "Resolved" },
  { value: "", label: "All" },
];

function formatDate(iso: string): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(new Date(iso));
}

function StatusPill({ status }: { status: FlagStatus }) {
  const className =
    status === "open"
      ? "bg-nexus-danger/15 text-nexus-danger"
      : status === "escalated"
        ? "bg-amber-500/15 text-amber-300"
        : "bg-primary/15 text-primary";

  return (
    <span
      className={cn(
        "inline-flex rounded-full px-2.5 py-0.5 text-xs font-medium capitalize",
        className,
      )}
    >
      {status}
    </span>
  );
}

export function NexFlagReviewPanel({
  initialFlags,
  canWrite,
}: NexFlagReviewPanelProps) {
  const [flags, setFlags] = useState(initialFlags);
  const [status, setStatus] = useState<FlagStatus | "">("open");
  const [notesById, setNotesById] = useState<Record<string, string>>({});
  const [busyId, setBusyId] = useState<string | null>(null);
  const [isLoading, setIsLoading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function refresh(nextStatus = status) {
    setIsLoading(true);
    setError(null);
    setMessage(null);

    try {
      const params = new URLSearchParams({ limit: "100" });
      if (nextStatus) {
        params.set("status", nextStatus);
      }

      const response = await fetch(`/api/admin/nex-ops/flags?${params}`);
      const payload = (await response.json()) as {
        success: boolean;
        data?: { flags: NexFlag[] };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not load Nex flags.");
        return;
      }

      setFlags(payload.data.flags);
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsLoading(false);
    }
  }

  async function updateFlag(flagId: string, nextStatus: "resolved" | "escalated") {
    setBusyId(flagId);
    setError(null);
    setMessage(null);

    try {
      const response = await fetch(`/api/admin/nex-ops/flags/${flagId}`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          status: nextStatus,
          notes: notesById[flagId] || undefined,
        }),
      });
      const payload = (await response.json()) as {
        success: boolean;
        data?: { flag: NexFlag };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not update flag.");
        return;
      }

      setFlags((current) =>
        current.map((flag) =>
          flag.id === flagId ? payload.data?.flag ?? flag : flag,
        ),
      );
      setMessage(`Flag marked ${nextStatus}.`);
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setBusyId(null);
    }
  }

  return (
    <Panel
      title="Flagged conversation review"
      description={
        canWrite
          ? "Review flagged Nex messages and mark each item resolved or escalated."
          : "Support can review flags. Resolution actions require super admin."
      }
      padded={false}
      action={
        <div className="flex flex-wrap items-center gap-2">
          <select
            value={status}
            onChange={(event) => {
              const nextStatus = event.target.value as FlagStatus | "";
              setStatus(nextStatus);
              void refresh(nextStatus);
            }}
            className="rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
          >
            {STATUS_OPTIONS.map((option) => (
              <option key={option.value || "all"} value={option.value}>
                {option.label}
              </option>
            ))}
          </select>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={() => void refresh()}
            disabled={isLoading}
          >
            {isLoading ? "Refreshing..." : "Refresh"}
          </Button>
        </div>
      }
    >
      {error ? <p className="px-5 pt-4 text-sm text-nexus-danger">{error}</p> : null}
      {message ? <p className="px-5 pt-4 text-sm text-primary">{message}</p> : null}

      <div className="divide-y divide-nexus-border">
        {flags.length === 0 ? (
          <p className="px-5 py-10 text-center text-sm text-muted-foreground">
            No flags match this filter.
          </p>
        ) : (
          flags.map((flag) => (
            <article key={flag.id} className="space-y-4 px-5 py-4">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div className="space-y-1">
                  <div className="flex flex-wrap items-center gap-2">
                    <StatusPill status={flag.status} />
                    <span className="text-xs uppercase tracking-wide text-muted-foreground">
                      {flag.source}
                    </span>
                    <span className="text-xs text-muted-foreground">
                      {formatDate(flag.createdAt)}
                    </span>
                  </div>
                  <h3 className="font-heading text-base font-semibold text-foreground">
                    {flag.studentName ?? "Unknown student"}
                  </h3>
                  <p className="text-sm text-muted-foreground">
                    {flag.reason ?? "No flag reason supplied."}
                  </p>
                </div>
                {flag.messageRole ? (
                  <span className="rounded-full bg-nexus-sunken px-2.5 py-1 text-xs font-medium capitalize text-muted-foreground">
                    {flag.messageRole}
                  </span>
                ) : null}
              </div>

              <blockquote className="rounded-xl border border-nexus-border bg-nexus-sunken px-4 py-3 text-sm text-foreground">
                {flag.messagePreview ?? "Message content unavailable."}
              </blockquote>

              {flag.notes ? (
                <p className="text-sm text-muted-foreground">Notes: {flag.notes}</p>
              ) : null}

              {canWrite && flag.status === "open" ? (
                <div className="grid gap-3 md:grid-cols-[1fr_auto] md:items-end">
                  <label className="block space-y-1.5 text-sm">
                    <span className="text-muted-foreground">Review notes</span>
                    <textarea
                      value={notesById[flag.id] ?? ""}
                      onChange={(event) =>
                        setNotesById((current) => ({
                          ...current,
                          [flag.id]: event.target.value,
                        }))
                      }
                      maxLength={2000}
                      rows={2}
                      className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
                    />
                  </label>
                  <div className="flex flex-wrap gap-2">
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      onClick={() => void updateFlag(flag.id, "escalated")}
                      disabled={busyId === flag.id}
                    >
                      Escalate
                    </Button>
                    <Button
                      type="button"
                      variant="primary"
                      size="sm"
                      onClick={() => void updateFlag(flag.id, "resolved")}
                      disabled={busyId === flag.id}
                    >
                      Resolve
                    </Button>
                  </div>
                </div>
              ) : null}
            </article>
          ))
        )}
      </div>
    </Panel>
  );
}
