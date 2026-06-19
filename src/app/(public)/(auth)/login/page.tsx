import { AuthForm } from "@/features/auth/components/AuthForm";

export default async function LoginPage({
  searchParams,
}: {
  searchParams: Promise<{ role?: string }>;
}) {
  const params = await searchParams;
  const role = params.role === "parent" ? "parent" : "student";

  return <AuthForm mode="login" role={role} />;
}
