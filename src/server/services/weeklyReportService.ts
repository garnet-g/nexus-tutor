import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { sendWeeklyParentReportEmail } from "@/server/services/notificationService";
import { getStudentPlanCode } from "@/server/services/subscriptionService";

function getWeekStartDate(date: Date = new Date()): string {
  const nairobi = new Date(
    date.toLocaleString("en-US", { timeZone: "Africa/Nairobi" }),
  );
  const day = nairobi.getDay();
  const diff = day === 0 ? -6 : 1 - day;
  nairobi.setDate(nairobi.getDate() + diff);
  return nairobi.toISOString().slice(0, 10);
}

function getWeekEndDate(weekStart: string): string {
  const start = new Date(`${weekStart}T00:00:00`);
  start.setDate(start.getDate() + 6);
  return start.toISOString().slice(0, 10);
}

async function getWeeklyStudyMinutes(studentId: string, weekStart: string): Promise<number> {
  const admin = createAdminClient();
  const weekEnd = getWeekEndDate(weekStart);

  const { data } = await admin
    .from("study_time_logs")
    .select("duration_seconds")
    .eq("student_id", studentId)
    .gte("logged_at", `${weekStart}T00:00:00`)
    .lte("logged_at", `${weekEnd}T23:59:59`);

  const totalSeconds =
    data?.reduce((sum, row) => sum + (row.duration_seconds ?? 0), 0) ?? 0;
  return Math.round(totalSeconds / 60);
}

async function getLatestHealthForStudent(
  studentId: string,
): Promise<{ healthScore: number; predictedGrade: string | null }> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("academic_health_scores")
    .select("health_score, predicted_grade")
    .eq("student_id", studentId)
    .order("calculated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  return {
    healthScore: Number(data?.health_score ?? 0),
    predictedGrade: data?.predicted_grade ?? null,
  };
}

async function getWeakTopics(studentId: string): Promise<string[]> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("topic_mastery")
    .select("mastery_percentage, topics(title)")
    .eq("student_id", studentId)
    .lt("mastery_percentage", 50)
    .order("mastery_percentage", { ascending: true })
    .limit(5);

  return (
    data?.map((row) => {
      const topic = row.topics as { title?: string } | null;
      return topic?.title ?? "Unknown topic";
    }) ?? []
  );
}

export async function generateWeeklyReportForLink(input: {
  parentId: string;
  studentId: string;
  weekStartDate?: string;
}): Promise<{ reportId: string; emailed: boolean }> {
  const admin = createAdminClient();
  const weekStart = input.weekStartDate ?? getWeekStartDate();

  const { data: link } = await admin
    .from("student_parent_links")
    .select("id, link_status")
    .eq("parent_id", input.parentId)
    .eq("student_id", input.studentId)
    .eq("link_status", "active")
    .maybeSingle();

  if (!link) {
    throw new Error("Parent is not linked to this student");
  }

  const planCode = await getStudentPlanCode(input.studentId);
  const isPremiumLinked = planCode === "premium" || planCode === "family";

  const [studyMinutes, health, weakTopics, studentProfile, parentProfile] =
    await Promise.all([
      getWeeklyStudyMinutes(input.studentId, weekStart),
      getLatestHealthForStudent(input.studentId),
      getWeakTopics(input.studentId),
      admin
        .from("student_profiles")
        .select("full_name, email")
        .eq("id", input.studentId)
        .single(),
      admin
        .from("parent_profiles")
        .select("email")
        .eq("id", input.parentId)
        .single(),
    ]);

  const studentName = studentProfile.data?.full_name ?? "Student";
  const reportPayload = {
    weekStart,
    studyMinutes,
    healthScore: health.healthScore,
    predictedGrade: health.predictedGrade,
    weakTopics,
  };

  const { data: parentReport, error: reportError } = await admin
    .from("parent_reports")
    .insert({
      parent_id: input.parentId,
      student_id: input.studentId,
      report_type: "weekly",
      report_payload: reportPayload,
    })
    .select("id")
    .single();

  if (reportError || !parentReport) {
    throw new Error(reportError?.message ?? "Could not create parent report");
  }

  await admin.from("weekly_reports").insert({
    parent_report_id: parentReport.id,
    week_start_date: weekStart,
    weekly_study_minutes: studyMinutes,
    weekly_health_score: health.healthScore,
    weekly_weak_topics: weakTopics,
    predicted_grade: health.predictedGrade,
  });

  let emailed = false;
  if (isPremiumLinked && parentProfile.data?.email) {
    await sendWeeklyParentReportEmail({
      parentId: input.parentId,
      studentId: input.studentId,
      weekStart,
      recipientEmail: parentProfile.data.email,
      studentName,
      studyMinutes,
      healthScore: health.healthScore,
      weakTopics: weakTopics.join(", ") || "None identified",
    });
    emailed = true;
  }

  return { reportId: parentReport.id, emailed };
}

export async function runWeeklyReportsForAllLinkedStudents(): Promise<{
  processed: number;
  emailed: number;
  errors: string[];
}> {
  const admin = createAdminClient();
  const weekStart = getWeekStartDate();

  const { data: links } = await admin
    .from("student_parent_links")
    .select("parent_id, student_id")
    .eq("link_status", "active");

  let processed = 0;
  let emailed = 0;
  const errors: string[] = [];

  for (const link of links ?? []) {
    try {
      const result = await generateWeeklyReportForLink({
        parentId: link.parent_id,
        studentId: link.student_id,
        weekStartDate: weekStart,
      });
      processed += 1;
      if (result.emailed) {
        emailed += 1;
      }
    } catch (error) {
      errors.push(
        `${link.parent_id}/${link.student_id}: ${
          error instanceof Error ? error.message : "Unknown error"
        }`,
      );
    }
  }

  return { processed, emailed, errors };
}

export interface StudentWeeklySummary {
  weekStart: string;
  weekEnd: string;
  studyMinutes: number;
  healthScore: number;
  predictedGrade: string | null;
  weakTopics: string[];
  activityBreakdown: Array<{ activityType: string; minutes: number }>;
}

/** In-app weekly summary — reuses the same computation as parent email reports. */
export async function getStudentWeeklySummary(
  studentId: string,
  weekStartDate?: string,
): Promise<StudentWeeklySummary> {
  const weekStart = weekStartDate ?? getWeekStartDate();
  const weekEnd = getWeekEndDate(weekStart);
  const admin = createAdminClient();

  const [studyMinutes, health, weakTopics, activityRows] = await Promise.all([
    getWeeklyStudyMinutes(studentId, weekStart),
    getLatestHealthForStudent(studentId),
    getWeakTopics(studentId),
    admin
      .from("study_time_logs")
      .select("activity_type, duration_seconds")
      .eq("student_id", studentId)
      .gte("logged_at", `${weekStart}T00:00:00`)
      .lte("logged_at", `${weekEnd}T23:59:59`),
  ]);

  const breakdown = new Map<string, number>();
  for (const row of activityRows.data ?? []) {
    const type = row.activity_type ?? "other";
    breakdown.set(
      type,
      (breakdown.get(type) ?? 0) + (row.duration_seconds ?? 0),
    );
  }

  const activityBreakdown = Array.from(breakdown.entries())
    .map(([activityType, seconds]) => ({
      activityType,
      minutes: Math.max(1, Math.round(seconds / 60)),
    }))
    .sort((left, right) => right.minutes - left.minutes);

  return {
    weekStart,
    weekEnd,
    studyMinutes,
    healthScore: health.healthScore,
    predictedGrade: health.predictedGrade,
    weakTopics,
    activityBreakdown,
  };
}
