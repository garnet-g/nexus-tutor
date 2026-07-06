-- PR-060 / PR-061: Parent product preferences and notification controls.
ALTER TABLE public.parent_profiles
  ADD COLUMN IF NOT EXISTS product_preferences JSONB NOT NULL DEFAULT '{}'::jsonb;

CREATE TABLE public.parent_notification_preferences (
  parent_id UUID PRIMARY KEY REFERENCES public.parent_profiles(id) ON DELETE CASCADE,
  channel_sms BOOLEAN NOT NULL DEFAULT true,
  channel_email BOOLEAN NOT NULL DEFAULT true,
  weekly_report BOOLEAN NOT NULL DEFAULT true,
  link_updates BOOLEAN NOT NULL DEFAULT true,
  at_risk_alerts BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_parent_notification_preferences_updated_at
  BEFORE UPDATE ON public.parent_notification_preferences
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.parent_notification_preferences ENABLE ROW LEVEL SECURITY;

CREATE POLICY parent_notification_preferences_own ON public.parent_notification_preferences
  FOR ALL
  USING (parent_id = public.auth_parent_id())
  WITH CHECK (parent_id = public.auth_parent_id());
