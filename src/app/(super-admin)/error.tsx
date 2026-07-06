"use client";

import { useEffect } from "react";

import { EmptyState } from "@/components/ui/EmptyState";

export default function AdminError({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  useEffect(() => {
    console.error(error);
  }, [error]);

  return (
    <EmptyState
      title="Admin page failed to load"
      description="An unexpected error occurred. Retry or return to the admin overview."
      primaryAction={{ label: "Try again", onClick: reset }}
      secondaryAction={{ label: "Admin home", href: "/admin" }}
    />
  );
}
