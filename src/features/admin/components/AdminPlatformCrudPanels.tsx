"use client";

import Link from "next/link";

import { buildSavedViewHref } from "@/lib/admin/savedViews";
import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel, StatusBadge } from "@/features/admin/components/adminUi";
import type {
  AdminAlert,
  AdminApprovalRequest,
  AdminCommunicationLog,
  AdminCommunicationTemplate,
  AdminExperiment,
  AdminRoleAssignment,
  AdminSavedView,
} from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLE_PERMISSIONS,
  getRoleLabel,
  type AdminOperationalRole,
} from "@/server/services/adminPlatformSummary";

const ALERT_SEVERITIES = ["critical", "urgent", "watch"] as const;
const ALERT_STATUSES = ["open", "acknowledged", "resolved"] as const;
const APPROVAL_STATUSES = ["approved", "rejected", "cancelled"] as const;
const ROLE_KEYS = Object.keys(
  ADMIN_ROLE_PERMISSIONS,
) as AdminOperationalRole[];

function fieldClassName() {
  return "w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20";
}

function toneForStatus(status: string) {
  if (status === "resolved" || status === "approved" || status === "sent") {
    return "success";
  }
  if (status === "critical" || status === "urgent" || status === "rejected") {
    return "danger";
  }
  if (status === "acknowledged" || status === "watch" || status === "pending") {
    return "warning";
  }
  return "neutral";
}

function parseJsonObject(value: FormDataEntryValue | null) {
  const raw = String(value || "").trim();
  if (!raw) {
    return {};
  }
  const parsed = JSON.parse(raw);
  if (!parsed || typeof parsed !== "object" || Array.isArray(parsed)) {
    throw new Error("JSON must be an object.");
  }
  return parsed as Record<string, unknown>;
}

export function AdminAlertsPanel({
  initialAlerts,
}: {
  initialAlerts: AdminAlert[];
}) {
  const [alerts, setAlerts] = useState(initialAlerts);
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  async function createAlert(formData: FormData) {
    setSubmitting(true);
    setMessage(null);

    const payload = {
      alertType: String(formData.get("alertType") || ""),
      severity: String(formData.get("severity") || "watch"),
      title: String(formData.get("title") || ""),
      description: String(formData.get("description") || "") || null,
      source: String(formData.get("source") || "admin"),
      targetType: String(formData.get("targetType") || "") || null,
      targetId: String(formData.get("targetId") || "") || null,
      metadata: {},
    };

    const response = await fetch("/api/admin/alerts", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    const body = await response.json();
    setSubmitting(false);

    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not create alert.");
      return;
    }

    setAlerts((current) => [body.data.alert, ...current]);
    setMessage("Alert created.");
  }

  async function updateAlert(alertId: string, status: AdminAlert["status"]) {
    setMessage(null);
    const response = await fetch("/api/admin/alerts", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ alertId, status }),
    });
    const body = await response.json();

    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not update alert.");
      return;
    }

    setAlerts((current) =>
      current.map((item) => (item.id === alertId ? body.data.alert : item)),
    );
    setMessage("Alert updated.");
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="Create alert" description="Add an operational signal to the admin task inbox.">
        <form action={createAlert} className="space-y-4">
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Title</span>
            <input required name="title" className={fieldClassName()} placeholder="M-Pesa callback delay" />
          </label>
          <div className="grid grid-cols-2 gap-3">
            <label className="block space-y-1.5">
              <span className="text-xs font-medium text-muted-foreground">Type</span>
              <input required name="alertType" className={fieldClassName()} placeholder="payments" />
            </label>
            <label className="block space-y-1.5">
              <span className="text-xs font-medium text-muted-foreground">Severity</span>
              <select name="severity" className={fieldClassName()}>
                {ALERT_SEVERITIES.map((severity) => (
                  <option key={severity} value={severity}>{severity}</option>
                ))}
              </select>
            </label>
          </div>
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Description</span>
            <textarea name="description" rows={4} className={fieldClassName()} />
          </label>
          <div className="grid grid-cols-2 gap-3">
            <label className="block space-y-1.5">
              <span className="text-xs font-medium text-muted-foreground">Source</span>
              <input name="source" className={fieldClassName()} defaultValue="admin" />
            </label>
            <label className="block space-y-1.5">
              <span className="text-xs font-medium text-muted-foreground">Target ID</span>
              <input name="targetId" className={fieldClassName()} placeholder="Optional" />
            </label>
          </div>
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Target type</span>
            <input name="targetType" className={fieldClassName()} placeholder="Optional" />
          </label>
          <Button type="submit" disabled={submitting} fullWidth>{submitting ? "Creating..." : "Create alert"}</Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>

      <Panel title="Alert queue" description={`${alerts.length} recent alert${alerts.length === 1 ? "" : "s"}`} padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Alert</th>
                <th className="px-5 py-3 font-medium">Severity</th>
                <th className="px-5 py-3 font-medium">Status</th>
                <th className="px-5 py-3 font-medium">Created</th>
              </tr>
            </thead>
            <tbody>
              {alerts.length === 0 ? (
                <tr><td colSpan={4} className="px-5 py-10 text-center text-muted-foreground">No alerts yet.</td></tr>
              ) : alerts.map((alert) => (
                <tr key={alert.id} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                  <td className="px-5 py-3">
                    <p className="font-medium text-foreground">{alert.title}</p>
                    <p className="text-xs text-muted-foreground">{alert.alertType} / {alert.source}</p>
                  </td>
                  <td className="px-5 py-3"><StatusBadge tone={toneForStatus(alert.severity)}>{alert.severity}</StatusBadge></td>
                  <td className="px-5 py-3">
                    <select
                      value={alert.status}
                      onChange={(event) => updateAlert(alert.id, event.target.value as AdminAlert["status"])}
                      className="rounded-lg border border-nexus-border bg-nexus-sunken px-2 py-1 text-xs outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
                    >
                      {ALERT_STATUSES.map((status) => <option key={status} value={status}>{status}</option>)}
                    </select>
                  </td>
                  <td className="px-5 py-3 text-xs text-muted-foreground">{new Date(alert.createdAt).toLocaleDateString("en-KE")}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Panel>
    </div>
  );
}

export function AdminRolesPanel({
  initialAssignments,
}: {
  initialAssignments: AdminRoleAssignment[];
}) {
  const [assignments, setAssignments] = useState(initialAssignments);
  const [submitting, setSubmitting] = useState(false);
  const [message, setMessage] = useState<string | null>(null);

  async function assignRole(formData: FormData) {
    setSubmitting(true);
    setMessage(null);
    const response = await fetch("/api/admin/roles", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        userId: String(formData.get("userId") || ""),
        roleKey: String(formData.get("roleKey") || "support"),
      }),
    });
    const body = await response.json();
    setSubmitting(false);

    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not assign role.");
      return;
    }

    setAssignments((current) => {
      const withoutDuplicate = current.filter(
        (item) =>
          item.userId !== body.data.assignment.userId ||
          item.roleKey !== body.data.assignment.roleKey,
      );
      return [body.data.assignment, ...withoutDuplicate];
    });
    setMessage("Role assigned.");
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="Assign operational role" description="Role rows are service-role backed and audited.">
        <form action={assignRole} className="space-y-4">
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">User ID</span>
            <input required name="userId" className={fieldClassName()} placeholder="Admin auth user UUID" />
          </label>
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Role</span>
            <select name="roleKey" className={fieldClassName()}>
              {ROLE_KEYS.map((role) => <option key={role} value={role}>{getRoleLabel(role)}</option>)}
            </select>
          </label>
          <Button type="submit" disabled={submitting} fullWidth>{submitting ? "Assigning..." : "Assign role"}</Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>

      <div className="space-y-5">
        <Panel title="Permission matrix" description="Routes each operational role is intended to access.">
          <div className="grid gap-3 md:grid-cols-2">
            {ROLE_KEYS.map((role) => (
              <div key={role} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
                <p className="font-medium text-foreground">{getRoleLabel(role)}</p>
                <p className="mt-1 text-xs text-muted-foreground">
                  {ADMIN_ROLE_PERMISSIONS[role].join(", ")}
                </p>
              </div>
            ))}
          </div>
        </Panel>

        <Panel title="Assignments" description={`${assignments.length} assigned operational role${assignments.length === 1 ? "" : "s"}`} padded={false}>
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead><tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground"><th className="px-5 py-3 font-medium">User</th><th className="px-5 py-3 font-medium">Role</th><th className="px-5 py-3 font-medium">Assigned</th></tr></thead>
              <tbody>
                {assignments.length === 0 ? (
                  <tr><td colSpan={3} className="px-5 py-10 text-center text-muted-foreground">No role assignments yet.</td></tr>
                ) : assignments.map((assignment) => (
                  <tr key={assignment.id} className="border-b border-nexus-border last:border-0">
                    <td className="px-5 py-3 font-mono text-xs text-muted-foreground">{assignment.userId}</td>
                    <td className="px-5 py-3"><StatusBadge tone="info">{getRoleLabel(assignment.roleKey)}</StatusBadge></td>
                    <td className="px-5 py-3 text-xs text-muted-foreground">{new Date(assignment.createdAt).toLocaleDateString("en-KE")}</td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        </Panel>
      </div>
    </div>
  );
}

export function AdminCommunicationsPanel({
  initialTemplates,
  initialLogs,
}: {
  initialTemplates: AdminCommunicationTemplate[];
  initialLogs: AdminCommunicationLog[];
}) {
  const [templates, setTemplates] = useState(initialTemplates);
  const [message, setMessage] = useState<string | null>(null);

  async function createTemplate(formData: FormData) {
    setMessage(null);
    const response = await fetch("/api/admin/communications", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        templateKey: String(formData.get("templateKey") || ""),
        channel: String(formData.get("channel") || "sms"),
        title: String(formData.get("title") || ""),
        body: String(formData.get("body") || ""),
      }),
    });
    const body = await response.json();
    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not create template.");
      return;
    }
    setTemplates((current) => [body.data.template, ...current]);
    setMessage("Template created.");
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="New template" description="Prepare SMS or email messages for support and lifecycle operations.">
        <form action={createTemplate} className="space-y-4">
          <input required name="templateKey" className={fieldClassName()} placeholder="payment_failed_parent" />
          <select name="channel" className={fieldClassName()}><option value="sms">sms</option><option value="email">email</option></select>
          <input required name="title" className={fieldClassName()} placeholder="Payment failed follow-up" />
          <textarea required name="body" rows={6} className={fieldClassName()} placeholder="Hi {{parent_name}}, your payment..." />
          <Button type="submit" fullWidth>Create template</Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>
      <div className="space-y-5">
        <Panel title="Templates" description={`${templates.length} template${templates.length === 1 ? "" : "s"}`}>
          <div className="space-y-3">
            {templates.length === 0 ? <p className="text-sm text-muted-foreground">No templates yet.</p> : templates.map((template) => (
              <div key={template.id} className="rounded-xl bg-nexus-sunken p-4">
                <div className="flex items-start justify-between gap-3">
                  <div><p className="font-medium text-foreground">{template.title}</p><p className="text-xs text-muted-foreground">{template.templateKey}</p></div>
                  <StatusBadge tone={template.isActive ? "success" : "neutral"}>{template.channel}</StatusBadge>
                </div>
                <p className="mt-2 line-clamp-3 text-sm text-muted-foreground">{template.body}</p>
              </div>
            ))}
          </div>
        </Panel>
        <Panel title="Recent sends" description={`${initialLogs.length} communication log${initialLogs.length === 1 ? "" : "s"}`}>
          <div className="space-y-2">
            {initialLogs.length === 0 ? <p className="text-sm text-muted-foreground">No communication logs yet.</p> : initialLogs.map((log) => (
              <div key={log.id} className="flex items-start justify-between gap-3 rounded-xl bg-nexus-sunken p-3">
                <div><p className="text-sm font-medium text-foreground">{log.recipient ?? "Unknown recipient"}</p><p className="line-clamp-2 text-xs text-muted-foreground">{log.messageBody}</p></div>
                <StatusBadge tone={toneForStatus(log.status)}>{log.status}</StatusBadge>
              </div>
            ))}
          </div>
        </Panel>
      </div>
    </div>
  );
}

export function AdminExperimentsPanel({
  initialExperiments,
}: {
  initialExperiments: AdminExperiment[];
}) {
  const [experiments, setExperiments] = useState(initialExperiments);
  const [message, setMessage] = useState<string | null>(null);

  async function createExperiment(formData: FormData) {
    setMessage(null);
    const response = await fetch("/api/admin/experiments", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        experimentKey: String(formData.get("experimentKey") || ""),
        title: String(formData.get("title") || ""),
        hypothesis: String(formData.get("hypothesis") || "") || null,
        metricKey: String(formData.get("metricKey") || "conversion"),
        variants: String(formData.get("variants") || "")
          .split(",")
          .map((item) => item.trim())
          .filter(Boolean),
      }),
    });
    const body = await response.json();
    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not create experiment.");
      return;
    }
    setExperiments((current) => [body.data.experiment, ...current]);
    setMessage("Experiment created.");
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="New experiment" description="Track product experiments without shipping new flags blindly.">
        <form action={createExperiment} className="space-y-4">
          <input required name="experimentKey" className={fieldClassName()} placeholder="pricing_copy_v2" />
          <input required name="title" className={fieldClassName()} placeholder="Pricing page copy test" />
          <input name="metricKey" className={fieldClassName()} defaultValue="conversion" />
          <input required name="variants" className={fieldClassName()} placeholder="control, challenger" />
          <textarea name="hypothesis" rows={4} className={fieldClassName()} placeholder="Families convert better when..." />
          <Button type="submit" fullWidth>Create experiment</Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>
      <Panel title="Experiments" description={`${experiments.length} configured experiment${experiments.length === 1 ? "" : "s"}`}>
        <div className="space-y-3">
          {experiments.length === 0 ? <p className="text-sm text-muted-foreground">No experiments yet.</p> : experiments.map((experiment) => (
            <div key={experiment.id} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div><p className="font-medium text-foreground">{experiment.title}</p><p className="text-xs text-muted-foreground">{experiment.experimentKey} / {experiment.metricKey}</p></div>
                <StatusBadge tone={experiment.status === "running" ? "success" : "neutral"}>{experiment.status}</StatusBadge>
              </div>
              <p className="mt-2 text-sm text-muted-foreground">{experiment.hypothesis ?? "No hypothesis recorded."}</p>
              <p className="mt-2 text-xs text-muted-foreground">Variants: {experiment.variants.join(", ")}</p>
            </div>
          ))}
        </div>
      </Panel>
    </div>
  );
}

export function AdminSavedViewsPanel({
  initialViews,
}: {
  initialViews: AdminSavedView[];
}) {
  const [views, setViews] = useState(initialViews);
  const [message, setMessage] = useState<string | null>(null);

  async function createView(formData: FormData) {
    setMessage(null);
    let filters: Record<string, unknown>;
    try {
      filters = parseJsonObject(formData.get("filters"));
    } catch (error) {
      setMessage(error instanceof Error ? error.message : "Invalid filters JSON.");
      return;
    }

    const response = await fetch("/api/admin/saved-views", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        viewKey: String(formData.get("viewKey") || ""),
        title: String(formData.get("title") || ""),
        route: String(formData.get("route") || ""),
        filters,
        isShared: formData.get("isShared") === "on",
      }),
    });
    const body = await response.json();
    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not create saved view.");
      return;
    }
    setViews((current) => [body.data.view, ...current]);
    setMessage("Saved view created.");
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="Save admin view" description="Persist useful filters for recurring workflows.">
        <form action={createView} className="space-y-4">
          <input required name="viewKey" className={fieldClassName()} placeholder="failed_payments_this_week" />
          <input required name="title" className={fieldClassName()} placeholder="Failed payments this week" />
          <input required name="route" className={fieldClassName()} placeholder="/admin/payments" />
          <textarea name="filters" rows={4} className={fieldClassName()} placeholder='{"status":"failed"}' />
          <label className="flex items-center gap-2 text-sm text-muted-foreground"><input type="checkbox" name="isShared" /> Shared</label>
          <Button type="submit" fullWidth>Save view</Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>
      <Panel title="Saved views" description={`${views.length} saved admin view${views.length === 1 ? "" : "s"}`}>
        <div className="grid gap-3 md:grid-cols-2">
          {views.length === 0 ? <p className="text-sm text-muted-foreground">No saved views yet.</p> : views.map((view) => (
            <Link key={view.id} href={buildSavedViewHref(view)} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4 transition-colors hover:border-primary/60">
              <div className="flex items-start justify-between gap-3">
                <div><p className="font-medium text-foreground">{view.title}</p><p className="text-xs text-muted-foreground">{view.viewKey}</p></div>
                <StatusBadge tone={view.isShared ? "info" : "neutral"}>{view.isShared ? "shared" : "private"}</StatusBadge>
              </div>
              <p className="mt-2 font-mono text-xs text-muted-foreground">{view.route}</p>
            </Link>
          ))}
        </div>
      </Panel>
    </div>
  );
}

export function AdminApprovalsPanel({
  initialApprovals,
}: {
  initialApprovals: AdminApprovalRequest[];
}) {
  const [approvals, setApprovals] = useState(initialApprovals);
  const [message, setMessage] = useState<string | null>(null);

  async function createApproval(formData: FormData) {
    setMessage(null);
    const response = await fetch("/api/admin/approvals", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        requestType: String(formData.get("requestType") || ""),
        title: String(formData.get("title") || ""),
        description: String(formData.get("description") || "") || null,
        targetType: String(formData.get("targetType") || "") || null,
        targetId: String(formData.get("targetId") || "") || null,
        metadata: {},
      }),
    });
    const body = await response.json();
    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not create approval.");
      return;
    }
    setApprovals((current) => [body.data.approval, ...current]);
    setMessage("Approval request created.");
  }

  async function updateApproval(
    approvalId: string,
    status: "approved" | "rejected" | "cancelled",
  ) {
    setMessage(null);
    const response = await fetch("/api/admin/approvals", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ approvalId, status }),
    });
    const body = await response.json();
    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not update approval.");
      return;
    }
    setApprovals((current) =>
      current.map((item) =>
        item.id === approvalId ? body.data.approval : item,
      ),
    );
    setMessage("Approval updated.");
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="Request approval" description="Queue controlled changes before execution.">
        <form action={createApproval} className="space-y-4">
          <input required name="title" className={fieldClassName()} placeholder="Bulk comp grant for pilot school" />
          <input required name="requestType" className={fieldClassName()} placeholder="bulk_action" />
          <textarea name="description" rows={4} className={fieldClassName()} />
          <div className="grid grid-cols-2 gap-3">
            <input name="targetType" className={fieldClassName()} placeholder="target type" />
            <input name="targetId" className={fieldClassName()} placeholder="target id" />
          </div>
          <Button type="submit" fullWidth>Create request</Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>
      <Panel title="Approval queue" description={`${approvals.length} approval request${approvals.length === 1 ? "" : "s"}`} padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead><tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground"><th className="px-5 py-3 font-medium">Request</th><th className="px-5 py-3 font-medium">Target</th><th className="px-5 py-3 font-medium">Status</th><th className="px-5 py-3 font-medium">Action</th></tr></thead>
            <tbody>
              {approvals.length === 0 ? <tr><td colSpan={4} className="px-5 py-10 text-center text-muted-foreground">No approvals yet.</td></tr> : approvals.map((approval) => (
                <tr key={approval.id} className="border-b border-nexus-border last:border-0">
                  <td className="px-5 py-3"><p className="font-medium text-foreground">{approval.title}</p><p className="text-xs text-muted-foreground">{approval.requestType}</p></td>
                  <td className="px-5 py-3 text-xs text-muted-foreground">{approval.targetType ?? "-"} {approval.targetId ?? ""}</td>
                  <td className="px-5 py-3"><StatusBadge tone={toneForStatus(approval.status)}>{approval.status}</StatusBadge></td>
                  <td className="px-5 py-3">
                    {approval.status === "pending" ? (
                      <select
                        defaultValue=""
                        onChange={(event) => {
                          if (event.target.value) {
                            updateApproval(
                              approval.id,
                              event.target.value as "approved" | "rejected" | "cancelled",
                            );
                          }
                        }}
                        className="rounded-lg border border-nexus-border bg-nexus-sunken px-2 py-1 text-xs outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
                      >
                        <option value="">Review</option>
                        {APPROVAL_STATUSES.map((status) => <option key={status} value={status}>{status}</option>)}
                      </select>
                    ) : "-"}
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Panel>
    </div>
  );
}
