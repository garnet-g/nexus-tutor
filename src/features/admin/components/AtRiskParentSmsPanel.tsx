"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Textarea } from "@/features/admin/components/adminForm";
import { Panel } from "@/features/admin/components/adminUi";
import { useConfirm } from "@/features/admin/components/ConfirmDialog";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import { cn } from "@/lib/utils";

type AtRiskStudent = {
  studentId: string;
  studentName: string;
  gradeLevel: string;
  curriculum: string;
  currentScore: number;
  delta: number;
  lastActive: string | null;
};

interface AtRiskParentSmsPanelProps {
  students: AtRiskStudent[];
  riskThreshold: number;
  canWrite: boolean;
}

function formatDelta(value: number): string {
  const sign = value > 0 ? "+" : "";
  return `${sign}${value.toFixed(1)}`;
}

function formatDate(iso: string | null): string {
  if (!iso) {
    return "-";
  }

  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date(iso));
}

function defaultSms(student: AtRiskStudent): string {
  return `Nexus update: ${student.studentName}'s academic health score is ${student.currentScore.toFixed(1)}. Please check in and encourage a short study session today.`;
}

export function AtRiskParentSmsPanel({
  students,
  riskThreshold,
  canWrite,
}: AtRiskParentSmsPanelProps) {
  const [messages, setMessages] = useState<Record<string, string>>(() =>
    Object.fromEntries(students.map((student) => [student.studentId, defaultSms(student)])),
  );
  const [busyId, setBusyId] = useState<string | null>(null);
  const { confirm, dialog } = useConfirm();

  async function sendSms(student: AtRiskStudent) {
    const ok = await confirm({
      title: `Send SMS to ${student.studentName}'s parent?`,
      description: "The message will be delivered to the linked parent phone.",
      confirmLabel: "Send SMS",
    });
    if (!ok) {
      return;
    }

    setBusyId(student.studentId);

    try {
      const response = await fetch("/api/admin/outcomes/parent-sms", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          studentId: student.studentId,
          message: messages[student.studentId] ?? defaultSms(student),
        }),
      });
      const payload = (await response.json()) as {
        success: boolean;
        data?: { parentName: string | null; smsStatus: string };
        error?: { code: string; message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        toastError(
          "Could not send SMS",
          payload.error?.code === "NO_PARENT_PHONE"
            ? "No active parent phone is linked."
            : payload.error?.message,
        );
        return;
      }

      toastSuccess(
        `SMS ${payload.data?.smsStatus ?? "sent"}`,
        `Delivered to ${student.studentName}'s parent.`,
      );
    } catch {
      toastError("Network error", "Please try again.");
    } finally {
      setBusyId(null);
    }
  }

  return (
    <Panel
      title="At-risk learners"
      description={`Health score below ${riskThreshold} or trending down. Parent SMS is single-recipient only.`}
      padded={false}
    >
      {dialog}
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
              <th className="px-5 py-3 font-medium">Student</th>
              <th className="px-5 py-3 font-medium">Grade</th>
              <th className="px-5 py-3 text-right font-medium">Current</th>
              <th className="px-5 py-3 text-right font-medium">Delta</th>
              <th className="px-5 py-3 font-medium">Last active</th>
              <th className="px-5 py-3 font-medium">Parent SMS</th>
            </tr>
          </thead>
          <tbody>
            {students.length === 0 ? (
              <tr>
                <td
                  colSpan={6}
                  className="px-5 py-10 text-center text-muted-foreground"
                >
                  No at-risk learners under the current threshold.
                </td>
              </tr>
            ) : (
              students.map((row) => (
                <tr
                  key={row.studentId}
                  className="border-b border-nexus-border align-top last:border-0 hover:bg-nexus-sunken/60"
                >
                  <td className="px-5 py-3 font-medium text-foreground">
                    {row.studentName}
                  </td>
                  <td className="px-5 py-3 text-muted-foreground">
                    {row.gradeLevel}
                  </td>
                  <td className="px-5 py-3 text-right font-mono tabular-nums text-foreground">
                    {row.currentScore.toFixed(1)}
                  </td>
                  <td
                    className={cn(
                      "px-5 py-3 text-right font-mono tabular-nums",
                      row.delta < 0
                        ? "text-nexus-danger"
                        : "text-muted-foreground",
                    )}
                  >
                    {formatDelta(row.delta)}
                  </td>
                  <td className="px-5 py-3 tabular-nums text-muted-foreground">
                    {formatDate(row.lastActive)}
                  </td>
                  <td className="min-w-80 px-5 py-3">
                    {canWrite ? (
                      <div className="space-y-2">
                        <Textarea
                          value={messages[row.studentId] ?? defaultSms(row)}
                          onChange={(event) =>
                            setMessages((current) => ({
                              ...current,
                              [row.studentId]: event.target.value,
                            }))
                          }
                          minLength={5}
                          maxLength={480}
                          rows={3}
                        />
                        <Button
                          type="button"
                          variant="outline"
                          size="sm"
                          onClick={() => void sendSms(row)}
                          disabled={busyId === row.studentId}
                        >
                          {busyId === row.studentId ? "Sending…" : "Send SMS"}
                        </Button>
                      </div>
                    ) : (
                      <span className="text-sm text-muted-foreground">
                        Super admin required.
                      </span>
                    )}
                  </td>
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </Panel>
  );
}
