"use client";

import { CheckCircle2, RefreshCw, TriangleAlert } from "lucide-react";
import { useMemo, useState, useTransition } from "react";

import { Button } from "@/components/ui/Button";
import { Select } from "@/features/admin/components/adminForm";
import { Panel, StatusBadge, type BadgeTone } from "@/features/admin/components/adminUi";
import { toastError } from "@/features/admin/components/toast";
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

function statusTone(status: NexOpsReviewStatus): BadgeTone {
  if (status === "resolved") return "success";
  if (status === "escalated") return "warning";
  return "danger";
}

export function NexOpsReviewPanel({
  initialItems,
}: {
  initialItems: NexOpsFlaggedMessage[];
}) {
  const [items, setItems] = useState(initialItems);
  const [filter, setFilter] = useState<Filter>("open");
  const [pendingId, setPendingId] = useState<string | null>(null);
  const [isPending, startTransition] = useTransition();

  const visibleItems = useMemo(
    () => (filter === "all" ? items : items.filter((item) => item.status === filter)),
    [filter, items],
  );

  const openCount = items.filter((item) => item.status === "open").length;

  function refresh() {
    startTransition(async () => {
      const response = await fetch("/api/admin/usage-stats", {
        headers: { Accept: "application/json" },
      });
      const payload = (await response.json()) as AdminUsageStatsResponse;

      if (!response.ok || !payload.success || !payload.data) {
        toastError("Could not refresh review queue", payload.error?.message);
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
        toastError("Could not update review status", payload.error?.message);
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
    <Panel
      title="Flagged conversation review"
      description={`${openCount} open validation ${openCount === 1 ? "failure" : "failures"}`}
      padded={false}
      action={
        <div className="flex items-center gap-2">
          <Select
            className="w-auto"
            value={filter}
            onChange={(event) => setFilter(event.target.value as Filter)}
            aria-label="Filter review status"
          >
            <option value="open">Open</option>
            <option value="resolved">Resolved</option>
            <option value="escalated">Escalated</option>
            <option value="all">All</option>
          </Select>
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
      }
    >
      <div className="space-y-4 p-5">
        {visibleItems.length === 0 ? (
          <div className="rounded-xl border border-nexus-border bg-nexus-sunken px-4 py-8 text-center text-sm text-muted-foreground">
            No flagged conversations match this filter.
          </div>
        ) : (
          visibleItems.map((item) => (
            <article
              key={item.messageId}
              className="rounded-xl border border-nexus-border bg-nexus-sunken p-4"
            >
              <div className="flex flex-col gap-3 sm:flex-row sm:items-start sm:justify-between">
                <div className="space-y-2">
                  <div className="flex flex-wrap items-center gap-2 text-xs text-muted-foreground">
                    <span>{formatDateTime(item.createdAt)}</span>
                    <span>{item.provider}</span>
                    <span>{item.mode}</span>
                    <StatusBadge tone={statusTone(item.status)}>
                      {item.status}
                    </StatusBadge>
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
    </Panel>
  );
}
