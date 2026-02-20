-- Reconcile environments where 20260208000001 is marked as applied
-- but cost_basis_history is missing.

CREATE TABLE IF NOT EXISTS public.cost_basis_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  account_id UUID REFERENCES public.accounts(id) NOT NULL,
  crypt_id UUID REFERENCES public.crypts(id) NOT NULL,
  transaction_id UUID NOT NULL,
  transaction_type VARCHAR(20) NOT NULL,
  occurred_at TIMESTAMPTZ NOT NULL,
  total_qty DECIMAL(18, 8) NOT NULL,
  total_cost DECIMAL(18, 2) NOT NULL,
  wac DECIMAL(18, 8) NOT NULL,
  realized_pnl DECIMAL(18, 2),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE INDEX IF NOT EXISTS idx_cost_basis_history_user_account_crypt_occurred
  ON public.cost_basis_history(user_id, account_id, crypt_id, occurred_at);

CREATE INDEX IF NOT EXISTS idx_cost_basis_history_account_crypt
  ON public.cost_basis_history(account_id, crypt_id);

CREATE INDEX IF NOT EXISTS idx_cost_basis_history_transaction
  ON public.cost_basis_history(transaction_id);

CREATE UNIQUE INDEX IF NOT EXISTS idx_cost_basis_history_unique
  ON public.cost_basis_history(user_id, account_id, crypt_id, transaction_id);

ALTER TABLE public.cost_basis_history ENABLE ROW LEVEL SECURITY;

DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'cost_basis_history' AND policyname = 'cost_basis_history_select'
  ) THEN
    CREATE POLICY cost_basis_history_select ON public.cost_basis_history
      FOR SELECT USING (auth.uid() = user_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'cost_basis_history' AND policyname = 'cost_basis_history_insert'
  ) THEN
    CREATE POLICY cost_basis_history_insert ON public.cost_basis_history
      FOR INSERT WITH CHECK (auth.uid() = user_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'cost_basis_history' AND policyname = 'cost_basis_history_update'
  ) THEN
    CREATE POLICY cost_basis_history_update ON public.cost_basis_history
      FOR UPDATE USING (auth.uid() = user_id);
  END IF;

  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE schemaname = 'public' AND tablename = 'cost_basis_history' AND policyname = 'cost_basis_history_delete'
  ) THEN
    CREATE POLICY cost_basis_history_delete ON public.cost_basis_history
      FOR DELETE USING (auth.uid() = user_id);
  END IF;
END
$$;

GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.cost_basis_history TO authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.cost_basis_history TO service_role;

NOTIFY pgrst, 'reload schema';
