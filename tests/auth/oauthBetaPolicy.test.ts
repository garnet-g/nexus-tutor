/**
 * @vitest-environment node
 */
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { GET as authCallbackGet } from "@/app/auth/callback/route";
import { signInWithGoogleAction } from "@/server/actions/authActions";

const signInWithOAuth = vi.fn();
const exchangeCodeForSession = vi.fn();
const getUser = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: {
      signInWithOAuth,
      exchangeCodeForSession,
      getUser,
    },
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      maybeSingle: vi.fn().mockResolvedValue({ data: null }),
    })),
  })),
}));

vi.mock("@supabase/ssr", () => ({
  createServerClient: vi.fn(() => ({
    auth: {
      exchangeCodeForSession,
      getUser,
    },
    from: vi.fn(() => ({
      select: vi.fn().mockReturnThis(),
      eq: vi.fn().mockReturnThis(),
      maybeSingle: vi.fn().mockResolvedValue({ data: null }),
    })),
  })),
}));

vi.mock("next/headers", () => ({
  cookies: vi.fn(async () => ({
    getAll: () => [],
    set: vi.fn(),
  })),
}));

vi.mock("@/server/services/authService", () => ({
  setUserRole: vi.fn(),
  createStudentProfile: vi.fn(),
  createParentProfile: vi.fn(),
  getPostAuthRedirectPath: vi.fn(() => "/onboarding"),
}));

vi.mock("@/server/services/betaInviteService", () => ({
  isBetaInviteRequired: vi.fn(() => true),
  validateInviteCode: vi.fn(async (code: string) =>
    code === "BETA-VALID1"
      ? { valid: true, invite: { invite_code: code } }
      : { valid: false, reason: "Invalid invite code." },
  ),
  reserveBetaInvite: vi.fn(async (code: string) =>
    code === "BETA-VALID1"
      ? { valid: true, reserved: true, invite: { invite_code: code } }
      : { valid: false, reason: "Invalid invite code." },
  ),
}));

vi.mock("@/server/services/signupCompensation", () => ({
  rollbackFailedSignup: vi.fn(),
}));

vi.mock("next/navigation", () => ({
  redirect: vi.fn((url: string) => {
    throw new Error(`REDIRECT:${url}`);
  }),
}));

const originalBetaFlag = process.env.BETA_INVITE_REQUIRED;

beforeEach(() => {
  process.env.BETA_INVITE_REQUIRED = "true";
  signInWithOAuth.mockReset();
  exchangeCodeForSession.mockReset();
  getUser.mockReset();
});

afterEach(() => {
  process.env.BETA_INVITE_REQUIRED = originalBetaFlag;
  vi.clearAllMocks();
});

describe("oauth beta policy", () => {
  it("blocks Google sign-in without invite when beta is required", async () => {
    const result = await signInWithGoogleAction("student");

    expect(result).toEqual({
      error: "A beta invite code is required to sign up.",
    });
    expect(signInWithOAuth).not.toHaveBeenCalled();
  });

  it("includes invite code in OAuth redirect when beta is required", async () => {
    signInWithOAuth.mockResolvedValue({ data: { url: "https://oauth.test" }, error: null });

    await expect(signInWithGoogleAction("student", "BETA-VALID1")).rejects.toThrow(
      "REDIRECT:https://oauth.test",
    );

    expect(signInWithOAuth).toHaveBeenCalledWith(
      expect.objectContaining({
        options: expect.objectContaining({
          redirectTo: expect.stringContaining("invite=BETA-VALID1"),
        }),
      }),
    );
  });

  it("redirects OAuth callback without invite back to signup", async () => {
    exchangeCodeForSession.mockResolvedValue({ error: null });
    getUser.mockResolvedValue({
      data: {
        user: {
          id: "oauth-user",
          email: "oauth@test.local",
          app_metadata: {},
          user_metadata: {},
        },
      },
      error: null,
    });

    const response = await authCallbackGet(
      new Request("http://localhost:3000/auth/callback?code=abc&role=student"),
    );

    expect(response.headers.get("location")).toContain("/signup?error=invite_required");
  });
});
