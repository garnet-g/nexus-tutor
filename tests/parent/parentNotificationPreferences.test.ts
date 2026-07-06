/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const PARENT_A = "00000000-0000-4000-8000-000000000101";

type NotificationPrefs = {
  channel_sms: boolean;
  channel_email: boolean;
  weekly_report: boolean;
  link_updates: boolean;
  at_risk_alerts: boolean;
};

let notificationPrefs: NotificationPrefs | null = null;

const sendCelcomSms = vi.fn();
const sendResendEmail = vi.fn();

vi.mock("@/lib/celcom/celcomClient", () => ({
  sendCelcomSms: (...args: unknown[]) => sendCelcomSms(...args),
}));

vi.mock("@/lib/resend/resendClient", () => ({
  sendResendEmail: (...args: unknown[]) => sendResendEmail(...args),
}));

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: {
      getUser: async () => ({
        data: { user: { id: "user-parent-a" } },
        error: null,
      }),
    },
    from: (table: string) => {
      if (table === "parent_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: { id: PARENT_A }, error: null }),
            }),
          }),
        };
      }

      if (table === "parent_notification_preferences") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: notificationPrefs, error: null }),
            }),
          }),
          upsert: (patch: Record<string, boolean | string>) => ({
            select: () => ({
              single: async () => {
                notificationPrefs = {
                  channel_sms: Boolean(patch.channel_sms ?? notificationPrefs?.channel_sms ?? true),
                  channel_email: Boolean(
                    patch.channel_email ?? notificationPrefs?.channel_email ?? true,
                  ),
                  weekly_report: Boolean(
                    patch.weekly_report ?? notificationPrefs?.weekly_report ?? true,
                  ),
                  link_updates: Boolean(
                    patch.link_updates ?? notificationPrefs?.link_updates ?? true,
                  ),
                  at_risk_alerts: Boolean(
                    patch.at_risk_alerts ?? notificationPrefs?.at_risk_alerts ?? true,
                  ),
                };

                return { data: notificationPrefs, error: null };
              },
            }),
          }),
        };
      }

      return {
        select: () => ({
          eq: () => ({
            maybeSingle: async () => ({ data: null, error: null }),
          }),
        }),
      };
    },
  })),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => {
      const chain: Record<string, unknown> = {};
      chain.select = () => chain;
      chain.eq = () => chain;
      chain.maybeSingle = async () => ({ data: null, error: null });
      return chain;
    },
  })),
}));

describe("PR-061 parent notification preferences", () => {
  beforeEach(() => {
    notificationPrefs = null;
    sendCelcomSms.mockReset();
    sendResendEmail.mockReset();
    vi.resetModules();
  });

  it("PATCH /api/parents/notification-preferences persists toggles", async () => {
    const { PATCH } = await import("@/app/api/parents/notification-preferences/route");
    const response = await PATCH(
      new Request("http://localhost/api/parents/notification-preferences", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          linkUpdates: false,
          weeklyReport: false,
          channelEmail: false,
        }),
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.data.preferences.linkUpdates).toBe(false);
    expect(body.data.preferences.weeklyReport).toBe(false);
    expect(body.data.preferences.channelEmail).toBe(false);
  });

  it("suppressed link_updates SMS is never sent", async () => {
    notificationPrefs = {
      channel_sms: true,
      channel_email: true,
      weekly_report: true,
      link_updates: false,
      at_risk_alerts: true,
    };

    const { sendParentLinkSuccessNotification } = await import(
      "@/server/services/notificationService"
    );

    await sendParentLinkSuccessNotification({
      parentId: PARENT_A,
      parentPhone: "+254700000001",
      studentName: "Student A",
    });

    expect(sendCelcomSms).not.toHaveBeenCalled();
  });

  it("suppressed weekly_report email is never sent", async () => {
    notificationPrefs = {
      channel_sms: true,
      channel_email: true,
      weekly_report: false,
      link_updates: true,
      at_risk_alerts: true,
    };

    const { sendWeeklyParentReportEmail } = await import(
      "@/server/services/notificationService"
    );

    await sendWeeklyParentReportEmail({
      parentId: PARENT_A,
      recipientEmail: "parent@example.com",
      studentName: "Student A",
      studyMinutes: 120,
      healthScore: 72,
      weakTopics: "Algebra",
    });

    expect(sendResendEmail).not.toHaveBeenCalled();
  });

  it("enabled weekly_report email is sent when preferences allow", async () => {
    notificationPrefs = {
      channel_sms: true,
      channel_email: true,
      weekly_report: true,
      link_updates: true,
      at_risk_alerts: true,
    };

    const { sendWeeklyParentReportEmail } = await import(
      "@/server/services/notificationService"
    );

    await sendWeeklyParentReportEmail({
      parentId: PARENT_A,
      recipientEmail: "parent@example.com",
      studentName: "Student A",
      studyMinutes: 120,
      healthScore: 72,
      weakTopics: "Algebra",
    });

    expect(sendResendEmail).toHaveBeenCalledOnce();
  });
});
