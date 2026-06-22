"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Panel } from "@/features/admin/components/adminUi";
import { cn } from "@/lib/utils";

type DiscountType = "percent" | "fixed";
type CouponPlan = "premium" | "family" | "any";

type AdminCoupon = {
  id: string;
  code: string;
  discountType: DiscountType;
  discountValue: number;
  appliesToPlan: CouponPlan;
  maxUses: number | null;
  usedCount: number;
  expiresAt: string | null;
  isActive: boolean;
  createdBy: string | null;
  createdAt: string;
};

interface CouponManagerPanelProps {
  initialCoupons: AdminCoupon[];
  canWrite: boolean;
}

const fieldClass =
  "w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 outline-none focus:border-primary focus:ring-2 focus:ring-primary/20";

function formatDiscount(coupon: AdminCoupon): string {
  if (coupon.discountType === "percent") {
    return `${coupon.discountValue}%`;
  }
  return `KES ${coupon.discountValue.toLocaleString()}`;
}

function formatDate(iso: string | null): string {
  if (!iso) {
    return "-";
  }
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date(iso));
}

export function CouponManagerPanel({
  initialCoupons,
  canWrite,
}: CouponManagerPanelProps) {
  const [coupons, setCoupons] = useState(initialCoupons);
  const [form, setForm] = useState({
    code: "",
    discountType: "percent" as DiscountType,
    discountValue: "10",
    appliesToPlan: "any" as CouponPlan,
    maxUses: "",
    expiresAt: "",
  });
  const [isSubmitting, setIsSubmitting] = useState(false);
  const [busyId, setBusyId] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);
  const [success, setSuccess] = useState<string | null>(null);

  async function createCoupon(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSubmitting(true);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch("/api/admin/payments/coupons", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          code: form.code,
          discountType: form.discountType,
          discountValue: Number(form.discountValue),
          appliesToPlan: form.appliesToPlan,
          maxUses: form.maxUses ? Number(form.maxUses) : null,
          expiresAt: form.expiresAt ? new Date(form.expiresAt).toISOString() : null,
        }),
      });
      const payload = (await response.json()) as {
        success: boolean;
        data?: { coupon: AdminCoupon };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not create coupon.");
        return;
      }

      setCoupons((current) => [payload.data!.coupon, ...current]);
      setForm({
        code: "",
        discountType: "percent",
        discountValue: "10",
        appliesToPlan: "any",
        maxUses: "",
        expiresAt: "",
      });
      setSuccess("Coupon created.");
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  async function deactivateCoupon(couponId: string) {
    setBusyId(couponId);
    setError(null);
    setSuccess(null);

    try {
      const response = await fetch(`/api/admin/payments/coupons/${couponId}`, {
        method: "PATCH",
      });
      const payload = (await response.json()) as {
        success: boolean;
        data?: { coupon: AdminCoupon };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        setError(payload.error?.message ?? "Could not deactivate coupon.");
        return;
      }

      setCoupons((current) =>
        current.map((coupon) =>
          coupon.id === couponId ? payload.data!.coupon : coupon,
        ),
      );
      setSuccess("Coupon deactivated.");
    } catch {
      setError("Network error. Please try again.");
    } finally {
      setBusyId(null);
    }
  }

  return (
    <Panel
      title="Coupon manager"
      description="Create and deactivate growth coupons. Redemption is handled outside this admin surface."
    >
      <div className="space-y-5">
        {canWrite ? (
          <form
            onSubmit={createCoupon}
            className="grid gap-3 rounded-xl border border-nexus-border bg-nexus-sunken p-4 lg:grid-cols-6"
          >
            <label className="space-y-1 text-sm lg:col-span-2">
              <span className="text-muted-foreground">Code</span>
              <input
                value={form.code}
                onChange={(event) =>
                  setForm((current) => ({ ...current, code: event.target.value }))
                }
                required
                minLength={3}
                maxLength={40}
                className={fieldClass}
              />
            </label>
            <label className="space-y-1 text-sm">
              <span className="text-muted-foreground">Type</span>
              <select
                value={form.discountType}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    discountType: event.target.value as DiscountType,
                  }))
                }
                className={fieldClass}
              >
                <option value="percent">Percent</option>
                <option value="fixed">Fixed KES</option>
              </select>
            </label>
            <label className="space-y-1 text-sm">
              <span className="text-muted-foreground">Value</span>
              <input
                type="number"
                min={1}
                max={form.discountType === "percent" ? 100 : 1000000}
                value={form.discountValue}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    discountValue: event.target.value,
                  }))
                }
                className={fieldClass}
              />
            </label>
            <label className="space-y-1 text-sm">
              <span className="text-muted-foreground">Plan</span>
              <select
                value={form.appliesToPlan}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    appliesToPlan: event.target.value as CouponPlan,
                  }))
                }
                className={fieldClass}
              >
                <option value="any">Any</option>
                <option value="premium">Premium</option>
                <option value="family">Family</option>
              </select>
            </label>
            <label className="space-y-1 text-sm">
              <span className="text-muted-foreground">Max uses</span>
              <input
                type="number"
                min={1}
                value={form.maxUses}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    maxUses: event.target.value,
                  }))
                }
                className={fieldClass}
              />
            </label>
            <label className="space-y-1 text-sm lg:col-span-2">
              <span className="text-muted-foreground">Expires at</span>
              <input
                type="datetime-local"
                value={form.expiresAt}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    expiresAt: event.target.value,
                  }))
                }
                className={fieldClass}
              />
            </label>
            <div className="flex items-end lg:col-span-4">
              <Button type="submit" variant="primary" disabled={isSubmitting}>
                {isSubmitting ? "Creating..." : "Create coupon"}
              </Button>
            </div>
          </form>
        ) : (
          <p className="rounded-xl border border-nexus-border bg-nexus-sunken px-4 py-3 text-sm text-muted-foreground">
            Support can review coupons. Create and deactivate actions require super admin.
          </p>
        )}

        {error ? <p className="text-sm text-nexus-danger">{error}</p> : null}
        {success ? <p className="text-sm text-primary">{success}</p> : null}

        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-3 py-3 font-medium">Code</th>
                <th className="px-3 py-3 font-medium">Discount</th>
                <th className="px-3 py-3 font-medium">Plan</th>
                <th className="px-3 py-3 text-right font-medium">Uses</th>
                <th className="px-3 py-3 font-medium">Expires</th>
                <th className="px-3 py-3 font-medium">Status</th>
                <th className="px-3 py-3 text-right font-medium">Action</th>
              </tr>
            </thead>
            <tbody>
              {coupons.length === 0 ? (
                <tr>
                  <td
                    colSpan={7}
                    className="px-3 py-8 text-center text-muted-foreground"
                  >
                    No coupons created yet.
                  </td>
                </tr>
              ) : (
                coupons.map((coupon) => (
                  <tr
                    key={coupon.id}
                    className="border-b border-nexus-border last:border-0"
                  >
                    <td className="px-3 py-3 font-mono text-foreground">
                      {coupon.code}
                    </td>
                    <td className="px-3 py-3 text-muted-foreground">
                      {formatDiscount(coupon)}
                    </td>
                    <td className="px-3 py-3 capitalize text-muted-foreground">
                      {coupon.appliesToPlan}
                    </td>
                    <td className="px-3 py-3 text-right font-mono tabular-nums">
                      {coupon.usedCount}
                      {coupon.maxUses ? ` / ${coupon.maxUses}` : ""}
                    </td>
                    <td className="px-3 py-3 tabular-nums text-muted-foreground">
                      {formatDate(coupon.expiresAt)}
                    </td>
                    <td className="px-3 py-3">
                      <span
                        className={cn(
                          "rounded-full px-2.5 py-0.5 text-xs font-medium",
                          coupon.isActive
                            ? "bg-primary/15 text-primary"
                            : "bg-nexus-sunken text-muted-foreground",
                        )}
                      >
                        {coupon.isActive ? "Active" : "Inactive"}
                      </span>
                    </td>
                    <td className="px-3 py-3 text-right">
                      {canWrite && coupon.isActive ? (
                        <Button
                          type="button"
                          variant="outline"
                          size="sm"
                          onClick={() => void deactivateCoupon(coupon.id)}
                          disabled={busyId === coupon.id}
                        >
                          Deactivate
                        </Button>
                      ) : null}
                    </td>
                  </tr>
                ))
              )}
            </tbody>
          </table>
        </div>
      </div>
    </Panel>
  );
}
