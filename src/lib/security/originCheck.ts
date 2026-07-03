import "server-only";

import { NextResponse } from "next/server";

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import {
  ADMIN_JSON_LIMIT_BYTES,
  checkContentLength,
} from "@/lib/security/bodySizeLimit";

const MUTATING_METHODS = new Set(["POST", "PUT", "PATCH", "DELETE"]);

/** Per-user burst ceiling shared by all admin mutation routes (PR-049). */
export const ADMIN_MUTATION_LIMIT_PER_MINUTE = 60;

function forbiddenResponse(): NextResponse {
  return NextResponse.json(
    {
      success: false,
      error: {
        code: "ORIGIN_FORBIDDEN",
        message: "Cross-origin request rejected.",
      },
    },
    { status: 403 },
  );
}

function collectAllowedHosts(request: Request): Set<string> {
  const allowedHosts = new Set<string>();

  try {
    allowedHosts.add(new URL(request.url).host);
  } catch {
    // Ignore malformed request URLs; NEXT_PUBLIC_SITE_URL still applies.
  }

  const siteUrl = process.env.NEXT_PUBLIC_SITE_URL;

  if (siteUrl) {
    try {
      allowedHosts.add(new URL(siteUrl).host);
    } catch {
      // Ignore malformed configuration; the request host remains authoritative.
    }
  }

  return allowedHosts;
}

/**
 * CSRF origin enforcement for cookie-authenticated mutations (PR-089).
 *
 * Applies to POST/PUT/PATCH/DELETE requests that carry cookies. Compares the
 * Origin header (falling back to Sec-Fetch-Site, then the Referer host)
 * against the request URL host and NEXT_PUBLIC_SITE_URL.
 *
 * Passes (returns null) for: same-origin requests, non-mutating methods
 * (incl. OPTIONS), cookieless requests, and non-browser clients that send no
 * origin signals at all.
 */
export function enforceSameOrigin(request: Request): NextResponse | null {
  if (!MUTATING_METHODS.has(request.method.toUpperCase())) {
    return null;
  }

  if (!request.headers.get("cookie")) {
    return null;
  }

  const allowedHosts = collectAllowedHosts(request);
  const origin = request.headers.get("origin");

  if (origin) {
    try {
      return allowedHosts.has(new URL(origin).host) ? null : forbiddenResponse();
    } catch {
      return forbiddenResponse();
    }
  }

  const secFetchSite = request.headers.get("sec-fetch-site");

  if (secFetchSite) {
    return secFetchSite === "same-origin" || secFetchSite === "none"
      ? null
      : forbiddenResponse();
  }

  const referer = request.headers.get("referer");

  if (referer) {
    try {
      return allowedHosts.has(new URL(referer).host)
        ? null
        : forbiddenResponse();
    } catch {
      return forbiddenResponse();
    }
  }

  // No Origin, Sec-Fetch-Site, or Referer: non-browser client. Cookie-bearing
  // programmatic clients are not CSRF-able (the attacker controls the client).
  return null;
}

/**
 * Shared guard bundle for admin mutation handlers (Amendment 3 / PR-049):
 * same-origin check, body-size ceiling (Content-Length), and a per-admin
 * burst limit of ADMIN_MUTATION_LIMIT_PER_MINUTE mutations per minute.
 *
 * Insert immediately after the route's auth check; returns a NextResponse to
 * short-circuit with, or null to continue.
 */
export async function enforceAdminMutationGuards(
  request: Request,
  userId: string,
  options?: { maxBytes?: number },
): Promise<NextResponse | null> {
  const originError = enforceSameOrigin(request);

  if (originError) {
    return originError;
  }

  const sizeError = checkContentLength(
    request,
    options?.maxBytes ?? ADMIN_JSON_LIMIT_BYTES,
  );

  if (sizeError) {
    return sizeError;
  }

  const limit = await checkRateLimit({
    key: `admin:mutations:${userId}`,
    windowSeconds: 60,
    max: ADMIN_MUTATION_LIMIT_PER_MINUTE,
  });

  if (!limit.allowed) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "RATE_LIMITED",
          message: "Too many admin requests. Please slow down.",
          details: { retryAfterSeconds: limit.retryAfterSeconds },
        },
      },
      { status: 429 },
    );
  }

  return null;
}
