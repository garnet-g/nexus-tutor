import { afterEach, describe, expect, it } from "vitest";

import { parseEnvSchema } from "@/lib/env/envSchema";
import { resetEnvCacheForTests } from "@/lib/env/providerModes";

const BASE_TEST_ENV = {
  APP_ENV: "test",
  NEX_PROVIDER_MODE: "mock",
  MPESA_PROVIDER_MODE: "mock",
  NOTIFICATIONS_PROVIDER_MODE: "mock",
  NEXT_PUBLIC_SUPABASE_URL: "https://example.supabase.co",
  NEXT_PUBLIC_SUPABASE_ANON_KEY: "anon-key",
  SUPABASE_SERVICE_ROLE_KEY: "service-role-key",
};

describe("envSchema", () => {
  afterEach(() => {
    resetEnvCacheForTests();
    delete process.env.APP_ENV;
    delete process.env.APP_ORIGIN;
    delete process.env.NEX_PROVIDER_MODE;
    delete process.env.MPESA_PROVIDER_MODE;
    delete process.env.NOTIFICATIONS_PROVIDER_MODE;
  });

  it("accepts explicit test fixture with mock provider modes", () => {
    const result = parseEnvSchema(BASE_TEST_ENV);
    expect(result.appEnv).toBe("test");
    expect(result.nexProviderMode).toBe("mock");
  });

  it("requires APP_ORIGIN for production", () => {
    expect(() =>
      parseEnvSchema({
        ...BASE_TEST_ENV,
        APP_ENV: "production",
        NEX_PROVIDER_MODE: "live",
        MPESA_PROVIDER_MODE: "sandbox",
        NOTIFICATIONS_PROVIDER_MODE: "live",
        GEMINI_API_KEY: "gemini-key",
        MPESA_CONSUMER_KEY: "ck",
        MPESA_CONSUMER_SECRET: "cs",
        MPESA_PASSKEY: "pk",
        MPESA_SHORTCODE: "174379",
        CELCOM_PARTNER_ID: "p",
        CELCOM_API_KEY: "k",
        CELCOM_SHORTCODE: "NEXUS",
        RESEND_API_KEY: "re_key",
      }),
    ).toThrow(/APP_ORIGIN/);
  });

  it("rejects production with mock nex mode", () => {
    expect(() =>
      parseEnvSchema({
        ...BASE_TEST_ENV,
        APP_ENV: "production",
        APP_ORIGIN: "https://app.nexus.co.ke",
        NEX_PROVIDER_MODE: "mock",
        MPESA_PROVIDER_MODE: "sandbox",
        NOTIFICATIONS_PROVIDER_MODE: "live",
      }),
    ).toThrow(/NEX_PROVIDER_MODE/);
  });
});
