"use client";

import Link from "next/link";
import { Lock, Mic } from "lucide-react";
import { useEffect, useRef, useState } from "react";

import { Button } from "@/components/ui/Button";
import type { NexMode } from "@/lib/nex/types";
import { cn } from "@/lib/utils";
import { VOICE_MAX_DURATION_SECONDS } from "@/schemas/voiceSchemas";

interface VoicePushToTalkProps {
  sessionMode: NexMode;
  sessionId: string | null;
  topicId: string | null;
  voiceEnabled: boolean;
  disabled?: boolean;
  onVoiceProcessed: (payload: {
    transcript: string;
    nexResponse: string;
    nexSessionId: string;
    nexMessageId: string;
    sessionMode: NexMode;
    audioBase64: string;
    audioMimeType: string;
  }) => void;
  onError: (message: string) => void;
  compact?: boolean;
  className?: string;
}

function pickRecorderMimeType(): string | undefined {
  const candidates = [
    "audio/webm;codecs=opus",
    "audio/webm",
    "audio/ogg;codecs=opus",
    "audio/mp4",
  ];

  for (const candidate of candidates) {
    if (typeof MediaRecorder !== "undefined" && MediaRecorder.isTypeSupported(candidate)) {
      return candidate;
    }
  }

  return undefined;
}

export function VoicePushToTalk({
  sessionMode,
  sessionId,
  topicId,
  voiceEnabled,
  disabled = false,
  onVoiceProcessed,
  onError,
  compact = false,
  className,
}: VoicePushToTalkProps) {
  const mediaRecorderRef = useRef<MediaRecorder | null>(null);
  const mediaStreamRef = useRef<MediaStream | null>(null);
  const chunksRef = useRef<Blob[]>([]);
  const startedAtRef = useRef<number | null>(null);
  const stopTimeoutRef = useRef<number | null>(null);
  const [isRecording, setIsRecording] = useState(false);
  const [isUploading, setIsUploading] = useState(false);
  const [permissionDenied, setPermissionDenied] = useState(false);

  useEffect(() => {
    return () => {
      if (stopTimeoutRef.current) {
        window.clearTimeout(stopTimeoutRef.current);
      }
      mediaStreamRef.current?.getTracks().forEach((track) => track.stop());
    };
  }, []);

  if (!voiceEnabled) {
    if (compact) {
      return (
        <Link
          href="/pricing"
          aria-label="Upgrade for voice tutoring"
          className={cn(
            "inline-flex min-h-10 items-center gap-1.5 rounded-xl border border-dashed border-nexus-border bg-nexus-surface px-3 text-xs font-medium text-muted-foreground transition-colors hover:border-nexus-primary/40 hover:text-nexus-primary focus-visible:outline-none focus-visible:ring-3 focus-visible:ring-ring/50",
            className,
          )}
        >
          <Lock className="size-3.5" aria-hidden />
          <Mic className="size-3.5" aria-hidden />
          Voice
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
        Voice tutoring is a Premium feature.{" "}
        <Link href="/pricing" className="font-medium text-primary underline-offset-4 hover:underline">
          Upgrade
        </Link>
      </div>
    );
  }

  async function uploadRecording(blob: Blob, durationSeconds: number) {
    setIsUploading(true);

    try {
      const body = new FormData();
      body.append("audio", blob, "voice.webm");
      body.append("sessionMode", sessionMode);
      body.append("durationSeconds", String(durationSeconds));
      if (sessionId) {
        body.append("nexSessionId", sessionId);
      }
      if (topicId) {
        body.append("topicId", topicId);
      }

      const response = await fetch("/api/nex/voice", {
        method: "POST",
        body,
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: {
          nexSessionId: string;
          nexMessageId: string;
          nexResponse: string;
          transcript: string;
          sessionMode: NexMode;
          audioBase64: string;
          audioMimeType: string;
        };
        error?: { message?: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        throw new Error(payload.error?.message ?? "Voice upload failed.");
      }

      onVoiceProcessed({
        transcript: payload.data.transcript,
        nexResponse: payload.data.nexResponse,
        nexSessionId: payload.data.nexSessionId,
        nexMessageId: payload.data.nexMessageId,
        sessionMode: payload.data.sessionMode,
        audioBase64: payload.data.audioBase64,
        audioMimeType: payload.data.audioMimeType,
      });

      const audio = new Audio(
        `data:${payload.data.audioMimeType};base64,${payload.data.audioBase64}`,
      );
      await audio.play().catch(() => undefined);
    } catch (uploadError) {
      onError(
        uploadError instanceof Error
          ? uploadError.message
          : "Could not process voice message.",
      );
    } finally {
      setIsUploading(false);
    }
  }

  async function startRecording() {
    if (isRecording || isUploading || disabled) {
      return;
    }

    try {
      const stream = await navigator.mediaDevices.getUserMedia({ audio: true });
      mediaStreamRef.current = stream;
      setPermissionDenied(false);

      const mimeType = pickRecorderMimeType();
      const recorder = mimeType
        ? new MediaRecorder(stream, { mimeType })
        : new MediaRecorder(stream);

      chunksRef.current = [];
      recorder.ondataavailable = (event) => {
        if (event.data.size > 0) {
          chunksRef.current.push(event.data);
        }
      };

      recorder.onstop = () => {
        const startedAt = startedAtRef.current ?? Date.now();
        const durationSeconds = Math.min(
          VOICE_MAX_DURATION_SECONDS,
          Math.max(1, Math.round((Date.now() - startedAt) / 1000)),
        );
        const blob = new Blob(chunksRef.current, {
          type: recorder.mimeType || mimeType || "audio/webm",
        });

        mediaStreamRef.current?.getTracks().forEach((track) => track.stop());
        mediaStreamRef.current = null;
        mediaRecorderRef.current = null;
        startedAtRef.current = null;
        setIsRecording(false);

        if (blob.size > 0) {
          void uploadRecording(blob, durationSeconds);
        }
      };

      mediaRecorderRef.current = recorder;
      startedAtRef.current = Date.now();
      recorder.start();
      setIsRecording(true);

      stopTimeoutRef.current = window.setTimeout(() => {
        stopRecording();
      }, VOICE_MAX_DURATION_SECONDS * 1000);
    } catch {
      setPermissionDenied(true);
      onError("Microphone permission is required for voice tutoring.");
    }
  }

  function stopRecording() {
    if (stopTimeoutRef.current) {
      window.clearTimeout(stopTimeoutRef.current);
      stopTimeoutRef.current = null;
    }

    const recorder = mediaRecorderRef.current;
    if (recorder && recorder.state !== "inactive") {
      recorder.stop();
    }
  }

  const label = permissionDenied
    ? "Allow microphone access"
    : isUploading
      ? "Nex is responding..."
      : isRecording
        ? "Release to send"
        : "Hold to talk";

  return (
    <div className={cn("flex items-center gap-2", className)}>
      <Button
        type="button"
        variant={isRecording ? "primary" : "secondary"}
        size={compact ? "icon-lg" : "default"}
        data-testid="nex-voice-button"
        disabled={disabled || isUploading}
        onPointerDown={(event) => {
          event.preventDefault();
          void startRecording();
        }}
        onPointerUp={(event) => {
          event.preventDefault();
          stopRecording();
        }}
        onPointerLeave={() => {
          if (isRecording) {
            stopRecording();
          }
        }}
        onPointerCancel={() => {
          if (isRecording) {
            stopRecording();
          }
        }}
        className={cn(
          "touch-none select-none",
          compact ? "min-h-10 min-w-10 px-0" : "min-h-12 min-w-12 px-4",
        )}
        aria-pressed={isRecording}
        aria-label={label}
      >
        {compact ? <Mic className="size-4" aria-hidden /> : label}
      </Button>
      <span className={cn("text-xs text-muted-foreground", compact && "sr-only")}>
        Push-to-talk · max {VOICE_MAX_DURATION_SECONDS}s
      </span>
    </div>
  );
}
