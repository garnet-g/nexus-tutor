/**
 * @vitest-environment node
 *
 * PR-089: same-origin enforcement for cookie-authenticated mutations, plus the
 * shared admin mutation guard bundle (PR-049/PR-090).
 */
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("@/lib/rateLimit/durableLimiter", () => ({
  checkRateLimit: vi.fn(),
}));

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import {
  enforceSameOrigin,
  enforceAdminMutationGuards,
} from "@/lib/security/originCheck";

const SELF = "https://app.nexus.co";

function req(
  method: string,
  headers: Record<string, string>,
  url = `${SELF}/api/thing`,
): Request {
  return new Request(url, { method, headers });
}

const originalSiteUrl = process.env.NEXT_PUBLIC_SITE_URL;

beforeEach(() => {
  delete process.env.NEXT_PUBLIC_SITE_URL;
  vi.mocked(checkRateLimit).mockReset();
});

afterEach(() => {
  if (originalSiteUrl === undefined) {
    delete process.env.NEXT_PUBLIC_SITE_URL;
  } else {
    process.env.NEXT_PUBLIC_SITE_URL = originalSiteUrl;
  }
});

describe("enforceSameOrigin", () => {
  it("passes non-mutating methods regardless of origin", () => {
    expect(
      enforceSameOrigin(req("GET", { cookie: "s=1", origin: "https://evil.com" })),
    ).toBeNull();
  });

  it("passes cookieless mutations (no CSRF surface)", () => {
    expect(
      enforceSameOrigin(req("POST", { origin: "https://evil.com" })),
    ).toBeNull();
  });

  it("passes same-origin cookie mutations", () => {
    expect(
      enforceSameOrigin(req("POST", { cookie: "s=1", origin: SELF })),
    ).toBeNull();
  });

  it("rejects cross-origin cookie mutations with 403", () => {
    const res = enforceSameOrigin(
      req("POST", { cookie: "s=1", origin: "https://evil.com" }),
    );
    expect(res?.status).toBe(403);
  });

  it("rejects a malformed Origin header", () => {
    const res = enforceSameOrigin(
      req("POST", { cookie: "s=1", origin: "not-a-url" }),
    );
    expect(res?.status).toBe(403);
  });

  it("falls back to Sec-Fetch-Site when Origin is absent", () => {
    expect(
      enforceSameOrigin(
        req("POST", { cookie: "s=1", "sec-fetch-site": "same-origin" }),
      ),
    ).toBeNull();
    expect(
      enforceSameOrigin(
        req("POST", { cookie: "s=1", "sec-fetch-site": "cross-site" }),
      )?.status,
    ).toBe(403);
  });

  it("falls back to Referer host when Origin and Sec-Fetch-Site are absent", () => {
    expect(
      enforceSameOrigin(
        req("POST", { cookie: "s=1", referer: `${SELF}/dashboard` }),
      ),
    ).toBeNull();
    expect(
      enforceSameOrigin(
        req("POST", { cookie: "s=1", referer: "https://evil.com/x" }),
      )?.status,
    ).toBe(403);
  });

  it("passes cookie mutations from non-browser clients with no origin signals", () => {
    expect(enforceSameOrigin(req("POST", { cookie: "s=1" }))).toBeNull();
  });

  it("honours NEXT_PUBLIC_SITE_URL as an allowed host", () => {
    process.env.NEXT_PUBLIC_SITE_URL = "https://nexus.co";
    expect(
      enforceSameOrigin(
        req("POST", { cookie: "s=1", origin: "https://nexus.co" }),
      ),
    ).toBeNull();
  });
});

describe("enforceAdminMutationGuards", () => {
  it("short-circuits on a cross-origin mutation before hitting the limiter", async () => {
    const res = await enforceAdminMutationGuards(
      req("POST", { cookie: "s=1", origin: "https://evil.com" }),
      "admin-1",
    );
    expect(res?.status).toBe(403);
    expect(checkRateLimit).not.toHaveBeenCalled();
  });

  it("rejects with 429 when the admin burst limit is exceeded", async () => {
    vi.mocked(checkRateLimit).mockResolvedValue({
      allowed: false,
      retryAfterSeconds: 30,
    });

    const res = await enforceAdminMutationGuards(
      req("POST", { cookie: "s=1", origin: SELF }),
      "admin-1",
    );

    expect(res?.status).toBe(429);
    expect(checkRateLimit).toHaveBeenCalledWith(
      expect.objectContaining({ key: "admin:mutations:admin-1" }),
    );
  });

  it("passes when origin, size, and burst limit are all satisfied", async () => {
    vi.mocked(checkRateLimit).mockResolvedValue({
      allowed: true,
      retryAfterSeconds: 0,
    });

    const res = await enforceAdminMutationGuards(
      req("POST", { cookie: "s=1", origin: SELF }),
      "admin-1",
    );

    expect(res).toBeNull();
  });
});
