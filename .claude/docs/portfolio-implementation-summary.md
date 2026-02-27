# Portfolio Overview Implementation Summary

**Date**: 2026-02-09
**Feature**: Portfolio Overview and Analysis

## Implementation Overview

ポートフォリオ機能を実装しました。総資産額、損益、保有資産の詳細表示を行います。

## Files Created/Modified

### Domain Models (lib/features/portfolio/domain/)

1. **portfolio_summary.dart** - ポートフォリオサマリーモデル
   - totalValueJpy: 総資産額（円）
   - totalCostBasisJpy: 総取得コスト
   - totalProfitLossJpy: 総損益
   - profitLossPercentage: 損益率（%）
   - lastUpdated: 最終更新日時

2. **crypt_holding.dart** - 通貨別保有資産モデル
   - cryptId, symbol, name: 通貨情報
   - amount: 保有量
   - avgCostBasisJpy: 平均取得単価
   - currentPriceJpy: 現在価格
   - valueJpy: 評価額
   - profitLossJpy: 損益
   - profitLossPercentage: 損益率

3. **account_holding.dart** - アカウント別保有資産モデル
   - accountId, name: アカウント情報
   - holdings: List<CryptHolding> - 通貨保有リスト
   - totalValueJpy: 合計評価額
   - totalProfitLossJpy: 合計損益

### Repository (lib/features/portfolio/data/)

1. **portfolio_repository.dart** - ポートフォリオデータ取得
   - getPortfolioSummary(): サマリー取得
   - getCryptHoldings(): 通貨別保有資産取得
   - getAccountHoldings(): アカウント別保有資産取得
   - calculateCurrentValue(): 現在価値計算
   - \_getAccountCryptHoldings(): アカウント毎の通貨保有取得（内部用）

### Provider (lib/features/portfolio/presentation/providers/)

1. **portfolio_provider.dart** - Riverpod Providers
   - portfolioRepositoryProvider: リポジトリプロバイダー
   - portfolioSummaryProvider: サマリープロバイダー
   - cryptHoldingsProvider: 通貨別保有プロバイダー
   - accountHoldingsProvider: アカウント別保有プロバイダー

### Screens (lib/features/portfolio/presentation/screens/)

1. **portfolio_screen.dart** - メインポートフォリオ画面（大幅更新）
   - サマリーカード: 総資産額、損益表示
   - 円グラフ: 保有資産構成（上位5通貨 + その他）
   - タブ切替: 通貨別 / アカウント別
   - 保有資産リスト: 詳細情報表示
   - プルリフレッシュ対応
   - エラーハンドリング

## Calculation Logic

### WAC (Weighted Average Cost) Method

保有量と平均取得コストの計算:

```
1. 購入トランザクションを時系列で処理
   - totalAmount += purchase.amount
   - totalCost += purchase.purchase_yen

2. 売却トランザクションで保有量を減算
   - totalAmount -= sell.amount

3. 平均取得単価を計算
   - avgCostBasis = totalCost / totalAmount
```

### Current Value & P/L Calculation

```
currentValue = amount × latest_price_jpy (from prices table)
profitLoss = currentValue - (amount × avgCostBasis)
profitLossPercentage = (profitLoss / (amount × avgCostBasis)) × 100
```

### Portfolio Summary

```
totalValue = Σ(holding.valueJpy) for all holdings
totalCostBasis = Σ(holding.avgCostBasisJpy × holding.amount)
totalProfitLoss = totalValue - totalCostBasis
profitLossPercentage = (totalProfitLoss / totalCostBasis) × 100
```

## Database Integration

### Tables Used

- **purchases**: 購入履歴（amount, purchase_yen）
- **sells**: 売却履歴（amount）
- **prices**: 価格履歴（unit_yen, exec_at）
- **crypts**: 通貨マスター（symbol, project_name, icon_url, color）
- **accounts**: アカウントマスター（name, icon_url）

### Query Strategy

1. 全購入・売却を取得し、通貨毎にグループ化
2. WAC法で平均取得単価を計算
3. prices テーブルから最新価格を取得
4. 現在価値と損益を計算

## UI Components

### 1. Summary Card

- 総資産額（大きく表示）
- 損益額と損益率（色分け: 緑=利益、赤=損失、灰=変動なし）

### 2. Pie Chart (fl_chart)

- 上位5通貨を表示
- 6番目以降は「その他」としてグループ化
- タッチインタラクション: タッチで拡大表示
- 凡例付き

### 3. Holdings List - 通貨別

- 通貨アイコン（最初の1文字）
- 通貨名、シンボル
- 評価額、損益
- 保有量、平均取得単価、現在価格
- 損益率バッジ（色分け）

### 4. Holdings List - アカウント別

- ExpansionTile で折りたたみ表示
- アカウント名、保有通貨数
- 合計評価額、合計損益
- 展開時: 各通貨の詳細表示

## Features Implemented

✅ Portfolio summary with total value and P&L
✅ WAC (Weighted Average Cost) calculation
✅ Integration with prices table for current values
✅ Pie chart visualization of holdings
✅ Holdings list by crypto (sorted by value)
✅ Holdings list by account (expandable)
✅ Color-coded P&L (green/red/grey)
✅ Pull to refresh
✅ Error handling with user-friendly messages
✅ Material Design 3 styling
✅ Japanese UI labels
✅ Proper number formatting (currency, decimals, percentages)

## Not Yet Implemented

❌ Portfolio detail screen per crypto
❌ Routing for detail screen
❌ Purchase/sell history in detail view
❌ Price chart visualization
❌ Real-time price updates
❌ Last updated timestamp display

## Next Steps

1. **Portfolio Detail Screen**: 通貨毎の詳細画面
   - 購入・売却履歴
   - アカウント毎の保有量
   - 実現損益 vs 未実現損益
   - 価格チャート

2. **Routing**: Detail画面への遷移
   - /portfolio/crypto/:cryptId

3. **Real-time Updates**: Supabase Realtime で価格自動更新

4. **Performance Optimization**:
   - キャッシング戦略
   - Pagination for large holdings

## Testing Recommendations

1. **Unit Tests**:
   - WAC calculation logic
   - P/L calculation accuracy
   - Edge cases (zero holdings, no price data)

2. **Integration Tests**:
   - Repository methods with mock Supabase
   - Provider state management

3. **Widget Tests**:
   - Portfolio screen rendering
   - Tab switching
   - Pull to refresh

4. **E2E Tests**:
   - Full flow from purchases to portfolio display
   - Real Supabase integration

## Known Limitations

1. **Performance**: すべての購入・売却を毎回取得するため、トランザクション数が多いと遅い
   - 解決策: daily_balances テーブルを活用したキャッシング

2. **Price Data**: prices テーブルに最新価格がない場合、0円表示
   - 解決策: 価格更新ジョブの安定化

3. **Decimal Precision**: Dart double の精度制限
   - 解決策: Decimal パッケージの導入検討

## Security Notes

✅ RLS (Row Level Security) enabled on all tables
✅ User-specific data filtering via user_id
✅ No sensitive data exposed in errors
✅ Proper error handling without stack traces to users

## Code Quality

✅ Freezed models for immutability
✅ Riverpod for state management
✅ Type-safe null handling
✅ Consistent naming conventions
✅ Material Design 3 components
✅ Responsive layout
✅ Accessibility considerations (semantic labels)

---

## Implementation Time

**Estimated**: 3-4 hours
**Actual**: Implemented in single session

## Files Summary

**Created**: 7 files (3 models + 1 repository + 1 provider + 1 screen update + 1 doc)
**Generated**: 10 files (freezed/json/provider codegen)
**Modified**: 1 file (portfolio_screen.dart)

Total LOC: ~1,200 lines
