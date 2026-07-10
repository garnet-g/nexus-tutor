import { beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("@/lib/supabase/admin", () => ({ createAdminClient: vi.fn() }));
vi.mock("@/server/services/studyPlanService", () => ({ generateStudyPlanForStudent: vi.fn() }));

import { createAdminClient } from "@/lib/supabase/admin";
import { generateStudyPlanForStudent } from "@/server/services/studyPlanService";
import { submitExamPaperFinalAnswers } from "@/server/services/examPaperService";
import type { StudentProfile } from "@/types/database";

const profile: StudentProfile = {
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

function makeFakeAdmin() {
  const upserts: any[] = [];
  const inserts: Record<string, any[]> = { academic_health_scores: [], exam_paper_answers: [] };
  const updates: any[] = [];

  return {
    upserts,
    inserts,
    updates,
    from(table: string) {
      if (table === "exam_paper_sessions") {
        return {
          select: () => ({
            eq: () => ({
              eq: () => ({
                maybeSingle: () =>
                  Promise.resolve({ data: { id: "s1", status: "in_progress", total_marks: 5 } }),
              }),
            }),
          }),
          update: (payload: any) => {
            updates.push(payload);
            return { eq: () => Promise.resolve({ data: null, error: null }) };
          },
        };
      }
      if (table === "exam_paper_session_questions") {
        return {
          select: () => ({
            eq: () => ({
              eq: () =>
                Promise.resolve({
                  data: [{ id: "q1", topic_id: "topic-angles" }],
                }),
            }),
          }),
        };
      }
      if (table === "exam_paper_session_answer_keys") {
        return {
          select: () => ({
            in: () =>
              Promise.resolve({
                data: [
                  {
                    session_question_id: "q1",
                    answer_key: [{ label: "a", computedAnswer: "80", tolerance: 0, marks: 3 }],
                  },
                ],
              }),
          }),
        };
      }
      if (table === "exam_paper_answers") {
        return {
          upsert: (row: any) => {
            upserts.push(row);
            return Promise.resolve({ data: null, error: null });
          },
        };
      }
      if (table === "topic_mastery") {
        return {
          select: () => ({
            eq: () => ({
              in: () => Promise.resolve({ data: [] }),
            }),
          }),
          upsert: (row: any) => {
            upserts.push(row);
            return Promise.resolve({ data: null, error: null });
          },
        };
      }
      if (table === "subjects") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: () => Promise.resolve({ data: { id: "subject-math" } }),
            }),
          }),
        };
      }
      if (table === "diagnostic_results") {
        return {
          select: () => ({
            eq: () => ({
              order: () => ({
                limit: () => ({
                  maybeSingle: () => Promise.resolve({ data: { health_score: 50 } }),
                }),
              }),
            }),
          }),
        };
      }
      if (table === "academic_health_scores") {
        return {
          insert: (row: any) => {
            inserts.academic_health_scores.push(row);
            return Promise.resolve({ data: null, error: null });
          },
        };
      }
      throw new Error(`Unexpected table: ${table}`);
    },
  };
}

describe("submitExamPaperFinalAnswers", () => {
  let admin: ReturnType<typeof makeFakeAdmin>;

  beforeEach(() => {
    admin = makeFakeAdmin();
    vi.mocked(createAdminClient).mockReturnValue(admin as any);
    vi.mocked(generateStudyPlanForStudent).mockResolvedValue(undefined as any);
  });

  it("auto-marks answers, updates mastery, and returns both grade views", async () => {
    const result = await submitExamPaperFinalAnswers("s1", profile, [
      { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "80" },
    ]);

    expect(result.verifiedMarks).toBe(3);
    expect(result.scorePercentage).toBe(60); // 3 / 5
    expect(typeof result.attemptPredictedGrade).toBe("string");
    expect(typeof result.rollingPredictedGrade).toBe("string");
    expect(admin.inserts.academic_health_scores).toHaveLength(1);
    expect(generateStudyPlanForStudent).toHaveBeenCalledWith(profile, {
      planType: "daily",
      dailyGoalMinutes: 20,
    });
  });

  it("only feeds mastery updates from auto-marked (verified) correctness", async () => {
    await submitExamPaperFinalAnswers("s1", profile, [
      { sessionQuestionId: "q1", partLabel: "a", studentAnswer: "wrong" },
    ]);
    const masteryUpsert = admin.upserts.find((row) => "mastery_percentage" in row);
    expect(masteryUpsert).toBeDefined();
  });
});
