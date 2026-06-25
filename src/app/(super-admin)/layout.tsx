import Link from "next/link";

import { ThemeToggle } from "@/components/ThemeToggle";
import { Button } from "@/components/ui/Button";
import { AdminMobileNav, AdminSidebarNav } from "@/features/admin/components/AdminNav";
import { AdminToaster } from "@/features/admin/components/AdminToaster";
import { signOutAction } from "@/server/actions/authActions";

export default function SuperAdminLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <div className="min-h-screen bg-nexus-background text-foreground">
      <div className="flex min-h-screen">
        {/* Sidebar (md and up) */}
        <aside className="sticky top-0 hidden h-dvh w-[17rem] shrink-0 flex-col border-r border-nexus-border bg-nexus-sunken md:flex">
          <div className="flex h-16 items-center gap-2.5 border-b border-nexus-border bg-nexus-surface/55 px-4">
            <span className="flex h-9 w-9 shrink-0 items-center justify-center rounded-xl bg-primary font-heading text-base font-bold text-primary-foreground shadow-[0_10px_24px_rgb(21_86_75/0.2)]">
              N
            </span>
            <Link href="/admin" className="min-w-0 leading-tight">
              <p className="font-heading text-sm font-semibold tracking-tight">
                Nexus
              </p>
              <p className="text-xs text-muted-foreground">Admin console</p>
            </Link>
          </div>
          <div className="admin-sidebar-scroll min-h-0 flex-1 overflow-y-auto px-2.5 py-3">
            <AdminSidebarNav />
          </div>
          <div className="border-t border-nexus-border bg-nexus-surface/70 px-3 py-3">
            <div className="flex items-center justify-between gap-3 rounded-2xl border border-nexus-border/70 bg-nexus-sunken/70 px-3 py-2.5">
              <div className="min-w-0">
                <p className="truncate text-xs text-muted-foreground">
                  Signed in as super admin
                </p>
                <form action={signOutAction}>
                  <Button
                    type="submit"
                    variant="ghost"
                    size="sm"
                    className="mt-1 h-auto justify-start px-0 py-0 text-xs text-muted-foreground hover:bg-transparent hover:text-foreground"
                  >
                    Sign out
                  </Button>
                </form>
              </div>
              <ThemeToggle className="shrink-0" />
            </div>
          </div>
        </aside>

        {/* Main column */}
        <div className="flex min-h-screen min-w-0 flex-1 flex-col">
          {/* Mobile top bar */}
          <header className="sticky top-0 z-20 border-b border-nexus-border bg-nexus-sunken/95 backdrop-blur-md md:hidden">
            <div className="flex h-14 items-center justify-between px-4">
              <Link
                href="/admin"
                className="flex items-center gap-2 font-heading text-base font-semibold tracking-tight"
              >
                <span className="flex h-7 w-7 items-center justify-center rounded-md bg-primary text-sm font-bold text-primary-foreground">
                  N
                </span>
                Nexus Admin
              </Link>
              <div className="flex items-center gap-2">
                <ThemeToggle />
                <form action={signOutAction}>
                  <Button type="submit" variant="outline" size="sm">
                    Sign out
                  </Button>
                </form>
              </div>
            </div>
            <div className="px-3 pb-2">
              <AdminMobileNav />
            </div>
          </header>

          <main className="flex-1 px-5 py-7 sm:px-8 sm:py-9">
            <div className="mx-auto w-full max-w-6xl space-y-7">{children}</div>
          </main>
        </div>
      </div>
      <AdminToaster />
    </div>
  );
}
