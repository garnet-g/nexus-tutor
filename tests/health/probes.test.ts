import { afterEach, describe, expect, it } from "vitest";

import { buildProviderProbes } from "@/lib/health/probes";

describe("health probes", () => {
  afterEach(() => {
    delete process.env.APP_ENV;
    delete process.env.NEX_PROVIDER_MODE;
    delete process.env.MPESA_PROVIDER_MODE;
    delete process.env.NOTIFICATIONS_PROVIDER_MODE;
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;
    delete process.env.MPESA_CONSUMER_KEY;
    delete process.env.CELCOM_API_KEY;
    delete process.env.RESEND_API_KEY;
  });

  it("includes database, providers, cron, and migrations probes", () => {
    process.env.APP_ENV = "test";
    process.env.NEX_PROVIDER_MODE = "mock";

    const probes = buildProviderProbes();
    const ids = probes.map((probe) => probe.id);

    expect(ids).toEqual(
      expect.arrayContaining([
        "database",
        "nex_ai",
        "mpesa",
        "notifications",
        "cron",
        "migrations",
      ]),
    );
  });

  it("marks Nex misconfigured in production live mode without keys", () => {
    process.env.APP_ENV = "production";
    process.env.NEX_PROVIDER_MODE = "live";

    const probes = buildProviderProbes();
    const nex = probes.find((probe) => probe.id === "nex_ai");

    expect(nex?.status).toBe("misconfigured");
    expect(nex?.detail).not.toMatch(/gemini|openai/i);
    expect(nex?.detail).not.toContain("key");
  });

  it("marks Nex configured in test mock mode", () => {
    process.env.APP_ENV = "test";
    process.env.NEX_PROVIDER_MODE = "mock";

    const probes = buildProviderProbes();
    const nex = probes.find((probe) => probe.id === "nex_ai");

    expect(nex?.status).toBe("configured");
    expect(nex?.detail).toContain("mock");
  });

  it("never includes secret values in probe output", () => {
    process.env.APP_ENV = "production";
    process.env.NEX_PROVIDER_MODE = "live";
    process.env.GEMINI_API_KEY = "super-secret-gemini-value";
    process.env.MPESA_PROVIDER_MODE = "sandbox";
    process.env.MPESA_CONSUMER_KEY = "mpesa-secret-key";
    process.env.NOTIFICATIONS_PROVIDER_MODE = "live";
    process.env.RESEND_API_KEY = "re_secret";

    const probes = buildProviderProbes();
    const serialized = JSON.stringify(probes);

    expect(serialized).not.toContain("super-secret-gemini-value");
    expect(serialized).not.toContain("mpesa-secret-key");
    expect(serialized).not.toContain("re_secret");
  });
});
