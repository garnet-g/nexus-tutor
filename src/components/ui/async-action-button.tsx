"use client";

import type { ComponentProps } from "react";

import { Button } from "@/components/ui/Button";

interface AsyncActionButtonProps extends Omit<ComponentProps<typeof Button>, "children"> {
  isPending?: boolean;
  idleLabel: string;
  pendingLabel?: string;
}

export function AsyncActionButton({
  isPending = false,
  idleLabel,
  pendingLabel = "Please wait...",
  disabled,
  ...props
}: AsyncActionButtonProps) {
  return (
    <Button {...props} disabled={disabled || isPending} aria-busy={isPending}>
      {isPending ? pendingLabel : idleLabel}
    </Button>
  );
}
