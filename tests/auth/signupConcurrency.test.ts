/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

import { signupAction } from "@/server/actions/authActions";

const signUp = vi.fn();
const getUser = vi.fn();
const getSession = vi.fn();

const inviteState = {
  code: "",
  max_uses: 1,
  use_count: 0,
};

const redemptions = new Map<string, string>();
const profiles = new Map<string, { userId: string; email: string }>();
const authUsers = new Map<string, { email: string }>();

const rpc = vi.fn();
const from = vi.fn();
const createUser = vi.fn();
const deleteUser = vi.fn();
const getUserById = vi.fn();
const updateUserById = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: {
      signUp,
      getUser,
      getSession,
    },
  })),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    rpc,
    from,
    auth: {
      admin: {
        createUser,
        deleteUser,
        getUserById,
        updateUserById,
      },
    },
  })),
}));

vi.mock("next/navigation", () => ({
  redirect: vi.fn(() => {
    throw new Error("REDIRECT");
  }),
}));

const testUserIds: string[] = [];

beforeEach(() => {
  inviteState.use_count = 0;
  inviteState.code = `BETA-${Date.now().toString(36).toUpperCase()}`;
  redemptions.clear();
  profiles.clear();
  authUsers.clear();

  signUp.mockReset();
  getUser.mockReset();
  getSession.mockReset();
  rpc.mockReset();
  from.mockReset();
  createUser.mockReset();
  deleteUser.mockReset();
  getUserById.mockReset();
  updateUserById.mockReset();

  process.env.BETA_INVITE_REQUIRED = "true";

  from.mockImplementation((table: string) => {
    if (table === "beta_invites") {
      return {
        select: () => ({
          eq: (_column: string, value: string) => ({
            maybeSingle: async () => ({
              data:
                value === inviteState.code
                  ? {
                      id: "invite-1",
                      invite_code: inviteState.code,
                      max_uses: inviteState.max_uses,
                      use_count: inviteState.use_count,
                      is_active: true,
                      expires_at: null,
                      created_at: new Date().toISOString(),
                      updated_at: new Date().toISOString(),
                    }
                  : null,
              error: null,
            }),
            single: async () => ({
              data: {
                id: "invite-1",
                invite_code: inviteState.code,
                max_uses: inviteState.max_uses,
                use_count: inviteState.use_count,
                is_active: true,
                expires_at: null,
                created_at: new Date().toISOString(),
                updated_at: new Date().toISOString(),
              },
              error: null,
            }),
          }),
        }),
        delete: () => ({
          eq: async () => ({ error: null }),
        }),
        insert: async () => ({ error: null }),
      };
    }

    if (table === "beta_invite_redemptions") {
      return {
        delete: () => ({
          eq: async () => ({ error: null }),
        }),
        select: () => ({
          eq: () => ({
            async then() {
              return { count: redemptions.size };
            },
          }),
        }),
      };
    }

    if (table === "student_profiles") {
      const profileRow = {
        id: "profile-1",
        user_id: "",
        full_name: "",
        email: "",
        curriculum: "CBC",
        grade_level: "",
        has_completed_diagnostic: false,
        learning_preferences: {},
      };

      return {
        insert: (row: { user_id: string; email: string; full_name: string }) => {
          profiles.set(row.user_id, { userId: row.user_id, email: row.email });
          profileRow.user_id = row.user_id;
          profileRow.email = row.email;
          profileRow.full_name = row.full_name;

          return {
            select: () => ({
              single: async () => ({
                data: { ...profileRow },
                error: null,
              }),
            }),
          };
        },
        delete: () => ({
          eq: async (_column: string, userId: string) => {
            profiles.delete(userId);
            return { error: null };
          },
        }),
        select: () => ({
          in: async () => ({ count: profiles.size, data: null, error: null }),
        }),
      };
    }

    throw new Error(`Unexpected table ${table}`);
  });

  rpc.mockImplementation(async (name: string, args: { p_code: string; p_user_id: string }) => {
    if (name === "release_beta_invite") {
      if (redemptions.get(args.p_code) === args.p_user_id) {
        redemptions.delete(args.p_code);
        inviteState.use_count = Math.max(inviteState.use_count - 1, 0);
      }
      return { data: { ok: true }, error: null };
    }

    if (redemptions.get(args.p_code) === args.p_user_id) {
      return { data: { ok: true, reason: "already_reserved" }, error: null };
    }

    if (inviteState.use_count >= inviteState.max_uses) {
      return {
        data: { ok: false, reason: "This invite code has reached its use limit." },
        error: null,
      };
    }

    inviteState.use_count += 1;
    redemptions.set(args.p_code, args.p_user_id);
    return { data: { ok: true }, error: null };
  });

  signUp.mockImplementation(async ({ email }: { email: string }) => {
    const userId = `user-${authUsers.size + 1}`;
    authUsers.set(userId, { email });
    testUserIds.push(userId);
    return { data: { user: { id: userId, email, created_at: new Date().toISOString() } }, error: null };
  });

  createUser.mockImplementation(async ({ email }: { email: string }) => {
    const userId = `user-${authUsers.size + 1}`;
    authUsers.set(userId, { email });
    return { data: { user: { id: userId, email, created_at: new Date().toISOString() } }, error: null };
  });

  deleteUser.mockImplementation(async (userId: string) => {
    authUsers.delete(userId);
    return { error: null };
  });

  getUserById.mockImplementation(async (userId: string) => {
    const user = authUsers.get(userId);
    if (!user) {
      return { data: { user: null }, error: { message: "not found" } };
    }

    return {
      data: {
        user: {
          id: userId,
          email: user.email,
          created_at: new Date().toISOString(),
          app_metadata: { userRole: "student", sessionVersion: 1 },
        },
      },
      error: null,
    };
  });

  updateUserById.mockResolvedValue({ error: null });
  getUser.mockResolvedValue({ data: { user: null }, error: null });
  getSession.mockResolvedValue({ data: { session: null }, error: null });
});

describe("signup concurrency (mocked store)", () => {
  it("allows exactly one signup to reserve a single-use invite", async () => {
    const formA = new FormData();
    formA.set("email", `signup-a-${Date.now()}@test.local`);
    formA.set("password", "SignupTest1!");
    formA.set("fullName", "Signup A");
    formA.set("role", "student");
    formA.set("inviteCode", inviteState.code);

    const formB = new FormData();
    formB.set("email", `signup-b-${Date.now()}@test.local`);
    formB.set("password", "SignupTest1!");
    formB.set("fullName", "Signup B");
    formB.set("role", "student");
    formB.set("inviteCode", inviteState.code);

    const [resultA, resultB] = await Promise.all([
      signupAction({}, formA),
      signupAction({}, formB),
    ]);

    const outcomes = [resultA, resultB];
    const successes = outcomes.filter((outcome) => !outcome.error).length;
    const failures = outcomes.filter((outcome) => Boolean(outcome.error));

    expect(successes, "single-use invite must allow exactly one success").toBe(1);
    expect(failures.length).toBe(1);
    expect(
      failures.some((failure) =>
        (failure.error ?? "").toLowerCase().includes("invite"),
      ),
    ).toBe(true);

    expect(inviteState.use_count).toBe(1);
    expect(redemptions.size).toBe(1);
    expect(profiles.size).toBe(1);
    expect(authUsers.size).toBe(1);
  });
});
