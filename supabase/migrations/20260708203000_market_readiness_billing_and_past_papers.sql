-- Kenya market readiness: term/daily/weekly billing plans, manual M-Pesa
-- reconciliation, Celcom WhatsApp logging, and the Past Papers Repository.

-- 1. New subscription plans -------------------------------------------------

INSERT INTO public.subscription_plans (plan_code, name, amount_kes, billing_cycle, is_active)
VALUES
  ('premium_daily', 'Premium Daily', 20, 'daily', true),
  ('premium_weekly', 'Premium Weekly', 150, 'weekly', true),
  ('premium_termly', 'Premium Termly', 1800, 'termly', true)
ON CONFLICT (plan_code) DO UPDATE
  SET name = EXCLUDED.name,
      amount_kes = EXCLUDED.amount_kes,
      billing_cycle = EXCLUDED.billing_cycle,
      is_active = EXCLUDED.is_active,
      updated_at = NOW();

-- 2. Manual M-Pesa reconciliation --------------------------------------------

CREATE TABLE public.mpesa_manual_verifications (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  subscription_plan_id UUID NOT NULL REFERENCES public.subscription_plans(id),
  mpesa_receipt_number TEXT NOT NULL,
  submitted_amount_kes INTEGER,
  verification_status TEXT NOT NULL DEFAULT 'pending'
    CHECK (verification_status IN ('pending', 'verified', 'rejected')),
  verification_source TEXT NOT NULL DEFAULT 'sandbox_auto'
    CHECK (verification_source IN ('sandbox_auto', 'daraja_transaction_status', 'manual_admin')),
  provider_result_payload JSONB,
  mpesa_payment_id UUID REFERENCES public.mpesa_payments(id) ON DELETE SET NULL,
  rejection_reason TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

CREATE UNIQUE INDEX uq_mpesa_manual_verifications_receipt
  ON public.mpesa_manual_verifications(mpesa_receipt_number);

CREATE INDEX idx_mpesa_manual_verifications_student
  ON public.mpesa_manual_verifications(student_id, created_at DESC);

ALTER TABLE public.mpesa_manual_verifications ENABLE ROW LEVEL SECURITY;

CREATE POLICY mpesa_manual_verifications_student_read
  ON public.mpesa_manual_verifications FOR SELECT
  USING (student_id = public.auth_student_id());

-- 3a. Allow the notification outbox to carry WhatsApp sends alongside sms/email.

ALTER TABLE public.notification_outbox
  DROP CONSTRAINT notification_outbox_channel_check;
ALTER TABLE public.notification_outbox
  ADD CONSTRAINT notification_outbox_channel_check
  CHECK (channel IN ('sms', 'email', 'whatsapp'));

-- 3b. Celcom WhatsApp notification logs ---------------------------------------

CREATE TABLE public.celcom_whatsapp_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID REFERENCES public.student_profiles(id) ON DELETE SET NULL,
  parent_id UUID REFERENCES public.parent_profiles(id) ON DELETE SET NULL,
  phone_number TEXT NOT NULL,
  message_body TEXT NOT NULL,
  template_code TEXT,
  celcom_message_id TEXT,
  whatsapp_status TEXT NOT NULL DEFAULT 'queued'
    CHECK (whatsapp_status IN ('queued', 'sent', 'delivered', 'failed')),
  sent_at TIMESTAMPTZ,
  delivered_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_celcom_whatsapp_logs_phone
  ON public.celcom_whatsapp_logs(phone_number, created_at DESC);

-- 4. Past Papers Repository ---------------------------------------------------

CREATE TABLE public.past_papers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  curriculum TEXT NOT NULL CHECK (curriculum IN ('CBC', 'KCSE')),
  subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  paper_year INTEGER NOT NULL,
  name TEXT NOT NULL,
  pdf_url TEXT NOT NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 150,
  total_marks INTEGER NOT NULL DEFAULT 100,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_past_papers_catalog
  ON public.past_papers(curriculum, subject_id, paper_year DESC)
  WHERE is_active = true;

CREATE TRIGGER trg_past_papers_updated_at
  BEFORE UPDATE ON public.past_papers
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.past_paper_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  past_paper_id UUID NOT NULL REFERENCES public.past_papers(id) ON DELETE CASCADE,
  question_number TEXT NOT NULL,
  question_text TEXT NOT NULL,
  marks INTEGER NOT NULL DEFAULT 1,
  marking_scheme TEXT NOT NULL,
  sort_order INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_past_paper_questions_paper
  ON public.past_paper_questions(past_paper_id, sort_order);

CREATE TABLE public.past_paper_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  past_paper_id UUID NOT NULL REFERENCES public.past_papers(id) ON DELETE CASCADE,
  status TEXT NOT NULL DEFAULT 'in_progress'
    CHECK (status IN ('in_progress', 'submitted', 'marking', 'marked')),
  score INTEGER,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  submitted_at TIMESTAMPTZ,
  marked_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_past_paper_attempts_student
  ON public.past_paper_attempts(student_id, created_at DESC);

ALTER TABLE public.past_paper_attempts ENABLE ROW LEVEL SECURITY;

CREATE POLICY past_paper_attempts_student ON public.past_paper_attempts FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE TABLE public.past_paper_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  attempt_id UUID NOT NULL REFERENCES public.past_paper_attempts(id) ON DELETE CASCADE,
  question_id UUID NOT NULL REFERENCES public.past_paper_questions(id) ON DELETE CASCADE,
  student_answer TEXT,
  ocr_image_url TEXT,
  score INTEGER,
  feedback TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (attempt_id, question_id)
);

CREATE TRIGGER trg_past_paper_answers_updated_at
  BEFORE UPDATE ON public.past_paper_answers
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.past_paper_answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY past_paper_answers_student ON public.past_paper_answers FOR ALL
  USING (
    attempt_id IN (
      SELECT id FROM public.past_paper_attempts
      WHERE student_id = public.auth_student_id()
    )
  )
  WITH CHECK (
    attempt_id IN (
      SELECT id FROM public.past_paper_attempts
      WHERE student_id = public.auth_student_id()
    )
  );

ALTER TABLE public.past_papers ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.past_paper_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY past_papers_student_read ON public.past_papers FOR SELECT
  USING (is_active = true);

CREATE POLICY past_paper_questions_student_read ON public.past_paper_questions FOR SELECT
  USING (
    past_paper_id IN (
      SELECT id FROM public.past_papers WHERE is_active = true
    )
  );

-- 5. Billing cycle-aware payment activation ----------------------------------
-- Replaces the hardcoded 30-day period and premium/family-only payable check
-- introduced in 20260701091000_phase03_payment_security_repair.sql so that
-- premium_daily / premium_weekly / premium_termly (and any future non-free
-- plan) can be activated with the correct subscription period length.

CREATE OR REPLACE FUNCTION public.process_verified_mpesa_payment(
  p_payment_id UUID,
  p_receipt TEXT,
  p_query_result_code INTEGER,
  p_query_payload JSONB,
  p_expected_amount INTEGER,
  p_family_max_seats INTEGER DEFAULT 4
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY INVOKER
SET search_path = ''
AS $$
DECLARE
  v_student_id UUID;
  v_plan_id UUID;
  v_amount INTEGER;
  v_status TEXT;
  v_existing_receipt TEXT;
  v_plan_code TEXT;
  v_billing_cycle TEXT;
  v_subscription_id UUID;
  v_existing_subscription_id UUID;
  v_period_start TIMESTAMPTZ := NOW();
  v_period_end TIMESTAMPTZ;
  v_owner_user_id UUID;
  v_family_group_id UUID;
  v_invite_code TEXT;
BEGIN
  IF p_query_result_code <> 0 THEN
    RAISE EXCEPTION 'Provider query is not successful';
  END IF;

  IF p_expected_amount IS NULL OR p_expected_amount <= 0 THEN
    RAISE EXCEPTION 'Verified amount must be positive';
  END IF;

  IF p_receipt IS NULL OR p_receipt !~ '^[A-Za-z0-9]+$' THEN
    RAISE EXCEPTION 'Invalid M-Pesa receipt';
  END IF;

  IF p_family_max_seats < 1 OR p_family_max_seats > 20 THEN
    RAISE EXCEPTION 'Invalid family seat limit';
  END IF;

  SELECT
    payment.student_id,
    payment.subscription_plan_id,
    payment.amount_kes,
    payment.payment_status,
    payment.mpesa_receipt_number,
    plan.plan_code,
    plan.billing_cycle
  INTO
    v_student_id,
    v_plan_id,
    v_amount,
    v_status,
    v_existing_receipt,
    v_plan_code,
    v_billing_cycle
  FROM public.mpesa_payments AS payment
  JOIN public.subscription_plans AS plan
    ON plan.id = payment.subscription_plan_id
  WHERE payment.id = p_payment_id
  FOR UPDATE OF payment;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'M-Pesa payment not found';
  END IF;

  SELECT txn.student_subscription_id
  INTO v_existing_subscription_id
  FROM public.payment_transactions AS txn
  WHERE txn.mpesa_payment_id = p_payment_id
  LIMIT 1;

  IF v_existing_subscription_id IS NOT NULL THEN
    RETURN jsonb_build_object(
      'activated', FALSE,
      'subscriptionId', v_existing_subscription_id
    );
  END IF;

  IF v_status = 'verified-paid' THEN
    RAISE EXCEPTION 'Verified payment requires manual reconciliation';
  END IF;

  IF v_status NOT IN ('processing', 'provider-pending') THEN
    RAISE EXCEPTION 'Payment is not processable from status %', v_status;
  END IF;

  IF v_plan_code = 'free' THEN
    RAISE EXCEPTION 'Plan is not payable';
  END IF;

  IF v_amount <> p_expected_amount THEN
    RAISE EXCEPTION 'Verified amount does not match payment';
  END IF;

  IF v_existing_receipt IS NOT NULL AND v_existing_receipt <> p_receipt THEN
    RAISE EXCEPTION 'Receipt does not match existing payment receipt';
  END IF;

  v_period_end := CASE v_billing_cycle
    WHEN 'daily' THEN v_period_start + INTERVAL '1 day'
    WHEN 'weekly' THEN v_period_start + INTERVAL '7 days'
    WHEN 'termly' THEN v_period_start + INTERVAL '120 days'
    ELSE v_period_start + INTERVAL '30 days'
  END;

  UPDATE public.mpesa_payments
  SET
    payment_status = 'verified-paid',
    mpesa_receipt_number = p_receipt,
    stk_query_verified_at = v_period_start,
    stk_query_result_code = p_query_result_code,
    stk_query_payload = COALESCE(p_query_payload, '{}'::JSONB),
    paid_at = v_period_start,
    updated_at = v_period_start
  WHERE id = p_payment_id;

  UPDATE public.subscription_trials
  SET
    is_trial_active = FALSE,
    converted_at = v_period_start
  WHERE student_id = v_student_id
    AND is_trial_active = TRUE;

  UPDATE public.student_subscriptions
  SET
    subscription_status = 'cancelled',
    cancelled_at = v_period_start,
    updated_at = v_period_start
  WHERE student_id = v_student_id
    AND subscription_status IN ('trialing', 'active');

  INSERT INTO public.student_subscriptions (
    student_id,
    subscription_plan_id,
    subscription_status,
    current_period_start,
    current_period_end
  )
  VALUES (
    v_student_id,
    v_plan_id,
    'active',
    v_period_start,
    v_period_end
  )
  RETURNING id INTO v_subscription_id;

  INSERT INTO public.payment_transactions (
    mpesa_payment_id,
    student_subscription_id,
    transaction_type,
    amount_kes
  )
  VALUES (
    p_payment_id,
    v_subscription_id,
    'subscription_payment',
    v_amount
  );

  INSERT INTO public.billing_events (
    student_subscription_id,
    event_type,
    event_payload
  )
  VALUES (
    v_subscription_id,
    'payment_received',
    jsonb_build_object(
      'mpesaPaymentId', p_payment_id,
      'mpesaReceiptNumber', p_receipt,
      'planCode', v_plan_code
    )
  );

  INSERT INTO public.invoices (
    student_id,
    mpesa_payment_id,
    amount_kes,
    invoice_status
  )
  VALUES (
    v_student_id,
    p_payment_id,
    v_amount,
    'paid'
  );

  IF v_plan_code = 'family' THEN
    SELECT profile.user_id
    INTO v_owner_user_id
    FROM public.student_profiles AS profile
    WHERE profile.id = v_student_id;

    IF v_owner_user_id IS NULL THEN
      RAISE EXCEPTION 'Family owner profile not found';
    END IF;

    SELECT family.id, family.invite_code
    INTO v_family_group_id, v_invite_code
    FROM public.family_groups AS family
    WHERE family.owner_student_id = v_student_id
      AND family.is_active = TRUE
    ORDER BY family.created_at DESC
    LIMIT 1
    FOR UPDATE;

    IF v_family_group_id IS NULL THEN
      v_invite_code := 'FAMILY-' || UPPER(
        SUBSTRING(REPLACE(gen_random_uuid()::TEXT, '-', '') FROM 1 FOR 12)
      );

      INSERT INTO public.family_groups (
        owner_user_id,
        owner_student_id,
        student_subscription_id,
        invite_code,
        max_seats,
        seat_count,
        is_active
      )
      VALUES (
        v_owner_user_id,
        v_student_id,
        v_subscription_id,
        v_invite_code,
        p_family_max_seats,
        1,
        TRUE
      )
      RETURNING id INTO v_family_group_id;
    ELSE
      UPDATE public.family_groups
      SET
        student_subscription_id = v_subscription_id,
        max_seats = GREATEST(p_family_max_seats, seat_count),
        updated_at = v_period_start
      WHERE id = v_family_group_id;
    END IF;

    INSERT INTO public.family_group_members (family_group_id, student_id)
    VALUES (v_family_group_id, v_student_id)
    ON CONFLICT (student_id) DO UPDATE
      SET family_group_id = EXCLUDED.family_group_id;
  END IF;

  RETURN jsonb_build_object(
    'activated', TRUE,
    'subscriptionId', v_subscription_id,
    'familyGroupId', v_family_group_id,
    'familyInviteCode', v_invite_code
  );
END;
$$;

REVOKE ALL ON FUNCTION public.process_verified_mpesa_payment(UUID, TEXT, INTEGER, JSONB, INTEGER, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.process_verified_mpesa_payment(UUID, TEXT, INTEGER, JSONB, INTEGER, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.process_verified_mpesa_payment(UUID, TEXT, INTEGER, JSONB, INTEGER, INTEGER) TO service_role;

-- 6. Storage bucket for past paper PDFs --------------------------------------
-- NOTE: requires user confirmation — see readiness.md "User Review Required".
-- Public read so students can view/download exam papers without a signed URL.

INSERT INTO storage.buckets (id, name, public)
VALUES ('past-papers-pdf', 'past-papers-pdf', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY past_papers_pdf_public_read ON storage.objects FOR SELECT
  USING (bucket_id = 'past-papers-pdf');

CREATE POLICY past_papers_pdf_service_write ON storage.objects FOR ALL
  USING (bucket_id = 'past-papers-pdf' AND auth.role() = 'service_role')
  WITH CHECK (bucket_id = 'past-papers-pdf' AND auth.role() = 'service_role');

-- Private bucket for student-submitted photos of handwritten working, used
-- by the AI marking flow. Access is via short-lived signed URLs only.

INSERT INTO storage.buckets (id, name, public)
VALUES ('past-paper-answer-photos', 'past-paper-answer-photos', false)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY past_paper_answer_photos_service_only ON storage.objects FOR ALL
  USING (bucket_id = 'past-paper-answer-photos' AND auth.role() = 'service_role')
  WITH CHECK (bucket_id = 'past-paper-answer-photos' AND auth.role() = 'service_role');
