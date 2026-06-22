import { MIN_QUESTIONS_TO_START_PRACTICE } from "@/lib/curriculum/practiceCoverage";

export const COMMON_KCSE_SUBJECT_CODES = [
  "mathematics",
  "science",
  "english",
  "kiswahili",
  "biology",
  "chemistry",
  "physics",
  "history_government",
  "geography",
  "cre",
  "ire",
  "business_studies",
  "agriculture",
  "computer_studies",
] as const;

export const TIER1_SUBJECT_CODES = ["mathematics", "science", "english"] as const;

export type CommonKcseSubjectCode = (typeof COMMON_KCSE_SUBJECT_CODES)[number];
export type Tier1SubjectCode = (typeof TIER1_SUBJECT_CODES)[number];

/** Subjects whose content may be generated via the admin pipeline AND surfaced to students. */
export const ACTIVE_SUBJECT_CODES = [
  "mathematics",
  "science",
  "english",
  "kiswahili",
  "chemistry",
] as const;

export type ActiveSubjectCode = (typeof ACTIVE_SUBJECT_CODES)[number];

export const MIN_TOPICS_PER_SUBJECT = 3;
export const MIN_LESSONS_PER_TOPIC = 3;
export const MIN_PRACTICE_QUESTIONS_PER_TOPIC = 21;

export function isTier1SubjectCode(
  subjectCode: string,
): subjectCode is Tier1SubjectCode {
  return (TIER1_SUBJECT_CODES as readonly string[]).includes(subjectCode);
}

export type TopicReadinessLabel =
  | "NOT_READY"
  | "LEARN_READY"
  | "PRACTICE_READY"
  | "PROD_READY";

export function isTopicLearnReady(
  publishedLessonCount: number,
  subtopicCount: number,
  subtopicsWithLesson: number,
): boolean {
  return (
    publishedLessonCount >= MIN_LESSONS_PER_TOPIC &&
    subtopicCount > 0 &&
    subtopicsWithLesson === subtopicCount
  );
}

export function isTopicPracticeReady(counts: {
  easy: number;
  medium: number;
  hard: number;
}): boolean {
  return (
    counts.easy + counts.medium + counts.hard > 0 &&
    (counts.easy >= MIN_QUESTIONS_TO_START_PRACTICE ||
      counts.medium >= MIN_QUESTIONS_TO_START_PRACTICE ||
      counts.hard >= MIN_QUESTIONS_TO_START_PRACTICE)
  );
}

export function getTopicReadinessLabel(input: {
  publishedLessonCount: number;
  subtopicCount: number;
  subtopicsWithLesson: number;
  questionCounts: { easy: number; medium: number; hard: number };
}): TopicReadinessLabel {
  const learnReady = isTopicLearnReady(
    input.publishedLessonCount,
    input.subtopicCount,
    input.subtopicsWithLesson,
  );
  const practiceReady = isTopicPracticeReady(input.questionCounts);

  if (learnReady && practiceReady) {
    return "PROD_READY";
  }
  if (learnReady) {
    return "LEARN_READY";
  }
  if (practiceReady) {
    return "PRACTICE_READY";
  }
  return "NOT_READY";
}

export function isTopicVisibleForGrade(
  topicMinGradeSortOrder: number,
  studentGradeSortOrder: number | null,
): boolean {
  if (studentGradeSortOrder === null) {
    return true;
  }

  return topicMinGradeSortOrder <= studentGradeSortOrder + 1;
}
