import { describe, expect, it } from "vitest";

import robots from "@/app/robots";

describe("robots.txt", () => {
  it("disallows admin and authenticated student routes", () => {
    const rules = robots();
    const ruleList = Array.isArray(rules.rules) ? rules.rules : [rules.rules];
    const disallow = ruleList.flatMap((rule) =>
      Array.isArray(rule.disallow) ? rule.disallow : rule.disallow ? [rule.disallow] : [],
    );

    expect(disallow).toEqual(
      expect.arrayContaining(["/admin", "/dashboard", "/parent", "/nex", "/api/"]),
    );
  });

  it("allows public marketing routes", () => {
    const rules = robots();
    const ruleList = Array.isArray(rules.rules) ? rules.rules : [rules.rules];
    const allow = ruleList.flatMap((rule) =>
      Array.isArray(rule.allow) ? rule.allow : rule.allow ? [rule.allow] : [],
    );

    expect(allow).toEqual(expect.arrayContaining(["/", "/about", "/pricing"]));
  });
});
