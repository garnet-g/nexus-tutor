DO $$
DECLARE
  v_subject_id UUID;
  v_topic_ids UUID[];
  v_topic_count INT;
  v_topic_id UUID;
  v_i INT;
BEGIN
  SELECT s.id INTO v_subject_id
  FROM public.subjects s
  JOIN public.curricula c ON c.id = s.curriculum_id
  WHERE s.code = 'mathematics' AND c.code = 'KCSE'
  LIMIT 1;

  IF v_subject_id IS NULL THEN
    RAISE NOTICE 'No KCSE mathematics subject found; skipping exam_paper_templates seed.';
    RETURN;
  END IF;

  SELECT array_agg(id ORDER BY id) INTO v_topic_ids
  FROM public.topics
  WHERE subject_id = v_subject_id;

  v_topic_count := COALESCE(array_length(v_topic_ids, 1), 0);

  IF v_topic_count = 0 THEN
    RAISE NOTICE 'No topics found for KCSE mathematics; skipping exam_paper_templates seed.';
    RETURN;
  END IF;

  -- Section I: 2 four-mark (percentage) questions.
  FOR v_i IN 1..2 LOOP
    v_topic_id := v_topic_ids[1 + ((v_i - 1) % v_topic_count)];
    INSERT INTO public.exam_paper_templates
      (paper, section, form_level, topic_id, marks, difficulty, review_status, is_active, body)
    VALUES (
      1, 'I', 1, v_topic_id, 4, 'medium', 'approved', true,
      jsonb_build_object(
        'params', jsonb_build_array(
          jsonb_build_object('name', 'a', 'min', 100, 'max', 900, 'step', 10)
        ),
        'stem', 'A trader buys goods for KSh {a}. She sells them at a profit of 15%, then gives a further 10% discount off the new price to a loyal customer.',
        'parts', jsonb_build_array(
          jsonb_build_object('label', 'a', 'prompt', 'Find the price after the 15% profit is added.', 'marks', 2, 'answerType', 'numeric', 'answerExpr', 'a * 1.15', 'tolerance', 0.01),
          jsonb_build_object('label', 'b', 'prompt', 'Find the final price the loyal customer pays.', 'marks', 2, 'answerType', 'numeric', 'answerExpr', '(a * 1.15) * 0.9', 'tolerance', 0.01)
        ),
        'markScheme', jsonb_build_array(
          jsonb_build_object('code', 'M1', 'text', '{a} x 1.15 = {answer_a}'),
          jsonb_build_object('code', 'M1', 'text', '{answer_a} x 0.9 = {answer_b}'),
          jsonb_build_object('code', 'A1', 'text', 'Final price = {answer_b}')
        )
      )
    );
  END LOOP;

  -- Section I: 14 three-mark (linear equation) questions.
  FOR v_i IN 1..14 LOOP
    v_topic_id := v_topic_ids[1 + ((v_i - 1) % v_topic_count)];
    INSERT INTO public.exam_paper_templates
      (paper, section, form_level, topic_id, marks, difficulty, review_status, is_active, body)
    VALUES (
      1, 'I', 1, v_topic_id, 3, 'medium', 'approved', true,
      jsonb_build_object(
        'params', jsonb_build_array(
          jsonb_build_object('name', 'x', 'min', 2, 'max', 9),
          jsonb_build_object('name', 'c', 'min', 1, 'max', 9),
          jsonb_build_object('name', 'rhs', 'min', 20, 'max', 60)
        ),
        'stem', 'Solve for p: {x}p + {c} = {rhs}',
        'parts', jsonb_build_array(
          jsonb_build_object('label', 'a', 'prompt', 'Find the value of p.', 'marks', 3, 'answerType', 'numeric', 'answerExpr', '(rhs - c) / x', 'tolerance', 0.01)
        ),
        'markScheme', jsonb_build_array(
          jsonb_build_object('code', 'M1', 'text', '{x}p = {rhs} - {c}'),
          jsonb_build_object('code', 'A1', 'text', 'p = {answer_a}')
        )
      )
    );
  END LOOP;

  -- Section II: 8 ten-mark (rectangular path) questions.
  FOR v_i IN 1..8 LOOP
    v_topic_id := v_topic_ids[1 + ((v_i - 1) % v_topic_count)];
    INSERT INTO public.exam_paper_templates
      (paper, section, form_level, topic_id, marks, difficulty, review_status, is_active, body)
    VALUES (
      1, 'II', 1, v_topic_id, 10, 'medium', 'approved', true,
      jsonb_build_object(
        'params', jsonb_build_array(
          jsonb_build_object('name', 'length', 'min', 8, 'max', 20),
          jsonb_build_object('name', 'width', 'min', 4, 'max', 12)
        ),
        'stem', 'A rectangular plot has length {length} m and width {width} m. A path of uniform width 1 m is constructed inside the plot, all round.',
        'parts', jsonb_build_array(
          jsonb_build_object('label', 'a', 'prompt', 'Find the area of the plot.', 'marks', 3, 'answerType', 'numeric', 'answerExpr', 'length * width', 'tolerance', 0.01),
          jsonb_build_object('label', 'b', 'prompt', 'Find the area enclosed by the inner edge of the path.', 'marks', 4, 'answerType', 'numeric', 'answerExpr', '(length - 2) * (width - 2)', 'tolerance', 0.01),
          jsonb_build_object('label', 'c', 'prompt', 'Find the area of the path.', 'marks', 3, 'answerType', 'numeric', 'answerExpr', '(length * width) - ((length - 2) * (width - 2))', 'tolerance', 0.01)
        ),
        'markScheme', jsonb_build_array(
          jsonb_build_object('code', 'M1', 'text', 'Area of plot = {length} x {width} = {answer_a}'),
          jsonb_build_object('code', 'M1', 'text', 'Inner length = {length} - 2, inner width = {width} - 2'),
          jsonb_build_object('code', 'A1', 'text', 'Inner area = {answer_b}'),
          jsonb_build_object('code', 'M1', 'text', 'Path area = {answer_a} - {answer_b}'),
          jsonb_build_object('code', 'A1', 'text', 'Path area = {answer_c}')
        )
      )
    );
  END LOOP;
END $$;
