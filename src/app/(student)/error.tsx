"use client";

import { useEffect } from "react";

import { EmptyState } from "@/components/ui/EmptyState";

export default function StudentError({
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
      title="Something went wrong"
      description="We couldn't load this page. Try again, or head back to your dashboard."
      primaryAction={{ label: "Try again", onClick: reset }}
      secondaryAction={{ label: "Back to Today", href: "/dashboard" }}
    />
  );
}
