import { beforeEach, describe, expect, it, vi } from "vitest";

import * as contentModel from "@/lib/curriculum/contentModel";

const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

import { runTopicProdReadyPublishGate } from "@/server/services/contentQualityGates";

function subtopicBuilder(subtopicIds: string[]) {
  return {
    select: vi.fn(() => ({
      eq: vi.fn(() => ({
        eq: vi.fn(async () => ({ data: subtopicIds.map((id) => ({ id })), error: null })),
      })),
    })),
  };
}

function lessonsBuilder(subtopicIds: string[]) {
  return {
    select: vi.fn(() => ({
      in: vi.fn(() => ({
        eq: vi.fn(() => ({
          eq: vi.fn(async () => ({
            data: subtopicIds.map((id) => ({ subtopic_id: id })),
            error: null,
          })),
        })),
      })),
    })),
  };
}

function questionsBuilder(counts: { easy: number; medium: number; hard: number }) {
  const rows = [
    ...Array.from({ length: counts.easy }, () => ({ difficulty: "easy" })),
    ...Array.from({ length: counts.medium }, () => ({ difficulty: "medium" })),
    ...Array.from({ length: counts.hard }, () => ({ difficulty: "hard" })),
  ];

  return {
    select: vi.fn(() => ({
      eq: vi.fn(() => ({
        eq: vi.fn(() => ({
          eq: vi.fn(async () => ({ data: rows, error: null })),
        })),
      })),
    })),
  };
}

beforeEach(() => {
  vi.clearAllMocks();
  vi.restoreAllMocks();
});

describe("runTopicProdReadyPublishGate", () => {
  it("blocks publish when a stale prod-ready label disagrees with DEC-002 counts", async () => {
    vi.spyOn(contentModel, "getTopicReadinessLabel").mockReturnValue("PROD_READY");

    from.mockImplementation((table: string) => {
      if (table === "subtopics") {
        return subtopicBuilder(["s1", "s2", "s3"]);
      }
      if (table === "lessons") {
        return lessonsBuilder(["s1", "s2", "s3"]);
      }
      if (table === "practice_questions") {
        return questionsBuilder({ easy: 5, medium: 0, hard: 0 });
      }
      return {};
    });

    const result = await runTopicProdReadyPublishGate("topic-1");
    expect(result.passed).toBe(false);
    expect(result.errors[0]).toContain("DEC-002");
  });
});
