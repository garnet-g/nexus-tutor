export type NexMode =
  | "explain"
  | "practice"
  | "homework"
  | "revision"
  | "assessment";

export type NexSessionMode = NexMode;

export type AssessmentStatus = "in_progress" | "completed";

export type HintLevel = 1 | 2 | 3 | 4;

export interface NexSessionMetadata {
  hintLevel: HintLevel;
  hintCount: number;
  attemptCount: number;
  misconceptionDetected: boolean;
  difficulty?: "easy" | "medium" | "hard";
  consecutiveCorrect?: number;
  consecutiveIncorrect?: number;
  examCountdownDays?: number;
  dailyGoalMinutes?: number;
  questionIndex?: number;
  correctCount?: number;
  assessmentStatus?: AssessmentStatus;
  assessmentQuestionCount?: number;
}

export const DEFAULT_ASSESSMENT_QUESTION_COUNT = 3;

export const DEFAULT_NEX_SESSION_METADATA: NexSessionMetadata = {
  hintLevel: 1,
  hintCount: 0,
  attemptCount: 0,
  misconceptionDetected: false,
  difficulty: "medium",
  consecutiveCorrect: 0,
  consecutiveIncorrect: 0,
  questionIndex: 0,
  correctCount: 0,
  assessmentStatus: "in_progress",
  assessmentQuestionCount: DEFAULT_ASSESSMENT_QUESTION_COUNT,
};
export interface NexMessageTurn {
  role: "student" | "nex";
  content: string;
}

export interface StudentMemoryContext {
  studentName: string;
  curriculum: string;
  gradeLevel: string;
  targetGrade: string | null;
  healthScore: number | null;
  predictedGrade: string | null;
  strongTopics: string[];
  weakTopics: string[];
  commonErrors: string[];
  recentTopics: string[];
  confidenceNotes: string;
  topicMasteryJson: string;
}

export interface CurriculumContext {
  subject: string | null;
  subjectCode: string | null;
  topic: string | null;
  subtopic: string | null;
  learningOutcome: string | null;
  lessonExcerpts: string;
}

export interface AssembledPrompt {
  systemPrompt: string;
  conversationMessages: NexMessageTurn[];
}

export interface NexModelCallInput {
  systemPrompt: string;
  messages: NexMessageTurn[];
  maxTokens?: number;
}

export interface NexModelCallResult {
  content: string;
  provider: "gemini" | "openai" | "mock";
}

export type ValidationResult =
  | { status: "pass" }
  | { status: "fail"; reason: string }
  | { status: "ambiguous"; reason: string };

export interface ValidateNexResponseInput {
  mode: NexMode;
  response: string;
  attemptCount: number;
  hintLevel: HintLevel;
  studentMessage: string;
}

export interface GenerateNexResponseInput {
  studentId: string;
  studentMessage: string;
  sessionMode: NexMode;
  sessionMetadata: NexSessionMetadata;
  topicId?: string | null;
  recentMessages: NexMessageTurn[];
  studentMemory?: StudentMemoryContext | null;
  curriculumContext?: CurriculumContext | null;
  regenerateStrict?: boolean;
}

export interface GenerateNexResponseResult {
  response: string;
  sessionMode: NexMode;
  metadata: NexSessionMetadata;
  provider: "gemini" | "openai" | "mock";
  validationPassed: boolean;
}
