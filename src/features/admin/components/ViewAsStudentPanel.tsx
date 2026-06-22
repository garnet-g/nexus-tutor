"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel } from "@/features/admin/components/adminUi";

interface ViewAsStudentPanelProps {
  studentId: string;
  studentName: string;
}

export function ViewAsStudentPanel({
  studentId,
  studentName,
}: ViewAsStudentPanelProps) {
  const router = useRouter();
  const [reason, setReason] = useState("");
  const [isStarting, setIsStarting] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleStart(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsStarting(true);
    setError(null);

    try {
      const response = await fetch(
        `/api/admin/users/${studentId}/impersonate`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ reason }),
        },
      );

      const payload = (await response.json()) as {
        success: boolean;
        data?: { sessionId: string; viewUrl: string; expiresAt: string };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not start view-as session.");
        return;
      }

      router.push(payload.data.viewUrl);
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsStarting(false);
    }
  }

  return (
    <Panel
      title="View as student"
      description="Open a read-only, time-boxed render of this student's dashboard. The session is audited and never signs in as the user."
    >
      <form onSubmit={handleStart} className="space-y-4">
        <label className="block space-y-1.5 text-sm">
          <span className="text-muted-foreground">Reason</span>
          <textarea
            value={reason}
            onChange={(event) => setReason(event.target.value)}
            required
            minLength={3}
            maxLength={500}
            rows={2}
            placeholder={`Why view ${studentName}'s account?`}
            className="w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
          />
        </label>

        {error ? <p className="text-sm text-nexus-danger">{error}</p> : null}

        <Button type="submit" disabled={isStarting} variant="outline">
          {isStarting ? "Starting…" : "View as student"}
        </Button>
      </form>
    </Panel>
  );
}
