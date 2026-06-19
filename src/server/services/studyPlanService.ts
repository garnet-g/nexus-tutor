import "server-only";

import { generateStudyPlan } from "@/lib/studyPlan/studyPlanEngine";
import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { StudentProfile } from "@/types/database";

function getNairobiDateString(): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(new Date());
}

export async function getActiveStudyPlan(studentId: string) {
  const admin = createAdminClient();
  const today = getNairobiDateString();

  const { data: plan } = await admin
    .from("study_plans")
    .select("id, title, plan_type, exam_countdown_days, target_completion_date, created_at")
    .eq("student_id", studentId)
    .eq("is_active", true)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (!plan) {
    return null;
  }

  const { data: tasks } = await admin
    .from("study_tasks")
    .select("id, topic_id, task_title, task_type, scheduled_date, daily_goal_minutes, is_completed, completed_at, topics(title)")
    .eq("study_plan_id", plan.id)
    .eq("scheduled_date", today)
    .order("task_title");

  const { data: dailyGoal } = await admin
    .from("daily_goals")
    .select("*")
    .eq("student_id", studentId)
    .eq("goal_date", today)
    .maybeSingle();

  return {
    id: plan.id,
    title: plan.title,
    planType: plan.plan_type,
    examCountdownDays: plan.exam_countdown_days,
    targetCompletionDate: plan.target_completion_date,
    dailyGoal: dailyGoal
      ? {
          goalDate: dailyGoal.goal_date,
          dailyGoalMinutes: dailyGoal.daily_goal_minutes,
          minutesCompleted: dailyGoal.minutes_completed,
          isCompleted: dailyGoal.is_completed,
        }
      : null,
    tasks:
      tasks?.map((task) => {
        const topic = unwrapSupabaseRelation(
          task.topics as { title?: string } | Array<{ title?: string }> | null,
        );

        return {
          id: task.id,
          topicId: task.topic_id,
          topicTitle: topic?.title ?? null,
          taskTitle: task.task_title,
          taskType: task.task_type,
          scheduledDate: task.scheduled_date,
          dailyGoalMinutes: task.daily_goal_minutes,
          isCompleted: task.is_completed,
          completedAt: task.completed_at,
        };
      }) ?? [],
  };
}

export async function generateStudyPlanForStudent(
  profile: StudentProfile,
  input: {
    planType: "daily" | "exam";
    examCountdownDays?: number;
    dailyGoalMinutes: number;
  },
) {
  const admin = createAdminClient();

  const [{ data: health }, { data: masteryRows }, { data: diagnosticResult }] =
    await Promise.all([
      admin
        .from("academic_health_scores")
        .select("health_score")
        .eq("student_id", profile.id)
        .order("calculated_at", { ascending: false })
        .limit(1)
        .maybeSingle(),
      admin
        .from("topic_mastery")
        .select("topic_id, mastery_percentage, topics(title, code)")
        .eq("student_id", profile.id),
      admin
        .from("diagnostic_results")
        .select("weak_topics")
        .eq("student_id", profile.id)
        .order("created_at", { ascending: false })
        .limit(1)
        .maybeSingle(),
    ]);

  const weakTopicsFromDiagnostic = Array.isArray(diagnosticResult?.weak_topics)
    ? diagnosticResult.weak_topics.map((topic) => {
        const record = topic as { topicId?: string; title?: string; topicScore?: number };
        return {
          topicId: record.topicId ?? "",
          title: record.title ?? "Topic",
          masteryPercentage: record.topicScore ?? 0,
        };
      })
    : [];

  const weakTopics =
    weakTopicsFromDiagnostic.length > 0
      ? weakTopicsFromDiagnostic
      : (masteryRows ?? [])
          .map((row) => {
            const topic = unwrapSupabaseRelation(
              row.topics as { title?: string; code?: string } | Array<{ title?: string; code?: string }> | null,
            );

            return {
              topicId: row.topic_id,
              title: topic?.title ?? "Topic",
              masteryPercentage: Number(row.mastery_percentage),
            };
          })
          .sort((left, right) => left.masteryPercentage - right.masteryPercentage)
          .slice(0, 5);

  const topicMastery = Object.fromEntries(
    (masteryRows ?? []).map((row) => [
      row.topic_id,
      Number(row.mastery_percentage),
    ]),
  );

  const generated = generateStudyPlan({
    studentId: profile.id,
    curriculum: profile.curriculum,
    gradeLevel: profile.grade_level,
    healthScore: Number(health?.health_score ?? 0),
    weakTopics,
    topicMastery,
    examCountdownDays:
      input.planType === "exam" ? input.examCountdownDays : undefined,
    dailyGoalMinutes: input.dailyGoalMinutes,
  });

  await admin
    .from("study_plans")
    .update({ is_active: false })
    .eq("student_id", profile.id)
    .eq("plan_type", generated.planType);

  const { data: createdPlan, error: planError } = await admin
    .from("study_plans")
    .insert({
      student_id: profile.id,
      title: generated.title,
      plan_type: generated.planType,
      exam_countdown_days: generated.examCountdownDays ?? null,
      target_completion_date: generated.targetCompletionDate ?? null,
      is_active: true,
    })
    .select("id")
    .single();

  if (planError || !createdPlan) {
    throw new Error(planError?.message ?? "Could not create study plan.");
  }

  const { data: tasks, error: taskError } = await admin
    .from("study_tasks")
    .insert(
      generated.tasks.map((task) => ({
        study_plan_id: createdPlan.id,
        topic_id: task.topicId,
        task_title: task.taskTitle,
        task_type: task.taskType,
        scheduled_date: task.scheduledDate,
        daily_goal_minutes: task.dailyGoalMinutes,
      })),
    )
    .select("id, topic_id, task_title, task_type, scheduled_date, daily_goal_minutes, is_completed");

  if (taskError) {
    throw new Error(taskError.message);
  }

  const today = getNairobiDateString();
  await admin.from("daily_goals").upsert(
    {
      student_id: profile.id,
      goal_date: today,
      daily_goal_minutes: input.dailyGoalMinutes,
      minutes_completed: 0,
      is_completed: false,
    },
    { onConflict: "student_id,goal_date" },
  );

  return {
    studyPlanId: createdPlan.id,
    title: generated.title,
    planType: generated.planType,
    tasks: tasks ?? [],
  };
}
