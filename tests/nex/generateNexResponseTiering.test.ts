/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const callNexModelMock = vi.fn(async () => ({ content: "CONCEPT\nA fraction is a part of a whole.", provider: "gemini" as const }));

vi.mock("@/lib/nex/callNexModel", () => ({
  callNexModel: callNexModelMock,
  streamNexModel: vi.fn(),
}));

vi.mock("@/lib/nex/loadStudentMemory", () => ({
  loadStudentMemory: vi.fn(async () => null),
}));

vi.mock("@/lib/nex/loadCurriculumContext", () => ({
  loadCurriculumContext: vi.fn(async () => null),
}));

describe("generateNexResponse model tiering", () => {
  beforeEach(() => {
    callNexModelMock.mockClear();
  });

  it("passes a lite modelOverride for a short explain-mode question", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      studentId: "student-1",
      studentMessage: "What is a fraction?",
      sessionMode: "explain",
      sessionMetadata: {
        hintLevel: 1,
        hintCount: 0,
        attemptCount: 0,
        misconceptionDetected: false,
      },
      recentMessages: [],
    });

    expect(callNexModelMock).toHaveBeenCalledWith(
      expect.objectContaining({ modelOverride: "gemini-3.5-flash-lite" }),
    );
  });

  it("does not set a lite override for homework mode", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      studentId: "student-1",
      studentMessage: "help me with this",
      sessionMode: "homework",
      sessionMetadata: {
        hintLevel: 1,
        hintCount: 0,
        attemptCount: 0,
        misconceptionDetected: false,
      },
      recentMessages: [],
    });

    expect(callNexModelMock).toHaveBeenCalledWith(
      expect.objectContaining({ modelOverride: undefined }),
    );
  });
});
