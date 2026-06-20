import "server-only";

import { computeMasteryUpdates } from "@/lib/mastery/masteryEngine";
import { resolveLessonStudyDurationSeconds } from "@/lib/learn/lessonDuration";
import { createAdminClient } from "@/lib/supabase/admin";
import type { Curriculum } from "@/types/database";
import { getLesson } from "@/server/services/curriculumService";
import { awardStudyActivity } from "@/server/services/studyActivityService";

const LESSON_XP = 25;

export async function getCompletedLessonIdsForTopic(
  studentId: string,
  topicId: string,
): Promise<Set<string>> {
  const admin = createAdminClient();

  const { data: subtopics } = await admin
    .from("subtopics")
    .select("id")
    .eq("topic_id", topicId)
    .eq("is_active", true);

  const subtopicIds = (subtopics ?? []).map((row) => row.id);
  if (subtopicIds.length === 0) {
    return new Set();
  }

  const { data: lessons } = await admin
    .from("lessons")
    .select("id")
    .in("subtopic_id", subtopicIds)
    .eq("is_active", true);

  const lessonIds = (lessons ?? []).map((row) => row.id);
  if (lessonIds.length === 0) {
    return new Set();
  }

  const { data: progressRows } = await admin
    .from("lesson_progress")
    .select("lesson_id")
    .eq("student_id", studentId)
    .eq("status", "completed")
    .in("lesson_id", lessonIds);

  return new Set((progressRows ?? []).map((row) => row.lesson_id));
}

export async function getLessonProgressState(
  studentId: string,
  lessonId: string,
): Promise<{
  status: "in_progress" | "completed" | null;
  completedAt: string | null;
  lastViewedAt: string | null;
}> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("lesson_progress")
    .select("status, completed_at, last_viewed_at")
    .eq("student_id", studentId)
    .eq("lesson_id", lessonId)
    .maybeSingle();

  if (!data) {
    return { status: null, completedAt: null, lastViewedAt: null };
  }

  return {
    status: data.status as "in_progress" | "completed",
    completedAt: data.completed_at,
    lastViewedAt: data.last_viewed_at,
  };
}

export async function markLessonViewed(
  studentId: string,
  lessonId: string,
  curriculum: Curriculum,
  gradeLevel: string,
) {
  const lesson = await getLesson(lessonId, curriculum, gradeLevel);
  if (!lesson) {
    throw new Error("NOT_FOUND");
  }

  const admin = createAdminClient();
  const now = new Date().toISOString();

  const { data: existing } = await admin
    .from("lesson_progress")
    .select("id, status, completed_at")
    .eq("student_id", studentId)
    .eq("lesson_id", lessonId)
    .maybeSingle();

  if (existing?.status === "completed") {
    await admin
      .from("lesson_progress")
      .update({ last_viewed_at: now })
      .eq("id", existing.id);
  } else {
    await admin.from("lesson_progress").upsert(
      {
        student_id: studentId,
        lesson_id: lessonId,
        status: "in_progress",
        last_viewed_at: now,
        completed_at: null,
      },
      { onConflict: "student_id,lesson_id" },
    );
  }

  return { lessonId, lastViewedAt: now };
}

export async function completeLesson(
  studentId: string,
  lessonId: string,
  curriculum: Curriculum,
  gradeLevel: string,
  input: { durationSeconds?: number; quizPassed?: boolean },
) {
  const lesson = await getLesson(lessonId, curriculum, gradeLevel);
  if (!lesson) {
    throw new Error("NOT_FOUND");
  }

  const admin = createAdminClient();
  const now = new Date().toISOString();

  const { data: existing } = await admin
    .from("lesson_progress")
    .select("id, status, completed_at")
    .eq("student_id", studentId)
    .eq("lesson_id", lessonId)
    .maybeSingle();

  if (existing?.status === "completed" && existing.completed_at) {
    return {
      alreadyCompleted: true,
      lessonId,
      completedAt: existing.completed_at,
      xpEarned: 0,
      currentStreak: null as number | null,
    };
  }

  const durationSeconds = resolveLessonStudyDurationSeconds(
    input.durationSeconds,
    lesson.estimatedMinutes,
  );

  await admin.from("lesson_progress").upsert(
    {
      student_id: studentId,
      lesson_id: lessonId,
      status: "completed",
      completed_at: now,
      last_viewed_at: now,
    },
    { onConflict: "student_id,lesson_id" },
  );

  const { currentStreak, xpEarned } = await awardStudyActivity({
    studentId,
    activityType: "lesson",
    activityId: lessonId,
    durationSeconds,
    xpEarned: LESSON_XP,
  });

  if (input.quizPassed) {
    const { data: existingMasteryRows } = await admin
      .from("topic_mastery")
      .select("topic_id, mastery_percentage")
      .eq("student_id", studentId);

    const existingMastery = Object.fromEntries(
      (existingMasteryRows ?? []).map((row) => [
        row.topic_id,
        Number(row.mastery_percentage),
      ]),
    );

    const masteryUpdates = computeMasteryUpdates(
      [{ topicId: lesson.topicId, correct: 1, total: 1 }],
      existingMastery,
    );

    for (const update of masteryUpdates) {
      await admin.from("topic_mastery").upsert(
        {
          student_id: studentId,
          topic_id: update.topicId,
          mastery_percentage: update.masteryPercentage,
          last_practiced_at: now,
        },
        { onConflict: "student_id,topic_id" },
      );
    }
  }

  return {
    alreadyCompleted: false,
    lessonId,
    completedAt: now,
    xpEarned,
    currentStreak,
    durationSeconds,
  };
}
