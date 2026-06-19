"use client";

import Link from "next/link";
import { useRef, useState } from "react";

import { Button } from "@/components/ui/Button";
import type { CameraMode } from "@/schemas/cameraSchemas";
import type { NexMode } from "@/lib/nex/types";
import { cn } from "@/lib/utils";

interface CameraCaptureButtonProps {
  sessionMode: NexMode;
  sessionId: string | null;
  topicId: string | null;
  cameraEnabled: boolean;
  disabled?: boolean;
  onPhotoProcessed: (payload: {
    studentMessage: string;
    nexResponse: string;
    nexSessionId: string;
    nexMessageId: string;
    sessionMode: NexMode;
  }) => void;
  onError: (message: string) => void;
  className?: string;
}

const CAMERA_MODES: CameraMode[] = ["homework", "explain"];

export function CameraCaptureButton({
  sessionMode,
  sessionId,
  topicId,
  cameraEnabled,
  disabled = false,
  onPhotoProcessed,
  onError,
  className,
}: CameraCaptureButtonProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [isUploading, setIsUploading] = useState(false);

  if (!CAMERA_MODES.includes(sessionMode as CameraMode)) {
    return null;
  }

  if (!cameraEnabled) {
    return (
      <div
        className={cn(
          "rounded-xl border border-dashed border-border bg-muted px-3 py-2 text-xs text-muted-foreground",
          className,
        )}
      >
        Camera tutoring is a Premium feature.{" "}
        <Link href="/pricing" className="font-medium text-primary underline-offset-4 hover:underline">
          Upgrade
        </Link>
      </div>
    );
  }

  async function handleFileChange(event: React.ChangeEvent<HTMLInputElement>) {
    const file = event.target.files?.[0];
    event.target.value = "";

    if (!file || isUploading) {
      return;
    }

    setIsUploading(true);

    try {
      const body = new FormData();
      body.append("image", file);
      body.append("sessionMode", sessionMode);
      if (sessionId) {
        body.append("nexSessionId", sessionId);
      }
      if (topicId) {
        body.append("topicId", topicId);
      }

      const response = await fetch("/api/nex/camera", {
        method: "POST",
        body,
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          nexSessionId: string;
          nexMessageId: string;
          nexResponse: string;
          sessionMode: NexMode;
          extractedText: string;
        };
        error?: { message?: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        throw new Error(payload.error?.message ?? "Camera upload failed.");
      }

      onPhotoProcessed({
        studentMessage: `Photo question:\n${payload.data.extractedText}`,
        nexResponse: payload.data.nexResponse,
        nexSessionId: payload.data.nexSessionId,
        nexMessageId: payload.data.nexMessageId,
        sessionMode: payload.data.sessionMode,
      });
    } catch (uploadError) {
      onError(
        uploadError instanceof Error
          ? uploadError.message
          : "Could not process photo.",
      );
    } finally {
      setIsUploading(false);
    }
  }

  return (
    <div className={cn("flex items-center gap-2", className)}>
      <input
        ref={inputRef}
        type="file"
        accept="image/jpeg,image/png,image/webp"
        capture="environment"
        className="sr-only"
        data-testid="nex-camera-input"
        onChange={handleFileChange}
      />
      <Button
        type="button"
        variant="secondary"
        size="sm"
        data-testid="nex-camera-button"
        disabled={disabled || isUploading}
        onClick={() => inputRef.current?.click()}
        className="min-h-10"
      >
        {isUploading ? "Reading photo..." : "Camera"}
      </Button>
    </div>
  );
}
