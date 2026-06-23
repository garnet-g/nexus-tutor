"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Field, Input } from "@/features/admin/components/adminForm";
import { EmptyState, Panel, StatusBadge } from "@/features/admin/components/adminUi";
import { CopyButton } from "@/features/admin/components/CopyButton";
import { toastError, toastSuccess } from "@/features/admin/components/toast";

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

  async function handleCreate(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsCreating(true);

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
        toastError("Could not create invite", payload.error?.message);
        return;
      }

      setInvites((current) => [payload.data!.invite, ...current]);
      toastSuccess(`Created invite ${payload.data.invite.invite_code}`);
      setExpiresAt("");
      setMaxUses(1);
    } catch {
      toastError("Network error", "Please try again.");
    } finally {
      setIsCreating(false);
    }
  }

  return (
    <div className="space-y-6">
      <Panel title="Create invite">
        <form onSubmit={handleCreate} className="space-y-4">
          <div className="grid gap-4 sm:grid-cols-2">
            <Field label="Max uses">
              <Input
                type="number"
                min={1}
                max={1000}
                value={maxUses}
                onChange={(event) => setMaxUses(Number(event.target.value))}
              />
            </Field>
            <Field label="Expires at (optional)">
              <Input
                type="datetime-local"
                value={expiresAt}
                onChange={(event) => setExpiresAt(event.target.value)}
              />
            </Field>
          </div>

          <Button type="submit" variant="primary" disabled={isCreating}>
            {isCreating ? "Creating…" : "Generate invite code"}
          </Button>
        </form>
      </Panel>

      <Panel title="Active invites" padded={invites.length === 0}>
        {invites.length === 0 ? (
          <EmptyState
            title="No invite codes yet"
            description="Generate a code above to share private beta access."
          />
        ) : (
          <ul className="divide-y divide-nexus-border">
            {invites.map((invite) => (
              <li
                key={invite.id}
                className="flex flex-wrap items-center justify-between gap-3 px-5 py-3 text-sm"
              >
                <div className="flex items-center gap-2">
                  <span className="font-mono font-medium text-foreground">
                    {invite.invite_code}
                  </span>
                  <CopyButton value={invite.invite_code} label="Copy invite code" />
                </div>
                <div className="flex items-center gap-3 text-muted-foreground">
                  <span className="tabular-nums">
                    {invite.use_count}/{invite.max_uses} uses
                  </span>
                  {invite.expires_at ? (
                    <span className="tabular-nums">
                      expires {new Date(invite.expires_at).toLocaleString()}
                    </span>
                  ) : null}
                  <StatusBadge tone={invite.is_active ? "success" : "neutral"}>
                    {invite.is_active ? "Active" : "Inactive"}
                  </StatusBadge>
                </div>
              </li>
            ))}
          </ul>
        )}
      </Panel>
    </div>
  );
}
