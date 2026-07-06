import { render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { SceneMarksAndYears } from "@/app/(public)/_landing/SceneMarksAndYears";

// jsdom has no matchMedia: static final state (progress 1).
describe("SceneMarksAndYears", () => {
  it("shows the repaired panel in student voice", () => {
    render(<SceneMarksAndYears />);
    expect(screen.getByText("Topics still costing you marks")).toBeDefined();
    expect(screen.getByText("Marks won back")).toBeDefined();
    expect(screen.getByText("Fixed today")).toBeDefined();
    expect(screen.getByText("+12")).toBeDefined();
  });

  it("shows the Form 1 to Form 4 journey", () => {
    render(<SceneMarksAndYears />);
    expect(screen.getByText("Form 1")).toBeDefined();
    expect(screen.getByText("Form 4")).toBeDefined();
    expect(screen.getByText("Walk into KCSE ready")).toBeDefined();
  });
});
