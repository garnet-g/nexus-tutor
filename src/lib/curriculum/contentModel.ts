export const TIER1_SUBJECT_CODES = ["mathematics", "science", "english"] as const;

export type Tier1SubjectCode = (typeof TIER1_SUBJECT_CODES)[number];

export const MIN_TOPICS_PER_SUBJECT = 3;
export const MIN_LESSONS_PER_TOPIC = 3;
export const MIN_PRACTICE_QUESTIONS_PER_TOPIC = 21;

export function isTopicVisibleForGrade(
  topicMinGradeSortOrder: number,
  studentGradeSortOrder: number | null,
): boolean {
  if (studentGradeSortOrder === null) {
    return true;
  }

  return topicMinGradeSortOrder <= studentGradeSortOrder + 1;
}
