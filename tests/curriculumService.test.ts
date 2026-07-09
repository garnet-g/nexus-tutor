import { describe, expect, it } from "vitest";

import {
  isTopicVisibleForGrade,
  MIN_PRACTICE_QUESTIONS_PER_TOPIC,
  MIN_TOPICS_PER_SUBJECT,
  TIER1_SUBJECT_CODES,
  ACTIVE_SUBJECT_CODES,
} from "@/lib/curriculum/contentModel";

describe("curriculumService", () => {
  it("exposes Tier 1 subject codes only", () => {
    expect(TIER1_SUBJECT_CODES).toEqual(["mathematics", "science", "english"]);
    expect(TIER1_SUBJECT_CODES).not.toContain("kiswahili");
    expect(TIER1_SUBJECT_CODES).not.toContain("cambridge");
  });

  it("only activates mathematics for maths-only platform launch", () => {
    expect(ACTIVE_SUBJECT_CODES).toContain("mathematics");
    expect(ACTIVE_SUBJECT_CODES).not.toContain("kiswahili");
    expect(ACTIVE_SUBJECT_CODES).not.toContain("chemistry");
  });

  it("allows topics at or one grade above the student", () => {
    expect(isTopicVisibleForGrade(2, 2)).toBe(true);
    expect(isTopicVisibleForGrade(3, 2)).toBe(true);
    expect(isTopicVisibleForGrade(4, 2)).toBe(false);
  });

  it("shows all topics when grade sort order is unknown", () => {
    expect(isTopicVisibleForGrade(5, null)).toBe(true);
  });

  it("matches minimum manifest topic counts per curriculum", () => {
    expect(MIN_TOPICS_PER_SUBJECT).toBe(3);
    expect(MIN_PRACTICE_QUESTIONS_PER_TOPIC).toBe(21);
  });
});
