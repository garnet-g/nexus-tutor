import "server-only";

import { buildCsv } from "@/lib/admin/csvExport";
import { listAdminAuditLog } from "@/server/services/adminAuditService";
import { getPaymentsDashboard } from "@/server/services/adminPaymentsReadService";
import { listUsers } from "@/server/services/adminUserReadService";

export const ADMIN_REPORT_EXPORT_KEYS = [
  "users",
  "payments",
  "content",
  "audit",
] as const;

export type AdminReportExportKey = (typeof ADMIN_REPORT_EXPORT_KEYS)[number];

export function isAdminReportExportKey(value: string): value is AdminReportExportKey {
  return (ADMIN_REPORT_EXPORT_KEYS as readonly string[]).includes(value);
}

export async function buildAdminReportCsv(
  exportKey: AdminReportExportKey,
): Promise<{ filename: string; csv: string; rowCount: number }> {
  if (exportKey === "users") {
    const users = await listUsers({ limit: 500 });
    const csv = buildCsv(
      ["id", "fullName", "type", "curriculum", "gradeLevel", "subscriptionStatus", "isActive"],
      users.map((user) => [
        user.id,
        user.fullName,
        user.type,
        user.curriculum ?? "",
        user.gradeLevel ?? "",
        user.subscriptionStatus ?? "",
        user.isActive ? "true" : "false",
      ]),
    );

    return { filename: "nexus-users-report.csv", csv, rowCount: users.length };
  }

  if (exportKey === "payments") {
    const dashboard = await getPaymentsDashboard({ limit: 500 });
    const csv = buildCsv(
      [
        "id",
        "createdAt",
        "studentName",
        "phoneNumber",
        "planName",
        "amountKes",
        "status",
        "mpesaReceiptNumber",
      ],
      dashboard.ledger.map((row) => [
        row.id,
        row.createdAt,
        row.studentName,
        row.phoneNumber,
        row.planName,
        row.amountKes,
        row.status,
        row.mpesaReceiptNumber ?? "",
      ]),
    );

    return {
      filename: "nexus-payments-report.csv",
      csv,
      rowCount: dashboard.ledger.length,
    };
  }

  if (exportKey === "audit") {
    const entries = await listAdminAuditLog({ limit: 500 });
    const csv = buildCsv(
      ["id", "action", "actorUserId", "targetType", "targetId", "createdAt"],
      entries.map((entry) => [
        entry.id,
        entry.action,
        entry.actor_user_id,
        entry.target_type ?? "",
        entry.target_id ?? "",
        entry.created_at,
      ]),
    );

    return { filename: "nexus-audit-report.csv", csv, rowCount: entries.length };
  }

  const csv = buildCsv(
    ["exportKey", "message"],
    [[exportKey, "Content coverage export is not yet available in this release."]],
  );

  return { filename: "nexus-content-report.csv", csv, rowCount: 1 };
}
