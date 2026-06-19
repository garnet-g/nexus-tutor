"use client";

export type AnalyticsEventName =
  | "cta_clicked"
  | "form_submit_started"
  | "form_submit_succeeded"
  | "form_submit_failed"
  | "api_error_shown"
  | "wizard_step_abandoned";

type AnalyticsPayload = Record<string, unknown>;

export function track(event: AnalyticsEventName, payload: AnalyticsPayload = {}) {
  if (typeof window === "undefined") {
    return;
  }

  const detail = {
    event,
    payload,
    timestamp: new Date().toISOString(),
  };

  window.dispatchEvent(new CustomEvent("nexus:analytics", { detail }));

  if (process.env.NODE_ENV !== "production") {
    console.info("[analytics]", event, payload);
  }
}
