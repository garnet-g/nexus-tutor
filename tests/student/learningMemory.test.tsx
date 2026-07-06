import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { LearningMemoryView } from "@/features/student/components/LearningMemoryView";
import type { StudentExperienceData } from "@/server/services/studentExperienceService";

const experience = {
  profile: {
    curriculum: "KCSE",
    grade_level: "form_3",
    learning_preferences: { studyStyle: "focused" },
    metadata: { commonErrors: ["Sign errors in algebra"] },
  },
  recommendedTopic: {
    title: "Linear equations",
    topicId: "topic-1",
    masteryPercentage: 55,
  },
  progress: {
    healthScore: 72,
    currentStreak: 4,
    totalXp: 1200,
  },
} as unknown as StudentExperienceData;

describe("learning memory view", () => {
  it("does not render raw JSON blobs", () => {
    const { container } = render(<LearningMemoryView experience={experience} />);

    expect(container.querySelector("pre")).toBeNull();
    expect(screen.getByText(/read-only projection/i)).toBeTruthy();
    expect(screen.getByText(/Sign errors in algebra/)).toBeTruthy();
    expect(screen.queryByText(/"studyStyle"/)).toBeNull();
  });
});
