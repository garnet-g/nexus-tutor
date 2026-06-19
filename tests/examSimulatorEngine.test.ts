import { describe, expect, it } from "vitest";

import {
  buildExamAnalysis,
  calculateEndsAt,
  canSubmitExamSession,
  formatGradeDelta,
  isExamSessionExpired,
  remainingSeconds,
  resolveSessionStatusOnSubmit,
} from "@/lib/mockExams/examSimulatorEngine";

describe("examSimulatorEngine", () => {
  it("calculates ends_at from duration", () => {
    const startedAt = new Date("2026-06-15T10:00:00.000Z");
    const endsAt = calculateEndsAt(startedAt, 45);

    expect(endsAt.toISOString()).toBe("2026-06-15T10:45:00.000Z");
  });

  it("detects expiry against server clock", () => {
    const endsAt = new Date("2026-06-15T10:45:00.000Z");
    const before = new Date("2026-06-15T10:44:59.000Z");
    const after = new Date("2026-06-15T10:45:00.000Z");

    expect(isExamSessionExpired(endsAt, before)).toBe(false);
    expect(isExamSessionExpired(endsAt, after)).toBe(true);
  });

  it("allows submit while in progress or after expiry", () => {
    const endsAt = new Date("2026-06-15T10:45:00.000Z");

    expect(
      canSubmitExamSession({
        sessionStatus: "in_progress",
        endsAt,
        now: new Date("2026-06-15T10:30:00.000Z"),
      }),
    ).toBe(true);

    expect(
      canSubmitExamSession({
        sessionStatus: "expired",
        endsAt,
      }),
    ).toBe(true);

    expect(
      canSubmitExamSession({
        sessionStatus: "completed",
        endsAt,
      }),
    ).toBe(false);
  });

  it("marks expired submissions separately from on-time completion", () => {
    const endsAt = new Date("2026-06-15T10:45:00.000Z");

    expect(
      resolveSessionStatusOnSubmit({
        endsAt,
        now: new Date("2026-06-15T10:40:00.000Z"),
      }),
    ).toBe("completed");

    expect(
      resolveSessionStatusOnSubmit({
        endsAt,
        now: new Date("2026-06-15T10:46:00.000Z"),
      }),
    ).toBe("expired");
  });

  it("formats grade deltas and builds analysis summary", () => {
    expect(formatGradeDelta("C+", "B-")).toBe("C+ → B-");
    expect(formatGradeDelta("B-", "B-")).toBe("unchanged");

    const analysis = buildExamAnalysis({
      scorePercentage: 72,
      weakTopicTitles: ["Trigonometry", "Statistics"],
      previousPredictedGrade: "C+",
      nextPredictedGrade: "B-",
    });

    expect(analysis.predictedGrade).toBe("B-");
    expect(analysis.predictedGradeDelta).toBe("C+ → B-");
    expect(analysis.summary).toContain("Trigonometry");
  });

  it("returns remaining seconds without going negative", () => {
    const endsAt = new Date("2026-06-15T10:45:00.000Z");
    const now = new Date("2026-06-15T10:44:30.000Z");

    expect(remainingSeconds(endsAt, now)).toBe(30);
    expect(remainingSeconds(endsAt, new Date("2026-06-15T11:00:00.000Z"))).toBe(0);
  });
});
