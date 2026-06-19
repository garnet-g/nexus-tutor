"use client";

import Link from "next/link";
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
        className="min-h-12 min-w-12 touch-none select-none px-4"
        aria-pressed={isRecording}
        aria-label={label}
      >
        {label}
      </Button>
      <span className="text-xs text-muted-foreground">
        Push-to-talk · max {VOICE_MAX_DURATION_SECONDS}s
      </span>
    </div>
  );
}
