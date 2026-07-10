import { describe, expect, it } from "vitest";

import {
  calculateEndsAt,
  EXAM_PAPER_DURATION_MINUTES,
  isSessionExpired,
  remainingSeconds,
} from "@/lib/examPapers/sessionTiming";

describe("sessionTiming", () => {
  it("defaults to a 150 minute (2h30m) duration", () => {
    expect(EXAM_PAPER_DURATION_MINUTES).toBe(150);
  });

  it("calculates ends-at as started-at plus duration", () => {
    const start = new Date("2026-01-01T09:00:00.000Z");
    const end = calculateEndsAt(start);
    expect(end.toISOString()).toBe("2026-01-01T11:30:00.000Z");
  });

  it("computes remaining seconds, floored at zero", () => {
    const end = new Date("2026-01-01T11:30:00.000Z");
    const before = new Date("2026-01-01T11:29:00.000Z");
    const after = new Date("2026-01-01T11:31:00.000Z");
    expect(remainingSeconds(end, before)).toBe(60);
    expect(remainingSeconds(end, after)).toBe(0);
  });

  it("reports expiry correctly", () => {
    const end = new Date("2026-01-01T11:30:00.000Z");
    expect(isSessionExpired(end, new Date("2026-01-01T11:29:59.000Z"))).toBe(false);
    expect(isSessionExpired(end, new Date("2026-01-01T11:30:00.000Z"))).toBe(true);
    expect(isSessionExpired(end, new Date("2026-01-01T11:30:01.000Z"))).toBe(true);
  });
});
