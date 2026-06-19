import "server-only";

import { randomBytes } from "node:crypto";

import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";

const INVITE_CODE_TTL_MS = 7 * 24 * 60 * 60 * 1000;
const WEAK_MASTERY_THRESHOLD = 60;

export interface LinkedStudentOverview {
  studentId: string;
  fullName: string;
  gradeLevel: string;
  curriculum: string;
  weeklyStudyMinutes: number;
  healthScore: number | null;
  weakTopics: string[];
  linkedAt: string | null;
}

function generateInviteCodeValue(): string {
  const suffix = randomBytes(3).toString("hex").toUpperCase();
  return `NEXUS-${suffix}`;
}

export async function generateStudentInviteCode(studentId: string): Promise<{
  inviteCode: string;
  expiresAt: string;
}> {
  const admin = createAdminClient();
  const inviteCode = generateInviteCodeValue();
  const expiresAt = new Date(Date.now() + INVITE_CODE_TTL_MS).toISOString();

  const { data: student, error: fetchError } = await admin
    .from("student_profiles")
    .select("metadata")
    .eq("id", studentId)
    .maybeSingle();

  if (fetchError || !student) {
    throw new Error("Student profile not found");
  }

  const metadata = (student.metadata as Record<string, unknown>) ?? {};

  const { error: updateError } = await admin
    .from("student_profiles")
    .update({
      metadata: {
        ...metadata,
        parentInviteCode: inviteCode,
        parentInviteCodeExpiresAt: expiresAt,
      },
    })
    .eq("id", studentId);

  if (updateError) {
    throw new Error(updateError.message);
  }

  return { inviteCode, expiresAt };
}

export async function getStudentInviteCode(studentId: string): Promise<{
  inviteCode: string | null;
  expiresAt: string | null;
}> {
  const admin = createAdminClient();

  const { data: student, error } = await admin
    .from("student_profiles")
    .select("metadata")
    .eq("id", studentId)
    .maybeSingle();

  if (error || !student) {
    throw new Error("Student profile not found");
  }

  const metadata = (student.metadata as Record<string, unknown>) ?? {};
  const inviteCode =
    typeof metadata.parentInviteCode === "string" ? metadata.parentInviteCode : null;
  const expiresAt =
    typeof metadata.parentInviteCodeExpiresAt === "string"
      ? metadata.parentInviteCodeExpiresAt
      : null;

  if (inviteCode && expiresAt && new Date(expiresAt).getTime() < Date.now()) {
    return { inviteCode: null, expiresAt: null };
  }

  return { inviteCode, expiresAt };
}

async function findStudentByInviteCode(inviteCode: string): Promise<{
  id: string;
  full_name: string;
} | null> {
  const admin = createAdminClient();
  const normalizedCode = inviteCode.trim().toUpperCase();

  const { data: students, error } = await admin
    .from("student_profiles")
    .select("id, full_name, metadata")
    .eq("is_active", true);

  if (error || !students) {
    return null;
  }

  for (const student of students) {
    const metadata = (student.metadata as Record<string, unknown>) ?? {};
    const storedCode =
      typeof metadata.parentInviteCode === "string"
        ? metadata.parentInviteCode.toUpperCase()
        : null;
    const expiresAt =
      typeof metadata.parentInviteCodeExpiresAt === "string"
        ? metadata.parentInviteCodeExpiresAt
        : null;

    if (
      storedCode === normalizedCode &&
      expiresAt &&
      new Date(expiresAt).getTime() >= Date.now()
    ) {
      return { id: student.id, full_name: student.full_name };
    }
  }

  return null;
}

export async function linkParentToStudent(
  parentId: string,
  inviteCode: string,
): Promise<{ studentId: string; studentName: string; linkedAt: string }> {
  const student = await findStudentByInviteCode(inviteCode);

  if (!student) {
    throw new Error("Invalid or expired invite code");
  }

  const admin = createAdminClient();
  const linkedAt = new Date().toISOString();

  const { data: existingLink } = await admin
    .from("student_parent_links")
    .select("id, link_status")
    .eq("student_id", student.id)
    .eq("parent_id", parentId)
    .maybeSingle();

  if (existingLink?.link_status === "active") {
    return {
      studentId: student.id,
      studentName: student.full_name,
      linkedAt,
    };
  }

  if (existingLink) {
    const { error: updateError } = await admin
      .from("student_parent_links")
      .update({
        link_status: "active",
        invite_code: inviteCode.trim().toUpperCase(),
        linked_at: linkedAt,
      })
      .eq("id", existingLink.id);

    if (updateError) {
      throw new Error(updateError.message);
    }
  } else {
    const { error: insertError } = await admin.from("student_parent_links").insert({
      student_id: student.id,
      parent_id: parentId,
      link_status: "active",
      invite_code: inviteCode.trim().toUpperCase(),
      linked_at: linkedAt,
    });

    if (insertError) {
      throw new Error(insertError.message);
    }
  }

  return {
    studentId: student.id,
    studentName: student.full_name,
    linkedAt,
  };
}

async function getWeeklyStudyMinutes(studentId: string): Promise<number> {
  const admin = createAdminClient();
  const weekAgo = new Date(Date.now() - 7 * 24 * 60 * 60 * 1000).toISOString();

  const { data: logs } = await admin
    .from("study_time_logs")
    .select("duration_seconds")
    .eq("student_id", studentId)
    .gte("logged_at", weekAgo);

  const totalSeconds =
    logs?.reduce((sum, log) => sum + (log.duration_seconds ?? 0), 0) ?? 0;

  return Math.round(totalSeconds / 60);
}

async function getLatestHealthScore(studentId: string): Promise<number | null> {
  const admin = createAdminClient();

  const { data } = await admin
    .from("academic_health_scores")
    .select("health_score")
    .eq("student_id", studentId)
    .order("calculated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!data?.health_score) {
    return null;
  }

  return Number(data.health_score);
}

async function getWeakTopics(studentId: string): Promise<string[]> {
  const admin = createAdminClient();

  const { data: masteryRows } = await admin
    .from("topic_mastery")
    .select("mastery_percentage, topics(title)")
    .eq("student_id", studentId)
    .lt("mastery_percentage", WEAK_MASTERY_THRESHOLD)
    .order("mastery_percentage", { ascending: true })
    .limit(5);

  if (!masteryRows) {
    return [];
  }

  return masteryRows
    .map((row) => {
      const topics = row.topics;
      if (topics && typeof topics === "object" && "title" in topics) {
        return String((topics as { title?: string }).title ?? "");
      }
      return "";
    })
    .filter(Boolean);
}

export async function getLinkedStudentsOverview(
  parentId: string,
): Promise<LinkedStudentOverview[]> {
  const supabase = await createClient();

  const { data: links, error: linksError } = await supabase
    .from("student_parent_links")
    .select(
      "linked_at, student_profiles(id, full_name, grade_level, curriculum)",
    )
    .eq("parent_id", parentId)
    .eq("link_status", "active");

  if (linksError || !links) {
    return [];
  }

  const overviews: LinkedStudentOverview[] = [];

  for (const link of links) {
    const profile = link.student_profiles;
    if (
      !profile ||
      typeof profile !== "object" ||
      !("id" in profile)
    ) {
      continue;
    }

    const studentId = String((profile as { id: string }).id);
    const fullName = String((profile as { full_name?: string }).full_name ?? "");
    const gradeLevel = String((profile as { grade_level?: string }).grade_level ?? "");
    const curriculum = String((profile as { curriculum?: string }).curriculum ?? "");

    const [weeklyStudyMinutes, healthScore, weakTopics] = await Promise.all([
      getWeeklyStudyMinutes(studentId),
      getLatestHealthScore(studentId),
      getWeakTopics(studentId),
    ]);

    overviews.push({
      studentId,
      fullName,
      gradeLevel,
      curriculum,
      weeklyStudyMinutes,
      healthScore,
      weakTopics,
      linkedAt: link.linked_at,
    });
  }

  return overviews;
}
