"use client";

import { useState } from "react";

type NotificationPreferences = {
  channelSms: boolean;
  channelEmail: boolean;
  weeklyReport: boolean;
  linkUpdates: boolean;
  atRiskAlerts: boolean;
};

export function ParentNotificationPreferencesForm({
  initial,
}: {
  initial: NotificationPreferences;
}) {
  const [prefs, setPrefs] = useState(initial);
  const [status, setStatus] = useState<"idle" | "saving" | "saved" | "error">("idle");

  function toggle<K extends keyof NotificationPreferences>(key: K) {
    setPrefs((current) => ({ ...current, [key]: !current[key] }));
  }

  return (
    <form
      className="space-y-4 rounded-2xl border border-border bg-card p-6"
      onSubmit={(event) => {
        event.preventDefault();
        setStatus("saving");
        void fetch("/api/parents/notification-preferences", {
          method: "PATCH",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify(prefs),
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
      <h2 className="text-lg font-medium text-foreground">Notification preferences</h2>
      <p className="text-sm text-muted-foreground">
        Suppressed events will not be sent on any channel.
      </p>

      {(
        [
          ["channelSms", "SMS channel"],
          ["channelEmail", "Email channel"],
          ["weeklyReport", "Weekly progress report"],
          ["linkUpdates", "Link confirmations"],
          ["atRiskAlerts", "At-risk alerts"],
        ] as const
      ).map(([key, label]) => (
        <label key={key} className="flex items-center gap-2 text-sm text-foreground">
          <input
            type="checkbox"
            checked={prefs[key]}
            onChange={() => toggle(key)}
            className="size-4 rounded border-border"
          />
          {label}
        </label>
      ))}

      <button
        type="submit"
        className="h-10 rounded-lg bg-primary px-4 text-sm font-medium text-primary-foreground"
      >
        {status === "saving" ? "Saving…" : "Save notification preferences"}
      </button>
      {status === "error" ? (
        <p className="text-sm text-destructive">Could not save preferences.</p>
      ) : null}
      {status === "saved" ? (
        <p className="text-sm text-nexus-success">Preferences saved.</p>
      ) : null}
    </form>
  );
}
