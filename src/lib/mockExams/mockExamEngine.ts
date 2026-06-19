import type { QuestionType } from "@/lib/diagnostic/types";

import { FREE_MOCK_EXAM_PREVIEW_LIMIT } from "@/schemas/mockExamSchemas";
import type { MockExamStyle } from "@/schemas/mockExamSchemas";

export interface PracticeQuestionPoolItem {
  id: string;
  topicId: string;
  topicTitle: string;
  questionText: string;
  questionType: QuestionType;
  options: unknown;
  correctAnswer: unknown;
  difficulty: "easy" | "medium" | "hard";
  explanation?: string | null;
}

export interface MockExamQuestionDraft {
  practiceQuestionId: string | null;
  topicId: string;
  questionText: string;
  questionType: QuestionType;
  options: unknown;
  correctAnswer: unknown;
  difficulty: "easy" | "medium" | "hard";
  explanation?: string | null;
  sortOrder: number;
}

const FULL_COUNTS: Record<MockExamStyle, number> = {
  kcse_style: 20,
  cbc_style: 15,
  topic_specific: 10,
  full_math: 25,
};

const DIFFICULTY_MIX: Record<MockExamStyle, Array<"easy" | "medium" | "hard">> = {
  kcse_style: ["easy", "easy", "medium", "medium", "medium", "hard", "hard"],
  cbc_style: ["easy", "easy", "medium", "medium", "hard"],
  topic_specific: ["easy", "medium", "medium", "hard"],
  full_math: ["easy", "medium", "medium", "hard", "hard"],
};

export function getTargetQuestionCount(
  style: MockExamStyle,
  isPreview: boolean,
): number {
  const fullCount = FULL_COUNTS[style];
  return isPreview ? Math.min(FREE_MOCK_EXAM_PREVIEW_LIMIT, fullCount) : fullCount;
}

export function buildDifficultySequence(
  style: MockExamStyle,
  count: number,
): Array<"easy" | "medium" | "hard"> {
  const pattern = DIFFICULTY_MIX[style];
  return Array.from({ length: count }, (_, index) => pattern[index % pattern.length]);
}

function shuffle<T>(items: T[]): T[] {
  const copy = [...items];
  for (let index = copy.length - 1; index > 0; index -= 1) {
    const swapIndex = Math.floor(Math.random() * (index + 1));
    [copy[index], copy[swapIndex]] = [copy[swapIndex], copy[index]];
  }
  return copy;
}

export function buildFallbackQuestion(
  topicId: string,
  difficulty: "easy" | "medium" | "hard",
  sortOrder: number,
  curriculum: "CBC" | "KCSE",
): MockExamQuestionDraft {
  const label = curriculum === "CBC" ? "Grade-level" : "KCSE";
  return {
    practiceQuestionId: null,
    topicId,
    questionText: `${label} ${difficulty} review: What is 12 + 8?`,
    questionType: "numeric",
    options: null,
    correctAnswer: 20,
    difficulty,
    explanation: "12 + 8 = 20",
    sortOrder,
  };
}

export function selectMockExamQuestions(input: {
  pool: PracticeQuestionPoolItem[];
  style: MockExamStyle;
  isPreview: boolean;
  topicId?: string | null;
  curriculum: "CBC" | "KCSE";
  fallbackTopicId: string;
}): MockExamQuestionDraft[] {
  const count = getTargetQuestionCount(input.style, input.isPreview);
  const difficulties = buildDifficultySequence(input.style, count);
  const selected: MockExamQuestionDraft[] = [];
  const usedIds = new Set<string>();

  let pool = input.pool;
  if (input.style === "topic_specific" && input.topicId) {
    pool = pool.filter((question) => question.topicId === input.topicId);
  }

  for (let index = 0; index < count; index += 1) {
    const difficulty = difficulties[index];
    const candidates = shuffle(
      pool.filter(
        (question) =>
          question.difficulty === difficulty && !usedIds.has(question.id),
      ),
    );

    const match = candidates[0];
    if (match) {
      usedIds.add(match.id);
      selected.push({
        practiceQuestionId: match.id,
        topicId: match.topicId,
        questionText: match.questionText,
        questionType: match.questionType,
        options: match.options,
        correctAnswer: match.correctAnswer,
        difficulty: match.difficulty,
        explanation: match.explanation,
        sortOrder: index,
      });
      continue;
    }

    const anyCandidate = shuffle(pool.filter((question) => !usedIds.has(question.id)))[0];
    if (anyCandidate) {
      usedIds.add(anyCandidate.id);
      selected.push({
        practiceQuestionId: anyCandidate.id,
        topicId: anyCandidate.topicId,
        questionText: anyCandidate.questionText,
        questionType: anyCandidate.questionType,
        options: anyCandidate.options,
        correctAnswer: anyCandidate.correctAnswer,
        difficulty: anyCandidate.difficulty,
        explanation: anyCandidate.explanation,
        sortOrder: index,
      });
      continue;
    }

    selected.push(
      buildFallbackQuestion(
        input.topicId ?? input.fallbackTopicId,
        difficulty,
        index,
        input.curriculum,
      ),
    );
  }

  return selected;
}

export interface MarkedAnswer {
  questionId: string;
  topicId: string;
  isCorrect: boolean;
  studentAnswer: unknown;
}

export function scoreMockExamAnswers(
  questions: Array<{
    id: string;
    topicId: string;
    questionType: QuestionType;
    correctAnswer: unknown;
  }>,
  answers: Array<{ questionId: string; studentAnswer: unknown }>,
  gradeAnswer: (
    questionType: QuestionType,
    correctAnswer: unknown,
    studentAnswer: unknown,
  ) => boolean,
): {
  marked: MarkedAnswer[];
  correctCount: number;
  scorePercentage: number;
  weakTopicIds: string[];
} {
  const answerMap = new Map(answers.map((answer) => [answer.questionId, answer.studentAnswer]));
  const marked: MarkedAnswer[] = [];
  const topicMisses = new Map<string, number>();

  for (const question of questions) {
    const studentAnswer = answerMap.get(question.id);
    const isCorrect = gradeAnswer(
      question.questionType,
      question.correctAnswer,
      studentAnswer,
    );

    marked.push({
      questionId: question.id,
      topicId: question.topicId,
      isCorrect,
      studentAnswer,
    });

    if (!isCorrect) {
      topicMisses.set(question.topicId, (topicMisses.get(question.topicId) ?? 0) + 1);
    }
  }

  const correctCount = marked.filter((entry) => entry.isCorrect).length;
  const scorePercentage =
    questions.length > 0 ? Math.round((correctCount / questions.length) * 100) : 0;

  const weakTopicIds = [...topicMisses.entries()]
    .filter(([, misses]) => misses >= 1)
    .sort((left, right) => right[1] - left[1])
    .map(([topicId]) => topicId);

  return { marked, correctCount, scorePercentage, weakTopicIds };
}
