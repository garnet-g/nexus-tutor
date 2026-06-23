import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { LearnSubjectExplorer } from "@/features/learn/components/LearnSubjectExplorer";
import type { CurriculumSubject, CurriculumTopic } from "@/types/curriculum";

const subjects: CurriculumSubject[] = [
  {
    id: "subject-math",
    code: "mathematics",
    name: "Mathematics",
    curriculumCode: "KCSE",
    topicCount: 1,
  },
  {
    id: "subject-science",
    code: "science",
    name: "Science",
    curriculumCode: "KCSE",
    topicCount: 1,
  },
];

const topicsBySubjectId: Record<string, CurriculumTopic[]> = {
  "subject-math": [
    {
      id: "topic-math",
      code: "algebra",
      title: "Algebra",
      description: "Equations and expressions.",
      sortOrder: 1,
      subjectId: "subject-math",
      lessonCount: 3,
    },
  ],
  "subject-science": [
    {
      id: "topic-science",
      code: "cells",
      title: "Cells and Tissues",
      description: "Foundations of life science.",
      sortOrder: 1,
      subjectId: "subject-science",
      lessonCount: 4,
    },
  ],
};

describe("LearnSubjectExplorer", () => {
  it("lets students switch between every learn-ready subject", () => {
    render(
      <LearnSubjectExplorer
        subjects={subjects}
        topicsBySubjectId={topicsBySubjectId}
        topicMasteryById={{ "topic-math": 35, "topic-science": 12 }}
      />,
    );

    const scienceButton = screen.getByRole("button", { name: "Science" });

    expect((scienceButton as HTMLButtonElement).disabled).toBe(false);
    expect(screen.queryByText("V2")).toBeNull();
    expect(screen.getByRole("heading", { name: "Algebra" })).toBeTruthy();

    fireEvent.click(scienceButton);

    expect(screen.getByRole("heading", { name: "Cells and Tissues" })).toBeTruthy();
    expect(screen.queryByText("Your active V1 subject.")).toBeNull();
  });
});
