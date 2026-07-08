import {
  parseEnvSchema,
  inferAppEnv,
  inferNexProviderMode,
  inferMpesaProviderMode,
  inferNotificationsProviderMode,
  type AppEnv,
  type MpesaProviderMode,
  type NexProviderMode,
  type NotificationsProviderMode,
  type ParsedEnv,
} from "./envSchema";

export class ConfigurationError extends Error {
  readonly code = "CONFIGURATION_ERROR";

  constructor(message: string) {
    super(message);
    this.name = "ConfigurationError";
  }
}

export const EXPLICIT_MOCK_ADAPTER = "explicit-test" as const;

export interface MockAdapterMetadata {
  adapter: typeof EXPLICIT_MOCK_ADAPTER;
  isMock: true;
}

export function createMockAdapterMetadata(): MockAdapterMetadata {
  return {
    adapter: EXPLICIT_MOCK_ADAPTER,
    isMock: true,
  };
}

let cachedParsedEnv: ParsedEnv | null = null;

export function resetEnvCacheForTests(): void {
  cachedParsedEnv = null;
}

export function getParsedEnv(): ParsedEnv {
  if (process.env.VITEST === "true") {
    return parseEnvSchema(process.env);
  }

  if (!cachedParsedEnv) {
    cachedParsedEnv = parseEnvSchema(process.env);
  }

  return cachedParsedEnv;
}

export function getAppEnv(): AppEnv {
  return inferAppEnv();
}

export function getNexProviderMode(): NexProviderMode {
  return inferNexProviderMode();
}

export function getMpesaProviderMode(): MpesaProviderMode {
  return inferMpesaProviderMode();
}

export function getNotificationsProviderMode(): NotificationsProviderMode {
  return inferNotificationsProviderMode();
}

export function isNexMockAllowed(): boolean {
  return inferNexProviderMode() === "mock";
}

export function isMpesaMockAllowed(): boolean {
  return inferMpesaProviderMode() === "mock";
}

export function isNotificationsMockAllowed(): boolean {
  return inferNotificationsProviderMode() === "mock";
}

export function isGeminiConfigured(): boolean {
  return Boolean(process.env.GEMINI_API_KEY?.trim());
}

export function isOpenAiConfigured(): boolean {
  return Boolean(process.env.OPENAI_API_KEY?.trim());
}

export function isMpesaConfigured(): boolean {
  return Boolean(
    process.env.MPESA_CONSUMER_KEY &&
      process.env.MPESA_CONSUMER_SECRET &&
      process.env.MPESA_PASSKEY &&
      process.env.MPESA_SHORTCODE,
  );
}

export function isCelcomConfigured(): boolean {
  return Boolean(
    process.env.CELCOM_PARTNER_ID &&
      process.env.CELCOM_API_KEY &&
      process.env.CELCOM_SHORTCODE,
  );
}

export function isResendConfigured(): boolean {
  return Boolean(process.env.RESEND_API_KEY?.trim());
}

export function assertNexConfiguredForLiveMode(): void {
  if (isNexMockAllowed()) {
    return;
  }

  if (!isGeminiConfigured() && !isOpenAiConfigured()) {
    throw new ConfigurationError(
      "Nex AI providers are not configured for live mode",
    );
  }
}

export function assertMpesaConfiguredForLiveMode(): void {
  if (isMpesaMockAllowed()) {
    return;
  }

  if (!isMpesaConfigured()) {
    throw new ConfigurationError("M-Pesa is not configured for live mode");
  }
}

export function assertNotificationsConfiguredForLiveMode(
  channel: "sms" | "email" | "whatsapp",
): void {
  if (isNotificationsMockAllowed()) {
    return;
  }

  if ((channel === "sms" || channel === "whatsapp") && !isCelcomConfigured()) {
    throw new ConfigurationError(
      `Celcom ${channel} is not configured for live mode`,
    );
  }

  if (channel === "email" && !isResendConfigured()) {
    throw new ConfigurationError("Resend email is not configured for live mode");
  }
}
