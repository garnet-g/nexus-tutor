import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

import { detectNexMode } from "@/lib/nex/detectNexMode";
import { assemblePrompt } from "@/lib/nex/assemblePrompt";
import {
  canRevealFullSolution,
  parseSessionMetadata,
  updateAssessmentState,
  updateSocraticState,
} from "@/lib/nex/socraticTutorEngine";
import type { HintLevel, NexMode } from "@/lib/nex/types";
import { validateNexResponse } from "@/lib/nex/validateNexResponse";

interface GoldenConversationCase {
  id: string;
  description: string;
  studentMessage: string;
  expectedMode: NexMode;
  attemptCount: number;
  hintLevel: HintLevel;
  badResponse?: string;
  goodResponse?: string;
  expectBadValidation?: "pass" | "fail" | "ambiguous";
  expectGoodValidation?: "pass" | "fail" | "ambiguous";
  initialMetadata?: {
    hintLevel: HintLevel;
    hintCount: number;
    attemptCount: number;
    misconceptionDetected: boolean;
  };
  expectCanRevealFullSolution?: boolean;
}

const goldenDir = join(process.cwd(), "tests/nex/golden-conversations");
const goldenFiles = readdirSync(goldenDir).filter((file) => file.endsWith(".json"));

const goldenCases: GoldenConversationCase[] = goldenFiles.map((file) => {
  const raw = readFileSync(join(goldenDir, file), "utf8");
  return JSON.parse(raw) as GoldenConversationCase;
});

describe("Nex golden conversations", () => {
  it("loads at least twenty golden cases", () => {
    expect(goldenCases.length).toBeGreaterThanOrEqual(20);
  });

  goldenCases.forEach((testCase) => {
    describe(testCase.id, () => {
      it("detects the expected teaching mode", () => {
        expect(detectNexMode(testCase.studentMessage)).toBe(testCase.expectedMode);
      });

      if (testCase.badResponse) {
        it("blocks bad homework-first-turn responses when applicable", () => {
          const result = validateNexResponse({
            mode: testCase.expectedMode,
            response: testCase.badResponse!,
            attemptCount: testCase.attemptCount,
            hintLevel: testCase.hintLevel,
            studentMessage: testCase.studentMessage,
          });

          expect(result.status).toBe(testCase.expectBadValidation ?? "fail");
        });
      }

      if (testCase.goodResponse) {
        it("accepts good Socratic responses", () => {
          const result = validateNexResponse({
            mode: testCase.expectedMode,
            response: testCase.goodResponse!,
            attemptCount: testCase.attemptCount,
            hintLevel: testCase.hintLevel,
            studentMessage: testCase.studentMessage,
          });

          expect(result.status).toBe(testCase.expectGoodValidation ?? "pass");
        });
      }

      if (testCase.initialMetadata) {
        it("respects hint escalation metadata rules", () => {
          const metadata = parseSessionMetadata(testCase.initialMetadata);
          expect(canRevealFullSolution(metadata)).toBe(
            Boolean(testCase.expectCanRevealFullSolution),
          );
        });
      }

      it("assembles a mode-specific system prompt", () => {
        const prompt = assemblePrompt({
          mode: testCase.expectedMode,
          recentMessages: [{ role: "student", content: testCase.studentMessage }],
        });

        expect(prompt.systemPrompt).toContain("You are Nex");
        expect(prompt.systemPrompt).toContain(
          `MODE: ${testCase.expectedMode.toUpperCase()}`,
        );
      });
    });
  });

  it("escalates homework hint requests without resetting attempts", () => {
    const metadata = updateSocraticState(
      parseSessionMetadata({
        hintLevel: 1,
        hintCount: 0,
        attemptCount: 1,
        misconceptionDetected: false,
      }),
      "I'm stuck, can I get a hint?",
      "homework",
    );

    expect(metadata.hintLevel).toBeGreaterThan(1);
    expect(metadata.attemptCount).toBe(1);
  });

  it("completes a three-question assessment after student attempts", () => {
    let metadata = parseSessionMetadata({
      assessmentStatus: "in_progress",
      questionIndex: 0,
      correctCount: 0,
      assessmentQuestionCount: 3,
    });

    metadata = updateAssessmentState(metadata, "x = 4");
    metadata = updateAssessmentState(metadata, "x = 2");
    metadata = updateAssessmentState(metadata, "x = 7");

    expect(metadata.assessmentStatus).toBe("completed");
    expect(metadata.questionIndex).toBe(3);
    expect(metadata.correctCount).toBe(3);
  });
});
