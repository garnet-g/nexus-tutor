"use client";

import { useEffect } from "react";

import { rememberOfflineStudentNamespace } from "@/lib/offline/offlineStorage";

export function OfflineRuntimeBootstrap({ studentId }: { studentId?: string | null }) {
  useEffect(() => {
    if (!studentId || typeof window === "undefined") {
      return;
    }

    rememberOfflineStudentNamespace(studentId);

    if ("serviceWorker" in navigator) {
      void navigator.serviceWorker.register("/sw.js").catch((error) => {
        console.error("OFFLINE_SW_REGISTER_FAILED", error);
      });
    }
  }, [studentId]);

  return null;
}
