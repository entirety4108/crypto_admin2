# 翻訳キー命名規約（ja/en）

- 形式: `domain.section.item`
- 例
  - `auth.login.title`
  - `auth.login.submit`
  - `transactions.form.sell.amount`
  - `common.error.required`
- 禁止
  - 文言そのものをキーにしない
  - 1階層キー（例: `title`）は使わない
- 変数埋め込み
  - `{count}`, `{name}` のように lowerCamelCase で統一
- 配置
  - `messages/ja.json`, `messages/en.json` で同一キーセットを維持
