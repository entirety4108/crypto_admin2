# Crypto Admin - Flutter + Supabase 移行仕様書

## プロジェクト概要

暗号通貨ポートフォリオ管理システム「crypto_admin」をLaravel+MySQLからFlutter+Supabaseへ移行する。

### 移行元
- **技術スタック**: Laravel 8.75+, Vue 2.6, MySQL 5.7+
- **ソースパス**: `s:\crypto_admin`

### 移行先
- **技術スタック**: Flutter 3.x, Supabase (PostgreSQL, Auth, Edge Functions, Realtime)
- **ソースパス**: `s:\crypto_admin2`

---

## 対象プラットフォーム

- **Web** (Flutter Web)
- **iOS** (Flutter iOS)
- **Android** (Flutter Android)

---

## 主要機能

### 1. ポートフォリオ管理

#### 1.1 アカウント管理
- 取引所/ウォレットアカウントの登録・編集・削除
- アカウント別の保有資産一覧表示
- アカウントのロック（非アクティブ化）機能
- ウォレットアドレスの紐付け

#### 1.2 暗号通貨マスタ（読み取り専用）
- 全ユーザー共通のマスタデータ
- シンボル、プロジェクト名、アイコンURL、カラー
- CoinGecko ID紐付け
- ※登録・更新はEdge Functionsで管理者が実行

#### 1.3 カテゴリ管理
- ユーザーが自由にカテゴリを作成・編集・削除
- 暗号通貨を任意のカテゴリに紐付け可能
- 1つの暗号通貨を複数カテゴリに紐付け可能

### 2. 取引管理

#### 2.1 入金（Deposit）
- 日本円での暗号通貨購入記録
- 必須項目: 実行日時, アカウント, 通貨, 単価(円), 数量, 入金額, 手数料

#### 2.2 売却（Sell）
- 暗号通貨の売却記録
- 加重平均法による損益自動計算
- 必須項目: 実行日時, アカウント, 通貨, 単価(円), 数量, 売却額, 手数料

#### 2.3 スワップ（Swap）
- 暗号通貨間の交換記録
- 売却側と購入側の両取引を自動作成
- 売却側の損益を自動計算

#### 2.4 振替（Transfer）
- アカウント間の暗号通貨移動記録
- 振替手数料の記録

#### 2.5 エアドロップ（Airdrop）
- 無料トークン配布の記録
- ステーキング報酬の記録（タイプ区別）
- 受取時の時価を記録

#### 2.6 手数料（Commission）
- 全取引の手数料を独立管理
- 取引と紐付けて損益計算に反映

### 3. 損益計算・レポート

#### 3.1 損益計算ロジック
- **計算方式**: 加重平均法
- **確定損益**: 売却時に実現した損益
- **評価損益**: 保有資産の含み損益（時価 - 平均取得単価）

#### 3.2 ポートフォリオビュー
- アカウント別保有状況
- 通貨別保有状況

#### 3.3 税務報告（確定申告用）
- 年度別の確定損益集計
- 入金総額、売却総額、手数料総額

#### 3.4 残高履歴
- 日次の残高スナップショット
- 残高推移チャート

### 4. テクニカル分析

#### 4.1 価格チャート
- 通貨別の価格履歴表示
- ローソク足チャート

#### 4.2 テクニカル指標
- **MACD**: MACDライン、シグナルライン、ヒストグラム
- **RSI**: 相対力指数
- **ボリンジャーバンド**: 上限、中央、下限

### 5. 外部連携

#### 5.1 価格データ取得
- **CoinGecko API**: 現在価格・履歴価格の取得
- 定期的な価格更新（Supabase Edge Functions + Cron）

#### 5.2 Zaim連携
- 暗号資産評価額をZaimアカウントに同期
- 評価額の増減を収入/支出として自動記録
- OAuth1認証でZaim APIと連携

### 6. 通知機能

- 価格アラート（設定した閾値を超えた場合）
- プッシュ通知（Firebase Cloud Messaging）

---

## 認証・認可

### 認証方式
- **Supabase Auth** (メール + パスワード)
- メール確認機能

### マルチテナンシー
- 全データにuser_idを付与
- Row Level Security (RLS)でユーザー分離

---

## 多言語対応

- **対応言語**: 日本語、英語
- **実装**: flutter_localizations + intl パッケージ
- **切り替え**: アプリ設定画面で切り替え可能

---

## UI/UX

### テーマ
- **ライトモードのみ**

### デザイン方針
- Material Design 3
- レスポンシブ対応（Web/タブレット/スマホ）

---

## データベース設計 (Supabase/PostgreSQL)

### マスタテーブル（読み取り専用・全ユーザー共通）

```sql
-- 暗号通貨マスタ（読み取り専用）
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

-- 価格履歴（読み取り専用）
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
```

### ユーザーテーブル

```sql
-- アカウント（取引所/ウォレット）
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

-- ウォレットアドレス
CREATE TABLE addresses (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  account_id UUID REFERENCES accounts(id) ON DELETE CASCADE NOT NULL,
  address VARCHAR(255) NOT NULL,
  label VARCHAR(100),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 暗号通貨カテゴリ（ユーザーごと）
CREATE TABLE crypt_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name VARCHAR(100) NOT NULL,
  color VARCHAR(7),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 暗号通貨とカテゴリの紐付け（ユーザーごと）
CREATE TABLE user_crypt_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  crypt_id UUID REFERENCES crypts(id) ON DELETE CASCADE NOT NULL,
  category_id UUID REFERENCES crypt_categories(id) ON DELETE CASCADE NOT NULL,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, crypt_id, category_id)
);
```

### 取引テーブル

```sql
-- 購入（入金・スワップ購入・エアドロップ）
CREATE TABLE purchases (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  deposit_yen DECIMAL(18, 2) DEFAULT 0,
  purchase_yen DECIMAL(18, 2) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  airdrop_id UUID REFERENCES airdrops(id),
  type CHAR(1) NOT NULL CHECK (type IN ('d', 's', 'a')), -- d:deposit, s:swap, a:airdrop
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 売却
CREATE TABLE sells (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  yen DECIMAL(18, 2) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  profit DECIMAL(18, 2),
  swap_id UUID REFERENCES purchases(id),
  type CHAR(1) NOT NULL CHECK (type IN ('s', 'w')), -- s:sell, w:swap
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 振替
CREATE TABLE transfers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  from_account_id UUID REFERENCES accounts(id) NOT NULL,
  to_account_id UUID REFERENCES accounts(id) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  profit DECIMAL(18, 2) DEFAULT 0,
  memo TEXT,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- エアドロップ
CREATE TABLE airdrops (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  type SMALLINT NOT NULL CHECK (type IN (1, 2)), -- 1:airdrop, 2:staking
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  approximate_yen DECIMAL(18, 2) NOT NULL,
  profit DECIMAL(18, 2) NOT NULL,
  commission_id UUID REFERENCES commissions(id),
  purchase_id UUID REFERENCES purchases(id),
  memo TEXT,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 手数料
CREATE TABLE commissions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  exec_at TIMESTAMPTZ NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  unit_yen DECIMAL(18, 8) NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  approximate_yen DECIMAL(18, 2) NOT NULL,
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);
```

### キャッシュ・集計テーブル

```sql
-- 日次残高キャッシュ
CREATE TABLE daily_balances (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  date DATE NOT NULL,
  amount DECIMAL(18, 8) NOT NULL,
  unit_price DECIMAL(18, 8),
  valuation DECIMAL(18, 2),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, account_id, crypt_id, date)
);

-- データマート：通貨別年間集計
CREATE TABLE dm_crypts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  crypt_id UUID REFERENCES crypts(id) NOT NULL,
  year INTEGER NOT NULL,
  deposit_yen_sum DECIMAL(18, 2) DEFAULT 0,
  purchase_yen_sum DECIMAL(18, 2) DEFAULT 0,
  sell_yen_sum DECIMAL(18, 2) DEFAULT 0,
  valuation DECIMAL(18, 2) DEFAULT 0,
  commission_sum DECIMAL(18, 2) DEFAULT 0,
  definite_profit DECIMAL(18, 2) DEFAULT 0,
  indefinite_profit DECIMAL(18, 2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, crypt_id, year)
);

-- データマート：アカウント別年間集計
CREATE TABLE dm_accounts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  user_id UUID REFERENCES auth.users(id) NOT NULL,
  account_id UUID REFERENCES accounts(id) NOT NULL,
  year INTEGER NOT NULL,
  deposit_yen_sum DECIMAL(18, 2) DEFAULT 0,
  purchase_yen_sum DECIMAL(18, 2) DEFAULT 0,
  sell_yen_sum DECIMAL(18, 2) DEFAULT 0,
  valuation DECIMAL(18, 2) DEFAULT 0,
  commission_sum DECIMAL(18, 2) DEFAULT 0,
  definite_profit DECIMAL(18, 2) DEFAULT 0,
  indefinite_profit DECIMAL(18, 2) DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, account_id, year)
);

```

### 連携テーブル

```sql
-- 価格アラート設定
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

-- Zaim OAuth認証情報
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

-- Zaimアカウント連携
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
```

---

## Row Level Security (RLS)

全テーブルにRLSを適用する。

### 読み取り専用テーブル（crypts, prices）

```sql
-- crypts: 全ユーザー読み取り可、書き込みはservice_roleのみ
ALTER TABLE crypts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view crypts" ON crypts FOR SELECT USING (true);

-- prices: 全ユーザー読み取り可、書き込みはservice_roleのみ
ALTER TABLE prices ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view prices" ON prices FOR SELECT USING (true);
```

### ユーザーテーブル

```sql
-- accounts
ALTER TABLE accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "accounts_select" ON accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "accounts_insert" ON accounts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "accounts_update" ON accounts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "accounts_delete" ON accounts FOR DELETE USING (auth.uid() = user_id);

-- addresses
ALTER TABLE addresses ENABLE ROW LEVEL SECURITY;
CREATE POLICY "addresses_select" ON addresses FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "addresses_insert" ON addresses FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "addresses_update" ON addresses FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "addresses_delete" ON addresses FOR DELETE USING (auth.uid() = user_id);

-- crypt_categories
ALTER TABLE crypt_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "crypt_categories_select" ON crypt_categories FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "crypt_categories_insert" ON crypt_categories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "crypt_categories_update" ON crypt_categories FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "crypt_categories_delete" ON crypt_categories FOR DELETE USING (auth.uid() = user_id);

-- user_crypt_categories
ALTER TABLE user_crypt_categories ENABLE ROW LEVEL SECURITY;
CREATE POLICY "user_crypt_categories_select" ON user_crypt_categories FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "user_crypt_categories_insert" ON user_crypt_categories FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "user_crypt_categories_delete" ON user_crypt_categories FOR DELETE USING (auth.uid() = user_id);
```

### 取引テーブル

```sql
-- purchases
ALTER TABLE purchases ENABLE ROW LEVEL SECURITY;
CREATE POLICY "purchases_select" ON purchases FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "purchases_insert" ON purchases FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "purchases_update" ON purchases FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "purchases_delete" ON purchases FOR DELETE USING (auth.uid() = user_id);

-- sells
ALTER TABLE sells ENABLE ROW LEVEL SECURITY;
CREATE POLICY "sells_select" ON sells FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "sells_insert" ON sells FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "sells_update" ON sells FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "sells_delete" ON sells FOR DELETE USING (auth.uid() = user_id);

-- transfers
ALTER TABLE transfers ENABLE ROW LEVEL SECURITY;
CREATE POLICY "transfers_select" ON transfers FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "transfers_insert" ON transfers FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "transfers_update" ON transfers FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "transfers_delete" ON transfers FOR DELETE USING (auth.uid() = user_id);

-- airdrops
ALTER TABLE airdrops ENABLE ROW LEVEL SECURITY;
CREATE POLICY "airdrops_select" ON airdrops FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "airdrops_insert" ON airdrops FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "airdrops_update" ON airdrops FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "airdrops_delete" ON airdrops FOR DELETE USING (auth.uid() = user_id);

-- commissions
ALTER TABLE commissions ENABLE ROW LEVEL SECURITY;
CREATE POLICY "commissions_select" ON commissions FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "commissions_insert" ON commissions FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "commissions_update" ON commissions FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "commissions_delete" ON commissions FOR DELETE USING (auth.uid() = user_id);
```

### キャッシュ・集計テーブル

```sql
-- daily_balances
ALTER TABLE daily_balances ENABLE ROW LEVEL SECURITY;
CREATE POLICY "daily_balances_select" ON daily_balances FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "daily_balances_all" ON daily_balances FOR ALL USING (auth.uid() = user_id);

-- dm_crypts
ALTER TABLE dm_crypts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "dm_crypts_select" ON dm_crypts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "dm_crypts_all" ON dm_crypts FOR ALL USING (auth.uid() = user_id);

-- dm_accounts
ALTER TABLE dm_accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "dm_accounts_select" ON dm_accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "dm_accounts_all" ON dm_accounts FOR ALL USING (auth.uid() = user_id);
```

### 連携テーブル

```sql
-- price_alerts
ALTER TABLE price_alerts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "price_alerts_select" ON price_alerts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "price_alerts_insert" ON price_alerts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "price_alerts_update" ON price_alerts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "price_alerts_delete" ON price_alerts FOR DELETE USING (auth.uid() = user_id);

-- zaim_credentials
ALTER TABLE zaim_credentials ENABLE ROW LEVEL SECURITY;
CREATE POLICY "zaim_credentials_select" ON zaim_credentials FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "zaim_credentials_insert" ON zaim_credentials FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "zaim_credentials_update" ON zaim_credentials FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "zaim_credentials_delete" ON zaim_credentials FOR DELETE USING (auth.uid() = user_id);

-- zaim_accounts
ALTER TABLE zaim_accounts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "zaim_accounts_select" ON zaim_accounts FOR SELECT USING (auth.uid() = user_id);
CREATE POLICY "zaim_accounts_insert" ON zaim_accounts FOR INSERT WITH CHECK (auth.uid() = user_id);
CREATE POLICY "zaim_accounts_update" ON zaim_accounts FOR UPDATE USING (auth.uid() = user_id);
CREATE POLICY "zaim_accounts_delete" ON zaim_accounts FOR DELETE USING (auth.uid() = user_id);
```

---

## Supabase Edge Functions

### 1. 価格更新 (update-prices)
- CoinGecko APIから価格取得
- pricesテーブルに保存
- Cron: 1時間ごと

### 2. テクニカル指標計算 (calculate-indicators)
- MACD、RSI、ボリンジャーバンド計算
- pricesテーブルを更新
- Cron: 1日1回

### 3. 日次残高更新 (update-daily-balances)
- daily_balancesテーブルを更新
- Cron: 1日1回

### 4. データマート更新 (update-data-marts)
- dm_crypts, dm_accountsを更新
- Cron: 1日1回

### 5. 価格アラート確認 (check-price-alerts)
- 閾値を超えたらプッシュ通知送信
- Cron: 5分ごと

### 6. Zaim同期 (sync-zaim)
- ユーザーの暗号資産評価合計額をZaimアカウントに同期
- 評価額の差分を収入/支出として記録
- 手動トリガーまたはCron: 1日1回

---

## Flutter アーキテクチャ

### 状態管理
- **Riverpod** (推奨)

### ディレクトリ構成

```
lib/
├── main.dart
├── app.dart
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   └── theme/
├── features/
│   ├── auth/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   ├── portfolio/
│   ├── transactions/
│   ├── analysis/
│   ├── settings/
│   └── notifications/
├── shared/
│   ├── widgets/
│   ├── models/
│   └── services/
└── l10n/
    ├── app_ja.arb
    └── app_en.arb
```

### 主要パッケージ

```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter

  # Supabase
  supabase_flutter: ^2.0.0

  # 状態管理
  flutter_riverpod: ^2.0.0
  riverpod_annotation: ^2.0.0

  # ルーティング
  go_router: ^14.0.0

  # UI
  fl_chart: ^0.68.0  # チャート
  data_table_2: ^2.5.0  # テーブル

  # ユーティリティ
  intl: ^0.19.0
  freezed_annotation: ^2.0.0
  json_annotation: ^4.0.0

  # 通知
  firebase_messaging: ^15.0.0
  flutter_local_notifications: ^17.0.0

dev_dependencies:
  build_runner: ^2.0.0
  freezed: ^2.0.0
  json_serializable: ^6.0.0
  riverpod_generator: ^2.0.0
```

---

## 画面構成

### 認証
- ログイン画面
- 新規登録画面
- パスワードリセット画面

### メイン（BottomNavigation）
1. **ポートフォリオ** - 保有資産概要、アカウント別・通貨別ビュー
2. **取引** - 取引一覧、各種取引の追加・編集
3. **分析** - チャート、テクニカル指標、損益レポート
4. **設定** - アカウント管理、カテゴリ管理、Zaim連携、通知設定、言語設定

---

## 開発フェーズ

### Phase 1: 基盤構築
- Supabaseプロジェクト作成
- データベーススキーマ作成（crypts, pricesテーブル含む）
- RLS設定
- Flutter プロジェクト初期化
- 認証機能実装

### Phase 2: 価格データ取得
- CoinGecko API連携
- cryptsテーブルへの暗号通貨マスタ登録
- pricesテーブルへの価格データ保存
- Edge Function (update-prices) 実装
- Cronスケジューリング設定

### Phase 3: コア機能
- アカウント管理
- 取引管理（入金、売却、スワップ、振替、エアドロップ）
- ポートフォリオ表示

### Phase 4: 分析・レポート
- 残高履歴
- 損益計算
- テクニカル分析（MACD, RSI, ボリンジャーバンド）
- チャート表示

### Phase 5: 外部連携
- Zaim連携
- その他Edge Functions実装

### Phase 6: 通知・最終調整
- プッシュ通知
- 価格アラート
- テスト・最終調整

---

## 除外機能（既存から削除）

- 投資目的（Objective）管理機能
- NFT管理機能
- リバランス自動実行機能
- Bybit連携
- Bitget連携
- GMO Coin連携
- Hyperliquid連携
- OpenSea連携
- Slack通知
- Notion連携
- Solana/Anchor関連機能
