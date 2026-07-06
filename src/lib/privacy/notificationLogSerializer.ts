import {
  redactEmailAddress,
  redactMessageBody,
  redactPhoneNumber,
} from "@/lib/privacy/redaction";

export type SmsLogExportRow = {
  id: string;
  templateCode: string | null;
  phoneNumber: string;
  smsBody: string;
  smsStatus: string;
  createdAt: string;
};

export type EmailLogExportRow = {
  id: string;
  templateCode: string | null;
  recipientEmail: string;
  emailSubject: string;
  emailStatus: string;
  createdAt: string;
};

export function serializeSmsLogForExport(row: SmsLogExportRow) {
  return {
    id: row.id,
    templateCode: row.templateCode,
    phoneNumber: redactPhoneNumber(row.phoneNumber),
    smsBody: redactMessageBody(row.smsBody),
    smsStatus: row.smsStatus,
    createdAt: row.createdAt,
  };
}

export function serializeEmailLogForExport(row: EmailLogExportRow) {
  return {
    id: row.id,
    templateCode: row.templateCode,
    recipientEmail: redactEmailAddress(row.recipientEmail),
    emailSubject: redactMessageBody(row.emailSubject),
    emailStatus: row.emailStatus,
    createdAt: row.createdAt,
  };
}

export function buildNotificationLogExportSnapshot(rows: {
  sms: SmsLogExportRow[];
  email: EmailLogExportRow[];
}) {
  return {
    sms: rows.sms.map(serializeSmsLogForExport),
    email: rows.email.map(serializeEmailLogForExport),
  };
}
