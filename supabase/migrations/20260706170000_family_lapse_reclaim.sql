-- PR-133 / PR-134: Reclaim family seats when the owner subscription lapses.
-- Mirrors Phase 05 join_family_group locking semantics (FOR UPDATE on family_groups).
CREATE OR REPLACE FUNCTION public.reclaim_family_group_on_lapse(
  p_student_subscription_id UUID
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_group public.family_groups%ROWTYPE;
  v_free_plan_id UUID;
  v_member_student_id UUID;
  v_removed_count INTEGER := 0;
BEGIN
  SELECT *
  INTO v_group
  FROM public.family_groups
  WHERE student_subscription_id = p_student_subscription_id
    AND is_active = TRUE
  FOR UPDATE;

  IF NOT FOUND THEN
    RETURN jsonb_build_object('reclaimed', FALSE, 'reason', 'NO_ACTIVE_GROUP');
  END IF;

  SELECT plan.id
  INTO v_free_plan_id
  FROM public.subscription_plans AS plan
  WHERE plan.plan_code = 'free';

  FOR v_member_student_id IN
    SELECT member.student_id
    FROM public.family_group_members AS member
    WHERE member.family_group_id = v_group.id
      AND member.student_id <> v_group.owner_student_id
  LOOP
    DELETE FROM public.family_group_members
    WHERE student_id = v_member_student_id;

    UPDATE public.student_subscriptions
    SET
      subscription_status = 'cancelled',
      cancelled_at = NOW(),
      updated_at = NOW()
    WHERE student_id = v_member_student_id
      AND subscription_status IN ('active', 'trialing');

    IF v_free_plan_id IS NOT NULL THEN
      INSERT INTO public.student_subscriptions (
        student_id,
        subscription_plan_id,
        subscription_status,
        current_period_start,
        current_period_end
      )
      VALUES (
        v_member_student_id,
        v_free_plan_id,
        'active',
        NOW(),
        NULL
      );
    END IF;

    v_removed_count := v_removed_count + 1;
  END LOOP;

  UPDATE public.family_groups
  SET
    is_active = FALSE,
    seat_count = 1,
    updated_at = NOW()
  WHERE id = v_group.id;

  RETURN jsonb_build_object(
    'reclaimed', TRUE,
    'family_group_id', v_group.id,
    'removed_members', v_removed_count
  );
END;
$$;

CREATE OR REPLACE FUNCTION public.reactivate_family_group_on_resubscribe(
  p_student_subscription_id UUID,
  p_owner_student_id UUID,
  p_max_seats INTEGER
)
RETURNS JSONB
LANGUAGE plpgsql
SECURITY DEFINER
SET search_path = ''
AS $$
DECLARE
  v_group public.family_groups%ROWTYPE;
BEGIN
  IF p_max_seats IS NULL OR p_max_seats < 1 OR p_max_seats > 20 THEN
    RAISE EXCEPTION 'Invalid family seat limit';
  END IF;

  SELECT *
  INTO v_group
  FROM public.family_groups
  WHERE owner_student_id = p_owner_student_id
  ORDER BY created_at DESC
  LIMIT 1
  FOR UPDATE;

  IF NOT FOUND THEN
    RAISE EXCEPTION 'NO_FAMILY_GROUP';
  END IF;

  UPDATE public.family_groups
  SET
    student_subscription_id = p_student_subscription_id,
    is_active = TRUE,
    max_seats = GREATEST(p_max_seats, seat_count),
    seat_count = 1,
    updated_at = NOW()
  WHERE id = v_group.id;

  INSERT INTO public.family_group_members (family_group_id, student_id)
  VALUES (v_group.id, p_owner_student_id)
  ON CONFLICT (student_id) DO UPDATE
    SET family_group_id = EXCLUDED.family_group_id;

  RETURN jsonb_build_object(
    'family_group_id', v_group.id,
    'invite_code', v_group.invite_code,
    'reactivated', TRUE
  );
END;
$$;

REVOKE ALL ON FUNCTION public.reclaim_family_group_on_lapse(UUID) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.reclaim_family_group_on_lapse(UUID) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.reclaim_family_group_on_lapse(UUID) TO service_role;

REVOKE ALL ON FUNCTION public.reactivate_family_group_on_resubscribe(UUID, UUID, INTEGER) FROM PUBLIC;
REVOKE ALL ON FUNCTION public.reactivate_family_group_on_resubscribe(UUID, UUID, INTEGER) FROM anon, authenticated;
GRANT EXECUTE ON FUNCTION public.reactivate_family_group_on_resubscribe(UUID, UUID, INTEGER) TO service_role;
