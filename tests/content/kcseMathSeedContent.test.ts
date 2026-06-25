import { readFileSync } from "node:fs";
import { describe, expect, it } from "vitest";

import { lessonContentSchema } from "@/schemas/lessonContentSchemas";

const SEED_FILES = [
  {
    path: "supabase/seed/curriculum_math_kcse_content.sql",
    expectedLessonCount: 20,
  },
  {
    path: "supabase/seed/curriculum_math_kcse_f1_b1.sql",
    expectedLessonCount: 19,
  },
] as const;

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
  for (const { path, expectedLessonCount } of SEED_FILES) {
    describe(path, () => {
      const sql = readFileSync(path, "utf-8");
      const blobs = extractLessonJson(sql);

      it(`extracts the expected number of lessons (${expectedLessonCount})`, () => {
        expect(blobs.length).toBe(expectedLessonCount);
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
  }
});
