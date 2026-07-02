import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export type SessionFreshnessResult =
  | { ok: true }
  | { ok: false; reason: "session_version_stale" | "session_not_active" | "account_disabled" };

function readSessionVersionFromAppMetadata(
  appMetadata: Record<string, unknown> | undefined,
): number {
  const version = appMetadata?.sessionVersion;
  return typeof version === "number" && Number.isFinite(version) ? version : 1;
}

export function readSessionVersionFromAccessToken(accessToken: string): number {
  return readJwtAppMetadata(accessToken).sessionVersion;
}

function readJwtPayload(accessToken: string): Record<string, unknown> {
  try {
    const payloadPart = accessToken.split(".")[1];
    if (!payloadPart) {
      return {};
    }

    const normalized = payloadPart.replace(/-/g, "+").replace(/_/g, "/");
    const padded =
      normalized + "=".repeat((4 - (normalized.length % 4 || 4)) % 4);

    return JSON.parse(Buffer.from(padded, "base64").toString("utf8")) as Record<
      string,
      unknown
    >;
  } catch {
    return {};
  }
}

function readJwtAppMetadata(accessToken: string): {
  sessionVersion: number;
} {
  const payload = readJwtPayload(accessToken);
  const appMetadata = payload.app_metadata as Record<string, unknown> | undefined;

  return {
    sessionVersion: readSessionVersionFromAppMetadata(appMetadata),
  };
}

export function readSessionIdFromAccessToken(accessToken: string): string | null {
  const sessionId = readJwtPayload(accessToken).session_id;
  return typeof sessionId === "string" && sessionId.length > 0 ? sessionId : null;
}

function isAccountDisabled(bannedUntil: string | null | undefined): boolean {
  if (!bannedUntil) {
    return false;
  }

  return new Date(bannedUntil).getTime() > Date.now();
}

async function isAuthSessionActive(
  sessionId: string,
  userId: string,
): Promise<boolean> {
  const admin = createAdminClient();
  const { data, error } = await admin.rpc("is_auth_session_active", {
    p_session_id: sessionId,
    p_user_id: userId,
  });

  if (error) {
    throw new Error(error.message);
  }

  return Boolean(data);
}

export async function validateSessionFreshness(input: {
  userId: string;
  accessToken: string;
}): Promise<SessionFreshnessResult> {
  const admin = createAdminClient();
  const { data, error } = await admin.auth.admin.getUserById(input.userId);

  if (error || !data.user) {
    return { ok: false, reason: "session_not_active" };
  }

  if (isAccountDisabled(data.user.banned_until)) {
    return { ok: false, reason: "account_disabled" };
  }

  const authoritativeVersion = readSessionVersionFromAppMetadata(
    data.user.app_metadata as Record<string, unknown> | undefined,
  );
  const tokenVersion = readSessionVersionFromAccessToken(input.accessToken);

  if (tokenVersion < authoritativeVersion) {
    return { ok: false, reason: "session_version_stale" };
  }

  const sessionId = readSessionIdFromAccessToken(input.accessToken);
  if (sessionId) {
    const active = await isAuthSessionActive(sessionId, input.userId);
    if (!active) {
      return { ok: false, reason: "session_not_active" };
    }
  }

  return { ok: true };
}
