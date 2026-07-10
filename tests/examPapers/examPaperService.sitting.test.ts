import { beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("@/lib/supabase/admin", () => ({ createAdminClient: vi.fn() }));

import { createAdminClient } from "@/lib/supabase/admin";
import { chooseSectionTwoQuestions, getExamPaperSessionForSitting } from "@/server/services/examPaperService";

function makeFakeAdmin(overrides: {
  session?: any;
  questions?: any[];
  updateStatusSpy?: (payload: any) => void;
}) {
  return {
    from(table: string) {
      if (table === "exam_paper_sessions") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => ({
                maybeSingle: () => Promise.resolve({ data: overrides.session ?? null }),
              }),
            }),
          }),
          update: (payload: any) => {
            overrides.updateStatusSpy?.(payload);
            return { eq: () => Promise.resolve({ data: null, error: null }) };
          },
        };
      }
      if (table === "exam_paper_session_questions") {
        return {
          select: () => ({
            eq: () => ({
              order: () => Promise.resolve({ data: overrides.questions ?? [] }),
              eq: () => Promise.resolve({ data: overrides.questions ?? [] }),
            }),
          }),
          update: () => ({
            eq: () => ({ eq: () => Promise.resolve({ data: null, error: null }) }),
            in: () => Promise.resolve({ data: null, error: null }),
          }),
        };
      }
      if (table === "exam_paper_answers") {
        return {
          select: () => ({ in: () => Promise.resolve({ data: [] }) }),
        };
      }
      throw new Error(`Unexpected table: ${table}`);
    },
  };
}

describe("getExamPaperSessionForSitting", () => {
  it("returns null when the session does not exist for this student", async () => {
    vi.mocked(createAdminClient).mockReturnValue(makeFakeAdmin({ session: null }) as any);
    const result = await getExamPaperSessionForSitting("missing", "student-1");
    expect(result).toBeNull();
  });

  it("marks an in-progress session expired once past ends_at", async () => {
    const updateStatusSpy = vi.fn();
    const pastEndsAt = new Date(Date.now() - 60_000).toISOString();
    vi.mocked(createAdminClient).mockReturnValue(
      makeFakeAdmin({
        session: { id: "s1", paper: 1, status: "in_progress", ends_at: pastEndsAt, total_marks: 100 },
        questions: [],
        updateStatusSpy,
      }) as any,
    );
    const result = await getExamPaperSessionForSitting("s1", "student-1");
    expect(result?.status).toBe("expired");
    expect(updateStatusSpy).toHaveBeenCalledWith({ status: "expired" });
  });
});

describe("chooseSectionTwoQuestions", () => {
  let currentSession: any;
  let sectionTwo: any[];

  beforeEach(() => {
    currentSession = { id: "s1", status: "in_progress" };
    sectionTwo = [
      { id: "q1", chosen: false },
      { id: "q2", chosen: false },
      { id: "q3", chosen: false },
      { id: "q4", chosen: false },
      { id: "q5", chosen: false },
      { id: "q6", chosen: false },
      { id: "q7", chosen: false },
      { id: "q8", chosen: false },
    ];
  });

  it("throws NOT_FOUND when the session does not belong to the student", async () => {
    vi.mocked(createAdminClient).mockReturnValue(makeFakeAdmin({ session: null }) as any);
    await expect(
      chooseSectionTwoQuestions("s1", "student-1", ["q1", "q2", "q3", "q4", "q5"]),
    ).rejects.toThrow("NOT_FOUND");
  });
});
