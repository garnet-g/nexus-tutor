-- Phase 03: payment trust — state machine, callback idempotency, receipt uniqueness

ALTER TABLE public.mpesa_payments
  DROP CONSTRAINT IF EXISTS mpesa_payments_payment_status_check;

-- Migrate legacy statuses before new CHECK
UPDATE public.mpesa_payments
SET payment_status = 'verified-paid'
WHERE payment_status = 'paid';

UPDATE public.mpesa_payments
SET payment_status = 'verified-failed'
WHERE payment_status IN ('failed', 'cancelled');

ALTER TABLE public.mpesa_payments
  ADD CONSTRAINT mpesa_payments_payment_status_check
  CHECK (payment_status IN (
    'pending', 'processing', 'provider-pending',
    'verified-paid', 'verified-failed', 'expired', 'refunded'
  ));

ALTER TABLE public.mpesa_payments
  ADD COLUMN IF NOT EXISTS callback_secret_hash TEXT,
  ADD COLUMN IF NOT EXISTS stk_query_verified_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS stk_query_result_code INTEGER,
  ADD COLUMN IF NOT EXISTS provider_pending_at TIMESTAMPTZ;

CREATE UNIQUE INDEX IF NOT EXISTS uq_mpesa_payments_receipt
  ON public.mpesa_payments (mpesa_receipt_number)
  WHERE mpesa_receipt_number IS NOT NULL;

CREATE UNIQUE INDEX IF NOT EXISTS uq_mpesa_payments_active_student_plan
  ON public.mpesa_payments (student_id, subscription_plan_id)
  WHERE payment_status IN ('pending', 'processing', 'provider-pending');

-- Evolve callback ledger
ALTER TABLE public.mpesa_callbacks RENAME TO mpesa_callback_events;

ALTER TABLE public.mpesa_callback_events
  ADD COLUMN IF NOT EXISTS idempotency_key TEXT,
  ADD COLUMN IF NOT EXISTS event_source TEXT NOT NULL DEFAULT 'daraja_callback';

UPDATE public.mpesa_callback_events
SET idempotency_key = 'legacy:' || id::text
WHERE idempotency_key IS NULL;

ALTER TABLE public.mpesa_callback_events
  ALTER COLUMN idempotency_key SET NOT NULL;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_constraint
    WHERE conname = 'mpesa_callback_events_event_source_check'
  ) THEN
    ALTER TABLE public.mpesa_callback_events
      ADD CONSTRAINT mpesa_callback_events_event_source_check
      CHECK (event_source IN ('daraja_callback', 'stk_query', 'reconciliation'));
  END IF;
END $$;

CREATE UNIQUE INDEX IF NOT EXISTS uq_mpesa_callback_events_idempotency
  ON public.mpesa_callback_events (idempotency_key);

CREATE TABLE IF NOT EXISTS public.celcom_webhook_events (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  idempotency_key TEXT NOT NULL UNIQUE,
  celcom_message_id TEXT,
  payload JSONB NOT NULL,
  processed_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE OR REPLACE FUNCTION public.transition_mpesa_payment(
  p_payment_id UUID,
  p_to_status TEXT,
  p_expected_from TEXT[]
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_current TEXT;
BEGIN
  SELECT payment_status INTO v_current
  FROM public.mpesa_payments
  WHERE id = p_payment_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;

  IF v_current = 'verified-paid' OR v_current = 'refunded' THEN
    RETURN FALSE;
  END IF;

  IF NOT (v_current = ANY(p_expected_from)) THEN
    RETURN FALSE;
  END IF;

  UPDATE public.mpesa_payments
  SET
    payment_status = p_to_status,
    updated_at = NOW(),
    provider_pending_at = CASE
      WHEN p_to_status = 'provider-pending' THEN NOW()
      ELSE provider_pending_at
    END
  WHERE id = p_payment_id;

  RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION public.record_mpesa_callback_event(
  p_idempotency_key TEXT,
  p_mpesa_payment_id UUID,
  p_checkout_request_id TEXT,
  p_callback_payload JSONB,
  p_result_code INTEGER,
  p_result_description TEXT,
  p_event_source TEXT DEFAULT 'daraja_callback'
)
RETURNS UUID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_id UUID;
BEGIN
  INSERT INTO public.mpesa_callback_events (
    idempotency_key,
    mpesa_payment_id,
    checkout_request_id,
    callback_payload,
    result_code,
    result_description,
    event_source,
    is_processed
  )
  VALUES (
    p_idempotency_key,
    p_mpesa_payment_id,
    p_checkout_request_id,
    p_callback_payload,
    p_result_code,
    p_result_description,
    p_event_source,
    FALSE
  )
  ON CONFLICT (idempotency_key) DO NOTHING
  RETURNING id INTO v_id;

  RETURN v_id;
END;
$$;

CREATE OR REPLACE FUNCTION public.verify_and_mark_mpesa_paid(
  p_payment_id UUID,
  p_receipt TEXT,
  p_query_result_code INTEGER,
  p_query_payload JSONB DEFAULT '{}'::jsonb
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = public
AS $$
DECLARE
  v_status TEXT;
BEGIN
  SELECT payment_status INTO v_status
  FROM public.mpesa_payments
  WHERE id = p_payment_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN FALSE;
  END IF;

  IF v_status = 'verified-paid' THEN
    RETURN TRUE;
  END IF;

  IF v_status NOT IN ('processing', 'provider-pending') THEN
    RETURN FALSE;
  END IF;

  BEGIN
    UPDATE public.mpesa_payments
    SET
      payment_status = 'verified-paid',
      mpesa_receipt_number = p_receipt,
      stk_query_verified_at = NOW(),
      stk_query_result_code = p_query_result_code,
      paid_at = NOW(),
      updated_at = NOW()
    WHERE id = p_payment_id;
  EXCEPTION
    WHEN unique_violation THEN
      RETURN FALSE;
  END;

  RETURN TRUE;
END;
$$;
