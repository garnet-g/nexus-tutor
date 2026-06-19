import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type { StudentProfile } from "@/types/database";
import type { StudentMemoryContext } from "./types";

function parseStringArray(value: unknown): string[] {
  if (!Array.isArray(value)) {
    return [];
  }

  return value
    .map((item) => {
      if (typeof item === "string") {
        return item;
      }
      if (item && typeof item === "object" && "title" in item) {
        return String((item as { title?: string }).title ?? "");
      }
      return "";
    })
    .filter(Boolean);
}

export async function loadStudentMemory(
  student: StudentProfile,
  topicId?: string | null,
): Promise<StudentMemoryContext> {
  const fallback: StudentMemoryContext = {
    studentName: student.full_name,
    curriculum: student.curriculum,
    gradeLevel: student.grade_level,
    targetGrade: student.target_grade,
    healthScore: null,
    predictedGrade: null,
    strongTopics: [],
    weakTopics: [],
    commonErrors: [],
    recentTopics: [],
    confidenceNotes: "No confidence data recorded yet.",
    topicMasteryJson: "{}",
  };

  try {
    const supabase = createAdminClient();

    const [diagnosticResult, healthScoreResult, masteryResult, recentSessions] =
      await Promise.all([
        supabase
          .from("diagnostic_results")
          .select("strong_topics, weak_topics, health_score")
          .eq("student_id", student.id)
          .order("created_at", { ascending: false })
          .limit(1)
          .maybeSingle(),
        supabase
          .from("academic_health_scores")
          .select("health_score, predicted_grade")
          .eq("student_id", student.id)
          .order("calculated_at", { ascending: false })
          .limit(1)
          .maybeSingle(),
        topicId
          ? supabase
              .from("topic_mastery")
              .select("topic_id, mastery_percentage, topics(title)")
              .eq("student_id", student.id)
              .eq("topic_id", topicId)
              .maybeSingle()
          : supabase
              .from("topic_mastery")
              .select("topic_id, mastery_percentage, topics(title)")
              .eq("student_id", student.id)
              .order("mastery_percentage", { ascending: true })
              .limit(5),
        supabase
          .from("nex_sessions")
          .select("topic_id, topics(title)")
          .eq("student_id", student.id)
          .not("topic_id", "is", null)
          .order("started_at", { ascending: false })
          .limit(5),
      ]);

    const strongTopics = parseStringArray(
      diagnosticResult.data?.strong_topics,
    );
    const weakTopics = parseStringArray(diagnosticResult.data?.weak_topics);

    const masteryRows = Array.isArray(masteryResult.data)
      ? masteryResult.data
      : masteryResult.data
        ? [masteryResult.data]
        : [];

    const topicMasteryRecord = masteryRows.reduce<Record<string, number>>(
      (acc, row) => {
        const title =
          row.topics &&
          typeof row.topics === "object" &&
          "title" in row.topics
            ? String((row.topics as { title?: string }).title ?? row.topic_id)
            : row.topic_id;
        acc[title] = Number(row.mastery_percentage ?? 0);
        return acc;
      },
      {},
    );

    const recentTopics = (recentSessions.data ?? [])
      .map((session) => {
        if (
          session.topics &&
          typeof session.topics === "object" &&
          "title" in session.topics
        ) {
          return String((session.topics as { title?: string }).title ?? "");
        }
        return "";
      })
      .filter(Boolean);

    const metadata = student.metadata ?? {};
    const commonErrors = parseStringArray(metadata.commonErrors);

    const healthScore =
      healthScoreResult.data?.health_score ??
      diagnosticResult.data?.health_score ??
      null;

    const lowMasteryTopics = Object.entries(topicMasteryRecord)
      .filter(([, score]) => score < 50)
      .map(([topic]) => topic);

    const confidenceNotes =
      lowMasteryTopics.length > 0
        ? `Student may need encouragement on: ${lowMasteryTopics.join(", ")}.`
        : "Student appears steady across tracked topics.";

    return {
      studentName: student.full_name,
      curriculum: student.curriculum,
      gradeLevel: student.grade_level,
      targetGrade: student.target_grade,
      healthScore:
        healthScore !== null && healthScore !== undefined
          ? Number(healthScore)
          : null,
      predictedGrade: healthScoreResult.data?.predicted_grade ?? null,
      strongTopics,
      weakTopics,
      commonErrors,
      recentTopics,
      confidenceNotes,
      topicMasteryJson: JSON.stringify(topicMasteryRecord, null, 2),
    };
  } catch {
    return fallback;
  }
}
