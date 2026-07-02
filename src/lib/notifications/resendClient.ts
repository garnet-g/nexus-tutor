import "server-only";

import { randomUUID } from "node:crypto";

import {
  assertNotificationsConfiguredForLiveMode,
  createMockAdapterMetadata,
  isNotificationsMockAllowed,
  isResendConfigured,
} from "@/lib/env/providerModes";
import { createAdminClient } from "@/lib/supabase/admin";

export interface SendResendEmailInput {
  recipientEmail: string;
  emailSubject: string;
  emailBody: string;
  templateCode?: string;
}

export interface SendResendEmailResult {
  resendEmailId: string;
  emailStatus: "queued" | "sent" | "delivered" | "opened" | "failed" | "bounced";
  isMock: boolean;
  mockMetadata?: ReturnType<typeof createMockAdapterMetadata>;
}

export async function sendResendEmail(
  input: SendResendEmailInput,
): Promise<SendResendEmailResult> {
  assertNotificationsConfiguredForLiveMode("email");

  const useMock = isNotificationsMockAllowed() || !isResendConfigured();

  if (!useMock) {
    const supabase = createAdminClient();
    let resendEmailId = `EMAIL-${randomUUID()}`;
    let emailStatus: SendResendEmailResult["emailStatus"] = "queued";
    let sentAt: string | null = null;

    const response = await fetch("https://api.resend.com/emails", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.RESEND_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        from: process.env.RESEND_FROM_EMAIL ?? "noreply@nexus.co.ke",
        to: [input.recipientEmail],
        subject: input.emailSubject,
        html: input.emailBody,
      }),
    });

    if (!response.ok) {
      emailStatus = "failed";
    } else {
      const payload = (await response.json()) as { id?: string };
      resendEmailId = payload.id ?? resendEmailId;
      emailStatus = "sent";
      sentAt = new Date().toISOString();
    }

    await supabase.from("resend_email_logs").insert({
      recipient_email: input.recipientEmail,
      email_subject: input.emailSubject,
      template_code: input.templateCode ?? null,
      resend_email_id: resendEmailId,
      email_status: emailStatus,
      sent_at: sentAt,
    });

    return {
      resendEmailId,
      emailStatus,
      isMock: false,
    };
  }

  if (!isNotificationsMockAllowed()) {
    assertNotificationsConfiguredForLiveMode("email");
  }

  const supabase = createAdminClient();
  const mockMetadata = createMockAdapterMetadata();
  const resendEmailId = `MOCK-EMAIL-${randomUUID()}`;

  await supabase.from("resend_email_logs").insert({
    recipient_email: input.recipientEmail,
    email_subject: input.emailSubject,
    template_code: input.templateCode ?? null,
    resend_email_id: resendEmailId,
    email_status: "queued",
    sent_at: null,
  });

  return {
    resendEmailId,
    emailStatus: "queued",
    isMock: true,
    mockMetadata,
  };
}
