DO $$
DECLARE p record;
BEGIN
  FOR p IN SELECT policyname FROM pg_policies WHERE schemaname='public' AND tablename='lesson_shares' AND cmd='SELECT'
  LOOP
    EXECUTE format('DROP POLICY %I ON public.lesson_shares', p.policyname);
  END LOOP;
END $$;

REVOKE SELECT ON public.lesson_shares FROM anon;

CREATE POLICY "Owners can read their own shares"
ON public.lesson_shares FOR SELECT TO authenticated
USING (auth.uid() = user_id);