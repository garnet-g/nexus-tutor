/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const PARENT_A = "00000000-0000-4000-8000-000000000101";
const STUDENT_A = "00000000-0000-4000-8000-000000000201";

const activeLinks = new Set<string>();
let updateCalled = false;

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: {
      getUser: async () => ({
        data: { user: { id: "user-parent-a" } },
        error: null,
      }),
    },
    from: (table: string) => {
      if (table === "parent_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: { id: PARENT_A }, error: null }),
            }),
          }),
        };
      }

      if (table === "student_parent_links") {
        const filters: Record<string, string> = {};
        const chain: Record<string, unknown> = {};
        chain.select = () => chain;
        chain.eq = (column: string, value: string) => {
          filters[column] = value;
          if (column === "link_status") {
            const linked = activeLinks.has(`${filters.parent_id}:${STUDENT_A}`)
              ? [
                  {
                    linked_at: "2026-07-01T00:00:00.000Z",
                    student_profiles: {
                      id: STUDENT_A,
                      full_name: "Student A",
                      grade_level: "form_3",
                      curriculum: "KCSE",
                    },
                  },
                ]
              : [];
            return Promise.resolve({ data: linked, error: null });
          }
          return chain;
        };
        chain.maybeSingle = async () => ({
          data:
            filters.link_status === "active" &&
            activeLinks.has(`${filters.parent_id}:${filters.student_id}`)
              ? { id: "link-1" }
              : null,
          error: null,
        });
        return chain;
      }

      if (table === "student_weekly_goals") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => ({
                maybeSingle: async () => ({ data: null, error: null }),
              }),
            }),
          }),
        };
      }

      return {
        select: () => ({
          eq: () => ({
            maybeSingle: async () => ({ data: null, error: null }),
          }),
        }),
      };
    },
  })),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => ({
      update: () => ({
        eq: () => ({
          eq: () => ({
            eq: () => ({
              select: () => ({
                maybeSingle: async () => {
                  updateCalled = true;
                  activeLinks.clear();
                  return { data: { id: "link-1" }, error: null };
                },
              }),
            }),
          }),
        }),
      }),
      select: () => ({
        eq: () => ({
          gte: async () => ({ data: [], error: null }),
          lt: () => ({
            order: () => ({
              limit: async () => ({ data: [], error: null }),
            }),
          }),
          order: () => ({
            limit: () => ({
              maybeSingle: async () => ({ data: null, error: null }),
            }),
          }),
        }),
      }),
    }),
  })),
}));

vi.mock("@/server/services/kcseMathRevisionService", () => ({
  getKcseMathRevisionHubForStudent: vi.fn(async () => null),
}));

import { DELETE as unlinkDELETE } from "@/app/api/parents/linked-students/[studentId]/route";
import { GET as overviewGET } from "@/app/api/parents/overview/route";

describe("parent unlink revocation", () => {
  beforeEach(() => {
    activeLinks.clear();
    activeLinks.add(`${PARENT_A}:${STUDENT_A}`);
    updateCalled = false;
  });

  it("revokes link and returns empty overview on the next request", async () => {
    const before = await overviewGET();
    const beforeBody = (await before.json()) as {
      data: { linkedStudents: Array<{ studentId: string }> };
    };
    expect(beforeBody.data.linkedStudents).toHaveLength(1);

    const unlinkResponse = await unlinkDELETE(new Request("https://nexus.test"), {
      params: Promise.resolve({ studentId: STUDENT_A }),
    });
    expect(unlinkResponse.status).toBe(200);
    expect(updateCalled).toBe(true);

    const after = await overviewGET();
    const afterBody = (await after.json()) as {
      data: { linkedStudents: Array<{ studentId: string }> };
    };
    expect(afterBody.data.linkedStudents).toHaveLength(0);
  });
});
