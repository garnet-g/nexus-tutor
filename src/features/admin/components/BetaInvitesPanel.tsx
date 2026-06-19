"use client";

import { useState } from "react";

type BetaInvite = {
  id: string;
  invite_code: string;
  max_uses: number;
  use_count: number;
  expires_at: string | null;
  is_active: boolean;
  created_at: string;
};

interface BetaInvitesPanelProps {
  initialInvites: BetaInvite[];
}

export function BetaInvitesPanel({ initialInvites }: BetaInvitesPanelProps) {
  const [invites, setInvites] = useState(initialInvites);
  const [maxUses, setMaxUses] = useState(1);
  const [expiresAt, setExpiresAt] = useState("");
  const [isCreating, setIsCreating] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  async function handleCreate(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsCreating(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch("/api/admin/beta-invites", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          maxUses,
          expiresAt: expiresAt ? new Date(expiresAt).toISOString() : null,
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: { invite: BetaInvite };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not create invite.");
        return;
      }

      setInvites((current) => [payload.data!.invite, ...current]);
      setSuccess(`Created invite ${payload.data.invite.invite_code}`);
      setExpiresAt("");
      setMaxUses(1);
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsCreating(false);
    }
  }

  return (
    <div className="space-y-6">
      <form
        onSubmit={handleCreate}
        className="space-y-4 rounded-2xl border border-border bg-primary p-6"
      >
        <h2 className="text-lg font-medium">Create invite</h2>
        <div className="grid gap-4 sm:grid-cols-2">
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Max uses</span>
            <input
              type="number"
              min={1}
              max={1000}
              value={maxUses}
              onChange={(event) => setMaxUses(Number(event.target.value))}
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Expires at (optional)</span>
            <input
              type="datetime-local"
              value={expiresAt}
              onChange={(event) => setExpiresAt(event.target.value)}
              className="w-full rounded-lg border border-border bg-background px-3 py-2"
            />
          </label>
        </div>

        {error ? <p className="text-sm text-red-400">{error}</p> : null}
        {success ? <p className="text-sm text-emerald-400">{success}</p> : null}

        <button
          type="submit"
          disabled={isCreating}
          className="rounded-lg bg-card px-4 py-2 text-sm font-medium text-foreground hover:bg-muted disabled:opacity-60"
        >
          {isCreating ? "Creating..." : "Generate invite code"}
        </button>
      </form>

      <section className="rounded-2xl border border-border bg-primary p-6">
        <h2 className="text-lg font-medium">Active invites</h2>
        {invites.length === 0 ? (
          <p className="mt-2 text-sm text-muted-foreground">No invite codes yet.</p>
        ) : (
          <ul className="mt-4 space-y-3">
            {invites.map((invite) => (
              <li
                key={invite.id}
                className="rounded-lg border border-border bg-background p-3 text-sm"
              >
                <p className="font-mono font-medium text-foreground">
                  {invite.invite_code}
                </p>
                <p className="text-muted-foreground">
                  {invite.use_count}/{invite.max_uses} uses
                  {invite.expires_at
                    ? ` · expires ${new Date(invite.expires_at).toLocaleString()}`
                    : ""}
                  {invite.is_active ? "" : " · inactive"}
                </p>
              </li>
            ))}
          </ul>
        )}
      </section>
    </div>
  );
}
