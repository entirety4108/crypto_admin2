-- Integration Tables

-- Price alerts
CREATE TABLE price_alerts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  condition VARCHAR(10) NOT NULL CHECK (condition IN ('above', 'below')),
  target_price DECIMAL(18, 8) NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  triggered_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Zaim OAuth credentials
CREATE TABLE zaim_credentials (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL UNIQUE,
  consumer_key TEXT NOT NULL,
  consumer_secret TEXT NOT NULL,
  access_token TEXT NOT NULL,
  access_token_secret TEXT NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Zaim account associations
CREATE TABLE zaim_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  zaim_account_id VARCHAR(50) NOT NULL,
  account_name VARCHAR(255) NOT NULL,
  balance DECIMAL(18, 2) DEFAULT 0,
  last_synced_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, zaim_account_id)
);

-- Create indexes
CREATE INDEX idx_price_alerts_user_id ON price_alerts(user_id);
CREATE INDEX idx_price_alerts_crypt_id ON price_alerts(crypt_id);
CREATE INDEX idx_price_alerts_is_active ON price_alerts(is_active);

CREATE INDEX idx_zaim_credentials_user_id ON zaim_credentials(user_id);

CREATE INDEX idx_zaim_accounts_user_id ON zaim_accounts(user_id);

-- Apply updated_at triggers
CREATE TRIGGER update_zaim_credentials_updated_at
    BEFORE UPDATE ON zaim_credentials
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_zaim_accounts_updated_at
    BEFORE UPDATE ON zaim_accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
