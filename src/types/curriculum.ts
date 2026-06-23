export type LessonBlockType =
  | "heading"
  | "paragraph"
  | "example"
  | "tip"
  | "chemical_equation"
  | "comprehension_passage"
  | "rich_text"
  | "image"
  | "table"
  | "math_block"
  | "callout"
  | "video_embed"
  | "divider"
  | "question"
  | "file_attachment";

/** Present on every block; optional in legacy stored JSON (assigned on read). */
export interface LessonBlockBase {
  id?: string;
}

export interface LessonHeadingBlock extends LessonBlockBase {
  type: "heading";
  content: string;
}

export interface LessonParagraphBlock extends LessonBlockBase {
  type: "paragraph";
  content: string;
}

export interface LessonExampleBlock extends LessonBlockBase {
  type: "example";
  title: string;
  steps: string[];
  answer: string;
}

export interface LessonTipBlock extends LessonBlockBase {
  type: "tip";
  content: string;
}

export interface LessonChemicalEquationBlock extends LessonBlockBase {
  type: "chemical_equation";
  equation: string;
  caption?: string;
}

export interface LessonComprehensionPassageBlock extends LessonBlockBase {
  type: "comprehension_passage";
  title?: string;
  passage: string;
}

export interface LessonRichTextBlock extends LessonBlockBase {
  type: "rich_text";
  markdown: string;
}

export interface LessonImageBlock extends LessonBlockBase {
  type: "image";
  url: string;
  alt: string;
  caption?: string;
}

export interface LessonTableBlock extends LessonBlockBase {
  type: "table";
  rows: string[][];
  caption?: string;
}

export interface LessonMathBlockBlock extends LessonBlockBase {
  type: "math_block";
  latex: string;
  caption?: string;
}

export type LessonCalloutVariant = "info" | "warning" | "key_point";

export interface LessonCalloutBlock extends LessonBlockBase {
  type: "callout";
  variant: LessonCalloutVariant;
  content: string;
}

export interface LessonVideoEmbedBlock extends LessonBlockBase {
  type: "video_embed";
  provider: string;
  url: string;
  title?: string;
}

export interface LessonDividerBlock extends LessonBlockBase {
  type: "divider";
}

export interface LessonInlineQuestionBlock extends LessonBlockBase {
  type: "question";
  questionText: string;
  questionType: "multiple_choice" | "short_answer";
  options?: string[];
  correctAnswer: string;
  explanation?: string;
}

export interface LessonFileAttachmentBlock extends LessonBlockBase {
  type: "file_attachment";
  url: string;
  name: string;
}

export type LessonContentBlock =
  | LessonHeadingBlock
  | LessonParagraphBlock
  | LessonExampleBlock
  | LessonTipBlock
  | LessonChemicalEquationBlock
  | LessonComprehensionPassageBlock
  | LessonRichTextBlock
  | LessonImageBlock
  | LessonTableBlock
  | LessonMathBlockBlock
  | LessonCalloutBlock
  | LessonVideoEmbedBlock
  | LessonDividerBlock
  | LessonInlineQuestionBlock
  | LessonFileAttachmentBlock;

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
