# Crypto Admin - Project Design Document

> Last Updated: 2026-02-08 (Phase 2.5 Design Review)

## Overview

Crypto Admin is a comprehensive cryptocurrency portfolio management system designed to track holdings, calculate accurate profit/loss using weighted average cost (WAC) accounting, and provide tax reporting for Japanese residents.

### Key Goals

- Accurate transaction ledger with multi-account support
- Weighted average cost (WAC) based profit/loss calculation
- Historical balance tracking and performance analysis
- Tax reporting (確定損益) for Japanese tax regulations
- External integrations (Zaim, price APIs)

---

## Architecture

### System Components

```
┌─────────────┐
│   Flutter   │  Frontend (Web/iOS/Android)
│   Frontend  │  - UI/UX
└──────┬──────┘  - State Management (Riverpod)
       │
       │ Supabase Client
       │
┌──────▼──────────────────────────────────┐
│         Supabase Backend                │
├─────────────────────────────────────────┤
│  PostgreSQL Database                    │
│  - Transaction Tables                   │
│  - Cost Basis History                   │
│  - Daily Balance Cache                  │
│  - Data Marts (yearly aggregates)      │
│                                         │
│  Row Level Security (RLS)               │
│  - User data isolation                  │
│                                         │
│  Edge Functions (Deno)                  │
│  - update-prices                        │
│  - update-daily-balances                │
│  - calculate-indicators                 │
│  - update-data-marts                    │
│  - sync-zaim                            │
│                                         │
│  Cron Jobs (pg_cron)                    │
│  - Scheduled batch processing           │
└─────────────────────────────────────────┘
       │
       │ External APIs
       │
┌──────▼──────┐     ┌──────────┐
│  CoinGecko  │     │   Zaim   │
│  Price API  │     │   API    │
└─────────────┘     └──────────┘
```

### Data Flow

1. **User Input** → Frontend → Supabase Auth → Transaction Tables
2. **Transaction Insert** → Trigger → Update `cost_basis_history`
3. **Cron Job** → Edge Function → Update `daily_balances`, `dm_*`
4. **Frontend Query** → Join transactions + cost_basis + prices → Display P&L

---

## Implementation Plan

### Patterns & Approaches

| Pattern                     | Purpose                  | Notes                                                         |
| --------------------------- | ------------------------ | ------------------------------------------------------------- |
| **Append-Only Ledger**      | Transaction immutability | Use `deleted_at` for logical deletion, `version` for tracking |
| **Cost Basis History**      | WAC calculation          | Record state after each transaction                           |
| **On-Write Calculation**    | Performance & accuracy   | Calculate WAC/P&L when transaction is created                 |
| **Idempotent Batch Jobs**   | Reliability              | Use `job_runs` table + advisory locks                         |
| **Materialized Aggregates** | Query performance        | Pre-calculate yearly aggregates in `dm_*` tables              |

### Libraries & Roles

| Library       | Role               | Version   | Notes                                      |
| ------------- | ------------------ | --------- | ------------------------------------------ |
| Supabase      | Backend platform   | Latest    | PostgreSQL, Auth, Edge Functions, Realtime |
| Flutter       | Frontend framework | 3.x       | Cross-platform (Web, iOS, Android)         |
| Riverpod      | State management   | 2.x       | Code generation with riverpod_annotation   |
| go_router     | Routing            | Latest    | Declarative routing with auth guards       |
| fl_chart      | Charting           | Latest    | Price charts, balance trends               |
| Freezed       | Immutable models   | Latest    | Type-safe domain models                    |
| CoinGecko API | Price data         | Free tier | Hourly price updates                       |
| Zaim API      | Expense tracking   | OAuth 1.0 | Net worth sync                             |

### Key Decisions

| Decision                                                                                           | Rationale                                                                                                                     | Alternatives Considered                                          | Date       |
| -------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------- | ---------- |
| **Consolidate airdrops into purchases**                                                            | Prevent double-counting, simplify queries                                                                                     | Keep separate table with exclusion constraint                    | 2026-02-08 |
| **Add cost_basis_history table**                                                                   | Essential for accurate WAC calculation and retroactive edits                                                                  | Calculate on-read (slow, complex queries)                        | 2026-02-08 |
| **Use on-write WAC calculation**                                                                   | Fast queries, consistent results                                                                                              | On-read calculation (complex, slow)                              | 2026-02-08 |
| **Swaps as linked transactions**                                                                   | Maintain transaction atomicity                                                                                                | Single swap table with JSON                                      | 2026-02-08 |
| **Job idempotency via job_runs**                                                                   | Prevent duplicate execution, enable safe retries                                                                              | Database locks only (no tracking)                                | 2026-02-08 |
| **Logical deletion (deleted_at)**                                                                  | Maintain audit trail, enable rollback                                                                                         | Hard delete (lose history)                                       | 2026-02-08 |
| **Transfer UI/Repo follow Purchase/Sell patterns**                                                 | Consistency in Flutter screens/providers and schema mapping (fee fields optional)                                             | Custom bespoke flow                                              | 2026-02-09 |
| **User-defined categories via crypt_categories + user_crypt_categories**                           | Flexible tagging and grouping of crypts, many-to-many relationships                                                           | Store category on crypts table (one-to-many only), no categories | 2026-02-09 |
| **Airdrop repository uses purchases.type='a' and maps airdrop_profit to purchase_yen/deposit_yen** | Align cost basis with taxable airdrop value; UI mirrors deposit patterns with type chips (1=エアドロップ, 2=ステーキング報酬) | Separate airdrop table or custom fields only                     | 2026-02-09 |
| **Swap repository creates linked sells(type='w') + purchases(type='s') and stores pair in swaps**  | Keeps swap atomic, supports list filtering/sorting via typed joined view model (`SwapWithDetails`)                            | Single-table raw swap records only in UI                         | 2026-02-13 |
| **Portfolio realtime display computes holdings from transaction ledger; `daily_balances` is chart-only cache** | Ensure deposit/sell/transfer/swap changes appear immediately in Portfolio while preserving lightweight historical chart reads | Trigger full `update-daily-balances` on every transaction      | 2026-02-27 |

---

## Database Design

### Core Transaction Tables

**purchases** (入金・購入)

- Types: `d` (deposit), `s` (swap-buy), `a` (airdrop)
- Tracks: unit_yen, amount, deposit_yen, purchase_yen
- Links to: commission, swap (via swaps table), airdrop fields

**sells** (売却)

- Types: `s` (sell), `w` (swap-sell)
- Tracks: unit_yen, amount, yen, profit (realized P&L)
- Links to: commission, swap (via swaps table)

**transfers** (振替)

- Tracks: from_account → to_account movement
- Links to: commission
- Note: Moves cost basis, not just quantity

**commissions** (手数料)

- Separate records linked to parent transactions
- Affects cost basis calculation

**swaps** (スワップ)

- Links: buy_tx_id (purchases) ↔ sell_tx_id (sells)
- Enforces: 1:1 relationship, prevents orphaned halves

**cost_basis_history** (コストベース履歴)

- Records after-transaction state: total_qty, total_cost, wac, realized_pnl
- Per account + asset + transaction
- Enables: WAC lookup, retroactive recalculation, audit trail

### Cache & Aggregation Tables

**daily_balances** (日次残高)

- Snapshot per user + account + asset + date
- Columns: amount, unit_price, valuation
- Watermark: last_recalculated_at

**dm_crypts** (通貨別年次集計)

- Aggregates per user + asset + year
- Metrics: deposit_yen_sum, sell_yen_sum, definite_profit, indefinite_profit

**dm_accounts** (アカウント別年次集計)

- Aggregates per user + account + year
- Same metrics as dm_crypts

**job_runs** (ジョブ実行履歴)

- Tracks Edge Function executions
- Prevents duplicate runs via unique constraint
- Columns: job_name, user_id, account_id, run_date, status

### Category Tables

**crypt_categories** (通貨カテゴリ)

- User-defined categories for organizing crypts
- Columns: user_id, name, color, icon_url, created_at, updated_at
- Examples: "長期保有", "デイトレード", "DeFi", "NFT"

**user_crypt_categories** (通貨カテゴリ割り当て)

- Many-to-many mapping between users, categories, and crypts
- Columns: user_id, category_id, crypt_id
- Enables: One crypt can belong to multiple categories
- Use case: Filter portfolio by category, group analysis by category

---

## Accounting Logic

### Weighted Average Cost (WAC) Formula

**Buy Transaction:**

```
new_total_cost = old_total_cost + (qty × price) + fee_in_jpy
new_total_qty = old_total_qty + qty
new_wac = new_total_cost ÷ new_total_qty
```

**Sell Transaction:**

```
cost_of_sale = sell_qty × wac_before_sell
realized_pnl = sell_proceeds - cost_of_sale - fee_in_jpy
new_total_cost = old_total_cost - cost_of_sale
new_total_qty = old_total_qty - sell_qty
new_wac = new_total_cost ÷ new_total_qty  (if qty > 0)
```

**Transfer:**

- Transfer-out: Same as sell, but realized_pnl = 0, cost basis moves
- Transfer-in: Inherit cost basis from transfer-out

### Profit/Loss Calculation

**Realized P&L (確定損益):**

- Calculated on sell/transfer-out
- Formula: `売却代金 - (売却数量 × WAC) - 手数料`
- Recorded in: `cost_basis_history.realized_pnl`, `sells.profit`

**Unrealized P&L (評価損益):**

- Calculated on-demand for portfolio view
- Formula: `(現在価格 - WAC) × 保有数量`
- Source: `daily_balances.valuation - total_cost_from_history`

**Tax Reporting (確定申告):**

- Sum of realized_pnl for calendar year
- Source: `dm_crypts.definite_profit` per asset
- Total: Sum across all assets for user

---

## Cost Basis Tracking

### Purpose of cost_basis_history

Records the cumulative state after each transaction:

- **total_qty**: Total holding after transaction
- **total_cost**: Total cost basis after transaction
- **wac**: Weighted average cost per unit
- **realized_pnl**: Profit/loss realized by this transaction (if disposal)

### Benefits

1. **Accurate WAC Lookup**: Query most recent record before a sell
2. **Retroactive Recalculation**: Replay from edit point forward
3. **Audit Trail**: Complete history of basis changes
4. **Performance**: No need to scan all historical transactions

### Example Flow

```sql
-- User buys 1 BTC at ¥5,000,000
INSERT INTO cost_basis_history (account_id, crypt_id, occurred_at, total_qty, total_cost, wac)
VALUES (..., 1.0, 5000000, 5000000);

-- User buys 1 BTC at ¥6,000,000
INSERT INTO cost_basis_history (...)
VALUES (..., 2.0, 11000000, 5500000);  -- WAC = 5.5M

-- User sells 0.5 BTC at ¥7,000,000
-- realized_pnl = 7000000 - (0.5 × 5500000) = 4,250,000
INSERT INTO cost_basis_history (...)
VALUES (..., 1.5, 8250000, 5500000, 4250000);  -- WAC unchanged
```

---

## Retroactive Modification Strategy

### Problem

When a past transaction is edited or deleted:

- All subsequent cost_basis_history records become invalid
- daily_balances from that date forward are incorrect
- dm\_\* aggregates for affected years are stale

### Solution: Targeted Recalculation

**Scope:**

1. Identify affected: `account_id` + `crypt_id`
2. Find edit date: `occurred_at` of modified transaction
3. Delete stale records:
   - `cost_basis_history WHERE occurred_at >= edit_date`
   - `daily_balances WHERE date >= edit_date`
   - `dm_crypts WHERE year >= extract(year from edit_date)`
4. Recalculate:
   - Replay transactions in chronological order
   - Rebuild cost_basis_history
   - Regenerate daily_balances (via Edge Function)
   - Regenerate dm\_\* (via Edge Function)

**Watermark Tracking:**

- Add `last_recalculated_at` to cache tables
- Compare with transaction `updated_at` to detect staleness

**Immutability Approach:**

- Prefer append-only with `version` field
- Logical deletion via `deleted_at`
- Enables rollback and full audit trail

---

## Edge Function Idempotency Design

### Why Idempotency Matters

- Cron jobs may retry on failure
- Network issues can cause duplicate execution
- Incorrect results if job runs multiple times

### Implementation Patterns

**1. Job Tracking (job_runs table)**

```sql
-- Before job execution
INSERT INTO job_runs (job_name, user_id, account_id, run_date, started_at)
VALUES ('update_daily_balances', ?, ?, CURRENT_DATE, NOW())
ON CONFLICT (job_name, user_id, account_id, run_date) DO NOTHING
RETURNING id;

-- If no id returned, job already running/completed
-- Skip execution

-- After job completion
UPDATE job_runs SET completed_at = NOW(), status = 'completed'
WHERE id = ?;
```

**2. Delete + Insert Pattern**

```sql
-- Safe to run multiple times
DELETE FROM daily_balances WHERE user_id = ? AND date = ?;
INSERT INTO daily_balances ...;
```

**3. Upsert Pattern**

```sql
INSERT INTO daily_balances (...)
VALUES (...)
ON CONFLICT (user_id, account_id, crypt_id, date)
DO UPDATE SET amount = EXCLUDED.amount, valuation = EXCLUDED.valuation;
```

**4. Advisory Locks**

```sql
-- Prevent concurrent execution for same account
SELECT pg_advisory_lock(hashtext(account_id::text));

-- Perform calculations

SELECT pg_advisory_unlock(hashtext(account_id::text));
```

### Edge Function Responsibilities

| Function              | Frequency    | Idempotency                   | Purpose                            |
| --------------------- | ------------ | ----------------------------- | ---------------------------------- |
| update-prices         | 1 hour       | UPSERT on (crypt_id, exec_at) | Fetch latest prices from CoinGecko |
| calculate-indicators  | 1 day        | UPSERT on (crypt_id, exec_at) | Calculate MACD, RSI, Bollinger     |
| update-daily-balances | 1 day        | DELETE + INSERT by date       | Snapshot balances                  |
| update-data-marts     | 1 day        | DELETE + INSERT by year       | Aggregate yearly totals            |
| check-price-alerts    | 5 min        | Check + update triggered_at   | Send notifications                 |
| sync-zaim             | Manual/1 day | API idempotency               | Update Zaim account balance        |

---

## Open Questions

- [x] How to handle transfer cost basis? → Included in design, transfers move cost basis
- [x] Airdrop double-counting? → Consolidated into purchases table
- [x] Swap integrity? → Dedicated swaps table with FK constraints
- [x] Retroactive edit strategy? → Targeted recalculation with watermarks
- [x] Edge Function idempotency? → job_runs + advisory locks

---

## Changelog

| Date       | Changes                                                                                                            |
| ---------- | ------------------------------------------------------------------------------------------------------------------ |
| 2026-02-27 | Portfolio now computes KPI/holdings from purchases+sells+transfers ledger for immediate reflection after transaction changes; daily_balances remains chart cache |
| 2026-02-13 | Added Swap feature: domain models, repository, provider, form/list screens with profit calculation and filtering   |
| 2026-02-09 | Added Airdrop feature: repository, provider, form/list screens with type filtering (エアドロップ/ステーキング報酬) |
| 2026-02-09 | Added category management feature: domain models, repository, providers, and 3 screens (list/form/detail)          |
| 2026-02-09 | Added Transfer feature implementation (Flutter UI/repository)                                                      |
| 2026-02-08 | Phase 2.5: Design review completed, schema improvements documented                                                 |
| 2026-01-30 | Initial schema created (Phase 1)                                                                                   |
