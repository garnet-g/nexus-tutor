import "server-only";

import { randomUUID } from "node:crypto";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  assertNexConfiguredForLiveMode,
  ConfigurationError,
  createMockAdapterMetadata,
  isNexMockAllowed,
} from "@/lib/env/providerModes";
import { getGeminiThinkingLevel, getGeminiVisionModel } from "@/lib/nex/modelConfig";

export const PAST_PAPER_ANSWER_PHOTOS_BUCKET = "past-paper-answer-photos";
const SIGNED_URL_TTL_SECONDS = 3600;

export interface PastPaperSummary {
  id: string;
  curriculum: string;
  subjectId: string;
  subjectName: string;
  paperYear: number;
  name: string;
  pdfUrl: string;
  durationMinutes: number;
  totalMarks: number;
}

export async function listPastPapers(
  curriculum: string,
  subjectId?: string,
  paperYear?: number,
): Promise<PastPaperSummary[]> {
  const admin = createAdminClient();

  let query = admin
    .from("past_papers")
    .select("id, curriculum, subject_id, paper_year, name, pdf_url, duration_minutes, total_marks, subjects(name)")
    .eq("curriculum", curriculum)
    .eq("is_active", true)
    .order("paper_year", { ascending: false });

  if (subjectId) {
    query = query.eq("subject_id", subjectId);
  }
  if (paperYear) {
    query = query.eq("paper_year", paperYear);
  }

  const { data, error } = await query;
  if (error || !data) {
    return [];
  }

  return data.map((row) => {
    const subject = row.subjects as { name?: string } | null;
    return {
      id: row.id,
      curriculum: row.curriculum,
      subjectId: row.subject_id,
      subjectName: subject?.name ?? "Unknown subject",
      paperYear: row.paper_year,
      name: row.name,
      pdfUrl: row.pdf_url,
      durationMinutes: row.duration_minutes,
      totalMarks: row.total_marks,
    };
  });
}

export interface PastPaperQuestionView {
  id: string;
  questionNumber: string;
  questionText: string;
  marks: number;
}

export interface PastPaperDetail extends PastPaperSummary {
  questions: PastPaperQuestionView[];
}

export async function getPastPaperDetail(
  pastPaperId: string,
): Promise<PastPaperDetail | null> {
  const admin = createAdminClient();

  const { data: paper } = await admin
    .from("past_papers")
    .select("id, curriculum, subject_id, paper_year, name, pdf_url, duration_minutes, total_marks, subjects(name)")
    .eq("id", pastPaperId)
    .eq("is_active", true)
    .maybeSingle();

  if (!paper) {
    return null;
  }

  const { data: questions } = await admin
    .from("past_paper_questions")
    .select("id, question_number, question_text, marks")
    .eq("past_paper_id", pastPaperId)
    .order("sort_order", { ascending: true });

  const subject = paper.subjects as { name?: string } | null;

  return {
    id: paper.id,
    curriculum: paper.curriculum,
    subjectId: paper.subject_id,
    subjectName: subject?.name ?? "Unknown subject",
    paperYear: paper.paper_year,
    name: paper.name,
    pdfUrl: paper.pdf_url,
    durationMinutes: paper.duration_minutes,
    totalMarks: paper.total_marks,
    questions: (questions ?? []).map((q) => ({
      id: q.id,
      questionNumber: q.question_number,
      questionText: q.question_text,
      marks: q.marks,
    })),
  };
}

export async function startPastPaperAttempt(
  studentId: string,
  pastPaperId: string,
): Promise<{ attemptId: string }> {
  const admin = createAdminClient();

  const { data: paper } = await admin
    .from("past_papers")
    .select("id")
    .eq("id", pastPaperId)
    .eq("is_active", true)
    .maybeSingle();

  if (!paper) {
    throw new Error("NOT_FOUND");
  }

  const { data: existing } = await admin
    .from("past_paper_attempts")
    .select("id")
    .eq("student_id", studentId)
    .eq("past_paper_id", pastPaperId)
    .eq("status", "in_progress")
    .maybeSingle();

  if (existing) {
    return { attemptId: existing.id };
  }

  const { data: attempt, error } = await admin
    .from("past_paper_attempts")
    .insert({
      student_id: studentId,
      past_paper_id: pastPaperId,
      status: "in_progress",
    })
    .select("id")
    .single();

  if (error || !attempt) {
    throw new Error(error?.message ?? "Could not start attempt");
  }

  return { attemptId: attempt.id };
}

export interface SubmitPastPaperAnswerInput {
  questionId: string;
  studentAnswer?: string;
  ocrImageUrl?: string;
}

export async function submitPastPaperAttempt(
  attemptId: string,
  studentId: string,
  answers: SubmitPastPaperAnswerInput[],
): Promise<{ submitted: boolean }> {
  const admin = createAdminClient();

  const { data: attempt } = await admin
    .from("past_paper_attempts")
    .select("id, status")
    .eq("id", attemptId)
    .eq("student_id", studentId)
    .maybeSingle();

  if (!attempt) {
    throw new Error("NOT_FOUND");
  }

  if (attempt.status !== "in_progress") {
    throw new Error("ALREADY_SUBMITTED");
  }

  for (const answer of answers) {
    await admin
      .from("past_paper_answers")
      .upsert(
        {
          attempt_id: attemptId,
          question_id: answer.questionId,
          student_answer: answer.studentAnswer ?? null,
          ocr_image_url: answer.ocrImageUrl ?? null,
        },
        { onConflict: "attempt_id,question_id" },
      );
  }

  await admin
    .from("past_paper_attempts")
    .update({ status: "submitted", submitted_at: new Date().toISOString() })
    .eq("id", attemptId);

  return { submitted: true };
}

export interface MarkAttemptQuestionResult {
  score: number;
  maxMarks: number;
  feedback: string;
}

function bytesToBase64(bytes: Uint8Array): string {
  if (typeof Buffer !== "undefined") {
    return Buffer.from(bytes).toString("base64");
  }
  let binary = "";
  for (const byte of bytes) {
    binary += String.fromCharCode(byte);
  }
  return btoa(binary);
}

function buildMarkingPrompt(input: {
  questionText: string;
  markingScheme: string;
  maxMarks: number;
  studentAnswer?: string;
}): string {
  return `You are marking a Kenyan CBC/KCSE mathematics exam answer step by step.

Question:
${input.questionText}

Official marking scheme:
${input.markingScheme}

Maximum marks: ${input.maxMarks}
${input.studentAnswer ? `Typed student answer: ${input.studentAnswer}` : "The student's working is in the attached photo."}

Compare the student's working against the marking scheme step by step. Award partial marks for correct method even if the final answer is wrong. Identify specific misconceptions.

Respond ONLY with strict JSON in this exact shape:
{"score": <integer 0-${input.maxMarks}>, "feedback": "<2-4 sentence step-by-step explanation of what earned or lost marks>"}`;
}

async function callGeminiForMarking(input: {
  prompt: string;
  imageBytes?: Uint8Array;
  mimeType?: string;
}): Promise<{ score: number; feedback: string }> {
  assertNexConfiguredForLiveMode();

  const apiKey = process.env.GEMINI_API_KEY;
  if (!apiKey) {
    throw new ConfigurationError("Gemini vision is not configured for live mode");
  }

  const parts: Array<Record<string, unknown>> = [{ text: input.prompt }];
  if (input.imageBytes && input.mimeType) {
    parts.push({
      inlineData: {
        mimeType: input.mimeType,
        data: bytesToBase64(input.imageBytes),
      },
    });
  }

  const response = await fetch(
    `https://generativelanguage.googleapis.com/v1beta/models/${getGeminiVisionModel()}:generateContent?key=${apiKey}`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        contents: [{ parts }],
        generationConfig: {
          temperature: 0.1,
          maxOutputTokens: 512,
          thinkingConfig: { thinkingLevel: getGeminiThinkingLevel() },
        },
      }),
    },
  );

  if (!response.ok) {
    throw new Error(`Gemini marking request failed: ${response.status}`);
  }

  const payload = (await response.json()) as {
    candidates?: Array<{ content?: { parts?: Array<{ text?: string }> } }>;
  };

  const text = payload.candidates?.[0]?.content?.parts?.[0]?.text?.trim() ?? "";
  const jsonMatch = text.match(/\{[\s\S]*\}/);

  if (!jsonMatch) {
    throw new Error("Gemini marking response was not valid JSON");
  }

  const parsed = JSON.parse(jsonMatch[0]) as { score?: number; feedback?: string };

  return {
    score: typeof parsed.score === "number" ? parsed.score : 0,
    feedback: parsed.feedback ?? "No feedback returned.",
  };
}

export async function markAttemptQuestionWithAI(
  attemptId: string,
  questionId: string,
  studentId: string,
  input: { studentAnswer?: string; imageBytes?: Uint8Array; mimeType?: string },
): Promise<MarkAttemptQuestionResult> {
  const admin = createAdminClient();

  const { data: attempt } = await admin
    .from("past_paper_attempts")
    .select("id")
    .eq("id", attemptId)
    .eq("student_id", studentId)
    .maybeSingle();

  if (!attempt) {
    throw new Error("NOT_FOUND");
  }

  const { data: question } = await admin
    .from("past_paper_questions")
    .select("id, question_text, marking_scheme, marks")
    .eq("id", questionId)
    .maybeSingle();

  if (!question) {
    throw new Error("QUESTION_NOT_FOUND");
  }

  let ocrImageUrl: string | null = null;

  if (input.imageBytes && input.mimeType) {
    const objectPath = `${studentId}/${attemptId}/${randomUUID()}.${input.mimeType.split("/")[1] ?? "jpg"}`;
    const { error: uploadError } = await admin.storage
      .from(PAST_PAPER_ANSWER_PHOTOS_BUCKET)
      .upload(objectPath, input.imageBytes, {
        contentType: input.mimeType,
        upsert: false,
      });

    if (uploadError) {
      throw new Error(`Answer photo upload failed: ${uploadError.message}`);
    }

    const { data: signedUrlData } = await admin.storage
      .from(PAST_PAPER_ANSWER_PHOTOS_BUCKET)
      .createSignedUrl(objectPath, SIGNED_URL_TTL_SECONDS);

    ocrImageUrl = signedUrlData?.signedUrl ?? null;
  }

  const prompt = buildMarkingPrompt({
    questionText: question.question_text,
    markingScheme: question.marking_scheme,
    maxMarks: question.marks,
    studentAnswer: input.studentAnswer,
  });

  let score: number;
  let feedback: string;

  if (isNexMockAllowed()) {
    void createMockAdapterMetadata();
    score = Math.round(question.marks * 0.75);
    feedback = "Mock marking: correct method shown with a minor arithmetic slip.";
  } else {
    const result = await callGeminiForMarking({
      prompt,
      imageBytes: input.imageBytes,
      mimeType: input.mimeType,
    });
    score = Math.max(0, Math.min(question.marks, Math.round(result.score)));
    feedback = result.feedback;
  }

  await admin
    .from("past_paper_answers")
    .upsert(
      {
        attempt_id: attemptId,
        question_id: questionId,
        student_answer: input.studentAnswer ?? null,
        ocr_image_url: ocrImageUrl,
        score,
        feedback,
      },
      { onConflict: "attempt_id,question_id" },
    );

  await recomputeAttemptScoreIfMarked(attemptId);

  return { score, maxMarks: question.marks, feedback };
}

async function recomputeAttemptScoreIfMarked(attemptId: string): Promise<void> {
  const admin = createAdminClient();

  const { data: attemptRow } = await admin
    .from("past_paper_attempts")
    .select("past_paper_id")
    .eq("id", attemptId)
    .single();

  const [{ data: answers }, { data: questions }] = await Promise.all([
    admin.from("past_paper_answers").select("score, question_id").eq("attempt_id", attemptId),
    admin
      .from("past_paper_questions")
      .select("id")
      .eq("past_paper_id", attemptRow?.past_paper_id ?? ""),
  ]);

  const totalQuestions = questions?.length ?? 0;
  const markedAnswers = (answers ?? []).filter((a) => a.score !== null);

  if (totalQuestions === 0 || markedAnswers.length < totalQuestions) {
    await admin
      .from("past_paper_attempts")
      .update({ status: "marking" })
      .eq("id", attemptId);
    return;
  }

  const totalScore = markedAnswers.reduce((sum, a) => sum + (a.score ?? 0), 0);

  await admin
    .from("past_paper_attempts")
    .update({ status: "marked", score: totalScore, marked_at: new Date().toISOString() })
    .eq("id", attemptId);
}

export interface PastPaperResultsView {
  attemptId: string;
  status: string;
  score: number | null;
  totalMarks: number;
  paperName: string;
  answers: Array<{
    questionId: string;
    questionNumber: string;
    questionText: string;
    markingScheme: string;
    marks: number;
    studentAnswer: string | null;
    ocrImageUrl: string | null;
    score: number | null;
    feedback: string | null;
  }>;
}

export async function getPastPaperAttemptResults(
  attemptId: string,
  studentId: string,
): Promise<PastPaperResultsView | null> {
  const admin = createAdminClient();

  const { data: attempt } = await admin
    .from("past_paper_attempts")
    .select("id, status, score, past_papers(name, total_marks)")
    .eq("id", attemptId)
    .eq("student_id", studentId)
    .maybeSingle();

  if (!attempt) {
    return null;
  }

  const paper = attempt.past_papers as { name?: string; total_marks?: number } | null;

  const { data: attemptRow } = await admin
    .from("past_paper_attempts")
    .select("past_paper_id")
    .eq("id", attemptId)
    .single();

  const [{ data: questions }, { data: answers }] = await Promise.all([
    admin
      .from("past_paper_questions")
      .select("id, question_number, question_text, marking_scheme, marks")
      .eq("past_paper_id", attemptRow?.past_paper_id ?? "")
      .order("sort_order", { ascending: true }),
    admin
      .from("past_paper_answers")
      .select("question_id, student_answer, ocr_image_url, score, feedback")
      .eq("attempt_id", attemptId),
  ]);

  const answersByQuestionId = new Map(
    (answers ?? []).map((a) => [a.question_id, a]),
  );

  return {
    attemptId: attempt.id,
    status: attempt.status,
    score: attempt.score,
    totalMarks: paper?.total_marks ?? 0,
    paperName: paper?.name ?? "Past paper",
    answers: (questions ?? []).map((q) => {
      const answer = answersByQuestionId.get(q.id);

      return {
        questionId: q.id,
        questionNumber: q.question_number,
        questionText: q.question_text,
        markingScheme: q.marking_scheme,
        marks: q.marks,
        studentAnswer: answer?.student_answer ?? null,
        ocrImageUrl: answer?.ocr_image_url ?? null,
        score: answer?.score ?? null,
        feedback: answer?.feedback ?? null,
      };
    }),
  };
}
