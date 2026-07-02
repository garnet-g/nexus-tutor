/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

import { reserveBetaInvite, validateInviteCode } from "@/server/services/betaInviteService";

const inviteState = {
  invite_code: "BETA-UNIT01",
  max_uses: 1,
  use_count: 0,
  is_active: true,
  expires_at: null,
  id: "invite-1",
  created_at: new Date().toISOString(),
  updated_at: new Date().toISOString(),
};

const redemptions = new Set<string>();

const rpc = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    rpc,
    from,
  })),
}));

beforeEach(() => {
  inviteState.use_count = 0;
  redemptions.clear();
  rpc.mockReset();
  from.mockReset();

  from.mockImplementation((table: string) => {
    if (table !== "beta_invites") {
      throw new Error(`Unexpected table ${table}`);
    }

    return {
      select: () => ({
        eq: () => ({
          maybeSingle: async () => ({
            data: { ...inviteState },
            error: null,
          }),
          single: async () => ({
            data: { ...inviteState },
            error: null,
          }),
        }),
      }),
    };
  });

  rpc.mockImplementation(async (_name: string, args: { p_code: string; p_user_id: string }) => {
    const key = `${args.p_code}:${args.p_user_id}`;
    if (redemptions.has(key)) {
      return {
        data: { ok: true, reason: "already_reserved", invite_id: inviteState.id },
        error: null,
      };
    }

    if (inviteState.use_count >= inviteState.max_uses) {
      return {
        data: { ok: false, reason: "This invite code has reached its use limit." },
        error: null,
      };
    }

    inviteState.use_count += 1;
    redemptions.add(key);

    return {
      data: { ok: true, invite_id: inviteState.id },
      error: null,
    };
  });
});

describe("reserveBetaInvite", () => {
  it("returns an explicit reserved result without post-reserve capacity revalidation", async () => {
    const first = await reserveBetaInvite("BETA-UNIT01", "user-a");
    const second = await reserveBetaInvite("BETA-UNIT01", "user-b");

    expect(first.valid).toBe(true);
    if (first.valid) {
      expect(first.reserved).toBe(true);
      expect(first.invite.use_count).toBe(1);
    }
    expect(second).toEqual({
      valid: false,
      reason: "This invite code has reached its use limit.",
    });

    const postReserveValidate = await validateInviteCode("BETA-UNIT01");
    expect(postReserveValidate.valid).toBe(false);
    expect(rpc).toHaveBeenCalledTimes(1);
  });
});
