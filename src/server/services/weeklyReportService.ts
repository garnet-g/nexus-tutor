import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  sendParentWeeklyWhatsAppReport,
  sendWeeklyParentReportEmail,
} from "@/server/services/notificationService";
import { getStudentPlanCode } from "@/server/services/subscriptionService";

/** Monday-based week start in Africa/Nairobi (see tests/parent/weeklyReportTimezone.test.ts). */
function getNairobiDateParts(date: Date): {
  year: number;
  month: number;
  day: number;
  weekday: number;
} {
  const parts = new Intl.DateTimeFormat("en-US", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    weekday: "short",
  }).formatToParts(date);

  const lookup = Object.fromEntries(parts.map((part) => [part.type, part.value]));
  const weekdayMap: Record<string, number> = {
    Sun: 0,
    Mon: 1,
    Tue: 2,
    Wed: 3,
    Thu: 4,
    Fri: 5,
    Sat: 6,
  };

  return {
    year: Number(lookup.year),
    month: Number(lookup.month),
    day: Number(lookup.day),
    weekday: weekdayMap[lookup.weekday ?? "Mon"] ?? 1,
  };
}

function addCalendarDays(year: number, month: number, day: number, delta: number): string {
  const shifted = new Date(Date.UTC(year, month - 1, day));
  shifted.setUTCDate(shifted.getUTCDate() + delta);
  return shifted.toISOString().slice(0, 10);
}

export function getWeekStartDate(date: Date = new Date()): string {
  const nairobi = getNairobiDateParts(date);
  const diff = nairobi.weekday === 0 ? -6 : 1 - nairobi.weekday;
  return addCalendarDays(nairobi.year, nairobi.month, nairobi.day, diff);
}

export function getWeekEndDate(weekStart: string): string {
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
}): Promise<{
  reportId: string;
  emailed: boolean;
  whatsapped?: boolean;
  skipped?: boolean;
}> {
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

  const { data: existingReport } = await admin
    .from("parent_reports")
    .select("id")
    .eq("parent_id", input.parentId)
    .eq("student_id", input.studentId)
    .eq("report_type", "weekly")
    .eq("week_start_date", weekStart)
    .maybeSingle();

  if (existingReport) {
    return { reportId: existingReport.id, emailed: false, skipped: true };
  }

  const planCode = await getStudentPlanCode(input.studentId);
  const isPremiumLinked = planCode !== "free";

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
        .select("email, phone_number")
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
      week_start_date: weekStart,
      report_payload: reportPayload,
    })
    .select("id")
    .single();

  if (reportError) {
    if (reportError.code === "23505") {
      const { data: racedReport } = await admin
        .from("parent_reports")
        .select("id")
        .eq("parent_id", input.parentId)
        .eq("student_id", input.studentId)
        .eq("report_type", "weekly")
        .eq("week_start_date", weekStart)
        .maybeSingle();

      if (racedReport) {
        return { reportId: racedReport.id, emailed: false, skipped: true };
      }
    }

    throw new Error(reportError.message ?? "Could not create parent report");
  }

  if (!parentReport) {
    throw new Error("Could not create parent report");
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

  let whatsapped = false;
  if (isPremiumLinked && parentProfile.data?.phone_number) {
    await sendParentWeeklyWhatsAppReport({
      parentId: input.parentId,
      studentId: input.studentId,
      weekStart,
      parentPhone: parentProfile.data.phone_number,
      studentName,
      studyMinutes,
      healthScore: health.healthScore,
      weakTopics: weakTopics.join(", ") || "None identified",
    });
    whatsapped = true;
  }

  return { reportId: parentReport.id, emailed, whatsapped };
}

export async function runWeeklyReportsForAllLinkedStudents(): Promise<{
  processed: number;
  emailed: number;
  whatsapped: number;
  skipped: number;
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
  let whatsapped = 0;
  let skipped = 0;
  const errors: string[] = [];

  for (const link of links ?? []) {
    try {
      const result = await generateWeeklyReportForLink({
        parentId: link.parent_id,
        studentId: link.student_id,
        weekStartDate: weekStart,
      });
      processed += 1;
      if (result.skipped) {
        skipped += 1;
      } else {
        if (result.emailed) {
          emailed += 1;
        }
        if (result.whatsapped) {
          whatsapped += 1;
        }
      }
    } catch (error) {
      errors.push(
        `${link.parent_id}/${link.student_id}: ${
          error instanceof Error ? error.message : "Unknown error"
        }`,
      );
    }
  }

  return { processed, emailed, whatsapped, skipped, errors };
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
