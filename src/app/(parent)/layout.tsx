import Link from "next/link";

import { Button } from "@/components/ui/Button";
import { signOutAction } from "@/server/actions/authActions";
import { getSessionUser } from "@/server/services/authService";

export default async function ParentLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const sessionUser = await getSessionUser();

  return (
    <div className="nexus-grain flex min-h-full flex-col bg-background">
      <header className="sticky top-0 z-20 border-b border-border/80 bg-card/90 backdrop-blur-md">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between px-4 sm:px-6">
          <Link
            href="/parent"
            className="font-heading text-lg font-semibold tracking-tight text-foreground transition-colors hover:text-primary"
          >
            Nexus Parent
          </Link>
          <div className="flex items-center gap-3 text-sm text-muted-foreground">
            <span>{sessionUser?.parentProfile?.full_name ?? "Parent"}</span>
            <form action={signOutAction}>
              <Button type="submit" variant="outline" size="sm">
                Sign out
              </Button>
            </form>
          </div>
        </div>
      </header>
      <main className="mx-auto w-full max-w-6xl flex-1 px-4 py-8 sm:px-6 sm:py-10">
        {children}
      </main>
    </div>
  );
}
