/**
 * @vitest-environment node
 */
import { describe, expect, it, vi } from "vitest";

const getUser = vi.fn(async () => ({
  data: { user: { id: "user-1" } },
  error: null,
}));

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: { getUser },
    from: (table: string) => {
      if (table === "student_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: { id: "student-1" }, error: null }),
            }),
          }),
        };
      }
      throw new Error(`unexpected table ${table}`);
    },
  })),
}));

vi.mock("@/server/services/misconceptionService", () => ({
  getDueMisconceptionReviews: vi.fn(async () => [
    { id: "review-1", errorCode: "sign_error", description: "Mixed up positive/negative signs", topicId: "topic-1" },
  ]),
  resolveMisconceptionReview: vi.fn(async () => undefined),
}));

describe("GET /api/nex/reviews/due", () => {
  it("returns due reviews for the authenticated student", async () => {
    const { GET } = await import("@/app/api/nex/reviews/due/route");
    const response = await GET(new Request("http://localhost/api/nex/reviews/due"));
    const payload = await response.json();

    expect(response.status).toBe(200);
    expect(payload.success).toBe(true);
    expect(payload.data).toHaveLength(1);
    expect(payload.data[0].errorCode).toBe("sign_error");
  });
});

describe("POST /api/nex/reviews/[id]/resolve", () => {
  it("resolves the review for the authenticated student", async () => {
    const { resolveMisconceptionReview } = await import(
      "@/server/services/misconceptionService"
    );
    const { POST } = await import("@/app/api/nex/reviews/[id]/resolve/route");

    const response = await POST(
      new Request("http://localhost/api/nex/reviews/review-1/resolve", { method: "POST" }),
      { params: Promise.resolve({ id: "review-1" }) },
    );
    const payload = await response.json();

    expect(response.status).toBe(200);
    expect(payload.success).toBe(true);
    expect(resolveMisconceptionReview).toHaveBeenCalledWith("student-1", "review-1");
  });
});
