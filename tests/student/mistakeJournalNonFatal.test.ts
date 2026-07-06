/**
 * @vitest-environment node
 */
import { describe, expect, it, vi } from "vitest";

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => ({
      select: () => ({
        eq: () => ({
          eq: async () => ({
            data: null,
            error: { message: "journal read failed" },
          }),
        }),
      }),
    }),
  })),
}));

import { recordPracticeSessionMistakesNonFatal } from "@/server/services/mistakeJournalService";

describe("non-fatal mistake journal recording", () => {
  it("does not throw when practice journal recording fails", async () => {
    const consoleSpy = vi.spyOn(console, "error").mockImplementation(() => {});

    await expect(
      recordPracticeSessionMistakesNonFatal("student-1", "session-1"),
    ).resolves.toBeUndefined();

    expect(consoleSpy).toHaveBeenCalledWith(
      "MISTAKE_JOURNAL_WRITE_FAILED",
      expect.objectContaining({
        studentId: "student-1",
        sessionId: "session-1",
      }),
    );

    consoleSpy.mockRestore();
  });
});
