import { describe, expect, it } from "vitest";

import { sqlJsonb, sqlLiteral } from "../scripts/exportContent";

describe("exportContent SQL helpers", () => {
  it("escapes single quotes in SQL literals", () => {
    expect(sqlLiteral("Grace's chapati")).toBe("'Grace''s chapati'");
  });

  it("serializes JSONB payloads deterministically", () => {
    expect(sqlJsonb({ blocks: [{ type: "heading", content: "Test" }] })).toBe(
      `'{"blocks":[{"type":"heading","content":"Test"}]}'::jsonb`,
    );
  });
});
