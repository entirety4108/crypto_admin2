-- Cache and Aggregation Tables

-- Daily balance cache
CREATE TABLE daily_balances (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  date DATE NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  unit_price DECIMAL(18, 8),
  valuation DECIMAL(18, 2),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, account_id, crypt_id, date)
);

-- Data mart: Yearly aggregation by cryptocurrency
CREATE TABLE dm_crypts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  year INTEGER NOT NULL,
  deposit_yen_sum DECIMAL(18, 2) DEFAULT 0,
  purchase_yen_sum DECIMAL(18, 2) DEFAULT 0,
  sell_yen_sum DECIMAL(18, 2) DEFAULT 0,
  valuation DECIMAL(18, 2) DEFAULT 0,
  commission_sum DECIMAL(18, 2) DEFAULT 0,
  definite_profit DECIMAL(18, 2) DEFAULT 0,
  indefinite_profit DECIMAL(18, 2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, crypt_id, year)
);

-- Data mart: Yearly aggregation by account
CREATE TABLE dm_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  year INTEGER NOT NULL,
  deposit_yen_sum DECIMAL(18, 2) DEFAULT 0,
  purchase_yen_sum DECIMAL(18, 2) DEFAULT 0,
  sell_yen_sum DECIMAL(18, 2) DEFAULT 0,
  valuation DECIMAL(18, 2) DEFAULT 0,
  commission_sum DECIMAL(18, 2) DEFAULT 0,
  definite_profit DECIMAL(18, 2) DEFAULT 0,
  indefinite_profit DECIMAL(18, 2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, account_id, year)
);

-- Create indexes
CREATE INDEX idx_daily_balances_user_id ON daily_balances(user_id);
CREATE INDEX idx_daily_balances_account_id ON daily_balances(account_id);
CREATE INDEX idx_daily_balances_crypt_id ON daily_balances(crypt_id);
CREATE INDEX idx_daily_balances_date ON daily_balances(date);
CREATE INDEX idx_daily_balances_user_date ON daily_balances(user_id, date);

CREATE INDEX idx_dm_crypts_user_id ON dm_crypts(user_id);
CREATE INDEX idx_dm_crypts_crypt_id ON dm_crypts(crypt_id);
CREATE INDEX idx_dm_crypts_year ON dm_crypts(year);
CREATE INDEX idx_dm_crypts_user_year ON dm_crypts(user_id, year);

CREATE INDEX idx_dm_accounts_user_id ON dm_accounts(user_id);
CREATE INDEX idx_dm_accounts_account_id ON dm_accounts(account_id);
CREATE INDEX idx_dm_accounts_year ON dm_accounts(year);
CREATE INDEX idx_dm_accounts_user_year ON dm_accounts(user_id, year);

-- Apply updated_at triggers
CREATE TRIGGER update_daily_balances_updated_at
    BEFORE UPDATE ON daily_balances
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dm_crypts_updated_at
    BEFORE UPDATE ON dm_crypts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_dm_accounts_updated_at
    BEFORE UPDATE ON dm_accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
