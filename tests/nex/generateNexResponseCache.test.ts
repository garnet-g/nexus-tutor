/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const callNexModelMock = vi.fn(async () => ({ content: "CONCEPT\nFresh answer.", provider: "gemini" as const }));
const getCachedExplainResponseMock = vi.fn(async () => null as string | null);
const storeExplainResponseMock = vi.fn(async () => undefined);

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

vi.mock("@/server/services/nexResponseCacheService", () => ({
  getCachedExplainResponse: getCachedExplainResponseMock,
  storeExplainResponse: storeExplainResponseMock,
}));

const baseInput = {
  studentId: "student-1",
  sessionMode: "explain" as const,
  sessionMetadata: {
    hintLevel: 1 as const,
    hintCount: 0,
    attemptCount: 0,
    misconceptionDetected: false,
  },
  recentMessages: [],
  topicId: "topic-1",
};

describe("generateNexResponse explain-mode cache", () => {
  beforeEach(() => {
    callNexModelMock.mockClear();
    getCachedExplainResponseMock.mockClear();
    storeExplainResponseMock.mockClear();
  });

  it("returns the cached response without calling the model on a hit", async () => {
    getCachedExplainResponseMock.mockResolvedValueOnce("Cached: a fraction is a part of a whole.");

    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    const result = await generateNexResponse({
      ...baseInput,
      studentMessage: "What is a fraction?",
    });

    expect(result.response).toBe("Cached: a fraction is a part of a whole.");
    expect(result.provider).toBe("cache");
    expect(callNexModelMock).not.toHaveBeenCalled();
  });

  it("calls the model and stores the result on a cache miss", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      ...baseInput,
      studentMessage: "What is a percentage?",
    });

    expect(callNexModelMock).toHaveBeenCalledTimes(1);
    expect(storeExplainResponseMock).toHaveBeenCalledWith(
      "topic-1",
      "What is a percentage?",
      "CONCEPT\nFresh answer.",
    );
  });

  it("does not check the cache for homework mode", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      ...baseInput,
      sessionMode: "homework",
      studentMessage: "help me solve this",
    });

    expect(getCachedExplainResponseMock).not.toHaveBeenCalled();
  });

  it("does not check the cache when there is no topicId", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      ...baseInput,
      topicId: undefined,
      studentMessage: "What is a fraction?",
    });

    expect(getCachedExplainResponseMock).not.toHaveBeenCalled();
  });
});
