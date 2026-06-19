"use client";

import { useState } from "react";

import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";

interface AuditLogEntry {
  id: string;
  change_type: string;
  setting_key: string | null;
  previous_value: unknown;
  new_value: unknown;
  change_reason: string | null;
  created_at: string;
}

interface PlatformSettingsEditorProps {
  initialConfig: EffectiveSubscriptionConfig;
  initialAuditLog: AuditLogEntry[];
}

export function PlatformSettingsEditor({
  initialConfig,
  initialAuditLog,
}: PlatformSettingsEditorProps) {
  const [config, setConfig] = useState(initialConfig);
  const [auditLog, setAuditLog] = useState(initialAuditLog);
  const [changeReason, setChangeReason] = useState("");
  const [isSaving, setIsSaving] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  const [form, setForm] = useState({
    freeDailyNexMessageLimit: initialConfig.limits.freeNex,
    freeDailyPracticeSessionLimit: initialConfig.limits.freePractice,
    premiumDailyNexMessageLimit: initialConfig.limits.premiumNex,
    premiumDailyPracticeSessionLimit: initialConfig.limits.premiumPractice,
    familyMaxStudents: initialConfig.limits.familyMaxStudents,
    premiumAmountKes: initialConfig.pricing.premiumAmountKes,
    familyAmountKes: initialConfig.pricing.familyAmountKes,
    promotionIsActive: initialConfig.promotion.isActive,
    promotionTitle: initialConfig.promotion.title ?? "",
    promotionEndsAt: initialConfig.promotion.endsAt ?? "",
    promotionPremiumAmountKes: "",
  });

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSaving(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch("/api/admin/platform-settings", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          ...form,
          promotionTitle: form.promotionTitle || null,
          promotionEndsAt: form.promotionEndsAt || null,
          promotionPremiumAmountKes: form.promotionPremiumAmountKes
            ? Number(form.promotionPremiumAmountKes)
            : null,
          changeReason: changeReason || undefined,
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          config: EffectiveSubscriptionConfig;
          recentAuditLog: AuditLogEntry[];
        };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not save settings.");
        return;
      }

      setConfig(payload.data.config);
      setAuditLog(payload.data.recentAuditLog);
      setSuccess("Platform settings updated.");
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsSaving(false);
    }
  }

  function updateNumberField(key: keyof typeof form, value: string) {
    setForm((current) => ({
      ...current,
      [key]: Number(value),
    }));
  }

  return (
    <div className="space-y-6">
      <section className="rounded-2xl border border-border bg-primary p-6">
        <h2 className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
          Effective subscription config
        </h2>
        <dl className="mt-4 grid gap-4 sm:grid-cols-2">
          <div>
            <dt className="text-sm text-muted-foreground">Premium price (KES)</dt>
            <dd className="text-xl font-semibold">
              {config.pricing.premiumAmountKes.toLocaleString()}
            </dd>
          </div>
          <div>
            <dt className="text-sm text-muted-foreground">Family price (KES)</dt>
            <dd className="text-xl font-semibold">
              {config.pricing.familyAmountKes.toLocaleString()}
            </dd>
          </div>
        </dl>
      </section>

      <form
        onSubmit={handleSubmit}
        className="space-y-6 rounded-2xl border border-border bg-primary p-6"
      >
        <h2 className="text-lg font-medium">Edit settings</h2>

        <div className="grid gap-4 sm:grid-cols-2">
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Free Nex messages / day</span>
            <input
              type="number"
              min={1}
              max={500}
              value={form.freeDailyNexMessageLimit}
              onChange={(event) =>
                updateNumberField("freeDailyNexMessageLimit", event.target.value)
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Free practice sessions / day</span>
            <input
              type="number"
              min={1}
              max={500}
              value={form.freeDailyPracticeSessionLimit}
              onChange={(event) =>
                updateNumberField(
                  "freeDailyPracticeSessionLimit",
                  event.target.value,
                )
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Premium Nex messages / day</span>
            <input
              type="number"
              min={1}
              max={500}
              value={form.premiumDailyNexMessageLimit}
              onChange={(event) =>
                updateNumberField(
                  "premiumDailyNexMessageLimit",
                  event.target.value,
                )
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Premium practice sessions / day</span>
            <input
              type="number"
              min={1}
              max={500}
              value={form.premiumDailyPracticeSessionLimit}
              onChange={(event) =>
                updateNumberField(
                  "premiumDailyPracticeSessionLimit",
                  event.target.value,
                )
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Family max students</span>
            <input
              type="number"
              min={1}
              max={20}
              value={form.familyMaxStudents}
              onChange={(event) =>
                updateNumberField("familyMaxStudents", event.target.value)
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Premium amount (KES)</span>
            <input
              type="number"
              min={1}
              max={100000}
              value={form.premiumAmountKes}
              onChange={(event) =>
                updateNumberField("premiumAmountKes", event.target.value)
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Family amount (KES)</span>
            <input
              type="number"
              min={1}
              max={100000}
              value={form.familyAmountKes}
              onChange={(event) =>
                updateNumberField("familyAmountKes", event.target.value)
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
        </div>

        <div className="space-y-4 border-t border-border pt-4">
          <h3 className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
            Promotion
          </h3>
          <label className="flex items-center gap-2 text-sm text-muted-foreground">
            <input
              type="checkbox"
              checked={form.promotionIsActive}
              onChange={(event) =>
                setForm((current) => ({
                  ...current,
                  promotionIsActive: event.target.checked,
                }))
              }
            />
            Promotion active
          </label>
          <label className="block space-y-1 text-sm">
            <span className="text-muted-foreground">Promotion title</span>
            <input
              type="text"
              value={form.promotionTitle}
              onChange={(event) =>
                setForm((current) => ({
                  ...current,
                  promotionTitle: event.target.value,
                }))
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="block space-y-1 text-sm">
            <span className="text-muted-foreground">Promotion ends at (ISO)</span>
            <input
              type="text"
              value={form.promotionEndsAt}
              onChange={(event) =>
                setForm((current) => ({
                  ...current,
                  promotionEndsAt: event.target.value,
                }))
              }
              placeholder="2026-12-31T23:59:59Z"
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="block space-y-1 text-sm">
            <span className="text-muted-foreground">Promotion premium amount (KES)</span>
            <input
              type="number"
              min={1}
              max={100000}
              value={form.promotionPremiumAmountKes}
              onChange={(event) =>
                setForm((current) => ({
                  ...current,
                  promotionPremiumAmountKes: event.target.value,
                }))
              }
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
        </div>

        <label className="block space-y-1 text-sm">
          <span className="text-muted-foreground">Change reason</span>
          <input
            type="text"
            value={changeReason}
            onChange={(event) => setChangeReason(event.target.value)}
            className="w-full rounded-lg border border-border bg-background px-3 py-2"
          />
        </label>

        {error ? <p className="text-sm text-red-400">{error}</p> : null}
        {success ? <p className="text-sm text-emerald-400">{success}</p> : null}

        <button
          type="submit"
          disabled={isSaving}
          className="rounded-lg bg-card px-4 py-2 text-sm font-medium text-foreground hover:bg-muted disabled:opacity-60"
        >
          {isSaving ? "Saving..." : "Save settings"}
        </button>
      </form>

      <section className="rounded-2xl border border-border bg-primary p-6">
        <h2 className="text-lg font-medium">Recent audit log</h2>
        {auditLog.length === 0 ? (
          <p className="mt-2 text-sm text-muted-foreground">No changes recorded yet.</p>
        ) : (
          <ul className="mt-4 space-y-3">
            {auditLog.map((entry) => (
              <li
                key={entry.id}
                className="rounded-lg border border-border bg-background p-3 text-sm"
              >
                <p className="font-medium text-muted-foreground">
                  {entry.change_type} · {entry.setting_key ?? "unknown"}
                </p>
                <p className="text-muted-foreground">
                  {new Date(entry.created_at).toLocaleString()}
                  {entry.change_reason ? ` · ${entry.change_reason}` : ""}
                </p>
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}
