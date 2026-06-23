"use client";

import { StatusBadge, type BadgeTone } from "@/features/admin/components/adminUi";
import { CopyButton } from "@/features/admin/components/CopyButton";
import { DataTable, type Column } from "@/features/admin/components/DataTable";
import type { PaymentLedgerRow } from "@/server/services/adminPaymentsReadService";

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

function statusTone(status: PaymentLedgerRow["status"]): BadgeTone {
  if (status === "paid") return "success";
  if (status === "failed" || status === "cancelled" || status === "expired") {
    return "danger";
  }
  return "neutral";
}

interface PaymentsLedgerTableProps {
  rows: PaymentLedgerRow[];
}

export function PaymentsLedgerTable({ rows }: PaymentsLedgerTableProps) {
  const columns: Column<PaymentLedgerRow>[] = [
    {
      key: "date",
      header: "Date",
      sortable: true,
      sortValue: (r) => r.createdAt,
      exportValue: (r) => formatDate(r.createdAt),
      className: "tabular-nums text-muted-foreground",
      render: (r) => formatDate(r.createdAt),
    },
    {
      key: "student",
      header: "Student",
      sortable: true,
      searchValue: (r) => r.studentName,
      className: "font-medium text-foreground",
      render: (r) => r.studentName,
    },
    {
      key: "phone",
      header: "Phone",
      searchValue: (r) => r.phoneNumber,
      className: "text-muted-foreground",
      render: (r) => r.phoneNumber,
    },
    {
      key: "plan",
      header: "Plan",
      sortable: true,
      sortValue: (r) => r.planName,
      searchValue: (r) => r.planName,
      className: "text-muted-foreground",
      render: (r) => r.planName,
    },
    {
      key: "amount",
      header: "Amount",
      align: "right",
      sortable: true,
      sortValue: (r) => r.amountKes,
      exportValue: (r) => r.amountKes,
      className: "font-mono tabular-nums text-foreground",
      render: (r) => r.amountKes.toLocaleString(),
    },
    {
      key: "status",
      header: "Status",
      sortable: true,
      sortValue: (r) => r.status,
      exportValue: (r) => r.status,
      render: (r) => (
        <StatusBadge tone={statusTone(r.status)}>{r.status}</StatusBadge>
      ),
    },
    {
      key: "ref",
      header: "Receipt / Ref",
      searchValue: (r) => r.mpesaReceiptNumber ?? r.checkoutRequestId ?? "",
      exportValue: (r) => r.mpesaReceiptNumber ?? r.checkoutRequestId ?? "",
      render: (r) => {
        const ref = r.mpesaReceiptNumber ?? r.checkoutRequestId;
        return ref ? (
          <span className="flex items-center gap-1">
            <span className="font-mono text-xs text-muted-foreground">{ref}</span>
            <CopyButton value={ref} label="Copy reference" />
          </span>
        ) : (
          "—"
        );
      },
    },
  ];

  return (
    <DataTable
      columns={columns}
      rows={rows}
      getRowKey={(r) => r.id}
      emptyMessage="No payments match these filters yet."
      searchable
      searchPlaceholder="Search student, phone, ref…"
      exportFilename="nexus-payments"
    />
  );
}
