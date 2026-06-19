import Link from "next/link";

import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";
import { cn } from "@/lib/utils";

interface StatCardProps {
  label: string;
  value: React.ReactNode;
  /** What is happening — metric context or current state. */
  description?: string;
  /** Why it matters — actionable insight for the student. */
  insight?: string;
  href?: string;
  linkLabel?: string;
  className?: string;
  accent?: "primary" | "secondary" | "accent" | "default";
}

const accentBar = {
  primary: "bg-primary",
  secondary: "bg-nexus-secondary",
  accent: "bg-nexus-accent",
  default: "bg-muted-foreground/30",
} as const;

export function StatCard({
  label,
  value,
  description,
  insight,
  href,
  linkLabel,
  className,
  accent = "default",
}: StatCardProps) {
  return (
    <Card className={cn("nexus-card-elevated relative overflow-hidden", className)}>
      <div
        className={cn("absolute inset-x-0 top-0 h-1", accentBar[accent])}
        aria-hidden
      />
      <CardHeader className="pb-0">
        <CardDescription className="text-xs font-medium uppercase tracking-[0.12em]">
          {label}
        </CardDescription>
        <CardTitle className="font-heading text-3xl font-semibold tracking-tight">
          {value}
        </CardTitle>
      </CardHeader>
      {(description || insight || href) && (
        <CardContent className="flex flex-col gap-3 pt-2">
          {description ? (
            <p className="text-sm leading-relaxed text-muted-foreground">{description}</p>
          ) : null}
          {insight ? (
            <p className="text-sm leading-relaxed text-foreground/80">{insight}</p>
          ) : null}
          {href && linkLabel ? (
            <Link
              href={href}
              className="text-sm font-medium text-primary transition-colors hover:text-primary/80"
            >
              {linkLabel} →
            </Link>
          ) : null}
        </CardContent>
      )}
    </Card>
  );
}
