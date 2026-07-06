import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";

const TERMINAL_STATUSES = new Set(["completed", "cancelled"]);
const MIN_ELAPSED_RATIO = 0.8;

export class FocusSessionConflictError extends Error {
  readonly code = "FOCUS_SESSION_CONFLICT";

  constructor(message = "Focus session cannot change from a terminal state.") {
    super(message);
    this.name = "FocusSessionConflictError";
  }
}

export class FocusSessionInsufficientElapsedError extends Error {
  readonly code = "FOCUS_INSUFFICIENT_ELAPSED";

  constructor(message = "Focus timer has not finished yet.") {
    super(message);
    this.name = "FocusSessionInsufficientElapsedError";
  }
}

type FocusSessionInput = {
  subject?: string | null;
  topicId?: string | null;
  durationMinutes: number;
  status: "planned" | "in_progress" | "completed" | "cancelled";
};

function computeCreditedMinutes(
  durationMinutes: number,
  startedAt: string,
  completedAt: string,
): number {
  const elapsedMs =
    new Date(completedAt).getTime() - new Date(startedAt).getTime();
  const elapsedMinutes = Math.max(0, Math.floor(elapsedMs / 60_000));
  return Math.min(durationMinutes, elapsedMinutes);
}

export async function listFocusSessions(studentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_focus_sessions")
    .select("*, topics(title)")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(50);

  if (error) return [];
  return (data ?? []).map((row) => {
    const topic = unwrapSupabaseRelation(
      row.topics as { title?: string } | Array<{ title?: string }> | null,
    );
    return {
      id: row.id as string,
      subject: row.subject as string | null,
      topicId: row.topic_id as string | null,
      topicTitle: topic?.title ?? null,
      durationMinutes: row.duration_minutes as number,
      creditedMinutes:
        (row.credited_minutes as number | null) ??
        (row.status === "completed" && row.started_at && row.completed_at
          ? computeCreditedMinutes(
              row.duration_minutes as number,
              String(row.started_at),
              String(row.completed_at),
            )
          : 0),
      status: row.status as "planned" | "in_progress" | "completed" | "cancelled",
      startedAt: row.started_at as string | null,
      completedAt: row.completed_at as string | null,
      createdAt: row.created_at as string,
      updatedAt: row.updated_at as string,
    };
  });
}

export async function createFocusSession(studentId: string, input: FocusSessionInput) {
  const admin = createAdminClient();

  if (input.status === "in_progress") {
    const { count, error: countError } = await admin
      .from("student_focus_sessions")
      .select("id", { count: "exact", head: true })
      .eq("student_id", studentId)
      .eq("status", "in_progress");

    if (countError) {
      throw new Error(countError.message);
    }

    if ((count ?? 0) > 0) {
      throw new FocusSessionConflictError(
        "Finish or cancel your current focus session before starting another.",
      );
    }
  }

  const now = new Date().toISOString();
  const { data, error } = await admin
    .from("student_focus_sessions")
    .insert({
      student_id: studentId,
      subject: input.subject ?? null,
      topic_id: input.topicId ?? null,
      duration_minutes: input.durationMinutes,
      status: input.status,
      started_at: input.status === "in_progress" ? now : null,
      completed_at: null,
      credited_minutes: null,
    })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not create focus session.");
  }

  return data;
}

export async function updateFocusSessionStatus(
  studentId: string,
  id: string,
  status: "planned" | "in_progress" | "completed" | "cancelled",
) {
  const admin = createAdminClient();
  const { data: existing, error: readError } = await admin
    .from("student_focus_sessions")
    .select("id, status, duration_minutes, started_at, completed_at")
    .eq("id", id)
    .eq("student_id", studentId)
    .maybeSingle();

  if (readError) {
    throw new Error(readError.message);
  }

  if (!existing) {
    throw new Error("NOT_FOUND");
  }

  if (TERMINAL_STATUSES.has(existing.status as string)) {
    throw new FocusSessionConflictError();
  }

  const now = new Date().toISOString();
  const patch: Record<string, unknown> = { status };

  if (status === "in_progress") {
    patch.started_at = existing.started_at ?? now;
  }

  if (status === "completed") {
    if (existing.status !== "in_progress" || !existing.started_at) {
      throw new FocusSessionInsufficientElapsedError(
        "Start the timer before completing a focus session.",
      );
    }

    const requiredMs =
      Number(existing.duration_minutes) * 60_000 * MIN_ELAPSED_RATIO;
    const elapsedMs = Date.now() - new Date(String(existing.started_at)).getTime();

    if (elapsedMs < requiredMs) {
      throw new FocusSessionInsufficientElapsedError();
    }

    patch.completed_at = now;
    patch.credited_minutes = computeCreditedMinutes(
      Number(existing.duration_minutes),
      String(existing.started_at),
      now,
    );
  }

  if (status === "cancelled") {
    patch.completed_at = null;
    patch.credited_minutes = null;
  }

  const { data, error } = await admin
    .from("student_focus_sessions")
    .update(patch)
    .eq("id", id)
    .eq("student_id", studentId)
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not update focus session.");
  }

  return data;
}
