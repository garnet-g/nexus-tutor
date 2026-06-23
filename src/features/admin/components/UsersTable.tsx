"use client";

import Link from "next/link";

import { StatusBadge, type BadgeTone } from "@/features/admin/components/adminUi";
import { DataTable, type Column } from "@/features/admin/components/DataTable";
import type { DirectoryUserRow } from "@/server/services/adminUserReadService";

function formatDate(iso: string): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date(iso));
}

function subscriptionTone(status: string | null): BadgeTone {
  if (status === "active") return "success";
  if (status === "trialing") return "warning";
  return "neutral";
}

interface UsersTableProps {
  rows: DirectoryUserRow[];
}

export function UsersTable({ rows }: UsersTableProps) {
  const columns: Column<DirectoryUserRow>[] = [
    {
      key: "name",
      header: "Name",
      sortable: true,
      searchValue: (u) => u.fullName,
      render: (u) =>
        u.type === "student" ? (
          <Link
            href={`/admin/users/${u.id}`}
            className="font-medium text-foreground hover:text-primary hover:underline"
          >
            {u.fullName}
          </Link>
        ) : (
          <span className="font-medium text-foreground">{u.fullName}</span>
        ),
    },
    {
      key: "type",
      header: "Type",
      sortable: true,
      sortValue: (u) => u.type,
      searchValue: (u) => u.type,
      className: "capitalize text-muted-foreground",
      render: (u) => u.type,
    },
    {
      key: "grade",
      header: "Grade / Curriculum",
      className: "text-muted-foreground",
      exportValue: (u) =>
        u.type === "student"
          ? `${u.gradeLevel || ""} / ${u.curriculum || ""}`
          : "",
      render: (u) =>
        u.type === "student"
          ? `${u.gradeLevel || "—"} · ${u.curriculum || "—"}`
          : "—",
    },
    {
      key: "subscription",
      header: "Subscription",
      sortable: true,
      sortValue: (u) => u.subscriptionStatus ?? "",
      exportValue: (u) => u.subscriptionStatus ?? "",
      render: (u) =>
        u.subscriptionStatus ? (
          <StatusBadge tone={subscriptionTone(u.subscriptionStatus)}>
            {u.subscriptionStatus}
          </StatusBadge>
        ) : (
          <span className="text-muted-foreground">—</span>
        ),
    },
    {
      key: "status",
      header: "Status",
      sortable: true,
      sortValue: (u) => (u.isActive ? 1 : 0),
      exportValue: (u) => (u.isActive ? "Active" : "Inactive"),
      render: (u) => (
        <StatusBadge tone={u.isActive ? "success" : "neutral"}>
          {u.isActive ? "Active" : "Inactive"}
        </StatusBadge>
      ),
    },
    {
      key: "joined",
      header: "Joined",
      align: "right",
      sortable: true,
      sortValue: (u) => u.createdAt,
      exportValue: (u) => formatDate(u.createdAt),
      className: "tabular-nums text-muted-foreground",
      render: (u) => formatDate(u.createdAt),
    },
  ];

  return (
    <DataTable
      columns={columns}
      rows={rows}
      getRowKey={(u) => `${u.type}-${u.id}`}
      emptyMessage="No accounts match these filters."
      exportFilename="nexus-users"
    />
  );
}
