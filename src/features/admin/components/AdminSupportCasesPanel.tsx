"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel, StatusBadge } from "@/features/admin/components/adminUi";
import type { AdminSupportCase } from "@/server/services/adminOpsService";

const PRIORITIES = ["low", "medium", "high", "urgent"] as const;
const STATUSES = ["open", "in_progress", "waiting_on_user", "resolved"] as const;
const ISSUE_TYPES = [
  "account",
  "billing",
  "learning",
  "content",
  "nex",
  "parent",
  "technical",
  "other",
] as const;

function priorityTone(priority: AdminSupportCase["priority"]) {
  if (priority === "urgent") {
    return "danger";
  }
  if (priority === "high") {
    return "warning";
  }
  return "neutral";
}

function statusTone(status: AdminSupportCase["status"]) {
  if (status === "resolved") {
    return "success";
  }
  if (status === "waiting_on_user") {
    return "warning";
  }
  return "info";
}

export function AdminSupportCasesPanel({
  initialCases,
}: {
  initialCases: AdminSupportCase[];
}) {
  const [cases, setCases] = useState(initialCases);
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  async function createCase(formData: FormData) {
    setSubmitting(true);
    setMessage(null);

    const payload = {
      targetStudentId: String(formData.get("targetStudentId") || "") || null,
      targetParentId: String(formData.get("targetParentId") || "") || null,
      issueType: String(formData.get("issueType") || "other"),
      priority: String(formData.get("priority") || "medium"),
      title: String(formData.get("title") || ""),
      notes: String(formData.get("notes") || "") || null,
    };

    const response = await fetch("/api/admin/support-cases", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    const body = await response.json();
    setSubmitting(false);

    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not create support case.");
      return;
    }

    setCases((current) => [body.data.case, ...current]);
    setMessage("Support case created.");
  }

  async function updateCase(caseId: string, status: AdminSupportCase["status"]) {
    setMessage(null);
    const response = await fetch("/api/admin/support-cases", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ caseId, status }),
    });
    const body = await response.json();

    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not update support case.");
      return;
    }

    setCases((current) =>
      current.map((item) => (item.id === caseId ? body.data.case : item)),
    );
    setMessage("Support case updated.");
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="New support case" description="Track internal account, billing, learning, Nex, and parent issues.">
        <form action={createCase} className="space-y-4">
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Title</span>
            <input
              required
              name="title"
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              placeholder="Parent paid but access is still free"
            />
          </label>

          <div className="grid grid-cols-2 gap-3">
            <label className="block space-y-1.5">
              <span className="text-xs font-medium text-muted-foreground">Type</span>
              <select
                name="issueType"
                className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              >
                {ISSUE_TYPES.map((type) => (
                  <option key={type} value={type}>
                    {type}
                  </option>
                ))}
              </select>
            </label>
            <label className="block space-y-1.5">
              <span className="text-xs font-medium text-muted-foreground">Priority</span>
              <select
                name="priority"
                className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              >
                {PRIORITIES.map((priority) => (
                  <option key={priority} value={priority}>
                    {priority}
                  </option>
                ))}
              </select>
            </label>
          </div>

          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Student ID</span>
            <input
              name="targetStudentId"
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              placeholder="Optional UUID"
            />
          </label>

          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Parent ID</span>
            <input
              name="targetParentId"
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              placeholder="Optional UUID"
            />
          </label>

          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Notes</span>
            <textarea
              name="notes"
              rows={4}
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              placeholder="What happened and what should the admin do next?"
            />
          </label>

          <Button type="submit" disabled={submitting} fullWidth>
            {submitting ? "Creating..." : "Create case"}
          </Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>

      <Panel title="Case queue" description={`${cases.length} recent case${cases.length === 1 ? "" : "s"}`} padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Case</th>
                <th className="px-5 py-3 font-medium">Target</th>
                <th className="px-5 py-3 font-medium">Priority</th>
                <th className="px-5 py-3 font-medium">Status</th>
                <th className="px-5 py-3 font-medium">Created</th>
              </tr>
            </thead>
            <tbody>
              {cases.length === 0 ? (
                <tr>
                  <td colSpan={5} className="px-5 py-10 text-center text-muted-foreground">
                    No support cases yet.
                  </td>
                </tr>
              ) : (
                cases.map((item) => (
                  <tr key={item.id} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                    <td className="px-5 py-3">
                      <p className="font-medium text-foreground">{item.title}</p>
                      <p className="text-xs text-muted-foreground">{item.issueType}</p>
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {item.targetName ?? item.targetStudentId ?? item.targetParentId ?? "-"}
                    </td>
                    <td className="px-5 py-3">
                      <StatusBadge tone={priorityTone(item.priority)}>{item.priority}</StatusBadge>
                    </td>
                    <td className="px-5 py-3">
                      <select
                        value={item.status}
                        onChange={(event) =>
                          updateCase(item.id, event.target.value as AdminSupportCase["status"])
                        }
                        className="rounded-lg border border-nexus-border bg-nexus-sunken px-2 py-1 text-xs outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
                        aria-label={`Update ${item.title} status`}
                      >
                        {STATUSES.map((status) => (
                          <option key={status} value={status}>
                            {status}
                          </option>
                        ))}
                      </select>
                      <span className="ml-2">
                        <StatusBadge tone={statusTone(item.status)}>{item.status}</StatusBadge>
                      </span>
                    </td>
                    <td className="px-5 py-3 text-xs text-muted-foreground">
                      {new Date(item.createdAt).toLocaleDateString("en-KE")}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </Panel>
    </div>
  );
}
