"use client";

import Link from "next/link";
import { usePathname } from "next/navigation";
import { useEffect, useRef, useState } from "react";
import {
  BarChart3,
  BookOpen,
  Home,
  Menu,
  Sparkles,
  X,
} from "lucide-react";

import { cn } from "@/lib/utils";

const NAV_ITEMS = [
  { href: "/dashboard", label: "Dashboard" },
  { href: "/learn", label: "Learn" },
  { href: "/nex", label: "Nex" },
  { href: "/practice", label: "Practice" },
  { href: "/exam-prep", label: "Exam Prep" },
  { href: "/progress", label: "Progress" },
  { href: "/study-plan", label: "Study Plan" },
  { href: "/profile", label: "Profile" },
  { href: "/pricing", label: "Pricing" },
] as const;

const MOBILE_NAV_ITEMS = [
  { href: "/dashboard", label: "Home", icon: Home },
  { href: "/learn", label: "Learn", icon: BookOpen },
  { href: "/nex", label: "Nex", icon: Sparkles },
  { href: "/progress", label: "Progress", icon: BarChart3 },
] as const;

const OVERFLOW_NAV_ITEMS = [
  { href: "/practice", label: "Practice" },
  { href: "/exam-prep", label: "Exam Prep" },
  { href: "/assignment-help", label: "Assignment Help" },
  { href: "/study-plan", label: "Study Plan" },
  { href: "/profile", label: "Profile" },
  { href: "/pricing", label: "Pricing" },
] as const;

function isActive(pathname: string, href: string): boolean {
  if (href === "/dashboard") {
    return pathname === "/dashboard";
  }
  return pathname === href || pathname.startsWith(`${href}/`);
}

function isOverflowActive(pathname: string): boolean {
  return OVERFLOW_NAV_ITEMS.some((item) => isActive(pathname, item.href));
}

interface StudentNavProps {
  diagnosticComplete: boolean;
}

export function StudentDesktopNav({ diagnosticComplete }: StudentNavProps) {
  const pathname = usePathname();

  if (!diagnosticComplete) {
    return (
      <nav className="hidden items-center gap-1 text-sm md:flex">
        <Link
          href="/diagnostic"
          className={cn(
            "rounded-lg px-3 py-2 transition-colors",
            pathname.startsWith("/diagnostic")
              ? "bg-primary/10 font-medium text-primary"
              : "text-muted-foreground hover:bg-muted hover:text-foreground",
          )}
        >
          Diagnostic
        </Link>
      </nav>
    );
  }

  return (
      <nav className="hidden items-center gap-1 text-sm md:flex">
      {NAV_ITEMS.map((item) => (
        <Link
          key={item.href}
          href={item.href}
          className={cn(
            "rounded-lg px-3 py-2 transition-colors",
            isActive(pathname, item.href)
              ? "bg-primary/10 font-medium text-primary"
              : "text-muted-foreground hover:bg-muted hover:text-foreground",
          )}
        >
          {item.label}
        </Link>
      ))}
    </nav>
  );
}

function MobileOverflowSheet({
  open,
  onClose,
  pathname,
}: {
  open: boolean;
  onClose: () => void;
  pathname: string;
}) {
  const panelRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    if (!open) {
      return;
    }

    function handleKeyDown(event: KeyboardEvent) {
      if (event.key === "Escape") {
        onClose();
      }
    }

    document.addEventListener("keydown", handleKeyDown);
    document.body.style.overflow = "hidden";

    return () => {
      document.removeEventListener("keydown", handleKeyDown);
      document.body.style.overflow = "";
    };
  }, [open, onClose]);

  if (!open) {
    return null;
  }

  return (
    <div className="fixed inset-0 z-30 md:hidden">
      <button
        type="button"
        aria-label="Close menu"
        className="absolute inset-0 bg-black/40"
        onClick={onClose}
      />
      <div
        ref={panelRef}
        role="dialog"
        aria-modal="true"
        aria-label="More navigation"
        className="absolute inset-x-0 bottom-0 rounded-t-2xl border-t border-border bg-card p-4 pb-6 shadow-lg nexus-card-elevated"
      >
        <div className="mb-4 flex items-center justify-between">
          <p className="text-sm font-semibold text-foreground">More</p>
          <button
            type="button"
            aria-label="Close"
            onClick={onClose}
            className="flex size-10 cursor-pointer items-center justify-center rounded-lg text-muted-foreground transition-colors hover:bg-muted"
          >
            <X className="h-5 w-5" strokeWidth={1.5} />
          </button>
        </div>
        <div className="grid gap-1">
          {OVERFLOW_NAV_ITEMS.map((item) => (
            <Link
              key={item.href}
              href={item.href}
              onClick={onClose}
                className={cn(
                  "flex min-h-12 cursor-pointer items-center rounded-xl px-4 text-sm transition-colors",
                  isActive(pathname, item.href)
                    ? "bg-primary/10 font-medium text-primary"
                    : "text-foreground hover:bg-muted",
                )}
            >
              {item.label}
            </Link>
          ))}
        </div>
      </div>
    </div>
  );
}

export function StudentMobileNav({ diagnosticComplete }: StudentNavProps) {
  const pathname = usePathname();
  const [overflowOpen, setOverflowOpen] = useState(false);

  if (!diagnosticComplete) {
    return null;
  }

  const overflowActive = isOverflowActive(pathname);

  return (
    <>
      <nav className="fixed inset-x-0 bottom-0 z-20 border-t border-border bg-card/95 backdrop-blur-md md:hidden">
        <div className="mx-auto flex max-w-lg items-stretch justify-around">
          {MOBILE_NAV_ITEMS.map((item) => {
            const Icon = item.icon;
            const active = isActive(pathname, item.href);

            return (
              <Link
                key={item.href}
                href={item.href}
                className={cn(
                  "flex min-h-12 min-w-12 flex-1 cursor-pointer flex-col items-center justify-center gap-0.5 px-1 py-2 text-xs transition-colors",
                  active
                    ? "font-medium text-primary"
                    : "text-muted-foreground",
                )}
              >
                <Icon className="h-5 w-5" strokeWidth={1.5} />
                {item.label}
              </Link>
            );
          })}
          <button
            type="button"
            aria-expanded={overflowOpen}
            aria-haspopup="dialog"
            onClick={() => setOverflowOpen(true)}
            className={cn(
              "flex min-h-12 min-w-12 flex-1 cursor-pointer flex-col items-center justify-center gap-0.5 px-1 py-2 text-xs transition-colors",
              overflowActive || overflowOpen
                ? "font-medium text-primary"
                : "text-muted-foreground",
            )}
          >
            <Menu className="h-5 w-5" strokeWidth={1.5} />
            More
          </button>
        </div>
      </nav>

      <MobileOverflowSheet
        open={overflowOpen}
        onClose={() => setOverflowOpen(false)}
        pathname={pathname}
      />
    </>
  );
}
