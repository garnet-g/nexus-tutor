import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

import { lessonContentSchema } from "@/schemas/lessonContentSchemas";

const sql = readFileSync(
  "supabase/seed/curriculum_math_kcse_content.sql",
  "utf-8",
);

// extract every lesson content JSON: , '{...}'::jsonb  (SQL doubles '' for apostrophes)
function extractLessonJson(text: string): string[] {
  const out: string[] = [];
  const re = /,\s*'(\{.*?\})'::jsonb/gs;
  let m: RegExpExecArray | null;
  while ((m = re.exec(text)) !== null) {
    out.push(m[1].replace(/''/g, "'"));
  }
  return out;
}

describe("KCSE math seed — lesson content validates against schema", () => {
  const blobs = extractLessonJson(sql);

  it("extracts the expected number of lessons", () => {
    expect(blobs.length).toBe(20);
  });

  it("every lesson passes lessonContentSchema", () => {
    const failures: string[] = [];
    for (const blob of blobs) {
      const parsed = lessonContentSchema.safeParse(JSON.parse(blob));
      if (!parsed.success) {
        failures.push(
          `${blob.slice(0, 60)} -> ${parsed.error.issues[0]?.message}`,
        );
      }
    }
    expect(failures).toEqual([]);
  });
});
