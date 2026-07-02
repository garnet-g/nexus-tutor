-- Atomic beta invite reservation for signup/OAuth parity (PR-054)

CREATE TABLE public.beta_invite_redemptions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  invite_code TEXT NOT NULL REFERENCES public.beta_invites (invite_code) ON DELETE CASCADE,
  user_id UUID NOT NULL,
  reserved_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  CONSTRAINT beta_invite_redemptions_unique_user UNIQUE (invite_code, user_id)
);

CREATE INDEX idx_beta_invite_redemptions_user
  ON public.beta_invite_redemptions (user_id);

ALTER TABLE public.beta_invite_redemptions ENABLE ROW LEVEL SECURITY;

REVOKE ALL ON TABLE public.beta_invite_redemptions FROM PUBLIC;
REVOKE ALL ON TABLE public.beta_invite_redemptions FROM anon;
REVOKE ALL ON TABLE public.beta_invite_redemptions FROM authenticated;
GRANT SELECT, INSERT, DELETE ON TABLE public.beta_invite_redemptions TO service_role;

CREATE OR REPLACE FUNCTION public.reserve_beta_invite(
  p_code TEXT,
  p_user_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_code TEXT := UPPER(TRIM(p_code));
  v_invite public.beta_invites%ROWTYPE;
BEGIN
  IF v_code IS NULL OR LENGTH(v_code) < 6 THEN
    RETURN jsonb_build_object('ok', false, 'reason', 'Enter a valid invite code.');
  END IF;

  IF EXISTS (
    SELECT 1
    FROM public.beta_invite_redemptions
    WHERE invite_code = v_code
      AND user_id = p_user_id
  ) THEN
    SELECT * INTO v_invite
    FROM public.beta_invites
    WHERE invite_code = v_code;

    RETURN jsonb_build_object(
      'ok', true,
      'invite_id', v_invite.id,
      'reason', 'already_reserved'
    );
  END IF;

  SELECT * INTO v_invite
  FROM public.beta_invites
  WHERE invite_code = v_code
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('ok', false, 'reason', 'Invalid invite code.');
  END IF;

  IF NOT v_invite.is_active THEN
    RETURN jsonb_build_object('ok', false, 'reason', 'This invite code is no longer active.');
  END IF;

  IF v_invite.expires_at IS NOT NULL AND v_invite.expires_at < NOW() THEN
    RETURN jsonb_build_object('ok', false, 'reason', 'This invite code has expired.');
  END IF;

  IF v_invite.use_count >= v_invite.max_uses THEN
    RETURN jsonb_build_object('ok', false, 'reason', 'This invite code has reached its use limit.');
  END IF;

  UPDATE public.beta_invites
  SET use_count = use_count + 1
  WHERE id = v_invite.id;

  INSERT INTO public.beta_invite_redemptions (invite_code, user_id)
  VALUES (v_code, p_user_id);

  RETURN jsonb_build_object('ok', true, 'invite_id', v_invite.id);
END;
$$;

CREATE OR REPLACE FUNCTION public.release_beta_invite(
  p_code TEXT,
  p_user_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_code TEXT := UPPER(TRIM(p_code));
  v_deleted INTEGER;
BEGIN
  DELETE FROM public.beta_invite_redemptions
  WHERE invite_code = v_code
    AND user_id = p_user_id;

  GET DIAGNOSTICS v_deleted = ROW_COUNT;

  IF v_deleted = 0 THEN
    RETURN jsonb_build_object('ok', true, 'reason', 'not_reserved');
  END IF;

  UPDATE public.beta_invites
  SET use_count = GREATEST(use_count - 1, 0)
  WHERE invite_code = v_code;

  RETURN jsonb_build_object('ok', true, 'reason', 'released');
END;
$$;

CREATE OR REPLACE FUNCTION public.is_auth_session_active(
  p_session_id UUID,
  p_user_id UUID
)
RETURNS BOOLEAN
LANGUAGE sql
SECURITY DEFINER
SET search_path = ''
AS $$
  SELECT EXISTS (
    SELECT 1
    FROM auth.sessions AS s
    WHERE s.id = p_session_id
      AND s.user_id = p_user_id
  );
$$;

REVOKE ALL ON FUNCTION public.reserve_beta_invite(TEXT, UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.reserve_beta_invite(TEXT, UUID) FROM anon;
REVOKE ALL ON FUNCTION public.reserve_beta_invite(TEXT, UUID) FROM authenticated;
GRANT EXECUTE ON FUNCTION public.reserve_beta_invite(TEXT, UUID) TO service_role;

REVOKE ALL ON FUNCTION public.release_beta_invite(TEXT, UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.release_beta_invite(TEXT, UUID) FROM anon;
REVOKE ALL ON FUNCTION public.release_beta_invite(TEXT, UUID) FROM authenticated;
GRANT EXECUTE ON FUNCTION public.release_beta_invite(TEXT, UUID) TO service_role;

REVOKE ALL ON FUNCTION public.is_auth_session_active(UUID, UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.is_auth_session_active(UUID, UUID) FROM anon;
REVOKE ALL ON FUNCTION public.is_auth_session_active(UUID, UUID) FROM authenticated;
GRANT EXECUTE ON FUNCTION public.is_auth_session_active(UUID, UUID) TO service_role;
