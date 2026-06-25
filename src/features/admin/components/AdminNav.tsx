"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import type { ReactElement, SVGProps } from "react";

import { cn } from "@/lib/utils";

type IconProps = SVGProps<SVGSVGElement> & { size?: number };

function svg({ size = 18, ...props }: IconProps) {
  return {
    width: size,
    height: size,
    viewBox: "0 0 24 24",
    fill: "none",
    stroke: "currentColor",
    strokeWidth: 1.8,
    strokeLinecap: "round" as const,
    strokeLinejoin: "round" as const,
    "aria-hidden": true,
    ...props,
  };
}

function SettingsIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <circle cx="12" cy="12" r="3" />
      <path d="M19.4 15a1.65 1.65 0 0 0 .33 1.82l.06.06a2 2 0 1 1-2.83 2.83l-.06-.06a1.65 1.65 0 0 0-1.82-.33 1.65 1.65 0 0 0-1 1.51V21a2 2 0 0 1-4 0v-.09A1.65 1.65 0 0 0 9 19.4a1.65 1.65 0 0 0-1.82.33l-.06.06a2 2 0 1 1-2.83-2.83l.06-.06a1.65 1.65 0 0 0 .33-1.82 1.65 1.65 0 0 0-1.51-1H3a2 2 0 0 1 0-4h.09A1.65 1.65 0 0 0 4.6 9a1.65 1.65 0 0 0-.33-1.82l-.06-.06a2 2 0 1 1 2.83-2.83l.06.06a1.65 1.65 0 0 0 1.82.33H9a1.65 1.65 0 0 0 1-1.51V3a2 2 0 0 1 4 0v.09a1.65 1.65 0 0 0 1 1.51 1.65 1.65 0 0 0 1.82-.33l.06-.06a2 2 0 1 1 2.83 2.83l-.06.06a1.65 1.65 0 0 0-.33 1.82V9a1.65 1.65 0 0 0 1.51 1H21a2 2 0 0 1 0 4h-.09a1.65 1.65 0 0 0-1.51 1Z" />
    </svg>
  );
}

function TicketIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <path d="M2 9a3 3 0 0 1 0 6v2a2 2 0 0 0 2 2h16a2 2 0 0 0 2-2v-2a3 3 0 0 1 0-6V7a2 2 0 0 0-2-2H4a2 2 0 0 0-2 2Z" />
      <path d="M13 5v2" />
      <path d="M13 17v2" />
      <path d="M13 11v2" />
    </svg>
  );
}

function UsersIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <path d="M16 21v-2a4 4 0 0 0-4-4H6a4 4 0 0 0-4 4v2" />
      <circle cx="9" cy="7" r="4" />
      <path d="M22 21v-2a4 4 0 0 0-3-3.87" />
      <path d="M16 3.13a4 4 0 0 1 0 7.75" />
    </svg>
  );
}

function LayersIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <path d="m12 2 9 5-9 5-9-5 9-5Z" />
      <path d="m3 12 9 5 9-5" />
      <path d="m3 17 9 5 9-5" />
    </svg>
  );
}

function ClipboardCheckIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <rect x="8" y="2" width="8" height="4" rx="1" />
      <path d="M16 4h2a2 2 0 0 1 2 2v14a2 2 0 0 1-2 2H6a2 2 0 0 1-2-2V6a2 2 0 0 1 2-2h2" />
      <path d="m9 14 2 2 4-4" />
    </svg>
  );
}

function BarChartIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <path d="M3 3v18h18" />
      <rect x="7" y="11" width="3" height="6" rx="1" />
      <rect x="12" y="7" width="3" height="10" rx="1" />
      <rect x="17" y="13" width="3" height="4" rx="1" />
    </svg>
  );
}

function WalletIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <path d="M3 7a2 2 0 0 1 2-2h13a1 1 0 0 1 1 1v2" />
      <path d="M3 7v10a2 2 0 0 0 2 2h14a2 2 0 0 0 2-2v-6a2 2 0 0 0-2-2H5a2 2 0 0 1-2-2Z" />
      <circle cx="16" cy="13" r="1" />
    </svg>
  );
}

function TrendingUpIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <path d="m3 17 6-6 4 4 7-7" />
      <path d="M14 8h6v6" />
    </svg>
  );
}

function CpuIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <rect x="6" y="6" width="12" height="12" rx="2" />
      <path d="M9 2v3M15 2v3M9 19v3M15 19v3M2 9h3M2 15h3M19 9h3M19 15h3" />
      <rect x="9.5" y="9.5" width="5" height="5" rx="1" />
    </svg>
  );
}

function ShieldIcon(props: IconProps) {
  return (
    <svg {...svg(props)}>
      <path d="M12 2 4 5v6c0 5 3.4 7.7 8 9 4.6-1.3 8-4 8-9V5Z" />
      <path d="m9 12 2 2 4-4" />
    </svg>
  );
}

type NavItem = {
  href: string;
  label: string;
  icon: (props: IconProps) => ReactElement;
};

type NavGroup = {
  label: string;
  items: NavItem[];
};

export const ADMIN_PRIMARY_HREF = "/admin";

export const ADMIN_NAV_GROUPS: NavGroup[] = [
  {
    label: "Overview",
    items: [
      { href: "/admin", label: "Dashboard", icon: BarChartIcon },
      { href: "/admin/inbox", label: "Task inbox", icon: ClipboardCheckIcon },
      { href: "/admin/search", label: "Search", icon: BarChartIcon },
      { href: "/admin/reports", label: "Reports", icon: BarChartIcon },
    ],
  },
  {
    label: "People",
    items: [
      { href: "/admin/users", label: "Users", icon: UsersIcon },
      { href: "/admin/roles", label: "Roles", icon: UsersIcon },
      { href: "/admin/support", label: "Support", icon: ShieldIcon },
      { href: "/admin/communications", label: "Communications", icon: TicketIcon },
    ],
  },
  {
    label: "Learning",
    items: [
      { href: "/admin/studio", label: "Content", icon: LayersIcon },
      { href: "/admin/content-calendar", label: "Content calendar", icon: ClipboardCheckIcon },
      { href: "/admin/assessment", label: "Assessment", icon: ClipboardCheckIcon },
      { href: "/admin/ai-quality", label: "AI quality", icon: CpuIcon },
      { href: "/admin/outcomes", label: "Outcomes", icon: TrendingUpIcon },
    ],
  },
  {
    label: "Revenue",
    items: [
      { href: "/admin/payments", label: "Payments", icon: WalletIcon },
      { href: "/admin/revenue-ops", label: "Revenue ops", icon: WalletIcon },
      { href: "/admin/campaigns", label: "Campaigns", icon: TrendingUpIcon },
    ],
  },
  {
    label: "Growth",
    items: [
      { href: "/admin/beta-invites", label: "Beta invites", icon: TicketIcon },
      { href: "/admin/experiments", label: "Experiments", icon: TrendingUpIcon },
      { href: "/admin/rollouts", label: "Rollouts", icon: SettingsIcon },
    ],
  },
  {
    label: "Operations",
    items: [
      { href: "/admin/alerts", label: "Alerts", icon: ShieldIcon },
      { href: "/admin/bulk-actions", label: "Bulk actions", icon: ClipboardCheckIcon },
      { href: "/admin/approvals", label: "Approvals", icon: ClipboardCheckIcon },
      { href: "/admin/saved-views", label: "Saved views", icon: LayersIcon },
    ],
  },
  {
    label: "System",
    items: [
      { href: "/admin/health", label: "System health", icon: SettingsIcon },
      { href: "/admin/usage-stats", label: "Usage stats", icon: BarChartIcon },
      { href: "/admin/nex-ops", label: "Nex ops", icon: CpuIcon },
      { href: "/admin/platform-settings", label: "Platform settings", icon: SettingsIcon },
      { href: "/admin/audit-log", label: "Audit log", icon: ShieldIcon },
    ],
  },
];

const NAV_ITEMS = ADMIN_NAV_GROUPS.flatMap((group) => group.items);

function isActive(pathname: string, href: string): boolean {
  if (href === "/admin") {
    return pathname === "/admin";
  }
  return pathname === href || pathname.startsWith(`${href}/`);
}

/** Vertical sidebar navigation (md and up). */
export function AdminSidebarNav() {
  const pathname = usePathname();

  return (
    <nav className="space-y-3" aria-label="Admin sections">
      {ADMIN_NAV_GROUPS.map((group) => (
        <section
          key={group.label}
          className="rounded-2xl border border-nexus-border/70 bg-nexus-surface/55 p-1.5 shadow-[inset_0_1px_0_rgb(255_255_255/0.03)]"
        >
          <div className="flex items-center justify-between gap-3 px-2 pb-1 pt-1.5">
            <p className="text-[10px] font-semibold uppercase tracking-[0.18em] text-muted-foreground/75">
              {group.label}
            </p>
            <span className="font-mono text-[10px] tabular-nums text-muted-foreground/55">
              {group.items.length}
            </span>
          </div>
          <div className="space-y-0.5">
            {group.items.map(({ href, label, icon: Icon }) => {
              const active = isActive(pathname, href);
              return (
                <Link
                  key={href}
                  href={href}
                  aria-current={active ? "page" : undefined}
                  className={cn(
                    "group relative flex min-h-9 items-center gap-2.5 rounded-xl px-2.5 py-2 text-sm font-medium transition-all duration-200 active:translate-y-px",
                    active
                      ? "bg-primary text-primary-foreground shadow-[0_8px_18px_rgb(21_86_75/0.18)]"
                      : "text-muted-foreground hover:bg-nexus-sunken hover:text-foreground",
                  )}
                >
                  <Icon
                    className={cn(
                      "shrink-0 transition-colors",
                      active
                        ? "text-primary-foreground"
                        : "text-muted-foreground/75 group-hover:text-foreground",
                    )}
                    size={17}
                  />
                  <span className="truncate">{label}</span>
                </Link>
              );
            })}
          </div>
        </section>
      ))}
    </nav>
  );
}

/** Horizontal scrollable nav fallback for small screens. */
export function AdminMobileNav() {
  const pathname = usePathname();

  return (
    <nav
      className="flex gap-1 overflow-x-auto pb-1 md:hidden"
      aria-label="Admin sections"
    >
      {NAV_ITEMS.map(({ href, label, icon: Icon }) => {
        const active = isActive(pathname, href);
        return (
          <Link
            key={href}
            href={href}
            aria-current={active ? "page" : undefined}
            className={cn(
              "flex shrink-0 items-center gap-2 rounded-lg px-3 py-2 text-sm font-medium transition-colors",
              active
                ? "bg-primary/15 text-foreground"
                : "text-muted-foreground hover:bg-nexus-surface hover:text-foreground",
            )}
          >
            <Icon size={16} className={active ? "text-primary" : undefined} />
            {label}
          </Link>
        );
      })}
    </nav>
  );
}
