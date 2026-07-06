type HeaderPair = { key: string; value: string };

function isDev(): boolean {
  return process.env.NODE_ENV === "development";
}

function isHttpsProduction(): boolean {
  const appEnv = process.env.APP_ENV ?? process.env.VERCEL_ENV ?? process.env.NODE_ENV;
  return appEnv === "production" || appEnv === "staging";
}

function supabaseOrigin(): string | null {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
  if (!url) {
    return null;
  }
  try {
    return new URL(url).origin;
  } catch {
    return null;
  }
}

function sentryConnectOrigins(): string {
  const dsn = process.env.SENTRY_DSN ?? process.env.NEXT_PUBLIC_SENTRY_DSN ?? "";
  if (!dsn) {
    return "";
  }
  try {
    const host = new URL(dsn).host;
    return ` https://${host}`;
  } catch {
    return "";
  }
}

export function buildContentSecurityPolicy(): string {
  const supabase = supabaseOrigin();
  const connectSrc = [
    "'self'",
    supabase,
    "https://*.supabase.co",
    sentryConnectOrigins(),
  ]
    .filter(Boolean)
    .join(" ");

  const devEval = isDev() ? " 'unsafe-eval'" : "";

  return [
    "default-src 'self'",
    `script-src 'self' 'unsafe-inline'${devEval}`,
    "style-src 'self' 'unsafe-inline'",
    "img-src 'self' blob: data: https:",
    "font-src 'self' data:",
    `connect-src ${connectSrc}`,
    "media-src 'self' blob:",
    "worker-src 'self' blob:",
    "object-src 'none'",
    "base-uri 'self'",
    "form-action 'self'",
    "frame-ancestors 'none'",
    isHttpsProduction() ? "upgrade-insecure-requests" : "",
  ]
    .filter(Boolean)
    .join("; ");
}

export function buildPermissionsPolicy(allowCameraMic: boolean): string {
  if (allowCameraMic) {
    return "camera=(self), microphone=(self), geolocation=(), payment=()";
  }
  return "camera=(), microphone=(), geolocation=(), payment=()";
}

export function buildBaseSecurityHeaders(): HeaderPair[] {
  const headers: HeaderPair[] = [
    { key: "X-Content-Type-Options", value: "nosniff" },
    { key: "Referrer-Policy", value: "strict-origin-when-cross-origin" },
    { key: "X-Frame-Options", value: "DENY" },
    { key: "Content-Security-Policy", value: buildContentSecurityPolicy() },
    {
      key: "Permissions-Policy",
      value: buildPermissionsPolicy(false),
    },
  ];

  if (isHttpsProduction()) {
    headers.push({
      key: "Strict-Transport-Security",
      value: "max-age=63072000; includeSubDomains; preload",
    });
  }

  return headers;
}

export function buildNexMultimediaHeaders(): HeaderPair[] {
  return [
    ...buildBaseSecurityHeaders().filter(
      (header) => header.key !== "Permissions-Policy",
    ),
    {
      key: "Permissions-Policy",
      value: buildPermissionsPolicy(true),
    },
  ];
}

export function buildNexPrivateHeaders(): HeaderPair[] {
  return [...buildNexMultimediaHeaders(), ...buildPrivateCacheHeaders()];
}

export const PRIVATE_CACHE_CONTROL = "private, no-store, max-age=0";

export function buildPrivateCacheHeaders(): HeaderPair[] {
  return [{ key: "Cache-Control", value: PRIVATE_CACHE_CONTROL }];
}

export const AUTHENTICATED_ROUTE_PREFIXES = [
  "/admin",
  "/dashboard",
  "/onboarding",
  "/diagnostic",
  "/learn",
  "/practice",
  "/assignment-help",
  "/exam-prep",
  "/mock-exams",
  "/exam-simulator",
  "/progress",
  "/revision",
  "/study-plan",
  "/profile",
  "/parent",
  "/focus",
  "/tasks",
  "/library",
  "/saved",
  "/study-search",
  "/mistakes",
  "/weak-areas",
  "/weekly-goal",
  "/continue",
  "/offline",
  "/nex-memory",
  "/readiness",
] as const;

export const NEX_ROUTE_PREFIXES = ["/nex"] as const;
