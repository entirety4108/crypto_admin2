# crypto_admin2

Next.js + Supabase で構築した暗号資産ポートフォリオ管理アプリです。

## 技術スタック
- Next.js 16 (App Router)
- TypeScript
- Supabase (Auth / Postgres / RLS)
- TanStack Query
- next-intl (ja/en)
- Vitest + Testing Library

## セットアップ
- 前提: Node.js 20+, pnpm, Supabase CLI
- `pnpm install`
- `.env.example` を `.env.local` にコピーして値を設定
- 必要に応じて `supabase start` / `supabase db push`

## 開発コマンド
- `pnpm dev` : 開発サーバー起動
- `pnpm lint` : ESLint
- `pnpm typecheck` : 型チェック
- `pnpm test` : テスト実行
- `pnpm test:watch` : テストwatch
- `pnpm test:rls` : RLSポリシーテスト
- `pnpm supabase:types` : Supabase型生成（`SUPABASE_PROJECT_REF` 必須）

## ドキュメント
- 実装計画: `DEVELOPMENT_PLAN.md`
- TODO: `TODO.md`
- Query Key 規約: `docs/query-key-convention.md`
- i18n キー規約: `docs/i18n-key-convention.md`

## 品質保証（Phase7）
- 主要フォーム単体テスト: `src/components/auth-form.test.tsx`
- 取引フロー統合テスト: `src/lib/accounting/wac.integration.test.ts`
- RLS権限テスト: `supabase/tests/rls_policies.sql`
- 統一エラー表示: `AlertMessage`
- ローディング/空状態UI: `LoadingState` / `EmptyState`
- アクセシビリティ対応: フォームラベル, `aria-live`, `role=alert`
