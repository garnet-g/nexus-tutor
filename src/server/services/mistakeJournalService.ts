import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { MarkedAnswer } from "@/lib/mockExams/mockExamEngine";

export type MistakeJournalSource = "practice" | "mock_exam" | "manual";

export type MistakeJournalUpsertInput = {
  questionId?: string | null;
  topicId?: string | null;
  questionText: string;
  chosenAnswer?: string | null;
  correctAnswer?: string | null;
  explanation?: string | null;
  source: MistakeJournalSource;
};

function formatStoredAnswer(value: unknown): string | null {
  if (value === null || value === undefined) {
    return null;
  }

  if (typeof value === "string") {
    return value;
  }

  if (typeof value === "number" || typeof value === "boolean") {
    return String(value);
  }

  try {
    return JSON.stringify(value);
  } catch {
    return String(value);
  }
}

function mapMistakeRow(row: Record<string, unknown>) {
  return {
    id: String(row.id),
    questionId: row.question_id ? String(row.question_id) : null,
    topicId: row.topic_id ? String(row.topic_id) : null,
    questionText: String(row.question_text),
    chosenAnswer: row.chosen_answer ? String(row.chosen_answer) : null,
    correctAnswer: row.correct_answer ? String(row.correct_answer) : null,
    explanation: row.explanation ? String(row.explanation) : null,
    source: row.source as MistakeJournalSource,
    status: row.status as "open" | "retried" | "mastered",
    createdAt: String(row.created_at),
    updatedAt: String(row.updated_at),
  };
}

export async function upsertMistakeJournalEntry(
  studentId: string,
  input: MistakeJournalUpsertInput,
) {
  const admin = createAdminClient();

  if (input.questionId) {
    const { data: existing, error: lookupError } = await admin
      .from("student_mistake_journal")
      .select("id, status")
      .eq("student_id", studentId)
      .eq("question_id", input.questionId)
      .maybeSingle();

    if (lookupError) {
      throw new Error(lookupError.message);
    }

    if (existing) {
      const nextStatus =
        existing.status === "mastered" ? "open" : (existing.status as string);

      const { data, error } = await admin
        .from("student_mistake_journal")
        .update({
          topic_id: input.topicId ?? null,
          question_text: input.questionText,
          chosen_answer: input.chosenAnswer ?? null,
          correct_answer: input.correctAnswer ?? null,
          explanation: input.explanation ?? null,
          source: input.source,
          status: nextStatus,
        })
        .eq("id", existing.id)
        .eq("student_id", studentId)
        .select("*")
        .single();

      if (error || !data) {
        throw new Error(error?.message ?? "Could not update mistake.");
      }

      return mapMistakeRow(data as Record<string, unknown>);
    }
  }

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
      status: "open",
    })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save mistake.");
  }

  return mapMistakeRow(data as Record<string, unknown>);
}

export async function recordPracticeSessionMistakes(
  studentId: string,
  sessionId: string,
) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("practice_attempts")
    .select(
      "student_answer, practice_question_id, practice_questions(topic_id, question_text, correct_answer, explanation)",
    )
    .eq("practice_session_id", sessionId)
    .eq("is_correct", false);

  if (error) {
    throw new Error(error.message);
  }

  for (const attempt of data ?? []) {
    const question = unwrapSupabaseRelation(
      attempt.practice_questions as
        | {
            topic_id?: string;
            question_text?: string;
            correct_answer?: unknown;
            explanation?: string | null;
          }
        | Array<{
            topic_id?: string;
            question_text?: string;
            correct_answer?: unknown;
            explanation?: string | null;
          }>
        | null,
    );

    if (!question?.question_text || !attempt.practice_question_id) {
      continue;
    }

    await upsertMistakeJournalEntry(studentId, {
      questionId: String(attempt.practice_question_id),
      topicId: question.topic_id ? String(question.topic_id) : null,
      questionText: String(question.question_text),
      chosenAnswer: formatStoredAnswer(attempt.student_answer),
      correctAnswer: formatStoredAnswer(question.correct_answer),
      explanation: question.explanation ?? null,
      source: "practice",
    });
  }
}

export async function recordMockExamMistakes(
  studentId: string,
  questions: Array<{
    id: string;
    topic_id: string;
    practice_question_id: string | null;
    question_text: string;
    correct_answer: unknown;
    explanation: string | null;
  }>,
  marked: MarkedAnswer[],
) {
  for (const mark of marked.filter((entry) => !entry.isCorrect)) {
    const question = questions.find((entry) => entry.id === mark.questionId);
    if (!question) {
      continue;
    }

    await upsertMistakeJournalEntry(studentId, {
      questionId: question.practice_question_id,
      topicId: question.topic_id,
      questionText: question.question_text,
      chosenAnswer: formatStoredAnswer(mark.studentAnswer),
      correctAnswer: formatStoredAnswer(question.correct_answer),
      explanation: question.explanation,
      source: "mock_exam",
    });
  }
}
