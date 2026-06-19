import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

const migrationPath = join(
  process.cwd(),
  "supabase/migrations/20250615140000_mock_exam_tables.sql",
);
const migrationSql = readFileSync(migrationPath, "utf8");

function extractPolicyBlocks(sql: string): string[] {
  return sql
    .split(/CREATE POLICY /g)
    .slice(1)
    .map((block) => `CREATE POLICY ${block.split(";")[0]};`);
}

describe("mock exam RLS policies", () => {
  const policies = extractPolicyBlocks(migrationSql);

  it("enables RLS on mock exam and simulator tables", () => {
    expect(migrationSql).toContain("ALTER TABLE public.mock_exam_sessions ENABLE ROW LEVEL SECURITY");
    expect(migrationSql).toContain("ALTER TABLE public.mock_exam_questions ENABLE ROW LEVEL SECURITY");
    expect(migrationSql).toContain("ALTER TABLE public.mock_exam_results ENABLE ROW LEVEL SECURITY");
    expect(migrationSql).toContain("ALTER TABLE public.exam_simulator_sessions ENABLE ROW LEVEL SECURITY");
  });

  it("scopes student-owned sessions to auth_student_id", () => {
    const sessionPolicy = policies.find((policy) =>
      policy.includes("mock_exam_sessions_student"),
    );

    expect(sessionPolicy).toBeDefined();
    expect(sessionPolicy).toContain("student_id = public.auth_student_id()");
    expect(sessionPolicy).toContain("FOR ALL");
  });

  it("scopes mock exam questions through parent session ownership", () => {
    const questionPolicy = policies.find((policy) =>
      policy.includes("mock_exam_questions_student"),
    );

    expect(questionPolicy).toBeDefined();
    expect(questionPolicy).toContain("mock_exam_sessions mes");
    expect(questionPolicy).toContain("mes.student_id = public.auth_student_id()");
  });

  it("scopes results and simulator sessions to the owning student", () => {
    const resultsPolicy = policies.find((policy) =>
      policy.includes("mock_exam_results_student"),
    );
    const simulatorPolicy = policies.find((policy) =>
      policy.includes("exam_simulator_sessions_student"),
    );

    expect(resultsPolicy).toContain("student_id = public.auth_student_id()");
    expect(simulatorPolicy).toContain("student_id = public.auth_student_id()");
  });
});
