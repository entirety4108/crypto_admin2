# Crypto Admin

暗号通貨ポートフォリオ管理システム (Flutter + Supabase)

## プロジェクト概要

Laravel+MySQLから**Flutter+Supabase**へ移行した暗号通貨ポートフォリオ管理アプリケーション。

### 対応プラットフォーム
- Web (Flutter Web)
- iOS (Flutter iOS)
- Android (Flutter Android)

### 技術スタック
- **Frontend**: Flutter 3.x
- **Backend**: Supabase (PostgreSQL, Auth, Edge Functions, Realtime)
- **状態管理**: Riverpod
- **ルーティング**: go_router
- **多言語対応**: flutter_localizations (日本語/英語)

---

## セットアップ

### 前提条件
- Flutter SDK 3.10.7以上
- Dart SDK 3.x
- Supabase アカウント

### 1. リポジトリのクローン

```bash
git clone <repository-url>
cd crypto_admin2
```

### 2. 依存関係のインストール

```bash
flutter pub get
```

### 3. 環境変数の設定

`.env.example`をコピーして`.env`ファイルを作成し、Supabase認証情報を設定:

```bash
cp .env.example .env
```

`.env`ファイルを編集:

```env
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

Supabase認証情報は[Supabase Dashboard](https://supabase.com/dashboard)の **Settings > API** から取得できます。

### 4. データベースマイグレーション

Supabaseプロジェクトにマイグレーションを適用:

```bash
supabase db push
```

### 5. アプリの起動

```bash
# Web
flutter run -d chrome

# iOS (macOS環境)
flutter run -d ios

# Android
flutter run -d android
```

---

## 開発状況

### ✅ Phase 1: 基盤構築 (完了)
- [x] Supabaseプロジェクト作成・リンク
- [x] データベーススキーマ作成（全テーブル）
- [x] Row Level Security (RLS) 設定
- [x] Flutterプロジェクト初期化
- [x] 依存関係追加
- [x] ディレクトリ構成作成
- [x] Supabase初期化設定
- [x] 認証機能実装（ログイン・新規登録・パスワードリセット）
- [x] 多言語対応（日本語・英語）
- [x] Material Design 3 テーマ設定

### 🔄 Phase 2: 価格データ取得 (予定)
- [ ] CoinGecko API連携
- [ ] cryptsテーブルマスタ登録
- [ ] Edge Function: update-prices
- [ ] Cronスケジューリング

### 📋 Phase 3: コア機能 (予定)
- [ ] アカウント管理
- [ ] 取引管理（入金・売却・スワップ・振替・エアドロップ）
- [ ] ポートフォリオ表示
- [ ] カテゴリ管理

### 📊 Phase 4: 分析・レポート (予定)
- [ ] 残高履歴
- [ ] 損益計算
- [ ] テクニカル分析
- [ ] チャート表示

### 🔌 Phase 5: 外部連携 (予定)
- [ ] Zaim連携

### 🔔 Phase 6: 通知・最終調整 (予定)
- [ ] プッシュ通知
- [ ] 価格アラート

---

## プロジェクト構成

```
lib/
├── main.dart                 # エントリーポイント
├── app.dart                  # ルートアプリウィジェット
├── core/                     # コア機能
│   ├── constants/            # 定数（環境変数、アプリ定数）
│   ├── extensions/           # 拡張機能
│   ├── utils/                # ユーティリティ
│   ├── theme/                # テーマ設定
│   └── router/               # ルーティング設定
├── features/                 # 機能別モジュール
│   ├── auth/                 # 認証機能
│   ├── portfolio/            # ポートフォリオ
│   ├── transactions/         # 取引管理
│   ├── analysis/             # 分析・レポート
│   ├── settings/             # 設定
│   └── notifications/        # 通知
├── shared/                   # 共通コンポーネント
│   ├── widgets/              # 共通ウィジェット
│   ├── models/               # 共通モデル
│   └── services/             # 共通サービス
└── l10n/                     # 多言語対応ファイル
    ├── app_ja.arb            # 日本語
    └── app_en.arb            # 英語
```

---

## データベース構成

詳細は[CLAUDE.md](CLAUDE.md)を参照してください。

### 主要テーブル
- **crypts**: 暗号通貨マスタ（読み取り専用）
- **prices**: 価格履歴（読み取り専用）
- **accounts**: アカウント（取引所/ウォレット）
- **purchases**: 購入記録
- **sells**: 売却記録
- **transfers**: 振替記録
- **airdrops**: エアドロップ記録
- **commissions**: 手数料記録

---

## コマンド一覧

### Flutter

```bash
# 依存関係の取得
flutter pub get

# ビルドランナー実行（コード生成）
flutter pub run build_runner build --delete-conflicting-outputs

# アプリ起動（Web）
flutter run -d chrome

# アプリ起動（iOS）
flutter run -d ios

# アプリ起動（Android）
flutter run -d android

# テスト実行
flutter test

# ビルド（Web）
flutter build web

# ビルド（iOS）
flutter build ios

# ビルド（Android）
flutter build apk
```

### Supabase

```bash
# プロジェクトステータス確認
supabase status

# マイグレーション適用
supabase db push

# マイグレーション作成
supabase migration new <migration_name>

# Edge Function作成
supabase functions new <function_name>

# Edge Functionデプロイ
supabase functions deploy <function_name>
```

---

## ライセンス

Private

---

## 参考資料

- [CLAUDE.md](CLAUDE.md) - 詳細な仕様書
- [TODO.md](TODO.md) - 実装TODOリスト
- [Supabase Documentation](https://supabase.com/docs)
- [Flutter Documentation](https://docs.flutter.dev/)
