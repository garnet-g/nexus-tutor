import Link from "next/link";
import type { LucideIcon } from "lucide-react";
import { ArrowRight } from "lucide-react";

import { cn } from "@/lib/utils";

export function StudentPageHeader({
  eyebrow,
  title,
  description,
  action,
}: {
  eyebrow: string;
  title: string;
  description: string;
  action?: { href: string; label: string };
}) {
  return (
    <header className="flex flex-col gap-4 sm:flex-row sm:items-end sm:justify-between">
      <div className="space-y-2">
        <p className="text-xs font-semibold uppercase tracking-[0.18em] text-muted-foreground">
          {eyebrow}
        </p>
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          {title}
        </h1>
        <p className="max-w-2xl text-sm leading-relaxed text-muted-foreground">
          {description}
        </p>
      </div>
      {action ? (
        <Link
          href={action.href}
          className="inline-flex h-10 items-center justify-center gap-2 rounded-xl bg-nexus-primary px-4 text-sm font-semibold text-nexus-text-inverse transition-colors hover:bg-nexus-primary-hover"
        >
          {action.label}
          <ArrowRight className="size-4" />
        </Link>
      ) : null}
    </header>
  );
}

export function MetricRow({
  metrics,
}: {
  metrics: Array<{ label: string; value: string | number; detail?: string }>;
}) {
  return (
    <section className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
      {metrics.map((metric) => (
        <div
          key={metric.label}
          className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
        >
          <p className="text-xs text-muted-foreground">{metric.label}</p>
          <p className="mt-1 font-heading text-2xl font-semibold tabular text-foreground">
            {metric.value}
          </p>
          {metric.detail ? (
            <p className="mt-1 text-xs text-muted-foreground">{metric.detail}</p>
          ) : null}
        </div>
      ))}
    </section>
  );
}

export function LinkedPanel({
  href,
  title,
  description,
  eyebrow,
  icon: Icon,
  count,
  tone = "default",
}: {
  href: string;
  title: string;
  description: string;
  eyebrow?: string;
  icon?: LucideIcon;
  count?: string | number;
  tone?: "default" | "accent" | "primary";
}) {
  return (
    <Link
      href={href}
      className={cn(
        "group block rounded-2xl border p-4 transition-transform active:scale-[0.99]",
        tone === "primary"
          ? "border-nexus-primary/30 bg-nexus-primary-soft"
          : tone === "accent"
            ? "border-nexus-accent/40 bg-nexus-accent-soft"
            : "border-nexus-border bg-nexus-surface hover:bg-nexus-sunken",
      )}
    >
      <div className="flex items-start gap-3">
        {Icon ? (
          <span className="flex size-10 flex-none items-center justify-center rounded-xl bg-nexus-background text-nexus-primary">
            <Icon className="size-5" />
          </span>
        ) : null}
        <div className="min-w-0 flex-1">
          {eyebrow ? (
            <p className="text-[11px] font-semibold uppercase tracking-[0.16em] text-muted-foreground">
              {eyebrow}
            </p>
          ) : null}
          <p className="font-semibold text-foreground">{title}</p>
          <p className="mt-1 text-sm leading-relaxed text-muted-foreground">
            {description}
          </p>
        </div>
        {count !== undefined ? (
          <span className="rounded-full bg-nexus-background px-2 py-1 text-xs font-semibold tabular text-foreground">
            {count}
          </span>
        ) : (
          <ArrowRight className="size-4 text-nexus-text-muted opacity-0 transition-opacity group-hover:opacity-100" />
        )}
      </div>
    </Link>
  );
}

export function EmptyStudentState({
  title,
  description,
  href,
  label,
}: {
  title: string;
  description: string;
  href?: string;
  label?: string;
}) {
  return (
    <div className="rounded-2xl border border-dashed border-nexus-border bg-nexus-surface p-6 text-center">
      <p className="font-semibold text-foreground">{title}</p>
      <p className="mx-auto mt-1 max-w-md text-sm leading-relaxed text-muted-foreground">
        {description}
      </p>
      {href && label ? (
        <Link
          href={href}
          className="mt-4 inline-flex h-10 items-center justify-center rounded-xl bg-nexus-primary px-4 text-sm font-semibold text-nexus-text-inverse transition-colors hover:bg-nexus-primary-hover"
        >
          {label}
        </Link>
      ) : null}
    </div>
  );
}
