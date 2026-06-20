"use client";

import Link from "next/link";
import { track } from "@/lib/analytics/track";

import { Button } from "@/components/ui/Button";
import { Card } from "@/components/ui/Card";

export { shouldShowDashboardEmptyState } from "../dashboardEmptyState";

export interface DashboardEmptyStatesProps {
  showEmptyState: boolean;
}

export function DashboardEmptyStates({
  showEmptyState,
}: DashboardEmptyStatesProps) {
  if (!showEmptyState) {
    return null;
  }

  return (
    <section className="grid gap-4 sm:grid-cols-2">
      <Card className="flex flex-col gap-4 p-6">
        <div className="space-y-1">
          <h2 className="text-lg font-semibold text-foreground">
            Get started with Nexus
          </h2>
          <p className="text-sm text-muted-foreground">
            You have not started any courses or practice sessions yet. Pick a
            path below to begin learning.
          </p>
        </div>
        <div className="flex flex-col gap-2 sm:flex-row sm:flex-wrap">
          <Button
            render={<Link href="/learn" />}
            onClick={() =>
              track("cta_clicked", {
                location: "dashboard_empty_state",
                target: "/learn",
              })
            }
          >
            Learn
          </Button>
          <Button
            render={<Link href="/practice" />}
            variant="outline"
            onClick={() =>
              track("cta_clicked", {
                location: "dashboard_empty_state",
                target: "/practice",
              })
            }
          >
            Start practice
          </Button>
        </div>
      </Card>

      <Card className="flex flex-col gap-4 p-6">
        <div className="space-y-1">
          <h2 className="text-lg font-semibold text-foreground">
            Need help right now?
          </h2>
          <p className="text-sm text-muted-foreground">
            Stuck on homework or preparing for an exam? Nex can guide you step
            by step.
          </p>
        </div>
        <div className="flex flex-col gap-2 sm:flex-row sm:flex-wrap">
          <Button
            render={<Link href="/assignment-help" />}
            onClick={() =>
              track("cta_clicked", {
                location: "dashboard_empty_state",
                target: "/assignment-help",
              })
            }
          >
            Assignment Help
          </Button>
          <Button
            render={<Link href="/exam-prep" />}
            variant="outline"
            onClick={() =>
              track("cta_clicked", {
                location: "dashboard_empty_state",
                target: "/exam-prep",
              })
            }
          >
            Exam Prep
          </Button>
        </div>
      </Card>
    </section>
  );
}
