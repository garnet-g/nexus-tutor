import { describe, expect, it } from "vitest";
import { renderToStaticMarkup } from "react-dom/server";

import { NexMessageContent } from "@/features/nex/components/NexMessageContent";

describe("NexMessageContent", () => {
  it("renders inline and block math markers without crashing", () => {
    const html = renderToStaticMarkup(
      <NexMessageContent content="Inline $x^2$ and block:\n\n$$\\frac{a}{b}$$" />,
    );

    expect(html).toContain("katex");
  });

  it("renders markdown lists and code", () => {
    const html = renderToStaticMarkup(
      <NexMessageContent content="- first\n- second\n\n`code`" />,
    );

    expect(html).toContain("<ul");
    expect(html).toContain("first");
    expect(html).toContain("<code");
  });
});
