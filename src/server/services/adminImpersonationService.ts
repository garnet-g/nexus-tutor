import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

/**
 * Audited, time-boxed "view as student" sessions for the super-admin portal
 * (Phase 3a). This NEVER signs in as the user and NEVER issues their JWT — it
 * only records a bounded window during which a super admin renders the student's
 * own data read-only via the service-role client. All access via createAdminClient.
 *
 * Source table: admin_impersonation_sessions.
 */

// View-as sessions are valid for 30 minutes from start.
const IMPERSONATION_TTL_MINUTES = 30;

export type ImpersonationSession = {
  id: string;
  adminUserId: string;
  targetStudentId: string;
  reason: string;
  startedAt: string;
  expiresAt: string;
  endedAt: string | null;
};

export async function startImpersonation(input: {
  adminUserId: string;
  targetStudentId: string;
  reason: string;
}): Promise<ImpersonationSession> {
  const admin = createAdminClient();
  const expiresAt = new Date(
    Date.now() + IMPERSONATION_TTL_MINUTES * 60 * 1000,
  ).toISOString();

  const { data, error } = await admin
    .from("admin_impersonation_sessions")
    .insert({
      admin_user_id: input.adminUserId,
      target_student_id: input.targetStudentId,
      reason: input.reason,
      expires_at: expiresAt,
    })
    .select(
      "id, admin_user_id, target_student_id, reason, started_at, expires_at, ended_at",
    )
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not start view-as session.");
  }

  return mapSession(data);
}

export async function endImpersonation(
  sessionId: string,
  adminUserId: string,
): Promise<ImpersonationSession | null> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("admin_impersonation_sessions")
    .update({ ended_at: new Date().toISOString() })
    .eq("id", sessionId)
    .eq("admin_user_id", adminUserId)
    .is("ended_at", null)
    .select(
      "id, admin_user_id, target_student_id, reason, started_at, expires_at, ended_at",
    )
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }
  if (!data) {
    return null;
  }

  return mapSession(data);
}

/**
 * Returns the session only if it is currently usable: not ended and not expired.
 */
export async function getActiveImpersonation(
  sessionId: string,
): Promise<ImpersonationSession | null> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("admin_impersonation_sessions")
    .select(
      "id, admin_user_id, target_student_id, reason, started_at, expires_at, ended_at",
    )
    .eq("id", sessionId)
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }
  if (!data) {
    return null;
  }

  const session = mapSession(data);
  if (session.endedAt !== null) {
    return null;
  }
  if (new Date(session.expiresAt).getTime() <= Date.now()) {
    return null;
  }

  return session;
}

type SessionRow = {
  id: string;
  admin_user_id: string;
  target_student_id: string;
  reason: string;
  started_at: string;
  expires_at: string;
  ended_at: string | null;
};

function mapSession(row: SessionRow): ImpersonationSession {
  return {
    id: row.id,
    adminUserId: row.admin_user_id,
    targetStudentId: row.target_student_id,
    reason: row.reason,
    startedAt: row.started_at,
    expiresAt: row.expires_at,
    endedAt: row.ended_at ?? null,
  };
}
