import "server-only";

import { gradeAnswer } from "@/lib/diagnostic/scoringEngine";
import {
  computeRollingHealthScore,
  predictGrade,
} from "@/lib/diagnostic/healthScoreEngine";
import {
  averageTopicMastery,
  computeMasteryUpdates,
} from "@/lib/mastery/masteryEngine";
import {
  ACTIVE_SUBJECT_CODES,
  isTopicPracticeReady,
  isTopicVisibleForGrade,
} from "@/lib/curriculum/contentModel";
import {
  emptyQuestionCounts,
  incrementQuestionCount,
  MIN_QUESTIONS_TO_START_PRACTICE,
  nodeNeedsContent,
  practiceReadyByDifficulty,
} from "@/lib/curriculum/practiceCoverage";
import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { StudentProfile } from "@/types/database";
import type {
  PracticeCurriculumSubject,
  PracticeCurriculumSubtopic,
  PracticeCurriculumTopic,
} from "@/types/practice";
import { awardStudyActivity } from "@/server/services/studyActivityService";

function calculateLevel(totalXp: number): number {
  return Math.max(1, Math.floor(totalXp / 100) + 1);
}

async function awardPracticeGamification(
  studentId: string,
  topicCode: string | null,
  masteryPercentage: number,
): Promise<{ xpEarned: number }> {
  const admin = createAdminClient();
  const xpEarned = 50;
  const { data: existingXp } = await admin
    .from("student_xp")
    .select("total_xp")
    .eq("student_id", studentId)
    .maybeSingle();

  const totalXp = (existingXp?.total_xp ?? 0) + xpEarned;

  await admin.from("student_xp").upsert(
    {
      student_id: studentId,
      total_xp: totalXp,
      current_level: calculateLevel(totalXp),
    },
    { onConflict: "student_id" },
  );

  await admin.from("student_badges").upsert(
    {
      student_id: studentId,
      badge_code: "first_practice_complete",
    },
    { onConflict: "student_id,badge_code", ignoreDuplicates: true },
  );

  if (topicCode === "algebra" && masteryPercentage >= 90) {
    await admin.from("student_badges").upsert(
      {
        student_id: studentId,
        badge_code: "algebra_master",
      },
      { onConflict: "student_id,badge_code", ignoreDuplicates: true },
    );
  }

  return { xpEarned };
}

async function recalculateHealthScore(
  studentId: string,
  profile: StudentProfile,
  subjectId: string,
) {
  const admin = createAdminClient();

  const { data: subject } = await admin
    .from("subjects")
    .select("id, code")
    .eq("id", subjectId)
    .maybeSingle();

  if (!subject) {
    return { healthScore: 0, predictedGrade: null };
  }

  const { data: subjectTopics } = await admin
    .from("topics")
    .select("id")
    .eq("subject_id", subjectId);

  const subjectTopicIds = new Set((subjectTopics ?? []).map((topic) => topic.id));

  const { data: diagnosticResult } = await admin
    .from("diagnostic_results")
    .select("health_score")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const { data: masteryRows } = await admin
    .from("topic_mastery")
    .select("topic_id, mastery_percentage")
    .eq("student_id", studentId);

  const subjectMastery = (masteryRows ?? []).filter((row) =>
    subjectTopicIds.has(row.topic_id),
  );

  const averageMastery = averageTopicMastery(
    subjectMastery.map((row) => ({
      topicId: row.topic_id,
      masteryPercentage: Number(row.mastery_percentage),
    })),
  );

  const diagnosticBaseline =
    subject.code === "mathematics"
      ? Number(diagnosticResult?.health_score ?? 0)
      : averageMastery;

  const { data: recentResults } = await admin
    .from("practice_results")
    .select("practice_score, practice_sessions(topic_id)")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(20);

  const subjectRecentScores = (recentResults ?? [])
    .filter((result) => {
      const session = unwrapSupabaseRelation(
        result.practice_sessions as
          | { topic_id?: string }
          | Array<{ topic_id?: string }>
          | null,
      );
      return session?.topic_id ? subjectTopicIds.has(session.topic_id) : false;
    })
    .slice(0, 5)
    .map((result) => Number(result.practice_score));

  const recentPracticePerformance =
    subjectRecentScores.length > 0
      ? Math.round(
          subjectRecentScores.reduce((sum, score) => sum + score, 0) /
            subjectRecentScores.length,
        )
      : diagnosticBaseline;

  const healthScore = computeRollingHealthScore({
    diagnosticBaseline,
    averageTopicMastery: averageMastery,
    recentPracticePerformance,
  });
  const predictedGrade = predictGrade(healthScore, profile.curriculum);

  const topicScores = Object.fromEntries(
    subjectMastery.map((row) => [row.topic_id, Number(row.mastery_percentage)]),
  );

  await admin.from("academic_health_scores").insert({
    student_id: studentId,
    subject_id: subject.id,
    health_score: healthScore,
    topic_scores: topicScores,
    predicted_grade: predictedGrade,
  });

  return { healthScore, predictedGrade };
}

async function getCurriculumId(curriculum: StudentProfile["curriculum"]) {
  const admin = createAdminClient();
  const { data } = await admin
    .from("curricula")
    .select("id")
    .eq("code", curriculum)
    .eq("is_active", true)
    .maybeSingle();

  return data?.id ?? null;
}

async function resolveStudentGradeSortOrder(
  curriculum: StudentProfile["curriculum"],
  gradeLevel: string,
): Promise<number | null> {
  const normalized = gradeLevel.trim();
  if (!normalized) {
    return null;
  }

  const admin = createAdminClient();
  const curriculumId = await getCurriculumId(curriculum);
  if (!curriculumId) {
    return null;
  }

  const { data: byDisplayName } = await admin
    .from("grade_levels")
    .select("sort_order")
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true)
    .eq("display_name", normalized)
    .maybeSingle();

  if (byDisplayName) {
    return byDisplayName.sort_order;
  }

  const normalizedCode = normalized.toLowerCase().replace(/\s+/g, "_");
  const { data: byCode } = await admin
    .from("grade_levels")
    .select("sort_order")
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true)
    .eq("code", normalizedCode)
    .maybeSingle();

  return byCode?.sort_order ?? null;
}

type PracticeTopicRow = {
  id: string;
  title: string;
  subject_id: string;
  min_grade_sort_order: number | null;
  subjects: { curriculum_id: string; code: string } | Array<{ curriculum_id: string; code: string }>;
};

async function validatePracticeTopic(
  profile: StudentProfile,
  topicId: string,
): Promise<PracticeTopicRow> {
  const admin = createAdminClient();
  const curriculumId = await getCurriculumId(profile.curriculum);

  if (!curriculumId) {
    throw new Error("NOT_FOUND");
  }

  const { data: topic, error } = await admin
    .from("topics")
    .select("id, title, subject_id, min_grade_sort_order, subjects(curriculum_id, code)")
    .eq("id", topicId)
    .eq("is_active", true)
    .maybeSingle();

  if (error || !topic) {
    throw new Error("NOT_FOUND");
  }

  const subject = unwrapSupabaseRelation(topic.subjects);
  if (!subject || subject.curriculum_id !== curriculumId) {
    throw new Error("NOT_FOUND");
  }

  const studentGradeSortOrder = await resolveStudentGradeSortOrder(
    profile.curriculum,
    profile.grade_level,
  );

  if (
    !isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder)
  ) {
    throw new Error("NOT_FOUND");
  }

  return topic as PracticeTopicRow;
}

async function validatePracticeSubtopic(topicId: string, subtopicId: string) {
  const admin = createAdminClient();
  const { data: subtopic, error } = await admin
    .from("subtopics")
    .select("id, title, topic_id")
    .eq("id", subtopicId)
    .eq("is_active", true)
    .maybeSingle();

  if (error || !subtopic || subtopic.topic_id !== topicId) {
    throw new Error("INVALID_SUBTOPIC");
  }

  return subtopic;
}

function isPublishableQuestion(row: {
  correct_answer: unknown;
  explanation: string | null;
}) {
  if (row.correct_answer === null || row.correct_answer === undefined) {
    return false;
  }

  return Boolean(row.explanation?.trim());
}

export async function listPracticeCurriculumTree(
  curriculum: StudentProfile["curriculum"],
  gradeLevel: string,
  studentId: string,
): Promise<PracticeCurriculumSubject[]> {
  const admin = createAdminClient();
  const curriculumId = await getCurriculumId(curriculum);

  if (!curriculumId) {
    return [];
  }

  const studentGradeSortOrder = await resolveStudentGradeSortOrder(curriculum, gradeLevel);

  const { data: subjects } = await admin
    .from("subjects")
    .select("id, code, name")
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true)
    .in("code", [...ACTIVE_SUBJECT_CODES])
    .order("name", { ascending: true });

  if (!subjects?.length) {
    return [];
  }

  const subjectIds = subjects.map((subject) => subject.id);
  const { data: topics } = await admin
    .from("topics")
    .select("id, code, title, sort_order, subject_id, min_grade_sort_order")
    .in("subject_id", subjectIds)
    .eq("is_active", true)
    .order("sort_order", { ascending: true });

  const visibleTopics = (topics ?? []).filter((topic) =>
    isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder),
  );

  if (!visibleTopics.length) {
    return subjects.map((subject) => ({
      id: subject.id,
      code: subject.code,
      name: subject.name,
      topics: [],
    }));
  }

  const topicIds = visibleTopics.map((topic) => topic.id);
  const { data: subtopics } = await admin
    .from("subtopics")
    .select("id, code, title, sort_order, topic_id")
    .in("topic_id", topicIds)
    .eq("is_active", true)
    .order("sort_order", { ascending: true });

  const subtopicIds = (subtopics ?? []).map((subtopic) => subtopic.id);
  const { data: lessons } = subtopicIds.length
    ? await admin
        .from("lessons")
        .select("subtopic_id")
        .in("subtopic_id", subtopicIds)
        .eq("is_active", true)
        .eq("review_status", "published")
    : { data: [] };

  const lessonCountBySubtopic = new Map<string, number>();
  for (const lesson of lessons ?? []) {
    lessonCountBySubtopic.set(
      lesson.subtopic_id,
      (lessonCountBySubtopic.get(lesson.subtopic_id) ?? 0) + 1,
    );
  }

  const { data: questionRows } = await admin
    .from("practice_questions")
    .select("topic_id, subtopic_id, difficulty, correct_answer, explanation")
    .in("topic_id", topicIds)
    .eq("is_active", true)
    .eq("review_status", "published");

  const topicQuestionCounts = new Map<string, ReturnType<typeof emptyQuestionCounts>>();
  const subtopicQuestionCounts = new Map<string, ReturnType<typeof emptyQuestionCounts>>();

  for (const question of questionRows ?? []) {
    if (!isPublishableQuestion(question)) {
      continue;
    }

    const topicCounts = topicQuestionCounts.get(question.topic_id) ?? emptyQuestionCounts();
    topicQuestionCounts.set(
      question.topic_id,
      incrementQuestionCount(topicCounts, question.difficulty),
    );

    if (question.subtopic_id) {
      const subtopicCounts =
        subtopicQuestionCounts.get(question.subtopic_id) ?? emptyQuestionCounts();
      subtopicQuestionCounts.set(
        question.subtopic_id,
        incrementQuestionCount(subtopicCounts, question.difficulty),
      );
    }
  }

  const { data: masteryRows } = await admin
    .from("topic_mastery")
    .select("topic_id, mastery_percentage")
    .eq("student_id", studentId);

  const masteryByTopicId = new Map(
    (masteryRows ?? []).map((row) => [row.topic_id, Number(row.mastery_percentage)]),
  );

  const subtopicsByTopic = new Map<string, PracticeCurriculumSubtopic[]>();
  for (const subtopic of subtopics ?? []) {
    const questionCounts = subtopicQuestionCounts.get(subtopic.id) ?? emptyQuestionCounts();
    const entry: PracticeCurriculumSubtopic = {
      id: subtopic.id,
      code: subtopic.code,
      title: subtopic.title,
      lessonCount: lessonCountBySubtopic.get(subtopic.id) ?? 0,
      questionCounts,
      practiceReady: practiceReadyByDifficulty(questionCounts),
      needsContent: nodeNeedsContent(questionCounts),
    };
    const list = subtopicsByTopic.get(subtopic.topic_id) ?? [];
    list.push(entry);
    subtopicsByTopic.set(subtopic.topic_id, list);
  }

  const topicsBySubject = new Map<string, PracticeCurriculumTopic[]>();
  for (const topic of visibleTopics) {
    const questionCounts = topicQuestionCounts.get(topic.id) ?? emptyQuestionCounts();
    if (!isTopicPracticeReady(questionCounts)) {
      continue;
    }

    const topicSubtopics = subtopicsByTopic.get(topic.id) ?? [];
    const lessonCount = topicSubtopics.reduce(
      (total, subtopic) => total + subtopic.lessonCount,
      0,
    );

    const entry: PracticeCurriculumTopic = {
      id: topic.id,
      code: topic.code,
      title: topic.title,
      masteryPercentage: masteryByTopicId.get(topic.id) ?? 0,
      lessonCount,
      questionCounts,
      practiceReady: practiceReadyByDifficulty(questionCounts),
      needsContent: nodeNeedsContent(questionCounts),
      subtopics: topicSubtopics,
    };

    const list = topicsBySubject.get(topic.subject_id) ?? [];
    list.push(entry);
    topicsBySubject.set(topic.subject_id, list);
  }

  return subjects
    .map((subject) => ({
      id: subject.id,
      code: subject.code,
      name: subject.name,
      topics: topicsBySubject.get(subject.id) ?? [],
    }))
    .filter((subject) => subject.topics.length > 0);
}

export async function startPracticeSession(
  profile: StudentProfile,
  input: {
    topicId: string;
    subtopicId?: string;
    difficulty: "easy" | "medium" | "hard";
    questionCount: number;
  },
) {
  const admin = createAdminClient();
  const topic = await validatePracticeTopic(profile, input.topicId);

  let subtopicTitle: string | null = null;
  if (input.subtopicId) {
    const subtopic = await validatePracticeSubtopic(input.topicId, input.subtopicId);
    subtopicTitle = subtopic.title;
  }

  let questionQuery = admin
    .from("practice_questions")
    .select(
      "id, question_text, question_type, options, difficulty, explanation, correct_answer",
    )
    .eq("topic_id", input.topicId)
    .eq("difficulty", input.difficulty)
    .eq("is_active", true)
    .eq("review_status", "published")
    .not("correct_answer", "is", null)
    .not("explanation", "is", null);

  if (input.subtopicId) {
    questionQuery = questionQuery.eq("subtopic_id", input.subtopicId);
  }

  const { data: questionRows, error: questionError } = await questionQuery.limit(
    input.questionCount * 3,
  );

  if (questionError) {
    throw new Error(questionError.message);
  }

  const publishable = (questionRows ?? []).filter((question) =>
    isPublishableQuestion(question),
  );
  const shuffled = [...publishable].sort(() => Math.random() - 0.5);
  const selected = shuffled.slice(0, input.questionCount);

  if (selected.length < MIN_QUESTIONS_TO_START_PRACTICE) {
    throw new Error(
      input.subtopicId ? "NO_QUESTIONS_FOR_SUBTOPIC" : "NO_QUESTIONS_FOR_TOPIC",
    );
  }

  const { data: session, error: sessionError } = await admin
    .from("practice_sessions")
    .insert({
      student_id: profile.id,
      topic_id: input.topicId,
      difficulty: input.difficulty,
      question_count: selected.length,
      session_status: "in_progress",
    })
    .select("id")
    .single();

  if (sessionError || !session) {
    throw new Error(sessionError?.message ?? "Could not start practice session.");
  }

  return {
    practiceSessionId: session.id,
    topicTitle: topic.title,
    subtopicTitle,
    questions: selected.map((question) => ({
      practiceQuestionId: question.id,
      questionText: question.question_text,
      questionType: question.question_type,
      options: question.options,
      difficulty: question.difficulty,
      explanation: question.explanation ?? "Review the core concept for this topic.",
    })),
  };
}

export async function submitPracticeAnswer(
  sessionId: string,
  profile: StudentProfile,
  input: {
    practiceQuestionId: string;
    studentAnswer: unknown;
    timeSpentSeconds: number;
  },
) {
  const admin = createAdminClient();

  const { data: session, error: sessionError } = await admin
    .from("practice_sessions")
    .select("id, session_status, student_id")
    .eq("id", sessionId)
    .eq("student_id", profile.id)
    .maybeSingle();

  if (sessionError || !session) {
    throw new Error("NOT_FOUND");
  }

  if (session.session_status !== "in_progress") {
    throw new Error("CONFLICT");
  }

  const { data: question, error: questionError } = await admin
    .from("practice_questions")
    .select("id, question_type, correct_answer")
    .eq("id", input.practiceQuestionId)
    .maybeSingle();

  if (questionError || !question) {
    throw new Error("NOT_FOUND");
  }

  const isCorrect = gradeAnswer(
    question.question_type as "multiple_choice" | "numeric" | "short_answer",
    question.correct_answer,
    input.studentAnswer,
  );

  const { data: attempt, error: attemptError } = await admin
    .from("practice_attempts")
    .insert({
      practice_session_id: sessionId,
      practice_question_id: input.practiceQuestionId,
      student_answer: input.studentAnswer,
      is_correct: isCorrect,
      time_spent_seconds: input.timeSpentSeconds,
    })
    .select("id, is_correct")
    .single();

  if (attemptError || !attempt) {
    throw new Error(attemptError?.message ?? "Could not save answer.");
  }

  return {
    attemptId: attempt.id,
    isCorrect: attempt.is_correct,
  };
}

export async function completePracticeSession(
  sessionId: string,
  profile: StudentProfile,
  timeSpentSeconds: number,
) {
  const admin = createAdminClient();

  const { data: session, error: sessionError } = await admin
    .from("practice_sessions")
    .select("id, session_status, topic_id, student_id, topics(code, title, subject_id)")
    .eq("id", sessionId)
    .eq("student_id", profile.id)
    .maybeSingle();

  if (sessionError || !session) {
    throw new Error("NOT_FOUND");
  }

  if (session.session_status === "completed") {
    throw new Error("CONFLICT");
  }

  const { data: attempts } = await admin
    .from("practice_attempts")
    .select("is_correct")
    .eq("practice_session_id", sessionId);

  const correctAnswers = (attempts ?? []).filter((attempt) => attempt.is_correct).length;
  const incorrectAnswers = (attempts ?? []).length - correctAnswers;
  const practiceScore =
    attempts && attempts.length > 0
      ? Math.round((correctAnswers / attempts.length) * 100)
      : 0;

  await admin
    .from("practice_sessions")
    .update({
      session_status: "completed",
      completed_at: new Date().toISOString(),
    })
    .eq("id", sessionId);

  const sessionTopic = unwrapSupabaseRelation(
    session.topics as
      | { code?: string; title?: string; subject_id?: string }
      | Array<{ code?: string; title?: string; subject_id?: string }>
      | null,
  );

  await admin.from("practice_results").insert({
    practice_session_id: sessionId,
    student_id: profile.id,
    practice_score: practiceScore,
    correct_answers: correctAnswers,
    incorrect_answers: incorrectAnswers,
    time_spent_seconds: timeSpentSeconds,
    weak_topics:
      practiceScore < 50
        ? [
            {
              topicId: session.topic_id,
              title: sessionTopic?.title ?? "Topic",
            },
          ]
        : [],
  });

  const { data: existingMasteryRows } = await admin
    .from("topic_mastery")
    .select("topic_id, mastery_percentage")
    .eq("student_id", profile.id);

  const existingMastery = Object.fromEntries(
    (existingMasteryRows ?? []).map((row) => [
      row.topic_id,
      Number(row.mastery_percentage),
    ]),
  );

  const masteryUpdates = computeMasteryUpdates(
    [
      {
        topicId: session.topic_id,
        correct: correctAnswers,
        total: attempts?.length ?? 0,
      },
    ],
    existingMastery,
  );

  for (const update of masteryUpdates) {
    await admin.from("topic_mastery").upsert(
      {
        student_id: profile.id,
        topic_id: update.topicId,
        mastery_percentage: update.masteryPercentage,
        last_practiced_at: new Date().toISOString(),
      },
      { onConflict: "student_id,topic_id" },
    );
  }

  const topicCode = sessionTopic?.code ?? null;

  const { xpEarned } = await awardPracticeGamification(
    profile.id,
    topicCode ?? null,
    masteryUpdates[0]?.masteryPercentage ?? 0,
  );

  const { currentStreak } = await awardStudyActivity({
    studentId: profile.id,
    activityType: "practice",
    activityId: sessionId,
    durationSeconds: timeSpentSeconds,
  });

  const { healthScore, predictedGrade } = sessionTopic?.subject_id
    ? await recalculateHealthScore(
        profile.id,
        profile,
        sessionTopic.subject_id,
      )
    : { healthScore: 0, predictedGrade: null };

  const { data: progress } = await admin
    .from("student_progress")
    .select("*")
    .eq("student_id", profile.id)
    .maybeSingle();

  if (progress) {
    await admin
      .from("student_progress")
      .update({
        practice_sessions_completed: progress.practice_sessions_completed + 1,
      })
      .eq("id", progress.id);
  }

  return {
    practiceScore,
    correctAnswers,
    incorrectAnswers,
    masteryUpdates: masteryUpdates.map((update) => ({
      topicId: update.topicId,
      masteryPercentage: update.masteryPercentage,
    })),
    healthScore,
    predictedGrade,
    currentStreak,
    xpEarned,
  };
}

export async function getProgressSummary(studentId: string) {
  const admin = createAdminClient();

  const [{ data: health }, { data: healthBySubject }, { data: masteryRows }, { data: streak }, { data: xp }, { data: badges }] =
    await Promise.all([
      admin
        .from("academic_health_scores")
        .select("health_score, predicted_grade")
        .eq("student_id", studentId)
        .order("calculated_at", { ascending: false })
        .limit(1)
        .maybeSingle(),
      admin
        .from("academic_health_scores")
        .select("health_score, predicted_grade, calculated_at, subject_id, subjects(code, name)")
        .eq("student_id", studentId)
        .order("calculated_at", { ascending: false }),
      admin
        .from("topic_mastery")
        .select("topic_id, mastery_percentage, topics(title)")
        .eq("student_id", studentId),
      admin
        .from("student_streaks")
        .select("current_streak, longest_streak")
        .eq("student_id", studentId)
        .maybeSingle(),
      admin
        .from("student_xp")
        .select("total_xp, current_level")
        .eq("student_id", studentId)
        .maybeSingle(),
      admin
        .from("student_badges")
        .select("badge_code, earned_at")
        .eq("student_id", studentId),
    ]);

  const seenSubjectIds = new Set<string>();
  const subjectHealthScores =
    healthBySubject
      ?.filter((row) => {
        if (!row.subject_id || seenSubjectIds.has(row.subject_id)) {
          return false;
        }

        seenSubjectIds.add(row.subject_id);
        return true;
      })
      .map((row) => {
        const subject = unwrapSupabaseRelation(
          row.subjects as
            | { code?: string; name?: string }
            | Array<{ code?: string; name?: string }>
            | null,
        );

        return {
          subjectCode: subject?.code ?? "unknown",
          subjectName: subject?.name ?? "Subject",
          healthScore: Number(row.health_score),
          predictedGrade: row.predicted_grade ?? null,
        };
      }) ?? [];

  return {
    healthScore: Number(health?.health_score ?? 0),
    predictedGrade: health?.predicted_grade ?? null,
    subjectHealthScores,
    topicMastery:
      masteryRows?.map((row) => {
        const topic = unwrapSupabaseRelation(
          row.topics as { title?: string } | Array<{ title?: string }> | null,
        );

        return {
          topicId: row.topic_id,
          title: topic?.title ?? "Topic",
          masteryPercentage: Number(row.mastery_percentage),
        };
      }) ?? [],
    currentStreak: streak?.current_streak ?? 0,
    longestStreak: streak?.longest_streak ?? 0,
    totalXp: xp?.total_xp ?? 0,
    currentLevel: xp?.current_level ?? 1,
    badges: badges?.map((badge) => badge.badge_code) ?? [],
    badgeEarnedAt: Object.fromEntries(
      (badges ?? []).map((badge) => [badge.badge_code, badge.earned_at]),
    ),
  };
}

export async function listPracticeTopics(curriculum: string) {
  const admin = createAdminClient();

  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("id")
    .eq("code", curriculum)
    .single();

  if (!curriculumRow) {
    return [];
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("id")
    .eq("curriculum_id", curriculumRow.id)
    .eq("code", "mathematics")
    .single();

  if (!subject) {
    return [];
  }

  const { data: topics } = await admin
    .from("topics")
    .select("id, title, code")
    .eq("subject_id", subject.id)
    .eq("is_active", true)
    .order("sort_order");

  return topics ?? [];
}
