import {
  createCommissionAction,
  createPurchaseAction,
  createSellAction,
  createSwapAction,
  createTransferAction,
  deleteCommissionAction,
  deletePurchaseAction,
  deleteSellAction,
  deleteSwapAction,
  deleteTransferAction,
  updateCommissionAction,
  updatePurchaseAction,
  updateSellAction,
  updateTransferAction,
} from './actions'
import { createClient } from '@/lib/supabase/server'

type SearchParams = Promise<{ type?: string; from?: string; to?: string }>

type Account = { id: string; name: string }
type Crypt = { id: string; symbol: string }
type Commission = {
  id: string
  exec_at: string
  account_id: string
  crypt_id: string
  unit_yen: string
  amount: string
  approximate_yen: string
}
type Purchase = {
  id: string
  exec_at: string
  account_id: string
  crypt_id: string
  unit_yen: string
  amount: string
  deposit_yen: string
  purchase_yen: string
  type: 'd' | 's' | 'a'
  commission_id: string | null
}
type Sell = {
  id: string
  exec_at: string
  account_id: string
  crypt_id: string
  unit_yen: string
  amount: string
  yen: string
  type: 's' | 'w'
  commission_id: string | null
}
type Transfer = {
  id: string
  exec_at: string
  from_account_id: string
  to_account_id: string
  crypt_id: string
  amount: string
  commission_id: string | null
  memo: string | null
}
type Swap = { id: string; buy_tx_id: string; sell_tx_id: string }

function toLocalDateTimeInput(iso: string) {
  const d = new Date(iso)
  const pad = (v: number) => String(v).padStart(2, '0')
  const y = d.getFullYear()
  const m = pad(d.getMonth() + 1)
  const day = pad(d.getDate())
  const h = pad(d.getHours())
  const min = pad(d.getMinutes())
  return `${y}-${m}-${day}T${h}:${min}`
}

function defaultNowInput() {
  return toLocalDateTimeInput(new Date().toISOString())
}

export default async function TransactionsPage({
  params,
  searchParams,
}: {
  params: Promise<{ locale: string }>
  searchParams: SearchParams
}) {
  const { locale } = await params
  const filters = await searchParams
  const txType = filters.type ?? 'all'

  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return <p className="text-sm text-red-600">ログインが必要です。</p>

  const from = filters.from ? new Date(`${filters.from}T00:00:00+09:00`).toISOString() : null
  const to = filters.to ? new Date(`${filters.to}T23:59:59+09:00`).toISOString() : null

  const purchasesQuery = supabase
    .from('purchases')
    .select('id,exec_at,account_id,crypt_id,unit_yen,amount,deposit_yen,purchase_yen,type,commission_id')
    .order('exec_at', { ascending: false })
  const sellsQuery = supabase
    .from('sells')
    .select('id,exec_at,account_id,crypt_id,unit_yen,amount,yen,type,commission_id')
    .order('exec_at', { ascending: false })
  const transfersQuery = supabase
    .from('transfers')
    .select('id,exec_at,from_account_id,to_account_id,crypt_id,amount,commission_id,memo')
    .order('exec_at', { ascending: false })

  if (from) {
    purchasesQuery.gte('exec_at', from)
    sellsQuery.gte('exec_at', from)
    transfersQuery.gte('exec_at', from)
  }
  if (to) {
    purchasesQuery.lte('exec_at', to)
    sellsQuery.lte('exec_at', to)
    transfersQuery.lte('exec_at', to)
  }

  const [accountsRes, cryptsRes, commissionsRes, purchasesRes, sellsRes, transfersRes, swapsRes] = await Promise.all([
    supabase.from('accounts').select('id,name').order('name'),
    supabase.from('crypts').select('id,symbol').eq('is_active', true).order('symbol'),
    supabase
      .from('commissions')
      .select('id,exec_at,account_id,crypt_id,unit_yen,amount,approximate_yen')
      .order('exec_at', { ascending: false }),
    purchasesQuery,
    sellsQuery,
    transfersQuery,
    supabase.from('swaps').select('id,buy_tx_id,sell_tx_id').order('created_at', { ascending: false }),
  ])

  const error =
    accountsRes.error ||
    cryptsRes.error ||
    commissionsRes.error ||
    purchasesRes.error ||
    sellsRes.error ||
    transfersRes.error ||
    swapsRes.error

  if (error) return <p className="text-sm text-red-600">{error.message}</p>

  const accounts = (accountsRes.data ?? []) as Account[]
  const crypts = (cryptsRes.data ?? []) as Crypt[]
  const commissions = (commissionsRes.data ?? []) as Commission[]
  const purchases = (purchasesRes.data ?? []) as Purchase[]
  const sells = (sellsRes.data ?? []) as Sell[]
  const transfers = (transfersRes.data ?? []) as Transfer[]
  const swaps = (swapsRes.data ?? []) as Swap[]

  const accountMap = new Map(accounts.map((v) => [v.id, v.name]))
  const cryptMap = new Map(crypts.map((v) => [v.id, v.symbol]))
  const swapBuySet = new Set(swaps.map((s) => s.buy_tx_id))
  const swapSellSet = new Set(swaps.map((s) => s.sell_tx_id))

  const filteredPurchases = purchases.filter((p) => {
    if (txType === 'all') return true
    if (txType === 'deposit') return p.type === 'd'
    if (txType === 'airdrop') return p.type === 'a'
    if (txType === 'swap') return p.type === 's' || swapBuySet.has(p.id)
    return false
  })
  const filteredSells = sells.filter((s) => {
    if (txType === 'all') return true
    if (txType === 'sell') return s.type === 's'
    if (txType === 'swap') return s.type === 'w' || swapSellSet.has(s.id)
    return false
  })
  const filteredTransfers = transfers.filter(() => txType === 'all' || txType === 'transfer')

  const defaultExecAt = defaultNowInput()

  return (
    <section className="space-y-8">
      <div>
        <h2 className="text-xl font-semibold">Transactions</h2>
        <p className="text-sm text-slate-600">取引の登録・編集・削除、手数料の紐付けに対応しています。</p>
      </div>

      <form className="grid gap-3 rounded-lg border p-4 md:grid-cols-4" method="get">
        <select name="type" defaultValue={txType} className="rounded border px-3 py-2">
          <option value="all">全種別</option>
          <option value="deposit">入金</option>
          <option value="sell">売却</option>
          <option value="swap">スワップ</option>
          <option value="transfer">振替</option>
          <option value="airdrop">エアドロップ</option>
        </select>
        <input type="date" name="from" defaultValue={filters.from ?? ''} className="rounded border px-3 py-2" />
        <input type="date" name="to" defaultValue={filters.to ?? ''} className="rounded border px-3 py-2" />
        <button className="rounded border px-3 py-2 text-sm" type="submit">
          フィルタ適用
        </button>
      </form>

      <div className="grid gap-4 lg:grid-cols-2">
        <form action={createCommissionAction} className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">手数料追加</h3>
          <input type="hidden" name="locale" value={locale} />
          <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="w-full rounded border px-3 py-2" required />
          <select name="account_id" className="w-full rounded border px-3 py-2" required>
            <option value="">アカウント</option>
            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
          </select>
          <select name="crypt_id" className="w-full rounded border px-3 py-2" required>
            <option value="">通貨</option>
            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
          </select>
          <input name="unit_yen" type="number" step="0.00000001" min="0" placeholder="単価(JPY)" className="w-full rounded border px-3 py-2" required />
          <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="w-full rounded border px-3 py-2" required />
          <input name="approximate_yen" type="number" step="0.01" min="0" placeholder="概算JPY" className="w-full rounded border px-3 py-2" required />
          <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">追加</button>
        </form>

        <form action={createPurchaseAction} className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">入金 / エアドロップ追加</h3>
          <input type="hidden" name="locale" value={locale} />
          <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="w-full rounded border px-3 py-2" required />
          <select name="type" className="w-full rounded border px-3 py-2" defaultValue="d">
            <option value="d">入金</option>
            <option value="a">エアドロップ</option>
          </select>
          <select name="account_id" className="w-full rounded border px-3 py-2" required>
            <option value="">アカウント</option>
            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
          </select>
          <select name="crypt_id" className="w-full rounded border px-3 py-2" required>
            <option value="">通貨</option>
            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
          </select>
          <input name="unit_yen" type="number" step="0.00000001" min="0" placeholder="単価(JPY)" className="w-full rounded border px-3 py-2" required />
          <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="w-full rounded border px-3 py-2" required />
          <input name="deposit_yen" type="number" step="0.01" min="0" placeholder="入金JPY" className="w-full rounded border px-3 py-2" defaultValue="0" />
          <input name="purchase_yen" type="number" step="0.01" min="0" placeholder="取得JPY" className="w-full rounded border px-3 py-2" required />
          <select name="commission_id" className="w-full rounded border px-3 py-2" defaultValue="">
            <option value="">手数料なし</option>
            {commissions.map((c) => <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>)}
          </select>
          <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">追加</button>
        </form>

        <form action={createSellAction} className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">売却追加</h3>
          <input type="hidden" name="locale" value={locale} />
          <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="w-full rounded border px-3 py-2" required />
          <select name="account_id" className="w-full rounded border px-3 py-2" required>
            <option value="">アカウント</option>
            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
          </select>
          <select name="crypt_id" className="w-full rounded border px-3 py-2" required>
            <option value="">通貨</option>
            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
          </select>
          <input name="unit_yen" type="number" step="0.00000001" min="0" placeholder="単価(JPY)" className="w-full rounded border px-3 py-2" required />
          <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="w-full rounded border px-3 py-2" required />
          <input name="yen" type="number" step="0.01" min="0" placeholder="売却JPY" className="w-full rounded border px-3 py-2" required />
          <select name="commission_id" className="w-full rounded border px-3 py-2" defaultValue="">
            <option value="">手数料なし</option>
            {commissions.map((c) => <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>)}
          </select>
          <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">追加</button>
        </form>

        <form action={createTransferAction} className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">振替追加</h3>
          <input type="hidden" name="locale" value={locale} />
          <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="w-full rounded border px-3 py-2" required />
          <select name="from_account_id" className="w-full rounded border px-3 py-2" required>
            <option value="">振替元アカウント</option>
            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
          </select>
          <select name="to_account_id" className="w-full rounded border px-3 py-2" required>
            <option value="">振替先アカウント</option>
            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
          </select>
          <select name="crypt_id" className="w-full rounded border px-3 py-2" required>
            <option value="">通貨</option>
            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
          </select>
          <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="w-full rounded border px-3 py-2" required />
          <select name="commission_id" className="w-full rounded border px-3 py-2" defaultValue="">
            <option value="">手数料なし</option>
            {commissions.map((c) => <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>)}
          </select>
          <input name="memo" placeholder="メモ" className="w-full rounded border px-3 py-2" />
          <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">追加</button>
        </form>
      </div>

      <form action={createSwapAction} className="space-y-2 rounded-lg border p-4">
        <h3 className="font-medium">スワップ追加（売り + 買い + swaps連携）</h3>
        <input type="hidden" name="locale" value={locale} />
        <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="w-full rounded border px-3 py-2" required />
        <div className="grid gap-2 md:grid-cols-2">
          <div className="space-y-2 rounded border p-3">
            <p className="text-sm font-medium">売り側</p>
            <select name="sell_account_id" className="w-full rounded border px-3 py-2" required>
              <option value="">売りアカウント</option>
              {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
            </select>
            <select name="sell_crypt_id" className="w-full rounded border px-3 py-2" required>
              <option value="">売り通貨</option>
              {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
            </select>
            <input name="sell_unit_yen" type="number" step="0.00000001" min="0" placeholder="売り単価(JPY)" className="w-full rounded border px-3 py-2" required />
            <input name="sell_amount" type="number" step="0.00000001" min="0.00000001" placeholder="売り数量" className="w-full rounded border px-3 py-2" required />
            <input name="sell_yen" type="number" step="0.01" min="0" placeholder="売却JPY" className="w-full rounded border px-3 py-2" required />
          </div>
          <div className="space-y-2 rounded border p-3">
            <p className="text-sm font-medium">買い側</p>
            <select name="buy_account_id" className="w-full rounded border px-3 py-2" required>
              <option value="">買いアカウント</option>
              {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
            </select>
            <select name="buy_crypt_id" className="w-full rounded border px-3 py-2" required>
              <option value="">買い通貨</option>
              {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
            </select>
            <input name="buy_unit_yen" type="number" step="0.00000001" min="0" placeholder="買い単価(JPY)" className="w-full rounded border px-3 py-2" required />
            <input name="buy_amount" type="number" step="0.00000001" min="0.00000001" placeholder="買い数量" className="w-full rounded border px-3 py-2" required />
            <input name="buy_deposit_yen" type="number" step="0.01" min="0" placeholder="入金JPY" defaultValue="0" className="w-full rounded border px-3 py-2" />
            <input name="buy_purchase_yen" type="number" step="0.01" min="0" placeholder="取得JPY" className="w-full rounded border px-3 py-2" required />
          </div>
        </div>
        <select name="commission_id" className="w-full rounded border px-3 py-2" defaultValue="">
          <option value="">手数料なし</option>
          {commissions.map((c) => <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>)}
        </select>
        <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">追加</button>
      </form>

      <div className="space-y-4">
        <h3 className="font-medium">手数料一覧（編集/削除）</h3>
        {commissions.map((commission) => (
          <form key={commission.id} action={updateCommissionAction} className="grid gap-2 rounded border p-3 md:grid-cols-4">
            <input type="hidden" name="locale" value={locale} />
            <input type="hidden" name="id" value={commission.id} />
            <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(commission.exec_at)} className="rounded border px-3 py-2" required />
            <select name="account_id" defaultValue={commission.account_id} className="rounded border px-3 py-2" required>
              {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
            </select>
            <select name="crypt_id" defaultValue={commission.crypt_id} className="rounded border px-3 py-2" required>
              {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
            </select>
            <input name="unit_yen" defaultValue={commission.unit_yen} type="number" step="0.00000001" min="0" className="rounded border px-3 py-2" required />
            <input name="amount" defaultValue={commission.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border px-3 py-2" required />
            <input name="approximate_yen" defaultValue={commission.approximate_yen} type="number" step="0.01" min="0" className="rounded border px-3 py-2" required />
            <div className="flex gap-2">
              <button className="rounded border px-3 py-2 text-sm" type="submit">更新</button>
              <button formAction={deleteCommissionAction} className="rounded border border-red-300 px-3 py-2 text-sm text-red-700" type="submit">削除</button>
            </div>
          </form>
        ))}
      </div>

      <div className="space-y-4">
        <h3 className="font-medium">取引一覧（編集/削除）</h3>

        {filteredPurchases.map((tx) => (
          <form key={tx.id} action={updatePurchaseAction} className="grid gap-2 rounded border p-3 md:grid-cols-4">
            <input type="hidden" name="locale" value={locale} />
            <input type="hidden" name="id" value={tx.id} />
            <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(tx.exec_at)} className="rounded border px-3 py-2" required />
            <select name="type" defaultValue={tx.type} className="rounded border px-3 py-2">
              <option value="d">入金</option>
              <option value="a">エアドロップ</option>
              <option value="s">スワップ買い</option>
            </select>
            <select name="account_id" defaultValue={tx.account_id} className="rounded border px-3 py-2" required>
              {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
            </select>
            <select name="crypt_id" defaultValue={tx.crypt_id} className="rounded border px-3 py-2" required>
              {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
            </select>
            <input name="unit_yen" defaultValue={tx.unit_yen} type="number" step="0.00000001" min="0" className="rounded border px-3 py-2" required />
            <input name="amount" defaultValue={tx.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border px-3 py-2" required />
            <input name="deposit_yen" defaultValue={tx.deposit_yen} type="number" step="0.01" min="0" className="rounded border px-3 py-2" required />
            <input name="purchase_yen" defaultValue={tx.purchase_yen} type="number" step="0.01" min="0" className="rounded border px-3 py-2" required />
            <select name="commission_id" defaultValue={tx.commission_id ?? ''} className="rounded border px-3 py-2">
              <option value="">手数料なし</option>
              {commissions.map((c) => <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>)}
            </select>
            <p className="text-xs text-slate-600">{tx.type === 'a' ? 'エアドロップ' : tx.type === 's' ? 'スワップ買い' : '入金'} / {cryptMap.get(tx.crypt_id)}</p>
            <div className="flex gap-2">
              <button className="rounded border px-3 py-2 text-sm" type="submit">更新</button>
              <button formAction={deletePurchaseAction} className="rounded border border-red-300 px-3 py-2 text-sm text-red-700" type="submit">削除</button>
            </div>
          </form>
        ))}

        {filteredSells.map((tx) => (
          <form key={tx.id} action={updateSellAction} className="grid gap-2 rounded border p-3 md:grid-cols-4">
            <input type="hidden" name="locale" value={locale} />
            <input type="hidden" name="id" value={tx.id} />
            <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(tx.exec_at)} className="rounded border px-3 py-2" required />
            <select name="account_id" defaultValue={tx.account_id} className="rounded border px-3 py-2" required>
              {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
            </select>
            <select name="crypt_id" defaultValue={tx.crypt_id} className="rounded border px-3 py-2" required>
              {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
            </select>
            <input name="unit_yen" defaultValue={tx.unit_yen} type="number" step="0.00000001" min="0" className="rounded border px-3 py-2" required />
            <input name="amount" defaultValue={tx.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border px-3 py-2" required />
            <input name="yen" defaultValue={tx.yen} type="number" step="0.01" min="0" className="rounded border px-3 py-2" required />
            <select name="commission_id" defaultValue={tx.commission_id ?? ''} className="rounded border px-3 py-2">
              <option value="">手数料なし</option>
              {commissions.map((c) => <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>)}
            </select>
            <p className="text-xs text-slate-600">{tx.type === 'w' ? 'スワップ売り' : '売却'} / {cryptMap.get(tx.crypt_id)}</p>
            <div className="flex gap-2">
              <button className="rounded border px-3 py-2 text-sm" type="submit">更新</button>
              <button formAction={deleteSellAction} className="rounded border border-red-300 px-3 py-2 text-sm text-red-700" type="submit">削除</button>
            </div>
          </form>
        ))}

        {filteredTransfers.map((tx) => (
          <form key={tx.id} action={updateTransferAction} className="grid gap-2 rounded border p-3 md:grid-cols-4">
            <input type="hidden" name="locale" value={locale} />
            <input type="hidden" name="id" value={tx.id} />
            <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(tx.exec_at)} className="rounded border px-3 py-2" required />
            <select name="from_account_id" defaultValue={tx.from_account_id} className="rounded border px-3 py-2" required>
              {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
            </select>
            <select name="to_account_id" defaultValue={tx.to_account_id} className="rounded border px-3 py-2" required>
              {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
            </select>
            <select name="crypt_id" defaultValue={tx.crypt_id} className="rounded border px-3 py-2" required>
              {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
            </select>
            <input name="amount" defaultValue={tx.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border px-3 py-2" required />
            <select name="commission_id" defaultValue={tx.commission_id ?? ''} className="rounded border px-3 py-2">
              <option value="">手数料なし</option>
              {commissions.map((c) => <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>)}
            </select>
            <input name="memo" defaultValue={tx.memo ?? ''} className="rounded border px-3 py-2" placeholder="メモ" />
            <p className="text-xs text-slate-600">{accountMap.get(tx.from_account_id)} → {accountMap.get(tx.to_account_id)} / {cryptMap.get(tx.crypt_id)}</p>
            <div className="flex gap-2">
              <button className="rounded border px-3 py-2 text-sm" type="submit">更新</button>
              <button formAction={deleteTransferAction} className="rounded border border-red-300 px-3 py-2 text-sm text-red-700" type="submit">削除</button>
            </div>
          </form>
        ))}

        <div className="space-y-2">
          <h4 className="text-sm font-medium">スワップ連携（削除）</h4>
          {swaps.map((s) => (
            <form key={s.id} action={deleteSwapAction} className="flex items-center gap-2 rounded border px-3 py-2 text-sm">
              <input type="hidden" name="locale" value={locale} />
              <input type="hidden" name="swap_id" value={s.id} />
              <input type="hidden" name="buy_tx_id" value={s.buy_tx_id} />
              <input type="hidden" name="sell_tx_id" value={s.sell_tx_id} />
              <span>buy: {s.buy_tx_id.slice(0, 8)} / sell: {s.sell_tx_id.slice(0, 8)}</span>
              <button className="rounded border border-red-300 px-2 py-1 text-red-700" type="submit">スワップ一括削除</button>
            </form>
          ))}
        </div>
      </div>
    </section>
  )
}
