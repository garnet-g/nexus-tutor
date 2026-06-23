import Link from "next/link";
import type { ReactNode } from "react";

import { cn } from "@/lib/utils";

interface PageHeaderProps {
  eyebrow?: string;
  title: string;
  description?: ReactNode;
  actions?: ReactNode;
}

/** Consistent page heading for every admin screen. */
export function PageHeader({ eyebrow, title, description, actions }: PageHeaderProps) {
  return (
    <div className="flex flex-wrap items-end justify-between gap-4 border-b border-nexus-border pb-5">
      <div className="space-y-1">
        {eyebrow ? (
          <p className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">
            {eyebrow}
          </p>
        ) : null}
        <h1 className="font-heading text-2xl font-semibold tracking-tight text-foreground">
          {title}
        </h1>
        {description ? (
          <p className="max-w-2xl text-sm text-muted-foreground">{description}</p>
        ) : null}
      </div>
      {actions ? <div className="flex items-center gap-2">{actions}</div> : null}
    </div>
  );
}

interface PanelProps {
  title?: string;
  description?: ReactNode;
  action?: ReactNode;
  children: ReactNode;
  className?: string;
  bodyClassName?: string;
  /** Set false for flush content like tables. */
  padded?: boolean;
}

/** Neutral surface card used to group admin content. */
export function Panel({
  title,
  description,
  action,
  children,
  className,
  bodyClassName,
  padded = true,
}: PanelProps) {
  const hasHeader = title || description || action;
  return (
    <section
      className={cn(
        "overflow-hidden rounded-2xl border border-nexus-border bg-nexus-surface",
        className,
      )}
    >
      {hasHeader ? (
        <div className="flex flex-wrap items-start justify-between gap-3 border-b border-nexus-border px-5 py-4">
          <div className="space-y-1">
            {title ? (
              <h2 className="font-heading text-base font-semibold text-foreground">
                {title}
              </h2>
            ) : null}
            {description ? (
              <p className="text-sm text-muted-foreground">{description}</p>
            ) : null}
          </div>
          {action}
        </div>
      ) : null}
      <div className={cn(padded && "p-5", bodyClassName)}>{children}</div>
    </section>
  );
}

interface StatCardProps {
  label: string;
  value: ReactNode;
  hint?: ReactNode;
  icon?: ReactNode;
}

/** Compact metric tile with restrained accent. */
export function StatCard({ label, value, hint, icon }: StatCardProps) {
  return (
    <div className="rounded-2xl border border-nexus-border bg-nexus-surface p-5">
      <div className="flex items-start justify-between gap-3">
        <p className="text-sm text-muted-foreground">{label}</p>
        {icon ? (
          <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/15 text-primary">
            {icon}
          </span>
        ) : null}
      </div>
      <p className="mt-2 font-heading text-3xl font-semibold tabular-nums text-foreground">
        {value}
      </p>
      {hint ? <p className="mt-1 text-xs text-muted-foreground">{hint}</p> : null}
    </div>
  );
}

export type BadgeTone = "success" | "warning" | "danger" | "neutral" | "info";

const BADGE_TONE: Record<BadgeTone, string> = {
  success: "bg-primary/15 text-primary",
  warning: "bg-nexus-accent-soft text-nexus-warning",
  danger: "bg-nexus-danger/15 text-nexus-danger",
  neutral: "bg-nexus-sunken text-muted-foreground",
  info: "bg-nexus-secondary/15 text-nexus-secondary",
};

interface StatusBadgeProps {
  children: ReactNode;
  tone?: BadgeTone;
  className?: string;
}

/** Pill badge used for statuses across admin tables. */
export function StatusBadge({ children, tone = "neutral", className }: StatusBadgeProps) {
  return (
    <span
      className={cn(
        "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium capitalize",
        BADGE_TONE[tone],
        className,
      )}
    >
      {children}
    </span>
  );
}

interface EmptyStateProps {
  title: string;
  description?: ReactNode;
  icon?: ReactNode;
  action?: ReactNode;
  className?: string;
}

/** Centered empty state for panels and tables with no data. */
export function EmptyState({ title, description, icon, action, className }: EmptyStateProps) {
  return (
    <div
      className={cn(
        "flex flex-col items-center justify-center gap-2 px-6 py-12 text-center",
        className,
      )}
    >
      {icon ? (
        <span className="flex h-11 w-11 items-center justify-center rounded-xl bg-nexus-sunken text-muted-foreground">
          {icon}
        </span>
      ) : null}
      <p className="font-medium text-foreground">{title}</p>
      {description ? (
        <p className="max-w-sm text-sm text-muted-foreground">{description}</p>
      ) : null}
      {action ? <div className="mt-2">{action}</div> : null}
    </div>
  );
}

interface FilterTabsOption {
  value: string;
  label: string;
}

interface FilterTabsProps {
  options: readonly FilterTabsOption[];
  activeValue: string;
  /** Builds the href for a given option value. */
  hrefFor: (value: string) => string;
  className?: string;
}

/** Link-based pill filter group (preserves server-rendered query-param navigation). */
export function FilterTabs({ options, activeValue, hrefFor, className }: FilterTabsProps) {
  return (
    <div className={cn("flex flex-wrap gap-1", className)}>
      {options.map((option) => {
        const isActive = activeValue === option.value;
        return (
          <Link
            key={option.value || "all"}
            href={hrefFor(option.value)}
            aria-current={isActive ? "true" : undefined}
            className={cn(
              "rounded-lg px-3 py-1.5 text-xs font-medium transition-colors",
              isActive
                ? "bg-primary/15 text-foreground"
                : "text-muted-foreground hover:bg-nexus-sunken hover:text-foreground",
            )}
          >
            {option.label}
          </Link>
        );
      })}
    </div>
  );
}

interface SearchInputProps {
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  className?: string;
  "aria-label"?: string;
}

/**
 * Controlled search input with a clear button. Presentational (no hooks) so it
 * is usable from both server and client components.
 */
export function SearchInput({
  value,
  onChange,
  placeholder = "Search…",
  className,
  "aria-label": ariaLabel,
}: SearchInputProps) {
  return (
    <div className={cn("relative", className)}>
      <svg
        viewBox="0 0 24 24"
        width="15"
        height="15"
        fill="none"
        stroke="currentColor"
        strokeWidth="1.8"
        strokeLinecap="round"
        strokeLinejoin="round"
        aria-hidden
        className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-muted-foreground"
      >
        <circle cx="11" cy="11" r="8" />
        <path d="m21 21-4.3-4.3" />
      </svg>
      <input
        type="search"
        value={value}
        onChange={(event) => onChange(event.target.value)}
        placeholder={placeholder}
        aria-label={ariaLabel ?? placeholder}
        className="w-56 rounded-lg border border-nexus-border bg-nexus-sunken py-1.5 pl-9 pr-3 text-sm text-foreground outline-none transition-colors placeholder:text-muted-foreground/70 focus:border-primary focus:ring-2 focus:ring-primary/20"
      />
    </div>
  );
}
