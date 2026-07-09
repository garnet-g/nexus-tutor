"use client";

import Link from "next/link";
import { Camera, Lock } from "lucide-react";
import { useRef, useState } from "react";

import { Button } from "@/components/ui/Button";
import { downscaleImageFile } from "@/features/nex/lib/downscaleImage";
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
  compact?: boolean;
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
  compact = false,
  className,
}: CameraCaptureButtonProps) {
  const inputRef = useRef<HTMLInputElement>(null);
  const [isUploading, setIsUploading] = useState(false);

  if (!CAMERA_MODES.includes(sessionMode as CameraMode)) {
    return null;
  }

  if (!cameraEnabled) {
    if (compact) {
      return (
        <Link
          href="/pricing"
          aria-label="Upgrade for camera tutoring"
          className={cn(
            "inline-flex min-h-10 items-center gap-1.5 rounded-xl border border-dashed border-nexus-border bg-nexus-surface px-3 text-xs font-medium text-muted-foreground transition-colors hover:border-nexus-primary/40 hover:text-nexus-primary focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
            className,
          )}
        >
          <Lock className="size-3.5" aria-hidden />
          <Camera className="size-3.5" aria-hidden />
          Camera
        </Link>
      );
    }

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
      const uploadFile = await downscaleImageFile(file).catch(() => file);

      const body = new FormData();
      body.append("image", uploadFile);
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
        size={compact ? "icon-lg" : "sm"}
        data-testid="nex-camera-button"
        disabled={disabled || isUploading}
        onClick={() => inputRef.current?.click()}
        className={cn(!compact && "min-h-10")}
        aria-label={isUploading ? "Reading photo" : "Camera tutoring"}
      >
        {compact ? (
          <Camera className="size-4" aria-hidden />
        ) : isUploading ? (
          "Reading photo..."
        ) : (
          "Camera"
        )}
      </Button>
    </div>
  );
}
