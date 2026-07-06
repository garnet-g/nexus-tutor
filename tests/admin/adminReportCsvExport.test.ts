/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";

import { buildCsv, escapeCsvCell } from "@/lib/admin/csvExport";

describe("PR-126 CSV formula injection escaping", () => {
  it("prefixes formula-leading cells with a single quote", () => {
    expect(escapeCsvCell("=cmd|'/c calc'!A0")).toBe("'=cmd|'/c calc'!A0");
    expect(escapeCsvCell("+1234")).toBe("'+1234");
    expect(escapeCsvCell("-10")).toBe("'-10");
    expect(escapeCsvCell("@sum(A1)")).toBe("'@sum(A1)");
    expect(escapeCsvCell("\tleak")).toBe("'\tleak");
    expect(escapeCsvCell("\rleak")).toBe('"\'\rleak"');
  });

  it("buildCsv exports formula cells safely", () => {
    const csv = buildCsv(["command"], [["=cmd"]]);
    expect(csv).toContain("'=cmd");
    expect(csv).not.toMatch(/^=cmd/m);
  });
});
