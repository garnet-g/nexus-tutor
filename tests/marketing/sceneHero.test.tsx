import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { SceneHero } from "@/app/(public)/_landing/SceneHero";

// jsdom has no matchMedia, so ScrollScene renders the static final state.
describe("SceneHero", () => {
  it("positions Nexus as a student-voiced tutor", () => {
    render(<SceneHero />);
    expect(screen.getByText("Your AI tutor for KCSE")).toBeDefined();
    expect(screen.getByText(/Revise the/)).toBeDefined();
    expect(screen.getByText("Fraction equations")).toBeDefined();
  });

  it("keeps both calls to action", () => {
    render(<SceneHero />);
    // Base UI's Button renders the Link with role="button", so assert the
    // underlying anchors and their destinations directly.
    const start = screen.getByText("Start your diagnosis").closest("a");
    expect(start?.getAttribute("href")).toBe("/signup");
    const plans = screen.getByText("See revision plans").closest("a");
    expect(plans?.getAttribute("href")).toBe("/pricing");
  });
});
