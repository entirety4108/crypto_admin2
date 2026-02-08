-- Swaps Table
-- Links buy and sell transactions that represent a crypto-to-crypto swap

CREATE TABLE swaps (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  buy_tx_id UUID REFERENCES purchases(id) NOT NULL,
  sell_tx_id UUID REFERENCES sells(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Unique constraints to ensure one-to-one relationship
CREATE UNIQUE INDEX idx_swaps_buy_tx ON swaps(buy_tx_id);
CREATE UNIQUE INDEX idx_swaps_sell_tx ON swaps(sell_tx_id);

-- Index for user queries
CREATE INDEX idx_swaps_user_id ON swaps(user_id);

-- Apply updated_at trigger
CREATE TRIGGER update_swaps_updated_at
    BEFORE UPDATE ON swaps
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add comments
COMMENT ON TABLE swaps IS 'Links buy and sell transactions that represent crypto-to-crypto swaps';
COMMENT ON COLUMN swaps.buy_tx_id IS 'Purchase transaction (crypto acquired)';
COMMENT ON COLUMN swaps.sell_tx_id IS 'Sell transaction (crypto disposed)';
