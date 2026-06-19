export type QuestionDifficulty = "easy" | "medium" | "hard";

export type QuestionType = "multiple_choice" | "numeric" | "short_answer";

export interface DiagnosticQuestionInput {
  diagnosticQuestionId: string;
  topicId: string;
  topicTitle: string;
  difficulty: QuestionDifficulty;
  questionType: QuestionType;
  correctAnswer: unknown;
}

export interface DiagnosticAnswerInput {
  diagnosticQuestionId: string;
  studentAnswer: unknown;
}

export interface GradedQuestionResult {
  diagnosticQuestionId: string;
  topicId: string;
  topicTitle: string;
  difficulty: QuestionDifficulty;
  isCorrect: boolean;
}

export interface TopicScoreResult {
  topicId: string;
  topicTitle: string;
  topicScore: number;
  correct: number;
  total: number;
}

export interface DiagnosticScoreResult {
  diagnosticScore: number;
  healthScore: number;
  gradedQuestions: GradedQuestionResult[];
  topicScores: TopicScoreResult[];
  strongTopics: TopicScoreResult[];
  weakTopics: TopicScoreResult[];
  recommendedTopics: TopicScoreResult[];
}
