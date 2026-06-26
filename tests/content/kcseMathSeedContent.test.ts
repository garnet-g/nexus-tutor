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
  {
    path: "supabase/migrations/20260625130000_kcse_math_f1_b2.sql",
    expectedLessonCount: 45,
  },
  {
    path: "supabase/migrations/20260625140000_kcse_math_f1_b3.sql",
    expectedLessonCount: 45,
  },
  {
    path: "supabase/migrations/20260625150000_kcse_math_f1_b4.sql",
    expectedLessonCount: 27,
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

// Find plain (non-JSONB) SQL string literals containing a double-backslash. LaTeX in plain string
// fields (question_text, explanation) must use a single backslash; "\\" there renders broken in KaTeX.
// (JSONB literals legitimately use "\\" and are excluded.)
function plainStringsWithDoubleBackslash(text: string): string[] {
  const bad: string[] = [];
  let i = 0;
  while (i < text.length) {
    if (text[i] === "'") {
      let j = i + 1;
      let body = "";
      while (j < text.length) {
        if (text[j] === "'") {
          if (text[j + 1] === "'") {
            body += "''";
            j += 2;
            continue;
          }
          break;
        }
        body += text[j];
        j += 1;
      }
      const isJsonb = text.slice(j + 1, j + 8).startsWith("::jsonb");
      if (!isJsonb && body.includes("\\\\")) {
        bad.push(body.slice(0, 80));
      }
      i = j + 1;
    } else {
      i += 1;
    }
  }
  return bad;
}

// extract every practice question's options + correct_answer JSONB pair
function extractQuestions(
  text: string,
): Array<{ options: string; answer: string }> {
  const out: Array<{ options: string; answer: string }> = [];
  const re = /'(\[[^\]]*\])'::jsonb,\s*'("[^']*")'::jsonb/gs;
  let m: RegExpExecArray | null;
  while ((m = re.exec(text)) !== null) {
    out.push({
      options: m[1].replace(/''/g, "'"),
      answer: m[2].replace(/''/g, "'"),
    });
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

      it("every practice question has valid JSON options + answer, and the answer is one of the options", () => {
        const questions = extractQuestions(sql);
        expect(questions.length).toBeGreaterThan(0);

        const failures: string[] = [];
        for (const { options, answer } of questions) {
          try {
            const opts = JSON.parse(options) as unknown;
            const ans = JSON.parse(answer) as unknown;
            if (!Array.isArray(opts) || !opts.includes(ans)) {
              failures.push(`answer ${answer} not in options ${options}`);
            }
          } catch (error) {
            // invalid JSON (e.g. single-backslash LaTeX in a JSONB field) — would fail ::jsonb load
            failures.push(`invalid JSON: ${options} / ${answer}`);
          }
        }
        expect(failures).toEqual([]);
      });

      it("no plain SQL string over-escapes LaTeX (question_text/explanation must use single backslash)", () => {
        expect(plainStringsWithDoubleBackslash(sql)).toEqual([]);
      });
    });
  }
});
