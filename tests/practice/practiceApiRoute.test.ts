import { beforeEach, describe, expect, it, vi } from "vitest";

import { POST } from "@/app/api/practice-sessions/route";

vi.mock("@/server/services/studentContext", () => ({
  requireStudentProfile: vi.fn(),
  apiErrorResponse: vi.fn((code: string, message: string, status: number) =>
    Response.json({ success: false, error: { code, message } }, { status }),
  ),
}));

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  getEffectiveSubscriptionConfigWithFallback: vi.fn(async () => ({})),
  getPracticeDailyLimit: vi.fn(() => 3),
}));

vi.mock("@/server/services/nexUsageService", () => ({
  getPracticeDailyUsageCount: vi.fn(async () => 0),
  getSecondsUntilNairobiMidnight: vi.fn(() => 3600),
  getStudentPlanCode: vi.fn(async () => "free"),
  incrementPracticeDailyUsage: vi.fn(async () => undefined),
}));

const startPracticeSession = vi.fn();

vi.mock("@/server/services/practiceService", () => ({
  startPracticeSession: (...args: unknown[]) => startPracticeSession(...args),
}));

const { requireStudentProfile } = await import("@/server/services/studentContext");

const TOPIC_ID = "11111111-1111-4111-8111-111111111111";
const SUBTOPIC_ID = "22222222-2222-4222-8222-222222222222";

beforeEach(() => {
  vi.clearAllMocks();
  vi.mocked(requireStudentProfile).mockResolvedValue({
    ok: true,
    profile: {
      id: "student-1",
      has_completed_diagnostic: true,
      curriculum: "CBC",
      grade_level: "Grade 6",
    },
  } as never);
});

describe("POST /api/practice-sessions", () => {
  it("returns 404 when selected subtopic has no published questions", async () => {
    startPracticeSession.mockRejectedValue(new Error("NO_QUESTIONS_FOR_SUBTOPIC"));

    const response = await POST(
      new Request("http://localhost/api/practice-sessions", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          topicId: TOPIC_ID,
          subtopicId: SUBTOPIC_ID,
          difficulty: "medium",
          questionCount: 10,
        }),
      }),
    );

    expect(response.status).toBe(404);
    const payload = await response.json();
    expect(payload.error.code).toBe("NO_QUESTIONS_FOR_SUBTOPIC");
  });
});
