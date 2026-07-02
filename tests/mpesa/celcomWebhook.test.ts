/**
 * @vitest-environment node
 */
import { beforeAll, expect, it, vi } from "vitest";

import { POST as celcomWebhookPost } from "@/app/api/celcom/webhook/route";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  assertIsolatedTestDatabase,
  describeIfIsolatedTestDatabase,
} from "../helpers/isolatedSupabase";

vi.mock("@/server/services/notificationService", () => ({
  handleCelcomDeliveryReport: vi.fn(async () => undefined),
}));

describeIfIsolatedTestDatabase("Celcom webhook hardening", () => {
  beforeAll(() => {
    assertIsolatedTestDatabase();
    process.env.CELCOM_WEBHOOK_SECRET = "celcom-test-secret";
  });

  it("returns 401 when webhook secret header is missing", async () => {
    const response = await celcomWebhookPost(
      new Request("http://localhost/api/celcom/webhook", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ messageId: "msg-1", status: "delivered" }),
      }),
    );

    expect(response.status).toBe(401);
  });

  it("deduplicates replayed message ids without double-processing", async () => {
    const admin = createAdminClient();
    const messageId = `celcom-replay-${Date.now()}`;
    const body = JSON.stringify({
      messageId,
      status: "delivered",
      eventTimestamp: "2026-06-29T10:00:00Z",
    });

    const first = await celcomWebhookPost(
      new Request("http://localhost/api/celcom/webhook", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Celcom-Webhook-Secret": "celcom-test-secret",
        },
        body,
      }),
    );

    const second = await celcomWebhookPost(
      new Request("http://localhost/api/celcom/webhook", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "X-Celcom-Webhook-Secret": "celcom-test-secret",
        },
        body,
      }),
    );

    expect(first.status).toBe(200);
    expect(second.status).toBe(200);

    const secondPayload = await second.json();
    expect(secondPayload.data.duplicate).toBe(true);

    const { count } = await admin
      .from("celcom_webhook_events")
      .select("id", { count: "exact", head: true })
      .eq("celcom_message_id", messageId);

    expect(count).toBe(1);
  });
});
