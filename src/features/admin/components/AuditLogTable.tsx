"use client";

import { CopyButton } from "@/features/admin/components/CopyButton";
import { DataTable, type Column } from "@/features/admin/components/DataTable";
import type { AdminAuditLogEntry } from "@/server/services/adminAuditService";

function formatTimestamp(iso: string): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    second: "2-digit",
    hour12: false,
  }).format(new Date(iso));
}

function summarizeMetadata(metadata: Record<string, unknown>): string {
  const keys = Object.keys(metadata);
  if (keys.length === 0) {
    return "—";
  }
  return keys.map((key) => `${key}: ${JSON.stringify(metadata[key])}`).join(", ");
}

function formatTarget(entry: AdminAuditLogEntry): string {
  if (!entry.target_type && !entry.target_id) {
    return "—";
  }
  if (entry.target_type && entry.target_id) {
    return `${entry.target_type}: ${entry.target_id}`;
  }
  return entry.target_type ?? entry.target_id ?? "—";
}

interface AuditLogTableProps {
  rows: AdminAuditLogEntry[];
}

export function AuditLogTable({ rows }: AuditLogTableProps) {
  const columns: Column<AdminAuditLogEntry>[] = [
    {
      key: "time",
      header: "Time",
      sortable: true,
      sortValue: (e) => e.created_at,
      searchValue: (e) => formatTimestamp(e.created_at),
      exportValue: (e) => formatTimestamp(e.created_at),
      className: "tabular-nums text-muted-foreground",
      render: (e) => formatTimestamp(e.created_at),
    },
    {
      key: "actor",
      header: "Actor",
      searchValue: (e) => `${e.actor_user_id} ${e.actor_role}`,
      exportValue: (e) => `${e.actor_user_id} (${e.actor_role})`,
      render: (e) => (
        <div>
          <div className="flex items-center gap-1">
            <span className="font-mono text-xs text-foreground">
              {e.actor_user_id}
            </span>
            <CopyButton value={e.actor_user_id} label="Copy actor ID" />
          </div>
          <span className="block text-xs text-muted-foreground">
            {e.actor_role}
          </span>
        </div>
      ),
    },
    {
      key: "action",
      header: "Action",
      sortable: true,
      sortValue: (e) => e.action,
      searchValue: (e) => e.action,
      className: "font-medium text-foreground",
      render: (e) => e.action,
    },
    {
      key: "target",
      header: "Target",
      searchValue: (e) => formatTarget(e),
      exportValue: (e) => formatTarget(e),
      className: "text-muted-foreground",
      render: (e) => formatTarget(e),
    },
    {
      key: "details",
      header: "Details",
      searchValue: (e) => summarizeMetadata(e.metadata),
      exportValue: (e) => summarizeMetadata(e.metadata),
      className: "text-muted-foreground",
      render: (e) => summarizeMetadata(e.metadata),
    },
  ];

  return (
    <DataTable
      columns={columns}
      rows={rows}
      getRowKey={(e) => e.id}
      emptyMessage="No admin actions recorded yet."
      searchable
      searchPlaceholder="Search actor, action, target…"
      exportFilename="nexus-audit-log"
    />
  );
}
