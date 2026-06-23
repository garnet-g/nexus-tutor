import { redirect } from "next/navigation";

export const dynamic = "force-dynamic";

export default function LegacyContentPage() {
  redirect("/admin/studio");
}
