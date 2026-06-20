import { describe, expect, it } from "vitest";

import {
  getMasteryPill,
  masteryPillClass,
} from "@/features/progress/lib/masteryPills";

describe("masteryPills", () => {
  it("maps percentages to three progress statuses", () => {
    expect(getMasteryPill(20).label).toBe("Needs work");
    expect(getMasteryPill(55).label).toBe("Developing");
    expect(getMasteryPill(80).label).toBe("Mastered");
  });

  it("uses semantic token classes for each status", () => {
    expect(masteryPillClass.needs_work).toContain("nexus-danger");
    expect(masteryPillClass.developing).toContain("nexus-warning");
    expect(masteryPillClass.mastered).toContain("nexus-success");
  });
});
