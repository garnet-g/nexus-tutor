"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Checkbox, Field, Input } from "@/features/admin/components/adminForm";
import { EmptyState, Panel, StatCard } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
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
        toastError("Could not save settings", payload.error?.message);
        return;
      }

      setConfig(payload.data.config);
      setAuditLog(payload.data.recentAuditLog);
      toastSuccess("Platform settings updated");
    } catch {
      toastError("Network error", "Please try again.");
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
      <section className="grid gap-4 sm:grid-cols-2">
        <StatCard
          label="Premium price (KES)"
          value={config.pricing.premiumAmountKes.toLocaleString()}
        />
        <StatCard
          label="Family price (KES)"
          value={config.pricing.familyAmountKes.toLocaleString()}
        />
      </section>

      <Panel title="Edit settings">
        <form onSubmit={handleSubmit} className="space-y-6">
          <div className="grid gap-4 sm:grid-cols-2">
            <Field label="Free Nex messages / day">
              <Input
                type="number"
                min={1}
                max={500}
                value={form.freeDailyNexMessageLimit}
                onChange={(event) =>
                  updateNumberField("freeDailyNexMessageLimit", event.target.value)
                }
              />
            </Field>
            <Field label="Free practice sessions / day">
              <Input
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
              />
            </Field>
            <Field label="Premium Nex messages / day">
              <Input
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
              />
            </Field>
            <Field label="Premium practice sessions / day">
              <Input
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
              />
            </Field>
            <Field label="Family max students">
              <Input
                type="number"
                min={1}
                max={20}
                value={form.familyMaxStudents}
                onChange={(event) =>
                  updateNumberField("familyMaxStudents", event.target.value)
                }
              />
            </Field>
            <Field label="Premium amount (KES)">
              <Input
                type="number"
                min={1}
                max={100000}
                value={form.premiumAmountKes}
                onChange={(event) =>
                  updateNumberField("premiumAmountKes", event.target.value)
                }
              />
            </Field>
            <Field label="Family amount (KES)">
              <Input
                type="number"
                min={1}
                max={100000}
                value={form.familyAmountKes}
                onChange={(event) =>
                  updateNumberField("familyAmountKes", event.target.value)
                }
              />
            </Field>
          </div>

          <div className="space-y-4 border-t border-nexus-border pt-5">
            <h3 className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              Promotion
            </h3>
            <Checkbox
              label="Promotion active"
              checked={form.promotionIsActive}
              onChange={(event) =>
                setForm((current) => ({
                  ...current,
                  promotionIsActive: event.target.checked,
                }))
              }
            />
            <Field label="Promotion title">
              <Input
                type="text"
                value={form.promotionTitle}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    promotionTitle: event.target.value,
                  }))
                }
              />
            </Field>
            <Field label="Promotion ends at (ISO)">
              <Input
                type="text"
                value={form.promotionEndsAt}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    promotionEndsAt: event.target.value,
                  }))
                }
                placeholder="2026-12-31T23:59:59Z"
              />
            </Field>
            <Field label="Promotion premium amount (KES)">
              <Input
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
              />
            </Field>
          </div>

          <Field label="Change reason">
            <Input
              type="text"
              value={changeReason}
              onChange={(event) => setChangeReason(event.target.value)}
            />
          </Field>

          <Button type="submit" variant="primary" disabled={isSaving}>
            {isSaving ? "Saving…" : "Save settings"}
          </Button>
        </form>
      </Panel>

      <Panel title="Recent audit log" padded={auditLog.length === 0}>
        {auditLog.length === 0 ? (
          <EmptyState title="No changes recorded yet" />
        ) : (
          <ul className="divide-y divide-nexus-border">
            {auditLog.map((entry) => (
              <li key={entry.id} className="px-5 py-3 text-sm">
                <p className="font-medium text-foreground">
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
      </Panel>
    </div>
  );
}
