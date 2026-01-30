-- Transaction Tables

-- Commissions (fees) - created first as it's referenced by other tables
CREATE TABLE commissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  approximate_yen DECIMAL(18, 2) NOT NULL,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Airdrops - created before purchases as it's referenced
CREATE TABLE airdrops (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  type SMALLINT NOT NULL CHECK (type IN (1, 2)), -- 1:airdrop, 2:staking
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  approximate_yen DECIMAL(18, 2) NOT NULL,
  profit DECIMAL(18, 2) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  purchase_id UUID, -- Will add FK constraint later to avoid circular dependency
  memo TEXT,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Purchases (deposits, swap purchases, airdrops)
CREATE TABLE purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  deposit_yen DECIMAL(18, 2) DEFAULT 0,
  purchase_yen DECIMAL(18, 2) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  airdrop_id UUID REFERENCES airdrops(id),
  type CHAR(1) NOT NULL CHECK (type IN ('d', 's', 'a')), -- d:deposit, s:swap, a:airdrop
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Add FK constraint from airdrops to purchases
ALTER TABLE airdrops ADD CONSTRAINT fk_airdrops_purchase FOREIGN KEY (purchase_id) REFERENCES purchases(id);

-- Sells
CREATE TABLE sells (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  yen DECIMAL(18, 2) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  profit DECIMAL(18, 2),
  swap_id UUID REFERENCES purchases(id),
  type CHAR(1) NOT NULL CHECK (type IN ('s', 'w')), -- s:sell, w:swap
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Transfers
CREATE TABLE transfers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  from_account_id UUID REFERENCES accounts(id) NOT NULL,
  to_account_id UUID REFERENCES accounts(id) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  profit DECIMAL(18, 2) DEFAULT 0,
  memo TEXT,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Create indexes
CREATE INDEX idx_commissions_user_id ON commissions(user_id);
CREATE INDEX idx_commissions_account_id ON commissions(account_id);
CREATE INDEX idx_commissions_exec_at ON commissions(exec_at);

CREATE INDEX idx_airdrops_user_id ON airdrops(user_id);
CREATE INDEX idx_airdrops_account_id ON airdrops(account_id);
CREATE INDEX idx_airdrops_crypt_id ON airdrops(crypt_id);
CREATE INDEX idx_airdrops_exec_at ON airdrops(exec_at);

CREATE INDEX idx_purchases_user_id ON purchases(user_id);
CREATE INDEX idx_purchases_account_id ON purchases(account_id);
CREATE INDEX idx_purchases_crypt_id ON purchases(crypt_id);
CREATE INDEX idx_purchases_exec_at ON purchases(exec_at);
CREATE INDEX idx_purchases_type ON purchases(type);

CREATE INDEX idx_sells_user_id ON sells(user_id);
CREATE INDEX idx_sells_account_id ON sells(account_id);
CREATE INDEX idx_sells_crypt_id ON sells(crypt_id);
CREATE INDEX idx_sells_exec_at ON sells(exec_at);

CREATE INDEX idx_transfers_user_id ON transfers(user_id);
CREATE INDEX idx_transfers_from_account_id ON transfers(from_account_id);
CREATE INDEX idx_transfers_to_account_id ON transfers(to_account_id);
CREATE INDEX idx_transfers_exec_at ON transfers(exec_at);

-- Apply updated_at triggers
CREATE TRIGGER update_commissions_updated_at
    BEFORE UPDATE ON commissions
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_airdrops_updated_at
    BEFORE UPDATE ON airdrops
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_purchases_updated_at
    BEFORE UPDATE ON purchases
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_sells_updated_at
    BEFORE UPDATE ON sells
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_transfers_updated_at
    BEFORE UPDATE ON transfers
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
