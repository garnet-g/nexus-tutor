-- Admin audit log: append-only record of privileged admin actions across the
-- platform (platform settings, beta invites, content pipeline, assessment, etc.).
-- This is a NEW table and is independent of public.platform_settings_audit_log,
-- which remains the narrower settings-change ledger and is untouched here.

CREATE TABLE public.admin_audit_log (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  actor_user_id UUID NOT NULL REFERENCES auth.users(id),
  actor_role TEXT NOT NULL,
  action TEXT NOT NULL,
  target_type TEXT,
  target_id TEXT,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  ip_address TEXT,
  user_agent TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_audit_log_created ON public.admin_audit_log(created_at DESC);
CREATE INDEX idx_admin_audit_log_actor ON public.admin_audit_log(actor_user_id);
CREATE INDEX idx_admin_audit_log_action ON public.admin_audit_log(action);
CREATE INDEX idx_admin_audit_log_target ON public.admin_audit_log(target_type, target_id);

-- Deny-all by default: no permissive policies for anon/authenticated.
-- Admin reads and writes go exclusively through the service-role client, which
-- bypasses RLS. This mirrors how other admin-only tables (e.g.
-- platform_settings, platform_settings_audit_log) are treated.
ALTER TABLE public.admin_audit_log ENABLE ROW LEVEL SECURITY;
