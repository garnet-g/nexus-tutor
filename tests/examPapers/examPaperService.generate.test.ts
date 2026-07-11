import { beforeEach, describe, expect, it, vi } from "vitest";

const insertedRows: { sessions: any[]; questions: any[]; answerKeys: any[] } = {
  sessions: [],
  questions: [],
  answerKeys: [],
};

function makeFakeAdmin(templateRows: any[]) {
  return {
    from(table: string) {
      if (table === "exam_paper_templates") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => Promise.resolve({ data: templateRows }),
            }),
          }),
        };
      }
      if (table === "exam_paper_sessions") {
        return {
          select: () => ({
            eq: () => ({
              order: () => ({
                limit: () => Promise.resolve({ data: [] }),
              }),
            }),
          }),
          insert: (row: any) => ({
            select: () => ({
              single: () => {
                const id = `session-${insertedRows.sessions.length + 1}`;
                insertedRows.sessions.push({ id, ...row });
                return Promise.resolve({ data: { id }, error: null });
              },
            }),
          }),
        };
      }
      if (table === "exam_paper_session_questions") {
        return {
          select: () => ({
            in: () => Promise.resolve({ data: [] }),
          }),
          insert: (row: any) => ({
            select: () => ({
              single: () => {
                const id = `question-${insertedRows.questions.length + 1}`;
                insertedRows.questions.push({ id, ...row });
                return Promise.resolve({ data: { id }, error: null });
              },
            }),
          }),
        };
      }
      if (table === "exam_paper_session_answer_keys") {
        return {
          insert: (row: any) => {
            insertedRows.answerKeys.push(row);
            return Promise.resolve({ error: null });
          },
        };
      }
      throw new Error(`Unexpected table in fake admin client: ${table}`);
    },
  };
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(),
}));
vi.mock("@/server/services/nexUsageService", () => ({
  getStudentPlanCode: vi.fn(),
}));

import { createAdminClient } from "@/lib/supabase/admin";
import { getStudentPlanCode } from "@/server/services/nexUsageService";
import { generateExamPaperSession } from "@/server/services/examPaperService";
import type { StudentProfile } from "@/types/database";

const baseProfile: StudentProfile = {
  id: "student-1",
  user_id: "user-1",
  full_name: "Test Student",
  email: null,
  phone_number: null,
  curriculum: "KCSE",
  grade_level: "Form 1",
  school_name: null,
  target_grade: null,
  has_completed_diagnostic: true,
  metadata: {},
  learning_preferences: {},
  is_active: true,
  created_at: "2026-01-01T00:00:00.000Z",
  updated_at: "2026-01-01T00:00:00.000Z",
};

function buildTemplateRow(overrides: Record<string, unknown>) {
  return {
    id: `tmpl-${Math.random()}`,
    paper: 1,
    section: "I",
    form_level: 1,
    topic_id: "topic-1",
    marks: 3,
    body: {
      params: [],
      stem: "2 + 2",
      parts: [{ label: "a", prompt: "Compute.", marks: 3, answerType: "numeric", answerExpr: "2 + 2" }],
      markScheme: [{ code: "B1", text: "4" }],
    },
    ...overrides,
  };
}

function buildRichTemplateRows() {
  const rows: any[] = [];
  for (let i = 0; i < 10; i += 1) rows.push(buildTemplateRow({ id: `s1-4-${i}`, marks: 4, topic_id: `t-${i}` }));
  for (let i = 0; i < 10; i += 1) rows.push(buildTemplateRow({ id: `s1-2-${i}`, marks: 2, topic_id: `t-${i}` }));
  for (let i = 0; i < 20; i += 1) rows.push(buildTemplateRow({ id: `s1-3-${i}`, marks: 3, topic_id: `t-${i}` }));
  for (let i = 0; i < 10; i += 1) {
    rows.push(buildTemplateRow({ id: `s2-${i}`, section: "II", marks: 10, topic_id: `t2-${i}` }));
  }
  return rows;
}

describe("generateExamPaperSession", () => {
  beforeEach(() => {
    insertedRows.sessions = [];
    insertedRows.questions = [];
    insertedRows.answerKeys = [];
    vi.mocked(getStudentPlanCode).mockResolvedValue("premium");
  });

  it("returns cbc_unavailable for CBC students", async () => {
    vi.mocked(createAdminClient).mockReturnValue(makeFakeAdmin(buildRichTemplateRows()) as any);
    const result = await generateExamPaperSession(
      { ...baseProfile, curriculum: "CBC" },
      { paper: 1 },
    );
    expect(result.status).toBe("cbc_unavailable");
  });

  it("returns insufficient_bank when the template pool is too small", async () => {
    vi.mocked(createAdminClient).mockReturnValue(makeFakeAdmin([buildTemplateRow({})]) as any);
    const result = await generateExamPaperSession(baseProfile, { paper: 1 });
    expect(result.status).toBe("insufficient_bank");
  });

  it("generates a full paper (100 marks) for a premium student", async () => {
    vi.mocked(createAdminClient).mockReturnValue(makeFakeAdmin(buildRichTemplateRows()) as any);
    const result = await generateExamPaperSession(baseProfile, { paper: 1 });
    expect(result.status).toBe("generated");
    if (result.status === "generated") {
      expect(result.totalMarks).toBe(100);
      expect(result.isSample).toBe(false);
    }
    expect(insertedRows.questions).toHaveLength(24); // 16 Section I + 8 Section II
  });

  it("generates a 5-question sample for a free-plan student", async () => {
    vi.mocked(getStudentPlanCode).mockResolvedValue("free");
    vi.mocked(createAdminClient).mockReturnValue(makeFakeAdmin(buildRichTemplateRows()) as any);
    const result = await generateExamPaperSession(baseProfile, { paper: 1 });
    expect(result.status).toBe("generated");
    if (result.status === "generated") {
      expect(result.isSample).toBe(true);
    }
    expect(insertedRows.questions).toHaveLength(5);
  });
});
