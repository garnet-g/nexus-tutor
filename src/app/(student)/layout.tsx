import Link from "next/link";

import { Button } from "@/components/ui/Button";
import {
  StudentDesktopNav,
  StudentMobileNav,
} from "@/features/student/components/StudentNav";
import { signOutAction } from "@/server/actions/authActions";
import { getSessionUser } from "@/server/services/authService";

export default async function StudentLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  const sessionUser = await getSessionUser();
  const diagnosticComplete =
    sessionUser?.studentProfile?.has_completed_diagnostic ?? false;

  return (
    <div className="nexus-grain flex min-h-full flex-col overflow-x-hidden bg-background">
      <header className="sticky top-0 z-20 border-b border-border/80 bg-card/90 backdrop-blur-md">
        <div className="mx-auto flex h-16 max-w-6xl items-center justify-between gap-3 px-4 sm:px-6">
          <div className="flex min-w-0 items-center gap-4">
            <Link
              href={diagnosticComplete ? "/dashboard" : "/diagnostic"}
              className="shrink-0 font-heading text-lg font-semibold tracking-tight text-foreground transition-colors hover:text-primary"
            >
              Nexus
            </Link>
            <StudentDesktopNav diagnosticComplete={diagnosticComplete} />
          </div>
          <div className="flex shrink-0 items-center gap-2 text-sm text-muted-foreground">
            <span className="hidden max-w-[8rem] truncate sm:inline">
              {sessionUser?.studentProfile?.full_name ?? "Student"}
            </span>
            <form action={signOutAction}>
              <Button type="submit" variant="outline" size="sm">
                Sign out
              </Button>
            </form>
          </div>
        </div>
      </header>

      <main className="mx-auto w-full max-w-6xl flex-1 px-4 py-8 pb-24 sm:px-6 sm:py-10 md:pb-10">
        {children}
      </main>

      <StudentMobileNav diagnosticComplete={diagnosticComplete} />
    </div>
  );
}
