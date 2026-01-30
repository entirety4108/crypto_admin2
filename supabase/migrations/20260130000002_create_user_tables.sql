-- User Tables

-- Accounts (exchanges/wallets)
CREATE TABLE accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(255) NOT NULL,
  is_locked BOOLEAN DEFAULT FALSE,
  icon_url TEXT,
  memo TEXT,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Wallet addresses
CREATE TABLE addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID REFERENCES accounts(id) ON DELETE CASCADE NOT NULL,
  address VARCHAR(255) NOT NULL,
  label VARCHAR(100),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Cryptocurrency categories (per user)
CREATE TABLE crypt_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  color VARCHAR(7),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Cryptocurrency-category associations (per user)
CREATE TABLE user_crypt_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  crypt_id UUID REFERENCES crypts(id) ON DELETE CASCADE NOT NULL,
  category_id UUID REFERENCES crypt_categories(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, crypt_id, category_id)
);

-- Create indexes
CREATE INDEX idx_accounts_user_id ON accounts(user_id);
CREATE INDEX idx_addresses_account_id ON addresses(account_id);
CREATE INDEX idx_addresses_user_id ON addresses(user_id);
CREATE INDEX idx_crypt_categories_user_id ON crypt_categories(user_id);
CREATE INDEX idx_user_crypt_categories_user_id ON user_crypt_categories(user_id);
CREATE INDEX idx_user_crypt_categories_crypt_id ON user_crypt_categories(crypt_id);
CREATE INDEX idx_user_crypt_categories_category_id ON user_crypt_categories(category_id);

-- Apply updated_at triggers
CREATE TRIGGER update_accounts_updated_at
    BEFORE UPDATE ON accounts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_crypt_categories_updated_at
    BEFORE UPDATE ON crypt_categories
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
