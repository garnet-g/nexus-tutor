import { describe, expect, it } from "vitest";

import {
  assembleExamPaper,
  hasSufficientTemplateBank,
  type TemplateRecord,
} from "@/lib/examPapers/paperAssembly";
import { mulberry32 } from "@/lib/examPapers/paramSampler";

function makeTemplate(overrides: Partial<TemplateRecord> & { id: string }): TemplateRecord {
  return {
    paper: 1,
    section: "I",
    formLevel: 1,
    topicId: `topic-${overrides.id}`,
    marks: 3,
    body: {},
    ...overrides,
  };
}

function buildRichPool(): TemplateRecord[] {
  const templates: TemplateRecord[] = [];
  for (let i = 0; i < 10; i += 1) {
    templates.push(makeTemplate({ id: `s1-four-${i}`, marks: 4 }));
  }
  for (let i = 0; i < 10; i += 1) {
    templates.push(makeTemplate({ id: `s1-two-${i}`, marks: 2 }));
  }
  for (let i = 0; i < 20; i += 1) {
    templates.push(makeTemplate({ id: `s1-three-${i}`, marks: 3 }));
  }
  for (let i = 0; i < 10; i += 1) {
    templates.push(makeTemplate({ id: `s2-${i}`, section: "II", marks: 10 }));
  }
  return templates;
}

describe("paperAssembly", () => {
  it("assembles Section I as exactly 16 questions summing to 50 marks", () => {
    const paper = assembleExamPaper({
      templates: buildRichPool(),
      paper: 1,
      formLevel: 1,
      excludedTemplateIds: [],
      rng: mulberry32(1),
    });

    expect(paper.sectionOne).toHaveLength(16);
    expect(paper.sectionOne.reduce((sum, t) => sum + t.marks, 0)).toBe(50);
  });

  it("assembles Section II as exactly 8 questions of 10 marks each", () => {
    const paper = assembleExamPaper({
      templates: buildRichPool(),
      paper: 1,
      formLevel: 1,
      excludedTemplateIds: [],
      rng: mulberry32(1),
    });

    expect(paper.sectionTwo).toHaveLength(8);
    expect(paper.sectionTwo.every((t) => t.marks === 10)).toBe(true);
  });

  it("excludes recently used template ids", () => {
    const pool = buildRichPool();
    const excludedIds = pool.filter((t) => t.section === "I").slice(0, 5).map((t) => t.id);

    const paper = assembleExamPaper({
      templates: pool,
      paper: 1,
      formLevel: 1,
      excludedTemplateIds: excludedIds,
      rng: mulberry32(2),
    });

    const usedIds = new Set(paper.sectionOne.map((t) => t.id));
    for (const excludedId of excludedIds) {
      expect(usedIds.has(excludedId)).toBe(false);
    }
  });

  it("filters out templates above the student's form level", () => {
    const pool = buildRichPool().map((t) =>
      t.section === "I" ? { ...t, formLevel: 3 } : t,
    );
    expect(() =>
      assembleExamPaper({
        templates: pool,
        paper: 1,
        formLevel: 1,
        excludedTemplateIds: [],
        rng: mulberry32(1),
      }),
    ).toThrow("INSUFFICIENT_TEMPLATE_BANK");
  });

  it("throws INSUFFICIENT_TEMPLATE_BANK when the pool is too small", () => {
    const sparsePool: TemplateRecord[] = [
      makeTemplate({ id: "only-one", marks: 3 }),
    ];
    expect(() =>
      assembleExamPaper({
        templates: sparsePool,
        paper: 1,
        formLevel: 1,
        excludedTemplateIds: [],
        rng: mulberry32(1),
      }),
    ).toThrow("INSUFFICIENT_TEMPLATE_BANK");
  });

  it("hasSufficientTemplateBank reflects assembleExamPaper feasibility", () => {
    expect(hasSufficientTemplateBank(buildRichPool(), 1, 1)).toBe(true);
    expect(hasSufficientTemplateBank([makeTemplate({ id: "only-one" })], 1, 1)).toBe(false);
  });
});
