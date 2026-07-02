-- Phase 03 production repair: close public RPC execution and make payment
-- verification + entitlement creation one atomic, idempotent transaction.

ALTER TABLE public.mpesa_payments
  ADD COLUMN IF NOT EXISTS stk_query_payload JSONB;

-- One payment can create only one transaction, invoice, and payment event.
CREATE UNIQUE INDEX IF NOT EXISTS uq_payment_transactions_mpesa_payment
  ON public.payment_transactions (mpesa_payment_id);

CREATE UNIQUE INDEX IF NOT EXISTS uq_invoices_mpesa_payment
  ON public.invoices (mpesa_payment_id)
  WHERE mpesa_payment_id IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_billing_events_payment_received_mpesa
  ON public.billing_events ((event_payload ->> 'mpesaPaymentId'))
  WHERE event_type = 'payment_received'
    AND event_payload ? 'mpesaPaymentId';

CREATE UNIQUE INDEX IF NOT EXISTS uq_family_groups_subscription
  ON public.family_groups (student_subscription_id)
  WHERE student_subscription_id IS NOT NULL;

-- These legacy helpers are called only through the server-side service-role
-- client. SECURITY INVOKER is sufficient and avoids privilege escalation.
ALTER FUNCTION public.transition_mpesa_payment(UUID, TEXT, TEXT[])
  SECURITY INVOKER;
ALTER FUNCTION public.record_mpesa_callback_event(TEXT, UUID, TEXT, JSONB, INTEGER, TEXT, TEXT)
  SECURITY INVOKER;
ALTER FUNCTION public.verify_and_mark_mpesa_paid(UUID, TEXT, INTEGER, JSONB)
  SECURITY INVOKER;

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
  v_subscription_id UUID;
  v_existing_subscription_id UUID;
  v_period_start TIMESTAMPTZ := NOW();
  v_period_end TIMESTAMPTZ := NOW() + INTERVAL '30 days';
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
    plan.plan_code
  INTO
    v_student_id,
    v_plan_id,
    v_amount,
    v_status,
    v_existing_receipt,
    v_plan_code
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

  IF v_plan_code NOT IN ('premium', 'family') THEN
    RAISE EXCEPTION 'Plan is not payable';
  END IF;

  IF v_amount <> p_expected_amount THEN
    RAISE EXCEPTION 'Verified amount does not match payment';
  END IF;

  IF v_existing_receipt IS NOT NULL AND v_existing_receipt <> p_receipt THEN
    RAISE EXCEPTION 'Receipt does not match existing payment receipt';
  END IF;

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

-- Supabase exposes public functions through PostgREST. Default EXECUTE is
-- granted to PUBLIC, so revoke both PUBLIC and API roles explicitly.
REVOKE ALL ON FUNCTION public.transition_mpesa_payment(UUID, TEXT, TEXT[]) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.transition_mpesa_payment(UUID, TEXT, TEXT[]) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.transition_mpesa_payment(UUID, TEXT, TEXT[]) TO service_role;

REVOKE ALL ON FUNCTION public.record_mpesa_callback_event(TEXT, UUID, TEXT, JSONB, INTEGER, TEXT, TEXT) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.record_mpesa_callback_event(TEXT, UUID, TEXT, JSONB, INTEGER, TEXT, TEXT) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.record_mpesa_callback_event(TEXT, UUID, TEXT, JSONB, INTEGER, TEXT, TEXT) TO service_role;

REVOKE ALL ON FUNCTION public.verify_and_mark_mpesa_paid(UUID, TEXT, INTEGER, JSONB) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.verify_and_mark_mpesa_paid(UUID, TEXT, INTEGER, JSONB) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.verify_and_mark_mpesa_paid(UUID, TEXT, INTEGER, JSONB) TO service_role;

REVOKE ALL ON FUNCTION public.process_verified_mpesa_payment(UUID, TEXT, INTEGER, JSONB, INTEGER, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.process_verified_mpesa_payment(UUID, TEXT, INTEGER, JSONB, INTEGER, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.process_verified_mpesa_payment(UUID, TEXT, INTEGER, JSONB, INTEGER, INTEGER) TO service_role;

-- Secure-by-default for functions created by future migrations owned by postgres.
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  REVOKE EXECUTE ON FUNCTIONS FROM PUBLIC;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public
  REVOKE EXECUTE ON FUNCTIONS FROM anon, authenticated;
