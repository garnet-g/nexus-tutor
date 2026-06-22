"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import { Button } from "@/components/ui/Button";

interface ViewAsStudentEndButtonProps {
  studentId: string;
  sessionId: string;
}

export function ViewAsStudentEndButton({
  studentId,
  sessionId,
}: ViewAsStudentEndButtonProps) {
  const router = useRouter();
  const [isEnding, setIsEnding] = useState(false);
  const [error, setError] = useState<string | null>(null);

  async function handleEnd() {
    setIsEnding(true);
    setError(null);

    try {
      const response = await fetch(
        `/api/admin/users/${studentId}/impersonate?session=${sessionId}`,
        { method: "DELETE" },
      );
      const payload = (await response.json()) as {
        success: boolean;
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        setError(payload.error?.message ?? "Could not end view-as session.");
        return;
      }

      router.push(`/admin/users/${studentId}`);
      router.refresh();
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsEnding(false);
    }
  }

  return (
    <div className="flex flex-wrap items-center gap-2">
      <Button
        type="button"
        variant="outline"
        size="sm"
        onClick={() => void handleEnd()}
        disabled={isEnding}
      >
        {isEnding ? "Ending..." : "End view"}
      </Button>
      {error ? <span className="text-xs text-nexus-danger">{error}</span> : null}
    </div>
  );
}
