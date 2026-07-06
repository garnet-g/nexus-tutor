/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";

import { buildOfflinePackUrls } from "@/server/services/offlinePackService";

describe("offline pack manifest", () => {
  it("includes recommended topic and recent lesson URLs", () => {
    const urls = buildOfflinePackUrls("student-1", "recommended-study-pack", {
      recommendedTopic: { title: "Algebra", topicId: "topic-1", masteryPercentage: 40 },
      recentLessons: [{ href: "/learn/topic-1/lesson-1", lessonTitle: "Intro", topicTitle: "Algebra", lessonId: "lesson-1", status: "in_progress", lastViewedAt: null, completedAt: null }],
      savedItems: [{ href: "/saved", title: "Note", description: null, id: "1", itemType: "note", itemId: null, metadata: {}, createdAt: "", updatedAt: "" }],
      mistakes: [{ topicId: "topic-2", id: "m1", questionId: null, topicTitle: null, questionText: "q", chosenAnswer: null, correctAnswer: null, explanation: null, source: "practice", status: "open", createdAt: "", updatedAt: "" }],
    });

    expect(urls).toContain("/practice?topicId=topic-1");
    expect(urls).toContain("/learn/topic-1/lesson-1");
    expect(urls).toContain("/practice?topicId=topic-2");
  });
});
