-- Add Audit Columns to Transaction Tables
-- Adds version control, source tracking, external ID mapping, and soft delete support

-- Add columns to transaction tables
ALTER TABLE purchases
  ADD COLUMN version INTEGER DEFAULT 1 NOT NULL,
  ADD COLUMN source VARCHAR(50), -- e.g., 'manual', 'csv_import', 'api_sync'
  ADD COLUMN external_tx_id VARCHAR(255), -- Exchange's transaction ID
  ADD COLUMN deleted_at TIMESTAMPTZ; -- Soft delete timestamp

ALTER TABLE sells
  ADD COLUMN version INTEGER DEFAULT 1 NOT NULL,
  ADD COLUMN source VARCHAR(50),
  ADD COLUMN external_tx_id VARCHAR(255),
  ADD COLUMN deleted_at TIMESTAMPTZ;

ALTER TABLE transfers
  ADD COLUMN version INTEGER DEFAULT 1 NOT NULL,
  ADD COLUMN source VARCHAR(50),
  ADD COLUMN external_tx_id VARCHAR(255),
  ADD COLUMN deleted_at TIMESTAMPTZ;

ALTER TABLE commissions
  ADD COLUMN version INTEGER DEFAULT 1 NOT NULL,
  ADD COLUMN source VARCHAR(50),
  ADD COLUMN external_tx_id VARCHAR(255),
  ADD COLUMN deleted_at TIMESTAMPTZ;

-- Add recalculation tracking to cache tables
ALTER TABLE daily_balances
  ADD COLUMN last_recalculated_at TIMESTAMPTZ;

ALTER TABLE dm_crypts
  ADD COLUMN last_recalculated_at TIMESTAMPTZ;

ALTER TABLE dm_accounts
  ADD COLUMN last_recalculated_at TIMESTAMPTZ;

-- Create indexes for soft delete queries (exclude deleted records)
CREATE INDEX idx_purchases_deleted_at ON purchases(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_sells_deleted_at ON sells(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_transfers_deleted_at ON transfers(deleted_at) WHERE deleted_at IS NULL;
CREATE INDEX idx_commissions_deleted_at ON commissions(deleted_at) WHERE deleted_at IS NULL;

-- Create indexes for external ID lookups
CREATE INDEX idx_purchases_external_tx_id ON purchases(external_tx_id) WHERE external_tx_id IS NOT NULL;
CREATE INDEX idx_sells_external_tx_id ON sells(external_tx_id) WHERE external_tx_id IS NOT NULL;
CREATE INDEX idx_transfers_external_tx_id ON transfers(external_tx_id) WHERE external_tx_id IS NOT NULL;
CREATE INDEX idx_commissions_external_tx_id ON commissions(external_tx_id) WHERE external_tx_id IS NOT NULL;

-- Add comments
COMMENT ON COLUMN purchases.version IS 'Version number for optimistic locking';
COMMENT ON COLUMN purchases.source IS 'Data source: manual, csv_import, api_sync, etc.';
COMMENT ON COLUMN purchases.external_tx_id IS 'Transaction ID from external exchange/wallet';
COMMENT ON COLUMN purchases.deleted_at IS 'Soft delete timestamp (NULL = active)';

COMMENT ON COLUMN daily_balances.last_recalculated_at IS 'Timestamp of last recalculation';
COMMENT ON COLUMN dm_crypts.last_recalculated_at IS 'Timestamp of last recalculation';
COMMENT ON COLUMN dm_accounts.last_recalculated_at IS 'Timestamp of last recalculation';
