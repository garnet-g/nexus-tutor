import { SectionCard } from "@/components/ui/SectionCard";
import { Skeleton } from "@/components/ui/Skeleton";

export default function AdminContentLoading() {
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <Skeleton variant="line" className="h-9 max-w-sm" />
        <Skeleton variant="line" className="h-5 max-w-xl" />
      </div>
      <div className="flex gap-2">
        <Skeleton variant="block" className="h-11 w-32" />
        <Skeleton variant="block" className="h-11 w-40" />
      </div>
      <SectionCard title="Loading content pipeline">
        <Skeleton variant="card" />
        <div className="mt-4 space-y-3">
          <Skeleton variant="block" />
          <Skeleton variant="block" />
          <Skeleton variant="block" />
        </div>
      </SectionCard>
    </div>
  );
}
