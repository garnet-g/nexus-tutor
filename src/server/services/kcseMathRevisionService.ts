import "server-only";

import {
  buildKcseMathRevisionHub,
  type KcseFormLevel,
  type KcseMathRevisionHubModel,
  type KcseMathRevisionTopicInput,
} from "@/lib/revision/kcseMathRevisionEngine";
import { createAdminClient } from "@/lib/supabase/admin";
import { getProgressSummary } from "@/server/services/practiceService";
import { getActiveStudyPlan } from "@/server/services/studyPlanService";
import type { StudentProfile } from "@/types/database";

function formLevelFromMinGrade(minGradeSortOrder: number | null): KcseFormLevel {
  const sortOrder = minGradeSortOrder ?? 1;
  if (sortOrder === 2) return "Form 2";
  if (sortOrder === 3) return "Form 3";
  if (sortOrder >= 4) return "Form 4";
  return "Form 1";
}

async function listKcseMathRevisionTopics(
  curriculum: string,
): Promise<KcseMathRevisionTopicInput[]> {
  const admin = createAdminClient();

  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("id")
    .eq("code", curriculum)
    .maybeSingle();

  if (!curriculumRow) {
    return [];
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("id")
    .eq("curriculum_id", curriculumRow.id)
    .eq("code", "mathematics")
    .maybeSingle();

  if (!subject) {
    return [];
  }

  const { data: topics } = await admin
    .from("topics")
    .select("id, code, title, sort_order, min_grade_sort_order")
    .eq("subject_id", subject.id)
    .eq("is_active", true)
    .order("min_grade_sort_order", { ascending: true })
    .order("sort_order", { ascending: true });

  return (topics ?? []).map((topic) => ({
    id: topic.id,
    code: topic.code,
    title: topic.title,
    sortOrder: Number(topic.sort_order ?? 0),
    formLevel: formLevelFromMinGrade(
      typeof topic.min_grade_sort_order === "number"
        ? topic.min_grade_sort_order
        : 1,
    ),
  }));
}

export async function getKcseMathRevisionHub(
  profile: StudentProfile,
): Promise<KcseMathRevisionHubModel> {
  return getKcseMathRevisionHubForStudent({
    studentId: profile.id,
    studentName: profile.full_name,
    curriculum: profile.curriculum,
    gradeLevel: profile.grade_level,
  });
}

export async function getKcseMathRevisionHubForStudent(input: {
  studentId: string;
  studentName: string;
  curriculum: string;
  gradeLevel: string;
}): Promise<KcseMathRevisionHubModel> {
  const [topics, progress, studyPlan] = await Promise.all([
    listKcseMathRevisionTopics(input.curriculum),
    getProgressSummary(input.studentId),
    getActiveStudyPlan(input.studentId),
  ]);

  const mathematicsHealth = progress.subjectHealthScores.find(
    (subject) => subject.subjectCode === "mathematics",
  );

  return buildKcseMathRevisionHub({
    studentName: input.studentName,
    curriculum: input.curriculum,
    gradeLevel: input.gradeLevel.replaceAll("_", " "),
    healthScore: mathematicsHealth?.healthScore ?? progress.healthScore,
    predictedGrade: mathematicsHealth?.predictedGrade ?? progress.predictedGrade,
    topics,
    topicMastery: progress.topicMastery,
    activeStudyPlan: studyPlan
      ? {
          title: studyPlan.title,
          dailyGoalMinutes: studyPlan.dailyGoal?.dailyGoalMinutes ?? null,
          tasks: studyPlan.tasks.map((task) => ({
            id: task.id,
            topicId: task.topicId,
            topicTitle: task.topicTitle,
            taskTitle: task.taskTitle,
            taskType: task.taskType,
            dailyGoalMinutes: task.dailyGoalMinutes,
            isCompleted: task.isCompleted,
          })),
        }
      : null,
  });
}
