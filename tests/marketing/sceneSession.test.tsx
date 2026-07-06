import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { SceneSession } from "@/app/(public)/_landing/SceneSession";

// jsdom has no matchMedia, so ScrollScene renders the static final state
// (progress 1): every beat of the session is present, counter at 6.
describe("SceneSession", () => {
  it("tells the full diagnosis in student voice", () => {
    render(<SceneSession />);
    expect(
      screen.getByText(/losing marks in simultaneous equations/),
    ).toBeDefined();
    expect(screen.getByText(/Multiply everything by 6/)).toBeDefined();
    expect(screen.getByText("6 marks")).toBeDefined();
    expect(
      screen.getByText(/You just needed to clear the fractions first/),
    ).toBeDefined();
  });

  it("frames Nex as a tutor that finds the mistake, no jargon", () => {
    render(<SceneSession />);
    expect(
      screen.getByText(/doesn't just give you the answer/i),
    ).toBeDefined();
    expect(screen.queryByText(/Socratic/i)).toBeNull();
  });
});
