import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { KcseMathRevisionHub } from "@/features/revision/components/KcseMathRevisionHub";
import type { KcseMathRevisionHubModel } from "@/lib/revision/kcseMathRevisionEngine";

describe("KcseMathRevisionHub", () => {
  const model: KcseMathRevisionHubModel = {
    studentName: "Amina",
    curriculum: "KCSE",
    gradeLevel: "Form 2",
    readiness: {
      score: 61,
      label: "Building",
      description: "You are building toward exam-ready work.",
      predictedGrade: "C+",
    },
    syllabusMap: [
      {
        id: "topic-algebra",
        code: "algebra",
        title: "Algebra",
        formLevel: "Form 1",
        masteryPercentage: 41,
        status: "repair",
        lessonHref: "/learn/topic-algebra",
        practiceHref: "/practice?topicId=topic-algebra",
        nexHref: "/nex?mode=revision&topicId=topic-algebra",
      },
    ],
    dailyPlan: {
      title: "Daily KCSE repair",
      dailyGoalMinutes: 35,
      items: [
        {
          id: "task-1",
          title: "Repair algebra basics",
          topicTitle: "Algebra",
          minutes: 20,
          isCompleted: false,
          href: "/nex?mode=revision&topicId=topic-algebra",
        },
      ],
      planHref: "/study-plan",
    },
    practiceLinks: {
      kcseStyle: {
        label: "Start KCSE-style maths practice",
        href: "/exam-prep?subject=mathematics&style=kcse_style",
      },
      topicDrill: {
        label: "Drill weak maths topics",
        href: "/practice",
      },
    },
    weakTopicRepair: [
      {
        id: "topic-algebra",
        title: "Algebra",
        masteryPercentage: 41,
        repairFocus: "Rebuild the core method before doing timed questions.",
        nexHref: "/nex?mode=revision&topicId=topic-algebra",
        practiceHref: "/practice?topicId=topic-algebra",
      },
    ],
    trustSummary: {
      schoolReadySignal: "KCSE maths readiness: Building at 61%.",
      parentPricingSignal: "Free daily text revision works before paid add-ons.",
      chatPrivacy: "Tutor chat text stays private; parents see progress signals only.",
    },
    lowDataMode: {
      tips: [
        "Keep revision text-first and avoid video-heavy flows.",
        "Use compact practice and return to the same weak topic later.",
      ],
    },
  };

  it("renders the eight maths-first revision surfaces with working route links", () => {
    render(<KcseMathRevisionHub model={model} />);

    expect(screen.getByRole("heading", { name: /KCSE maths revision/i })).toBeTruthy();
    expect(screen.getByText(/Syllabus map/i)).toBeTruthy();
    expect(screen.getAllByText(/Exam readiness/i).length).toBeGreaterThan(0);
    expect(screen.getByText(/Daily revision plan/i)).toBeTruthy();
    expect(screen.getAllByText(/KCSE-style practice/i).length).toBeGreaterThan(0);
    expect(screen.getAllByText(/Weak-topic repair/i).length).toBeGreaterThan(0);
    expect(screen.getByText(/School\/teacher trust/i)).toBeTruthy();
    expect(screen.getByText(/Parent-friendly pricing/i)).toBeTruthy();
    expect(screen.getByText(/Low-data mode/i)).toBeTruthy();

    expect(
      screen
        .getByRole("button", { name: /Start KCSE-style maths practice/i })
        .getAttribute("href"),
    ).toBe("/exam-prep?subject=mathematics&style=kcse_style");
    expect(screen.getByRole("button", { name: /Repair with Nex/i }).getAttribute("href")).toBe(
      "/nex?mode=revision&topicId=topic-algebra",
    );
    expect(screen.getByRole("button", { name: /Practice Algebra/i }).getAttribute("href")).toBe(
      "/practice?topicId=topic-algebra",
    );
  });
});
