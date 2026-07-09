-- Durable evidence for privileged account mutations. An operation is reserved
-- transactionally with its audit and outbox rows before Supabase Auth is
-- changed. The application must then mark the operation completed before it
-- may report success. A failed reservation therefore fails closed.
CREATE TABLE public.critical_account_operations (
  id UUID PRIMARY KEY,
  idempotency_key UUID NOT NULL UNIQUE,
  actor_user_id UUID NOT NULL REFERENCES auth.users(id),
  actor_role TEXT NOT NULL CHECK (actor_role IN ('super_admin', 'support')),
  target_user_id UUID NOT NULL REFERENCES auth.users(id),
  operation TEXT NOT NULL CHECK (operation IN ('ban', 'unban', 'revoke_sessions', 'recovery', 'profile_correction', 'role_change')),
  reason TEXT NOT NULL CHECK (char_length(btrim(reason)) BETWEEN 3 AND 500),
  request_metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  result_metadata JSONB NOT NULL DEFAULT '{}'::jsonb,
  status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'completed', 'failed')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

CREATE TABLE public.critical_account_outbox (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  operation_id UUID NOT NULL UNIQUE REFERENCES public.critical_account_operations(id) ON DELETE RESTRICT,
  event_type TEXT NOT NULL,
  payload JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  processed_at TIMESTAMPTZ
);

CREATE INDEX idx_critical_account_operations_target_created
  ON public.critical_account_operations(target_user_id, created_at DESC);
CREATE INDEX idx_critical_account_outbox_pending
  ON public.critical_account_outbox(created_at) WHERE processed_at IS NULL;

ALTER TABLE public.critical_account_operations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.critical_account_outbox ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.critical_account_operations FROM PUBLIC, anon, authenticated;
REVOKE ALL ON public.critical_account_outbox FROM PUBLIC, anon, authenticated;

CREATE OR REPLACE FUNCTION public.reserve_critical_account_operation(
  p_operation_id UUID,
  p_idempotency_key UUID,
  p_actor_user_id UUID,
  p_actor_role TEXT,
  p_target_user_id UUID,
  p_operation TEXT,
  p_reason TEXT,
  p_request_metadata JSONB DEFAULT '{}'::jsonb
) RETURNS TABLE(operation_id UUID, operation_status TEXT, is_replay BOOLEAN)
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  existing public.critical_account_operations%ROWTYPE;
BEGIN
  IF p_actor_role NOT IN ('super_admin', 'support') THEN
    RAISE EXCEPTION 'invalid actor role';
  END IF;
  IF p_operation <> 'recovery' AND p_actor_role <> 'super_admin' THEN
    RAISE EXCEPTION 'operation requires super admin';
  END IF;

  SELECT * INTO existing
  FROM public.critical_account_operations
  WHERE idempotency_key = p_idempotency_key;
  IF FOUND THEN
    IF existing.actor_user_id <> p_actor_user_id
      OR existing.target_user_id <> p_target_user_id
      OR existing.operation <> p_operation THEN
      RAISE EXCEPTION 'idempotency key conflict';
    END IF;
    RETURN QUERY SELECT existing.id, existing.status, TRUE;
    RETURN;
  END IF;

  INSERT INTO public.critical_account_operations (
    id, idempotency_key, actor_user_id, actor_role, target_user_id,
    operation, reason, request_metadata
  ) VALUES (
    p_operation_id, p_idempotency_key, p_actor_user_id, p_actor_role,
    p_target_user_id, p_operation, btrim(p_reason), COALESCE(p_request_metadata, '{}'::jsonb)
  );

  INSERT INTO public.admin_audit_log (
    actor_user_id, actor_role, action, target_type, target_id, metadata
  ) VALUES (
    p_actor_user_id, p_actor_role, 'account.' || p_operation || '.reserved',
    'auth_user', p_target_user_id::text,
    jsonb_build_object('operationId', p_operation_id, 'reason', btrim(p_reason)) || COALESCE(p_request_metadata, '{}'::jsonb)
  );

  INSERT INTO public.critical_account_outbox (operation_id, event_type, payload)
  VALUES (
    p_operation_id, 'account.' || p_operation || '.reserved',
    jsonb_build_object('operationId', p_operation_id, 'targetUserId', p_target_user_id)
  );

  RETURN QUERY SELECT p_operation_id, 'pending'::TEXT, FALSE;
END;
$$;

CREATE OR REPLACE FUNCTION public.complete_critical_account_operation(
  p_operation_id UUID,
  p_result_metadata JSONB DEFAULT '{}'::jsonb
) RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  current_operation public.critical_account_operations%ROWTYPE;
BEGIN
  SELECT * INTO current_operation
  FROM public.critical_account_operations
  WHERE id = p_operation_id
  FOR UPDATE;
  IF NOT FOUND THEN
    RAISE EXCEPTION 'operation not found';
  END IF;
  IF current_operation.status = 'completed' THEN
    RETURN;
  END IF;

  UPDATE public.critical_account_operations
  SET status = 'completed', result_metadata = COALESCE(p_result_metadata, '{}'::jsonb), completed_at = NOW()
  WHERE id = p_operation_id;

  INSERT INTO public.admin_audit_log (
    actor_user_id, actor_role, action, target_type, target_id, metadata
  ) VALUES (
    current_operation.actor_user_id, current_operation.actor_role,
    'account.' || current_operation.operation || '.completed', 'auth_user',
    current_operation.target_user_id::text,
    jsonb_build_object('operationId', current_operation.id, 'reason', current_operation.reason) || COALESCE(p_result_metadata, '{}'::jsonb)
  );

  UPDATE public.critical_account_outbox
  SET event_type = 'account.' || current_operation.operation || '.completed',
      payload = payload || COALESCE(p_result_metadata, '{}'::jsonb)
  WHERE operation_id = p_operation_id;
END;
$$;

REVOKE ALL ON FUNCTION public.reserve_critical_account_operation(UUID, UUID, UUID, TEXT, UUID, TEXT, TEXT, JSONB) FROM PUBLIC, anon, authenticated;
REVOKE ALL ON FUNCTION public.complete_critical_account_operation(UUID, JSONB) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.reserve_critical_account_operation(UUID, UUID, UUID, TEXT, UUID, TEXT, TEXT, JSONB) TO service_role;
GRANT EXECUTE ON FUNCTION public.complete_critical_account_operation(UUID, JSONB) TO service_role;

CREATE OR REPLACE FUNCTION public.replace_canonical_admin_role_assignment(
  p_user_id UUID,
  p_role TEXT,
  p_actor_user_id UUID
) RETURNS VOID
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
BEGIN
  IF p_role NOT IN ('student', 'parent', 'super_admin', 'support') THEN
    RAISE EXCEPTION 'invalid canonical role';
  END IF;
  DELETE FROM public.admin_role_assignments WHERE user_id = p_user_id;
  IF p_role IN ('super_admin', 'support') THEN
    INSERT INTO public.admin_role_assignments(user_id, role_key, assigned_by)
    VALUES (p_user_id, p_role, p_actor_user_id);
  END IF;
END;
$$;

REVOKE ALL ON FUNCTION public.replace_canonical_admin_role_assignment(UUID, TEXT, UUID) FROM PUBLIC, anon, authenticated;
GRANT EXECUTE ON FUNCTION public.replace_canonical_admin_role_assignment(UUID, TEXT, UUID) TO service_role;
