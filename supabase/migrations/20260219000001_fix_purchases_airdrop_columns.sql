-- Ensure purchases table has airdrop columns
-- Context: some environments missed 20260208000006_consolidate_airdrops.sql application.

ALTER TABLE purchases
  ADD COLUMN IF NOT EXISTS airdrop_type SMALLINT,
  ADD COLUMN IF NOT EXISTS airdrop_profit DECIMAL(18, 2);

-- Normalize check constraints for purchases type and airdrop consistency
ALTER TABLE purchases
  DROP CONSTRAINT IF EXISTS purchases_type_check,
  DROP CONSTRAINT IF EXISTS chk_purchases_type,
  DROP CONSTRAINT IF EXISTS chk_purchases_airdrop_consistency;

ALTER TABLE purchases
  ADD CONSTRAINT chk_purchases_type CHECK (type IN ('d', 's', 'a')),
  ADD CONSTRAINT chk_purchases_airdrop_consistency CHECK (
    (type = 'a' AND airdrop_type IS NOT NULL AND airdrop_profit IS NOT NULL)
    OR
    (type <> 'a' AND airdrop_type IS NULL AND airdrop_profit IS NULL)
  );

COMMENT ON COLUMN purchases.airdrop_type IS 'Airdrop type: 1=airdrop, 2=staking (only for type=a)';
COMMENT ON COLUMN purchases.airdrop_profit IS 'Airdrop profit in JPY (only for type=a)';
COMMENT ON CONSTRAINT chk_purchases_airdrop_consistency ON purchases IS 'Ensures airdrop fields are set only for airdrop transactions';
