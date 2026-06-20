import Link from "next/link";

import { Button } from "@/components/ui/Button";
import { cn } from "@/lib/utils";

interface EmptyStateAction {
  label: string;
  href?: string;
  onClick?: () => void;
}

interface EmptyStateProps {
  icon?: React.ReactNode;
  title: string;
  description: string;
  primaryAction?: EmptyStateAction;
  secondaryAction?: EmptyStateAction;
  className?: string;
}

export function EmptyState({
  icon,
  title,
  description,
  primaryAction,
  secondaryAction,
  className,
}: EmptyStateProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center rounded-[22px] border border-nexus-border bg-nexus-surface px-6 py-10 text-center shadow-card",
        className,
      )}
    >
      {icon ? (
        <div className="mb-4 flex size-14 items-center justify-center rounded-2xl bg-nexus-primary-soft text-nexus-primary">
          {icon}
        </div>
      ) : null}
      <h2 className="font-heading text-lg font-semibold text-foreground">
        {title}
      </h2>
      <p className="mt-2 max-w-md text-sm leading-relaxed text-muted-foreground">
        {description}
      </p>
      {primaryAction || secondaryAction ? (
        <div className="mt-6 flex flex-col gap-2 sm:flex-row sm:flex-wrap sm:justify-center">
          {primaryAction ? (
            <EmptyStateButton action={primaryAction} variant="default" />
          ) : null}
          {secondaryAction ? (
            <EmptyStateButton action={secondaryAction} variant="outline" />
          ) : null}
        </div>
      ) : null}
    </div>
  );
}

function EmptyStateButton({
  action,
  variant,
}: {
  action: EmptyStateAction;
  variant: "default" | "outline";
}) {
  const className = "min-h-12 px-5";

  if (action.href) {
    return (
      <Button render={<Link href={action.href} />} variant={variant} className={className}>
        {action.label}
      </Button>
    );
  }

  return (
    <Button type="button" variant={variant} className={className} onClick={action.onClick}>
      {action.label}
    </Button>
  );
}
