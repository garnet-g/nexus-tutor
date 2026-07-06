import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

const rlsMigrationPath = join(
  process.cwd(),
  "supabase/migrations/20250613120300_enable_rls.sql",
);
const experienceToolsMigrationPath = join(
  process.cwd(),
  "supabase/migrations/20260625060211_student_experience_tools.sql",
);
const rlsSql = readFileSync(rlsMigrationPath, "utf8");
const experienceToolsSql = readFileSync(experienceToolsMigrationPath, "utf8");

const STUDENT_MUTABLE_TABLES = [
  "student_profiles",
  "diagnostic_attempts",
  "practice_sessions",
  "practice_attempts",
  "study_plans",
  "study_tasks",
  "daily_goals",
  "nex_sessions",
  "nex_messages",
  "nex_recommendations",
] as const;

function extractPolicyBlocks(sql: string): string[] {
  return sql
    .split(/CREATE POLICY /g)
    .slice(1)
    .map((block) => `CREATE POLICY ${block.split(";")[0]};`);
}

describe("parent RLS access policies", () => {
  const policies = extractPolicyBlocks(rlsSql);

  it("defines parent SELECT policies for linked student data", () => {
    const parentSelectPolicies = policies.filter(
      (policy) =>
        policy.includes("_parent") &&
        policy.includes("FOR SELECT") &&
        policy.includes("student_parent_links"),
    );

    expect(parentSelectPolicies.length).toBeGreaterThanOrEqual(3);
  });

  it("does not grant parents INSERT, UPDATE, or DELETE on student-owned tables", () => {
    for (const table of STUDENT_MUTABLE_TABLES) {
      const parentMutations = policies.filter(
        (policy) =>
          policy.includes(`ON public.${table}`) &&
          policy.includes("_parent") &&
          /FOR (INSERT|UPDATE|DELETE|ALL)/.test(policy),
      );

      expect(parentMutations).toEqual([]);
    }
  });

  it("restricts student_parent_links to parent SELECT only", () => {
    const linkPolicies = policies.filter((policy) =>
      policy.includes("ON public.student_parent_links"),
    );

    expect(linkPolicies).toHaveLength(1);
    expect(linkPolicies[0]).toContain("FOR SELECT");
    expect(linkPolicies[0]).toContain("parent_id = public.auth_parent_id()");
    expect(linkPolicies[0]).not.toMatch(/FOR (INSERT|UPDATE|DELETE|ALL)/);
  });

  it("documents that parents cannot mutate student data in migration", () => {
    expect(rlsSql).toContain(
      "Parents cannot mutate student data (no INSERT/UPDATE on student tables for parents)",
    );
  });

  it("uses active link_status in parent read policies", () => {
    const parentLinkedPolicies = policies.filter(
      (policy) =>
        policy.includes("_parent") &&
        policy.includes("student_parent_links") &&
        policy.includes("link_status = 'active'"),
    );

    expect(parentLinkedPolicies.length).toBeGreaterThanOrEqual(2);
  });

  it("restricts parent weekly goal reads to parent_visible linked students", () => {
    expect(experienceToolsSql).toContain(
      "CREATE POLICY student_weekly_goals_parent_linked",
    );
    expect(experienceToolsSql).toContain("parent_visible = true");
    expect(experienceToolsSql).toContain("public.auth_parent_id()");
    expect(experienceToolsSql).toContain("link_status = 'active'");
  });
});
