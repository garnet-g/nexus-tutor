import { afterEach, describe, expect, it, vi } from "vitest";

import {
  DEFAULT_PROBE_TIMEOUT_MS,
  runProbeWithTimeout,
} from "@/lib/health/probeTimeout";

describe("runProbeWithTimeout", () => {
  afterEach(() => {
    vi.useRealTimers();
  });

  it("returns probe value when completed within timeout", async () => {
    const result = await runProbeWithTimeout("fast", 500, async () => "ok");
    expect(result).toEqual({ ok: true, value: "ok" });
  });

  it("returns timeout error when probe exceeds budget", async () => {
    vi.useFakeTimers();

    const pending = runProbeWithTimeout(
      "slow",
      DEFAULT_PROBE_TIMEOUT_MS,
      async () => new Promise((resolve) => setTimeout(() => resolve(true), 10_000)),
    );

    await vi.advanceTimersByTimeAsync(DEFAULT_PROBE_TIMEOUT_MS + 10);
    const result = await pending;

    expect(result.ok).toBe(false);
    if (!result.ok) {
      expect(result.error).toContain("slow timed out");
    }
  });
});
