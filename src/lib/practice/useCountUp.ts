"use client";

import { useEffect, useRef, useState } from "react";

function prefersReducedMotion(): boolean {
  return (
    typeof window !== "undefined" &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches
  );
}

export function useCountUp(
  target: number,
  enabled = true,
  durationMs = 700,
): number {
  const shouldAnimate =
    enabled && target > 0 && !prefersReducedMotion();
  const [animatedValue, setAnimatedValue] = useState(0);
  const frameRef = useRef<number | null>(null);

  useEffect(() => {
    if (!shouldAnimate) {
      return;
    }

    const start = performance.now();

    function tick(now: number) {
      const progress = Math.min(1, (now - start) / durationMs);
      setAnimatedValue(Math.round(target * progress));
      if (progress < 1) {
        frameRef.current = requestAnimationFrame(tick);
      }
    }

    frameRef.current = requestAnimationFrame(tick);

    return () => {
      if (frameRef.current !== null) {
        cancelAnimationFrame(frameRef.current);
      }
    };
  }, [durationMs, shouldAnimate, target]);

  if (!enabled || target === 0 || prefersReducedMotion()) {
    return target;
  }

  return animatedValue;
}
