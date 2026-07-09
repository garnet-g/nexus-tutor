-- Phase E registration consent and irreversible account anonymization.
-- Consent rows are append-only evidence. Deletion processing is claimed in
-- Postgres before any Auth mutation and completed only by the matching claim.

CREATE SCHEMA IF NOT EXISTS private;
REVOKE ALL ON SCHEMA private FROM PUBLIC, anon, authenticated;

CREATE TABLE public.account_consents (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE RESTRICT,
  account_role TEXT NOT NULL CHECK (account_role IN ('student', 'parent')),
  terms_version TEXT NOT NULL CHECK (char_length(btrim(terms_version)) BETWEEN 1 AND 100),
  privacy_version TEXT NOT NULL CHECK (char_length(btrim(privacy_version)) BETWEEN 1 AND 100),
  guardian_acknowledged BOOLEAN NOT NULL,
  evidence_source TEXT NOT NULL CHECK (evidence_source IN ('password_signup', 'oauth_signup')),
  accepted_at TIMESTAMPTZ NOT NULL DEFAULT statement_timestamp(),
  CONSTRAINT account_consents_student_guardian_required CHECK (
    account_role <> 'student' OR guardian_acknowledged
  ),
  CONSTRAINT account_consents_version_evidence_unique UNIQUE (
    user_id,
    terms_version,
    privacy_version,
    evidence_source
  )
);

COMMENT ON TABLE public.account_consents IS
  'Append-only evidence of the exact legal versions accepted during registration.';

CREATE OR REPLACE FUNCTION private.prevent_account_consent_mutation()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  RAISE EXCEPTION 'account consent evidence is immutable'
    USING ERRCODE = '55000';
END;
$$;

REVOKE ALL ON FUNCTION private.prevent_account_consent_mutation()
  FROM PUBLIC, anon, authenticated;

CREATE TRIGGER trg_account_consents_immutable
  BEFORE UPDATE OR DELETE ON public.account_consents
  FOR EACH ROW EXECUTE FUNCTION private.prevent_account_consent_mutation();

ALTER TABLE public.account_consents ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.account_consents FROM PUBLIC, anon, authenticated;
GRANT SELECT, INSERT ON public.account_consents TO service_role;
REVOKE UPDATE, DELETE, TRUNCATE ON public.account_consents FROM service_role;

ALTER TABLE public.account_deletion_requests
  DROP CONSTRAINT IF EXISTS account_deletion_requests_status_check;

ALTER TABLE public.account_deletion_requests
  DROP CONSTRAINT IF EXISTS account_deletion_requests_cancelled_state;

ALTER TABLE public.account_deletion_requests
  ADD COLUMN processing_started_at TIMESTAMPTZ,
  ADD COLUMN completed_at TIMESTAMPTZ,
  ADD COLUMN failed_at TIMESTAMPTZ,
  ADD COLUMN next_retry_at TIMESTAMPTZ,
  ADD COLUMN claim_token UUID,
  ADD COLUMN attempt_count INTEGER NOT NULL DEFAULT 0 CHECK (attempt_count >= 0),
  ADD COLUMN last_error_code TEXT;

ALTER TABLE public.account_deletion_requests
  ADD CONSTRAINT account_deletion_requests_status_check CHECK (
    status IN ('requested', 'cancelled', 'processing', 'completed', 'failed')
  ),
  ADD CONSTRAINT account_deletion_requests_processing_state CHECK (
    (status = 'requested'
      AND cancelled_at IS NULL
      AND processing_started_at IS NULL
      AND completed_at IS NULL
      AND failed_at IS NULL
      AND claim_token IS NULL)
    OR (status = 'cancelled'
      AND cancelled_at IS NOT NULL
      AND processing_started_at IS NULL
      AND completed_at IS NULL
      AND failed_at IS NULL
      AND claim_token IS NULL)
    OR (status = 'processing'
      AND cancelled_at IS NULL
      AND processing_started_at IS NOT NULL
      AND completed_at IS NULL
      AND failed_at IS NULL
      AND claim_token IS NOT NULL)
    OR (status = 'completed'
      AND cancelled_at IS NULL
      AND processing_started_at IS NOT NULL
      AND completed_at IS NOT NULL
      AND failed_at IS NULL
      AND claim_token IS NULL)
    OR (status = 'failed'
      AND cancelled_at IS NULL
      AND processing_started_at IS NOT NULL
      AND completed_at IS NULL
      AND failed_at IS NOT NULL
      AND claim_token IS NULL)
  );

DROP INDEX IF EXISTS public.account_deletion_requests_pending_schedule_idx;
CREATE INDEX account_deletion_requests_due_idx
  ON public.account_deletion_requests (scheduled_for, next_retry_at)
  WHERE status IN ('requested', 'failed', 'processing');

CREATE OR REPLACE FUNCTION private.enforce_account_deletion_transition()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = ''
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    NEW.status = 'requested';
    NEW.requested_at = statement_timestamp();
    NEW.cancelled_at = NULL;
    NEW.processing_started_at = NULL;
    NEW.completed_at = NULL;
    NEW.failed_at = NULL;
    NEW.next_retry_at = NULL;
    NEW.claim_token = NULL;
    NEW.attempt_count = 0;
    NEW.last_error_code = NULL;
    RETURN NEW;
  END IF;

  IF NEW.user_id IS DISTINCT FROM OLD.user_id
    OR NEW.id IS DISTINCT FROM OLD.id
    OR NEW.created_at IS DISTINCT FROM OLD.created_at THEN
    RAISE EXCEPTION 'account deletion request identity is immutable'
      USING ERRCODE = '23514';
  END IF;

  IF auth.role() = 'authenticated' THEN
    IF OLD.status = 'requested' AND NEW.status = 'requested' THEN
      NEW.requested_at = OLD.requested_at;
      NEW.cancelled_at = NULL;
    ELSIF OLD.status = 'requested' AND NEW.status = 'cancelled'
      AND OLD.scheduled_for > statement_timestamp() THEN
      NEW.requested_at = OLD.requested_at;
      NEW.cancelled_at = COALESCE(NEW.cancelled_at, statement_timestamp());
    ELSIF OLD.status = 'cancelled' AND NEW.status = 'requested' THEN
      NEW.requested_at = statement_timestamp();
      NEW.cancelled_at = NULL;
    ELSIF OLD.status = 'cancelled' AND NEW.status = 'cancelled' THEN
      NEW.requested_at = OLD.requested_at;
      NEW.cancelled_at = OLD.cancelled_at;
    ELSE
      RAISE EXCEPTION 'invalid account deletion request transition'
        USING ERRCODE = '23514';
    END IF;

    NEW.processing_started_at = OLD.processing_started_at;
    NEW.completed_at = OLD.completed_at;
    NEW.failed_at = OLD.failed_at;
    NEW.next_retry_at = OLD.next_retry_at;
    NEW.claim_token = OLD.claim_token;
    NEW.attempt_count = OLD.attempt_count;
    NEW.last_error_code = OLD.last_error_code;
  END IF;

  RETURN NEW;
END;
$$;

REVOKE ALL ON FUNCTION private.enforce_account_deletion_transition()
  FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.claim_due_account_deletions(
  p_claim_token UUID,
  p_limit INTEGER DEFAULT 25
)
RETURNS TABLE (
  request_id UUID,
  user_id UUID,
  requested_at TIMESTAMPTZ,
  scheduled_for TIMESTAMPTZ,
  attempt_count INTEGER
)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF p_claim_token IS NULL OR p_limit < 1 OR p_limit > 100 THEN
    RAISE EXCEPTION 'invalid deletion claim';
  END IF;

  RETURN QUERY
  WITH due AS (
    SELECT request.id
    FROM public.account_deletion_requests AS request
    WHERE request.requested_at <= statement_timestamp() - INTERVAL '30 days'
      AND request.scheduled_for <= statement_timestamp()
      AND (
        request.status = 'requested'
        OR (request.status = 'failed'
          AND request.attempt_count < 5
          AND COALESCE(request.next_retry_at, '-infinity'::timestamptz) <= statement_timestamp())
        OR (request.status = 'processing'
          AND request.processing_started_at <= statement_timestamp() - INTERVAL '15 minutes')
      )
    ORDER BY request.scheduled_for, request.id
    FOR UPDATE SKIP LOCKED
    LIMIT p_limit
  ), claimed AS (
    UPDATE public.account_deletion_requests AS request
    SET status = 'processing',
        processing_started_at = statement_timestamp(),
        completed_at = NULL,
        failed_at = NULL,
        next_retry_at = NULL,
        claim_token = p_claim_token,
        attempt_count = request.attempt_count + 1,
        last_error_code = NULL
    FROM due
    WHERE request.id = due.id
    RETURNING request.id, request.user_id, request.requested_at,
      request.scheduled_for, request.attempt_count
  )
  SELECT claimed.id, claimed.user_id, claimed.requested_at,
    claimed.scheduled_for, claimed.attempt_count
  FROM claimed;
END;
$$;

CREATE OR REPLACE FUNCTION public.complete_account_deletion_anonymization(
  p_request_id UUID,
  p_claim_token UUID,
  p_anonymized_email TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  deletion_request public.account_deletion_requests%ROWTYPE;
  student_profile_id UUID;
  parent_profile_id UUID;
  original_email TEXT;
BEGIN
  SELECT * INTO deletion_request
  FROM public.account_deletion_requests
  WHERE id = p_request_id
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'deletion request not found';
  END IF;
  IF deletion_request.status = 'completed' THEN
    RETURN FALSE;
  END IF;
  IF deletion_request.status <> 'processing'
    OR deletion_request.claim_token IS DISTINCT FROM p_claim_token THEN
    RAISE EXCEPTION 'deletion claim mismatch';
  END IF;
  IF deletion_request.requested_at > statement_timestamp() - INTERVAL '30 days'
    OR deletion_request.scheduled_for > statement_timestamp() THEN
    RAISE EXCEPTION 'deletion request is not due';
  END IF;
  IF p_anonymized_email IS NULL
    OR p_anonymized_email !~ '^[a-z0-9+._-]+@deleted[.]invalid$' THEN
    RAISE EXCEPTION 'invalid anonymized identity';
  END IF;

  SELECT id, email INTO student_profile_id, original_email
  FROM public.student_profiles
  WHERE user_id = deletion_request.user_id;
  SELECT id, email INTO parent_profile_id, original_email
  FROM public.parent_profiles
  WHERE user_id = deletion_request.user_id
    AND student_profile_id IS NULL;

  IF original_email IS NULL THEN
    SELECT email INTO original_email
    FROM auth.users
    WHERE id = deletion_request.user_id;
  END IF;

  UPDATE public.student_profiles
  SET full_name = 'Deleted account',
      email = p_anonymized_email,
      phone_number = NULL,
      school_name = NULL,
      target_grade = NULL,
      metadata = '{}'::jsonb,
      learning_preferences = jsonb_build_object(
        'explanationDepth', 'standard',
        'sessionGoalMinutes', 20,
        'reminderChannel', 'off'
      ),
      is_active = FALSE
  WHERE user_id = deletion_request.user_id;

  UPDATE public.parent_profiles
  SET full_name = 'Deleted account',
      email = p_anonymized_email,
      phone_number = NULL,
      contact_preferences = jsonb_build_object('weeklyReportChannel', 'off'),
      is_active = FALSE
  WHERE user_id = deletion_request.user_id;

  IF student_profile_id IS NOT NULL THEN
    UPDATE public.mpesa_payments
    SET phone_number = 'REDACTED'
    WHERE student_id = student_profile_id;

    UPDATE public.celcom_sms_logs
    SET phone_number = 'REDACTED', sms_body = '[redacted]'
    WHERE student_id = student_profile_id;
  END IF;

  IF parent_profile_id IS NOT NULL THEN
    UPDATE public.celcom_sms_logs
    SET phone_number = 'REDACTED', sms_body = '[redacted]'
    WHERE parent_id = parent_profile_id;
  END IF;

  UPDATE public.resend_email_logs
  SET recipient_email = p_anonymized_email,
      email_subject = '[redacted]'
  WHERE original_email IS NOT NULL
    AND lower(recipient_email) = lower(original_email);

  UPDATE public.account_deletion_requests
  SET status = 'completed',
      completed_at = statement_timestamp(),
      failed_at = NULL,
      next_retry_at = NULL,
      claim_token = NULL,
      last_error_code = NULL
  WHERE id = deletion_request.id;

  RETURN TRUE;
END;
$$;

CREATE OR REPLACE FUNCTION public.fail_account_deletion_claim(
  p_request_id UUID,
  p_claim_token UUID,
  p_error_code TEXT
)
RETURNS BOOLEAN
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  updated_count INTEGER;
BEGIN
  IF p_error_code IS NULL OR p_error_code !~ '^[A-Z0-9_]{3,64}$' THEN
    RAISE EXCEPTION 'invalid deletion failure code';
  END IF;

  UPDATE public.account_deletion_requests
  SET status = 'failed',
      failed_at = statement_timestamp(),
      next_retry_at = CASE
        WHEN attempt_count < 5
          THEN statement_timestamp() + make_interval(mins => LEAST(60, attempt_count * 5))
        ELSE NULL
      END,
      claim_token = NULL,
      last_error_code = p_error_code
  WHERE id = p_request_id
    AND status = 'processing'
    AND claim_token = p_claim_token;

  GET DIAGNOSTICS updated_count = ROW_COUNT;
  RETURN updated_count = 1;
END;
$$;

REVOKE ALL ON FUNCTION public.claim_due_account_deletions(UUID, INTEGER)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.complete_account_deletion_anonymization(UUID, UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.fail_account_deletion_claim(UUID, UUID, TEXT)
  FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.claim_due_account_deletions(UUID, INTEGER)
  TO service_role;
GRANT EXECUTE ON FUNCTION public.complete_account_deletion_anonymization(UUID, UUID, TEXT)
  TO service_role;
GRANT EXECUTE ON FUNCTION public.fail_account_deletion_claim(UUID, UUID, TEXT)
  TO service_role;
