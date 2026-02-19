-- Ensure swaps table exists (for environments where prior migration was skipped)

CREATE TABLE IF NOT EXISTS swaps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  buy_tx_id UUID REFERENCES purchases(id) NOT NULL,
  sell_tx_id UUID REFERENCES sells(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE UNIQUE INDEX IF NOT EXISTS idx_swaps_buy_tx ON swaps(buy_tx_id);
CREATE UNIQUE INDEX IF NOT EXISTS idx_swaps_sell_tx ON swaps(sell_tx_id);
CREATE INDEX IF NOT EXISTS idx_swaps_user_id ON swaps(user_id);

DROP TRIGGER IF EXISTS update_swaps_updated_at ON swaps;
CREATE TRIGGER update_swaps_updated_at
    BEFORE UPDATE ON swaps
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

ALTER TABLE swaps ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "swaps_select" ON swaps;
DROP POLICY IF EXISTS "swaps_insert" ON swaps;
DROP POLICY IF EXISTS "swaps_update" ON swaps;
DROP POLICY IF EXISTS "swaps_delete" ON swaps;

CREATE POLICY "swaps_select" ON swaps
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "swaps_insert" ON swaps
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "swaps_update" ON swaps
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "swaps_delete" ON swaps
  FOR DELETE USING (auth.uid() = user_id);

COMMENT ON TABLE swaps IS 'Links buy and sell transactions that represent crypto-to-crypto swaps';
COMMENT ON COLUMN swaps.buy_tx_id IS 'Purchase transaction (crypto acquired)';
COMMENT ON COLUMN swaps.sell_tx_id IS 'Sell transaction (crypto disposed)';
