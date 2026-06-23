"use client";

import { useState } from "react";

import { Button } from "@/components/ui/Button";
import { Field, Input, Select } from "@/features/admin/components/adminForm";
import { Panel, StatusBadge } from "@/features/admin/components/adminUi";
import { useConfirm } from "@/features/admin/components/ConfirmDialog";
import { toastError, toastSuccess } from "@/features/admin/components/toast";

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
  const { confirm, dialog } = useConfirm();

  async function createCoupon(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSubmitting(true);

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
        toastError("Could not create coupon", payload.error?.message);
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
      toastSuccess("Coupon created");
    } catch {
      toastError("Network error", "Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  async function deactivateCoupon(coupon: AdminCoupon) {
    const ok = await confirm({
      title: `Deactivate coupon ${coupon.code}?`,
      description:
        "It will stop redeeming immediately. This cannot be undone from here.",
      confirmLabel: "Deactivate",
      destructive: true,
    });
    if (!ok) {
      return;
    }

    setBusyId(coupon.id);

    try {
      const response = await fetch(`/api/admin/payments/coupons/${coupon.id}`, {
        method: "PATCH",
      });
      const payload = (await response.json()) as {
        success: boolean;
        data?: { coupon: AdminCoupon };
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        toastError("Could not deactivate coupon", payload.error?.message);
        return;
      }

      setCoupons((current) =>
        current.map((existing) =>
          existing.id === coupon.id ? payload.data!.coupon : existing,
        ),
      );
      toastSuccess("Coupon deactivated");
    } catch {
      toastError("Network error", "Please try again.");
    } finally {
      setBusyId(null);
    }
  }

  return (
    <Panel
      title="Coupon manager"
      description="Create and deactivate growth coupons. Redemption is handled outside this admin surface."
    >
      {dialog}
      <div className="space-y-5">
        {canWrite ? (
          <form
            onSubmit={createCoupon}
            className="grid gap-3 rounded-xl border border-nexus-border bg-nexus-sunken p-4 lg:grid-cols-6"
          >
            <Field label="Code" className="lg:col-span-2">
              <Input
                value={form.code}
                onChange={(event) =>
                  setForm((current) => ({ ...current, code: event.target.value }))
                }
                required
                minLength={3}
                maxLength={40}
              />
            </Field>
            <Field label="Type">
              <Select
                value={form.discountType}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    discountType: event.target.value as DiscountType,
                  }))
                }
              >
                <option value="percent">Percent</option>
                <option value="fixed">Fixed KES</option>
              </Select>
            </Field>
            <Field label="Value">
              <Input
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
              />
            </Field>
            <Field label="Plan">
              <Select
                value={form.appliesToPlan}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    appliesToPlan: event.target.value as CouponPlan,
                  }))
                }
              >
                <option value="any">Any</option>
                <option value="premium">Premium</option>
                <option value="family">Family</option>
              </Select>
            </Field>
            <Field label="Max uses">
              <Input
                type="number"
                min={1}
                value={form.maxUses}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    maxUses: event.target.value,
                  }))
                }
              />
            </Field>
            <Field label="Expires at" className="lg:col-span-2">
              <Input
                type="datetime-local"
                value={form.expiresAt}
                onChange={(event) =>
                  setForm((current) => ({
                    ...current,
                    expiresAt: event.target.value,
                  }))
                }
              />
            </Field>
            <div className="flex items-end lg:col-span-4">
              <Button type="submit" variant="primary" disabled={isSubmitting}>
                {isSubmitting ? "Creating…" : "Create coupon"}
              </Button>
            </div>
          </form>
        ) : (
          <p className="rounded-xl border border-nexus-border bg-nexus-sunken px-4 py-3 text-sm text-muted-foreground">
            Support can review coupons. Create and deactivate actions require super admin.
          </p>
        )}

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
                      <StatusBadge tone={coupon.isActive ? "success" : "neutral"}>
                        {coupon.isActive ? "Active" : "Inactive"}
                      </StatusBadge>
                    </td>
                    <td className="px-3 py-3 text-right">
                      {canWrite && coupon.isActive ? (
                        <Button
                          type="button"
                          variant="outline"
                          size="sm"
                          onClick={() => void deactivateCoupon(coupon)}
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
