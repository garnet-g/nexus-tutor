/**
 * @vitest-environment node
 *
 * PR-062: cross-family isolation must be proven through the authenticated
 * parent API path — not a direct service-role unit test.
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const PARENT_A = "00000000-0000-4000-8000-000000000101";
const STUDENT_A = "00000000-0000-4000-8000-000000000201";
const STUDENT_B = "00000000-0000-4000-8000-000000000202";

type WeeklyGoalRow = {
  target_minutes: number;
  target_tasks: number;
  note: string | null;
  week_start_date: string;
  parent_visible?: boolean;
};

const weeklyGoalsByStudent = new Map<string, WeeklyGoalRow>();
const activeLinks = new Set<string>();

function linkKey(parentId: string, studentId: string) {
  return `${parentId}:${studentId}`;
}

function chainableFilter(resolver: () => Promise<{ data: unknown; error: null }>) {
  const chain: Record<string, unknown> = {};
  const terminal = () => resolver();
  chain.eq = () => chain;
  chain.maybeSingle = terminal;
  chain.select = () => chain;
  return chain;
}

function createParentSupabaseMock() {
  return {
    auth: {
      getUser: vi.fn(async () => ({
        data: { user: { id: "user-parent-a" } },
        error: null,
      })),
    },
    from: (table: string) => {
      if (table === "parent_profiles") {
        return {
          select: () =>
            chainableFilter(async () => ({
              data: { id: PARENT_A },
              error: null,
            })),
        };
      }

      if (table === "student_parent_links") {
        const filters: Record<string, string> = {};

        const buildLinksList = () =>
          [...activeLinks]
            .filter((key) => key.startsWith(`${filters.parent_id}:`))
            .map((key) => key.split(":")[1])
            .filter(Boolean)
            .map((studentIdValue) => ({
              linked_at: "2026-07-01T00:00:00.000Z",
              student_profiles: {
                id: studentIdValue,
                full_name: studentIdValue === STUDENT_A ? "Student A" : "Student B",
                grade_level: "form_3",
                curriculum: "KCSE",
              },
            }));

        const linkChain: Record<string, unknown> = {};
        linkChain.select = () => linkChain;
        linkChain.eq = (column: string, value: string) => {
          filters[column] = value;

          if (column === "link_status") {
            const listResult = {
              data: buildLinksList(),
              error: null,
            };
            return Object.assign(Promise.resolve(listResult), linkChain);
          }

          return linkChain;
        };
        linkChain.maybeSingle = async () => {
          const parentId = filters.parent_id;
          const studentId = filters.student_id;
          const status = filters.link_status;

          if (status === "active" && parentId && studentId) {
            return {
              data: activeLinks.has(linkKey(parentId, studentId))
                ? { id: "link-1" }
                : null,
              error: null,
            };
          }

          return { data: null, error: null };
        };

        return linkChain;
      }

      if (table === "student_weekly_goals") {
        const filters: Record<string, string> = {};
        const goalChain: Record<string, unknown> = {};
        goalChain.select = () => goalChain;
        goalChain.eq = (column: string, value: string) => {
          filters[column] = value;
          return goalChain;
        };
        goalChain.maybeSingle = async () => {
          const studentId = filters.student_id;
          const row = studentId ? weeklyGoalsByStudent.get(studentId) : undefined;

          if (!row || row.parent_visible === false) {
            return { data: null, error: null };
          }

          return {
            data: {
              target_minutes: row.target_minutes,
              target_tasks: row.target_tasks,
              note: row.note,
              week_start_date: row.week_start_date,
            },
            error: null,
          };
        };

        return goalChain;
      }

      throw new Error(`Unexpected table in parent isolation mock: ${table}`);
    },
  };
}

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => createParentSupabaseMock()),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => ({
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

import { GET as overviewGET } from "@/app/api/parents/overview/route";
import { GET as weeklyGoalGET } from "@/app/api/parents/linked-students/[studentId]/weekly-goal/route";
import { getWeekStartDate } from "@/server/services/studentExperienceService";

describe("parent weekly goal cross-family isolation (API path)", () => {
  beforeEach(() => {
    weeklyGoalsByStudent.clear();
    activeLinks.clear();
    activeLinks.add(linkKey(PARENT_A, STUDENT_A));
    weeklyGoalsByStudent.set(STUDENT_A, {
      target_minutes: 150,
      target_tasks: 5,
      note: "Algebra focus",
      week_start_date: getWeekStartDate(),
      parent_visible: true,
    });
    weeklyGoalsByStudent.set(STUDENT_B, {
      target_minutes: 200,
      target_tasks: 8,
      note: "Other family goal",
      week_start_date: getWeekStartDate(),
      parent_visible: true,
    });
  });

  it("returns 404 when parent A requests student B weekly goal (unlinked)", async () => {
    const response = await weeklyGoalGET(new Request("https://nexus.test"), {
      params: Promise.resolve({ studentId: STUDENT_B }),
    });

    expect(response.status).toBe(404);
    const body = (await response.json()) as { error: { code: string } };
    expect(body.error.code).toBe("NOT_LINKED");
  });

  it("returns weekly goal when linked and parent_visible=true", async () => {
    const response = await weeklyGoalGET(new Request("https://nexus.test"), {
      params: Promise.resolve({ studentId: STUDENT_A }),
    });

    expect(response.status).toBe(200);
    const body = (await response.json()) as {
      success: boolean;
      data: { weeklyGoal: { targetMinutes: number } };
    };
    expect(body.data.weeklyGoal.targetMinutes).toBe(150);
  });

  it("returns null weekly goal when linked but parent_visible=false (RLS backstop)", async () => {
    weeklyGoalsByStudent.set(STUDENT_A, {
      target_minutes: 150,
      target_tasks: 5,
      note: "Hidden",
      week_start_date: getWeekStartDate(),
      parent_visible: false,
    });

    const response = await weeklyGoalGET(new Request("https://nexus.test"), {
      params: Promise.resolve({ studentId: STUDENT_A }),
    });

    expect(response.status).toBe(200);
    const body = (await response.json()) as {
      data: { weeklyGoal: null };
    };
    expect(body.data.weeklyGoal).toBeNull();
  });

  it("overview never includes unlinked student B for parent A", async () => {
    const response = await overviewGET();

    expect(response.status).toBe(200);
    const body = (await response.json()) as {
      data: {
        linkedStudents: Array<{ studentId: string; weeklyGoal: unknown }>;
      };
    };

    const studentIds = body.data.linkedStudents.map((student) => student.studentId);
    expect(studentIds).toEqual([STUDENT_A]);
    expect(studentIds).not.toContain(STUDENT_B);
  });
});
