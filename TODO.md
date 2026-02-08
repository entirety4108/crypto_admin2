# Crypto Admin - 実装TODOリスト

生成日時: 2026-01-30

---

## Phase 1: 基盤構築 ✅

### Supabase セットアップ
- [x] Supabaseプロジェクト作成
- [x] 環境変数の設定（SUPABASE_URL, SUPABASE_ANON_KEY）

### データベース構築
- [x] マスタテーブル作成
  - [x] crypts テーブル（暗号通貨マスタ）
  - [x] prices テーブル（価格履歴）
- [x] ユーザーテーブル作成
  - [x] accounts テーブル（取引所/ウォレット）
  - [x] addresses テーブル（ウォレットアドレス）
  - [x] crypt_categories テーブル（カテゴリ）
  - [x] user_crypt_categories テーブル（カテゴリ紐付け）
- [x] 取引テーブル作成
  - [x] purchases テーブル（購入）
  - [x] sells テーブル（売却）
  - [x] transfers テーブル（振替）
  - [x] airdrops テーブル（エアドロップ）
  - [x] commissions テーブル（手数料）
- [x] キャッシュ・集計テーブル作成
  - [x] daily_balances テーブル（日次残高）
  - [x] dm_crypts テーブル（通貨別年間集計）
  - [x] dm_accounts テーブル（アカウント別年間集計）
- [x] 連携テーブル作成
  - [x] price_alerts テーブル（価格アラート）
  - [x] zaim_credentials テーブル（Zaim認証）
  - [x] zaim_accounts テーブル（Zaimアカウント）

### Row Level Security (RLS)
- [x] マスタテーブルRLS設定（crypts, prices: 読み取り専用）
- [x] ユーザーテーブルRLS設定（accounts, addresses, crypt_categories, user_crypt_categories）
- [x] 取引テーブルRLS設定（purchases, sells, transfers, airdrops, commissions）
- [x] キャッシュテーブルRLS設定（daily_balances, dm_crypts, dm_accounts）
- [x] 連携テーブルRLS設定（price_alerts, zaim_credentials, zaim_accounts）

### Flutter プロジェクト初期化
- [x] Flutter プロジェクト作成（Web/iOS/Android対応）
- [x] pubspec.yaml 依存関係追加
  - [x] supabase_flutter
  - [x] flutter_riverpod / riverpod_annotation
  - [x] go_router
  - [x] fl_chart
  - [x] data_table_2
  - [x] intl
  - [x] freezed_annotation / json_annotation
  - [x] flutter_dotenv（環境変数管理）
  - [ ] firebase_messaging / flutter_local_notifications（Phase 6で実装）
- [x] ディレクトリ構成作成
  - [x] lib/core/（constants, extensions, utils, theme）
  - [x] lib/features/（auth, portfolio, transactions, analysis, settings, notifications）
  - [x] lib/shared/（widgets, models, services）
  - [x] lib/l10n/（多言語ファイル）
- [x] Supabase初期化設定（main.dart）

### 認証機能
- [x] 認証サービス作成（Supabase Auth）
- [x] ログイン画面実装
- [x] 新規登録画面実装
- [x] パスワードリセット画面実装
- [x] 認証状態管理（Riverpod Provider）
- [x] 認証済みルーティング設定（go_router）

### 多言語対応
- [x] flutter_localizations 設定
- [x] app_ja.arb 作成（日本語）
- [x] app_en.arb 作成（英語）
- [x] 言語切り替え機能

### テーマ・UI基盤
- [x] Material Design 3 テーマ設定
- [x] 共通ウィジェット作成（MainShell, ナビゲーションバー）
- [x] レスポンシブレイアウト基盤

---

## Phase 2: 価格データ取得 ✅

### CoinGecko API連携
- [x] CoinGecko API調査
  - [x] API エンドポイント確認
  - [x] レート制限確認
  - [x] 必要なAPIキー取得（必要な場合）
- [x] 対象暗号通貨リスト定義

### cryptsテーブルマスタ登録
- [x] 初期暗号通貨データ作成（symbol, project_name, coingecko_id）
- [x] マスタ登録用SQL作成・実行
- [x] アイコンURL、カラー設定

### Edge Function: update-prices
- [x] Supabase Edge Functions環境セットアップ
- [x] update-prices 関数作成
  - [x] cryptsテーブルからcoingecko_id取得
  - [x] CoinGecko API呼び出し（日本円価格取得）
  - [x] pricesテーブルへUPSERT
  - [x] エラーハンドリング
  - [x] ログ出力
- [x] ローカルテスト（リモートテスト実施）
- [x] デプロイ

### Cronスケジューリング
- [x] Supabase pg_cron マイグレーション作成
- [x] update-prices を1時間ごとに実行設定（Dashboardから設定可能）
- [x] 実行ログ確認（Dashboardから確認可能）

### 動作確認
- [x] 価格データ取得テスト（11/12通貨成功）
- [x] pricesテーブルデータ確認
- [x] エラー時のリトライ確認（必要に応じて）

---

## Phase 2.5: 設計レビュー・仕様確定 ✅

**CRITICAL**: Phase 3開始前に以下を完了させ、実装の手戻りを防ぐ

### 取引台帳モデルの設計レビュー
- [x] 取引テーブルの関係性レビュー
  - [x] スワップ（2取引同時作成）の整合性確認
  - [x] 振替の記帳方法確認
  - [x] 手数料の取引紐付け方法確認
- [x] 二重記帳モデルの必要性検討
- [x] 会計ロジックの整合性確認
  - [x] 加重平均法による平均取得単価計算ロジック
  - [x] 確定損益（実現損益）計算ロジック
  - [x] 評価損益（含み損益）計算ロジック
- [x] Codex経由で会計ロジック相談・レビュー

### 評価時点・遡及修正ポリシーの決定
- [x] 評価時点の仕様確定
  - [x] 「どの時点の価格で評価するか」決定（日次終値 or リアルタイム価格）
  - [x] 評価額計算タイミング（リアルタイム or バッチ）
- [x] 遡及修正ポリシーの決定
  - [x] 過去取引を修正した場合の挙動定義
  - [x] 残高履歴の再計算範囲決定
  - [x] 損益の再計算範囲決定
  - [x] データマート（dm_crypts, dm_accounts）の更新方法
- [x] 仕様書作成・合意形成

### Edge Functions設計書作成
- [x] 各Edge Functionの責務明確化
  - [x] update-prices（価格更新）
  - [x] update-daily-balances（日次残高スナップショット）
  - [x] calculate-indicators（テクニカル指標計算）
  - [x] update-data-marts（データマート更新）
  - [x] check-price-alerts（価格アラートチェック）
  - [x] sync-zaim（Zaim連携）
- [x] 冪等性設計
  - [x] 重複実行時の挙動定義
  - [x] ロック機構設計（pg_advisory_lock）
  - [x] バージョン管理・水位管理（最終実行時刻記録）
- [x] 再実行戦略
  - [x] 失敗時のリトライポリシー
  - [x] エラーアラート設計
  - [x] ロールバック戦略
- [x] トランザクション境界の明確化
- [x] Cronスケジュール最終確認
  - [x] 実行頻度・実行順序の依存関係確認
  - [x] 実行時間の重複・衝突チェック

### データ整合性確認
- [x] RLSポリシーの再確認
- [x] トリガー・制約の必要性検討
- [x] インデックス設計レビュー
- [x] バックアップ・リストア戦略

### スキーマ改善実装
- [x] cost_basis_history テーブル作成（履歴追跡）
- [x] swaps テーブル作成（スワップ取引リンク）
- [x] job_runs テーブル作成（冪等性管理）
- [x] 監査列追加（version, source, external_tx_id, deleted_at）
- [x] CHECK制約追加（数量・単価の妥当性チェック）
- [x] FK制約・UNIQUE制約追加（データ整合性）
- [x] airdropsテーブル統合（purchasesに集約、二重計上防止）
- [x] RLSポリシー追加（新規テーブル）
- [x] 設計ドキュメント更新（DESIGN.md）
- [x] マイグレーション適用（supabase db push）
- [x] 制約追加（CHECK制約、FK制約、UNIQUE制約）
- [x] airdropsテーブル統合（purchasesテーブルに集約）

---

## Phase 3: コア機能

### アカウント管理
- [x] Account モデル作成（Freezed）
- [x] AccountRepository 作成
- [x] AccountProvider 作成（Riverpod）
- [x] アカウント一覧画面
- [x] アカウント追加画面
- [x] アカウント編集画面
- [x] アカウント削除機能
- [x] アカウントロック機能
- [x] ウォレットアドレス管理
  - [x] Address モデル
  - [x] アドレス追加・編集・削除

### 取引管理 - 入金（Deposit）
- [x] Purchase モデル作成
- [x] PurchaseRepository 作成
- [x] CryptRepository 作成
- [x] PurchaseProvider 作成（Riverpod）
- [x] 入金登録画面
  - [x] 実行日時入力
  - [x] アカウント選択
  - [x] 通貨選択
  - [x] 単価・数量・入金額入力（自動計算）
  - [x] 手数料入力
- [x] 入金一覧表示
  - [x] フィルター機能（口座・暗号資産）
  - [x] ソート機能（実行日・数量・入金額）
  - [x] Pull to refresh
- [x] 入金編集・削除
- [x] ルーティング追加（/transactions/deposits）

### 取引管理 - 売却（Sell）
- [x] Sell モデル作成
- [x] SellRepository 作成（WAC計算実装済み）
- [x] 売却登録画面
- [x] 加重平均法による損益自動計算（createSell内で実装済み）
- [x] 売却一覧表示（損益色分け、フィルター、ソート）
- [x] 売却編集・削除
- [x] ルーティング追加（/transactions/sells）

### 取引管理 - スワップ（Swap）
- [ ] スワップ登録画面
- [ ] 売却側・購入側の両取引自動作成
- [ ] 売却側損益自動計算
- [ ] スワップ一覧表示

### 取引管理 - 振替（Transfer）
- [ ] Transfer モデル作成
- [ ] TransferRepository 作成
- [ ] 振替登録画面
- [ ] 振替手数料記録
- [ ] 振替一覧表示

### 取引管理 - エアドロップ（Airdrop）
- [ ] Airdrop モデル作成
- [ ] AirdropRepository 作成
- [ ] エアドロップ登録画面（タイプ選択: airdrop/staking）
- [ ] 受取時時価記録
- [ ] エアドロップ一覧表示

### 取引管理 - 手数料（Commission）
- [ ] Commission モデル作成
- [ ] CommissionRepository 作成
- [ ] 手数料の取引紐付け

### ポートフォリオ表示
- [ ] ポートフォリオ概要画面
- [ ] アカウント別保有状況
- [ ] 通貨別保有状況
- [ ] 現在価格表示（pricesテーブル参照）
- [ ] 評価額計算・表示

### カテゴリ管理
- [ ] CryptCategory モデル作成
- [ ] カテゴリ一覧画面
- [ ] カテゴリ追加・編集・削除
- [ ] 暗号通貨へのカテゴリ紐付け

---

## Phase 4: 分析・レポート

### 残高履歴
- [ ] Edge Function: update-daily-balances 作成
- [ ] 日次残高スナップショット保存
- [ ] 残高推移チャート表示（fl_chart）

### 損益計算
- [ ] 加重平均法による平均取得単価計算
- [ ] 確定損益計算（売却時実現損益）
- [ ] 評価損益計算（含み損益）
- [ ] 損益レポート画面

### 税務報告
- [ ] 年度別確定損益集計
- [ ] 入金総額・売却総額・手数料総額表示
- [ ] Edge Function: update-data-marts 作成
- [ ] dm_crypts, dm_accounts 更新処理

### テクニカル分析
- [ ] Edge Function: calculate-indicators 作成
  - [ ] MACD計算（MACDライン、シグナルライン、ヒストグラム）
  - [ ] RSI計算
  - [ ] ボリンジャーバンド計算（上限、中央、下限）
- [ ] pricesテーブル更新

### チャート表示
- [ ] 価格チャート画面
- [ ] ローソク足チャート実装
- [ ] MACD表示
- [ ] RSI表示
- [ ] ボリンジャーバンド表示

---

## Phase 5: 外部連携

### Zaim連携
- [ ] Zaim API調査
- [ ] OAuth1認証フロー実装
- [ ] zaim_credentials 保存処理
- [ ] Zaimアカウント取得・保存
- [ ] Edge Function: sync-zaim 作成
  - [ ] 暗号資産評価額合計算出
  - [ ] Zaimアカウント残高更新
  - [ ] 差分を収入/支出として記録
- [ ] Zaim連携設定画面

### その他Edge Functions
- [ ] 全Edge Functionsのデプロイ確認
- [ ] Cronスケジュール設定
  - [ ] update-prices: 1時間ごと
  - [ ] calculate-indicators: 1日1回
  - [ ] update-daily-balances: 1日1回
  - [ ] update-data-marts: 1日1回
  - [ ] sync-zaim: 1日1回（または手動）

---

## Phase 6: 通知・最終調整

### プッシュ通知
- [ ] Firebase Cloud Messaging セットアップ
- [ ] flutter_local_notifications 設定
- [ ] デバイストークン登録処理
- [ ] 通知受信処理

### 価格アラート
- [ ] price_alerts 管理画面
- [ ] アラート設定（通貨、条件、価格）
- [ ] Edge Function: check-price-alerts 作成
  - [ ] 閾値チェック（5分ごと）
  - [ ] プッシュ通知送信
  - [ ] triggered_at 更新

### 設定画面
- [ ] アカウント管理リンク（Phase 3で実装）
- [ ] カテゴリ管理リンク（Phase 3で実装）
- [ ] Zaim連携設定（Phase 5で実装）
- [ ] 通知設定
- [x] 言語設定

### テスト・最終調整
- [ ] 単体テスト作成
- [ ] 統合テスト
- [ ] Web版動作確認
- [ ] iOS版ビルド・動作確認
- [ ] Android版ビルド・動作確認
- [ ] パフォーマンス最適化
- [ ] バグ修正

---

## 補足

### 技術スタック
- **Frontend**: Flutter 3.x
- **Backend**: Supabase (PostgreSQL, Auth, Edge Functions, Realtime)
- **状態管理**: Riverpod
- **ルーティング**: go_router
- **チャート**: fl_chart
- **通知**: Firebase Cloud Messaging

### 除外機能
- 投資目的（Objective）管理
- NFT管理
- リバランス自動実行
- 取引所API連携（Bybit, Bitget, GMO Coin, Hyperliquid）
- OpenSea連携
- Slack通知
- Notion連携
- Solana/Anchor関連
