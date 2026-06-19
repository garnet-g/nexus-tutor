-- Family subscription groups and seat management

CREATE TABLE public.family_groups (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  owner_user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  owner_student_id UUID REFERENCES public.student_profiles(id) ON DELETE SET NULL,
  student_subscription_id UUID REFERENCES public.student_subscriptions(id) ON DELETE SET NULL,
  invite_code TEXT NOT NULL UNIQUE,
  max_seats INTEGER NOT NULL DEFAULT 4,
  seat_count INTEGER NOT NULL DEFAULT 1,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_family_groups_invite ON public.family_groups(invite_code);
CREATE INDEX idx_family_groups_owner ON public.family_groups(owner_user_id);

CREATE TABLE public.family_group_members (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  family_group_id UUID NOT NULL REFERENCES public.family_groups(id) ON DELETE CASCADE,
  student_id UUID NOT NULL UNIQUE REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  joined_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (family_group_id, student_id)
);

CREATE TRIGGER trg_family_groups_updated_at
  BEFORE UPDATE ON public.family_groups
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.family_groups ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.family_group_members ENABLE ROW LEVEL SECURITY;

-- Members can read their family group
CREATE POLICY family_groups_member_read ON public.family_groups FOR SELECT TO authenticated
  USING (
    owner_user_id = auth.uid()
    OR EXISTS (
      SELECT 1 FROM public.family_group_members fgm
      JOIN public.student_profiles sp ON sp.id = fgm.student_id
      WHERE fgm.family_group_id = family_groups.id AND sp.user_id = auth.uid()
    )
  );

CREATE POLICY family_group_members_read ON public.family_group_members FOR SELECT TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM public.family_groups fg
      WHERE fg.id = family_group_id
        AND (
          fg.owner_user_id = auth.uid()
          OR EXISTS (
            SELECT 1 FROM public.student_profiles sp
            WHERE sp.id = family_group_members.student_id AND sp.user_id = auth.uid()
          )
        )
    )
  );

-- Additional SMS/email templates for notification triggers
INSERT INTO public.sms_templates (template_code, sms_body_template) VALUES
  ('diagnostic_complete', 'Great work {{studentName}}! Your Academic Health Score is {{healthScore}}%. Log in: {{appUrl}}'),
  ('trial_ending', 'Nexus: Your free trial ends in {{daysRemaining}} days. Upgrade: {{appUrl}}/pricing'),
  ('trial_expired', 'Nexus: Your trial has ended. Upgrade to Premium: {{appUrl}}/pricing'),
  ('weekly_streak', 'Nexus: {{studentName}}, you hit a 7-day study streak! Keep going!')
ON CONFLICT (template_code) DO NOTHING;

INSERT INTO public.email_templates (template_code, email_subject_template, email_body_template) VALUES
  ('weekly_parent_report', 'Weekly progress for {{studentName}}', '<p>Study time: {{studyMinutes}} min. Health score: {{healthScore}}%. Weak topics: {{weakTopics}}.</p>')
ON CONFLICT (template_code) DO NOTHING;
