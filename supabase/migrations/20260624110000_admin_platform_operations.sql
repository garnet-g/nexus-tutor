-- Admin platform operations layer.
-- These tables support the second admin dashboard layer: alerts, role mapping,
-- communications, experiments, saved views, and approval workflows.

CREATE TABLE public.admin_alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  alert_type TEXT NOT NULL,
  severity TEXT NOT NULL DEFAULT 'watch'
    CHECK (severity IN ('critical', 'urgent', 'watch')),
  title TEXT NOT NULL,
  description TEXT,
  source TEXT NOT NULL DEFAULT 'system',
  status TEXT NOT NULL DEFAULT 'open'
    CHECK (status IN ('open', 'acknowledged', 'resolved')),
  target_type TEXT,
  target_id TEXT,
  assigned_to_user_id UUID REFERENCES auth.users(id),
  resolved_by UUID REFERENCES auth.users(id),
  resolved_at TIMESTAMPTZ,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_alerts_status ON public.admin_alerts(status, severity, created_at DESC);
CREATE INDEX idx_admin_alerts_target ON public.admin_alerts(target_type, target_id);

CREATE TABLE public.admin_role_assignments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  role_key TEXT NOT NULL
    CHECK (role_key IN ('super_admin', 'support', 'content_reviewer', 'finance_admin', 'growth_admin', 'ops_admin')),
  assigned_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (user_id, role_key)
);

CREATE TABLE public.admin_communication_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_key TEXT NOT NULL UNIQUE,
  channel TEXT NOT NULL CHECK (channel IN ('sms', 'email')),
  title TEXT NOT NULL,
  body TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.admin_communication_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_id UUID REFERENCES public.admin_communication_templates(id) ON DELETE SET NULL,
  channel TEXT NOT NULL CHECK (channel IN ('sms', 'email')),
  target_student_id UUID REFERENCES public.student_profiles(id) ON DELETE SET NULL,
  target_parent_id UUID REFERENCES public.parent_profiles(id) ON DELETE SET NULL,
  recipient TEXT,
  message_body TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'queued'
    CHECK (status IN ('queued', 'sent', 'failed', 'mocked')),
  provider_message_id TEXT,
  created_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_communication_logs_target ON public.admin_communication_logs(target_student_id, target_parent_id, created_at DESC);

CREATE TABLE public.admin_experiments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  experiment_key TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  hypothesis TEXT,
  status TEXT NOT NULL DEFAULT 'draft'
    CHECK (status IN ('draft', 'running', 'paused', 'completed')),
  metric_key TEXT NOT NULL DEFAULT 'conversion',
  variants JSONB NOT NULL DEFAULT '[]'::jsonb,
  started_at TIMESTAMPTZ,
  ended_at TIMESTAMPTZ,
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.admin_saved_views (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  view_key TEXT NOT NULL UNIQUE,
  title TEXT NOT NULL,
  route TEXT NOT NULL,
  filters JSONB NOT NULL DEFAULT '{}'::jsonb,
  owner_user_id UUID REFERENCES auth.users(id),
  is_shared BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.admin_approval_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  request_type TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  target_type TEXT,
  target_id TEXT,
  status TEXT NOT NULL DEFAULT 'pending'
    CHECK (status IN ('pending', 'approved', 'rejected', 'cancelled')),
  requested_by UUID REFERENCES auth.users(id),
  reviewed_by UUID REFERENCES auth.users(id),
  reviewed_at TIMESTAMPTZ,
  metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_approval_requests_status ON public.admin_approval_requests(status, created_at DESC);

CREATE TRIGGER trg_admin_alerts_updated_at
  BEFORE UPDATE ON public.admin_alerts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_admin_communication_templates_updated_at
  BEFORE UPDATE ON public.admin_communication_templates
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_admin_experiments_updated_at
  BEFORE UPDATE ON public.admin_experiments
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_admin_saved_views_updated_at
  BEFORE UPDATE ON public.admin_saved_views
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_admin_approval_requests_updated_at
  BEFORE UPDATE ON public.admin_approval_requests
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.admin_alerts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_role_assignments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_communication_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_communication_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_experiments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_saved_views ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_approval_requests ENABLE ROW LEVEL SECURITY;
