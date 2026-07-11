/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const studentId = "11111111-1111-4111-8111-111111111111";
const otherStudentId = "22222222-2222-4222-8222-222222222222";
const topicId = "33333333-3333-4333-8333-333333333333";
const questionId = "44444444-4444-4444-8444-444444444444";
const attemptId = "55555555-5555-4555-8555-555555555555";
const sessionId = "66666666-6666-4666-8666-666666666666";
const lessonId = "77777777-7777-4777-8777-777777777777";
const subjectId = "88888888-8888-4888-8888-888888888888";

type QueryResult = { data: unknown; error: null };

const tables = new Map<string, unknown[]>();

function chainable(result: QueryResult) {
  const api: Record<string, unknown> = {
    select: () => api,
    eq: () => api,
    maybeSingle: async () => result,
    single: async () => result,
  };
  return api;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      const rows = tables.get(table) ?? [];
      return {
        select: (_cols?: string) => ({
          eq: (column: string, value: string) => {
            const matched = rows.filter(
              (row) =>
                row &&
                typeof row === "object" &&
                (row as Record<string, unknown>)[column] === value,
            );
            return {
              eq: (column2: string, value2: string) => {
                const nested = matched.filter(
                  (row) =>
                    row &&
                    typeof row === "object" &&
                    (row as Record<string, unknown>)[column2] === value2,
                );
                return {
                  maybeSingle: async () => ({
                    data: nested[0] ?? null,
                    error: null,
                  }),
                };
              },
              maybeSingle: async () => ({
                data: matched[0] ?? null,
                error: null,
              }),
            };
          },
          maybeSingle: async () => ({ data: rows[0] ?? null, error: null }),
        }),
      };
    },
  })),
}));

describe("nexWorkflowContextSchema", () => {
  it("accepts a valid lesson context", async () => {
    const { nexWorkflowContextSchema } = await import(
      "@/schemas/nexWorkflowContextSchemas"
    );

    const result = nexWorkflowContextSchema.safeParse({
      version: 1,
      source: "lesson",
      label: "Quadratic equations · Lesson 2",
      subjectId,
      topicId,
      lessonId,
      allowedActions: ["explain", "simplify"],
      protectedAssessment: false,
    });

    expect(result.success).toBe(true);
  });

  it("accepts a valid practice context", async () => {
    const { nexWorkflowContextSchema } = await import(
      "@/schemas/nexWorkflowContextSchemas"
    );

    const result = nexWorkflowContextSchema.safeParse({
      version: 1,
      source: "practice",
      label: "Quadratic equations · Question 4",
      topicId,
      questionId,
      attemptId,
      allowedActions: ["hint", "review"],
      protectedAssessment: false,
    });

    expect(result.success).toBe(true);
  });

  it("rejects unknown keys", async () => {
    const { nexWorkflowContextSchema } = await import(
      "@/schemas/nexWorkflowContextSchemas"
    );

    const result = nexWorkflowContextSchema.safeParse({
      version: 1,
      source: "practice",
      label: "Practice",
      questionId,
      allowedActions: ["hint"],
      protectedAssessment: false,
      answerKey: "B",
    });

    expect(result.success).toBe(false);
  });

  it("rejects client-supplied protected answer material", async () => {
    const { nexWorkflowContextSchema } = await import(
      "@/schemas/nexWorkflowContextSchemas"
    );

    const result = nexWorkflowContextSchema.safeParse({
      version: 1,
      source: "practice",
      questionId: crypto.randomUUID(),
      answerKey: "B",
    });

    expect(result.success).toBe(false);
  });

  it("rejects invalid UUIDs", async () => {
    const { nexWorkflowContextSchema } = await import(
      "@/schemas/nexWorkflowContextSchemas"
    );

    const result = nexWorkflowContextSchema.safeParse({
      version: 1,
      source: "lesson",
      label: "Lesson",
      topicId: "not-a-uuid",
      allowedActions: ["explain"],
      protectedAssessment: false,
    });

    expect(result.success).toBe(false);
  });

  it("rejects labels longer than 120 characters", async () => {
    const { nexWorkflowContextSchema } = await import(
      "@/schemas/nexWorkflowContextSchemas"
    );

    const result = nexWorkflowContextSchema.safeParse({
      version: 1,
      source: "global",
      label: "x".repeat(121),
      allowedActions: [],
      protectedAssessment: false,
    });

    expect(result.success).toBe(false);
  });
});

describe("resolveNexWorkflowContext", () => {
  beforeEach(() => {
    tables.clear();
    vi.resetModules();
  });

  it("rejects protected assessment context", async () => {
    const { resolveNexWorkflowContext } = await import(
      "@/server/services/nexWorkflowContextService"
    );

    const result = await resolveNexWorkflowContext({
      studentId,
      context: {
        version: 1,
        source: "exam_review",
        label: "Mock exam in progress",
        sessionId,
        allowedActions: ["hint"],
        protectedAssessment: true,
      },
    });

    expect(result).toEqual({
      status: "rejected",
      reason: "protected_assessment",
    });
  });

  it("drops optional context when ownership mismatches", async () => {
    tables.set("practice_attempts", [
      {
        id: attemptId,
        practice_question_id: questionId,
        practice_session_id: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
      },
    ]);
    tables.set("practice_sessions", [
      {
        id: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
        student_id: otherStudentId,
        topic_id: topicId,
      },
    ]);

    const { resolveNexWorkflowContext } = await import(
      "@/server/services/nexWorkflowContextService"
    );

    const result = await resolveNexWorkflowContext({
      studentId,
      context: {
        version: 1,
        source: "practice",
        label: "Someone else's attempt",
        questionId,
        attemptId,
        allowedActions: ["hint"],
        protectedAssessment: false,
      },
    });

    expect(result).toEqual({
      status: "dropped",
      reason: "not_owned",
    });
  });

  it("drops optional context when identifiers are missing", async () => {
    tables.set("topics", []);

    const { resolveNexWorkflowContext } = await import(
      "@/server/services/nexWorkflowContextService"
    );

    const result = await resolveNexWorkflowContext({
      studentId,
      context: {
        version: 1,
        source: "lesson",
        label: "Missing topic",
        topicId,
        allowedActions: ["explain"],
        protectedAssessment: false,
      },
    });

    expect(result).toEqual({
      status: "dropped",
      reason: "not_found",
    });
  });

  it("resolves owned practice context with authoritative label", async () => {
    tables.set("topics", [{ id: topicId, title: "Quadratic Equations", subject_id: subjectId }]);
    tables.set("practice_questions", [
      { id: questionId, topic_id: topicId, question_text: "Solve x^2 = 4" },
    ]);
    tables.set("practice_attempts", [
      {
        id: attemptId,
        practice_question_id: questionId,
        practice_session_id: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
      },
    ]);
    tables.set("practice_sessions", [
      {
        id: "aaaaaaaa-aaaa-4aaa-8aaa-aaaaaaaaaaaa",
        student_id: studentId,
        topic_id: topicId,
      },
    ]);

    const { resolveNexWorkflowContext } = await import(
      "@/server/services/nexWorkflowContextService"
    );

    const result = await resolveNexWorkflowContext({
      studentId,
      context: {
        version: 1,
        source: "practice",
        label: "Client label ignored",
        topicId,
        questionId,
        attemptId,
        allowedActions: ["hint", "review"],
        protectedAssessment: false,
      },
    });

    expect(result.status).toBe("resolved");
    if (result.status === "resolved") {
      expect(result.context.label).toContain("Quadratic Equations");
      expect(result.context.topicId).toBe(topicId);
      expect(result.context.questionId).toBe(questionId);
      expect(result.context.allowedActions).toEqual(["hint", "review"]);
    }
  });

  it("returns none when context is absent", async () => {
    const { resolveNexWorkflowContext } = await import(
      "@/server/services/nexWorkflowContextService"
    );

    const result = await resolveNexWorkflowContext({
      studentId,
      context: null,
    });

    expect(result).toEqual({ status: "none" });
  });
});
