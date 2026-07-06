import { describe, expect, it } from "vitest";

import {
  buildBaseSecurityHeaders,
  buildContentSecurityPolicy,
  buildNexMultimediaHeaders,
  buildNexPrivateHeaders,
  buildPermissionsPolicy,
  buildPrivateCacheHeaders,
  PRIVATE_CACHE_CONTROL,
} from "@/lib/security/securityHeaders";

describe("security headers", () => {
  it("builds CSP with default-src self and frame-ancestors none", () => {
    const csp = buildContentSecurityPolicy();
    expect(csp).toContain("default-src 'self'");
    expect(csp).toContain("frame-ancestors 'none'");
    expect(csp).toContain("object-src 'none'");
  });

  it("includes frame protection headers on base set", () => {
    const headers = buildBaseSecurityHeaders();
    const keys = headers.map((header) => header.key);
    expect(keys).toContain("Content-Security-Policy");
    expect(keys).toContain("X-Frame-Options");
    expect(headers.find((h) => h.key === "X-Frame-Options")?.value).toBe("DENY");
  });

  it("sets nosniff and referrer policy", () => {
    const headers = buildBaseSecurityHeaders();
    expect(headers.find((h) => h.key === "X-Content-Type-Options")?.value).toBe(
      "nosniff",
    );
    expect(headers.find((h) => h.key === "Referrer-Policy")?.value).toBe(
      "strict-origin-when-cross-origin",
    );
  });

  it("denies camera/mic by default and allows them only on Nex routes", () => {
    expect(buildPermissionsPolicy(false)).toContain("camera=()");
    expect(buildPermissionsPolicy(false)).toContain("microphone=()");
    expect(buildPermissionsPolicy(true)).toContain("camera=(self)");
    expect(buildPermissionsPolicy(true)).toContain("microphone=(self)");
  });

  it("applies multimedia permissions only on Nex header block", () => {
    const base = buildBaseSecurityHeaders().find((h) => h.key === "Permissions-Policy")
      ?.value;
    const nex = buildNexMultimediaHeaders().find((h) => h.key === "Permissions-Policy")
      ?.value;
    expect(base).toContain("camera=()");
    expect(nex).toContain("camera=(self)");
  });

  it("combines Nex multimedia with private cache for authenticated Nex routes", () => {
    const headers = buildNexPrivateHeaders();
    expect(headers.find((h) => h.key === "Cache-Control")?.value).toBe(
      PRIVATE_CACHE_CONTROL,
    );
    expect(headers.find((h) => h.key === "Permissions-Policy")?.value).toContain(
      "camera=(self)",
    );
  });

  it("uses private no-store cache control for authenticated routes", () => {
    const cache = buildPrivateCacheHeaders();
    expect(cache[0]?.value).toBe("private, no-store, max-age=0");
  });

  it("adds HSTS only in staging/production HTTPS contexts", () => {
    const original = process.env.APP_ENV;
    process.env.APP_ENV = "production";
    const prodHeaders = buildBaseSecurityHeaders();
    expect(prodHeaders.some((h) => h.key === "Strict-Transport-Security")).toBe(true);

    process.env.APP_ENV = "development";
    const devHeaders = buildBaseSecurityHeaders();
    expect(devHeaders.some((h) => h.key === "Strict-Transport-Security")).toBe(false);
    process.env.APP_ENV = original;
  });
});
