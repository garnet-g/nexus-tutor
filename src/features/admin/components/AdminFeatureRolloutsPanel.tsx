"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel, StatusBadge } from "@/features/admin/components/adminUi";
import type { AdminFeatureRollout } from "@/server/services/adminOpsService";

const SCOPES = ["global", "curriculum", "grade", "cohort", "student", "role"] as const;

const FEATURE_PRESETS = [
  { featureKey: "camera_help", displayName: "Ask Nex with camera" },
  { featureKey: "mock_exams", displayName: "Mock exams" },
  { featureKey: "science_content", displayName: "Science content" },
  { featureKey: "english_content", displayName: "English content" },
  { featureKey: "voice_tutor", displayName: "Voice tutor" },
] as const;

type FeaturePreset = (typeof FEATURE_PRESETS)[number];

export function AdminFeatureRolloutsPanel({
  initialRollouts,
}: {
  initialRollouts: AdminFeatureRollout[];
}) {
  const [rollouts, setRollouts] = useState(initialRollouts);
  const [message, setMessage] = useState<string | null>(null);
  const [preset, setPreset] = useState<FeaturePreset>(FEATURE_PRESETS[0]);

  async function saveRollout(formData: FormData) {
    setMessage(null);
    const scope = String(formData.get("scope") || "global");
    const payload = {
      featureKey: String(formData.get("featureKey") || ""),
      displayName: String(formData.get("displayName") || ""),
      description: String(formData.get("description") || "") || null,
      isEnabled: formData.get("isEnabled") === "on",
      scope,
      scopeValue: scope === "global" ? null : String(formData.get("scopeValue") || ""),
    };

    const response = await fetch("/api/admin/feature-rollouts", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    });
    const body = await response.json();

    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not save rollout.");
      return;
    }

    const saved = body.data.rollout as AdminFeatureRollout;
    setRollouts((current) => {
      const next = current.filter((item) => item.id !== saved.id);
      return [...next, saved].sort((a, b) =>
        a.featureKey.localeCompare(b.featureKey),
      );
    });
    setMessage("Rollout saved.");
  }

  async function toggleRollout(item: AdminFeatureRollout) {
    const response = await fetch("/api/admin/feature-rollouts", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        featureKey: item.featureKey,
        displayName: item.displayName,
        description: item.description,
        isEnabled: !item.isEnabled,
        scope: item.scope,
        scopeValue: item.scopeValue,
      }),
    });
    const body = await response.json();
    if (!response.ok || !body.success) {
      setMessage(body.error?.message ?? "Could not update rollout.");
      return;
    }
    setRollouts((current) =>
      current.map((rollout) =>
        rollout.id === item.id ? body.data.rollout : rollout,
      ),
    );
  }

  return (
    <div className="grid gap-5 lg:grid-cols-[360px_1fr]">
      <Panel title="Rollout control" description="Enable features globally or for a scoped cohort before wider release.">
        <form action={saveRollout} className="space-y-4">
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Preset</span>
            <select
              value={preset.featureKey}
              onChange={(event) => {
                const next =
                  FEATURE_PRESETS.find(
                    (item) => item.featureKey === event.target.value,
                  ) ?? FEATURE_PRESETS[0];
                setPreset(next);
              }}
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
            >
              {FEATURE_PRESETS.map((item) => (
                <option key={item.featureKey} value={item.featureKey}>
                  {item.displayName}
                </option>
              ))}
            </select>
          </label>

          <input type="hidden" name="featureKey" value={preset.featureKey} />
          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Display name</span>
            <input
              key={preset.featureKey}
              name="displayName"
              defaultValue={preset.displayName}
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
            />
          </label>

          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Scope</span>
            <select
              name="scope"
              defaultValue="global"
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
            >
              {SCOPES.map((scope) => (
                <option key={scope} value={scope}>
                  {scope}
                </option>
              ))}
            </select>
          </label>

          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Scope value</span>
            <input
              name="scopeValue"
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              placeholder="KCSE, Form 4, beta-2026, student UUID"
            />
          </label>

          <label className="block space-y-1.5">
            <span className="text-xs font-medium text-muted-foreground">Description</span>
            <textarea
              name="description"
              rows={3}
              className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
              placeholder="Rollout purpose or guardrail notes."
            />
          </label>

          <label className="flex items-center gap-2 text-sm text-foreground">
            <input
              type="checkbox"
              name="isEnabled"
              className="h-4 w-4 rounded border-nexus-border bg-nexus-sunken"
            />
            Enabled
          </label>

          <Button type="submit" fullWidth>
            Save rollout
          </Button>
          {message ? <p className="text-sm text-muted-foreground">{message}</p> : null}
        </form>
      </Panel>

      <Panel title="Rollout matrix" description={`${rollouts.length} configured rollout${rollouts.length === 1 ? "" : "s"}`} padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Feature</th>
                <th className="px-5 py-3 font-medium">Scope</th>
                <th className="px-5 py-3 font-medium">State</th>
                <th className="px-5 py-3 text-right font-medium">Action</th>
              </tr>
            </thead>
            <tbody>
              {rollouts.length === 0 ? (
                <tr>
                  <td colSpan={4} className="px-5 py-10 text-center text-muted-foreground">
                    No rollout controls configured yet.
                  </td>
                </tr>
              ) : (
                rollouts.map((item) => (
                  <tr key={item.id} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                    <td className="px-5 py-3">
                      <p className="font-medium text-foreground">{item.displayName}</p>
                      <p className="font-mono text-xs text-muted-foreground">{item.featureKey}</p>
                    </td>
                    <td className="px-5 py-3 text-muted-foreground">
                      {item.scope}
                      {item.scopeValue ? `: ${item.scopeValue}` : ""}
                    </td>
                    <td className="px-5 py-3">
                      <StatusBadge tone={item.isEnabled ? "success" : "neutral"}>
                        {item.isEnabled ? "enabled" : "disabled"}
                      </StatusBadge>
                    </td>
                    <td className="px-5 py-3 text-right">
                      <Button
                        type="button"
                        variant="outline"
                        size="sm"
                        onClick={() => toggleRollout(item)}
                      >
                        {item.isEnabled ? "Disable" : "Enable"}
                      </Button>
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
