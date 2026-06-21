"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useState } from "react";
import {
  BarChart3,
  BookOpen,
  CalendarCheck,
  CalendarDays,
  Flame,
  Home,
  Search,
  Target,
  User,
  Zap,
} from "lucide-react";

import { cn } from "@/lib/utils";
import { levelFromXp } from "@/lib/gamification";
import { NexMark } from "@/components/NexMark";
import { CommandPalette } from "@/components/student/CommandPalette";
import { ThemeToggle } from "@/components/ThemeToggle";
import { ToastProvider } from "@/components/ui/Toast";
import { signOutAction } from "@/server/actions/authActions";

type NavItem = {
  href: string;
  label: string;
  icon?: React.ComponentType<{ className?: string }>;
  nex?: boolean;
};

const PRIMARY_NAV: NavItem[] = [
  { href: "/dashboard", label: "Today", icon: Home },
  { href: "/learn", label: "Learn", icon: BookOpen },
  { href: "/revision", label: "Revision", icon: CalendarCheck },
  { href: "/nex", label: "Nex", nex: true },
  { href: "/practice", label: "Practice", icon: Target },
  { href: "/progress", label: "Progress", icon: BarChart3 },
];

const SECONDARY_NAV: NavItem[] = [
  { href: "/study-plan", label: "Study Plan", icon: CalendarDays },
  { href: "/profile", label: "Profile", icon: User },
];

const MOBILE_NAV: NavItem[] = [
  { href: "/dashboard", label: "Today", icon: Home },
  { href: "/learn", label: "Learn", icon: BookOpen },
  { href: "/revision", label: "Revision", icon: CalendarCheck },
  { href: "/nex", label: "Nex", nex: true },
  { href: "/practice", label: "Practice", icon: Target },
];

function isActive(pathname: string, href: string): boolean {
  if (href === "/dashboard") return pathname === "/dashboard";
  return pathname === href || pathname.startsWith(`${href}/`);
}

interface StudentAppShellProps {
  studentName: string;
  currentStreak: number;
  totalXp: number;
  diagnosticComplete: boolean;
  children: React.ReactNode;
}

export function StudentAppShell({
  studentName,
  currentStreak,
  totalXp,
  diagnosticComplete,
  children,
}: StudentAppShellProps) {
  const pathname = usePathname();
  const [paletteOpen, setPaletteOpen] = useState(false);
  const { level } = levelFromXp(totalXp);

  useEffect(() => {
    function onKeyDown(event: KeyboardEvent) {
      if ((event.metaKey || event.ctrlKey) && event.key.toLowerCase() === "k") {
        event.preventDefault();
        setPaletteOpen((open) => !open);
      }
    }
    window.addEventListener("keydown", onKeyDown);
    return () => window.removeEventListener("keydown", onKeyDown);
  }, []);

  return (
    <ToastProvider>
      <div className="min-h-dvh bg-nexus-background">
      {/* Desktop sidebar */}
      <aside className="fixed inset-y-0 left-0 z-30 hidden w-64 flex-col border-r border-nexus-border bg-nexus-surface lg:flex">
        <Link href="/dashboard" className="flex items-center gap-2.5 px-5 py-5">
          <NexMark size={28} />
          <span className="font-heading text-lg font-semibold tracking-tight text-foreground">
            Nexus
          </span>
        </Link>

        {diagnosticComplete ? (
          <nav className="flex-1 space-y-6 overflow-y-auto px-3 py-2">
            <NavGroup items={PRIMARY_NAV} pathname={pathname} />
            <div>
              <p className="px-3 pb-1 text-[11px] font-semibold uppercase tracking-wide text-nexus-text-muted">
                More
              </p>
              <NavGroup items={SECONDARY_NAV} pathname={pathname} />
            </div>
          </nav>
        ) : (
          <nav className="flex-1 px-3 py-2">
            <NavGroup
              items={[{ href: "/diagnostic", label: "Diagnostic", icon: Target }]}
              pathname={pathname}
            />
          </nav>
        )}

        <div className="border-t border-nexus-border p-3">
          <div className="flex items-center gap-3 px-2 py-1.5">
            <span className="flex size-8 flex-none items-center justify-center rounded-full bg-nexus-primary-soft text-xs font-semibold text-nexus-primary">
              {studentName.charAt(0).toUpperCase()}
            </span>
            <span className="min-w-0 flex-1 truncate text-sm font-medium text-foreground">
              {studentName}
            </span>
          </div>
          <form action={signOutAction}>
            <button
              type="submit"
              className="mt-1 w-full rounded-lg px-2 py-1.5 text-left text-xs text-muted-foreground transition-colors hover:bg-nexus-sunken hover:text-foreground"
            >
              Sign out
            </button>
          </form>
        </div>
      </aside>

      {/* Content column */}
      <div className="lg:pl-64">
        {/* Top bar (desktop) */}
        <header className="sticky top-0 z-20 hidden border-b border-nexus-border bg-nexus-background/85 backdrop-blur-md lg:block">
          <div className="mx-auto flex h-14 max-w-6xl items-center gap-3 px-5">
            <button
              type="button"
              onClick={() => setPaletteOpen(true)}
              className="flex h-9 w-72 items-center gap-2.5 rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm text-nexus-text-muted transition-colors hover:border-nexus-border-strong"
            >
              <Search className="size-4" />
              <span className="flex-1 text-left">Search or jump to…</span>
              <kbd className="rounded-md border border-nexus-border bg-nexus-sunken px-1.5 py-0.5 text-[10px] font-medium">
                ⌘K
              </kbd>
            </button>

            <div className="ml-auto flex items-center gap-2">
              <ThemeToggle />
              {diagnosticComplete ? (
                <>
                  <StatPill
                    icon={<Flame className="size-3.5 text-nexus-accent" />}
                    value={currentStreak}
                    suffix="day"
                  />
                  <StatPill
                    icon={<Zap className="size-3.5 text-nexus-primary" />}
                    value={`Lv ${level}`}
                  />
                </>
              ) : null}
              <Link
                href="/nex"
                className="flex h-9 items-center gap-2 rounded-xl bg-nexus-primary px-3.5 text-sm font-semibold text-nexus-text-inverse shadow-card transition-colors hover:bg-nexus-primary-hover"
              >
                <NexMark size={18} className="shadow-none" />
                Ask Nex
              </Link>
            </div>
          </div>
        </header>

        {/* Top bar (mobile) */}
        <header className="sticky top-0 z-20 flex h-14 items-center gap-3 border-b border-nexus-border bg-nexus-background/90 px-4 backdrop-blur-md lg:hidden">
          <Link href="/dashboard" className="flex items-center gap-2">
            <NexMark size={26} />
            <span className="font-heading text-lg font-semibold text-foreground">
              Nexus
            </span>
          </Link>
          <button
            type="button"
            onClick={() => setPaletteOpen(true)}
            aria-label="Search"
            className="ml-auto flex size-9 items-center justify-center rounded-xl border border-nexus-border bg-nexus-surface text-nexus-text-muted"
          >
            <Search className="size-4" />
          </button>
          <ThemeToggle />
        </header>

        <main className="mx-auto w-full max-w-6xl px-4 pb-28 pt-6 sm:px-5 sm:pt-8 lg:pb-12">
          {children}
        </main>
      </div>

      {/* Mobile bottom nav */}
      {diagnosticComplete ? (
        <nav className="fixed inset-x-0 bottom-0 z-30 border-t border-nexus-border bg-nexus-surface/95 backdrop-blur-md lg:hidden">
          <div className="mx-auto flex max-w-md items-end justify-around px-2">
            {MOBILE_NAV.map((item) => {
              const active = isActive(pathname, item.href);
              if (item.nex) {
                return (
                  <Link
                    key={item.href}
                    href={item.href}
                    aria-current={active ? "page" : undefined}
                    className="flex flex-1 flex-col items-center gap-0.5 pb-2 text-[10.5px] font-semibold text-nexus-primary"
                  >
                    <NexMark
                      size={46}
                      className="-mt-6 border-4 border-nexus-surface"
                    />
                    Nex
                  </Link>
                );
              }
              const Icon = item.icon!;
              return (
                <Link
                  key={item.href}
                  href={item.href}
                  aria-current={active ? "page" : undefined}
                  className={cn(
                    "flex min-h-14 flex-1 flex-col items-center justify-center gap-1 text-[10.5px] font-medium",
                    active ? "text-nexus-primary" : "text-nexus-text-muted",
                  )}
                >
                  <Icon className="size-5" />
                  {item.label}
                </Link>
              );
            })}
          </div>
        </nav>
      ) : null}

      <CommandPalette open={paletteOpen} onOpenChange={setPaletteOpen} />
      </div>
    </ToastProvider>
  );
}

function NavGroup({
  items,
  pathname,
}: {
  items: NavItem[];
  pathname: string;
}) {
  return (
    <ul className="space-y-0.5">
      {items.map((item) => {
        const active = isActive(pathname, item.href);
        return (
          <li key={item.href}>
            <Link
              href={item.href}
              aria-current={active ? "page" : undefined}
              className={cn(
                "flex items-center gap-3 rounded-xl px-3 py-2 text-sm font-medium transition-colors",
                active
                  ? "bg-nexus-primary-soft text-nexus-primary"
                  : "text-nexus-text-secondary hover:bg-nexus-sunken hover:text-foreground",
              )}
            >
              {item.nex ? (
                <NexMark size={18} className="shadow-none" />
              ) : item.icon ? (
                <item.icon className="size-[18px]" />
              ) : null}
              {item.label}
            </Link>
          </li>
        );
      })}
    </ul>
  );
}

function StatPill({
  icon,
  value,
  suffix,
}: {
  icon: React.ReactNode;
  value: React.ReactNode;
  suffix?: string;
}) {
  return (
    <span className="flex h-9 items-center gap-1.5 rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm font-semibold tabular text-foreground">
      {icon}
      {value}
      {suffix ? (
        <span className="text-xs font-normal text-muted-foreground">
          {suffix}
        </span>
      ) : null}
    </span>
  );
}
