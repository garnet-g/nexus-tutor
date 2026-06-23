import type { Curriculum } from "@/types/database";

export type StudioReviewStatus = "draft" | "published" | "archived";

export interface StudioLessonSummary {
  id: string;
  title: string;
  reviewStatus: StudioReviewStatus;
  isActive: boolean;
  sortOrder: number;
  estimatedMinutes: number;
  updatedAt: string;
}

export interface StudioQuestionRow {
  id: string;
  topicId: string;
  subtopicId: string | null;
  questionText: string;
  questionType: "multiple_choice" | "short_answer";
  options: string[];
  correctAnswer: string;
  difficulty: "easy" | "medium" | "hard";
  explanation: string | null;
  reviewStatus: StudioReviewStatus;
  isActive: boolean;
}

export interface StudioTopicContext {
  topicId: string;
  topicTitle: string;
  subjectCode: string;
  curriculumCode: Curriculum;
}

export interface StudioSubtopicContext {
  subtopicId: string;
  subtopicTitle: string;
  topicId: string;
  topicTitle: string;
  subjectCode: string;
  curriculumCode: Curriculum;
}

export interface BulkSaveQuestionsResult {
  createdIds: string[];
  updatedIds: string[];
  archivedIds: string[];
  errors: Array<{ index: number; message: string }>;
}

export interface ReorderLessonsResult {
  subtopicId: string;
  lessonIds: string[];
}
