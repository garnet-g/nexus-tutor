import "server-only";

import type { StudentExperienceData } from "@/server/services/studentExperienceService";

export function buildOfflinePackUrls(
  studentId: string,
  packKey: string,
  experience: Pick<
    StudentExperienceData,
    "recommendedTopic" | "recentLessons" | "savedItems" | "mistakes"
  >,
): string[] {
  const urls = new Set<string>(["/offline", "/dashboard", "/learn"]);

  if (experience.recommendedTopic?.topicId) {
    urls.add(`/practice?topicId=${experience.recommendedTopic.topicId}`);
    urls.add(`/learn/${experience.recommendedTopic.topicId}`);
  }

  for (const lesson of experience.recentLessons.slice(0, 3)) {
    urls.add(lesson.href);
  }

  for (const item of experience.savedItems.slice(0, 5)) {
    if (item.href.startsWith("/")) {
      urls.add(item.href);
    }
  }

  for (const mistake of experience.mistakes.slice(0, 5)) {
    if (mistake.topicId) {
      urls.add(`/practice?topicId=${mistake.topicId}`);
    }
  }

  void studentId;
  void packKey;

  return [...urls];
}
