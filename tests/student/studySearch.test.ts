/**
 * @vitest-environment node
 */
import { describe, expect, it, vi } from "vitest";

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => ({
      select: () => ({
        eq: () => ({
          maybeSingle: async () => ({ data: null, error: null }),
        }),
        lte: () => ({
          eq: () => async () => ({ data: [], error: null }),
        }),
      }),
      in: () => ({
        eq: () => ({
          textSearch: () => ({
            limit: async () => ({ data: [], error: null }),
          }),
        }),
      }),
    }),
  })),
}));

import { searchStudentContent } from "@/server/services/studentSearchService";
import type { StudentProfile } from "@/types/database";

const profile = {
  id: "student-1",
  curriculum: "KCSE",
  grade_level: "form_3",
} as StudentProfile;

describe("study search", () => {
  it("returns no hits for short queries", async () => {
    await expect(searchStudentContent(profile, "a")).resolves.toEqual([]);
  });

  it("returns no hits for blank queries", async () => {
    await expect(searchStudentContent(profile, "   ")).resolves.toEqual([]);
  });
});
