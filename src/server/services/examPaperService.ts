import "server-only";

import { randomInt } from "node:crypto";

import { instantiateTemplate, type ExamPaperTemplateBody } from "@/lib/examPapers/templateInstantiation";
import { assembleExamPaper, hasSufficientTemplateBank, type TemplateRecord } from "@/lib/examPapers/paperAssembly";
import { mulberry32 } from "@/lib/examPapers/paramSampler";
import { calculateEndsAt, EXAM_PAPER_DURATION_MINUTES, isSessionExpired } from "@/lib/examPapers/sessionTiming";
import { parseFormLevel } from "@/lib/examPapers/formScope";
import { createAdminClient } from "@/lib/supabase/admin";
import { studentHasExamPaperAccess, FREE_EXAM_PAPER_SAMPLE_QUESTION_COUNT } from "@/schemas/examPaperSchemas";
import { getStudentPlanCode } from "@/server/services/nexUsageService";
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
