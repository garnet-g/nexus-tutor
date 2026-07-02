/**
 * @vitest-environment node
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";

import { describe, expect, it } from "vitest";

const migrationPath = join(
  process.cwd(),
  "supabase/migrations/20260701100000_beta_invite_reservation.sql",
);

describe("beta invite migration SQL contract", () => {
  const sql = readFileSync(migrationPath, "utf8");

  it("revokes execute from PUBLIC, anon, and authenticated on RPCs", () => {
    for (const functionName of [
      "reserve_beta_invite",
      "release_beta_invite",
      "is_auth_session_active",
    ]) {
      expect(sql).toContain(
        `REVOKE ALL ON FUNCTION public.${functionName}`,
      );
      expect(sql).toContain("FROM PUBLIC");
      expect(sql).toContain("FROM anon");
      expect(sql).toContain("FROM authenticated");
    }
  });

  it("grants execute to service_role on RPCs", () => {
    for (const functionName of [
      "reserve_beta_invite",
      "release_beta_invite",
      "is_auth_session_active",
    ]) {
      expect(sql).toContain(
        `GRANT EXECUTE ON FUNCTION public.${functionName}`,
      );
      expect(sql).toContain("TO service_role");
    }
  });

  it("uses empty search_path and fully qualified objects", () => {
    expect(sql).toContain("SET search_path = ''");
    expect(sql).toContain("FROM public.beta_invites");
    expect(sql).toContain("FROM public.beta_invite_redemptions");
    expect(sql).toContain("FROM auth.sessions AS s");
  });
});
