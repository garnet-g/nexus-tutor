/**
 * @vitest-environment jsdom
 *
 * PR-140: provider-down checkout must show a recoverable error, not a dead end.
 */
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";
import { cleanup, fireEvent, render, screen, waitFor } from "@testing-library/react";

import { PricingCheckout } from "@/features/pricing/components/PricingCheckout";

const config = {
  pricing: {
    premiumDailyAmountKes: 20,
    premiumWeeklyAmountKes: 150,
    premiumAmountKes: 799,
    premiumTermlyAmountKes: 2400,
    familyAmountKes: 2499,
  },
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

describe("PricingCheckout provider-down UX", () => {
  beforeEach(() => {
    sessionStorage.clear();
    vi.restoreAllMocks();
  });

  afterEach(() => {
    cleanup();
  });

  it("shows a recoverable provider-down message and keeps checkout enabled", async () => {
    vi.spyOn(globalThis, "fetch").mockResolvedValue(
      new Response(
        JSON.stringify({
          success: false,
          error: {
            code: "MPESA_PAYMENT_FAILED",
            message: "M-Pesa STK push failed.",
          },
        }),
        { status: 502 },
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

    fireEvent.change(screen.getByLabelText(/m-pesa phone number/i), {
      target: { value: "+254712345678" },
    });
    fireEvent.click(screen.getByRole("button", { name: /send stk push/i }));

    await waitFor(() => {
      expect(screen.getByTestId("checkout-provider-error")).toBeTruthy();
    });

    expect(
      screen.getByText(/m-pesa is temporarily unavailable/i),
    ).toBeTruthy();
    const submitButton = screen.getByRole("button", { name: /send stk push/i });
    expect((submitButton as HTMLButtonElement).disabled).toBe(false);
  });
});
