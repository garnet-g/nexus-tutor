import { afterEach, describe, expect, it } from "vitest";

import { ConfigurationError, createMockAdapterMetadata, resetEnvCacheForTests } from "@/lib/env/providerModes";
import { callNexModel } from "@/lib/nex/callNexModel";
import { extractImageText } from "@/lib/nex/extractImageText";
import { transcribeVoiceAudio } from "@/lib/nex/voiceTranscribe";
import { synthesizeVoiceResponse } from "@/lib/nex/voiceSynthesize";
import { initiateStkPush } from "@/lib/mpesa/mpesaClient";
import { sendCelcomSms } from "@/lib/notifications/celcomClient";
import { sendResendEmail } from "@/lib/notifications/resendClient";

const PRODUCTION_BASE = {
  APP_ENV: "production",
  APP_ORIGIN: "https://app.nexus.co.ke",
  NEX_PROVIDER_MODE: "live",
  MPESA_PROVIDER_MODE: "sandbox",
  NOTIFICATIONS_PROVIDER_MODE: "live",
  NEXT_PUBLIC_SUPABASE_URL: "https://example.supabase.co",
  NEXT_PUBLIC_SUPABASE_ANON_KEY: "anon-key",
  SUPABASE_SERVICE_ROLE_KEY: "service-role-key",
};

function applyEnv(values: Record<string, string>) {
  for (const [key, value] of Object.entries(values)) {
    process.env[key] = value;
  }
}

function clearProviderEnv() {
  const keys = [
    "APP_ENV",
    "APP_ORIGIN",
    "NEX_PROVIDER_MODE",
    "MPESA_PROVIDER_MODE",
    "NOTIFICATIONS_PROVIDER_MODE",
    "GEMINI_API_KEY",
    "OPENAI_API_KEY",
    "MPESA_CONSUMER_KEY",
    "MPESA_CONSUMER_SECRET",
    "MPESA_PASSKEY",
    "MPESA_SHORTCODE",
    "CELCOM_PARTNER_ID",
    "CELCOM_API_KEY",
    "CELCOM_SHORTCODE",
    "RESEND_API_KEY",
    "NOTIFICATIONS_MOCK",
    "NEX_MOCK_AI",
  ];
  for (const key of keys) {
    delete process.env[key];
  }
}

describe("production fail-closed", () => {
  afterEach(() => {
    clearProviderEnv();
    resetEnvCacheForTests();
  });

  it("rejects Nex text generation without AI keys in production", async () => {
    applyEnv(PRODUCTION_BASE);
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    await expect(
      callNexModel({
        systemPrompt: "You are Nex.",
        messages: [{ role: "student", content: "Explain fractions." }],
      }),
    ).rejects.toBeInstanceOf(ConfigurationError);
  });

  it("rejects M-Pesa STK push without Daraja credentials in production", async () => {
    applyEnv(PRODUCTION_BASE);

    await expect(
      initiateStkPush({
        phoneNumber: "0712345678",
        amountKes: 100,
        accountReference: "TEST",
        transactionDesc: "Plan",
      }),
    ).rejects.toBeInstanceOf(ConfigurationError);
  });

  it("does not mock-deliver Celcom SMS in production when unconfigured", async () => {
    applyEnv(PRODUCTION_BASE);

    await expect(
      sendCelcomSms({
        phoneNumber: "254712345678",
        smsBody: "Hello",
      }),
    ).rejects.toBeInstanceOf(ConfigurationError);
  });

  it("does not mock-deliver Resend email in production when unconfigured", async () => {
    applyEnv(PRODUCTION_BASE);

    await expect(
      sendResendEmail({
        recipientEmail: "student@example.com",
        emailSubject: "Test",
        emailBody: "<p>Hi</p>",
      }),
    ).rejects.toBeInstanceOf(ConfigurationError);
  });

  it("rejects camera OCR without vision credentials in production", async () => {
    applyEnv(PRODUCTION_BASE);
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    await expect(
      extractImageText({
        imageBytes: new Uint8Array([1, 2, 3]),
        mimeType: "image/png",
      }),
    ).rejects.toBeInstanceOf(ConfigurationError);
  });

  it("rejects voice transcription without AI keys in production", async () => {
    applyEnv(PRODUCTION_BASE);
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    await expect(
      transcribeVoiceAudio({
        audioBytes: new Uint8Array([1, 2, 3]),
        mimeType: "audio/webm",
      }),
    ).rejects.toBeInstanceOf(ConfigurationError);
  });

  it("rejects voice synthesis without AI keys in production", async () => {
    applyEnv(PRODUCTION_BASE);
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    await expect(
      synthesizeVoiceResponse({ text: "Explain fractions clearly." }),
    ).rejects.toBeInstanceOf(ConfigurationError);
  });

  it("allows explicit mock adapter metadata only in test mode", async () => {
    applyEnv({
      ...PRODUCTION_BASE,
      APP_ENV: "test",
      NEX_PROVIDER_MODE: "mock",
      MPESA_PROVIDER_MODE: "mock",
      NOTIFICATIONS_PROVIDER_MODE: "mock",
    });
    delete process.env.GEMINI_API_KEY;
    delete process.env.OPENAI_API_KEY;

    const result = await callNexModel({
      systemPrompt: "You are Nex.",
      messages: [{ role: "student", content: "Explain fractions." }],
    });

    expect(result.provider).toBe("mock");
    expect(createMockAdapterMetadata()).toEqual({
      adapter: "explicit-test",
      isMock: true,
    });
  });
});
