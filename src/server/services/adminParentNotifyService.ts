import "server-only";

import { sendCelcomSms } from "@/lib/celcom/celcomClient";
import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import { recordAdminAudit } from "@/server/services/adminAuditService";

/**
 * At-risk parent SMS service (Phase 3b).
 *
 * Source tables:
 *  - student_parent_links (student_id, parent_id, link_status) — active link only
 *  - parent_profiles (id, full_name, phone_number)
 *  - celcom_sms_logs — written by sendCelcomSms() (do NOT double-insert here)
 *
 * HARD RULES: super_admin only (enforced at the route), ONE recipient per call,
 * the message is supplied explicitly by the caller (no silent mass templating),
 * every send is logged to celcom_sms_logs (via the celcom client) and audited.
 */

type ParentProfileLite = {
  id?: string | null;
  full_name?: string | null;
  phone_number?: string | null;
};

type LinkRow = {
  parent_id: string | null;
  parent_profiles: ParentProfileLite | ParentProfileLite[] | null;
};

export type ParentContact = {
  parentId: string;
  parentName: string | null;
  phone: string;
};

/** Mask a phone number for audit metadata, keeping the last 3 digits. */
function maskPhone(phone: string): string {
  if (phone.length <= 3) {
    return "***";
  }
  return `***${phone.slice(-3)}`;
}

export async function resolveParentContact(
  studentId: string,
): Promise<ParentContact | null> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("student_parent_links")
    .select("parent_id, parent_profiles(id, full_name, phone_number)")
    .eq("student_id", studentId)
    .eq("link_status", "active")
    .order("linked_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  if (!data) {
    return null;
  }

  const profile = unwrapSupabaseRelation<ParentProfileLite>(
    (data as LinkRow).parent_profiles,
  );
  const phone = profile?.phone_number?.trim();

  if (!profile?.id || !phone) {
    return null;
  }

  return {
    parentId: profile.id,
    parentName: profile.full_name ?? null,
    phone,
  };
}

export type SendParentSmsResult =
  | {
      ok: true;
      parentName: string | null;
      smsStatus: "queued" | "sent" | "delivered" | "failed";
    }
  | { ok: false; code: "NO_PARENT_PHONE"; message: string };

export async function sendParentSms(input: {
  studentId: string;
  message: string;
  adminUserId: string;
  adminRole?: string;
  request?: Request;
}): Promise<SendParentSmsResult> {
  const contact = await resolveParentContact(input.studentId);

  if (!contact) {
    await recordAdminAudit({
      actorUserId: input.adminUserId,
      actorRole: input.adminRole ?? "super_admin",
      action: "parent.sms.send",
      targetType: "student",
      targetId: input.studentId,
      metadata: {
        studentId: input.studentId,
        smsStatus: "no_parent_phone",
      },
      request: input.request,
    });

    return {
      ok: false,
      code: "NO_PARENT_PHONE",
      message: "No active parent with a phone number is linked to this student.",
    };
  }

  // sendCelcomSms writes the celcom_sms_logs row itself.
  const result = await sendCelcomSms({
    phoneNumber: contact.phone,
    smsBody: input.message,
    studentId: input.studentId,
    parentId: contact.parentId,
  });

  await recordAdminAudit({
    actorUserId: input.adminUserId,
    actorRole: input.adminRole ?? "super_admin",
    action: "parent.sms.send",
    targetType: "student",
    targetId: input.studentId,
    metadata: {
      studentId: input.studentId,
      parentPhone: maskPhone(contact.phone),
      smsStatus: result.smsStatus,
    },
    request: input.request,
  });

  return {
    ok: true,
    parentName: contact.parentName,
    smsStatus: result.smsStatus,
  };
}
