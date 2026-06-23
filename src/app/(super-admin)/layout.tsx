import Link from "next/link";

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
    <div className="dark min-h-screen bg-nexus-background text-foreground">
      <div className="flex min-h-screen">
        {/* Sidebar (md and up) */}
        <aside className="sticky top-0 hidden h-screen w-60 shrink-0 flex-col border-r border-nexus-border bg-nexus-sunken md:flex">
          <div className="flex h-16 items-center gap-2.5 border-b border-nexus-border px-5">
            <span className="flex h-8 w-8 items-center justify-center rounded-lg bg-primary font-heading text-base font-bold text-primary-foreground">
              N
            </span>
            <div className="leading-tight">
              <p className="font-heading text-sm font-semibold tracking-tight">
                Nexus
              </p>
              <p className="text-xs text-muted-foreground">Admin console</p>
            </div>
          </div>
          <div className="flex-1 overflow-y-auto px-3 py-4">
            <p className="px-3 pb-2 text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              Manage
            </p>
            <AdminSidebarNav />
          </div>
          <div className="border-t border-nexus-border px-3 py-3">
            <p className="px-3 pb-1 text-xs text-muted-foreground">
              Signed in as super admin
            </p>
            <form action={signOutAction} className="px-1">
              <Button
                type="submit"
                variant="ghost"
                size="sm"
                className="w-full justify-start text-muted-foreground hover:text-foreground"
              >
                Sign out
              </Button>
            </form>
          </div>
        </aside>

        {/* Main column */}
        <div className="flex min-h-screen min-w-0 flex-1 flex-col">
          {/* Mobile top bar */}
          <header className="sticky top-0 z-20 border-b border-nexus-border bg-nexus-sunken/95 backdrop-blur-md md:hidden">
            <div className="flex h-14 items-center justify-between px-4">
              <Link
                href="/admin/platform-settings"
                className="flex items-center gap-2 font-heading text-base font-semibold tracking-tight"
              >
                <span className="flex h-7 w-7 items-center justify-center rounded-md bg-primary text-sm font-bold text-primary-foreground">
                  N
                </span>
                Nexus Admin
              </Link>
              <form action={signOutAction}>
                <Button type="submit" variant="outline" size="sm">
                  Sign out
                </Button>
              </form>
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
