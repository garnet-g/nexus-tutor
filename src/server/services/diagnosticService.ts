import "server-only";

import {
  buildTopicScoresRecord,
  computeInitialHealthScore,
  predictGrade,
} from "@/lib/diagnostic/healthScoreEngine";
import { scoreDiagnosticAttempt } from "@/lib/diagnostic/scoringEngine";
import type { QuestionDifficulty } from "@/lib/diagnostic/types";
import { seedMasteryFromDiagnostic } from "@/lib/mastery/masteryEngine";
import { generateDailyStudyPlan } from "@/lib/studyPlan/studyPlanEngine";
import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { Curriculum, StudentProfile } from "@/types/database";

const QUESTION_COUNT = 20;

const CBC_TOPIC_TARGETS: Record<string, number> = {
  fractions: 6,
  algebra: 7,
  geometry: 7,
};

const KCSE_TOPIC_TARGETS: Record<string, number> = {
  algebra: 4,
  fractions: 4,
  geometry: 4,
  trigonometry: 4,
  statistics: 4,
};

const DIFFICULTY_TARGETS: Record<QuestionDifficulty, number> = {
  easy: 8,
  medium: 8,
  hard: 4,
};

interface DiagnosticQuestionRow {
  id: string;
  topic_id: string;
  question_text: string;
  question_type: string;
  options: unknown;
  correct_answer: unknown;
  difficulty: QuestionDifficulty;
  topics: { code: string; title: string } | { code: string; title: string }[] | null;
}

function shuffle<T>(items: T[]): T[] {
  const copy = [...items];

  for (let index = copy.length - 1; index > 0; index -= 1) {
    const swapIndex = Math.floor(Math.random() * (index + 1));
    [copy[index], copy[swapIndex]] = [copy[swapIndex], copy[index]];
  }

  return copy;
}

function interleave<T>(groups: T[][]): T[] {
  const result: T[] = [];
  const queues = groups.map((group) => [...group]);
  let added = true;

  while (added) {
    added = false;

    for (const queue of queues) {
      const next = queue.shift();

      if (next) {
        result.push(next);
        added = true;
      }
    }
  }

  return result;
}

function getTopicCode(
  topic: DiagnosticQuestionRow["topics"],
): string {
  if (Array.isArray(topic)) {
    return topic[0]?.code ?? "";
  }

  return topic?.code ?? "";
}

function getTopicTitle(
  topic: DiagnosticQuestionRow["topics"],
): string {
  if (Array.isArray(topic)) {
    return topic[0]?.title ?? "Topic";
  }

  return topic?.title ?? "Topic";
}

function selectQuestions(
  questions: DiagnosticQuestionRow[],
  curriculum: Curriculum,
): DiagnosticQuestionRow[] {
  const topicTargets =
    curriculum === "CBC" ? CBC_TOPIC_TARGETS : KCSE_TOPIC_TARGETS;

  const byTopic = new Map<string, DiagnosticQuestionRow[]>();

  for (const question of questions) {
    const code = getTopicCode(question.topics);
    const existing = byTopic.get(code) ?? [];
    existing.push(question);
    byTopic.set(code, existing);
  }

  const selected: DiagnosticQuestionRow[] = [];

  for (const [topicCode, targetCount] of Object.entries(topicTargets)) {
    const topicQuestions = shuffle(byTopic.get(topicCode) ?? []);
    selected.push(...topicQuestions.slice(0, targetCount));
  }

  if (selected.length < QUESTION_COUNT) {
    const selectedIds = new Set(selected.map((question) => question.id));
    const remainder = shuffle(
      questions.filter((question) => !selectedIds.has(question.id)),
    );
    selected.push(...remainder.slice(0, QUESTION_COUNT - selected.length));
  }

  const trimmed = selected.slice(0, QUESTION_COUNT);
  const byDifficulty = {
    easy: [] as DiagnosticQuestionRow[],
    medium: [] as DiagnosticQuestionRow[],
    hard: [] as DiagnosticQuestionRow[],
  };

  for (const question of trimmed) {
    byDifficulty[question.difficulty].push(question);
  }

  const balanced: DiagnosticQuestionRow[] = [];

  for (const [difficulty, targetCount] of Object.entries(DIFFICULTY_TARGETS) as Array<
    [QuestionDifficulty, number]
  >) {
    balanced.push(...shuffle(byDifficulty[difficulty]).slice(0, targetCount));
  }

  if (balanced.length < QUESTION_COUNT) {
    const balancedIds = new Set(balanced.map((question) => question.id));
    balanced.push(
      ...shuffle(trimmed.filter((question) => !balancedIds.has(question.id))).slice(
        0,
        QUESTION_COUNT - balanced.length,
      ),
    );
  }

  const topicGroups = new Map<string, DiagnosticQuestionRow[]>();

  for (const question of balanced.slice(0, QUESTION_COUNT)) {
    const code = getTopicCode(question.topics);
    const group = topicGroups.get(code) ?? [];
    group.push(question);
    topicGroups.set(code, group);
  }

  return interleave(Array.from(topicGroups.values())).slice(0, QUESTION_COUNT);
}

function sanitizeQuestion(question: DiagnosticQuestionRow) {
  return {
    diagnosticQuestionId: question.id,
    topicId: question.topic_id,
    questionText: question.question_text,
    questionType: question.question_type,
    options: question.options,
    difficulty: question.difficulty,
  };
}

function getNairobiDateString(): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(new Date());
}

async function getCurriculumId(curriculum: Curriculum): Promise<string> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("curricula")
    .select("id")
    .eq("code", curriculum)
    .single();

  if (error || !data) {
    throw new Error("Curriculum not found.");
  }

  return data.id;
}

export async function listDiagnosticAssessments(profile: StudentProfile) {
  const admin = createAdminClient();
  const curriculumId = await getCurriculumId(profile.curriculum);

  const { data: assessments, error } = await admin
    .from("diagnostic_assessments")
    .select("id, title, question_count, is_active, subject_id")
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true);

  if (error) {
    throw new Error(error.message);
  }

  const { data: attempts } = await admin
    .from("diagnostic_attempts")
    .select("diagnostic_assessment_id, assessment_status")
    .eq("student_id", profile.id);

  const attemptMap = new Map(
    attempts?.map((attempt) => [
      attempt.diagnostic_assessment_id,
      attempt.assessment_status,
    ]) ?? [],
  );

  return (assessments ?? []).map((assessment) => ({
    id: assessment.id,
    title: assessment.title,
    questionCount: assessment.question_count,
    assessmentStatus: attemptMap.get(assessment.id) ?? "not_started",
    isCompleted: attemptMap.get(assessment.id) === "completed",
  }));
}

export async function startDiagnosticAssessment(
  assessmentId: string,
  profile: StudentProfile,
) {
  const admin = createAdminClient();

  const { data: assessment, error: assessmentError } = await admin
    .from("diagnostic_assessments")
    .select("id, curriculum_id, question_count, curricula(code)")
    .eq("id", assessmentId)
    .eq("is_active", true)
    .maybeSingle();

  if (assessmentError || !assessment) {
    throw new Error("NOT_FOUND");
  }

  const curriculumCode = unwrapSupabaseRelation(
    assessment.curricula as { code: string } | { code: string }[] | null,
  )?.code;

  if (curriculumCode !== profile.curriculum) {
    throw new Error("FORBIDDEN");
  }

  const { data: completedAttempt } = await admin
    .from("diagnostic_attempts")
    .select("id")
    .eq("student_id", profile.id)
    .eq("diagnostic_assessment_id", assessmentId)
    .eq("assessment_status", "completed")
    .maybeSingle();

  if (completedAttempt) {
    throw new Error("CONFLICT");
  }

  const { data: inProgressAttempt } = await admin
    .from("diagnostic_attempts")
    .select("id")
    .eq("student_id", profile.id)
    .eq("diagnostic_assessment_id", assessmentId)
    .eq("assessment_status", "in_progress")
    .maybeSingle();

  let attemptId = inProgressAttempt?.id;

  if (!attemptId) {
    const { data: createdAttempt, error: createError } = await admin
      .from("diagnostic_attempts")
      .insert({
        student_id: profile.id,
        diagnostic_assessment_id: assessmentId,
        assessment_status: "in_progress",
      })
      .select("id")
      .single();

    if (createError || !createdAttempt) {
      throw new Error(createError?.message ?? "Could not start diagnostic.");
    }

    attemptId = createdAttempt.id;
  }

  const { data: questionRows, error: questionError } = await admin
    .from("diagnostic_questions")
    .select(
      "id, topic_id, question_text, question_type, options, correct_answer, difficulty, topics(code, title)",
    )
    .eq("diagnostic_assessment_id", assessmentId)
    .eq("is_active", true);

  if (questionError) {
    throw new Error(questionError.message);
  }

  const selectedQuestions = selectQuestions(
    (questionRows ?? []) as DiagnosticQuestionRow[],
    profile.curriculum,
  );

  if (selectedQuestions.length === 0) {
    throw new Error("NO_QUESTIONS");
  }

  return {
    diagnosticAttemptId: attemptId,
    assessmentStatus: "in_progress" as const,
    questions: selectedQuestions.map(sanitizeQuestion),
  };
}

export async function submitDiagnosticAssessment(
  assessmentId: string,
  attemptId: string,
  profile: StudentProfile,
  answers: Array<{ diagnosticQuestionId: string; studentAnswer: unknown }>,
) {
  const admin = createAdminClient();

  const { data: attempt, error: attemptError } = await admin
    .from("diagnostic_attempts")
    .select("id, assessment_status, diagnostic_assessment_id")
    .eq("id", attemptId)
    .eq("student_id", profile.id)
    .eq("diagnostic_assessment_id", assessmentId)
    .maybeSingle();

  if (attemptError || !attempt) {
    throw new Error("NOT_FOUND");
  }

  if (attempt.assessment_status === "completed") {
    throw new Error("CONFLICT");
  }

  const { data: assessment } = await admin
    .from("diagnostic_assessments")
    .select("id, subject_id")
    .eq("id", assessmentId)
    .single();

  if (!assessment) {
    throw new Error("NOT_FOUND");
  }

  const questionIds = answers.map((answer) => answer.diagnosticQuestionId);
  const { data: questionRows, error: questionError } = await admin
    .from("diagnostic_questions")
    .select(
      "id, topic_id, question_type, correct_answer, difficulty, topics(code, title)",
    )
    .eq("diagnostic_assessment_id", assessmentId)
    .in("id", questionIds);

  if (questionError || !questionRows?.length) {
    throw new Error("VALIDATION_ERROR");
  }

  const scored = scoreDiagnosticAttempt(
    questionRows.map((question) => ({
      diagnosticQuestionId: question.id,
      topicId: question.topic_id,
      topicTitle: getTopicTitle(
        question.topics as DiagnosticQuestionRow["topics"],
      ),
      difficulty: question.difficulty as QuestionDifficulty,
      questionType: question.question_type as
        | "multiple_choice"
        | "numeric"
        | "short_answer",
      correctAnswer: question.correct_answer,
    })),
    answers,
  );

  const healthScore = computeInitialHealthScore(scored.healthScore);
  const predictedGrade = predictGrade(healthScore, profile.curriculum);
  const topicScoresRecord = buildTopicScoresRecord(scored.topicScores);

  await admin
    .from("diagnostic_attempts")
    .update({
      assessment_status: "completed",
      completed_at: new Date().toISOString(),
    })
    .eq("id", attemptId);

  await admin.from("diagnostic_results").insert({
    diagnostic_attempt_id: attemptId,
    student_id: profile.id,
    diagnostic_score: scored.diagnosticScore,
    health_score: healthScore,
    strong_topics: scored.strongTopics.map((topic) => ({
      topicId: topic.topicId,
      title: topic.topicTitle,
      topicScore: topic.topicScore,
    })),
    weak_topics: scored.weakTopics.map((topic) => ({
      topicId: topic.topicId,
      title: topic.topicTitle,
      topicScore: topic.topicScore,
    })),
    recommended_topics: scored.recommendedTopics.map((topic) => ({
      topicId: topic.topicId,
      title: topic.topicTitle,
      topicScore: topic.topicScore,
    })),
  });

  await admin.from("academic_health_scores").insert({
    student_id: profile.id,
    subject_id: assessment.subject_id,
    health_score: healthScore,
    topic_scores: topicScoresRecord,
    predicted_grade: predictedGrade,
  });

  for (const topic of scored.topicScores) {
    await admin.from("topic_mastery").upsert(
      {
        student_id: profile.id,
        topic_id: topic.topicId,
        mastery_percentage: seedMasteryFromDiagnostic(topic.topicScore),
        last_practiced_at: new Date().toISOString(),
      },
      { onConflict: "student_id,topic_id" },
    );
  }

  await admin
    .from("student_profiles")
    .update({ has_completed_diagnostic: true })
    .eq("id", profile.id);

  const { data: existingXp } = await admin
    .from("student_xp")
    .select("total_xp")
    .eq("student_id", profile.id)
    .maybeSingle();

  const totalXp = (existingXp?.total_xp ?? 0) + 100;

  await admin.from("student_xp").upsert(
    {
      student_id: profile.id,
      total_xp: totalXp,
      current_level: Math.max(1, Math.floor(totalXp / 100) + 1),
    },
    { onConflict: "student_id" },
  );

  await admin.from("student_badges").upsert(
    {
      student_id: profile.id,
      badge_code: "first_diagnostic_complete",
    },
    { onConflict: "student_id,badge_code", ignoreDuplicates: true },
  );

  const today = getNairobiDateString();
  await admin.from("daily_goals").upsert(
    {
      student_id: profile.id,
      goal_date: today,
      daily_goal_minutes: 20,
      minutes_completed: 0,
      is_completed: false,
    },
    { onConflict: "student_id,goal_date" },
  );

  const weakTopics = scored.recommendedTopics.map((topic) => ({
    topicId: topic.topicId,
    title: topic.topicTitle,
    masteryPercentage: topic.topicScore,
  }));
  const dailyPlan = generateDailyStudyPlan({
    studentId: profile.id,
    curriculum: profile.curriculum,
    gradeLevel: profile.grade_level,
    healthScore,
    weakTopics,
    topicMastery: topicScoresRecord,
    dailyGoalMinutes: 20,
  });

  await admin
    .from("study_plans")
    .update({ is_active: false })
    .eq("student_id", profile.id)
    .eq("plan_type", "daily");

  const { data: createdPlan } = await admin
    .from("study_plans")
    .insert({
      student_id: profile.id,
      title: dailyPlan.title,
      plan_type: "daily",
      is_active: true,
    })
    .select("id")
    .single();

  if (createdPlan) {
    await admin.from("study_tasks").insert(
      dailyPlan.tasks.map((task) => ({
        study_plan_id: createdPlan.id,
        topic_id: task.topicId,
        task_title: task.taskTitle,
        task_type: task.taskType,
        scheduled_date: task.scheduledDate,
        daily_goal_minutes: task.dailyGoalMinutes,
      })),
    );
  }

  const { sendDiagnosticCompleteNotification } = await import(
    "@/server/services/notificationService"
  );
  await sendDiagnosticCompleteNotification({
    studentId: profile.id,
    phoneNumber: profile.phone_number,
    studentName: profile.full_name,
    healthScore,
  }).catch(() => undefined);

  return {
    diagnosticScore: scored.diagnosticScore,
    healthScore,
    strongTopics: scored.strongTopics.map((topic) => topic.topicTitle),
    weakTopics: scored.weakTopics.map((topic) => topic.topicTitle),
    recommendedTopics: scored.recommendedTopics.map((topic) => topic.topicTitle),
    predictedGrade,
  };
}

export async function getLatestHealthScore(studentId: string) {
  const admin = createAdminClient();
  const { data } = await admin
    .from("academic_health_scores")
    .select("health_score, predicted_grade, topic_scores, calculated_at")
    .eq("student_id", studentId)
    .order("calculated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  return data;
}
