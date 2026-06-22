import { render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { PracticeLanding } from "@/features/practice/components/PracticeLanding";
import type { PracticeCurriculumSubject } from "@/types/practice";

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push: vi.fn() }),
  useSearchParams: () => new URLSearchParams(),
}));

const tree: PracticeCurriculumSubject[] = [
  {
    id: "subject-1",
    code: "mathematics",
    name: "Mathematics",
    topics: [
      {
        id: "topic-1",
        code: "algebra",
        title: "Algebra",
        masteryPercentage: 42,
        lessonCount: 3,
        questionCounts: { easy: 8, medium: 12, hard: 4 },
        practiceReady: { easy: true, medium: true, hard: false },
        needsContent: false,
        subtopics: [
          {
            id: "subtopic-1",
            code: "linear_equations",
            title: "Linear Equations",
            lessonCount: 2,
            questionCounts: { easy: 6, medium: 7, hard: 2 },
            practiceReady: { easy: true, medium: true, hard: false },
            needsContent: false,
          },
        ],
      },
    ],
  },
];

describe("PracticeLanding", () => {
  it("renders subject, topic, and subtopic hierarchy from service data", () => {
    render(
      <PracticeLanding
        studentId="student-1"
        curriculumTree={tree}
        dailyUsage={0}
        dailyLimit={3}
        retryAfterSeconds={3600}
        planCode="free"
      />,
    );

    expect(screen.getByRole("button", { name: "Mathematics" })).toBeTruthy();
    expect(screen.getByRole("heading", { name: "Algebra" })).toBeTruthy();
    expect(screen.getByText("Linear Equations")).toBeTruthy();
    expect(screen.getByRole("button", { name: "Start medium session" })).toBeTruthy();
    expect(screen.getByText("Easy 8 · Medium 12 · Hard 4")).toBeTruthy();
  });
  it("does not mark a topic ready when every difficulty is below the start threshold", () => {
    render(
      <PracticeLanding
        studentId="student-1"
        curriculumTree={[
          {
            id: "subject-1",
            code: "mathematics",
            name: "Mathematics",
            topics: [
              {
                id: "topic-1",
                code: "fractions",
                title: "Fractions",
                masteryPercentage: 0,
                lessonCount: 1,
                questionCounts: { easy: 4, medium: 0, hard: 0 },
                practiceReady: { easy: false, medium: false, hard: false },
                needsContent: false,
                subtopics: [],
              },
            ],
          },
        ]}
        dailyUsage={0}
        dailyLimit={3}
        retryAfterSeconds={3600}
        planCode="free"
      />,
    );

    expect(screen.getAllByText("Needs content").length).toBeGreaterThan(0);
    expect(screen.queryByText("Ready")).toBeNull();
  });
});
