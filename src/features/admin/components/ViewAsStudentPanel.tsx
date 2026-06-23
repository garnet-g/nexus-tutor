"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Field, Textarea } from "@/features/admin/components/adminForm";
import { Panel } from "@/features/admin/components/adminUi";
import { useConfirm } from "@/features/admin/components/ConfirmDialog";
import { toastError } from "@/features/admin/components/toast";

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
  const { confirm, dialog } = useConfirm();

  async function handleStart(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();

    const ok = await confirm({
      title: `View ${studentName}'s account?`,
      description:
        "This opens a read-only, time-boxed, audited render of their dashboard. It does not sign in as the user.",
      confirmLabel: "Start session",
    });
    if (!ok) {
      return;
    }

    setIsStarting(true);

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
        toastError("Could not start view-as session", payload.error?.message);
        return;
      }

      router.push(payload.data.viewUrl);
    } catch {
      toastError("Network error", "Please try again.");
    } finally {
      setIsStarting(false);
    }
  }

  return (
    <Panel
      title="View as student"
      description="Open a read-only, time-boxed render of this student's dashboard. The session is audited and never signs in as the user."
    >
      {dialog}
      <form onSubmit={handleStart} className="space-y-4">
        <Field label="Reason">
          <Textarea
            value={reason}
            onChange={(event) => setReason(event.target.value)}
            required
            minLength={3}
            maxLength={500}
            rows={2}
            placeholder={`Why view ${studentName}'s account?`}
          />
        </Field>

        <Button type="submit" disabled={isStarting} variant="outline">
          {isStarting ? "Starting…" : "View as student"}
        </Button>
      </form>
    </Panel>
  );
}
