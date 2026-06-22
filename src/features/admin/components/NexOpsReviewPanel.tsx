"use client";

import { CheckCircle2, RefreshCw, TriangleAlert } from "lucide-react";
import { useMemo, useState, useTransition } from "react";

import { Button } from "@/components/ui/Button";
import type {
  NexOpsFlaggedMessage,
  NexOpsReviewStatus,
  NexOpsSnapshot,
} from "@/server/services/nexOpsService";

type Filter = NexOpsReviewStatus | "all";

interface AdminUsageStatsResponse {
  success: boolean;
  data?: NexOpsSnapshot;
  error?: { message?: string };
}

function formatDateTime(value: string): string {
  return new Intl.DateTimeFormat("en-KE", {
    dateStyle: "medium",
    timeStyle: "short",
    timeZone: "Africa/Nairobi",
  }).format(new Date(value));
}

function statusClasses(status: NexOpsReviewStatus): string {
  if (status === "resolved") {
    return "border-emerald-500/30 bg-emerald-500/10 text-emerald-200";
  }

  if (status === "escalated") {
    return "border-amber-500/30 bg-amber-500/10 text-amber-200";
  }

  return "border-destructive/30 bg-destructive/10 text-destructive";
}

export function NexOpsReviewPanel({
  initialItems,
}: {
  initialItems: NexOpsFlaggedMessage[];
}) {
  const [items, setItems] = useState(initialItems);
  const [filter, setFilter] = useState<Filter>("open");
  const [error, setError] = useState<string | null>(null);
  const [pendingId, setPendingId] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  const visibleItems = useMemo(
    () => (filter === "all" ? items : items.filter((item) => item.status === filter)),
    [filter, items],
  );

  const openCount = items.filter((item) => item.status === "open").length;

  function refresh() {
    startTransition(async () => {
      setError(null);
      const response = await fetch("/api/admin/usage-stats", {
        headers: { Accept: "application/json" },
      });
      const payload = (await response.json()) as AdminUsageStatsResponse;

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not refresh review queue.");
        return;
      }

      setItems(payload.data.flagged);
    });
  }

  function updateStatus(
    messageId: string,
    status: Exclude<NexOpsReviewStatus, "open">,
  ) {
    setPendingId(messageId);
    setError(null);
    startTransition(async () => {
      const response = await fetch("/api/admin/usage-stats", {
        method: "PATCH",
        headers: {
          Accept: "application/json",
          "Content-Type": "application/json",
        },
        body: JSON.stringify({ messageId, status }),
      });
      const payload = (await response.json()) as AdminUsageStatsResponse;

      setPendingId(null);

      if (!response.ok || !payload.success) {
        setError(payload.error?.message ?? "Could not update review status.");
        return;
      }

      setItems((current) =>
        current.map((item) =>
          item.messageId === messageId ? { ...item, status } : item,
        ),
      );
    });
  }

  return (
    <section className="rounded-lg border border-border bg-card">
      <div className="flex flex-col gap-4 border-b border-border px-5 py-4 sm:flex-row sm:items-center sm:justify-between">
        <div>
          <h2 className="font-heading text-lg font-semibold">
            Flagged conversation review
          </h2>
          <p className="mt-1 text-sm text-muted-foreground">
            {openCount} open validation {openCount === 1 ? "failure" : "failures"}
          </p>
        </div>
        <div className="flex items-center gap-2">
          <select
            className="h-9 rounded-lg border border-border bg-background px-3 text-sm outline-none focus-visible:ring-2 focus-visible:ring-ring"
            value={filter}
            onChange={(event) => setFilter(event.target.value as Filter)}
            aria-label="Filter review status"
          >
            <option value="open">Open</option>
            <option value="resolved">Resolved</option>
            <option value="escalated">Escalated</option>
            <option value="all">All</option>
          </select>
          <Button
            type="button"
            variant="outline"
            size="sm"
            onClick={refresh}
            disabled={isPending}
          >
            <RefreshCw aria-hidden />
            Refresh
          </Button>
        </div>
      </div>

      <div className="space-y-4 p-5">
        {error ? (
          <div className="rounded-lg border border-destructive/30 bg-destructive/10 px-4 py-3 text-sm text-destructive">
            {error}
          </div>
        ) : null}

        {visibleItems.length === 0 ? (
          <div className="rounded-lg border border-border bg-background px-4 py-8 text-center text-sm text-muted-foreground">
            No flagged conversations match this filter.
          </div>
        ) : (
          visibleItems.map((item) => (
            <article
              key={item.messageId}
              className="rounded-lg border border-border bg-background p-4"
            >
              <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                <div className="space-y-2">
                  <div className="flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
                    <span>{formatDateTime(item.createdAt)}</span>
                    <span>{item.provider}</span>
                    <span>{item.mode}</span>
                    <span
                      className={`rounded-full border px-2 py-0.5 font-medium capitalize ${statusClasses(
                        item.status,
                      )}`}
                    >
                      {item.status}
                    </span>
                  </div>
                  <p className="text-sm">
                    <span className="text-muted-foreground">Student:</span>{" "}
                    {item.promptPreview || "No prompt preview recorded."}
                  </p>
                  <p className="text-sm">
                    <span className="text-muted-foreground">Nex:</span>{" "}
                    {item.responsePreview || "No response preview recorded."}
                  </p>
                </div>

                {item.status === "open" ? (
                  <div className="flex shrink-0 gap-2">
                    <Button
                      type="button"
                      variant="outline"
                      size="sm"
                      disabled={pendingId === item.messageId}
                      onClick={() => updateStatus(item.messageId, "resolved")}
                    >
                      <CheckCircle2 aria-hidden />
                      Resolve
                    </Button>
                    <Button
                      type="button"
                      variant="destructive"
                      size="sm"
                      disabled={pendingId === item.messageId}
                      onClick={() => updateStatus(item.messageId, "escalated")}
                    >
                      <TriangleAlert aria-hidden />
                      Escalate
                    </Button>
                  </div>
                ) : null}
              </div>
            </article>
          ))
        )}
      </div>
    </section>
  );
}
