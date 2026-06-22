export type LessonBlockType =
  | "heading"
  | "paragraph"
  | "example"
  | "tip"
  | "chemical_equation"
  | "comprehension_passage";

export interface LessonHeadingBlock {
  type: "heading";
  content: string;
}

export interface LessonParagraphBlock {
  type: "paragraph";
  content: string;
}

export interface LessonExampleBlock {
  type: "example";
  title: string;
  steps: string[];
  answer: string;
}

export interface LessonTipBlock {
  type: "tip";
  content: string;
}

export interface LessonChemicalEquationBlock {
  type: "chemical_equation";
  equation: string;
  caption?: string;
}

export interface LessonComprehensionPassageBlock {
  type: "comprehension_passage";
  title?: string;
  passage: string;
}

export type LessonContentBlock =
  | LessonHeadingBlock
  | LessonParagraphBlock
  | LessonExampleBlock
  | LessonTipBlock
  | LessonChemicalEquationBlock
  | LessonComprehensionPassageBlock;

export interface LessonShortQuizQuestion {
  questionText: string;
  options: string[];
  correctAnswer: string;
}

export interface LessonContent {
  blocks: LessonContentBlock[];
  shortQuiz?: {
    questions: LessonShortQuizQuestion[];
  };
}

export interface CurriculumSubject {
  id: string;
  code: string;
  name: string;
  curriculumCode: string;
  topicCount: number;
}

export interface CurriculumTopic {
  id: string;
  code: string;
  title: string;
  description: string | null;
  sortOrder: number;
  subjectId: string;
  lessonCount: number;
}

export interface CurriculumSubtopic {
  id: string;
  code: string;
  title: string;
  description: string | null;
  sortOrder: number;
  lessons: CurriculumLessonSummary[];
}

export interface CurriculumLessonSummary {
  id: string;
  title: string;
  estimatedMinutes: number;
  sortOrder: number;
}

export interface CurriculumTopicDetail extends CurriculumTopic {
  subjectCode: string;
  subjectName: string;
  subtopics: CurriculumSubtopic[];
}

export interface CurriculumLesson {
  id: string;
  title: string;
  content: LessonContent;
  estimatedMinutes: number;
  sortOrder: number;
  subtopicId: string;
  subtopicTitle: string;
  topicId: string;
  topicTitle: string;
  subjectId: string;
  curriculumCode: string;
}
