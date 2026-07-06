"use client";

import { Suspense } from "react";
import { useSearchParams } from "next/navigation";

function E2eForceErrorInner() {
  const searchParams = useSearchParams();

  if (searchParams.get("forceError") === "1") {
    throw new Error("E2E forced error for recovery boundary test");
  }

  return <p data-testid="e2e-force-error-ready">ready</p>;
}

export default function E2eForceErrorPage() {
  return (
    <Suspense fallback={<p data-testid="e2e-force-error-ready">ready</p>}>
      <E2eForceErrorInner />
    </Suspense>
  );
}
