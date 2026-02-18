# crypto_admin2 — Next.js + Supabase 暗号資産ポートフォリオ管理

## プロジェクト概要

個人用の暗号資産ポートフォリオ管理 Web アプリ。
`../crypto_admin`（Laravel 版）のコア機能を React + Next.js で再実装する。
バックエンドは Supabase（DB・Auth・Edge Functions）を使用。マイグレーションと価格取得バッチは稼働済み。

## 技術スタック

| カテゴリ | 採用技術 |
|----------|----------|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript |
| UI | Tailwind CSS + shadcn/ui |
| Data Fetching | TanStack Query v5 |
| Client State | Zustand |
| Backend | Supabase (PostgreSQL, Auth, Edge Functions) |
| i18n | next-intl（日本語・英語） |
| Testing | Vitest + React Testing Library |
| Package Manager | pnpm |
| Deployment | Vercel |

## 実装スコープ（コア機能）

### 優先実装機能

1. **認証** — Supabase Auth（ログイン・新規登録・パスワードリセット）
2. **ポートフォリオダッシュボード** — 保有残高・評価損益・アカウント別/カテゴリ別集計
3. **取引管理** — 入金・売却・スワップ・振替・エアドロップ（CRUD）
4. **アカウント管理** — 取引所・ウォレット等のアカウント一覧管理
5. **カテゴリ管理** — 通貨カテゴリ（ユーザー定義）の管理
6. **損益レポート** — 確定損益・評価損益の年次・月次集計
7. **残高履歴** — 日次残高推移グラフ

### 除外機能（当面スコープ外）

- テクニカル分析（MACD・RSI・ボリンジャーバンド）
- 取引所 API 連携（Bybit・Bitget 等）
- Zaim / Notion 連携
- プッシュ通知・価格アラート
- オートリバランス

## プロジェクト構成

```
crypto_admin2/
├── src/
│   ├── app/                    # Next.js App Router
│   │   ├── [locale]/           # next-intl ロケール別ルート
│   │   │   ├── (auth)/         # 認証不要ページ
│   │   │   │   ├── login/
│   │   │   │   └── register/
│   │   │   └── (dashboard)/    # 認証必須ページ（Supabase Auth）
│   │   │       ├── portfolio/
│   │   │       ├── transactions/
│   │   │       ├── accounts/
│   │   │       ├── categories/
│   │   │       ├── reports/
│   │   │       └── settings/
│   │   └── api/               # API Routes（必要に応じて）
│   ├── components/
│   │   ├── ui/                # shadcn/ui コンポーネント（自動生成）
│   │   └── features/          # 機能別コンポーネント
│   │       ├── portfolio/
│   │       ├── transactions/
│   │       ├── accounts/
│   │       └── reports/
│   ├── hooks/                 # カスタムフック
│   ├── lib/
│   │   ├── supabase/          # Supabase クライアント・型定義
│   │   ├── utils/             # ユーティリティ
│   │   └── validations/       # Zod スキーマ
│   ├── stores/                # Zustand ストア
│   └── types/                 # 型定義
├── messages/
│   ├── ja.json                # 日本語
│   └── en.json                # 英語
├── supabase/
│   ├── config.toml
│   └── migrations/            # スキーマ（稼働済み）
├── public/
├── tests/                     # Vitest テスト
└── CLAUDE.md
```

## データベーススキーマ（Supabase PostgreSQL）

マイグレーションは `supabase/migrations/` に定義済み。概要は以下の通り。

### マスターテーブル（読み取り専用）

| テーブル | 用途 |
|---------|------|
| `crypts` | 暗号通貨マスター（symbol, project_name, icon_url, coingecko_id） |
| `prices` | 価格履歴（crypt_id, exec_at, unit_yen） |

### ユーザーテーブル（RLS 適用）

| テーブル | 用途 |
|---------|------|
| `accounts` | 取引所・ウォレット（name） |
| `crypt_categories` | ユーザー定義カテゴリ |
| `user_crypt_categories` | 通貨 ↔ カテゴリ（多対多） |

### トランザクションテーブル

| テーブル | 用途 |
|---------|------|
| `purchases` | 入金・スワップ買い・エアドロップ（type: d/s/a） |
| `sells` | 売却・スワップ売り（type: s/w） |
| `transfers` | アカウント間振替 |
| `commissions` | 手数料 |
| `swaps` | スワップペア（purchases ↔ sells を 1:1 紐付け） |

### キャッシュ・集計テーブル

| テーブル | 用途 |
|---------|------|
| `cost_basis_history` | WAC 計算履歴・監査証跡 |
| `daily_balances` | 日次残高スナップショット |
| `dm_crypts` | 通貨別年次集計 |
| `dm_accounts` | アカウント別年次集計 |

## 会計ロジック（WAC 方式）

**Weighted Average Cost（加重平均取得単価）方式**

```
購入時:
  new_total_cost = old_total_cost + (qty × price) + fee_jpy
  new_wac = new_total_cost ÷ (old_qty + qty)

売却時:
  realized_pnl = sell_proceeds - (sell_qty × wac) - fee_jpy
  new_total_cost = old_total_cost - (sell_qty × wac)
```

- **確定損益**: 売却時に `sells.profit` と `cost_basis_history.realized_pnl` に記録
- **評価損益**: ポートフォリオ表示時にオンデマンド計算 = `(現価 - WAC) × 保有量`

⚠️ 過去取引の編集・削除時は、後続トランザクションの WAC を再計算する必要がある。

## 開発コマンド

```bash
# 依存関係インストール
pnpm install

# 開発サーバー起動
pnpm dev

# ビルド
pnpm build

# テスト実行
pnpm test          # 全テスト
pnpm test:watch    # ウォッチモード

# 型チェック
pnpm typecheck

# Lint / Format
pnpm lint
pnpm format

# Supabase ローカル起動
pnpm supabase start

# 型自動生成（Supabase → TypeScript）
pnpm supabase gen types typescript --local > src/types/database.types.ts
```

## コーディング規約

### ファイル・コンポーネント

- コンポーネント: `PascalCase`（例: `PortfolioSummary.tsx`）
- フック: `camelCase` + `use` prefix（例: `usePortfolio.ts`）
- ユーティリティ: `camelCase`（例: `formatCurrency.ts`）
- Zustand ストア: `useXxxStore`（例: `usePortfolioStore.ts`）

### データ取得パターン

```typescript
// TanStack Query でサーバーデータを取得
const { data, isLoading } = useQuery({
  queryKey: ['portfolio', userId],
  queryFn: () => fetchPortfolio(userId),
})

// Supabase クライアント（Browser）
import { createClient } from '@/lib/supabase/client'

// Supabase クライアント（Server Components）
import { createClient } from '@/lib/supabase/server'
```

### 金額表示

- 日本円: `toLocaleString('ja-JP', { style: 'currency', currency: 'JPY' })`
- 数量（仮想通貨）: 最大8桁の小数（例: `0.00000001 BTC`）

## 環境変数

```bash
# .env.local
NEXT_PUBLIC_SUPABASE_URL=https://xxx.supabase.co
NEXT_PUBLIC_SUPABASE_ANON_KEY=xxx

# サーバーサイドのみ（Edge Functions 等から参照）
SUPABASE_SERVICE_ROLE_KEY=xxx
```

## Supabase Edge Functions

価格取得・集計バッチはすでに稼働中。フロントエンドから直接呼び出さない。

| Function | スケジュール | 用途 |
|----------|-------------|------|
| `update-prices` | 1時間毎 | CoinGecko から価格取得 |
| `calculate-indicators` | 日次 | テクニカル指標計算 |
| `update-daily-balances` | 日次 | 日次残高スナップショット |
| `update-data-marts` | 日次 | 年次集計テーブル更新 |

## 実装フェーズ

### Phase 1: プロジェクト初期化
- [ ] Next.js 15 セットアップ（App Router + TypeScript）
- [ ] Tailwind CSS + shadcn/ui 導入
- [ ] Supabase クライアント設定
- [ ] next-intl 設定（日本語・英語）
- [ ] TanStack Query + Zustand 設定
- [ ] Vitest 設定

### Phase 2: 認証
- [ ] ログイン画面
- [ ] 新規登録画面
- [ ] パスワードリセット
- [ ] ミドルウェア（認証ガード）

### Phase 3: ポートフォリオ
- [ ] ポートフォリオダッシュボード（残高・損益サマリー）
- [ ] アカウント別ビュー
- [ ] カテゴリ別ビュー

### Phase 4: 取引管理
- [ ] 取引一覧
- [ ] 入金フォーム
- [ ] 売却フォーム
- [ ] スワップフォーム
- [ ] 振替フォーム
- [ ] エアドロップフォーム

### Phase 5: 管理
- [ ] アカウント管理
- [ ] カテゴリ管理

### Phase 6: 分析
- [ ] 損益レポート（確定・評価損益）
- [ ] 残高履歴グラフ

## 参考プロジェクト

- `../crypto_admin`: Laravel 版（本番稼働中）— ビジネスロジックの参考に
- `supabase/migrations/`: DB スキーマ定義（すでに本番適用済み）
