import { describe, expect, it } from "vitest";
import { readFile } from "node:fs/promises";

describe("getSessionUser request memoization", () => {
  it("wraps session lookup with React cache() for request-scoped deduplication", async () => {
    const source = await readFile("src/server/services/authService.ts", "utf8");
    expect(source).toContain("cache(async");
    expect(source).toContain("export const getSessionUser = cache");
  });
});
