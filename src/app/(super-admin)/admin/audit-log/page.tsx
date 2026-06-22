import { redirect } from "next/navigation";

import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import {
  type AdminAuditLogEntry,
  listAdminAuditLog,
} from "@/server/services/adminAuditService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

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

  return keys
    .map((key) => `${key}: ${JSON.stringify(metadata[key])}`)
    .join(", ");
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

export default async function AuditLogPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  let entries: AdminAuditLogEntry[] = [];
  try {
    entries = await listAdminAuditLog({ limit: 100 });
  } catch {
    entries = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Security"
        title="Audit log"
        description="Privileged admin actions across the platform, most recent first (Nairobi time)."
      />

      <Panel title="Recent activity" padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Time</th>
                <th className="px-5 py-3 font-medium">Actor</th>
                <th className="px-5 py-3 font-medium">Action</th>
                <th className="px-5 py-3 font-medium">Target</th>
                <th className="px-5 py-3 font-medium">Details</th>
              </tr>
            </thead>
            <tbody>
              {entries.length === 0 ? (
                <tr>
                  <td
                    colSpan={5}
                    className="px-5 py-10 text-center text-muted-foreground"
                  >
                    No admin actions recorded yet.
                  </td>
                </tr>
              ) : (
                entries.map((entry) => (
                  <tr
                    key={entry.id}
                    className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60"
                  >
                    <td className="px-5 py-3 tabular-nums text-muted-foreground">
                      {formatTimestamp(entry.created_at)}
                    </td>
                    <td className="px-5 py-3">
                      <span className="font-mono text-xs text-foreground">
                        {entry.actor_user_id}
                      </span>
                      <span className="block text-xs text-muted-foreground">
                        {entry.actor_role}
                      </span>
                    </td>
                    <td className="px-5 py-3 font-medium text-foreground">
                      {entry.action}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {formatTarget(entry)}
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {summarizeMetadata(entry.metadata)}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </Panel>
    </>
  );
}
