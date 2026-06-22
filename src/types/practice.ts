import type {
  PracticeDifficulty,
  PracticeQuestionCounts,
} from "@/lib/curriculum/practiceCoverage";

export interface PracticeReadyByDifficulty {
  easy: boolean;
  medium: boolean;
  hard: boolean;
}

export interface PracticeCurriculumSubtopic {
  id: string;
  code: string;
  title: string;
  lessonCount: number;
  questionCounts: PracticeQuestionCounts;
  practiceReady: PracticeReadyByDifficulty;
  needsContent: boolean;
}

export interface PracticeCurriculumTopic {
  id: string;
  code: string;
  title: string;
  masteryPercentage: number;
  lessonCount: number;
  questionCounts: PracticeQuestionCounts;
  practiceReady: PracticeReadyByDifficulty;
  needsContent: boolean;
  subtopics: PracticeCurriculumSubtopic[];
}

export interface PracticeCurriculumSubject {
  id: string;
  code: string;
  name: string;
  topics: PracticeCurriculumTopic[];
}

export type { PracticeDifficulty, PracticeQuestionCounts };
