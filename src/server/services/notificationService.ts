import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { sendCelcomSms } from "@/lib/celcom/celcomClient";
import { sendResendEmail } from "@/lib/resend/resendClient";

const APP_URL = process.env.NEXT_PUBLIC_APP_URL ?? "http://localhost:3000";

interface TemplateVariables {
  [key: string]: string | number;
}

function renderTemplate(template: string, variables: TemplateVariables): string {
  return template.replace(/\{\{(\w+)\}\}/g, (_match, key: string) => {
    const value = variables[key];
    return value !== undefined ? String(value) : "";
  });
}

async function loadSmsTemplate(templateCode: string): Promise<string | null> {
  const supabase = createAdminClient();
  const { data } = await supabase
    .from("sms_templates")
    .select("sms_body_template")
    .eq("template_code", templateCode)
    .eq("is_active", true)
    .maybeSingle();

  return data?.sms_body_template ?? null;
}

async function loadEmailTemplate(
  templateCode: string,
): Promise<{ subject: string; body: string } | null> {
  const supabase = createAdminClient();
  const { data } = await supabase
    .from("email_templates")
    .select("email_subject_template, email_body_template")
    .eq("template_code", templateCode)
    .eq("is_active", true)
    .maybeSingle();

  if (!data) {
    return null;
  }

  return {
    subject: data.email_subject_template,
    body: data.email_body_template,
  };
}

export async function sendParentLinkSuccessNotification(input: {
  parentId: string;
  parentPhone: string | null;
  studentName: string;
}): Promise<void> {
  if (!input.parentPhone) {
    return;
  }

  const template = await loadSmsTemplate("parent_link_success");
  const smsBody =
    template !== null
      ? renderTemplate(template, {
          studentName: input.studentName,
          appUrl: APP_URL,
        })
      : `Nexus: You are now linked to ${input.studentName}'s progress. View dashboard: ${APP_URL}/parent`;

  await sendCelcomSms({
    phoneNumber: input.parentPhone,
    smsBody,
    templateCode: "parent_link_success",
    parentId: input.parentId,
  });
}

export async function sendPaymentSuccessNotifications(input: {
  studentId: string;
  phoneNumber: string;
  recipientEmail?: string | null;
  amountKes: number;
  mpesaReceiptNumber: string;
  planName: string;
}): Promise<void> {
  const smsTemplate = await loadSmsTemplate("payment_success");
  const smsBody =
    smsTemplate !== null
      ? renderTemplate(smsTemplate, {
          amountKes: input.amountKes,
          mpesaReceiptNumber: input.mpesaReceiptNumber,
          planName: input.planName,
        })
      : `Nexus: Payment of KES ${input.amountKes} received. Ref: ${input.mpesaReceiptNumber}. Your ${input.planName} plan is now active.`;

  await sendCelcomSms({
    phoneNumber: input.phoneNumber,
    smsBody,
    templateCode: "payment_success",
    studentId: input.studentId,
  });

  if (input.recipientEmail) {
    const emailTemplate = await loadEmailTemplate("payment_receipt");
    const subject =
      emailTemplate !== null
        ? renderTemplate(emailTemplate.subject, {
            amountKes: input.amountKes,
          })
        : `Nexus Payment Receipt — KES ${input.amountKes}`;
    const body =
      emailTemplate !== null
        ? renderTemplate(emailTemplate.body, {
            amountKes: input.amountKes,
            mpesaReceiptNumber: input.mpesaReceiptNumber,
            planName: input.planName,
            appUrl: APP_URL,
          })
        : `Payment of KES ${input.amountKes} received. Ref: ${input.mpesaReceiptNumber}.`;

    await sendResendEmail({
      recipientEmail: input.recipientEmail,
      emailSubject: subject,
      emailBody: body,
      templateCode: "payment_receipt",
    });
  }
}

export async function sendPaymentFailedNotification(input: {
  studentId: string;
  phoneNumber: string;
  amountKes: number;
}): Promise<void> {
  const smsTemplate = await loadSmsTemplate("payment_failed");
  const smsBody =
    smsTemplate !== null
      ? renderTemplate(smsTemplate, {
          amountKes: input.amountKes,
          appUrl: APP_URL,
        })
      : `Nexus: Payment of KES ${input.amountKes} was not completed. Try again: ${APP_URL}/pricing`;

  await sendCelcomSms({
    phoneNumber: input.phoneNumber,
    smsBody,
    templateCode: "payment_failed",
    studentId: input.studentId,
  });
}

export async function sendDiagnosticCompleteNotification(input: {
  studentId: string;
  phoneNumber: string | null;
  studentName: string;
  healthScore: number;
}): Promise<void> {
  if (!input.phoneNumber) {
    return;
  }

  const template = await loadSmsTemplate("diagnostic_complete");
  const smsBody =
    template !== null
      ? renderTemplate(template, {
          studentName: input.studentName,
          healthScore: Math.round(input.healthScore),
          appUrl: APP_URL,
        })
      : `Great work ${input.studentName}! Your Academic Health Score is ${Math.round(input.healthScore)}%. Log in: ${APP_URL}`;

  await sendCelcomSms({
    phoneNumber: input.phoneNumber,
    smsBody,
    templateCode: "diagnostic_complete",
    studentId: input.studentId,
  });
}

export async function sendTrialEndingNotification(input: {
  studentId: string;
  phoneNumber: string | null;
  daysRemaining: number;
}): Promise<void> {
  if (!input.phoneNumber) {
    return;
  }

  const template = await loadSmsTemplate("trial_ending");
  const smsBody =
    template !== null
      ? renderTemplate(template, {
          daysRemaining: input.daysRemaining,
          appUrl: APP_URL,
        })
      : `Nexus: Your free trial ends in ${input.daysRemaining} days. Upgrade: ${APP_URL}/pricing`;

  await sendCelcomSms({
    phoneNumber: input.phoneNumber,
    smsBody,
    templateCode: "trial_ending",
    studentId: input.studentId,
  });
}

export async function sendWeeklyStreakNotification(input: {
  studentId: string;
  phoneNumber: string | null;
  studentName: string;
}): Promise<void> {
  if (!input.phoneNumber) {
    return;
  }

  const template = await loadSmsTemplate("weekly_streak");
  const smsBody =
    template !== null
      ? renderTemplate(template, { studentName: input.studentName })
      : `Nexus: ${input.studentName}, you hit a 7-day study streak! Keep going!`;

  await sendCelcomSms({
    phoneNumber: input.phoneNumber,
    smsBody,
    templateCode: "weekly_streak",
    studentId: input.studentId,
  });
}

export async function sendWeeklyParentReportEmail(input: {
  recipientEmail: string;
  studentName: string;
  studyMinutes: number;
  healthScore: number;
  weakTopics: string;
}): Promise<void> {
  const emailTemplate = await loadEmailTemplate("weekly_parent_report");
  const subject =
    emailTemplate !== null
      ? renderTemplate(emailTemplate.subject, { studentName: input.studentName })
      : `Weekly progress for ${input.studentName}`;
  const body =
    emailTemplate !== null
      ? renderTemplate(emailTemplate.body, {
          studentName: input.studentName,
          studyMinutes: input.studyMinutes,
          healthScore: Math.round(input.healthScore),
          weakTopics: input.weakTopics,
        })
      : `Study time: ${input.studyMinutes} min. Health score: ${Math.round(input.healthScore)}%.`;

  await sendResendEmail({
    recipientEmail: input.recipientEmail,
    emailSubject: subject,
    emailBody: body,
    templateCode: "weekly_parent_report",
  });
}

export async function handleCelcomDeliveryReport(payload: unknown): Promise<void> {
  if (!payload || typeof payload !== "object") {
    return;
  }

  const report = payload as Record<string, unknown>;
  const messageId =
    typeof report.messageId === "string"
      ? report.messageId
      : typeof report.celcomMessageId === "string"
        ? report.celcomMessageId
        : null;

  if (!messageId) {
    return;
  }

  const supabase = createAdminClient();
  const status =
    typeof report.status === "string" ? report.status.toLowerCase() : "delivered";

  await supabase
    .from("celcom_sms_logs")
    .update({
      sms_status: status === "failed" ? "failed" : "delivered",
      delivered_at: new Date().toISOString(),
    })
    .eq("celcom_message_id", messageId);
}
