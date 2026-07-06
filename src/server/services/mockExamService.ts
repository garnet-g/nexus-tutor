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
  buildExamAnalysis,
  calculateEndsAt,
  DEFAULT_EXAM_DURATION_MINUTES,
  isExamSessionExpired,
  resolveSessionStatusOnSubmit,
} from "@/lib/mockExams/examSimulatorEngine";
import {
  buildMockExamReview,
  scoreMockExamAnswers,
  selectMockExamQuestions,
  type MockExamReviewQuestion,
  type PracticeQuestionPoolItem,
} from "@/lib/mockExams/mockExamEngine";
import type { QuestionType } from "@/lib/diagnostic/types";
import { createAdminClient } from "@/lib/supabase/admin";
import type { StudentProfile } from "@/types/database";

export type { MockExamReviewQuestion } from "@/lib/mockExams/mockExamEngine";

/** Unwrap a Supabase relation (object or single-element array) to its title. */
function relationTitle(relation: unknown): string {
  const value = Array.isArray(relation) ? relation[0] : relation;
  if (value && typeof value === "object" && "title" in value) {
    return String((value as { title?: unknown }).title ?? "Topic");
  }
  return "Topic";
}

/** Coerce a JSONB options column into a string[] (or null for non-MCQ). */
function toOptionStrings(value: unknown): string[] | null {
  return Array.isArray(value) ? value.map((option) => String(option)) : null;
}
import type { MockExamStyle } from "@/schemas/mockExamSchemas";
import { studentHasMockExamAccess } from "@/schemas/mockExamSchemas";
import { getStudentPlanCode } from "@/server/services/nexUsageService";
import { recordMockExamMistakesNonFatal } from "@/server/services/mistakeJournalService";

async function loadPracticePool(
  curriculum: string,
  topicId?: string | null,
  subjectCode = "mathematics",
): Promise<PracticeQuestionPoolItem[]> {
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
    .eq("code", subjectCode)
    .maybeSingle();

  if (!subject) {
    return [];
  }

  let query = admin
    .from("practice_questions")
    .select(
      "id, question_text, question_type, options, correct_answer, difficulty, explanation, topic_id, topics!inner(id, title, subject_id)",
    )
    .eq("is_active", true)
    .eq("topics.subject_id", subject.id);

  if (topicId) {
    query = query.eq("topic_id", topicId);
  }

  const { data } = await query.limit(200);

  return (data ?? []).map((row) => ({
    id: row.id,
    topicId: row.topic_id,
    topicTitle:
      row.topics && typeof row.topics === "object" && "title" in row.topics
        ? String((row.topics as { title?: string }).title ?? "Topic")
        : "Topic",
    questionText: row.question_text,
    questionType: row.question_type as PracticeQuestionPoolItem["questionType"],
    options: row.options,
    correctAnswer: row.correct_answer,
    difficulty: row.difficulty as PracticeQuestionPoolItem["difficulty"],
    explanation: row.explanation,
  }));
}

export async function generateMockExamSession(
  profile: StudentProfile,
  input: { examStyle: MockExamStyle; topicId?: string; subjectCode?: string },
) {
  if (input.examStyle === "topic_specific" && !input.topicId) {
    throw new Error("VALIDATION");
  }

  const planCode = await getStudentPlanCode(profile.id);
  const isPreview = !studentHasMockExamAccess(planCode);
  const subjectCode = input.subjectCode ?? "mathematics";
  const pool = await loadPracticePool(profile.curriculum, input.topicId, subjectCode);
  const fallbackTopicId = pool[0]?.topicId ?? input.topicId;

  if (!fallbackTopicId) {
    throw new Error("NO_QUESTIONS");
  }

  const drafts = selectMockExamQuestions({
    pool,
    style: input.examStyle,
    isPreview,
    topicId: input.topicId,
    curriculum: profile.curriculum,
    fallbackTopicId,
  });

  const admin = createAdminClient();

  const { data: session, error: sessionError } = await admin
    .from("mock_exam_sessions")
    .insert({
      student_id: profile.id,
      curriculum: profile.curriculum,
      exam_style: input.examStyle,
      topic_id: input.topicId ?? null,
      question_count: drafts.length,
      session_status: "ready",
      is_preview: isPreview,
    })
    .select("id, is_preview, question_count, exam_style")
    .single();

  if (sessionError || !session) {
    throw new Error(sessionError?.message ?? "Could not create mock exam.");
  }

  const { error: questionError } = await admin.from("mock_exam_questions").insert(
    drafts.map((draft) => ({
      mock_exam_session_id: session.id,
      practice_question_id: draft.practiceQuestionId,
      topic_id: draft.topicId,
      question_text: draft.questionText,
      question_type: draft.questionType,
      options: draft.options,
      correct_answer: draft.correctAnswer,
      difficulty: draft.difficulty,
      sort_order: draft.sortOrder,
      explanation: draft.explanation,
    })),
  );

  if (questionError) {
    throw new Error(questionError.message);
  }

  const { data: questions } = await admin
    .from("mock_exam_questions")
    .select("id, question_text, question_type, options, difficulty, sort_order")
    .eq("mock_exam_session_id", session.id)
    .order("sort_order", { ascending: true });

  return {
    mockExamSessionId: session.id,
    examStyle: session.exam_style,
    questionCount: session.question_count,
    isPreview: session.is_preview,
    requiresUpgrade: session.is_preview,
    questions: questions ?? [],
  };
}

async function applyMockExamProgressUpdates(
  profile: StudentProfile,
  marked: Array<{ topicId: string; isCorrect: boolean }>,
) {
  const admin = createAdminClient();
  const topicResults = new Map<string, { correct: number; total: number }>();

  for (const entry of marked) {
    const current = topicResults.get(entry.topicId) ?? { correct: 0, total: 0 };
    current.total += 1;
    if (entry.isCorrect) {
      current.correct += 1;
    }
    topicResults.set(entry.topicId, current);
  }

  const topicIds = [...topicResults.keys()];
  const { data: masteryRows } = await admin
    .from("topic_mastery")
    .select("topic_id, mastery_percentage")
    .eq("student_id", profile.id)
    .in("topic_id", topicIds);

  const existingMastery = Object.fromEntries(
    (masteryRows ?? []).map((row) => [row.topic_id, Number(row.mastery_percentage)]),
  );

  const updates = computeMasteryUpdates(
    [...topicResults.entries()].map(([topicId, result]) => ({
      topicId,
      correct: result.correct,
      total: result.total,
    })),
    existingMastery,
  );

  for (const update of updates) {
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

  const { data: subject } = await admin
    .from("subjects")
    .select("id, curricula!inner(code)")
    .eq("code", "mathematics")
    .maybeSingle();

  if (!subject) {
    return;
  }

  const { data: allMastery } = await admin
    .from("topic_mastery")
    .select("mastery_percentage")
    .eq("student_id", profile.id);

  const { data: diagnosticResult } = await admin
    .from("diagnostic_results")
    .select("health_score")
    .eq("student_id", profile.id)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const averageMastery = averageTopicMastery(
    (allMastery ?? []).map((row) => ({
      topicId: "topic",
      masteryPercentage: Number(row.mastery_percentage),
    })),
  );

  const recentPerformance = Math.round(
    (marked.filter((entry) => entry.isCorrect).length / Math.max(marked.length, 1)) *
      100,
  );

  const healthScore = computeRollingHealthScore({
    diagnosticBaseline: Number(diagnosticResult?.health_score ?? 0),
    averageTopicMastery: averageMastery,
    recentPracticePerformance: recentPerformance,
  });

  const predictedGrade = predictGrade(healthScore, profile.curriculum);

  await admin.from("academic_health_scores").insert({
    student_id: profile.id,
    subject_id: subject.id,
    health_score: healthScore,
    topic_scores: Object.fromEntries(
      updates.map((update) => [update.topicId, update.masteryPercentage]),
    ),
    predicted_grade: predictedGrade,
  });
}

export async function submitMockExamSession(
  profile: StudentProfile,
  mockExamSessionId: string,
  answers: Array<{ questionId: string; studentAnswer: unknown }>,
) {
  const admin = createAdminClient();

  const { data: session } = await admin
    .from("mock_exam_sessions")
    .select("id, student_id, session_status, curriculum")
    .eq("id", mockExamSessionId)
    .eq("student_id", profile.id)
    .maybeSingle();

  if (!session) {
    throw new Error("NOT_FOUND");
  }

  if (session.session_status === "completed") {
    throw new Error("CONFLICT");
  }

  const { data: questions } = await admin
    .from("mock_exam_questions")
    .select(
      "id, topic_id, practice_question_id, question_text, question_type, options, correct_answer, difficulty, sort_order, explanation, topics(title)",
    )
    .eq("mock_exam_session_id", mockExamSessionId)
    .order("sort_order", { ascending: true });

  if (!questions?.length) {
    throw new Error("NOT_FOUND");
  }

  const scored = scoreMockExamAnswers(
    questions.map((question) => ({
      id: question.id,
      topicId: question.topic_id,
      questionType: question.question_type as QuestionType,
      correctAnswer: question.correct_answer,
    })),
    answers,
    gradeAnswer,
  );

  const review: MockExamReviewQuestion[] = buildMockExamReview(
    questions.map((question) => ({
      id: question.id,
      sortOrder: question.sort_order ?? 0,
      questionText: question.question_text,
      questionType: question.question_type as QuestionType,
      options: toOptionStrings(question.options),
      difficulty: question.difficulty as "easy" | "medium" | "hard",
      topicTitle: relationTitle(question.topics),
      correctAnswer: String(question.correct_answer ?? ""),
      explanation: question.explanation ?? null,
    })),
    scored.marked,
  );

  const weakTopicTitles = questions
    .filter((question) => scored.weakTopicIds.includes(question.topic_id))
    .map((question) => relationTitle(question.topics));

  const { data: previousHealth } = await admin
    .from("academic_health_scores")
    .select("predicted_grade")
    .eq("student_id", profile.id)
    .order("calculated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const predictedGrade = predictGrade(scored.scorePercentage, profile.curriculum);
  const analysis = buildExamAnalysis({
    scorePercentage: scored.scorePercentage,
    weakTopicTitles: [...new Set(weakTopicTitles)],
    previousPredictedGrade: previousHealth?.predicted_grade ?? null,
    nextPredictedGrade: predictedGrade,
  });

  const { data: result, error: resultError } = await admin
    .from("mock_exam_results")
    .insert({
      mock_exam_session_id: mockExamSessionId,
      student_id: profile.id,
      score_percentage: scored.scorePercentage,
      correct_count: scored.correctCount,
      total_count: questions.length,
      weak_topics: analysis.weakTopics,
      predicted_grade: analysis.predictedGrade,
      predicted_grade_delta: analysis.predictedGradeDelta,
      answers: scored.marked,
    })
    .select("id")
    .single();

  if (resultError || !result) {
    throw new Error(resultError?.message ?? "Could not save results.");
  }

  await admin
    .from("mock_exam_sessions")
    .update({ session_status: "completed" })
    .eq("id", mockExamSessionId);

  await applyMockExamProgressUpdates(profile, scored.marked);

  await recordMockExamMistakesNonFatal(
    profile.id,
    mockExamSessionId,
    questions.map((question) => ({
      id: question.id,
      topic_id: question.topic_id,
      practice_question_id: question.practice_question_id ?? null,
      question_text: question.question_text,
      correct_answer: question.correct_answer,
      explanation: question.explanation ?? null,
    })),
    scored.marked,
  );

  return {
    resultId: result.id,
    analysis,
    correctCount: scored.correctCount,
    totalCount: questions.length,
    review,
  };
}

export async function startExamSimulatorSession(
  profile: StudentProfile,
  input: { mockExamSessionId: string; durationMinutes?: number },
) {
  const admin = createAdminClient();
  const durationMinutes = input.durationMinutes ?? DEFAULT_EXAM_DURATION_MINUTES;

  const { data: mockSession } = await admin
    .from("mock_exam_sessions")
    .select("id, student_id, session_status")
    .eq("id", input.mockExamSessionId)
    .eq("student_id", profile.id)
    .maybeSingle();

  if (!mockSession) {
    throw new Error("NOT_FOUND");
  }

  if (mockSession.session_status === "completed") {
    throw new Error("CONFLICT");
  }

  const startedAt = new Date();
  const endsAt = calculateEndsAt(startedAt, durationMinutes);

  const { data: simulator, error } = await admin
    .from("exam_simulator_sessions")
    .insert({
      student_id: profile.id,
      mock_exam_session_id: input.mockExamSessionId,
      duration_minutes: durationMinutes,
      started_at: startedAt.toISOString(),
      ends_at: endsAt.toISOString(),
      session_status: "in_progress",
    })
    .select("id, ends_at, duration_minutes")
    .single();

  if (error || !simulator) {
    throw new Error(error?.message ?? "Could not start simulator.");
  }

  await admin
    .from("mock_exam_sessions")
    .update({ session_status: "in_progress" })
    .eq("id", input.mockExamSessionId);

  const { data: questions } = await admin
    .from("mock_exam_questions")
    .select("id, question_text, question_type, options, difficulty, sort_order")
    .eq("mock_exam_session_id", input.mockExamSessionId)
    .order("sort_order", { ascending: true });

  return {
    simulatorSessionId: simulator.id,
    mockExamSessionId: input.mockExamSessionId,
    endsAt: simulator.ends_at,
    durationMinutes: simulator.duration_minutes,
    questions: questions ?? [],
  };
}

export async function submitExamSimulatorSession(
  profile: StudentProfile,
  simulatorSessionId: string,
  answers: Array<{ questionId: string; studentAnswer: unknown }>,
  questionIndex?: number,
) {
  const admin = createAdminClient();

  const { data: simulator } = await admin
    .from("exam_simulator_sessions")
    .select("id, student_id, mock_exam_session_id, session_status, ends_at")
    .eq("id", simulatorSessionId)
    .eq("student_id", profile.id)
    .maybeSingle();

  if (!simulator) {
    throw new Error("NOT_FOUND");
  }

  const expired = isExamSessionExpired(new Date(simulator.ends_at));
  const nextStatus = resolveSessionStatusOnSubmit({
    endsAt: new Date(simulator.ends_at),
  });

  if (simulator.session_status === "completed") {
    throw new Error("CONFLICT");
  }

  await admin
    .from("exam_simulator_sessions")
    .update({
      answers,
      current_question_index: questionIndex ?? 0,
      session_status: nextStatus,
      completed_at: new Date().toISOString(),
    })
    .eq("id", simulatorSessionId);

  const result = await submitMockExamSession(
    profile,
    simulator.mock_exam_session_id,
    answers,
  );

  return {
    ...result,
    expired,
    simulatorSessionId,
  };
}
