import { render, screen, waitFor } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";

import { ScrollScene } from "@/app/(public)/_landing/ScrollScene";

function stubMatchMedia(matches: boolean) {
  window.matchMedia = vi.fn().mockReturnValue({
    matches,
    addEventListener: vi.fn(),
    removeEventListener: vi.fn(),
  }) as unknown as typeof window.matchMedia;
}

afterEach(() => {
  vi.restoreAllMocks();
  // @ts-expect-error jsdom has no matchMedia; remove our stub between tests
  delete window.matchMedia;
});

describe("ScrollScene", () => {
  it("renders the final state (progress 1) under prefers-reduced-motion", () => {
    stubMatchMedia(true);
    render(<ScrollScene length={3}>{(p) => <p>progress:{p}</p>}</ScrollScene>);
    expect(screen.getByText("progress:1")).toBeDefined();
  });

  it("renders the final state when matchMedia is unavailable (no-JS-equivalent)", () => {
    render(<ScrollScene length={3}>{(p) => <p>progress:{p}</p>}</ScrollScene>);
    expect(screen.getByText("progress:1")).toBeDefined();
  });

  it("pins to a tall section and scrubs from the top when motion is allowed", async () => {
    stubMatchMedia(false);
    vi.spyOn(Element.prototype, "getBoundingClientRect").mockReturnValue({
      top: 0,
      bottom: 2304,
      height: 2304,
      left: 0,
      right: 0,
      width: 0,
      x: 0,
      y: 0,
      toJSON: () => ({}),
    } as DOMRect);
    const { container } = render(
      <ScrollScene length={3}>{(p) => <p>progress:{p}</p>}</ScrollScene>,
    );
    // Pinning is deferred behind requestAnimationFrame, so wait for it.
    const section = container.querySelector("section");
    await waitFor(() => expect(section?.style.height).toBe("300vh"));
    // jsdom innerHeight is 768: scrollable = 2304 - 768, top = 0 -> progress 0
    await waitFor(() => expect(screen.getByText("progress:0")).toBeDefined());
  });
});
