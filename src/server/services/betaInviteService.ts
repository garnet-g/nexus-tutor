import "server-only";

import { randomBytes } from "crypto";

import { createAdminClient } from "@/lib/supabase/admin";

export type BetaInvite = {
  id: string;
  invite_code: string;
  max_uses: number;
  use_count: number;
  expires_at: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
};

export type BetaInviteValidationResult =
  | { valid: true; invite: BetaInvite }
  | { valid: false; reason: string };

function normalizeInviteCode(code: string): string {
  return code.trim().toUpperCase();
}

function isInviteExpired(expiresAt: string | null): boolean {
  if (!expiresAt) {
    return false;
  }

  return new Date(expiresAt).getTime() < Date.now();
}

function evaluateInvite(invite: BetaInvite): BetaInviteValidationResult {
  if (!invite.is_active) {
    return { valid: false, reason: "This invite code is no longer active." };
  }

  if (isInviteExpired(invite.expires_at)) {
    return { valid: false, reason: "This invite code has expired." };
  }

  if (invite.use_count >= invite.max_uses) {
    return { valid: false, reason: "This invite code has reached its use limit." };
  }

  return { valid: true, invite };
}

export async function validateInviteCode(
  code: string,
): Promise<BetaInviteValidationResult> {
  const normalizedCode = normalizeInviteCode(code);

  if (normalizedCode.length < 6) {
    return { valid: false, reason: "Enter a valid invite code." };
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("beta_invites")
    .select("*")
    .eq("invite_code", normalizedCode)
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  if (!data) {
    return { valid: false, reason: "Invalid invite code." };
  }

  return evaluateInvite(data as BetaInvite);
}

export async function consumeInvite(code: string): Promise<BetaInviteValidationResult> {
  const validation = await validateInviteCode(code);

  if (!validation.valid) {
    return validation;
  }

  const admin = createAdminClient();
  const normalizedCode = normalizeInviteCode(code);
  const nextUseCount = validation.invite.use_count + 1;

  const { data, error } = await admin
    .from("beta_invites")
    .update({ use_count: nextUseCount })
    .eq("invite_code", normalizedCode)
    .eq("use_count", validation.invite.use_count)
    .select("*")
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  if (!data) {
    return validateInviteCode(code);
  }

  return { valid: true, invite: data as BetaInvite };
}

export function generateBetaInviteCode(): string {
  return `BETA-${randomBytes(3).toString("hex").toUpperCase()}`;
}

export function isBetaInviteRequired(): boolean {
  return process.env.BETA_INVITE_REQUIRED === "true";
}

export async function listBetaInvites(): Promise<BetaInvite[]> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("beta_invites")
    .select("*")
    .order("created_at", { ascending: false });

  if (error) {
    throw new Error(error.message);
  }

  return (data ?? []) as BetaInvite[];
}

export async function createBetaInvite(input: {
  maxUses?: number;
  expiresAt?: string | null;
}): Promise<BetaInvite> {
  const admin = createAdminClient();
  const inviteCode = generateBetaInviteCode();

  const { data, error } = await admin
    .from("beta_invites")
    .insert({
      invite_code: inviteCode,
      max_uses: input.maxUses ?? 1,
      expires_at: input.expiresAt ?? null,
    })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not create beta invite");
  }

  return data as BetaInvite;
}
