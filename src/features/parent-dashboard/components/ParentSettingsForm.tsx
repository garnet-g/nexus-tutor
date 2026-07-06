"use client";

import { useState } from "react";

type ParentSettings = {
  displayName: string;
  contactPhone: string | null;
  preferredLanguage: "en" | "sw";
  dashboardSummary: "compact" | "detailed";
};

export function ParentSettingsForm({ initial }: { initial: ParentSettings }) {
  const [form, setForm] = useState(initial);
  const [status, setStatus] = useState<"idle" | "saving" | "saved" | "error">("idle");

  return (
    <form
      className="space-y-4 rounded-2xl border border-border bg-card p-6"
      onSubmit={(event) => {
        event.preventDefault();
        setStatus("saving");
        void fetch("/api/parents/settings", {
          method: "PATCH",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(form),
        })
          .then((response) => {
            if (!response.ok) {
              throw new Error("save failed");
            }
            setStatus("saved");
          })
          .catch(() => setStatus("error"));
      }}
    >
      <h2 className="text-lg font-medium text-foreground">Profile & contact</h2>
      <p className="text-sm text-muted-foreground">
        Product preferences only — account email and password are managed separately.
      </p>

      <label className="block text-sm font-medium text-foreground">
        Display name
        <input
          value={form.displayName}
          onChange={(event) => setForm({ ...form, displayName: event.target.value })}
          className="mt-1 h-10 w-full rounded-lg border border-border px-3 text-sm"
          required
        />
      </label>

      <label className="block text-sm font-medium text-foreground">
        Contact phone
        <input
          value={form.contactPhone ?? ""}
          onChange={(event) =>
            setForm({ ...form, contactPhone: event.target.value || null })
          }
          className="mt-1 h-10 w-full rounded-lg border border-border px-3 text-sm"
        />
      </label>

      <label className="block text-sm font-medium text-foreground">
        Dashboard layout
        <select
          value={form.dashboardSummary}
          onChange={(event) =>
            setForm({
              ...form,
              dashboardSummary: event.target.value as "compact" | "detailed",
            })
          }
          className="mt-1 h-10 w-full rounded-lg border border-border px-3 text-sm"
        >
          <option value="detailed">Detailed</option>
          <option value="compact">Compact</option>
        </select>
      </label>

      <button
        type="submit"
        className="h-10 rounded-lg bg-primary px-4 text-sm font-medium text-primary-foreground"
      >
        {status === "saving" ? "Saving…" : "Save settings"}
      </button>
      {status === "error" ? (
        <p className="text-sm text-destructive">Could not save settings.</p>
      ) : null}
      {status === "saved" ? (
        <p className="text-sm text-nexus-success">Settings saved.</p>
      ) : null}
    </form>
  );
}
