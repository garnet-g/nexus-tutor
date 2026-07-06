/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";

import { getWeekStartDate } from "@/server/services/weeklyReportService";

describe("PR-132 weekly report timezone boundaries (Africa/Nairobi)", () => {
  it("uses Monday as week start for a mid-week Nairobi timestamp", () => {
    const weekStart = getWeekStartDate(new Date("2026-07-08T12:00:00.000Z"));
    expect(weekStart).toBe("2026-07-06");
  });

  it("Sunday 23:59 Nairobi remains in the week that started the prior Monday", () => {
    const weekStart = getWeekStartDate(new Date("2026-07-05T20:59:00.000Z"));
    expect(weekStart).toBe("2026-06-29");
  });

  it("Monday 00:00 Nairobi rolls into the new week", () => {
    const weekStart = getWeekStartDate(new Date("2026-07-05T21:00:00.000Z"));
    expect(weekStart).toBe("2026-07-06");
  });
});
