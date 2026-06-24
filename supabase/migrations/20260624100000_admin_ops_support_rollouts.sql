-- Admin operations layer:
--   1. public.admin_support_cases stores lightweight internal support cases tied
--      to student/parent accounts and admin actions.
--   2. public.admin_feature_rollouts stores scoped feature flags for controlled
--      v2 rollouts such as camera, mock exams, science/English, and voice.
--
-- Both tables are admin-only. Reads and writes go through service-role-backed
-- admin routes. RLS is deny-all for normal anon/authenticated clients.

CREATE TABLE public.admin_support_cases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  target_student_id UUID REFERENCES public.student_profiles(id) ON DELETE SET NULL,
  target_parent_id UUID REFERENCES public.parent_profiles(id) ON DELETE SET NULL,
  issue_type TEXT NOT NULL
    CHECK (issue_type IN ('account', 'billing', 'learning', 'content', 'nex', 'parent', 'technical', 'other')),
  priority TEXT NOT NULL DEFAULT 'medium'
    CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  status TEXT NOT NULL DEFAULT 'open'
    CHECK (status IN ('open', 'in_progress', 'waiting_on_user', 'resolved')),
  title TEXT NOT NULL,
  notes TEXT,
  assigned_to_user_id UUID REFERENCES auth.users(id),
  created_by UUID REFERENCES auth.users(id),
  updated_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_admin_support_cases_status ON public.admin_support_cases(status, priority, created_at DESC);
CREATE INDEX idx_admin_support_cases_student ON public.admin_support_cases(target_student_id);
CREATE INDEX idx_admin_support_cases_parent ON public.admin_support_cases(target_parent_id);

CREATE TABLE public.admin_feature_rollouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  feature_key TEXT NOT NULL,
  display_name TEXT NOT NULL,
  description TEXT,
  is_enabled BOOLEAN NOT NULL DEFAULT false,
  scope TEXT NOT NULL DEFAULT 'global'
    CHECK (scope IN ('global', 'curriculum', 'grade', 'cohort', 'student', 'role')),
  scope_value TEXT,
  updated_by UUID REFERENCES auth.users(id),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (feature_key, scope, scope_value)
);

CREATE INDEX idx_admin_feature_rollouts_key ON public.admin_feature_rollouts(feature_key);
CREATE INDEX idx_admin_feature_rollouts_enabled ON public.admin_feature_rollouts(is_enabled, scope);

CREATE TRIGGER trg_admin_support_cases_updated_at
  BEFORE UPDATE ON public.admin_support_cases
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_admin_feature_rollouts_updated_at
  BEFORE UPDATE ON public.admin_feature_rollouts
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.admin_support_cases ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.admin_feature_rollouts ENABLE ROW LEVEL SECURITY;
