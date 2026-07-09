"use client";

import { useEffect, useState } from "react";
import { RotateCcw, X } from "lucide-react";

import { cn } from "@/lib/utils";

interface DueReview {
  id: string;
  errorCode: string;
  description: string;
  topicId: string | null;
}

interface NexReviewBannerProps {
  onSelectReview: (review: DueReview) => void;
  className?: string;
}

export function NexReviewBanner({ onSelectReview, className }: NexReviewBannerProps) {
  const [reviews, setReviews] = useState<DueReview[]>([]);
  const [dismissedIds, setDismissedIds] = useState<Set<string>>(new Set());

  useEffect(() => {
    let cancelled = false;

    void (async () => {
      try {
        const response = await fetch("/api/nex/reviews/due");
        const payload = (await response.json()) as {
          success: boolean;
          data?: DueReview[];
        };

        if (!cancelled && response.ok && payload.success && payload.data) {
          setReviews(payload.data);
        }
      } catch {
        // Silent — the review banner is a nice-to-have, not critical path.
      }
    })();

    return () => {
      cancelled = true;
    };
  }, []);

  const visibleReview = reviews.find((review) => !dismissedIds.has(review.id));

  if (!visibleReview) {
    return null;
  }

  // "Not now" — hides the banner for this session only. Does not call the
  // resolve API: dismissing without practicing the item should not mark the
  // misconception as fixed, or the spaced-review loop stops tracking it the
  // moment a student clicks past the banner.
  function dismiss(reviewId: string) {
    setDismissedIds((prev) => new Set(prev).add(reviewId));
  }

  // Clicking "Try it" is the closest signal we have that the student is
  // engaging with the misconception again, so this is what actually closes
  // the review loop (resolve is fire-and-forget — a failure here shouldn't
  // block sending the practice prompt).
  function tryIt(review: DueReview) {
    setDismissedIds((prev) => new Set(prev).add(review.id));
    void fetch(`/api/nex/reviews/${review.id}/resolve`, { method: "POST" }).catch(
      () => undefined,
    );
    onSelectReview(review);
  }

  return (
    <div
      className={cn(
        "flex items-center justify-between gap-3 rounded-[14px] border border-nexus-primary/30 bg-nexus-primary/5 px-4 py-3",
        className,
      )}
      role="status"
    >
      <div className="flex items-center gap-2 text-sm text-foreground">
        <RotateCcw className="size-4 shrink-0 text-nexus-primary" aria-hidden />
        <span>You mixed this up before: {visibleReview.description}. Want a quick check?</span>
      </div>
      <div className="flex shrink-0 items-center gap-2">
        <button
          type="button"
          onClick={() => tryIt(visibleReview)}
          className="min-h-9 rounded-full bg-nexus-primary px-3 text-sm font-medium text-nexus-text-inverse hover:opacity-90"
        >
          Try it
        </button>
        <button
          type="button"
          onClick={() => dismiss(visibleReview.id)}
          aria-label="Dismiss review"
          className="flex size-9 items-center justify-center rounded-full text-muted-foreground hover:bg-nexus-sunken"
        >
          <X className="size-4" aria-hidden />
        </button>
      </div>
    </div>
  );
}
