/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const PARENT_ID = "00000000-0000-4000-8000-000000000101";
const STUDENT_ID = "00000000-0000-4000-8000-000000000201";
const WEEK_START = "2026-07-06";

const parentReports = new Map<string, { id: string }>();
let emailSendCalls = 0;

vi.mock("@/server/services/notificationService", () => ({
  sendWeeklyParentReportEmail: vi.fn(async () => {
    emailSendCalls += 1;
  }),
}));

vi.mock("@/server/services/subscriptionService", () => ({
  getStudentPlanCode: vi.fn(async () => "premium"),
}));

function buildAdminMock() {
  return {
    from: (table: string) => {
      if (table === "student_parent_links") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => ({
                eq: () => ({
                  maybeSingle: async () => ({ data: { id: "link-1" }, error: null }),
                }),
              }),
            }),
          }),
        };
      }

      if (table === "parent_reports") {
        const filters: Record<string, string> = {};
        const chain: Record<string, unknown> = {};
        chain.select = () => chain;
        chain.eq = (column: string, value: string) => {
          filters[column] = value;
          return chain;
        };
        chain.maybeSingle = async () => {
          const key = `${filters.parent_id}:${filters.student_id}:${filters.week_start_date}`;
          const existing = parentReports.get(key);
          return { data: existing ? { id: existing.id } : null, error: null };
        };
        chain.insert = (row: {
          parent_id: string;
          student_id: string;
          week_start_date: string;
        }) => ({
          select: () => ({
            single: async () => {
              const key = `${row.parent_id}:${row.student_id}:${row.week_start_date}`;
              if (parentReports.has(key)) {
                return {
                  data: null,
                  error: { code: "23505", message: "duplicate key" },
                };
              }

              const created = { id: `report-${parentReports.size + 1}` };
              parentReports.set(key, created);
              return { data: created, error: null };
            },
          }),
        });
        return chain;
      }

      if (table === "study_time_logs") {
        return {
          select: () => ({
            eq: () => ({
              gte: () => ({
                lte: async () => ({ data: [{ duration_seconds: 3600 }], error: null }),
              }),
            }),
          }),
        };
      }

      if (table === "academic_health_scores") {
        return {
          select: () => ({
            eq: () => ({
              order: () => ({
                limit: () => ({
                  maybeSingle: async () => ({
                    data: { health_score: 70, predicted_grade: "B" },
                    error: null,
                  }),
                }),
              }),
            }),
          }),
        };
      }

      if (table === "topic_mastery") {
        return {
          select: () => ({
            eq: () => ({
              lt: () => ({
                order: () => ({
                  limit: async () => ({ data: [], error: null }),
                }),
              }),
            }),
          }),
        };
      }

      if (table === "student_profiles" || table === "parent_profiles") {
        return {
          select: () => ({
            eq: () => ({
              single: async () => ({
                data:
                  table === "student_profiles"
                    ? { full_name: "Student A", email: "student@example.com" }
                    : { email: "parent@example.com" },
                error: null,
              }),
            }),
          }),
        };
      }

      if (table === "weekly_reports") {
        return {
          insert: async () => ({ data: null, error: null }),
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
  };
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => buildAdminMock()),
}));

describe("PR-131 weekly report cron idempotency", () => {
  beforeEach(() => {
    parentReports.clear();
    emailSendCalls = 0;
    vi.resetModules();
  });

  it("double invocation for the same parent/student/week sends exactly one email", async () => {
    const { generateWeeklyReportForLink } = await import(
      "@/server/services/weeklyReportService"
    );

    const first = await generateWeeklyReportForLink({
      parentId: PARENT_ID,
      studentId: STUDENT_ID,
      weekStartDate: WEEK_START,
    });
    const second = await generateWeeklyReportForLink({
      parentId: PARENT_ID,
      studentId: STUDENT_ID,
      weekStartDate: WEEK_START,
    });

    expect(first.emailed).toBe(true);
    expect(first.skipped).toBeUndefined();
    expect(second.emailed).toBe(false);
    expect(second.skipped).toBe(true);
    expect(emailSendCalls).toBe(1);
    expect(parentReports.size).toBe(1);
  });
});
