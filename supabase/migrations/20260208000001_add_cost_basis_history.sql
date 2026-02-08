-- Cost Basis History Table
-- Tracks historical cost basis and WAC changes for each transaction

CREATE TABLE cost_basis_history (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  transaction_id UUID NOT NULL, -- References various transaction tables (purchases, sells, transfers)
  transaction_type VARCHAR(20) NOT NULL, -- 'purchase', 'sell', 'transfer_out', 'transfer_in'
  occurred_at TIMESTAMPTZ NOT NULL, -- When the transaction occurred
  total_qty DECIMAL(18, 8) NOT NULL, -- Total quantity after this transaction
  total_cost DECIMAL(18, 2) NOT NULL, -- Total cost basis after this transaction
  wac DECIMAL(18, 8) NOT NULL, -- Weighted average cost per unit after this transaction
  realized_pnl DECIMAL(18, 2), -- Realized profit/loss (only for sells/transfers_out)
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes for efficient queries
CREATE INDEX idx_cost_basis_history_user_account_crypt_occurred
  ON cost_basis_history(user_id, account_id, crypt_id, occurred_at);

CREATE INDEX idx_cost_basis_history_account_crypt
  ON cost_basis_history(account_id, crypt_id);

CREATE INDEX idx_cost_basis_history_transaction
  ON cost_basis_history(transaction_id);

-- Unique constraint to prevent duplicate entries for same transaction
CREATE UNIQUE INDEX idx_cost_basis_history_unique
  ON cost_basis_history(user_id, account_id, crypt_id, transaction_id);

-- Add comments
COMMENT ON TABLE cost_basis_history IS 'Historical record of cost basis and WAC changes for audit and debugging';
COMMENT ON COLUMN cost_basis_history.transaction_type IS 'Type of transaction: purchase, sell, transfer_out, transfer_in';
COMMENT ON COLUMN cost_basis_history.wac IS 'Weighted Average Cost per unit in JPY';
COMMENT ON COLUMN cost_basis_history.realized_pnl IS 'Realized profit/loss in JPY (only for disposals)';
