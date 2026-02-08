-- Add Business Logic Constraints
-- Adds CHECK constraints for data validation and prevents invalid states

-- CHECK constraints for positive amounts and non-negative prices
ALTER TABLE purchases
  ADD CONSTRAINT chk_purchases_amount_positive CHECK (amount > 0),
  ADD CONSTRAINT chk_purchases_unit_yen_nonnegative CHECK (unit_yen >= 0),
  ADD CONSTRAINT chk_purchases_purchase_yen_nonnegative CHECK (purchase_yen >= 0),
  ADD CONSTRAINT chk_purchases_deposit_yen_nonnegative CHECK (deposit_yen >= 0);

ALTER TABLE sells
  ADD CONSTRAINT chk_sells_amount_positive CHECK (amount > 0),
  ADD CONSTRAINT chk_sells_unit_yen_nonnegative CHECK (unit_yen >= 0),
  ADD CONSTRAINT chk_sells_yen_nonnegative CHECK (yen >= 0);

ALTER TABLE transfers
  ADD CONSTRAINT chk_transfers_amount_positive CHECK (amount > 0),
  ADD CONSTRAINT chk_transfers_different_accounts CHECK (from_account_id != to_account_id);

ALTER TABLE commissions
  ADD CONSTRAINT chk_commissions_amount_positive CHECK (amount > 0),
  ADD CONSTRAINT chk_commissions_unit_yen_nonnegative CHECK (unit_yen >= 0),
  ADD CONSTRAINT chk_commissions_approximate_yen_nonnegative CHECK (approximate_yen >= 0);

-- Unique constraint on commissions to prevent duplicate linking
-- One commission can only be linked to one transaction
CREATE UNIQUE INDEX idx_commissions_unique_purchase
  ON commissions(id)
  WHERE id IN (SELECT commission_id FROM purchases WHERE commission_id IS NOT NULL);

CREATE UNIQUE INDEX idx_commissions_unique_sell
  ON commissions(id)
  WHERE id IN (SELECT commission_id FROM sells WHERE commission_id IS NOT NULL);

CREATE UNIQUE INDEX idx_commissions_unique_transfer
  ON commissions(id)
  WHERE id IN (SELECT commission_id FROM transfers WHERE commission_id IS NOT NULL);

-- Add comments
COMMENT ON CONSTRAINT chk_purchases_amount_positive ON purchases IS 'Ensure purchase amount is positive';
COMMENT ON CONSTRAINT chk_sells_amount_positive ON sells IS 'Ensure sell amount is positive';
COMMENT ON CONSTRAINT chk_transfers_amount_positive ON transfers IS 'Ensure transfer amount is positive';
COMMENT ON CONSTRAINT chk_transfers_different_accounts ON transfers IS 'Prevent transfers to same account';
