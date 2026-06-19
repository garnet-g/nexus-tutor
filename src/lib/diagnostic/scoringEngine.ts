import type {
  DiagnosticAnswerInput,
  DiagnosticQuestionInput,
  DiagnosticScoreResult,
  GradedQuestionResult,
  QuestionType,
  TopicScoreResult,
} from "@/lib/diagnostic/types";

const QUESTION_WEIGHTS = {
  easy: 1.0,
  medium: 1.5,
  hard: 2.0,
} as const;

const STRONG_TOPIC_THRESHOLD = 70;
const WEAK_TOPIC_THRESHOLD = 50;

function normalizeString(value: unknown): string {
  return String(value ?? "")
    .trim()
    .toLowerCase()
    .replace(/\s+/g, " ");
}

function parseNumeric(value: unknown): number | null {
  if (typeof value === "number" && Number.isFinite(value)) {
    return value;
  }

  const parsed = Number(String(value ?? "").trim());

  return Number.isFinite(parsed) ? parsed : null;
}

export function gradeAnswer(
  questionType: QuestionType,
  correctAnswer: unknown,
  studentAnswer: unknown,
): boolean {
  if (studentAnswer === null || studentAnswer === undefined) {
    return false;
  }

  switch (questionType) {
    case "multiple_choice":
      return normalizeString(correctAnswer) === normalizeString(studentAnswer);
    case "numeric": {
      const correct = parseNumeric(correctAnswer);
      const student = parseNumeric(studentAnswer);

      if (correct === null || student === null) {
        return false;
      }

      return Math.abs(correct - student) <= 0.01;
    }
    case "short_answer":
      return normalizeString(correctAnswer) === normalizeString(studentAnswer);
    default:
      return false;
  }
}

function buildTopicScores(gradedQuestions: GradedQuestionResult[]): TopicScoreResult[] {
  const byTopic = new Map<
    string,
    { topicTitle: string; correct: number; total: number }
  >();

  for (const question of gradedQuestions) {
    const existing = byTopic.get(question.topicId) ?? {
      topicTitle: question.topicTitle,
      correct: 0,
      total: 0,
    };

    existing.total += 1;
    if (question.isCorrect) {
      existing.correct += 1;
    }

    byTopic.set(question.topicId, existing);
  }

  return Array.from(byTopic.entries()).map(([topicId, stats]) => ({
    topicId,
    topicTitle: stats.topicTitle,
    correct: stats.correct,
    total: stats.total,
    topicScore: stats.total > 0 ? Math.round((stats.correct / stats.total) * 100) : 0,
  }));
}

function classifyTopics(topicScores: TopicScoreResult[]) {
  const strongTopics = topicScores.filter(
    (topic) => topic.topicScore >= STRONG_TOPIC_THRESHOLD,
  );
  const weakTopics = topicScores.filter(
    (topic) => topic.topicScore < WEAK_TOPIC_THRESHOLD,
  );
  const recommendedTopics = [...weakTopics]
    .sort((left, right) => left.topicScore - right.topicScore)
    .slice(0, 3);

  return { strongTopics, weakTopics, recommendedTopics };
}

export function scoreDiagnosticAttempt(
  questions: DiagnosticQuestionInput[],
  answers: DiagnosticAnswerInput[],
): DiagnosticScoreResult {
  const answerMap = new Map(
    answers.map((answer) => [answer.diagnosticQuestionId, answer.studentAnswer]),
  );

  const gradedQuestions: GradedQuestionResult[] = questions.map((question) => ({
    diagnosticQuestionId: question.diagnosticQuestionId,
    topicId: question.topicId,
    topicTitle: question.topicTitle,
    difficulty: question.difficulty,
    isCorrect: gradeAnswer(
      question.questionType,
      question.correctAnswer,
      answerMap.get(question.diagnosticQuestionId),
    ),
  }));

  let weightedCorrect = 0;
  let weightedTotal = 0;

  for (const question of gradedQuestions) {
    const weight = QUESTION_WEIGHTS[question.difficulty];
    weightedTotal += weight;

    if (question.isCorrect) {
      weightedCorrect += weight;
    }
  }

  const diagnosticScore =
    weightedTotal > 0
      ? Math.round((weightedCorrect / weightedTotal) * 100)
      : 0;
  const healthScore = diagnosticScore;
  const topicScores = buildTopicScores(gradedQuestions);
  const { strongTopics, weakTopics, recommendedTopics } = classifyTopics(topicScores);

  return {
    diagnosticScore,
    healthScore,
    gradedQuestions,
    topicScores,
    strongTopics,
    weakTopics,
    recommendedTopics,
  };
}
