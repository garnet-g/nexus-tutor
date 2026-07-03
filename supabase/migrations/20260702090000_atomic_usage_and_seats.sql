-- Phase 05: atomic quota enforcement, transactional family seats, atomic
-- trial/family setup, and a durable rate-limit bucket store (PR-014, PR-015,
-- PR-016, PR-046, PR-048, PR-049, PR-091, PR-092, PR-093).
--
-- Conventions per Phase 03/04 hardening: SECURITY DEFINER + SET search_path = '',
-- REVOKE ALL FROM PUBLIC/anon/authenticated, GRANT EXECUTE TO service_role.
-- Every function returns enough state that callers never read-then-write.

-- ---------------------------------------------------------------------------
-- Atomic Nex daily usage increment. The cap is enforced inside the same
-- statement via ON CONFLICT ... DO UPDATE ... WHERE, so 20 parallel calls can
-- never push nex_message_count past p_daily_limit.
-- nex_daily_usage already carries UNIQUE (student_id, usage_date)
-- (20250613120100_create_learning_tables.sql), which the upsert relies on.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.increment_nex_daily_usage(
  p_student_id UUID,
  p_usage_date DATE,
  p_daily_limit INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_count INTEGER;
BEGIN
  IF p_daily_limit IS NULL OR p_daily_limit <= 0 THEN
    SELECT usage.nex_message_count
    INTO v_count
    FROM public.nex_daily_usage AS usage
    WHERE usage.student_id = p_student_id
      AND usage.usage_date = p_usage_date;

    RETURN jsonb_build_object(
      'allowed', FALSE,
      'new_count', COALESCE(v_count, 0)
    );
  END IF;

  INSERT INTO public.nex_daily_usage (
    student_id,
    usage_date,
    nex_message_count,
    practice_session_count
  )
  VALUES (p_student_id, p_usage_date, 1, 0)
  ON CONFLICT (student_id, usage_date) DO UPDATE
    SET nex_message_count = public.nex_daily_usage.nex_message_count + 1
    WHERE public.nex_daily_usage.nex_message_count < p_daily_limit
  RETURNING nex_message_count INTO v_count;

  IF v_count IS NOT NULL THEN
    RETURN jsonb_build_object('allowed', TRUE, 'new_count', v_count);
  END IF;

  -- Conflict row exists but is already at/over the cap: report current state.
  SELECT usage.nex_message_count
  INTO v_count
  FROM public.nex_daily_usage AS usage
  WHERE usage.student_id = p_student_id
    AND usage.usage_date = p_usage_date;

  RETURN jsonb_build_object(
    'allowed', FALSE,
    'new_count', COALESCE(v_count, 0)
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- Atomic practice daily usage increment (same contract, practice column).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.increment_practice_daily_usage(
  p_student_id UUID,
  p_usage_date DATE,
  p_daily_limit INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_count INTEGER;
BEGIN
  IF p_daily_limit IS NULL OR p_daily_limit <= 0 THEN
    SELECT usage.practice_session_count
    INTO v_count
    FROM public.nex_daily_usage AS usage
    WHERE usage.student_id = p_student_id
      AND usage.usage_date = p_usage_date;

    RETURN jsonb_build_object(
      'allowed', FALSE,
      'new_count', COALESCE(v_count, 0)
    );
  END IF;

  INSERT INTO public.nex_daily_usage (
    student_id,
    usage_date,
    nex_message_count,
    practice_session_count
  )
  VALUES (p_student_id, p_usage_date, 0, 1)
  ON CONFLICT (student_id, usage_date) DO UPDATE
    SET practice_session_count = public.nex_daily_usage.practice_session_count + 1
    WHERE public.nex_daily_usage.practice_session_count < p_daily_limit
  RETURNING practice_session_count INTO v_count;

  IF v_count IS NOT NULL THEN
    RETURN jsonb_build_object('allowed', TRUE, 'new_count', v_count);
  END IF;

  SELECT usage.practice_session_count
  INTO v_count
  FROM public.nex_daily_usage AS usage
  WHERE usage.student_id = p_student_id
    AND usage.usage_date = p_usage_date;

  RETURN jsonb_build_object(
    'allowed', FALSE,
    'new_count', COALESCE(v_count, 0)
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- Transactional family join: lock the group row FOR UPDATE, verify seats and
-- membership, then insert the member, bump seat_count, cancel prior
-- subscriptions, and attach the family subscription — all in one transaction.
-- family_group_members.student_id is already UNIQUE
-- (20250613130000_create_family_groups.sql), backing the membership check.
-- Errors are raised as machine tokens for the service layer to map:
--   INVALID_CODE, ALREADY_MEMBER, NO_SEATS.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.join_family_group(
  p_invite_code TEXT,
  p_student_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_code TEXT := UPPER(TRIM(p_invite_code));
  v_group public.family_groups%ROWTYPE;
  v_family_plan_id UUID;
  v_period_start TIMESTAMPTZ := NOW();
  v_period_end TIMESTAMPTZ := NULL;
  v_new_seat_count INTEGER;
BEGIN
  SELECT *
  INTO v_group
  FROM public.family_groups
  WHERE invite_code = v_code
    AND is_active = TRUE
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'INVALID_CODE';
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.family_group_members
    WHERE student_id = p_student_id
  ) THEN
    RAISE EXCEPTION 'ALREADY_MEMBER';
  END IF;

  IF v_group.seat_count >= v_group.max_seats THEN
    RAISE EXCEPTION 'NO_SEATS';
  END IF;

  INSERT INTO public.family_group_members (family_group_id, student_id)
  VALUES (v_group.id, p_student_id);

  v_new_seat_count := v_group.seat_count + 1;

  UPDATE public.family_groups
  SET
    seat_count = v_new_seat_count,
    updated_at = NOW()
  WHERE id = v_group.id;

  SELECT plan.id
  INTO v_family_plan_id
  FROM public.subscription_plans AS plan
  WHERE plan.plan_code = 'family';

  IF v_family_plan_id IS NOT NULL THEN
    UPDATE public.student_subscriptions
    SET
      subscription_status = 'cancelled',
      cancelled_at = NOW(),
      updated_at = NOW()
    WHERE student_id = p_student_id
      AND subscription_status IN ('active', 'trialing');

    IF v_group.student_subscription_id IS NOT NULL THEN
      SELECT
        COALESCE(sub.current_period_start, v_period_start),
        sub.current_period_end
      INTO v_period_start, v_period_end
      FROM public.student_subscriptions AS sub
      WHERE sub.id = v_group.student_subscription_id;
    END IF;

    INSERT INTO public.student_subscriptions (
      student_id,
      subscription_plan_id,
      subscription_status,
      current_period_start,
      current_period_end
    )
    VALUES (
      p_student_id,
      v_family_plan_id,
      'active',
      v_period_start,
      v_period_end
    );
  END IF;

  RETURN jsonb_build_object(
    'family_group_id', v_group.id,
    'seats_remaining', v_group.max_seats - v_new_seat_count
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- Atomic trial start: trial row + trialing subscription + billing event in a
-- single transaction. subscription_trials.student_id is already UNIQUE
-- (20250613120200_create_billing_notifications.sql); the ON CONFLICT DO
-- NOTHING makes concurrent starts race-safe. Raises TRIAL_ALREADY_USED.
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.start_trial_atomic(
  p_student_id UUID,
  p_premium_plan_id UUID,
  p_trial_days INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_trial_started_at TIMESTAMPTZ := NOW();
  v_trial_ends_at TIMESTAMPTZ;
  v_subscription_id UUID;
BEGIN
  IF p_trial_days IS NULL OR p_trial_days < 1 OR p_trial_days > 90 THEN
    RAISE EXCEPTION 'Invalid trial length';
  END IF;

  v_trial_ends_at := v_trial_started_at + make_interval(days => p_trial_days);

  INSERT INTO public.subscription_trials (
    student_id,
    trial_started_at,
    trial_ends_at,
    is_trial_active
  )
  VALUES (p_student_id, v_trial_started_at, v_trial_ends_at, TRUE)
  ON CONFLICT (student_id) DO NOTHING;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'TRIAL_ALREADY_USED';
  END IF;

  INSERT INTO public.student_subscriptions (
    student_id,
    subscription_plan_id,
    subscription_status,
    trial_started_at,
    trial_ends_at,
    current_period_start,
    current_period_end
  )
  VALUES (
    p_student_id,
    p_premium_plan_id,
    'trialing',
    v_trial_started_at,
    v_trial_ends_at,
    v_trial_started_at,
    v_trial_ends_at
  )
  RETURNING id INTO v_subscription_id;

  INSERT INTO public.billing_events (
    student_subscription_id,
    event_type,
    event_payload
  )
  VALUES (
    v_subscription_id,
    'trial_started',
    jsonb_build_object('trialDays', p_trial_days)
  );

  RETURN jsonb_build_object(
    'trial_ends_at', v_trial_ends_at,
    'subscription_id', v_subscription_id
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- Atomic family group creation for a verified payment: group + owner member
-- in one transaction (createFamilyGroupForPayment previously did two
-- non-atomic inserts — PR-093).
-- ---------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION public.create_family_group_atomic(
  p_owner_user_id UUID,
  p_owner_student_id UUID,
  p_student_subscription_id UUID,
  p_invite_code TEXT,
  p_max_seats INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_family_group_id UUID;
BEGIN
  IF p_max_seats IS NULL OR p_max_seats < 1 OR p_max_seats > 20 THEN
    RAISE EXCEPTION 'Invalid family seat limit';
  END IF;

  IF p_invite_code IS NULL OR LENGTH(TRIM(p_invite_code)) < 6 THEN
    RAISE EXCEPTION 'Invalid family invite code';
  END IF;

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
    p_owner_user_id,
    p_owner_student_id,
    p_student_subscription_id,
    UPPER(TRIM(p_invite_code)),
    p_max_seats,
    1,
    TRUE
  )
  RETURNING id INTO v_family_group_id;

  INSERT INTO public.family_group_members (family_group_id, student_id)
  VALUES (v_family_group_id, p_owner_student_id)
  ON CONFLICT (student_id) DO UPDATE
    SET family_group_id = EXCLUDED.family_group_id;

  RETURN jsonb_build_object(
    'family_group_id', v_family_group_id,
    'invite_code', UPPER(TRIM(p_invite_code))
  );
END;
$$;

-- ---------------------------------------------------------------------------
-- Durable rate-limit buckets (PR-046, PR-048, PR-049). Fixed-window counters
-- shared across all app instances. Service-role only: RLS enabled with no
-- policies, matching beta_invite_redemptions.
-- ---------------------------------------------------------------------------
CREATE TABLE public.rate_limit_buckets (
  key TEXT NOT NULL,
  window_start TIMESTAMPTZ NOT NULL,
  count INTEGER NOT NULL DEFAULT 0,
  PRIMARY KEY (key, window_start)
);

CREATE INDEX idx_rate_limit_buckets_window_start
  ON public.rate_limit_buckets (window_start);

ALTER TABLE public.rate_limit_buckets ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.rate_limit_buckets FROM PUBLIC;
REVOKE ALL ON TABLE public.rate_limit_buckets FROM anon;
REVOKE ALL ON TABLE public.rate_limit_buckets FROM authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.rate_limit_buckets TO service_role;

CREATE OR REPLACE FUNCTION public.consume_rate_limit(
  p_key TEXT,
  p_window_seconds INTEGER,
  p_max INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_window_start TIMESTAMPTZ;
  v_count INTEGER;
  v_retry_after INTEGER;
BEGIN
  IF p_key IS NULL OR LENGTH(p_key) = 0 THEN
    RAISE EXCEPTION 'Rate limit key is required';
  END IF;

  IF p_window_seconds IS NULL OR p_window_seconds < 1 OR p_window_seconds > 86400 THEN
    RAISE EXCEPTION 'Invalid rate limit window';
  END IF;

  IF p_max IS NULL OR p_max < 1 THEN
    RAISE EXCEPTION 'Invalid rate limit maximum';
  END IF;

  v_window_start := TO_TIMESTAMP(
    FLOOR(EXTRACT(EPOCH FROM NOW()) / p_window_seconds) * p_window_seconds
  );

  INSERT INTO public.rate_limit_buckets (key, window_start, count)
  VALUES (p_key, v_window_start, 1)
  ON CONFLICT (key, window_start) DO UPDATE
    SET count = public.rate_limit_buckets.count + 1
  RETURNING count INTO v_count;

  v_retry_after := GREATEST(
    CEIL(EXTRACT(EPOCH FROM (
      v_window_start + make_interval(secs => p_window_seconds) - NOW()
    )))::INTEGER,
    1
  );

  -- Opportunistic cleanup of stale buckets (~2% of calls). All configured
  -- windows are well under two hours, so this never deletes a live bucket.
  IF random() < 0.02 THEN
    DELETE FROM public.rate_limit_buckets
    WHERE window_start < NOW() - INTERVAL '2 hours';
  END IF;

  IF v_count > p_max THEN
    RETURN jsonb_build_object(
      'allowed', FALSE,
      'retry_after_seconds', v_retry_after
    );
  END IF;

  RETURN jsonb_build_object('allowed', TRUE, 'retry_after_seconds', 0);
END;
$$;

-- ---------------------------------------------------------------------------
-- Lock down every new function: service-role execution only.
-- ---------------------------------------------------------------------------
REVOKE ALL ON FUNCTION public.increment_nex_daily_usage(UUID, DATE, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.increment_nex_daily_usage(UUID, DATE, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.increment_nex_daily_usage(UUID, DATE, INTEGER) TO service_role;

REVOKE ALL ON FUNCTION public.increment_practice_daily_usage(UUID, DATE, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.increment_practice_daily_usage(UUID, DATE, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.increment_practice_daily_usage(UUID, DATE, INTEGER) TO service_role;

REVOKE ALL ON FUNCTION public.join_family_group(TEXT, UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.join_family_group(TEXT, UUID) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.join_family_group(TEXT, UUID) TO service_role;

REVOKE ALL ON FUNCTION public.start_trial_atomic(UUID, UUID, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.start_trial_atomic(UUID, UUID, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.start_trial_atomic(UUID, UUID, INTEGER) TO service_role;

REVOKE ALL ON FUNCTION public.create_family_group_atomic(UUID, UUID, UUID, TEXT, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.create_family_group_atomic(UUID, UUID, UUID, TEXT, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.create_family_group_atomic(UUID, UUID, UUID, TEXT, INTEGER) TO service_role;

REVOKE ALL ON FUNCTION public.consume_rate_limit(TEXT, INTEGER, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.consume_rate_limit(TEXT, INTEGER, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.consume_rate_limit(TEXT, INTEGER, INTEGER) TO service_role;
