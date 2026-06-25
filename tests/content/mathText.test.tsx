import { render } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { MathText } from "@/components/content/MathText";

describe("MathText", () => {
  it("renders LaTeX as KaTeX markup", () => {
    const { container } = render(<MathText inline>{"$\\frac{3}{4}$"}</MathText>);
    expect(container.querySelector(".katex")).not.toBeNull();
  });

  it("passes plain text through unchanged", () => {
    const { container } = render(<MathText inline>{"Hello world"}</MathText>);
    expect(container.textContent).toContain("Hello world");
  });
});
