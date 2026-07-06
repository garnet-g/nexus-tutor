import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { levelFromXp } from "@/lib/gamification";
import { unwrapSupabaseRelation } from "@/lib/utils";
import {
  buildStudentActionBadges,
  buildStudentExperienceSnapshot,
  type StudentActionBadgeInput,
} from "@/features/student/studentExperience";
import { getProgressSummary } from "@/server/services/practiceService";
import { getActiveStudyPlan } from "@/server/services/studyPlanService";
import { getStudentPlanCode } from "@/server/services/subscriptionService";
import { getStudentWeeklySummary } from "@/server/services/weeklyReportService";
import {
  createFocusSession,
  listFocusSessions,
  updateFocusSessionStatus,
} from "@/server/services/focusSessionService";
import type { StudentProfile } from "@/types/database";

type SavedItemInput = {
  itemType: "question" | "lesson" | "topic" | "note";
  itemId?: string | null;
  title: string;
  description?: string | null;
  href: string;
  metadata?: Record<string, unknown>;
};

type MistakeInput = {
  questionId?: string | null;
  topicId?: string | null;
  questionText: string;
  chosenAnswer?: string | null;
  correctAnswer?: string | null;
  explanation?: string | null;
  source: "practice" | "mock_exam" | "manual";
  status: "open" | "retried" | "mastered";
};

type WeeklyGoalInput = {
  weekStartDate?: string;
  targetMinutes: number;
  targetTasks: number;
  parentVisible: boolean;
  note?: string | null;
};

type FocusSessionInput = {
  subject?: string | null;
  topicId?: string | null;
  durationMinutes: number;
  status: "planned" | "in_progress" | "completed" | "cancelled";
};

type OfflinePackInput = {
  packKey: string;
  title: string;
  description?: string | null;
  status: "ready" | "downloaded" | "expired";
  sizeKb: number;
};

export type StudentExperienceData = Awaited<
  ReturnType<typeof getStudentExperienceData>
>;

export function getNairobiDateString(date: Date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(date);
}

export function getWeekStartDate(date: Date = new Date()): string {
  const nairobi = new Date(
    date.toLocaleString("en-US", { timeZone: "Africa/Nairobi" }),
  );
  const day = nairobi.getDay();
  const diff = day === 0 ? -6 : 1 - day;
  nairobi.setDate(nairobi.getDate() + diff);
  return nairobi.toISOString().slice(0, 10);
}

export async function getStudentExperienceData(profile: StudentProfile) {
  const [
    progress,
    studyPlan,
    weeklySummary,
    planCode,
    savedItems,
    mistakes,
    weeklyGoal,
    focusSessions,
    offlinePacks,
    recentLessons,
    recentPractice,
    recentMockResults,
  ] = await Promise.all([
    getProgressSummary(profile.id),
    getActiveStudyPlan(profile.id),
    getStudentWeeklySummary(profile.id).catch(() => null),
    getStudentPlanCode(profile.id).catch(() => "free"),
    listSavedItems(profile.id),
    listMistakes(profile.id),
    getWeeklyGoal(profile.id),
    listFocusSessions(profile.id),
    listOfflinePacks(profile.id),
    listRecentLessonProgress(profile.id),
    listRecentPractice(profile.id),
    listRecentMockResults(profile.id),
  ]);

  const sortedMastery = progress.topicMastery
    .slice()
    .sort((left, right) => left.masteryPercentage - right.masteryPercentage);
  const weakAreas = sortedMastery.filter((topic) => topic.masteryPercentage < 70);
  const recommendedTask = studyPlan?.tasks.find((task) => task.topicTitle);
  const recommendedTopic = recommendedTask
    ? {
        title: recommendedTask.topicTitle ?? recommendedTask.taskTitle,
        topicId: recommendedTask.topicId,
        masteryPercentage:
          progress.topicMastery.find((topic) => topic.topicId === recommendedTask.topicId)
            ?.masteryPercentage ?? null,
      }
    : sortedMastery[0] ?? null;
  const nextTask = recommendedTask
    ? {
        title: recommendedTask.taskTitle || recommendedTask.topicTitle || "Continue studying",
        href: recommendedTask.topicId
          ? `/practice?topicId=${recommendedTask.topicId}`
          : "/practice",
      }
    : recentLessons[0]
      ? {
          title: recentLessons[0].lessonTitle,
          href: recentLessons[0].href,
        }
      : null;

  const dailyGoalMinutes = studyPlan?.dailyGoal?.dailyGoalMinutes ?? 20;
  const completedMinutes = studyPlan?.dailyGoal?.minutesCompleted ?? 0;
  const focusMinutesToday = focusSessions
    .filter((session) => {
      if (session.status !== "completed" || !session.completedAt) return false;
      return session.completedAt.startsWith(getNairobiDateString());
    })
    .reduce((sum, session) => sum + (session.creditedMinutes ?? 0), 0);
  const dueTasks = (studyPlan?.tasks ?? []).filter((task) => !task.isCompleted).length;
  const mistakesToReview = mistakes.filter((mistake) => mistake.status !== "mastered").length;
  const offlinePacksReady = offlinePacks.filter((pack) => pack.status !== "expired").length;

  const badgeInput: StudentActionBadgeInput = {
    dueTasks,
    weakAreas: weakAreas.length,
    savedItems: savedItems.length,
    mistakesToReview,
    focusMinutesToday,
    offlinePacksReady,
  };

  const snapshot = buildStudentExperienceSnapshot({
    studentFirstName: profile.full_name?.split(" ")[0],
    healthScore: progress.healthScore,
    predictedGrade: progress.predictedGrade,
    currentStreak: progress.currentStreak,
    totalXp: progress.totalXp,
    recommendedTopic,
    nextTask,
    dailyGoalMinutes,
    completedMinutes,
    weeklyGoalMinutes: weeklyGoal?.targetMinutes ?? 120,
    weeklyCompletedMinutes: weeklySummary?.studyMinutes ?? completedMinutes,
    ...badgeInput,
  });

  return {
    profile,
    progress,
    studyPlan,
    weeklySummary,
    weeklyGoal,
    planCode,
    level: levelFromXp(progress.totalXp),
    savedItems,
    mistakes,
    focusSessions,
    offlinePacks,
    recentLessons,
    recentPractice,
    recentMockResults,
    weakAreas,
    recommendedTopic,
    nextTask,
    badgeInput,
    navBadges: buildStudentActionBadges(badgeInput),
    snapshot,
  };
}

export async function getStudentChromeData(profile: StudentProfile) {
  const [progress, studyPlan, savedItems, mistakes, focusSessions, offlinePacks, planCode] =
    await Promise.all([
      getProgressSummary(profile.id),
      getActiveStudyPlan(profile.id),
      listSavedItems(profile.id),
      listMistakes(profile.id),
      listFocusSessions(profile.id),
      listOfflinePacks(profile.id),
      getStudentPlanCode(profile.id).catch(() => "free"),
    ]);

  const weakAreas = progress.topicMastery.filter(
    (topic) => topic.masteryPercentage < 70,
  );
  const today = getNairobiDateString();
  const focusMinutesToday = focusSessions
    .filter(
      (session) =>
        session.status === "completed" &&
        Boolean(session.completedAt?.startsWith(today)),
    )
    .reduce((sum, session) => sum + (session.creditedMinutes ?? 0), 0);
  const badgeInput: StudentActionBadgeInput = {
    dueTasks: (studyPlan?.tasks ?? []).filter((task) => !task.isCompleted).length,
    weakAreas: weakAreas.length,
    savedItems: savedItems.length,
    mistakesToReview: mistakes.filter((mistake) => mistake.status !== "mastered").length,
    focusMinutesToday,
    offlinePacksReady: offlinePacks.filter((pack) => pack.status !== "expired").length,
  };

  return {
    currentStreak: progress.currentStreak,
    totalXp: progress.totalXp,
    planCode,
    navBadges: buildStudentActionBadges(badgeInput),
  };
}

export async function listSavedItems(studentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_saved_items")
    .select("*")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(100);

  if (error) return [];
  return (data ?? []).map((row) => ({
    id: row.id as string,
    itemType: row.item_type as "question" | "lesson" | "topic" | "note",
    itemId: row.item_id as string | null,
    title: row.title as string,
    description: row.description as string | null,
    href: row.href as string,
    metadata: (row.metadata ?? {}) as Record<string, unknown>,
    createdAt: row.created_at as string,
    updatedAt: row.updated_at as string,
  }));
}

export async function findSavedItemByReference(
  studentId: string,
  itemType: "question" | "lesson" | "topic" | "note",
  itemId: string,
) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_saved_items")
    .select("id")
    .eq("student_id", studentId)
    .eq("item_type", itemType)
    .eq("item_id", itemId)
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  return data ? { id: String(data.id) } : null;
}

export async function saveStudentItem(studentId: string, input: SavedItemInput) {
  if (input.itemId) {
    const existing = await findSavedItemByReference(
      studentId,
      input.itemType,
      input.itemId,
    );
    if (existing) {
      const items = await listSavedItems(studentId);
      const match = items.find((item) => item.id === existing.id);
      if (match) {
        return match;
      }
    }
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_saved_items")
    .insert({
      student_id: studentId,
      item_type: input.itemType,
      item_id: input.itemId ?? null,
      title: input.title,
      description: input.description ?? null,
      href: input.href,
      metadata: input.metadata ?? {},
    })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save item.");
  }

  return {
    id: data.id as string,
    itemType: data.item_type as "question" | "lesson" | "topic" | "note",
    itemId: data.item_id as string | null,
    title: data.title as string,
    description: data.description as string | null,
    href: data.href as string,
    metadata: (data.metadata ?? {}) as Record<string, unknown>,
    createdAt: data.created_at as string,
    updatedAt: data.updated_at as string,
  };
}

export async function deleteSavedItemByReference(
  studentId: string,
  itemType: "question" | "lesson" | "topic" | "note",
  itemId: string,
) {
  const existing = await findSavedItemByReference(studentId, itemType, itemId);
  if (!existing) {
    return false;
  }

  await deleteSavedItem(studentId, existing.id);
  return true;
}

export async function deleteSavedItem(studentId: string, id: string) {
  const admin = createAdminClient();
  const { error } = await admin
    .from("student_saved_items")
    .delete()
    .eq("id", id)
    .eq("student_id", studentId);

  if (error) throw new Error(error.message);
}

export async function listMistakes(studentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_mistake_journal")
    .select("*, topics(title)")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(100);

  if (error) return [];
  return (data ?? []).map((row) => {
    const topic = unwrapSupabaseRelation(
      row.topics as { title?: string } | Array<{ title?: string }> | null,
    );
    return {
      id: row.id as string,
      questionId: row.question_id as string | null,
      topicId: row.topic_id as string | null,
      topicTitle: topic?.title ?? null,
      questionText: row.question_text as string,
      chosenAnswer: row.chosen_answer as string | null,
      correctAnswer: row.correct_answer as string | null,
      explanation: row.explanation as string | null,
      source: row.source as "practice" | "mock_exam" | "manual",
      status: row.status as "open" | "retried" | "mastered",
      createdAt: row.created_at as string,
      updatedAt: row.updated_at as string,
    };
  });
}

export async function addMistake(studentId: string, input: MistakeInput) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_mistake_journal")
    .insert({
      student_id: studentId,
      question_id: input.questionId ?? null,
      topic_id: input.topicId ?? null,
      question_text: input.questionText,
      chosen_answer: input.chosenAnswer ?? null,
      correct_answer: input.correctAnswer ?? null,
      explanation: input.explanation ?? null,
      source: input.source,
      status: input.status,
    })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save mistake.");
  }

  return data;
}

export async function updateMistakeStatus(
  studentId: string,
  id: string,
  status: "open" | "retried" | "mastered",
) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_mistake_journal")
    .update({ status })
    .eq("id", id)
    .eq("student_id", studentId)
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not update mistake.");
  }

  return data;
}

export async function getWeeklyGoal(studentId: string, weekStart = getWeekStartDate()) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_weekly_goals")
    .select("*")
    .eq("student_id", studentId)
    .eq("week_start_date", weekStart)
    .maybeSingle();

  if (error || !data) return null;
  return {
    id: data.id as string,
    weekStartDate: data.week_start_date as string,
    targetMinutes: data.target_minutes as number,
    targetTasks: data.target_tasks as number,
    parentVisible: data.parent_visible as boolean,
    note: data.note as string | null,
    createdAt: data.created_at as string,
    updatedAt: data.updated_at as string,
  };
}

export async function upsertWeeklyGoal(studentId: string, input: WeeklyGoalInput) {
  const weekStartDate = input.weekStartDate ?? getWeekStartDate();
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_weekly_goals")
    .upsert(
      {
        student_id: studentId,
        week_start_date: weekStartDate,
        target_minutes: input.targetMinutes,
        target_tasks: input.targetTasks,
        parent_visible: input.parentVisible,
        note: input.note ?? null,
      },
      { onConflict: "student_id,week_start_date" },
    )
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save weekly goal.");
  }

  return data;
}

export { createFocusSession, listFocusSessions, updateFocusSessionStatus };

export async function listOfflinePacks(studentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_offline_packs")
    .select("*")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(50);

  if (error) return [];
  return (data ?? []).map((row) => ({
    id: row.id as string,
    packKey: row.pack_key as string,
    title: row.title as string,
    description: row.description as string | null,
    status: row.status as "ready" | "downloaded" | "expired",
    sizeKb: row.size_kb as number,
    cachedAt: row.cached_at as string | null,
    createdAt: row.created_at as string,
    updatedAt: row.updated_at as string,
  }));
}

export async function upsertOfflinePack(studentId: string, input: OfflinePackInput) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_offline_packs")
    .upsert(
      {
        student_id: studentId,
        pack_key: input.packKey,
        title: input.title,
        description: input.description ?? null,
        status: input.status,
        size_kb: input.sizeKb,
        cached_at: input.status === "downloaded" ? new Date().toISOString() : null,
      },
      { onConflict: "student_id,pack_key" },
    )
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save offline pack.");
  }

  return data;
}

export async function updateOfflinePackStatus(
  studentId: string,
  id: string,
  status: "ready" | "downloaded" | "expired",
) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_offline_packs")
    .update({
      status,
      cached_at: status === "downloaded" ? new Date().toISOString() : null,
    })
    .eq("id", id)
    .eq("student_id", studentId)
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not update offline pack.");
  }

  return data;
}

async function listRecentLessonProgress(studentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("lesson_progress")
    .select("lesson_id, status, last_viewed_at, completed_at, lessons(title, subtopics(topic_id, title, topics(title)))")
    .eq("student_id", studentId)
    .order("last_viewed_at", { ascending: false })
    .limit(5);

  if (error) return [];
  return (data ?? []).map((row) => {
    const lesson = unwrapSupabaseRelation(
      row.lessons as
        | {
            title?: string;
            subtopics?: { topic_id?: string; title?: string; topics?: { title?: string } };
          }
        | Array<{
            title?: string;
            subtopics?: { topic_id?: string; title?: string; topics?: { title?: string } };
          }>
        | null,
    );
    const subtopic = unwrapSupabaseRelation(lesson?.subtopics ?? null);
    const topic = unwrapSupabaseRelation(subtopic?.topics ?? null);
    return {
      lessonId: row.lesson_id as string,
      lessonTitle: lesson?.title ?? "Continue lesson",
      topicTitle: topic?.title ?? subtopic?.title ?? "Topic",
      href: subtopic?.topic_id
        ? `/learn/${subtopic.topic_id}/${row.lesson_id}`
        : `/learn`,
      status: row.status as "in_progress" | "completed",
      lastViewedAt: row.last_viewed_at as string | null,
      completedAt: row.completed_at as string | null,
    };
  });
}

async function listRecentPractice(studentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("practice_sessions")
    .select("id, topic_id, difficulty, session_status, created_at, completed_at, topics(title)")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(5);

  if (error) return [];
  return (data ?? []).map((row) => {
    const topic = unwrapSupabaseRelation(
      row.topics as { title?: string } | Array<{ title?: string }> | null,
    );
    return {
      id: row.id as string,
      topicId: row.topic_id as string,
      topicTitle: topic?.title ?? "Practice topic",
      difficulty: row.difficulty as string,
      status: row.session_status as string,
      href: `/practice?topicId=${row.topic_id}`,
      createdAt: row.created_at as string,
      completedAt: row.completed_at as string | null,
    };
  });
}

async function listRecentMockResults(studentId: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("mock_exam_results")
    .select("id, score_percentage, predicted_grade, weak_topics, created_at")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(5);

  if (error) return [];
  return (data ?? []).map((row) => ({
    id: row.id as string,
    scorePercentage: Number(row.score_percentage ?? 0),
    predictedGrade: row.predicted_grade as string | null,
    weakTopics: Array.isArray(row.weak_topics) ? row.weak_topics : [],
    createdAt: row.created_at as string,
  }));
}
