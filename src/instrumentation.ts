export async function register() {
  if (process.env.NEXT_RUNTIME === "nodejs") {
    const { assertEnvironmentValid } = await import("@/lib/env/validateEnv");
    const appEnv = process.env.APP_ENV ?? process.env.NODE_ENV;

    if (appEnv === "production" || appEnv === "staging") {
      assertEnvironmentValid();
    }
  }

  if (!process.env.SENTRY_DSN) {
    return;
  }

  if (process.env.NEXT_RUNTIME === "nodejs") {
    await import("../sentry.server.config");
  }

  if (process.env.NEXT_RUNTIME === "edge") {
    await import("../sentry.server.config");
  }
}

export async function onRequestError(
  error: unknown,
  request: {
    path: string;
    method: string;
    headers: Record<string, string | string[] | undefined>;
  },
  context: {
    routerKind: "Pages Router" | "App Router";
    routePath: string;
    routeType: "render" | "route" | "action" | "middleware";
  },
) {
  if (!process.env.SENTRY_DSN) {
    return;
  }

  const Sentry = await import("@sentry/nextjs");
  Sentry.captureException(error, {
    extra: {
      requestPath: request.path,
      requestMethod: request.method,
      routePath: context.routePath,
      routeType: context.routeType,
    },
  });
}
