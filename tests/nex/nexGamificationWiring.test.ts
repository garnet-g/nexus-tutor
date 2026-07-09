/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { join } from "node:path";

const root = process.cwd();

describe("Nex routes award gamification credit on new session creation", () => {
  it("chat route calls awardStudyActivity only in the new-session branch", () => {
    const source = readFileSync(
      join(root, "src", "app", "api", "nex", "chat", "route.ts"),
      "utf8",
    );

    expect(source).toContain('import { awardStudyActivity } from "@/server/services/studyActivityService"');
    expect(source).toMatch(/const newSessionId = createdSession\.id;[\s\S]{0,400}awardStudyActivity/);
  });

  it("voice route calls awardStudyActivity only in the new-session branch", () => {
    const source = readFileSync(
      join(root, "src", "app", "api", "nex", "voice", "route.ts"),
      "utf8",
    );

    expect(source).toContain('import { awardStudyActivity } from "@/server/services/studyActivityService"');
    expect(source).toMatch(/const newSessionId = createdSession\.id;[\s\S]{0,400}awardStudyActivity/);
  });

  it("camera route calls awardStudyActivity only in the new-session branch", () => {
    const source = readFileSync(
      join(root, "src", "app", "api", "nex", "camera", "route.ts"),
      "utf8",
    );

    expect(source).toContain('import { awardStudyActivity } from "@/server/services/studyActivityService"');
    expect(source).toContain("awardStudyActivity");
  });
});
