"use client";

import { useEffect } from "react";

import { EmptyState } from "@/components/ui/EmptyState";

export default function ParentError({
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
      description="We couldn't load your parent dashboard. Try again or return home."
      primaryAction={{ label: "Try again", onClick: reset }}
      secondaryAction={{ label: "Parent home", href: "/parent" }}
    />
  );
}
