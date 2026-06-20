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
import { createAdminClient } from "@/lib/supabase/admin";
import {
  BADGE_UPSERT_OPTIONS,
  sevenDayStreakBadgeRow,
  shouldAwardSevenDayStreakBadge,
} from "@/lib/gamification/streakBadges";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { StudentProfile } from "@/types/database";

function getNairobiDateString(): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(new Date());
}

function calculateLevel(totalXp: number): number {
  return Math.max(1, Math.floor(totalXp / 100) + 1);
}

async function updateStudentStreak(studentId: string) {
  const admin = createAdminClient();
  const today = getNairobiDateString();
  const { data: streak } = await admin
    .from("student_streaks")
    .select("*")
    .eq("student_id", studentId)
    .maybeSingle();

  if (!streak) {
    await admin.from("student_streaks").insert({
      student_id: studentId,
      current_streak: 1,
      longest_streak: 1,
      last_activity_date: today,
    });
    return 1;
  }

  const lastDate = streak.last_activity_date;
  let currentStreak = streak.current_streak;

  if (lastDate === today) {
    return currentStreak;
  }

  const yesterday = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(new Date(Date.now() - 86_400_000));

  currentStreak = lastDate === yesterday ? currentStreak + 1 : 1;

  await admin
    .from("student_streaks")
    .update({
      current_streak: currentStreak,
      longest_streak: Math.max(streak.longest_streak, currentStreak),
      last_activity_date: today,
    })
    .eq("student_id", studentId);

  if (shouldAwardSevenDayStreakBadge(currentStreak)) {
    await admin.from("student_badges").upsert(
      sevenDayStreakBadgeRow(studentId),
      BADGE_UPSERT_OPTIONS,
    );

    const { data: profile } = await admin
      .from("student_profiles")
      .select("full_name, phone_number")
      .eq("id", studentId)
      .maybeSingle();

    const { sendWeeklyStreakNotification } = await import(
      "@/server/services/notificationService"
    );
    await sendWeeklyStreakNotification({
      studentId,
      phoneNumber: profile?.phone_number ?? null,
      studentName: profile?.full_name ?? "Student",
    }).catch(() => undefined);
  }

  return currentStreak;
}

async function awardPracticeGamification(
  studentId: string,
  topicCode: string | null,
  masteryPercentage: number,
): Promise<{ currentStreak: number; xpEarned: number }> {
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

  const currentStreak = await updateStudentStreak(studentId);
  return { currentStreak, xpEarned };
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

export async function startPracticeSession(
  profile: StudentProfile,
  input: {
    topicId: string;
    difficulty: "easy" | "medium" | "hard";
    questionCount: number;
  },
) {
  const admin = createAdminClient();

  const { data: topic, error: topicError } = await admin
    .from("topics")
    .select("id, title")
    .eq("id", input.topicId)
    .maybeSingle();

  if (topicError || !topic) {
    throw new Error("NOT_FOUND");
  }

  const { data: questionRows, error: questionError } = await admin
    .from("practice_questions")
    .select("id, question_text, question_type, options, difficulty, explanation")
    .eq("topic_id", input.topicId)
    .eq("difficulty", input.difficulty)
    .eq("is_active", true)
    .limit(input.questionCount * 3);

  if (questionError) {
    throw new Error(questionError.message);
  }

  const shuffled = [...(questionRows ?? [])].sort(() => Math.random() - 0.5);
  const selected = shuffled.slice(0, input.questionCount);

  if (selected.length === 0) {
    throw new Error("NO_QUESTIONS");
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
    questions: selected.map((question) => ({
      practiceQuestionId: question.id,
      questionText: question.question_text,
      questionType: question.question_type,
      options: question.options,
      difficulty: question.difficulty,
      explanation:
        question.explanation ?? "Review the core concept for this topic.",
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

  const { currentStreak, xpEarned } = await awardPracticeGamification(
    profile.id,
    topicCode ?? null,
    masteryUpdates[0]?.masteryPercentage ?? 0,
  );

  const { healthScore, predictedGrade } = sessionTopic?.subject_id
    ? await recalculateHealthScore(
        profile.id,
        profile,
        sessionTopic.subject_id,
      )
    : { healthScore: 0, predictedGrade: null };

  const today = getNairobiDateString();
  const minutesCompleted = Math.max(1, Math.round(timeSpentSeconds / 60));
  const { data: dailyGoal } = await admin
    .from("daily_goals")
    .select("*")
    .eq("student_id", profile.id)
    .eq("goal_date", today)
    .maybeSingle();

  const nextMinutes = (dailyGoal?.minutes_completed ?? 0) + minutesCompleted;
  const dailyGoalMinutes = dailyGoal?.daily_goal_minutes ?? 20;

  await admin.from("daily_goals").upsert(
    {
      student_id: profile.id,
      goal_date: today,
      daily_goal_minutes: dailyGoalMinutes,
      minutes_completed: nextMinutes,
      is_completed: nextMinutes >= dailyGoalMinutes,
    },
    { onConflict: "student_id,goal_date" },
  );

  await admin.from("study_time_logs").insert({
    student_id: profile.id,
    activity_type: "practice",
    activity_id: sessionId,
    duration_seconds: timeSpentSeconds,
  });

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
        total_study_time_seconds:
          progress.total_study_time_seconds + timeSpentSeconds,
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
