import { Skeleton } from "@/components/ui/Skeleton";

export default function RevisionLoading() {
  return (
    <div className="space-y-6">
      <Skeleton className="h-40 rounded-[28px]" />
      <div className="grid gap-4 lg:grid-cols-[1.35fr_0.65fr]">
        <Skeleton className="h-96 rounded-[22px]" />
        <div className="space-y-4">
          <Skeleton className="h-48 rounded-[22px]" />
          <Skeleton className="h-44 rounded-[22px]" />
        </div>
      </div>
      <div className="grid gap-4 lg:grid-cols-2">
        <Skeleton className="h-72 rounded-[22px]" />
        <Skeleton className="h-72 rounded-[22px]" />
      </div>
    </div>
  );
}
