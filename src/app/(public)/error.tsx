"use client";

import { useEffect } from "react";

import { EmptyState } from "@/components/ui/EmptyState";

export default function PublicError({
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
      title="Page unavailable"
      description="We hit a snag loading this page. Try again or head back to the homepage."
      primaryAction={{ label: "Try again", onClick: reset }}
      secondaryAction={{ label: "Home", href: "/" }}
    />
  );
}
