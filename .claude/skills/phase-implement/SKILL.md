---
name: phase-implement
description: crypto_admin2のTODO.mdで指定したフェーズを実装し、完了時にチェックボックスをマーク
argument-hint: '[phase-name]'
allowed-tools: Read, Edit, Bash(*)
disable-model-invocation: true
---

# Phase Implement スキル

## 概要

`TODO.md` から指定フェーズのタスク一覧を取得し、実装を支援します。実装完了後にチェックボックスを自動更新します。

## 使用方法

```bash
/phase-implement Phase 2
/phase-implement Phase 3
/phase-implement "Phase 4"
```

## 実行フロー

### ステップ1: フェーズのタスク一覧を表示

1. `TODO.md` を読込み
2. 指定フェーズ `$0` のセクションを抽出
3. タスク一覧を見やすく表示（完了/未完了を区別）
4. サブタスク階層を明確に表示

### ステップ2: 実装指示

フェーズの説明に基づき、以下を実行：

1. **フェーズの目的を確認** - 「このフェーズの目的は何か」を理解
2. **個別タスクを実装** - 各タスクを順序立てて実装
3. **実装ガイダンス**
   - `CLAUDE.md` の詳細仕様に基づく
   - `lib/` ディレクトリ構造に従う
   - Dart/Flutter ベストプラクティスに従う
4. **テスト・検証** - コマンド実行やビルド確認など

### ステップ3: チェックボックスの自動更新

実装完了後：

```
実装が完了しました。以下を実行して TODO.md を更新してください：

/phase-implement-complete Phase X
```

## フェーズの説明

各フェーズの詳細は以下の通り：

### Phase 1: 基盤構築 ✅ (完了)

- Supabase セットアップ
- データベーススキーマ作成
- RLS 設定
- Flutter プロジェクト初期化
- 認証機能実装

### Phase 2: 価格データ取得

- CoinGecko API 連携
- crypts マスタデータ登録
- Edge Function: update-prices 実装
- Cron スケジューリング

### Phase 3: コア機能

- アカウント管理
- 取引管理（入金、売却、スワップ、振替、エアドロップ）
- ポートフォリオ表示

### Phase 4: 分析・レポート

- 残高履歴
- 損益計算
- テクニカル分析
- チャート表示

### Phase 5: 外部連携

- Zaim API 連携
- Edge Functions デプロイ
- Cron スケジューリング

### Phase 6: 通知・最終調整

- Firebase Cloud Messaging
- 価格アラート
- テスト・最終調整

## 詳細実装手順

### 実装開始時

1. フェーズのタスク一覧をすべて確認
2. 優先度順に実装（通常は上から順）
3. 完了したタスクは逐次チェック

### 実装中

- コードは `lib/features/` の適切なディレクトリに配置
- モデルは Freezed を使用
- 状態管理は Riverpod を使用
- Supabase との連携は `supabase` パッケージを使用

### 実装完了時

```
## ✅ $0 実装完了

実装内容：
- タスク1: 詳細
- タスク2: 詳細
- ...

確認方法：
- ビルド成功: `flutter pub get && flutter analyze`
- テスト実行: `flutter test`

Todo.md を更新するには、以下を実行：

/phase-implement-complete $0
```

## 補助スキル

実装後は以下のコマンドで自動更新：

```bash
/phase-implement-complete Phase 2
```

このコマンドが `TODO.md` のチェックボックスを自動的に更新します。
