-- Master Tables (Read-only, shared by all users)

-- Cryptocurrency master table
CREATE TABLE crypts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  symbol VARCHAR(20) UNIQUE NOT NULL,
  project_name VARCHAR(255),
  icon_url TEXT,
  color VARCHAR(7),
  is_active BOOLEAN DEFAULT TRUE,
  coingecko_id VARCHAR(100),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Price history table
CREATE TABLE prices (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  crypt_id UUID REFERENCES crypts(id) ON DELETE CASCADE NOT NULL,
  exec_at DATE NOT NULL,
  unit_yen DECIMAL(18, 8) NOT NULL,
  macd_line DECIMAL(18, 8),
  signal_line DECIMAL(18, 8),
  histogram DECIMAL(18, 8),
  rsi DECIMAL(8, 4),
  bollinger_upper DECIMAL(18, 8),
  bollinger_middle DECIMAL(18, 8),
  bollinger_lower DECIMAL(18, 8),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(crypt_id, exec_at)
);

-- Create indexes for performance
CREATE INDEX idx_crypts_symbol ON crypts(symbol);
CREATE INDEX idx_crypts_coingecko_id ON crypts(coingecko_id);
CREATE INDEX idx_prices_crypt_id ON prices(crypt_id);
CREATE INDEX idx_prices_exec_at ON prices(exec_at);
CREATE INDEX idx_prices_crypt_exec ON prices(crypt_id, exec_at);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Apply trigger to crypts
CREATE TRIGGER update_crypts_updated_at
    BEFORE UPDATE ON crypts
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();
