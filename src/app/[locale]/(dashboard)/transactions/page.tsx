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
import { Table, TableHeader, TableBody, TableRow, TableHead, TableCell } from '@/components/ui/table'

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
  const txType = filters.type ?? 'deposit'

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

  const cryptMap = new Map(crypts.map((v) => [v.id, v.symbol]))
  const swapBuySet = new Set(swaps.map((s) => s.buy_tx_id))
  const swapSellSet = new Set(swaps.map((s) => s.sell_tx_id))

  const filteredPurchases = purchases.filter((p) => {
    if (txType === 'deposit') return p.type === 'd' || p.type === 'a'
    if (txType === 'swap') return p.type === 's' || swapBuySet.has(p.id)
    return false
  })
  const filteredSells = sells.filter((s) => {
    if (txType === 'sell') return s.type === 's'
    if (txType === 'swap') return s.type === 'w' || swapSellSet.has(s.id)
    return false
  })
  const filteredTransfers = txType === 'transfer' ? transfers : []
  const filteredCommissions = txType === 'commission' ? commissions : []

  const defaultExecAt = defaultNowInput()

  const tabs = [
    { label: '入金 / エアドロップ', value: 'deposit' },
    { label: '売却', value: 'sell' },
    { label: 'スワップ', value: 'swap' },
    { label: '振替', value: 'transfer' },
    { label: '手数料', value: 'commission' },
  ]

  return (
    <section className="space-y-6">
      <div>
        <h2 className="text-xl font-semibold tracking-tight">Transactions</h2>
        <p className="text-sm text-slate-500">取引の登録・編集・削除</p>
      </div>

      {/* Tab Bar */}
      <div className="border-b border-slate-200">
        <nav className="-mb-px flex gap-0">
          {tabs.map((tab) => (
            <a
              key={tab.value}
              href={`?type=${tab.value}${filters.from ? `&from=${filters.from}` : ''}${filters.to ? `&to=${filters.to}` : ''}`}
              className={
                txType === tab.value
                  ? 'border-b-2 border-emerald-500 px-5 py-3 text-sm font-medium text-emerald-600 whitespace-nowrap'
                  : 'border-b-2 border-transparent px-5 py-3 text-sm font-medium text-slate-500 hover:text-slate-900 whitespace-nowrap'
              }
            >
              {tab.label}
            </a>
          ))}
        </nav>
      </div>

      {/* Date Range Filter */}
      <form className="flex flex-wrap items-center gap-3" method="get">
        <input type="hidden" name="type" value={txType} />
        <label className="text-xs font-medium text-slate-500 uppercase tracking-wider">期間</label>
        <input type="date" name="from" defaultValue={filters.from ?? ''} className="rounded-md border border-slate-200 px-3 py-2 text-sm" />
        <span className="text-slate-400 text-xs">〜</span>
        <input type="date" name="to" defaultValue={filters.to ?? ''} className="rounded-md border border-slate-200 px-3 py-2 text-sm" />
        <button type="submit" className="inline-flex items-center justify-center rounded-md border border-slate-300 bg-white px-4 py-2 text-sm font-medium hover:bg-slate-50">適用</button>
      </form>

      {/* DEPOSIT TAB */}
      {txType === 'deposit' && (
        <>
          <div className="rounded-xl border border-slate-200 bg-white shadow-sm p-6">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-4">入金 / エアドロップ 追加</p>
            <form action={createPurchaseAction} className="grid grid-cols-1 gap-3 md:grid-cols-2">
              <input type="hidden" name="locale" value={locale} />
              <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <select name="type" className="rounded-md border border-slate-200 px-3 py-2 text-sm" defaultValue="d">
                <option value="d">入金</option>
                <option value="a">エアドロップ</option>
              </select>
              <select name="account_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">アカウント</option>
                {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
              </select>
              <select name="crypt_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">通貨</option>
                {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
              </select>
              <input name="unit_yen" type="number" step="0.00000001" min="0" placeholder="単価 (JPY)" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <input name="deposit_yen" type="number" step="0.01" min="0" placeholder="入金 JPY" className="rounded-md border border-slate-200 px-3 py-2 text-sm" defaultValue="0" />
              <input name="purchase_yen" type="number" step="0.01" min="0" placeholder="取得 JPY" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <select name="commission_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" defaultValue="">
                <option value="">手数料なし</option>
                {commissions.map((c) => (
                  <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>
                ))}
              </select>
              <div className="md:col-span-2 flex justify-end">
                <button type="submit" className="inline-flex items-center justify-center rounded-md bg-emerald-600 text-white px-4 py-2 text-sm font-medium hover:bg-emerald-700">追加</button>
              </div>
            </form>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white shadow-sm overflow-hidden">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 px-6 pt-5 pb-3">入金 / エアドロップ 一覧</p>
            {filteredPurchases.length === 0 ? (
              <p className="text-sm text-slate-500 py-8 text-center">データがありません</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>日時</TableHead>
                    <TableHead>種別</TableHead>
                    <TableHead>アカウント</TableHead>
                    <TableHead>通貨</TableHead>
                    <TableHead className="text-right">単価(JPY)</TableHead>
                    <TableHead className="text-right">数量</TableHead>
                    <TableHead className="text-right">入金JPY</TableHead>
                    <TableHead className="text-right">取得JPY</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredPurchases.map((tx) => (
                    <TableRow key={tx.id}>
                      <TableCell colSpan={9} className="p-0">
                        <form action={updatePurchaseAction} className="flex flex-wrap gap-1 items-center px-4 py-2">
                          <input type="hidden" name="locale" value={locale} />
                          <input type="hidden" name="id" value={tx.id} />
                          <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(tx.exec_at)} className="rounded border border-slate-200 px-2 py-1 text-xs w-44" required />
                          <select name="type" defaultValue={tx.type} className="rounded border border-slate-200 px-2 py-1 text-xs">
                            <option value="d">入金</option>
                            <option value="a">エアドロップ</option>
                            <option value="s">スワップ買い</option>
                          </select>
                          <select name="account_id" defaultValue={tx.account_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
                          </select>
                          <select name="crypt_id" defaultValue={tx.crypt_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
                          </select>
                          <input name="unit_yen" defaultValue={tx.unit_yen} type="number" step="0.00000001" min="0" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="amount" defaultValue={tx.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="deposit_yen" defaultValue={tx.deposit_yen} type="number" step="0.01" min="0" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="purchase_yen" defaultValue={tx.purchase_yen} type="number" step="0.01" min="0" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <div className="flex gap-1 ml-auto">
                            <button type="submit" className="rounded bg-emerald-600 px-2 py-1 text-xs text-white hover:bg-emerald-700">更新</button>
                            <button formAction={deletePurchaseAction} type="submit" className="text-xs text-red-500 hover:text-red-700 px-2 py-1">削除</button>
                          </div>
                        </form>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </div>
        </>
      )}

      {/* SELL TAB */}
      {txType === 'sell' && (
        <>
          <div className="rounded-xl border border-slate-200 bg-white shadow-sm p-6">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-4">売却 追加</p>
            <form action={createSellAction} className="grid grid-cols-1 gap-3 md:grid-cols-2">
              <input type="hidden" name="locale" value={locale} />
              <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <select name="account_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">アカウント</option>
                {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
              </select>
              <select name="crypt_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">通貨</option>
                {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
              </select>
              <input name="unit_yen" type="number" step="0.00000001" min="0" placeholder="単価 (JPY)" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <input name="yen" type="number" step="0.01" min="0" placeholder="売却 JPY" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <select name="commission_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" defaultValue="">
                <option value="">手数料なし</option>
                {commissions.map((c) => (
                  <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>
                ))}
              </select>
              <div className="md:col-span-2 flex justify-end">
                <button type="submit" className="inline-flex items-center justify-center rounded-md bg-emerald-600 text-white px-4 py-2 text-sm font-medium hover:bg-emerald-700">追加</button>
              </div>
            </form>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white shadow-sm overflow-hidden">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 px-6 pt-5 pb-3">売却 一覧</p>
            {filteredSells.length === 0 ? (
              <p className="text-sm text-slate-500 py-8 text-center">データがありません</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>日時</TableHead>
                    <TableHead>アカウント</TableHead>
                    <TableHead>通貨</TableHead>
                    <TableHead className="text-right">単価(JPY)</TableHead>
                    <TableHead className="text-right">数量</TableHead>
                    <TableHead className="text-right">売却JPY</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredSells.map((tx) => (
                    <TableRow key={tx.id}>
                      <TableCell colSpan={7} className="p-0">
                        <form action={updateSellAction} className="flex flex-wrap gap-1 items-center px-4 py-2">
                          <input type="hidden" name="locale" value={locale} />
                          <input type="hidden" name="id" value={tx.id} />
                          <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(tx.exec_at)} className="rounded border border-slate-200 px-2 py-1 text-xs w-44" required />
                          <select name="account_id" defaultValue={tx.account_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
                          </select>
                          <select name="crypt_id" defaultValue={tx.crypt_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
                          </select>
                          <input name="unit_yen" defaultValue={tx.unit_yen} type="number" step="0.00000001" min="0" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="amount" defaultValue={tx.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="yen" defaultValue={tx.yen} type="number" step="0.01" min="0" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <div className="flex gap-1 ml-auto">
                            <button type="submit" className="rounded bg-emerald-600 px-2 py-1 text-xs text-white hover:bg-emerald-700">更新</button>
                            <button formAction={deleteSellAction} type="submit" className="text-xs text-red-500 hover:text-red-700 px-2 py-1">削除</button>
                          </div>
                        </form>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </div>
        </>
      )}

      {/* SWAP TAB */}
      {txType === 'swap' && (
        <>
          <div className="rounded-xl border border-slate-200 bg-white shadow-sm p-6">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-4">スワップ 追加</p>
            <form action={createSwapAction} className="space-y-3">
              <input type="hidden" name="locale" value={locale} />
              <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <div className="grid gap-3 md:grid-cols-2">
                <div className="space-y-2 rounded-lg border border-slate-200 p-3">
                  <p className="text-xs font-semibold text-slate-500">売り側</p>
                  <select name="sell_account_id" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                    <option value="">売りアカウント</option>
                    {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
                  </select>
                  <select name="sell_crypt_id" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                    <option value="">売り通貨</option>
                    {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
                  </select>
                  <input name="sell_unit_yen" type="number" step="0.00000001" min="0" placeholder="売り単価(JPY)" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required />
                  <input name="sell_amount" type="number" step="0.00000001" min="0.00000001" placeholder="売り数量" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required />
                  <input name="sell_yen" type="number" step="0.01" min="0" placeholder="売却JPY" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required />
                </div>
                <div className="space-y-2 rounded-lg border border-slate-200 p-3">
                  <p className="text-xs font-semibold text-slate-500">買い側</p>
                  <select name="buy_account_id" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                    <option value="">買いアカウント</option>
                    {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
                  </select>
                  <select name="buy_crypt_id" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                    <option value="">買い通貨</option>
                    {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
                  </select>
                  <input name="buy_unit_yen" type="number" step="0.00000001" min="0" placeholder="買い単価(JPY)" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required />
                  <input name="buy_amount" type="number" step="0.00000001" min="0.00000001" placeholder="買い数量" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required />
                  <input name="buy_deposit_yen" type="number" step="0.01" min="0" placeholder="入金JPY" defaultValue="0" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" />
                  <input name="buy_purchase_yen" type="number" step="0.01" min="0" placeholder="取得JPY" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" required />
                </div>
              </div>
              <select name="commission_id" className="w-full rounded-md border border-slate-200 px-3 py-2 text-sm" defaultValue="">
                <option value="">手数料なし</option>
                {commissions.map((c) => (
                  <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>
                ))}
              </select>
              <div className="flex justify-end">
                <button type="submit" className="inline-flex items-center justify-center rounded-md bg-emerald-600 text-white px-4 py-2 text-sm font-medium hover:bg-emerald-700">追加</button>
              </div>
            </form>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white shadow-sm overflow-hidden">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 px-6 pt-5 pb-3">スワップ連携 一覧</p>
            {swaps.length === 0 ? (
              <p className="text-sm text-slate-500 py-8 text-center">データがありません</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>買いTX</TableHead>
                    <TableHead>売りTX</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {swaps.map((s) => (
                    <TableRow key={s.id}>
                      <TableCell className="font-mono text-xs">{s.buy_tx_id.slice(0, 8)}</TableCell>
                      <TableCell className="font-mono text-xs">{s.sell_tx_id.slice(0, 8)}</TableCell>
                      <TableCell>
                        <form action={deleteSwapAction}>
                          <input type="hidden" name="locale" value={locale} />
                          <input type="hidden" name="swap_id" value={s.id} />
                          <input type="hidden" name="buy_tx_id" value={s.buy_tx_id} />
                          <input type="hidden" name="sell_tx_id" value={s.sell_tx_id} />
                          <button type="submit" className="text-xs text-red-500 hover:text-red-700">一括削除</button>
                        </form>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </div>
        </>
      )}

      {/* TRANSFER TAB */}
      {txType === 'transfer' && (
        <>
          <div className="rounded-xl border border-slate-200 bg-white shadow-sm p-6">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-4">振替 追加</p>
            <form action={createTransferAction} className="grid grid-cols-1 gap-3 md:grid-cols-2">
              <input type="hidden" name="locale" value={locale} />
              <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <select name="crypt_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">通貨</option>
                {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
              </select>
              <select name="from_account_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">振替元アカウント</option>
                {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
              </select>
              <select name="to_account_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">振替先アカウント</option>
                {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
              </select>
              <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <select name="commission_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" defaultValue="">
                <option value="">手数料なし</option>
                {commissions.map((c) => (
                  <option key={c.id} value={c.id}>{new Date(c.exec_at).toLocaleString('ja-JP')} / {cryptMap.get(c.crypt_id) ?? 'N/A'}</option>
                ))}
              </select>
              <input name="memo" placeholder="メモ" className="rounded-md border border-slate-200 px-3 py-2 text-sm md:col-span-2" />
              <div className="md:col-span-2 flex justify-end">
                <button type="submit" className="inline-flex items-center justify-center rounded-md bg-emerald-600 text-white px-4 py-2 text-sm font-medium hover:bg-emerald-700">追加</button>
              </div>
            </form>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white shadow-sm overflow-hidden">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 px-6 pt-5 pb-3">振替 一覧</p>
            {filteredTransfers.length === 0 ? (
              <p className="text-sm text-slate-500 py-8 text-center">データがありません</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>日時</TableHead>
                    <TableHead>送り元</TableHead>
                    <TableHead>送り先</TableHead>
                    <TableHead>通貨</TableHead>
                    <TableHead className="text-right">数量</TableHead>
                    <TableHead>メモ</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredTransfers.map((tx) => (
                    <TableRow key={tx.id}>
                      <TableCell colSpan={7} className="p-0">
                        <form action={updateTransferAction} className="flex flex-wrap gap-1 items-center px-4 py-2">
                          <input type="hidden" name="locale" value={locale} />
                          <input type="hidden" name="id" value={tx.id} />
                          <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(tx.exec_at)} className="rounded border border-slate-200 px-2 py-1 text-xs w-44" required />
                          <select name="from_account_id" defaultValue={tx.from_account_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
                          </select>
                          <select name="to_account_id" defaultValue={tx.to_account_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
                          </select>
                          <select name="crypt_id" defaultValue={tx.crypt_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
                          </select>
                          <input name="amount" defaultValue={tx.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="memo" defaultValue={tx.memo ?? ''} className="rounded border border-slate-200 px-2 py-1 text-xs" placeholder="メモ" />
                          <div className="flex gap-1 ml-auto">
                            <button type="submit" className="rounded bg-emerald-600 px-2 py-1 text-xs text-white hover:bg-emerald-700">更新</button>
                            <button formAction={deleteTransferAction} type="submit" className="text-xs text-red-500 hover:text-red-700 px-2 py-1">削除</button>
                          </div>
                        </form>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </div>
        </>
      )}

      {/* COMMISSION TAB */}
      {txType === 'commission' && (
        <>
          <div className="rounded-xl border border-slate-200 bg-white shadow-sm p-6">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 mb-4">手数料 追加</p>
            <form action={createCommissionAction} className="grid grid-cols-1 gap-3 md:grid-cols-2">
              <input type="hidden" name="locale" value={locale} />
              <input type="datetime-local" name="exec_at" defaultValue={defaultExecAt} className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <select name="account_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">アカウント</option>
                {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
              </select>
              <select name="crypt_id" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required>
                <option value="">通貨</option>
                {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
              </select>
              <input name="unit_yen" type="number" step="0.00000001" min="0" placeholder="単価(JPY)" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <input name="amount" type="number" step="0.00000001" min="0.00000001" placeholder="数量" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <input name="approximate_yen" type="number" step="0.01" min="0" placeholder="概算JPY" className="rounded-md border border-slate-200 px-3 py-2 text-sm" required />
              <div className="md:col-span-2 flex justify-end">
                <button type="submit" className="inline-flex items-center justify-center rounded-md bg-emerald-600 text-white px-4 py-2 text-sm font-medium hover:bg-emerald-700">追加</button>
              </div>
            </form>
          </div>

          <div className="rounded-xl border border-slate-200 bg-white shadow-sm overflow-hidden">
            <p className="text-xs font-semibold uppercase tracking-wider text-slate-500 px-6 pt-5 pb-3">手数料 一覧</p>
            {filteredCommissions.length === 0 ? (
              <p className="text-sm text-slate-500 py-8 text-center">データがありません</p>
            ) : (
              <Table>
                <TableHeader>
                  <TableRow>
                    <TableHead>日時</TableHead>
                    <TableHead>アカウント</TableHead>
                    <TableHead>通貨</TableHead>
                    <TableHead className="text-right">単価(JPY)</TableHead>
                    <TableHead className="text-right">数量</TableHead>
                    <TableHead className="text-right">概算JPY</TableHead>
                    <TableHead></TableHead>
                  </TableRow>
                </TableHeader>
                <TableBody>
                  {filteredCommissions.map((commission) => (
                    <TableRow key={commission.id}>
                      <TableCell colSpan={7} className="p-0">
                        <form action={updateCommissionAction} className="flex flex-wrap gap-1 items-center px-4 py-2">
                          <input type="hidden" name="locale" value={locale} />
                          <input type="hidden" name="id" value={commission.id} />
                          <input type="datetime-local" name="exec_at" defaultValue={toLocalDateTimeInput(commission.exec_at)} className="rounded border border-slate-200 px-2 py-1 text-xs w-44" required />
                          <select name="account_id" defaultValue={commission.account_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {accounts.map((a) => <option key={a.id} value={a.id}>{a.name}</option>)}
                          </select>
                          <select name="crypt_id" defaultValue={commission.crypt_id} className="rounded border border-slate-200 px-2 py-1 text-xs" required>
                            {crypts.map((c) => <option key={c.id} value={c.id}>{c.symbol}</option>)}
                          </select>
                          <input name="unit_yen" defaultValue={commission.unit_yen} type="number" step="0.00000001" min="0" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="amount" defaultValue={commission.amount} type="number" step="0.00000001" min="0.00000001" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <input name="approximate_yen" defaultValue={commission.approximate_yen} type="number" step="0.01" min="0" className="rounded border border-slate-200 px-2 py-1 text-xs w-24 text-right" required />
                          <div className="flex gap-1 ml-auto">
                            <button type="submit" className="rounded bg-emerald-600 px-2 py-1 text-xs text-white hover:bg-emerald-700">更新</button>
                            <button formAction={deleteCommissionAction} type="submit" className="text-xs text-red-500 hover:text-red-700 px-2 py-1">削除</button>
                          </div>
                        </form>
                      </TableCell>
                    </TableRow>
                  ))}
                </TableBody>
              </Table>
            )}
          </div>
        </>
      )}
    </section>
  )
}
