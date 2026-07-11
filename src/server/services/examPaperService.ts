import "server-only";

import { randomInt } from "node:crypto";

import { computeRollingHealthScore, predictGrade } from "@/lib/diagnostic/healthScoreEngine";
import { applySelfMarkedMethodMarks, autoMarkExamPaperAnswers, buildVerifiedTopicResults, composeExamPaperScore, type AnswerKeyPart, type AutoMarkedPart, type SelfMarkClaim, type StudentPartAnswer } from "@/lib/examPapers/markingEngine";
import { instantiateTemplate, type ExamPaperTemplateBody } from "@/lib/examPapers/templateInstantiation";
import { assembleExamPaper, hasSufficientTemplateBank, type TemplateRecord } from "@/lib/examPapers/paperAssembly";
import { mulberry32 } from "@/lib/examPapers/paramSampler";
import { calculateEndsAt, EXAM_PAPER_DURATION_MINUTES, isSessionExpired } from "@/lib/examPapers/sessionTiming";
import { parseFormLevel } from "@/lib/examPapers/formScope";
import { computeMasteryUpdates, averageTopicMastery } from "@/lib/mastery/masteryEngine";
import { createAdminClient } from "@/lib/supabase/admin";
import { studentHasExamPaperAccess, FREE_EXAM_PAPER_SAMPLE_QUESTION_COUNT } from "@/schemas/examPaperSchemas";
import { getStudentPlanCode } from "@/server/services/nexUsageService";
import { generateStudyPlanForStudent } from "@/server/services/studyPlanService";
import type { StudentProfile } from "@/types/database";

type AdminClient = ReturnType<typeof createAdminClient>;

const RECENT_SESSIONS_LOOKBACK = 3;

async function loadTemplatePool(admin: AdminClient, paper: 1 | 2): Promise<TemplateRecord[]> {
  const { data } = await admin
    .from("exam_paper_templates")
    .select("id, paper, section, form_level, topic_id, marks, body")
    .eq("review_status", "approved")
    .eq("is_active", true);

  return (data ?? [])
    .filter((row: any) => row.paper === paper)
    .map((row: any) => ({
      id: row.id,
      paper: row.paper as 1 | 2,
      section: row.section as "I" | "II",
      formLevel: row.form_level,
      topicId: row.topic_id,
      marks: row.marks,
      body: row.body as ExamPaperTemplateBody,
    }));
}

async function loadRecentTemplateIds(admin: AdminClient, studentId: string): Promise<string[]> {
  const { data: recentSessions } = await admin
    .from("exam_paper_sessions")
    .select("id")
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(RECENT_SESSIONS_LOOKBACK);

  const sessionIds = (recentSessions ?? []).map((row: any) => row.id);
  if (sessionIds.length === 0) return [];

  const { data: questions } = await admin
    .from("exam_paper_session_questions")
    .select("template_id")
    .in("session_id", sessionIds);

  return (questions ?? []).map((row: any) => row.template_id);
}

async function insertSessionQuestion(
  admin: AdminClient,
  sessionId: string,
  template: TemplateRecord,
  questionNumber: number,
  section: "I" | "II",
  chosen: boolean,
  rng: () => number,
): Promise<void> {
  const instantiated = instantiateTemplate(template.body as ExamPaperTemplateBody, rng);

  const { data: sessionQuestion, error } = await admin
    .from("exam_paper_session_questions")
    .insert({
      session_id: sessionId,
      template_id: template.id,
      question_number: questionNumber,
      section,
      topic_id: template.topicId,
      params: instantiated.params,
      rendered_stem: instantiated.renderedStem,
      rendered_parts: instantiated.parts.map((part) => ({
        label: part.label,
        prompt: part.prompt,
        marks: part.marks,
        answerType: part.answerType,
      })),
      chosen,
      sort_order: questionNumber,
    })
    .select("id")
    .single();

  if (error || !sessionQuestion) {
    throw new Error(error?.message ?? "Could not create exam paper session question");
  }

  const { error: keyError } = await admin.from("exam_paper_session_answer_keys").insert({
    session_question_id: sessionQuestion.id,
    answer_key: instantiated.parts.map((part) => ({
      label: part.label,
      computedAnswer: part.computedAnswer,
      tolerance: part.tolerance,
      marks: part.marks,
    })),
    mark_scheme: instantiated.markScheme,
  });

  if (keyError) {
    throw new Error(keyError.message);
  }
}

export type GenerateExamPaperResult =
  | { status: "cbc_unavailable" }
  | { status: "insufficient_bank"; formScope: number }
  | { status: "generated"; sessionId: string; endsAt: string; totalMarks: number; isSample: boolean };

export async function generateExamPaperSession(
  profile: StudentProfile,
  input: { paper: 1 | 2 },
): Promise<GenerateExamPaperResult> {
  if (profile.curriculum !== "KCSE") {
    return { status: "cbc_unavailable" };
  }

  const admin = createAdminClient();
  const formScope = parseFormLevel(profile.grade_level);
  const planCode = await getStudentPlanCode(profile.id);
  const isSample = !studentHasExamPaperAccess(planCode);

  const [templates, recentTemplateIds] = await Promise.all([
    loadTemplatePool(admin, input.paper),
    loadRecentTemplateIds(admin, profile.id),
  ]);

  if (!hasSufficientTemplateBank(templates, input.paper, formScope)) {
    return { status: "insufficient_bank", formScope };
  }

  const rng = mulberry32(randomInt(0, 2 ** 31 - 1));
  const assembled = assembleExamPaper({
    templates,
    paper: input.paper,
    formLevel: formScope,
    excludedTemplateIds: recentTemplateIds,
    rng,
  });

  const sectionOne = isSample
    ? assembled.sectionOne.slice(0, FREE_EXAM_PAPER_SAMPLE_QUESTION_COUNT)
    : assembled.sectionOne;
  const sectionTwo = isSample ? [] : assembled.sectionTwo;

  const startedAt = new Date();
  const endsAt = calculateEndsAt(startedAt, EXAM_PAPER_DURATION_MINUTES);
  const totalMarks = sectionOne.reduce((sum, t) => sum + t.marks, 0) + Math.min(sectionTwo.length, 5) * 10;

  const { data: session, error: sessionError } = await admin
    .from("exam_paper_sessions")
    .insert({
      student_id: profile.id,
      paper: input.paper,
      form_scope: formScope,
      status: "in_progress",
      total_marks: totalMarks,
      started_at: startedAt.toISOString(),
      ends_at: endsAt.toISOString(),
    })
    .select("id")
    .single();

  if (sessionError || !session) {
    throw new Error(sessionError?.message ?? "Could not create exam paper session");
  }

  let questionNumber = 1;
  for (const template of sectionOne) {
    await insertSessionQuestion(admin, session.id, template, questionNumber, "I", true, rng);
    questionNumber += 1;
  }
  for (const template of sectionTwo) {
    await insertSessionQuestion(admin, session.id, template, questionNumber, "II", false, rng);
    questionNumber += 1;
  }

  return { status: "generated", sessionId: session.id, endsAt: endsAt.toISOString(), totalMarks, isSample };
}

export interface ExamPaperSittingQuestion {
  sessionQuestionId: string;
  questionNumber: number;
  section: "I" | "II";
  chosen: boolean;
  renderedStem: string;
  parts: Array<{ label: string; prompt: string; marks: number; answerType: "numeric" | "short_answer" }>;
}

export interface ExamPaperSittingView {
  sessionId: string;
  paper: 1 | 2;
  status: string;
  endsAt: string;
  totalMarks: number;
  questions: ExamPaperSittingQuestion[];
}

export async function getExamPaperSessionForSitting(
  sessionId: string,
  studentId: string,
): Promise<ExamPaperSittingView | null> {
  const admin = createAdminClient();

  const { data: session } = await admin
    .from("exam_paper_sessions")
    .select("id, paper, status, ends_at, total_marks")
    .eq("id", sessionId)
    .eq("student_id", studentId)
    .maybeSingle();

  if (!session) return null;

  let status = session.status;
  if (status === "in_progress" && isSessionExpired(new Date(session.ends_at))) {
    await admin.from("exam_paper_sessions").update({ status: "expired" }).eq("id", sessionId);
    status = "expired";
  }

  const { data: questions } = await admin
    .from("exam_paper_session_questions")
    .select("id, question_number, section, chosen, rendered_stem, rendered_parts")
    .eq("session_id", sessionId)
    .order("sort_order", { ascending: true });

  return {
    sessionId: session.id,
    paper: session.paper as 1 | 2,
    status,
    endsAt: session.ends_at,
    totalMarks: session.total_marks,
    questions: (questions ?? []).map((q: any) => ({
      sessionQuestionId: q.id,
      questionNumber: q.question_number,
      section: q.section as "I" | "II",
      chosen: q.chosen,
      renderedStem: q.rendered_stem,
      parts: q.rendered_parts as ExamPaperSittingQuestion["parts"],
    })),
  };
}

export async function chooseSectionTwoQuestions(
  sessionId: string,
  studentId: string,
  sessionQuestionIds: string[],
): Promise<void> {
  const admin = createAdminClient();

  const { data: session } = await admin
    .from("exam_paper_sessions")
    .select("id, status")
    .eq("id", sessionId)
    .eq("student_id", studentId)
    .maybeSingle();

  if (!session) throw new Error("NOT_FOUND");
  if (session.status !== "in_progress") throw new Error("CONFLICT");

  const { data: sectionTwoQuestions } = await admin
    .from("exam_paper_session_questions")
    .select("id, chosen")
    .eq("session_id", sessionId)
    .eq("section", "II");

  const validIds = new Set((sectionTwoQuestions ?? []).map((q: any) => q.id));
  if (!sessionQuestionIds.every((id) => validIds.has(id))) {
    throw new Error("VALIDATION");
  }

  const currentlyChosen = new Set(
    (sectionTwoQuestions ?? []).filter((q: any) => q.chosen).map((q: any) => q.id),
  );
  const beingDeselected = [...currentlyChosen].filter((id) => !sessionQuestionIds.includes(id as string));

  if (beingDeselected.length > 0) {
    const { data: existingAnswers } = await admin
      .from("exam_paper_answers")
      .select("session_question_id")
      .in("session_question_id", beingDeselected);

    if ((existingAnswers ?? []).length > 0) {
      throw new Error("CONFLICT");
    }
  }

  await admin
    .from("exam_paper_session_questions")
    .update({ chosen: false })
    .eq("session_id", sessionId)
    .eq("section", "II");

  await admin.from("exam_paper_session_questions").update({ chosen: true }).in("id", sessionQuestionIds);
}

export interface SubmitExamPaperResult {
  verifiedMarks: number;
  totalMarks: number;
  scorePercentage: number;
  attemptPredictedGrade: string;
  rollingPredictedGrade: string;
}

export async function submitExamPaperFinalAnswers(
  sessionId: string,
  profile: StudentProfile,
  answers: StudentPartAnswer[],
): Promise<SubmitExamPaperResult> {
  const admin = createAdminClient();

  const { data: session } = await admin
    .from("exam_paper_sessions")
    .select("id, status, total_marks")
    .eq("id", sessionId)
    .eq("student_id", profile.id)
    .maybeSingle();

  if (!session) throw new Error("NOT_FOUND");
  if (session.status !== "in_progress" && session.status !== "expired") {
    throw new Error("CONFLICT");
  }

  const { data: chosenQuestions } = await admin
    .from("exam_paper_session_questions")
    .select("id, topic_id")
    .eq("session_id", sessionId)
    .eq("chosen", true);

  const chosenIds = (chosenQuestions ?? []).map((q: any) => q.id);
  const topicByQuestionId = new Map((chosenQuestions ?? []).map((q: any) => [q.id, q.topic_id]));

  const { data: answerKeyRows } = await admin
    .from("exam_paper_session_answer_keys")
    .select("session_question_id, answer_key")
    .in("session_question_id", chosenIds);

  const answerKey: AnswerKeyPart[] = (answerKeyRows ?? []).flatMap((row: any) =>
    (row.answer_key as Array<{ label: string; computedAnswer: string; tolerance: number; marks: number }>).map(
      (part) => ({
        sessionQuestionId: row.session_question_id,
        partLabel: part.label,
        topicId: topicByQuestionId.get(row.session_question_id) ?? "",
        marks: part.marks,
        answerType: (/^-?\d+(\.\d+)?$/.test(part.computedAnswer) ? "numeric" : "short_answer") as
          | "numeric"
          | "short_answer",
        computedAnswer: part.computedAnswer,
        tolerance: part.tolerance,
      }),
    ),
  );

  const relevantAnswers = answers.filter((answer) => chosenIds.includes(answer.sessionQuestionId));
  const autoMarked = autoMarkExamPaperAnswers(answerKey, relevantAnswers);

  for (const part of autoMarked) {
    const studentAnswer = relevantAnswers.find(
      (a) => a.sessionQuestionId === part.sessionQuestionId && a.partLabel === part.partLabel,
    );
    await admin.from("exam_paper_answers").upsert(
      {
        session_question_id: part.sessionQuestionId,
        part_label: part.partLabel,
        student_answer: studentAnswer?.studentAnswer ?? null,
        is_correct: part.isCorrect,
        auto_marks: part.autoMarks,
      },
      { onConflict: "session_question_id,part_label" },
    );
  }

  const verifiedMarks = autoMarked.reduce((sum, part) => sum + part.autoMarks, 0);
  const totalMarks = session.total_marks;
  const scorePercentage = totalMarks > 0 ? Math.round((verifiedMarks / totalMarks) * 100) : 0;

  await admin
    .from("exam_paper_sessions")
    .update({ status: "submitted", verified_marks: verifiedMarks, submitted_at: new Date().toISOString() })
    .eq("id", sessionId);

  const attemptPredictedGrade = predictGrade(scorePercentage, profile.curriculum);
  const { predictedGrade: rollingPredictedGrade } = await applyExamPaperOutcomeLoop(admin, profile, autoMarked);

  return { verifiedMarks, totalMarks, scorePercentage, attemptPredictedGrade, rollingPredictedGrade };
}

async function applyExamPaperOutcomeLoop(
  admin: AdminClient,
  profile: StudentProfile,
  autoMarked: AutoMarkedPart[],
): Promise<{ healthScore: number; predictedGrade: string }> {
  const topicResults = buildVerifiedTopicResults(autoMarked);

  const { data: masteryRows } = await admin
    .from("topic_mastery")
    .select("topic_id, mastery_percentage")
    .eq("student_id", profile.id)
    .in("topic_id", topicResults.map((r) => r.topicId));

  const existingMastery = Object.fromEntries(
    (masteryRows ?? []).map((row: any) => [row.topic_id, Number(row.mastery_percentage)]),
  );

  const updates = computeMasteryUpdates(topicResults, existingMastery);

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
    .select("id")
    .eq("code", "mathematics")
    .maybeSingle();

  if (!subject) {
    return { healthScore: 0, predictedGrade: predictGrade(0, profile.curriculum) };
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
    (allMastery ?? []).map((row: any) => ({ topicId: "topic", masteryPercentage: Number(row.mastery_percentage) })),
  );

  const correctCount = autoMarked.filter((part) => part.isCorrect).length;
  const recentPerformance = autoMarked.length > 0 ? Math.round((correctCount / autoMarked.length) * 100) : 0;

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
    topic_scores: Object.fromEntries(updates.map((u) => [u.topicId, u.masteryPercentage])),
    predicted_grade: predictedGrade,
  });

  await generateStudyPlanForStudent(profile, { planType: "daily", dailyGoalMinutes: 20 });

  return { healthScore, predictedGrade };
}

export interface SelfMarkResult {
  combinedMarks: number;
  totalMarks: number;
  percentage: number;
}

export async function selfMarkExamPaperSession(
  sessionId: string,
  studentId: string,
  claims: SelfMarkClaim[],
): Promise<SelfMarkResult> {
  const admin = createAdminClient();

  const { data: session } = await admin
    .from("exam_paper_sessions")
    .select("id, status, total_marks")
    .eq("id", sessionId)
    .eq("student_id", studentId)
    .maybeSingle();

  if (!session) throw new Error("NOT_FOUND");
  if (session.status !== "submitted") throw new Error("CONFLICT");

  const { data: chosenQuestions } = await admin
    .from("exam_paper_session_questions")
    .select("id, topic_id")
    .eq("session_id", sessionId)
    .eq("chosen", true);

  const chosenIds = (chosenQuestions ?? []).map((q: any) => q.id);

  const [{ data: answerKeyRows }, { data: answerRows }] = await Promise.all([
    admin.from("exam_paper_session_answer_keys").select("session_question_id, answer_key").in("session_question_id", chosenIds),
    admin
      .from("exam_paper_answers")
      .select("session_question_id, part_label, is_correct, auto_marks")
      .in("session_question_id", chosenIds),
  ]);

  const marksByKey = new Map<string, number>();
  for (const row of answerKeyRows ?? []) {
    for (const part of (row as any).answer_key as Array<{ label: string; marks: number }>) {
      marksByKey.set(`${(row as any).session_question_id}::${part.label}`, part.marks);
    }
  }

  const autoMarked: AutoMarkedPart[] = (answerRows ?? []).map((row: any) => ({
    sessionQuestionId: row.session_question_id,
    partLabel: row.part_label,
    topicId: "",
    marks: marksByKey.get(`${row.session_question_id}::${row.part_label}`) ?? 0,
    isCorrect: row.is_correct ?? false,
    autoMarks: row.auto_marks ?? 0,
  }));

  const marked = applySelfMarkedMethodMarks(autoMarked, claims);

  for (const part of marked) {
    await admin
      .from("exam_paper_answers")
      .update({ self_awarded_method_marks: part.selfAwardedMethodMarks })
      .eq("session_question_id", part.sessionQuestionId)
      .eq("part_label", part.partLabel);
  }

  const summary = composeExamPaperScore(marked);

  await admin
    .from("exam_paper_sessions")
    .update({ status: "self_marked", self_awarded_marks: summary.selfAwardedMarks })
    .eq("id", sessionId);

  return {
    combinedMarks: summary.combinedMarks,
    totalMarks: session.total_marks,
    percentage: session.total_marks > 0 ? Math.round((summary.combinedMarks / session.total_marks) * 100) : 0,
  };
}

export interface ExamPaperResultPart {
  label: string;
  prompt: string;
  marks: number;
  studentAnswer: string | null;
  isCorrect: boolean;
  autoMarks: number;
  selfAwardedMethodMarks: number;
  computedAnswer: string;
}

export interface ExamPaperResultQuestion {
  sessionQuestionId: string;
  questionNumber: number;
  section: "I" | "II";
  renderedStem: string;
  markScheme: Array<{ code: string; text: string }>;
  parts: ExamPaperResultPart[];
}

export interface ExamPaperResultsView {
  sessionId: string;
  status: string;
  totalMarks: number;
  verifiedMarks: number;
  selfAwardedMarks: number;
  combinedMarks: number;
  percentage: number;
  questions: ExamPaperResultQuestion[];
}

export async function getExamPaperResults(
  sessionId: string,
  studentId: string,
): Promise<ExamPaperResultsView | null> {
  const admin = createAdminClient();

  const { data: session } = await admin
    .from("exam_paper_sessions")
    .select("id, status, total_marks, verified_marks, self_awarded_marks")
    .eq("id", sessionId)
    .eq("student_id", studentId)
    .maybeSingle();

  if (!session || session.status === "in_progress") return null;

  const { data: questions } = await admin
    .from("exam_paper_session_questions")
    .select("id, question_number, section, rendered_stem, rendered_parts")
    .eq("session_id", sessionId)
    .eq("chosen", true)
    .order("sort_order", { ascending: true });

  const questionIds = (questions ?? []).map((q: any) => q.id);

  const [{ data: answerKeyRows }, { data: answerRows }] = await Promise.all([
    admin
      .from("exam_paper_session_answer_keys")
      .select("session_question_id, answer_key, mark_scheme")
      .in("session_question_id", questionIds),
    admin
      .from("exam_paper_answers")
      .select("session_question_id, part_label, student_answer, is_correct, auto_marks, self_awarded_method_marks")
      .in("session_question_id", questionIds),
  ]);

  const keysByQuestion = new Map(
    (answerKeyRows ?? []).map((row: any) => [
      row.session_question_id,
      {
        answerKey: row.answer_key as Array<{ label: string; computedAnswer: string; marks: number }>,
        markScheme: row.mark_scheme as Array<{ code: string; text: string }>,
      },
    ]),
  );

  const answersByKey = new Map(
    (answerRows ?? []).map((row: any) => [`${row.session_question_id}::${row.part_label}`, row]),
  );

  const resultQuestions: ExamPaperResultQuestion[] = (questions ?? []).map((question: any) => {
    const renderedParts = question.rendered_parts as Array<{ label: string; prompt: string; marks: number }>;
    const key = keysByQuestion.get(question.id);

    const parts: ExamPaperResultPart[] = renderedParts.map((part) => {
      const answer = answersByKey.get(`${question.id}::${part.label}`);
      const keyEntry = key?.answerKey.find((entry) => entry.label === part.label);

      return {
        label: part.label,
        prompt: part.prompt,
        marks: part.marks,
        studentAnswer: answer?.student_answer ?? null,
        isCorrect: answer?.is_correct ?? false,
        autoMarks: answer?.auto_marks ?? 0,
        selfAwardedMethodMarks: answer?.self_awarded_method_marks ?? 0,
        computedAnswer: keyEntry?.computedAnswer ?? "",
      };
    });

    return {
      sessionQuestionId: question.id,
      questionNumber: question.question_number,
      section: question.section as "I" | "II",
      renderedStem: question.rendered_stem,
      markScheme: key?.markScheme ?? [],
      parts,
    };
  });

  const verifiedMarks = session.verified_marks ?? 0;
  const selfAwardedMarks = session.self_awarded_marks ?? 0;
  const combinedMarks = verifiedMarks + selfAwardedMarks;

  return {
    sessionId: session.id,
    status: session.status,
    totalMarks: session.total_marks,
    verifiedMarks,
    selfAwardedMarks,
    combinedMarks,
    percentage: session.total_marks > 0 ? Math.round((combinedMarks / session.total_marks) * 100) : 0,
    questions: resultQuestions,
  };
}
