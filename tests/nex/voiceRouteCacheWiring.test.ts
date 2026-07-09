/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { join } from "node:path";

describe("voice route uses the voice cache before calling synthesizeVoiceResponse", () => {
  it("checks getCachedVoice before synthesis and stores the result on a miss", () => {
    const source = readFileSync(
      join(process.cwd(), "src", "app", "api", "nex", "voice", "route.ts"),
      "utf8",
    );

    expect(source).toContain('from "@/server/services/nexVoiceCacheService"');
    expect(source).toContain("getCachedVoice(");
    expect(source).toContain("hashVoiceContent(");
    expect(source).toContain("storeCachedVoice(");

    const cacheCheckIndex = source.indexOf("getCachedVoice(");
    const synthesizeIndex = source.indexOf("synthesizeVoiceResponse({");
    expect(cacheCheckIndex).toBeGreaterThan(0);
    expect(cacheCheckIndex).toBeLessThan(synthesizeIndex);
  });
});
