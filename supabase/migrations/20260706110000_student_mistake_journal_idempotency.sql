-- PR-036: DB-enforced idempotency for auto-populated mistake journal rows.
CREATE UNIQUE INDEX idx_student_mistake_journal_student_question
  ON public.student_mistake_journal(student_id, question_id)
  WHERE question_id IS NOT NULL;
