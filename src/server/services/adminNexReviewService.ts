import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type {
  CreateFlagInput,
  NexReviewQueryInput,
} from "@/schemas/adminSchemas";

/**
 * Read + triage service for the Nex safety review surface (Phase 3b).
 *
 * Source tables:
 *  - nex_message_flags (id, message_id, session_id, student_id, reason, source,
 *    status, notes, resolved_by, resolved_at, created_at)
 *  - nex_messages (id, role, message_content, created_at) — flagged message text
 *  - student_profiles (full_name) — who the flag belongs to
 *
 * Writes (resolve / escalate / admin-create) go through the service-role
 * client; the route layer enforces super_admin for resolution.
 */

const DEFAULT_FLAG_LIMIT = 50;

type FlagStatus = "open" | "resolved" | "escalated";
type FlagSource = "student" | "admin" | "system";
type MessageRole = "student" | "nex";

type StudentProfileLite = {
  full_name?: string | null;
};

type FlaggedMessageLite = {
  message_content?: string | null;
  role?: MessageRole | null;
};

type FlagRow = {
  id: string;
  message_id: string | null;
  session_id: string | null;
  student_id: string | null;
  reason: string | null;
  source: FlagSource;
  status: FlagStatus;
  notes: string | null;
  resolved_by: string | null;
  resolved_at: string | null;
  created_at: string;
  student_profiles?: StudentProfileLite | StudentProfileLite[] | null;
  nex_messages?: FlaggedMessageLite | FlaggedMessageLite[] | null;
};

export type NexFlag = {
  id: string;
  messageId: string | null;
  sessionId: string | null;
  studentId: string | null;
  studentName: string | null;
  reason: string | null;
  source: FlagSource;
  status: FlagStatus;
  notes: string | null;
  resolvedBy: string | null;
  resolvedAt: string | null;
  createdAt: string;
  messagePreview: string | null;
  messageRole: MessageRole | null;
};

export type NexConversationMessage = {
  id: string;
  role: MessageRole;
  content: string;
  createdAt: string;
};

function mapFlag(row: FlagRow): NexFlag {
  const profile = unwrapSupabaseRelation<StudentProfileLite>(
    row.student_profiles,
  );
  const message = unwrapSupabaseRelation<FlaggedMessageLite>(row.nex_messages);

  return {
    id: row.id,
    messageId: row.message_id,
    sessionId: row.session_id,
    studentId: row.student_id,
    studentName: profile?.full_name ?? null,
    reason: row.reason,
    source: row.source,
    status: row.status,
    notes: row.notes,
    resolvedBy: row.resolved_by,
    resolvedAt: row.resolved_at,
    createdAt: row.created_at,
    messagePreview: message?.message_content ?? null,
    messageRole: message?.role ?? null,
  };
}

function uniqueNonNull(values: Array<string | null>): string[] {
  return Array.from(
    new Set(values.filter((value): value is string => Boolean(value))),
  );
}

async function hydrateFlags(rows: FlagRow[]): Promise<NexFlag[]> {
  if (rows.length === 0) {
    return [];
  }

  const admin = createAdminClient();
  const studentIds = uniqueNonNull(rows.map((row) => row.student_id));
  const messageIds = uniqueNonNull(rows.map((row) => row.message_id));

  const profileById = new Map<string, StudentProfileLite>();
  if (studentIds.length > 0) {
    const { data, error } = await admin
      .from("student_profiles")
      .select("id, full_name")
      .in("id", studentIds);

    if (error) {
      throw new Error(error.message);
    }

    for (const row of data ?? []) {
      profileById.set(row.id, { full_name: row.full_name ?? null });
    }
  }

  const messageById = new Map<string, FlaggedMessageLite>();
  if (messageIds.length > 0) {
    const { data, error } = await admin
      .from("nex_messages")
      .select("id, message_content, role")
      .in("id", messageIds);

    if (error) {
      throw new Error(error.message);
    }

    for (const row of data ?? []) {
      messageById.set(row.id, {
        message_content: row.message_content ?? null,
        role: row.role ?? null,
      });
    }
  }

  return rows.map((row) =>
    mapFlag({
      ...row,
      student_profiles: row.student_id
        ? (profileById.get(row.student_id) ?? null)
        : null,
      nex_messages: row.message_id
        ? (messageById.get(row.message_id) ?? null)
        : null,
    }),
  );
}

export async function listFlags(
  filters: NexReviewQueryInput = {},
): Promise<NexFlag[]> {
  const admin = createAdminClient();
  const limit = filters.limit ?? DEFAULT_FLAG_LIMIT;

  let query = admin
    .from("nex_message_flags")
    .select(
      "id, message_id, session_id, student_id, reason, source, status, notes, resolved_by, resolved_at, created_at",
    )
    .order("created_at", { ascending: false })
    .limit(limit);

  if (filters.status) {
    query = query.eq("status", filters.status);
  }

  if (filters.before) {
    query = query.lt("created_at", filters.before);
  }

  const { data, error } = await query;

  if (error) {
    throw new Error(error.message);
  }

  return hydrateFlags((data ?? []) as FlagRow[]);
}

export async function getSessionConversation(
  sessionId: string,
): Promise<NexConversationMessage[]> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("nex_messages")
    .select("id, role, message_content, created_at")
    .eq("nex_session_id", sessionId)
    .order("created_at", { ascending: true });

  if (error) {
    throw new Error(error.message);
  }

  return (
    (data ?? []) as {
      id: string;
      role: MessageRole;
      message_content: string;
      created_at: string;
    }[]
  ).map((row) => ({
    id: row.id,
    role: row.role,
    content: row.message_content,
    createdAt: row.created_at,
  }));
}

export async function resolveFlag(input: {
  flagId: string;
  status: "resolved" | "escalated";
  notes?: string;
  resolvedBy: string;
}): Promise<NexFlag | null> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("nex_message_flags")
    .update({
      status: input.status,
      notes: input.notes ?? null,
      resolved_by: input.resolvedBy,
      resolved_at: new Date().toISOString(),
    })
    .eq("id", input.flagId)
    .select(
      "id, message_id, session_id, student_id, reason, source, status, notes, resolved_by, resolved_at, created_at",
    )
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  const hydrated = data ? await hydrateFlags([data as FlagRow]) : [];
  return hydrated[0] ?? null;
}

export async function createAdminFlag(
  input: CreateFlagInput & { studentIdFallback?: string | null },
): Promise<NexFlag | null> {
  const admin = createAdminClient();

  // Resolve session/student from the message when not supplied.
  let sessionId = input.sessionId ?? null;
  let studentId = input.studentId ?? null;

  if (!sessionId || !studentId) {
    const { data: message, error: messageError } = await admin
      .from("nex_messages")
      .select("nex_session_id, student_id")
      .eq("id", input.messageId)
      .maybeSingle();

    if (messageError) {
      throw new Error(messageError.message);
    }

    sessionId = sessionId ?? message?.nex_session_id ?? null;
    studentId = studentId ?? message?.student_id ?? null;
  }

  const { data, error } = await admin
    .from("nex_message_flags")
    .insert({
      message_id: input.messageId,
      session_id: sessionId,
      student_id: studentId,
      reason: input.reason ?? null,
      source: "admin",
      status: "open",
    })
    .select(
      "id, message_id, session_id, student_id, reason, source, status, notes, resolved_by, resolved_at, created_at",
    )
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  const hydrated = data ? await hydrateFlags([data as FlagRow]) : [];
  return hydrated[0] ?? null;
}
