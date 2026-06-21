import { describe, expect, it } from "vitest";

import { buildKcseMathRevisionHub } from "@/lib/revision/kcseMathRevisionEngine";

describe("buildKcseMathRevisionHub", () => {
  const topics = [
    {
      id: "topic-fractions",
      code: "fractions",
      title: "Fractions",
      formLevel: "Form 1" as const,
      sortOrder: 1,
    },
    {
      id: "topic-algebra",
      code: "algebra",
      title: "Algebra",
      formLevel: "Form 1" as const,
      sortOrder: 2,
    },
    {
      id: "topic-trig",
      code: "trigonometry",
      title: "Trigonometry",
      formLevel: "Form 2" as const,
      sortOrder: 3,
    },
    {
      id: "topic-stats",
      code: "statistics",
      title: "Statistics",
      formLevel: "Form 3" as const,
      sortOrder: 4,
    },
  ];

  it("builds a KCSE maths readiness model from mastery, health, plan, and weak topics", () => {
    const hub = buildKcseMathRevisionHub({
      studentName: "Amina",
      gradeLevel: "Form 2",
      curriculum: "KCSE",
      healthScore: 64,
      predictedGrade: "C+",
      topics,
      topicMastery: [
        { topicId: "topic-fractions", masteryPercentage: 82 },
        { topicId: "topic-algebra", masteryPercentage: 41 },
        { topicId: "topic-trig", masteryPercentage: 55 },
      ],
      activeStudyPlan: {
        title: "Daily KCSE repair",
        dailyGoalMinutes: 35,
        tasks: [
          {
            id: "task-1",
            topicId: "topic-algebra",
            topicTitle: "Algebra",
            taskTitle: "Repair algebra basics",
            taskType: "revision",
            dailyGoalMinutes: 20,
            isCompleted: false,
          },
        ],
      },
    });

    expect(hub.readiness.score).toBe(62);
    expect(hub.readiness.label).toBe("Building");
    expect(hub.readiness.predictedGrade).toBe("C+");
    expect(hub.syllabusMap.map((topic) => topic.formLevel)).toEqual([
      "Form 1",
      "Form 1",
      "Form 2",
      "Form 3",
    ]);
    expect(hub.syllabusMap.find((topic) => topic.title === "Algebra")).toMatchObject({
      masteryPercentage: 41,
      status: "repair",
      practiceHref: "/practice?topicId=topic-algebra",
      nexHref: "/nex?mode=revision&topicId=topic-algebra",
    });
    expect(hub.weakTopicRepair[0]).toMatchObject({
      title: "Algebra",
      repairFocus: "Rebuild the core method before doing timed questions.",
    });
    expect(hub.dailyPlan.items[0]).toMatchObject({
      title: "Repair algebra basics",
      href: "/nex?mode=revision&topicId=topic-algebra",
    });
    expect(hub.practiceLinks.kcseStyle.href).toBe("/exam-prep?subject=mathematics&style=kcse_style");
    expect(hub.trustSummary.chatPrivacy).toContain("Tutor chat text stays private");
    expect(hub.lowDataMode.tips).toContain("Keep revision text-first and avoid video-heavy flows.");
  });
});
