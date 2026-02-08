# Design Review: Phase 2.5 - Cryptocurrency Portfolio Management System

**Review Date**: 2026-02-08
**Reviewed By**: Codex CLI (gpt-5.2-codex)
**Context**: PostgreSQL schema for crypto transaction ledger with weighted average cost accounting

---

## Critical Issues / Risks

### 1. Swap Double-Recording Risk
- **Issue**: `purchases(type='s')` and `sells(type='w')` record the same swap event twice
- **Risk**: Integrity can easily break without FK/unique constraints and quantity/price/fee consistency checks
- **Impact**: Asset balances and P&L will be incorrect

### 2. Airdrop Double-Counting
- **Issue**: Both `airdrops` table and `purchases(type='a')` may represent the same event
- **Risk**: Severe double-counting if both records exist for same airdrop
- **Solution Needed**: Consolidate into one table OR add mutual exclusion constraint

### 3. Commission Isolation/Duplication
- **Issue**: `commissions` as separate table prone to orphaned records or duplicate linking
- **Requirements**: FK + unique constraint + referential integrity is mandatory

### 4. Transfer Cost Basis Migration
- **Issue**: `transfers` with profit=0 doesn't handle cost basis movement between accounts
- **Risk**: Cost basis disappears or duplicates when transferred
- **Impact**: Incorrect WAC and P&L calculations

### 5. Retroactive Edit Inconsistency
- **Issue**: `daily_balances` and `dm_*` tables don't automatically recalculate when past transactions are edited
- **Risk**: Permanent data inconsistency
- **Impact**: Reports show incorrect historical balances and P&L

---

## Recommended Schema Changes

### 1. Unified Transaction Layer
Create a common `transactions` (or `ledger_entries`) schema with type discrimination:
- Minimum columns: `tx_id`, `account_id`, `asset_id`, `occurred_at`, `qty`, `price`, `total`, `fee_asset_id`, `fee_qty`, `source`, `external_tx_id`
- Reduces duplicate logic across multiple tables
- Simplifies querying and consistency enforcement

### 2. Dedicated Swap Link Table
Create `swaps` table:
- Links `buy_tx_id` and `sell_tx_id` in 1:1 relationship
- Enforces quantity, fee, and rate consistency
- Prevents orphaned swap halves

### 3. Cost Basis History Table
Add `cost_basis_history` or `positions` table:
- Records after-transaction state: `total_qty`, `total_cost`, `wac`, `realized_pnl`
- Enables accurate historical WAC lookup
- Essential for retroactive recalculation

### 4. Prices Table
Add `prices` table:
- Columns: `asset_id`, `timestamp`, `price`, `source`
- Ensures referential integrity with `daily_balances`
- Handles missing price data explicitly

### 5. Job Execution Management
Add `job_runs` table:
- Unique constraint on: `job_name` + `account_id` + `date` + `hash`
- Prevents duplicate executions and conflicts
- Tracks last successful run

---

## Accounting Strategy (WAC / Profit Calculation)

### Weighted Average Cost Calculation
Maintain per-account, per-asset: `total_qty`, `total_cost`

**Buy Transaction**:
```
total_cost += qty * price + fee_in_base_currency
total_qty += qty - fee_in_asset
```

**Sell Transaction**:
```
cost = sell_qty * WAC(before_sell)
total_cost -= cost
total_qty -= sell_qty
realized_pnl = sell_proceeds - cost - fee
```

### Profit Calculation Timing
- **Recommendation**: On-write calculation (immediate)
- **Rationale**: Accurate and fast, no need for complex on-read queries
- **Implementation**: Write to `cost_basis_history` at transaction time
- **Retroactive edits**: Recalculate from edit date forward

### Partial Sells
- WAC automatically adjusts based on remaining quantity
- `positions` table tracks cumulative state
- No special handling needed beyond standard WAC formula

---

## Retroactive Modification Strategy

### Impact Scope
When a past transaction is edited:
1. Recalculate `positions` from edit date forward
2. Invalidate `daily_balances` from edit date forward
3. Recalculate `dm_crypts` and `dm_accounts` for affected year(s)

### Recalculation Granularity
- Minimize scope: only recalculate affected `account_id` + `asset_id`
- Don't recalculate unaffected assets or accounts

### Watermark Tracking
Add `last_recalculated_at` column to:
- `daily_balances`
- `dm_crypts`
- `dm_accounts`

Compare with transaction `updated_at` to detect stale data.

### Immutability Approach
- **Recommended**: Append-only with `version` field
- **Deletions**: Use `is_void` flag (logical deletion)
- **Edits**: Create new version, mark old version as void
- **Benefits**: Full audit trail, easier rollback

---

## Idempotency Design for Edge Functions

### `update-daily-balances`
```sql
-- Strategy: Delete + Insert or Upsert
DELETE FROM daily_balances
WHERE user_id = ? AND date = ?;

INSERT INTO daily_balances ...;

-- Record execution
INSERT INTO job_runs (job_name, account_id, date, hash, completed_at)
VALUES ('daily_balances', ?, ?, ?, NOW())
ON CONFLICT DO NOTHING;
```

**Key Points**:
- Unique constraint on `(job_name, account_id, date)` prevents duplicate runs
- Hash input data to detect actual changes
- Safe to retry if job fails

### `update-data-marts`
```sql
-- Strategy: Full recalculation (recommended for yearly aggregates)
DELETE FROM dm_crypts
WHERE user_id = ? AND year = ?;

INSERT INTO dm_crypts
SELECT ... FROM transactions WHERE year = ?;

-- For incremental update (more complex):
-- Track last_tx_id and process only new transactions
```

**Key Points**:
- Full recalc is simpler and safer for yearly aggregates
- Incremental update requires tracking `last_tx_id` per user/year
- Use transactions to ensure atomicity

### Concurrency Control
```sql
-- Prevent concurrent execution for same account
SELECT pg_advisory_lock(account_id);

-- Perform calculations

SELECT pg_advisory_unlock(account_id);
```

**Key Points**:
- Advisory locks prevent race conditions
- Lock at account level for granular concurrency
- Ensure locks are released (use PL/pgSQL exception handlers)

---

## Missing Constraints / Columns

### Referential Integrity
```sql
-- All transaction tables need:
ALTER TABLE purchases ADD CONSTRAINT fk_account
  FOREIGN KEY (account_id) REFERENCES accounts(id);

ALTER TABLE purchases ADD CONSTRAINT fk_asset
  FOREIGN KEY (crypt_id) REFERENCES crypts(id);

-- Commission linking (prevent orphans and duplicates):
ALTER TABLE commissions ADD CONSTRAINT fk_transaction
  FOREIGN KEY (tx_id) REFERENCES transactions(id);

ALTER TABLE commissions ADD CONSTRAINT unique_tx_link
  UNIQUE (tx_id, tx_type);

-- Swap integrity:
ALTER TABLE swaps ADD CONSTRAINT unique_buy_tx
  UNIQUE (buy_tx_id);

ALTER TABLE swaps ADD CONSTRAINT unique_sell_tx
  UNIQUE (sell_tx_id);
```

### Validity Checks
```sql
-- Quantity and price sanity:
ALTER TABLE purchases ADD CONSTRAINT check_qty_positive
  CHECK (amount > 0);

ALTER TABLE purchases ADD CONSTRAINT check_price_nonnegative
  CHECK (unit_yen >= 0);

ALTER TABLE purchases ADD CONSTRAINT check_occurred_at_not_null
  CHECK (occurred_at IS NOT NULL);

-- Balance non-negativity (optional, context-dependent):
-- Use DEFERRABLE if intermediate states may violate
ALTER TABLE daily_balances ADD CONSTRAINT check_balance_nonnegative
  CHECK (amount >= 0) DEFERRABLE INITIALLY DEFERRED;
```

### Audit Columns
```sql
-- Add to all transaction tables:
ALTER TABLE purchases ADD COLUMN created_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE purchases ADD COLUMN updated_at TIMESTAMPTZ DEFAULT NOW();
ALTER TABLE purchases ADD COLUMN deleted_at TIMESTAMPTZ;
ALTER TABLE purchases ADD COLUMN version INTEGER DEFAULT 1;
ALTER TABLE purchases ADD COLUMN source VARCHAR(50); -- 'manual', 'import', 'api'
ALTER TABLE purchases ADD COLUMN external_tx_id VARCHAR(255); -- from exchange
```

---

## Additional Recommendations

### 1. Transaction Boundaries
- All WAC updates and profit calculations should happen within a single database transaction
- Use `SERIALIZABLE` isolation level for critical calculations
- Implement retry logic for serialization failures

### 2. Data Validation Layer
- Implement application-level validation before writing to database
- Validate swap pairs match (quantity conservation)
- Validate commission amounts are reasonable
- Validate timestamps are in valid range

### 3. Testing Strategy
- Unit test WAC calculation with various scenarios:
  - Multiple buys at different prices
  - Partial sells
  - Complete liquidation
  - Swap transactions
  - Transfer with cost basis
- Integration test retroactive modification flow
- Load test concurrent transaction processing

### 4. Monitoring & Alerting
- Track balance discrepancies (sum of transactions vs. daily_balances)
- Alert on negative balances (if not allowed)
- Monitor job execution failures and retries
- Track data staleness (last_recalculated_at)

### 5. Performance Optimization
- Index on `(user_id, asset_id, occurred_at)` for WAC calculations
- Partition large tables by user_id or date
- Materialize frequently accessed aggregations
- Use read replicas for reporting queries

---

## Summary

The current design has **solid foundation** but requires critical fixes to ensure data integrity and accurate accounting:

**Must Fix**:
1. Resolve airdrop double-counting (unify tables or add exclusion constraint)
2. Add cost basis tracking (new table)
3. Implement retroactive recalculation logic
4. Add missing FK constraints and unique constraints
5. Implement idempotent edge functions with job tracking

**Should Fix**:
1. Consider unified transaction layer
2. Add prices table for referential integrity
3. Implement transfer cost basis migration
4. Add audit columns

**Nice to Have**:
1. Version-based immutability
2. Advanced monitoring and alerting
3. Performance optimizations

Addressing the "Must Fix" items will prevent calculation errors and data inconsistency. The accounting logic using on-write WAC calculation with cost_basis_history is sound and recommended.
