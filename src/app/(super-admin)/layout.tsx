import Link from "next/link";

import { Button } from "@/components/ui/Button";
import { signOutAction } from "@/server/actions/authActions";

export default function SuperAdminLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <div className="dark flex min-h-full flex-col bg-background text-foreground">
      <header className="sticky top-0 z-20 border-b border-border bg-card/90 backdrop-blur-md">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4 sm:px-6">
          <div className="flex items-center gap-6">
            <Link
              href="/admin/platform-settings"
              className="font-heading text-lg font-semibold tracking-tight"
            >
              Nexus Admin
            </Link>
            <nav className="flex gap-1 text-sm">
              <Link
                href="/admin/platform-settings"
                className="rounded-lg px-3 py-2 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
              >
                Platform settings
              </Link>
              <Link
                href="/admin/beta-invites"
                className="rounded-lg px-3 py-2 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
              >
                Beta invites
              </Link>
              <Link
                href="/admin/content"
                className="rounded-lg px-3 py-2 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
              >
                Content
              </Link>
              <Link
                href="/admin/usage-stats"
                className="rounded-lg px-3 py-2 text-muted-foreground transition-colors hover:bg-muted hover:text-foreground"
              >
                Usage stats
              </Link>
            </nav>
          </div>
          <form action={signOutAction}>
            <Button type="submit" variant="outline" size="sm">
              Sign out
            </Button>
          </form>
        </div>
      </header>
      <main className="mx-auto w-full max-w-6xl flex-1 px-4 py-8 sm:px-6 sm:py-10">
        {children}
      </main>
    </div>
  );
}
