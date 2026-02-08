-- Consolidate Airdrops into Purchases Table
-- Migrates airdrop data into purchases table and removes separate airdrops table

-- Step 1: Check if airdrops table has data
DO $$
DECLARE
  airdrop_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO airdrop_count FROM airdrops;

  IF airdrop_count > 0 THEN
    RAISE NOTICE 'Found % airdrop records to migrate', airdrop_count;
  ELSE
    RAISE NOTICE 'No airdrop records found';
  END IF;
END $$;

-- Step 2: Add new columns to purchases table for airdrop-specific data
ALTER TABLE purchases
  ADD COLUMN airdrop_type SMALLINT CHECK (airdrop_type IN (1, 2)),
  ADD COLUMN airdrop_profit DECIMAL(18, 2);

-- Step 3: Migrate existing airdrop data to purchases
-- Update purchases that are linked to airdrops
UPDATE purchases p
SET
  airdrop_type = a.type,
  airdrop_profit = a.profit
FROM airdrops a
WHERE p.airdrop_id = a.id;

-- Step 4: Remove FK constraint from purchases to airdrops
ALTER TABLE purchases DROP CONSTRAINT IF EXISTS purchases_airdrop_id_fkey;

-- Step 5: Remove FK constraint from airdrops to purchases
ALTER TABLE airdrops DROP CONSTRAINT IF EXISTS fk_airdrops_purchase;

-- Step 6: Drop airdrop_id column from purchases
ALTER TABLE purchases DROP COLUMN airdrop_id;

-- Step 7: Drop the airdrops table
DROP TABLE IF EXISTS airdrops;

-- Step 8: Add constraint to ensure airdrop columns are consistent
ALTER TABLE purchases
  ADD CONSTRAINT chk_purchases_airdrop_consistency
  CHECK (
    (type = 'a' AND airdrop_type IS NOT NULL AND airdrop_profit IS NOT NULL)
    OR
    (type != 'a' AND airdrop_type IS NULL AND airdrop_profit IS NULL)
  );

-- Step 9: Ensure type constraint is properly defined
ALTER TABLE purchases
  DROP CONSTRAINT IF EXISTS purchases_type_check,
  ADD CONSTRAINT chk_purchases_type CHECK (type IN ('d', 's', 'a'));

-- Add comments
COMMENT ON COLUMN purchases.airdrop_type IS 'Airdrop type: 1=airdrop, 2=staking (only for type=a)';
COMMENT ON COLUMN purchases.airdrop_profit IS 'Airdrop profit in JPY (only for type=a)';
COMMENT ON CONSTRAINT chk_purchases_airdrop_consistency ON purchases IS 'Ensures airdrop fields are set only for airdrop transactions';
