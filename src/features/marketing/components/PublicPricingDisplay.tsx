import Link from "next/link";

import { Button } from "@/components/ui/Button";
import {
  Card,
  CardContent,
  CardDescription,
  CardHeader,
  CardTitle,
} from "@/components/ui/Card";
import type { EffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { cn } from "@/lib/utils";

interface PublicPricingDisplayProps {
  config: EffectiveSubscriptionConfig;
}

export function PublicPricingDisplay({ config }: PublicPricingDisplayProps) {
  const { limits, pricing, promotion } = config;
  const premiumPrice = pricing.premiumAmountKes;
  const familyPrice = pricing.familyAmountKes;

  return (
    <div className="flex flex-col gap-8">
      {promotion.isActive && promotion.title ? (
        <Card className="border-nexus-success/30 bg-nexus-success/10">
          <CardContent className="py-4 text-sm text-nexus-secondary">
            {promotion.title}
          </CardContent>
        </Card>
      ) : null}

      <section className="grid gap-4 md:grid-cols-3">
        <Card className="nexus-card-elevated">
          <CardHeader>
            <CardTitle className="font-heading text-lg">Free</CardTitle>
            <CardDescription className="font-heading text-3xl font-bold text-foreground">
              KES 0
              <span className="text-base font-normal text-muted-foreground"> / forever</span>
            </CardDescription>
          </CardHeader>
          <CardContent>
            <ul className="flex flex-col gap-2 text-sm text-muted-foreground">
              <li>{limits.freeNex} Nex messages per day</li>
              <li>{limits.freePractice} practice sessions per day</li>
              <li>Diagnostic &amp; predicted grade</li>
              <li>Learn curriculum topics</li>
            </ul>
          </CardContent>
        </Card>

        <Card className={cn("nexus-card-elevated border-2 border-primary ring-2 ring-primary/10")}>
          <CardHeader>
            <CardDescription className="text-xs font-medium uppercase tracking-[0.12em] text-primary">
              Most popular
            </CardDescription>
            <CardTitle className="font-heading text-lg">Premium</CardTitle>
            <CardDescription className="font-heading text-3xl font-bold text-foreground">
              KES {premiumPrice.toLocaleString()}
              <span className="text-base font-normal text-muted-foreground"> / month</span>
            </CardDescription>
          </CardHeader>
          <CardContent>
            <ul className="flex flex-col gap-2 text-sm text-muted-foreground">
              <li>{limits.premiumNex} Nex messages per day</li>
              <li>{limits.premiumPractice} practice sessions per day</li>
              <li>Exam study plans via Nex revision</li>
              <li>7-day trial available after signup</li>
            </ul>
          </CardContent>
        </Card>

        <Card className="nexus-card-elevated">
          <CardHeader>
            <CardTitle className="font-heading text-lg">Family</CardTitle>
            <CardDescription className="font-heading text-3xl font-bold text-foreground">
              KES {familyPrice.toLocaleString()}
              <span className="text-base font-normal text-muted-foreground"> / month</span>
            </CardDescription>
          </CardHeader>
          <CardContent>
            <ul className="flex flex-col gap-2 text-sm text-muted-foreground">
              <li>Up to {limits.familyMaxStudents} student accounts</li>
              <li>Premium limits for each student</li>
              <li>Parent dashboard for every linked child</li>
              <li>Pay with M-Pesa after signup</li>
            </ul>
          </CardContent>
        </Card>
      </section>

      <div className="flex flex-col items-center gap-3 text-center">
        <Button render={<Link href="/signup" />} size="lg">
          Create your free account
        </Button>
        <p className="text-sm text-muted-foreground">
          Prices load from live platform settings — no hidden fees.
        </p>
      </div>
    </div>
  );
}
