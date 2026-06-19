import { describe, expect, it } from "vitest";

import {
  buildLearningPreferenceHints,
  DEFAULT_LEARNING_PREFERENCES,
  learningPreferencesSchema,
  learningPreferencesToDb,
  parseLearningPreferencesFromDb,
} from "@/schemas/profileSchemas";

describe("learningPreferencesSchema", () => {
  it("accepts valid preferences", () => {
    const parsed = learningPreferencesSchema.safeParse({
      explanationDepth: "detailed",
      sessionGoalMinutes: 45,
      reminderChannel: "sms",
      learningTone: "encouraging",
    });

    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.explanationDepth).toBe("detailed");
      expect(parsed.data.sessionGoalMinutes).toBe(45);
    }
  });

  it("rejects session goal outside bounds", () => {
    const parsed = learningPreferencesSchema.safeParse({
      explanationDepth: "standard",
      sessionGoalMinutes: 3,
      reminderChannel: "off",
    });

    expect(parsed.success).toBe(false);
  });

  it("rejects invalid explanation depth", () => {
    const parsed = learningPreferencesSchema.safeParse({
      explanationDepth: "verbose",
      sessionGoalMinutes: 20,
      reminderChannel: "email",
    });

    expect(parsed.success).toBe(false);
  });
});

describe("parseLearningPreferencesFromDb", () => {
  it("returns defaults for null or invalid data", () => {
    expect(parseLearningPreferencesFromDb(null)).toEqual(
      DEFAULT_LEARNING_PREFERENCES,
    );
    expect(parseLearningPreferencesFromDb({ bad: true })).toEqual(
      DEFAULT_LEARNING_PREFERENCES,
    );
  });

  it("parses valid stored JSON", () => {
    expect(
      parseLearningPreferencesFromDb({
        explanationDepth: "quick",
        sessionGoalMinutes: 15,
        reminderChannel: "email",
        learningTone: "focused",
      }),
    ).toEqual({
      explanationDepth: "quick",
      sessionGoalMinutes: 15,
      reminderChannel: "email",
      learningTone: "focused",
    });
  });
});

describe("learningPreferencesToDb", () => {
  it("maps preferences to JSONB payload without optional tone", () => {
    expect(
      learningPreferencesToDb({
        explanationDepth: "standard",
        sessionGoalMinutes: 20,
        reminderChannel: "off",
      }),
    ).toEqual({
      explanationDepth: "standard",
      sessionGoalMinutes: 20,
      reminderChannel: "off",
    });
  });

  it("includes learningTone when set", () => {
    expect(
      learningPreferencesToDb({
        explanationDepth: "detailed",
        sessionGoalMinutes: 60,
        reminderChannel: "sms",
        learningTone: "friendly",
      }),
    ).toEqual({
      explanationDepth: "detailed",
      sessionGoalMinutes: 60,
      reminderChannel: "sms",
      learningTone: "friendly",
    });
  });
});

describe("buildLearningPreferenceHints", () => {
  it("includes depth and session goal guidance", () => {
    const hints = buildLearningPreferenceHints({
      explanationDepth: "quick",
      sessionGoalMinutes: 10,
      reminderChannel: "off",
    });

    expect(hints).toContain("STUDENT LEARNING PREFERENCES");
    expect(hints).toContain("quick");
    expect(hints).toContain("10 minutes");
  });

  it("includes tone when provided", () => {
    const hints = buildLearningPreferenceHints({
      explanationDepth: "standard",
      sessionGoalMinutes: 20,
      reminderChannel: "email",
      learningTone: "encouraging",
    });

    expect(hints).toContain("encouraging");
  });
});
