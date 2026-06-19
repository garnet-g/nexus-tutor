import { AuthForm } from "@/features/auth/components/AuthForm";
import { isBetaInviteRequired } from "@/server/services/betaInviteService";

export default async function SignupPage({
  searchParams,
}: {
  searchParams: Promise<{ role?: string }>;
}) {
  const params = await searchParams;
  const role = params.role === "parent" ? "parent" : "student";
  const betaInviteRequired = isBetaInviteRequired();

  return (
    <AuthForm mode="signup" role={role} betaInviteRequired={betaInviteRequired} />
  );
}
