import "server-only";

import { randomUUID } from "node:crypto";

import {
  assertNotificationsConfiguredForLiveMode,
  createMockAdapterMetadata,
  isCelcomConfigured,
  isNotificationsMockAllowed,
} from "@/lib/env/providerModes";
import { createAdminClient } from "@/lib/supabase/admin";

export interface SendCelcomSmsInput {
  phoneNumber: string;
  smsBody: string;
  templateCode?: string;
  studentId?: string;
  parentId?: string;
}

export interface SendCelcomSmsResult {
  celcomMessageId: string;
  smsStatus: "queued" | "sent" | "delivered" | "failed";
  isMock: boolean;
  mockMetadata?: ReturnType<typeof createMockAdapterMetadata>;
}

export async function sendCelcomSms(
  input: SendCelcomSmsInput,
): Promise<SendCelcomSmsResult> {
  assertNotificationsConfiguredForLiveMode("sms");

  const useMock = isNotificationsMockAllowed() || !isCelcomConfigured();
  if (!useMock && !isCelcomConfigured()) {
    assertNotificationsConfiguredForLiveMode("sms");
  }

  if (!useMock) {
    const supabase = createAdminClient();
    let celcomMessageId = `SMS-${randomUUID()}`;
    let smsStatus: SendCelcomSmsResult["smsStatus"] = "queued";
    let sentAt: string | null = null;

    const response = await fetch("https://api.celcomafrica.com/sms/send", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${process.env.CELCOM_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        partnerId: process.env.CELCOM_PARTNER_ID,
        senderId: process.env.CELCOM_SHORTCODE,
        shortcode: process.env.CELCOM_SHORTCODE,
        phoneNumber: input.phoneNumber,
        message: input.smsBody,
      }),
    });

    if (!response.ok) {
      smsStatus = "failed";
    } else {
      const payload = (await response.json()) as { messageId?: string };
      celcomMessageId = payload.messageId ?? celcomMessageId;
      smsStatus = "sent";
      sentAt = new Date().toISOString();
    }

    await supabase.from("celcom_sms_logs").insert({
      student_id: input.studentId ?? null,
      parent_id: input.parentId ?? null,
      phone_number: input.phoneNumber,
      sms_body: input.smsBody,
      template_code: input.templateCode ?? null,
      celcom_message_id: celcomMessageId,
      sms_status: smsStatus,
      sent_at: sentAt,
    });

    return {
      celcomMessageId,
      smsStatus,
      isMock: false,
    };
  }

  if (!isNotificationsMockAllowed()) {
    assertNotificationsConfiguredForLiveMode("sms");
  }

  const supabase = createAdminClient();
  const mockMetadata = createMockAdapterMetadata();
  const celcomMessageId = `MOCK-SMS-${randomUUID()}`;

  await supabase.from("celcom_sms_logs").insert({
    student_id: input.studentId ?? null,
    parent_id: input.parentId ?? null,
    phone_number: input.phoneNumber,
    sms_body: input.smsBody,
    template_code: input.templateCode ?? null,
    celcom_message_id: celcomMessageId,
    sms_status: "queued",
    sent_at: null,
  });

  return {
    celcomMessageId,
    smsStatus: "queued",
    isMock: true,
    mockMetadata,
  };
}

export async function sendCelcomOtp(input: {
  phoneNumber: string;
  otpCode: string;
}): Promise<SendCelcomSmsResult> {
  return sendCelcomSms({
    phoneNumber: input.phoneNumber,
    smsBody: `Nexus: Your verification code is ${input.otpCode}. Valid for 10 minutes.`,
    templateCode: "otp_verification",
  });
}
