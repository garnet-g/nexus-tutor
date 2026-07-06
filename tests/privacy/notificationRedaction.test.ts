/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";

import { buildNotificationLogExportSnapshot } from "@/lib/privacy/notificationLogSerializer";

describe("PR-058 notification log export redaction", () => {
  it("snapshot contains no raw phone numbers or message bodies", () => {
    const snapshot = buildNotificationLogExportSnapshot({
      sms: [
        {
          id: "sms-1",
          templateCode: "parent_link_success",
          phoneNumber: "+254712345678",
          smsBody: "Nexus: You are now linked to Alex.",
          smsStatus: "sent",
          createdAt: "2026-07-06T09:00:00.000Z",
        },
      ],
      email: [
        {
          id: "email-1",
          templateCode: "weekly_parent_report",
          recipientEmail: "parent@example.com",
          emailSubject: "Weekly progress for Alex",
          emailStatus: "sent",
          createdAt: "2026-07-06T09:00:00.000Z",
        },
      ],
    });

    expect(snapshot.sms[0]?.phoneNumber).toBe("+2547***78");
    expect(snapshot.sms[0]?.smsBody).toBe("[redacted]");
    expect(snapshot.email[0]?.recipientEmail).toBe("pa***@example.com");
    expect(snapshot.email[0]?.emailSubject).toBe("[redacted]");

    const serialized = JSON.stringify(snapshot);
    expect(serialized).not.toContain("+254712345678");
    expect(serialized).not.toContain("You are now linked");
    expect(serialized).not.toContain("Weekly progress for Alex");
  });
});
