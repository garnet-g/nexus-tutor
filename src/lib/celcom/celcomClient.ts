import "server-only";

import { randomUUID } from "node:crypto";

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
}

function isCelcomConfigured(): boolean {
  return Boolean(
    process.env.CELCOM_PARTNER_ID &&
      process.env.CELCOM_API_KEY &&
      process.env.CELCOM_SHORTCODE,
  );
}

function shouldUseMock(): boolean {
  return (
    !isCelcomConfigured() ||
    process.env.NOTIFICATIONS_MOCK === "true"
  );
}

export async function sendCelcomSms(
  input: SendCelcomSmsInput,
): Promise<SendCelcomSmsResult> {
  const supabase = createAdminClient();
  const isMock = shouldUseMock();
  let celcomMessageId = `MOCK-SMS-${randomUUID()}`;
  let smsStatus: SendCelcomSmsResult["smsStatus"] = "queued";
  let sentAt: string | null = null;

  if (!isMock) {
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
  } else {
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
    isMock,
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
