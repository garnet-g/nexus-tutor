import { describe, expect, it } from "vitest";

import { resolveLessonStudyDurationSeconds } from "@/lib/learn/lessonDuration";
import { getLessonPathStatus } from "@/lib/learn/lessonProgress";
import { lessonCompleteSchema } from "@/schemas/lessonProgressSchemas";

describe("resolveLessonStudyDurationSeconds", () => {
  it("falls back to estimated minutes when client time is missing", () => {
    expect(resolveLessonStudyDurationSeconds(undefined, 10)).toBe(600);
  });

  it("caps client time at twice the estimate", () => {
    expect(resolveLessonStudyDurationSeconds(5000, 10)).toBe(1200);
  });

  it("uses client time when within cap", () => {
    expect(resolveLessonStudyDurationSeconds(300, 10)).toBe(300);
  });
});

describe("getLessonPathStatus", () => {
  const ordered = ["a", "b", "c"];

  it("marks completed lessons as done", () => {
    expect(getLessonPathStatus("a", ordered, ["a"])).toBe("done");
  });

  it("locks lessons until the previous one is complete", () => {
    expect(getLessonPathStatus("b", ordered, [])).toBe("locked");
    expect(getLessonPathStatus("b", ordered, ["a"])).toBe("available");
  });
});

describe("lessonCompleteSchema", () => {
  it("accepts optional duration and quiz flag", () => {
    expect(
      lessonCompleteSchema.safeParse({
        durationSeconds: 420,
        quizPassed: true,
      }).success,
    ).toBe(true);
  });

  it("rejects excessive duration", () => {
    expect(
      lessonCompleteSchema.safeParse({ durationSeconds: 99_999 }).success,
    ).toBe(false);
  });
});
