/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const insertedRows: Record<string, unknown>[] = [];

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => ({
      insert: async (row: Record<string, unknown>) => {
        insertedRows.push({ table, ...row });
        return { data: null, error: null };
      },
    }),
  })),
}));

describe("sendCelcomWhatsApp", () => {
  beforeEach(() => {
    insertedRows.length = 0;
    vi.resetModules();
    vi.unstubAllEnvs();
  });

  it("logs a queued mock message and returns a mock message id in mock mode", async () => {
    vi.stubEnv("NEX_MOCK_ALLOWED", "");
    vi.doMock("@/lib/env/providerModes", () => ({
      isNotificationsMockAllowed: () => true,
      isCelcomConfigured: () => false,
      assertNotificationsConfiguredForLiveMode: () => undefined,
      createMockAdapterMetadata: () => ({ adapter: "explicit-test", isMock: true }),
    }));

    const { sendCelcomWhatsApp } = await import(
      "@/lib/notifications/celcomClient"
    );

    const result = await sendCelcomWhatsApp({
      phoneNumber: "+254700000000",
      messageBody: "Weekly progress update",
      templateCode: "weekly_parent_report_whatsapp",
      parentId: "parent-1",
      studentId: "student-1",
    });

    expect(result.isMock).toBe(true);
    expect(result.whatsappStatus).toBe("queued");
    expect(result.celcomMessageId).toMatch(/^MOCK-WA-/);

    expect(insertedRows).toHaveLength(1);
    expect(insertedRows[0]).toMatchObject({
      table: "celcom_whatsapp_logs",
      phone_number: "+254700000000",
      message_body: "Weekly progress update",
      whatsapp_status: "queued",
    });
  });

  it("posts to the Celcom WhatsApp endpoint and logs delivery status in live mode", async () => {
    vi.doMock("@/lib/env/providerModes", () => ({
      isNotificationsMockAllowed: () => false,
      isCelcomConfigured: () => true,
      assertNotificationsConfiguredForLiveMode: () => undefined,
      createMockAdapterMetadata: () => ({ adapter: "explicit-test", isMock: true }),
    }));

    const fetchMock = vi.fn(async () => ({
      ok: true,
      json: async () => ({ messageId: "WA-REMOTE-1" }),
    }));
    vi.stubGlobal("fetch", fetchMock);

    const { sendCelcomWhatsApp } = await import(
      "@/lib/notifications/celcomClient"
    );

    const result = await sendCelcomWhatsApp({
      phoneNumber: "+254711111111",
      messageBody: "Hello parent",
    });

    expect(fetchMock).toHaveBeenCalledWith(
      "https://api.celcomafrica.com/whatsapp/send",
      expect.objectContaining({ method: "POST" }),
    );
    expect(result.isMock).toBe(false);
    expect(result.whatsappStatus).toBe("sent");
    expect(result.celcomMessageId).toBe("WA-REMOTE-1");
    expect(insertedRows[0]).toMatchObject({
      table: "celcom_whatsapp_logs",
      whatsapp_status: "sent",
    });
  });
});
