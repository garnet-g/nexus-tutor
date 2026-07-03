import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export interface RateLimitCheckInput {
  /** Stable bucket key, e.g. `nex:chat:${studentId}` or `waitlist:teacher:${ip}`. */
  key: string;
  /** Fixed window length in seconds. */
  windowSeconds: number;
  /** Maximum requests allowed per window. */
  max: number;
}

export interface RateLimitCheckResult {
  allowed: boolean;
  retryAfterSeconds: number;
}

/**
 * Durable, multi-instance rate limiter backed by the `consume_rate_limit`
 * Postgres function (fixed-window counters in `rate_limit_buckets`).
 *
 * Fail-open: if the RPC errors (network, migration missing), the request is
 * allowed and the failure is logged. Availability is preferred over strict
 * limiting for these abuse-control buckets; the daily quota RPCs remain the
 * hard backstop for spend.
 */
export async function checkRateLimit(
  input: RateLimitCheckInput,
): Promise<RateLimitCheckResult> {
  try {
    const supabase = createAdminClient();
    const { data, error } = await supabase.rpc("consume_rate_limit", {
      p_key: input.key,
      p_window_seconds: input.windowSeconds,
      p_max: input.max,
    });

    if (error) {
      throw new Error(error.message);
    }

    if (!data || typeof data !== "object") {
      throw new Error("consume_rate_limit returned an invalid result");
    }

    const result = data as Record<string, unknown>;

    return {
      allowed: result.allowed === true,
      retryAfterSeconds:
        typeof result.retry_after_seconds === "number"
          ? result.retry_after_seconds
          : 0,
    };
  } catch (error) {
    console.error("RATE_LIMIT_CHECK_FAILED", input.key, error);
    return { allowed: true, retryAfterSeconds: 0 };
  }
}
