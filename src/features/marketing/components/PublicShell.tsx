import Link from "next/link";

import { Button } from "@/components/ui/Button";
import { cn } from "@/lib/utils";

interface PublicShellProps {
  children: React.ReactNode;
}

const NAV_LINKS = [
  { href: "/pricing", label: "Pricing" },
  { href: "/about", label: "About" },
  { href: "/login", label: "Sign in" },
] as const;

export function PublicShell({ children }: PublicShellProps) {
  return (
    <div className="nexus-grain flex min-h-full flex-col overflow-x-hidden bg-background">
      <header className="sticky top-0 z-20 border-b border-border/80 bg-card/90 backdrop-blur-md">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between gap-4 px-4 sm:px-6">
          <Link
            href="/"
            className="font-heading text-lg font-semibold tracking-tight text-foreground transition-colors hover:text-primary"
          >
            Nexus
          </Link>
          <nav className="hidden items-center gap-1 md:flex">
            {NAV_LINKS.map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="rounded-lg px-3 py-2 text-sm text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
              >
                {link.label}
              </Link>
            ))}
          </nav>
          <div className="flex items-center gap-2">
            <Link
              href="/login"
              className="rounded-lg px-3 py-2 text-sm font-medium text-muted-foreground transition-colors hover:text-foreground md:hidden"
            >
              Sign in
            </Link>
            <Button render={<Link href="/signup" />} size="default">
              Get started
            </Button>
          </div>
        </div>
      </header>
      <main className="flex-1">{children}</main>
      <footer className="border-t border-border bg-card">
        <div className="mx-auto flex max-w-6xl flex-col gap-4 px-4 py-10 text-sm text-muted-foreground sm:flex-row sm:items-center sm:justify-between sm:px-6">
          <p>© {new Date().getFullYear()} Nexus · Garnet Labs</p>
          <div className="flex flex-wrap gap-4">
            {NAV_LINKS.filter((link) => link.href !== "/login").map((link) => (
              <Link
                key={link.href}
                href={link.href}
                className="transition-colors hover:text-foreground"
              >
                {link.label}
              </Link>
            ))}
            <Link href="/signup" className="transition-colors hover:text-foreground">
              Sign up
            </Link>
          </div>
        </div>
      </footer>
    </div>
  );
}

export function MarketingSection({
  className,
  children,
  variant = "default",
}: {
  className?: string;
  children: React.ReactNode;
  variant?: "default" | "muted" | "primary";
}) {
  return (
    <section
      className={cn(
        variant === "primary" && "bg-primary text-primary-foreground",
        variant === "muted" && "border-y border-border bg-muted/40",
        className,
      )}
    >
      {children}
    </section>
  );
}
