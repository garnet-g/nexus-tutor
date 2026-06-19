-- Subscriptions, M-Pesa, notifications, parent reports

CREATE TABLE public.student_subscriptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  subscription_plan_id UUID NOT NULL REFERENCES public.subscription_plans(id),
  subscription_status TEXT NOT NULL DEFAULT 'active'
    CHECK (subscription_status IN ('trialing', 'active', 'past_due', 'cancelled', 'expired')),
  trial_started_at TIMESTAMPTZ,
  trial_ends_at TIMESTAMPTZ,
  current_period_start TIMESTAMPTZ,
  current_period_end TIMESTAMPTZ,
  cancelled_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.subscription_trials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL UNIQUE REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  trial_started_at TIMESTAMPTZ NOT NULL,
  trial_ends_at TIMESTAMPTZ NOT NULL,
  is_trial_active BOOLEAN NOT NULL DEFAULT true,
  converted_at TIMESTAMPTZ
);

CREATE TABLE public.mpesa_payments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  subscription_plan_id UUID NOT NULL REFERENCES public.subscription_plans(id),
  phone_number TEXT NOT NULL,
  amount_kes INTEGER NOT NULL,
  checkout_request_id TEXT UNIQUE,
  merchant_request_id TEXT,
  mpesa_receipt_number TEXT,
  payment_status TEXT NOT NULL DEFAULT 'pending'
    CHECK (payment_status IN ('pending', 'processing', 'paid', 'failed', 'cancelled', 'expired', 'refunded')),
  paid_at TIMESTAMPTZ,
  expires_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.mpesa_callbacks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mpesa_payment_id UUID NOT NULL REFERENCES public.mpesa_payments(id) ON DELETE CASCADE,
  checkout_request_id TEXT,
  callback_payload JSONB NOT NULL,
  result_code INTEGER,
  result_description TEXT,
  is_processed BOOLEAN NOT NULL DEFAULT false,
  processed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_mpesa_callbacks_checkout ON public.mpesa_callbacks(checkout_request_id);

CREATE TABLE public.payment_transactions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mpesa_payment_id UUID NOT NULL REFERENCES public.mpesa_payments(id) ON DELETE CASCADE,
  student_subscription_id UUID REFERENCES public.student_subscriptions(id),
  transaction_type TEXT NOT NULL DEFAULT 'subscription_payment',
  amount_kes INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.billing_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_subscription_id UUID NOT NULL REFERENCES public.student_subscriptions(id) ON DELETE CASCADE,
  event_type TEXT NOT NULL,
  event_payload JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.invoices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  mpesa_payment_id UUID REFERENCES public.mpesa_payments(id),
  amount_kes INTEGER NOT NULL,
  invoice_status TEXT NOT NULL DEFAULT 'paid' CHECK (invoice_status IN ('paid', 'void')),
  issued_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.sms_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_code TEXT NOT NULL UNIQUE,
  sms_body_template TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE public.celcom_sms_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID REFERENCES public.student_profiles(id),
  parent_id UUID REFERENCES public.parent_profiles(id),
  phone_number TEXT NOT NULL,
  sms_body TEXT NOT NULL,
  template_code TEXT,
  celcom_message_id TEXT,
  sms_status TEXT NOT NULL DEFAULT 'queued'
    CHECK (sms_status IN ('queued', 'sent', 'delivered', 'failed')),
  sent_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_celcom_sms_phone ON public.celcom_sms_logs(phone_number, created_at DESC);

CREATE TABLE public.email_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  template_code TEXT NOT NULL UNIQUE,
  email_subject_template TEXT NOT NULL,
  email_body_template TEXT NOT NULL,
  is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE public.resend_email_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  recipient_email TEXT NOT NULL,
  email_subject TEXT NOT NULL,
  template_code TEXT,
  resend_email_id TEXT,
  email_status TEXT NOT NULL DEFAULT 'queued'
    CHECK (email_status IN ('queued', 'sent', 'delivered', 'opened', 'failed', 'bounced')),
  sent_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_resend_email_recipient ON public.resend_email_logs(recipient_email, created_at DESC);

CREATE TABLE public.parent_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_id UUID NOT NULL REFERENCES public.parent_profiles(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  report_type TEXT NOT NULL DEFAULT 'weekly',
  report_payload JSONB NOT NULL DEFAULT '{}',
  generated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.weekly_reports (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  parent_report_id UUID NOT NULL REFERENCES public.parent_reports(id) ON DELETE CASCADE,
  week_start_date DATE NOT NULL,
  weekly_study_minutes INTEGER NOT NULL DEFAULT 0,
  weekly_health_score NUMERIC(5,2),
  weekly_weak_topics JSONB NOT NULL DEFAULT '[]',
  predicted_grade TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TRIGGER trg_student_subscriptions_updated_at
  BEFORE UPDATE ON public.student_subscriptions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TRIGGER trg_mpesa_payments_updated_at
  BEFORE UPDATE ON public.mpesa_payments
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();
