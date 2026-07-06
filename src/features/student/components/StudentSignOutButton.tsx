"use client";

import { purgeOfflineCaches } from "@/lib/offline/offlineStorage";
import { signOutAction } from "@/server/actions/authActions";

export function StudentSignOutButton({
  studentId,
  className,
  label = "Sign out",
}: {
  studentId?: string | null;
  className?: string;
  label?: string;
}) {
  return (
    <button
      type="button"
      className={className}
      onClick={() => {
        void (async () => {
          await purgeOfflineCaches(studentId);
          await signOutAction();
        })();
      }}
    >
      {label}
    </button>
  );
}
