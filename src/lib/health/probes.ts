import "server-only";

import {
  inferAppEnv,
  inferMpesaProviderMode,
  inferNexProviderMode,
  inferNotificationsProviderMode,
} from "@/lib/env/envSchema";
import {
  isCelcomConfigured,
  isGeminiConfigured,
  isMpesaConfigured,
  isOpenAiConfigured,
  isResendConfigured,
} from "@/lib/env/providerModes";
import type { HealthProbe, ProbeStatus } from "./types";

function nexProbeStatus(): { status: ProbeStatus; detail: string } {
  const mode = inferNexProviderMode();

  if (mode === "mock") {
    return {
      status: "configured",
      detail: `Nex running in explicit mock mode (${inferAppEnv()}).`,
    };
  }

  const hasGemini = isGeminiConfigured();
  const hasOpenAi = isOpenAiConfigured();

  if (!hasGemini && !hasOpenAi) {
    return {
      status: "misconfigured",
      detail: "Live Nex mode requires at least one AI provider credential.",
    };
  }

  const providers = [
    hasGemini ? "Gemini" : null,
    hasOpenAi ? "OpenAI" : null,
  ].filter(Boolean);

  return {
    status: "configured",
    detail: `Live Nex credentials present (${providers.join(", ")}). Reachability not verified at boot.`,
  };
}

function mpesaProbeStatus(): { status: ProbeStatus; detail: string } {
  const mode = inferMpesaProviderMode();

  if (mode === "mock") {
    return {
      status: "configured",
      detail: "M-Pesa mock adapter enabled for non-production environment.",
    };
  }

  if (!isMpesaConfigured()) {
    return {
      status: "misconfigured",
      detail: `M-Pesa ${mode} mode requires Daraja credentials.`,
    };
  }

  return {
    status: "configured",
    detail: `M-Pesa ${mode} credentials present. Daraja reachability not verified at boot.`,
  };
}

function notificationsProbeStatus(): { status: ProbeStatus; detail: string } {
  const mode = inferNotificationsProviderMode();

  if (mode === "mock") {
    return {
      status: "configured",
      detail: "Notifications mock adapter enabled for non-production environment.",
    };
  }

  const channels: string[] = [];
  if (isCelcomConfigured()) {
    channels.push("SMS");
  }
  if (isResendConfigured()) {
    channels.push("email");
  }

  if (channels.length === 0) {
    return {
      status: "misconfigured",
      detail: "Live notifications mode requires Celcom and/or Resend credentials.",
    };
  }

  return {
    status: "configured",
    detail: `Notification credentials present (${channels.join(", ")}). Provider reachability not verified at boot.`,
  };
}

function databaseProbeStatus(): { status: ProbeStatus; detail: string } {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
  const serviceRole = process.env.SUPABASE_SERVICE_ROLE_KEY?.trim();
  const anon = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY?.trim();

  if (!url || !serviceRole || !anon) {
    return {
      status: "misconfigured",
      detail: "Supabase URL or keys are missing.",
    };
  }

  if (url.includes("your-") || serviceRole.includes("your-")) {
    return {
      status: "misconfigured",
      detail: "Supabase credentials are still placeholder values.",
    };
  }

  return {
    status: "configured",
    detail: "Supabase credentials present. Connection not verified at boot.",
  };
}

function cronProbeStatus(): { status: ProbeStatus; detail: string } {
  const appEnv = inferAppEnv();
  const cronSecret = process.env.CRON_SECRET?.trim();

  if (appEnv === "production" || appEnv === "staging") {
    if (!cronSecret) {
      return {
        status: "misconfigured",
        detail: "CRON_SECRET is required for scheduled jobs in staging/production.",
      };
    }

    return {
      status: "configured",
      detail: "Cron secret configured. Job freshness not verified at boot.",
    };
  }

  return {
    status: cronSecret ? "configured" : "not_verified",
    detail: cronSecret
      ? "Cron secret present for local/staging diagnostics."
      : "Cron secret optional in development/test.",
  };
}

export function buildProviderProbes(): HealthProbe[] {
  const nex = nexProbeStatus();
  const mpesa = mpesaProbeStatus();
  const notifications = notificationsProbeStatus();
  const database = databaseProbeStatus();
  const cron = cronProbeStatus();

  return [
    {
      id: "database",
      name: "Database",
      status: database.status,
      detail: database.detail,
    },
    {
      id: "nex_ai",
      name: "Nex AI",
      status: nex.status,
      detail: nex.detail,
    },
    {
      id: "mpesa",
      name: "M-Pesa",
      status: mpesa.status,
      detail: mpesa.detail,
    },
    {
      id: "notifications",
      name: "Notifications",
      status: notifications.status,
      detail: notifications.detail,
    },
    {
      id: "cron",
      name: "Scheduled jobs",
      status: cron.status,
      detail: cron.detail,
    },
  ];
}

export async function probeDatabaseReachability(): Promise<HealthProbe> {
  const base = buildProviderProbes().find((probe) => probe.id === "database");
  if (!base || base.status === "misconfigured") {
    return (
      base ?? {
        id: "database",
        name: "Database",
        status: "misconfigured",
        detail: "Supabase credentials are missing.",
      }
    );
  }

  try {
    const { createAdminClient } = await import("@/lib/supabase/admin");
    const supabase = createAdminClient();
    const { error } = await supabase.from("platform_settings").select("id").limit(1);

    if (error) {
      return {
        ...base,
        status: "degraded",
        detail: "Supabase credentials present but admin read failed.",
      };
    }

    return {
      ...base,
      status: "reachable",
      detail: "Supabase admin read succeeded.",
    };
  } catch {
    return {
      ...base,
      status: "degraded",
      detail: "Supabase admin client could not be initialized.",
    };
  }
}

export async function runHealthProbes(options?: {
  checkReachability?: boolean;
}): Promise<HealthProbe[]> {
  const probes = buildProviderProbes();

  if (!options?.checkReachability) {
    return probes;
  }

  const database = await probeDatabaseReachability();
  return probes.map((probe) => (probe.id === "database" ? database : probe));
}
