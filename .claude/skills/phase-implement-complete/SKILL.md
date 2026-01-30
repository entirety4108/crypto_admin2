---
name: phase-implement-complete
description: 指定フェーズのすべての未完了タスクを完了（チェック）として TODO.md を更新
argument-hint: "[phase-name]"
allowed-tools: Read, Edit, Bash(*)
disable-model-invocation: true
---

# Phase Implement Complete スキル

## 概要

実装完了後に `TODO.md` の指定フェーズのチェックボックスを自動的に更新するスキルです。

## 使用方法

```bash
/phase-implement-complete Phase 2
/phase-implement-complete Phase 3
```

## 実行処理

### ステップ1: 対象フェーズの確認

1. `TODO.md` から指定フェーズ `$0` を検索
2. フェーズに含まれるすべてのタスクを特定
3. 現在の完了状態を表示

### ステップ2: バックアップ作成

1. `TODO.md.bak` にバックアップを作成
2. 更新前の状態を保持

### ステップ3: チェックボックスの更新

1. 指定フェーズ内のすべての `- [ ]` を `- [x]` に更新
2. サブタスクも含めて更新
3. 次のフェーズが現れたら処理を終了

### ステップ4: ファイルの保存と確認

1. 更新内容をログ出力
2. 変更前後の差分を表示
3. Git での確認コマンドを提示

## 実装例

```markdown
## Phase 2: 価格データ取得 （チェック前）

### CoinGecko API連携
- [ ] CoinGecko API調査
  - [ ] API エンドポイント確認
  - [ ] レート制限確認
  - [ ] 必要なAPIキー取得（必要な場合）
- [ ] 対象暗号通貨リスト定義

↓ スキル実行後 ↓

## Phase 2: 価格データ取得 （チェック後）

### CoinGecko API連携
- [x] CoinGecko API調査
  - [x] API エンドポイント確認
  - [x] レート制限確認
  - [x] 必要なAPIキー取得（必要な場合）
- [x] 対象暗号通貨リスト定義
```

## 実装手順

以下の手順で `TODO.md` を更新してください：

### 1. 対象フェーズのタスクをすべて確認

```bash
/phase-implement Phase 2
```

このコマンドでタスク一覧を表示。

### 2. 各タスクを実装

個別にタスクを実装してください。

### 3. 実装完了を確認

すべてのタスクが実装できたことを確認。

### 4. チェックボックスを自動更新

```bash
/phase-implement-complete Phase 2
```

このスキルを実行すると、自動的に以下が行われます：

- ✅ `TODO.md` の該当フェーズのすべてのチェックボックスを更新
- ✅ バックアップファイル `TODO.md.bak` を作成
- ✅ 変更前後の差分を表示
- ✅ Git でのコミットコマンドを提示

### 5. 変更をコミット

```bash
git add TODO.md
git commit -m "Phase X を完了"
```

## 確認コマンド

更新後、以下で変更内容を確認：

```bash
# 差分確認
git diff TODO.md

# Git ログ確認
git log --oneline -5
```

## トラブルシューティング

### ✅ 完了したはずなのに、一部タスクが残っている

→ サブタスク（インデント付き）も含めてチェックされています。
　 インデント階層に注意してください。

### ✅ 誤って更新してしまった

→ バックアップから復元：

```bash
cp TODO.md.bak TODO.md
```

### ✅ 一部のタスクだけ更新したい

→ このスキルはフェーズ全体を更新します。
　 部分的な更新が必要な場合は、手動で `TODO.md` を編集してください。

## 関連スキル

- `/phase-implement Phase X` - フェーズのタスク一覧表示と実装指示
- `/phase-implement-complete Phase X` - チェックボックスの自動更新（このスキル）
