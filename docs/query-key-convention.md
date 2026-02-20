# Query Key 命名規約

- 形式: `['scope', ...params]`
- `scope` は画面単位で固定
  - portfolio: `['portfolio', userId]`
  - accounts: `['accounts', userId]`
  - categories: `['categories', userId]`
  - transactions: `['transactions', userId, { type, from, to }]`
- 詳細データは `detail` を挟む
  - `['accounts', userId, 'detail', accountId]`
- 集計系は `summary` を使う
  - `['transactions', userId, 'summary', { month }]`
- 無効化単位
  - 更新後は同一scopeをinvalidate（例: `queryClient.invalidateQueries({ queryKey: ['accounts', userId] })`）
