/**
 * @vitest-environment node
 *
 * PR-032: Supabase insert `{ error }` must surface as audit failure.
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const insert = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: vi.fn(() => ({ insert })),
  })),
}));

import {
  AdminAuditWriteError,
  recordAdminAudit,
} from "@/server/services/adminAuditService";

describe("recordAdminAudit — Supabase error handling", () => {
  beforeEach(() => {
    insert.mockReset();
  });

  it("returns ok:false when Supabase returns an error object without throwing", async () => {
    insert.mockResolvedValue({ error: { message: "permission denied" } });

    const result = await recordAdminAudit({
      actorUserId: "actor-1",
      actorRole: "super_admin",
      action: "content.generate",
      targetType: "content",
      targetId: "target-1",
    });

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.error).toContain("permission denied");
    }
  });

  it("throws AdminAuditWriteError in fail-closed mode", async () => {
    insert.mockResolvedValue({ error: { message: "disk full" } });

    await expect(
      recordAdminAudit(
        {
          actorUserId: "actor-1",
          actorRole: "super_admin",
          action: "admin_role.assign",
        },
        { failClosed: true },
      ),
    ).rejects.toBeInstanceOf(AdminAuditWriteError);
  });
});
