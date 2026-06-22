-- Admin user-management support tables (Phase 3a):
--   * admin_impersonation_sessions: audited, time-boxed "view as student" sessions.
--     This is a READ-ONLY admin render — it never signs in as the user or issues
--     their JWT. Each session is bounded by expires_at and may be ended early.
--   * admin_subscription_grants: append-only trail of manual comp/grant actions a
--     super admin performs on a student's subscription (no money movement).
-- Both are NEW tables, independent of public.admin_audit_log (the broad action
-- ledger) and public.platform_settings_audit_log (the settings ledger).

CREATE TABLE public.admin_impersonation_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_user_id UUID NOT NULL REFERENCES auth.users(id),
  target_student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  reason TEXT NOT NULL,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  expires_at TIMESTAMPTZ NOT NULL,
  ended_at TIMESTAMPTZ
);

CREATE INDEX idx_admin_impersonation_admin ON public.admin_impersonation_sessions(admin_user_id);
CREATE INDEX idx_admin_impersonation_target ON public.admin_impersonation_sessions(target_student_id);
CREATE INDEX idx_admin_impersonation_expires ON public.admin_impersonation_sessions(expires_at);

CREATE TABLE public.admin_subscription_grants (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_user_id UUID NOT NULL REFERENCES auth.users(id),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  plan_code TEXT NOT NULL,
  reason TEXT NOT NULL,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_subscription_grants_student ON public.admin_subscription_grants(student_id);

-- Deny-all by default: no permissive policies for anon/authenticated.
-- Admin reads and writes go exclusively through the service-role client, which
-- bypasses RLS. This mirrors how other admin-only tables (e.g. admin_audit_log,
-- platform_settings, platform_settings_audit_log) are treated.
ALTER TABLE public.admin_impersonation_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_subscription_grants ENABLE ROW LEVEL SECURITY;
