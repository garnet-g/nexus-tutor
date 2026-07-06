/**
 * @vitest-environment jsdom
 *
 * PR-123: reloading /pricing during a pending payment must resume polling.
 */
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { cleanup, render, screen, waitFor } from "@testing-library/react";

import { PricingCheckout } from "@/features/pricing/components/PricingCheckout";
import { PENDING_PAYMENT_STORAGE_KEY } from "@/features/pricing/lib/pendingPaymentStorage";

const config = {
  pricing: { premiumAmountKes: 799, familyAmountKes: 2499 },
  limits: {
    premiumNex: 50,
    premiumPractice: 30,
    familyMaxStudents: 5,
    freeNex: 10,
    freePractice: 10,
  },
  promotion: { isActive: false, title: null, endsAt: null },
};

const plans = [
  {
    id: "00000000-0000-4000-8000-000000000011",
    planCode: "premium",
    name: "Premium",
    amountKes: 799,
  },
];

describe("PricingCheckout pending payment recovery", () => {
  beforeEach(() => {
    sessionStorage.clear();
    vi.restoreAllMocks();
  });

  afterEach(() => {
    cleanup();
    sessionStorage.clear();
  });

  it("resumes polling when sessionStorage has a non-terminal pending payment", async () => {
    const paymentId = "00000000-0000-4000-8000-000000000099";
    sessionStorage.setItem(
      PENDING_PAYMENT_STORAGE_KEY,
      JSON.stringify({ mpesaPaymentId: paymentId }),
    );

    const fetchMock = vi.spyOn(globalThis, "fetch").mockResolvedValue(
      new Response(
        JSON.stringify({
          success: true,
          data: {
            status: "processing",
            statusLabel: "Processing",
            isTerminal: false,
            failureHint: null,
            planName: "Premium",
          },
        }),
        { status: 200 },
      ),
    );

    render(
      <PricingCheckout
        config={config}
        plans={plans}
        hasUsedTrial={false}
        currentPlanCode="free"
      />,
    );

    await waitFor(() => {
      expect(fetchMock).toHaveBeenCalledWith(
        `/api/mpesa/status?mpesaPaymentId=${encodeURIComponent(paymentId)}`,
      );
    });

    expect(
      screen.getByText(/resuming your pending payment/i),
    ).toBeTruthy();
    expect(
      screen.getByText(/waiting for payment on your phone/i),
    ).toBeTruthy();
  });
});
