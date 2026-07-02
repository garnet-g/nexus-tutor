/**
 * @vitest-environment node
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

describe("runtime environment validation bundle", () => {
  it("does not trace the repository filesystem from Next instrumentation", () => {
    const source = readFileSync(
      join(process.cwd(), "src", "lib", "env", "validateEnv.ts"),
      "utf8",
    );

    expect(source).not.toContain('from "node:fs"');
    expect(source).not.toContain('from "node:path"');
    expect(source).not.toContain("process.cwd()");
  });
});
