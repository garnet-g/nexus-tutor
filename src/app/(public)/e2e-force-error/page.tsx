"use client";

import { useEffect, useState } from "react";

export default function E2eForceErrorPage() {
  const [shouldThrow, setShouldThrow] = useState(false);

  useEffect(() => {
    const params = new URLSearchParams(window.location.search);
    if (params.get("forceError") === "1") {
      setShouldThrow(true);
    }
  }, []);

  if (shouldThrow) {
    throw new Error("E2E forced error for recovery boundary test");
  }

  return <p data-testid="e2e-force-error-ready">ready</p>;
}
