# TODO — crypto_admin2（Next.js移行）

最終更新: 2026-02-18
参照: `CLAUDE.md`, `DEVELOPMENT_PLAN.md`

---

## Phase 1: 基盤構築
- [x] Next.js 15 + TypeScript プロジェクト初期化
- [x] Tailwind CSS 導入
- [x] shadcn/ui 初期セットアップ（Button/Input/Table/Dialog）
- [x] Supabase client/server ヘルパー実装（`src/lib/supabase`）
- [x] next-intl 設定（ja/enメッセージ）
- [x] TanStack Query Provider 実装
- [x] Zustand ストア雛形作成
- [x] Vitest + React Testing Library 設定
- [x] ESLint/Prettier/TypeScript strict 設定
- [x] CI（lint/typecheck/test）追加

## Phase 2: 認証・ルーティング
- [x] ログイン画面
- [x] 新規登録画面
- [x] パスワードリセット画面
- [x] 認証ガード（middleware）
- [x] 認証後リダイレクト（portfolio）
- [x] 共通ダッシュボードレイアウト（ナビ含む）
- [x] 言語切替UI

## Phase 3: 管理機能（Accounts / Categories）
- [x] accounts 一覧ページ
- [x] accounts 作成フォーム
- [x] accounts 編集フォーム
- [x] accounts 削除処理（論理削除方針があれば対応）
- [x] crypt_categories 一覧/作成/編集/削除
- [x] user_crypt_categories 紐付けUI
- [x] 画面/APIのバリデーション（Zod）

## Phase 4: 取引管理（CRUD）
- [x] 取引一覧ページ（種別フィルタ/期間フィルタ）
- [x] 入金（purchases type=d）登録
- [x] 売却（sells type=s）登録
- [x] スワップ（purchases+sells+swaps）登録
- [x] 振替（transfers）登録
- [x] エアドロップ（purchases type=a）登録
- [x] 各取引の編集
- [x] 各取引の削除
- [x] 手数料（commissions）紐付けUI

## Phase 5: 会計ロジック（WAC）
- [x] WAC計算ユースケース実装
- [x] 売却時 realized PnL 計算実装
- [x] 編集/削除時の再計算実装
- [x] `cost_basis_history` 更新実装
- [x] 境界値テスト（小数・ゼロ残高・連続売買）
- [x] 期待値フィクスチャ作成（旧システム比較用）

## Phase 6: ポートフォリオ・分析
- [x] ポートフォリオサマリー（総評価額/確定/評価損益）
- [x] アカウント別保有表示
- [x] カテゴリ別保有表示
- [x] 損益レポート（月次/年次）
- [x] 残高履歴（日次）グラフ
- [x] 表示パフォーマンス改善（必要に応じて）

## Phase 7: 品質保証
- [x] 主要フォームの単体テスト
- [x] 主要クエリのRLS権限テスト
- [x] 取引フロー統合テスト（作成→集計反映）
- [x] エラー表示統一（Toast/Alert）
- [x] ローディング/空状態UI整備
- [x] アクセシビリティ最低限対応

## Phase 8: リリース準備
- [ ] UATチェックリスト作成
- [ ] 本番環境変数最終確認
- [ ] デプロイ手順書作成
- [ ] ロールバック手順書作成
- [ ] 既存運用との差分確認（残高・損益）
- [ ] リリース判定

---

## 補助タスク
- [x] `README.md` を Next.js版運用手順に更新
- [x] Supabase 型自動生成スクリプト整備
- [x] 画面ごとの Query Key 命名規約を文書化
- [x] 日英翻訳キー命名規約を文書化
