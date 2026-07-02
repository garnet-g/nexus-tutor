import { z } from "zod";

export const APP_ENV_VALUES = [
  "test",
  "development",
  "staging",
  "production",
] as const;

export const NEX_PROVIDER_MODE_VALUES = ["mock", "live"] as const;
export const MPESA_PROVIDER_MODE_VALUES = ["mock", "sandbox", "live"] as const;
export const NOTIFICATIONS_PROVIDER_MODE_VALUES = ["mock", "live"] as const;

export type AppEnv = (typeof APP_ENV_VALUES)[number];
export type NexProviderMode = (typeof NEX_PROVIDER_MODE_VALUES)[number];
export type MpesaProviderMode = (typeof MPESA_PROVIDER_MODE_VALUES)[number];
export type NotificationsProviderMode =
  (typeof NOTIFICATIONS_PROVIDER_MODE_VALUES)[number];

export interface ParsedEnv {
  appEnv: AppEnv;
  appOrigin: string | null;
  nexProviderMode: NexProviderMode;
  mpesaProviderMode: MpesaProviderMode;
  notificationsProviderMode: NotificationsProviderMode;
}

function readEnvRecord(
  source: Record<string, string | undefined> = process.env,
): Record<string, string | undefined> {
  return source;
}

function inferDefaultAppEnv(
  source: Record<string, string | undefined>,
): AppEnv {
  if (source.APP_ENV) {
    return source.APP_ENV as AppEnv;
  }

  if (source.VITEST === "true" || source.NODE_ENV === "test") {
    return "test";
  }

  return "development";
}

function inferDefaultNexMode(
  appEnv: AppEnv,
  source: Record<string, string | undefined>,
): NexProviderMode {
  if (source.NEX_PROVIDER_MODE) {
    return source.NEX_PROVIDER_MODE as NexProviderMode;
  }

  if (appEnv === "test") {
    return "mock";
  }

  return appEnv === "production" || appEnv === "staging" ? "live" : "mock";
}

function inferDefaultMpesaMode(
  appEnv: AppEnv,
  source: Record<string, string | undefined>,
): MpesaProviderMode {
  if (source.MPESA_PROVIDER_MODE) {
    return source.MPESA_PROVIDER_MODE as MpesaProviderMode;
  }

  if (appEnv === "test") {
    return "mock";
  }

  if (appEnv === "staging") {
    return "sandbox";
  }

  return appEnv === "production" ? "live" : "mock";
}

function inferDefaultNotificationsMode(
  appEnv: AppEnv,
  source: Record<string, string | undefined>,
): NotificationsProviderMode {
  if (source.NOTIFICATIONS_PROVIDER_MODE) {
    return source.NOTIFICATIONS_PROVIDER_MODE as NotificationsProviderMode;
  }

  if (appEnv === "test") {
    return "mock";
  }

  return appEnv === "production" || appEnv === "staging" ? "live" : "mock";
}

const appEnvSchema = z.enum(APP_ENV_VALUES);
const nexModeSchema = z.enum(NEX_PROVIDER_MODE_VALUES);
const mpesaModeSchema = z.enum(MPESA_PROVIDER_MODE_VALUES);
const notificationsModeSchema = z.enum(NOTIFICATIONS_PROVIDER_MODE_VALUES);

function hasValue(value: string | undefined): boolean {
  return Boolean(value && value.trim().length > 0);
}

function assertProductionRules(
  source: Record<string, string | undefined>,
  parsed: ParsedEnv,
): void {
  if (parsed.appEnv === "production" || parsed.appEnv === "staging") {
    if (!parsed.appOrigin) {
      throw new Error("APP_ORIGIN is required when APP_ENV is staging or production");
    }

    try {
      const url = new URL(parsed.appOrigin);
      if (url.protocol !== "https:" && parsed.appEnv === "production") {
        throw new Error("APP_ORIGIN must use https in production");
      }
    } catch {
      throw new Error("APP_ORIGIN must be a valid URL when APP_ENV is staging or production");
    }
  }

  if (parsed.appEnv === "production") {
    if (parsed.nexProviderMode !== "live") {
      throw new Error("NEX_PROVIDER_MODE must be live when APP_ENV is production");
    }

    if (parsed.mpesaProviderMode === "mock") {
      throw new Error("MPESA_PROVIDER_MODE cannot be mock when APP_ENV is production");
    }

    if (parsed.notificationsProviderMode !== "live") {
      throw new Error(
        "NOTIFICATIONS_PROVIDER_MODE must be live when APP_ENV is production",
      );
    }
  }

  if (parsed.appEnv === "test") {
    if (parsed.nexProviderMode !== "mock") {
      throw new Error("NEX_PROVIDER_MODE must be mock when APP_ENV is test");
    }

    if (parsed.mpesaProviderMode !== "mock") {
      throw new Error("MPESA_PROVIDER_MODE must be mock when APP_ENV is test");
    }

    if (parsed.notificationsProviderMode !== "mock") {
      throw new Error(
        "NOTIFICATIONS_PROVIDER_MODE must be mock when APP_ENV is test",
      );
    }
  }

  if (parsed.nexProviderMode === "live") {
    if (!hasValue(source.GEMINI_API_KEY) && !hasValue(source.OPENAI_API_KEY)) {
      throw new Error(
        "At least one of GEMINI_API_KEY or OPENAI_API_KEY is required when NEX_PROVIDER_MODE is live",
      );
    }
  }

  if (parsed.mpesaProviderMode === "sandbox" || parsed.mpesaProviderMode === "live") {
    const mpesaKeys = [
      "MPESA_CONSUMER_KEY",
      "MPESA_CONSUMER_SECRET",
      "MPESA_PASSKEY",
      "MPESA_SHORTCODE",
    ] as const;

    for (const key of mpesaKeys) {
      if (!hasValue(source[key])) {
        throw new Error(`${key} is required when MPESA_PROVIDER_MODE is not mock`);
      }
    }
  }

  if (parsed.notificationsProviderMode === "live") {
    const celcomKeys = [
      "CELCOM_PARTNER_ID",
      "CELCOM_API_KEY",
      "CELCOM_SHORTCODE",
    ] as const;
    const hasCelcom = celcomKeys.every((key) => hasValue(source[key]));
    const hasResend = hasValue(source.RESEND_API_KEY);

    if (!hasCelcom && !hasResend) {
      throw new Error(
        "CELCOM_* or RESEND_API_KEY is required when NOTIFICATIONS_PROVIDER_MODE is live",
      );
    }
  }

  const supabaseKeys = [
    "NEXT_PUBLIC_SUPABASE_URL",
    "NEXT_PUBLIC_SUPABASE_ANON_KEY",
    "SUPABASE_SERVICE_ROLE_KEY",
  ] as const;

  for (const key of supabaseKeys) {
    if (!hasValue(source[key])) {
      throw new Error(`${key} is required`);
    }
  }
}

export function inferAppEnv(
  source: Record<string, string | undefined> = process.env,
): AppEnv {
  return appEnvSchema.parse(inferDefaultAppEnv(source));
}

export function inferNexProviderMode(
  source: Record<string, string | undefined> = process.env,
): NexProviderMode {
  const appEnv = inferDefaultAppEnv(source);
  return nexModeSchema.parse(inferDefaultNexMode(appEnv, source));
}

export function inferMpesaProviderMode(
  source: Record<string, string | undefined> = process.env,
): MpesaProviderMode {
  const appEnv = inferDefaultAppEnv(source);
  return mpesaModeSchema.parse(inferDefaultMpesaMode(appEnv, source));
}

export function inferNotificationsProviderMode(
  source: Record<string, string | undefined> = process.env,
): NotificationsProviderMode {
  const appEnv = inferDefaultAppEnv(source);
  return notificationsModeSchema.parse(
    inferDefaultNotificationsMode(appEnv, source),
  );
}

export function parseEnvSchema(
  source: Record<string, string | undefined> = readEnvRecord(),
): ParsedEnv {
  const appEnv = appEnvSchema.parse(inferDefaultAppEnv(source));
  const parsed: ParsedEnv = {
    appEnv,
    appOrigin: source.APP_ORIGIN?.trim() || null,
    nexProviderMode: nexModeSchema.parse(inferDefaultNexMode(appEnv, source)),
    mpesaProviderMode: mpesaModeSchema.parse(
      inferDefaultMpesaMode(appEnv, source),
    ),
    notificationsProviderMode: notificationsModeSchema.parse(
      inferDefaultNotificationsMode(appEnv, source),
    ),
  };

  assertProductionRules(source, parsed);
  return parsed;
}

export function formatEnvValidationErrors(error: unknown): string[] {
  if (error instanceof z.ZodError) {
    return error.issues.map((issue) => issue.message);
  }

  if (error instanceof Error) {
    return [error.message];
  }

  return ["Unknown environment validation error"];
}
