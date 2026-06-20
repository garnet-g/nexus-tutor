import { cn } from "@/lib/utils";

type SkeletonVariant = "line" | "text" | "card" | "ring" | "block";

interface SkeletonProps {
  variant?: SkeletonVariant;
  className?: string;
  lines?: number;
}

const variantClass: Record<SkeletonVariant, string> = {
  line: "h-4 w-full max-w-md rounded-lg",
  text: "h-3 w-full rounded-md",
  card: "h-32 w-full rounded-[22px]",
  ring: "size-24 rounded-full",
  block: "h-12 w-full rounded-xl",
};

export function Skeleton({
  variant = "line",
  className,
  lines = 1,
}: SkeletonProps) {
  if (variant === "text" && lines > 1) {
    return (
      <div className={cn("space-y-2", className)}>
        {Array.from({ length: lines }).map((_, index) => (
          <div
            key={index}
            className={cn(
              "animate-pulse bg-nexus-sunken",
              variantClass.text,
              index === lines - 1 && "w-4/5",
            )}
          />
        ))}
      </div>
    );
  }

  return (
    <div
      aria-hidden
      className={cn(
        "animate-pulse bg-nexus-sunken",
        variantClass[variant],
        className,
      )}
    />
  );
}

export function LearnPageSkeleton() {
  return (
    <div className="space-y-8 nexus-enter">
      <div className="space-y-3">
        <Skeleton variant="line" className="h-8 w-48" />
        <Skeleton variant="text" lines={2} />
      </div>
      <Skeleton variant="card" className="h-24" />
      <div className="grid gap-4 sm:grid-cols-2">
        <Skeleton variant="card" />
        <Skeleton variant="card" />
      </div>
    </div>
  );
}

export function TopicPageSkeleton() {
  return (
    <div className="space-y-8 nexus-enter">
      <Skeleton variant="line" className="h-4 w-32" />
      <Skeleton variant="line" className="h-9 w-64" />
      <div className="grid gap-8 lg:grid-cols-[1fr_320px]">
        <div className="space-y-4">
          {Array.from({ length: 4 }).map((_, index) => (
            <Skeleton key={index} variant="block" className="h-20" />
          ))}
        </div>
        <Skeleton variant="card" className="h-64" />
      </div>
    </div>
  );
}

export function LessonPageSkeleton() {
  return (
    <div className="space-y-8 nexus-enter">
      <Skeleton variant="line" className="h-4 w-40" />
      <Skeleton variant="line" className="h-10 w-3/4 max-w-lg" />
      <Skeleton variant="text" lines={6} />
      <Skeleton variant="card" className="h-40" />
    </div>
  );
}

export function PracticePageSkeleton() {
  return (
    <div className="space-y-6 nexus-enter">
      <Skeleton variant="card" className="h-28" />
      <div className="grid gap-4 sm:grid-cols-2">
        <Skeleton variant="card" className="h-40" />
        <Skeleton variant="card" className="h-40" />
      </div>
    </div>
  );
}

export function ProgressPageSkeleton() {
  return (
    <div className="space-y-6 nexus-enter">
      <div className="space-y-3">
        <Skeleton variant="line" className="h-4 w-24" />
        <Skeleton variant="line" className="h-9 w-56" />
        <Skeleton variant="text" lines={2} />
      </div>
      <Skeleton variant="card" className="h-32" />
      <div className="grid gap-6 lg:grid-cols-2">
        <Skeleton variant="card" className="h-72" />
        <Skeleton variant="card" className="h-72" />
      </div>
    </div>
  );
}

export function StudyPlanPageSkeleton() {
  return (
    <div className="space-y-6 nexus-enter">
      <div className="space-y-3">
        <Skeleton variant="line" className="h-4 w-24" />
        <Skeleton variant="line" className="h-9 w-48" />
        <Skeleton variant="text" lines={2} />
      </div>
      <div className="grid gap-6 lg:grid-cols-2">
        <Skeleton variant="card" className="h-44" />
        <Skeleton variant="card" className="h-44" />
      </div>
      <Skeleton variant="card" className="h-28" />
      <Skeleton variant="card" className="h-64" />
    </div>
  );
}
