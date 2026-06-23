import type { Curriculum } from "@/types/database";

export const QUESTION_COVERAGE_TARGET = 20;
export const SUBTOPIC_QUESTION_COVERAGE_TARGET = 10;

export const GRADE_LEVELS_BY_CURRICULUM: Record<Curriculum, string[]> = {
  CBC: ["Grade 4", "Grade 5", "Grade 6", "Grade 7", "Grade 8", "Grade 9"],
  KCSE: ["Form 1", "Form 2", "Form 3", "Form 4"],
};

export interface ContentCoverageSubtopic {
  id: string;
  code: string;
  title: string;
  publishedLessonCount: number;
  draftLessonCount: number;
  questionCounts: {
    easy: number;
    medium: number;
    hard: number;
  };
}

export interface ContentCoverageTopic {
  id: string;
  code: string;
  title: string;
  publishedLessonCount: number;
  draftLessonCount: number;
  questionCounts: {
    easy: number;
    medium: number;
    hard: number;
  };
  readinessLabel: "NOT_READY" | "LEARN_READY" | "PRACTICE_READY" | "PROD_READY";
  subtopics: ContentCoverageSubtopic[];
}

export interface ContentCoverageCurriculum {
  code: Curriculum;
  gradeLevels: string[];
  topics: ContentCoverageTopic[];
}

export interface ContentCoverageSubject {
  code: string;
  name: string;
  curricula: ContentCoverageCurriculum[];
}

export interface DraftLessonQueueItem {
  kind: "lesson";
  id: string;
  title: string;
  estimatedMinutes: number;
  curriculumCode: Curriculum;
  topicId: string;
  topicTitle: string;
  subtopicId: string;
  subtopicTitle: string;
  generatedModel: string | null;
  updatedAt: string;
}

export interface DraftQuestionQueueItem {
  kind: "question";
  id: string;
  questionText: string;
  questionType: "multiple_choice" | "short_answer";
  options: string[] | null;
  correctAnswer: string;
  difficulty: "easy" | "medium" | "hard";
  explanation: string | null;
  curriculumCode: Curriculum;
  topicId: string;
  topicTitle: string;
  subtopicId: string | null;
  subtopicTitle: string | null;
  generatedModel: string | null;
}

export type ContentDraftQueueItem = DraftLessonQueueItem | DraftQuestionQueueItem;

export interface ReviewLessonQueueItem extends DraftLessonQueueItem {
  submittedAt: string | null;
  reviewNotes: string | null;
}

export interface ReviewQuestionQueueItem extends DraftQuestionQueueItem {
  submittedAt: string | null;
  reviewNotes: string | null;
}

export type ContentReviewQueueItem = ReviewLessonQueueItem | ReviewQuestionQueueItem;
