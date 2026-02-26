import { createClient } from '@/lib/supabase/server'
import {
  Table,
  TableBody,
  TableCell,
  TableCellNumeric,
  TableHead,
  TableHeader,
  TableRow,
} from '@/components/ui/table'

type Account = { id: string; name: string }
type Crypt = { id: string; symbol: string }
type Sell = { exec_at: string; profit: string | null }
type PriceRow = { crypt_id: string; exec_at: string; unit_yen: string }
type Category = { id: string; name: string }
type UserCryptCategory = { crypt_id: string; category_id: string }
type DailyBalance = {
  account_id: string
  crypt_id: string
  date: string
  amount: string
  unit_price: string | null
  valuation: string | null
}

type Holding = {
  accountId: string
  cryptId: string
  qty: number
  cost: number
  price: number
  valuation: number
  unrealizedPnl: number
}

const fmtJPY = new Intl.NumberFormat('ja-JP', { maximumFractionDigits: 0 })
const fmtQty = new Intl.NumberFormat('ja-JP', { maximumFractionDigits: 8 })

function n(value: string | number | null | undefined) {
  const v = Number(value ?? 0)
  return Number.isFinite(v) ? v : 0
}

function sum(values: number[]) {
  return values.reduce((acc, cur) => acc + cur, 0)
}

function formatMonth(iso: string) {
  const d = new Date(iso)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}`
}

function formatYmd(iso: string) {
  const d = new Date(iso)
  return `${d.getFullYear()}-${String(d.getMonth() + 1).padStart(2, '0')}-${String(d.getDate()).padStart(2, '0')}`
}

function pnlColor(value: number) {
  return value >= 0 ? 'text-green-500' : 'text-red-500'
}

function PnlArrow({ value }: { value: number }) {
  if (value > 0) {
    return (
      <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" className="inline-block">
        <polyline points="18 15 12 9 6 15" />
      </svg>
    )
  }
  if (value < 0) {
    return (
      <svg xmlns="http://www.w3.org/2000/svg" width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2.5" strokeLinecap="round" strokeLinejoin="round" className="inline-block">
        <polyline points="6 9 12 15 18 9" />
      </svg>
    )
  }
  return null
}

export default async function PortfolioPage() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return <p className="text-sm text-red-600">ログインが必要です。</p>

  const [accountsRes, cryptsRes, sellsRes, pricesRes, categoriesRes, userCryptCategoriesRes, dailyBalancesRes] =
    await Promise.all([
      supabase.from('accounts').select('id,name').order('name'),
      supabase.from('crypts').select('id,symbol').eq('is_active', true).order('symbol'),
      supabase.from('sells').select('exec_at,profit').order('exec_at', { ascending: false }),
      supabase.from('prices').select('crypt_id,exec_at,unit_yen').order('exec_at', { ascending: false }),
      supabase.from('crypt_categories').select('id,name').order('name'),
      supabase.from('user_crypt_categories').select('crypt_id,category_id'),
      supabase
        .from('daily_balances')
        .select('account_id,crypt_id,date,amount,unit_price,valuation')
        .order('date', { ascending: true }),
    ])

  const error =
    accountsRes.error ||
    cryptsRes.error ||
    sellsRes.error ||
    pricesRes.error ||
    categoriesRes.error ||
    userCryptCategoriesRes.error ||
    dailyBalancesRes.error

  if (error) return <p className="text-sm text-red-600">{error.message}</p>

  const accounts = (accountsRes.data ?? []) as Account[]
  const crypts = (cryptsRes.data ?? []) as Crypt[]
  const sells = (sellsRes.data ?? []) as Sell[]
  const prices = (pricesRes.data ?? []) as PriceRow[]
  const categories = (categoriesRes.data ?? []) as Category[]
  const userCryptCategories = (userCryptCategoriesRes.data ?? []) as UserCryptCategory[]
  const dailyBalances = (dailyBalancesRes.data ?? []) as DailyBalance[]

  const accountMap = new Map(accounts.map((a) => [a.id, a.name]))
  const cryptMap = new Map(crypts.map((c) => [c.id, c.symbol]))

  const latestByAccountCrypt = new Map<string, DailyBalance>()
  for (let i = dailyBalances.length - 1; i >= 0; i -= 1) {
    const row = dailyBalances[i]
    if (!row) continue
    const key = `${row.account_id}:${row.crypt_id}`
    if (!latestByAccountCrypt.has(key)) latestByAccountCrypt.set(key, row)
  }

  const latestPriceByCrypt = new Map<string, number>()
  for (const row of prices) {
    if (!latestPriceByCrypt.has(row.crypt_id)) latestPriceByCrypt.set(row.crypt_id, n(row.unit_yen))
  }

  const holdings: Holding[] = []
  for (const row of latestByAccountCrypt.values()) {
    const qty = n(row.amount)
    if (qty <= 0) continue
    const valuation = n(row.valuation)
    const price = n(row.unit_price) || latestPriceByCrypt.get(row.crypt_id) || 0
    const cost = Math.max(valuation - qty * price, 0)
    holdings.push({
      accountId: row.account_id,
      cryptId: row.crypt_id,
      qty,
      cost,
      price,
      valuation,
      unrealizedPnl: valuation - cost,
    })
  }

  const realizedPnlTotal = sum(sells.map((row) => n(row.profit)))
  const valuationTotal = sum(holdings.map((h) => h.valuation))
  const unrealizedPnlTotal = sum(holdings.map((h) => h.unrealizedPnl))

  const holdingsByAccount = new Map<string, { valuation: number; cost: number; qty: number }>()
  for (const h of holdings) {
    const cur = holdingsByAccount.get(h.accountId) ?? { valuation: 0, cost: 0, qty: 0 }
    cur.valuation += h.valuation
    cur.cost += h.cost
    cur.qty += h.qty
    holdingsByAccount.set(h.accountId, cur)
  }

  const categoryMap = new Map(categories.map((c) => [c.id, c.name]))
  const cryptFirstCategory = new Map<string, string>()
  for (const rel of userCryptCategories) {
    if (!cryptFirstCategory.has(rel.crypt_id)) {
      const categoryName = categoryMap.get(rel.category_id)
      cryptFirstCategory.set(rel.crypt_id, categoryName ?? '未分類')
    }
  }

  const holdingsByCategory = new Map<string, { valuation: number; cost: number; qty: number }>()
  for (const h of holdings) {
    const categoryName = cryptFirstCategory.get(h.cryptId) ?? '未分類'
    const cur = holdingsByCategory.get(categoryName) ?? { valuation: 0, cost: 0, qty: 0 }
    cur.valuation += h.valuation
    cur.cost += h.cost
    cur.qty += h.qty
    holdingsByCategory.set(categoryName, cur)
  }

  const monthlyRealized = new Map<string, number>()
  const yearlyRealized = new Map<string, number>()
  for (const row of sells) {
    const pnl = n(row.profit)
    if (!pnl) continue
    const month = formatMonth(row.exec_at)
    const year = String(new Date(row.exec_at).getFullYear())
    monthlyRealized.set(month, (monthlyRealized.get(month) ?? 0) + pnl)
    yearlyRealized.set(year, (yearlyRealized.get(year) ?? 0) + pnl)
  }

  const dailyTotalMap = new Map<string, number>()
  for (const row of dailyBalances) {
    const date = String(row.date)
    dailyTotalMap.set(date, (dailyTotalMap.get(date) ?? 0) + n(row.valuation))
  }
  const dailySeries = [...dailyTotalMap.entries()].map(([date, valuation]) => ({ date, valuation })).slice(-30)
  const maxDailyValuation = Math.max(...dailySeries.map((v) => v.valuation), 1)

  return (
    <section className="space-y-8">
      <div>
        <h2 className="text-2xl font-bold text-slate-900">Portfolio</h2>
        <p className="mt-1 text-sm text-slate-500">保有資産の評価額・損益サマリー</p>
      </div>

      {/* KPI Cards */}
      <div className="grid gap-4 md:grid-cols-3">
        <article className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
          <div className="flex items-stretch">
            <div className="w-1 shrink-0 bg-slate-400" />
            <div className="flex-1 p-5">
              <p className="text-xs font-semibold uppercase tracking-wider text-slate-500">総評価額</p>
              <p className="mt-2 font-mono text-3xl font-bold tabular-nums text-slate-900">
                ¥{fmtJPY.format(valuationTotal)}
              </p>
            </div>
          </div>
        </article>
        <article className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
          <div className="flex items-stretch">
            <div className={`w-1 shrink-0 ${realizedPnlTotal >= 0 ? 'bg-green-500' : 'bg-red-500'}`} />
            <div className="flex-1 p-5">
              <p className="text-xs font-semibold uppercase tracking-wider text-slate-500">確定損益</p>
              <p className={`mt-2 flex items-center gap-1 font-mono text-3xl font-bold tabular-nums ${pnlColor(realizedPnlTotal)}`}>
                <PnlArrow value={realizedPnlTotal} />
                ¥{fmtJPY.format(realizedPnlTotal)}
              </p>
            </div>
          </div>
        </article>
        <article className="overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm">
          <div className="flex items-stretch">
            <div className={`w-1 shrink-0 ${unrealizedPnlTotal >= 0 ? 'bg-green-500' : 'bg-red-500'}`} />
            <div className="flex-1 p-5">
              <p className="text-xs font-semibold uppercase tracking-wider text-slate-500">評価損益</p>
              <p className={`mt-2 flex items-center gap-1 font-mono text-3xl font-bold tabular-nums ${pnlColor(unrealizedPnlTotal)}`}>
                <PnlArrow value={unrealizedPnlTotal} />
                ¥{fmtJPY.format(unrealizedPnlTotal)}
              </p>
            </div>
          </div>
        </article>
      </div>

      {/* Holdings by Account and Category */}
      <div className="grid gap-6 lg:grid-cols-2">
        <article className="rounded-xl border border-slate-200 bg-white shadow-sm">
          <div className="border-b border-slate-100 px-5 py-4">
            <h3 className="font-semibold text-slate-900">アカウント別保有</h3>
          </div>
          {holdingsByAccount.size === 0 ? (
            <p className="p-5 text-sm text-slate-500">保有データがありません。</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>アカウント</TableHead>
                  <TableHead className="text-right">評価額</TableHead>
                  <TableHead className="text-right">評価損益</TableHead>
                  <TableHead className="text-right">損益率</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {[...holdingsByAccount.entries()]
                  .sort((a, b) => b[1].valuation - a[1].valuation)
                  .map(([accountId, v]) => {
                    const pnl = v.valuation - v.cost
                    const pnlPct = v.cost > 0 ? (pnl / v.cost) * 100 : 0
                    return (
                      <TableRow key={accountId}>
                        <TableCell className="font-medium text-slate-900">
                          {accountMap.get(accountId) ?? 'Unknown'}
                        </TableCell>
                        <TableCellNumeric>¥{fmtJPY.format(v.valuation)}</TableCellNumeric>
                        <TableCellNumeric className={pnlColor(pnl)}>
                          ¥{fmtJPY.format(pnl)}
                        </TableCellNumeric>
                        <TableCellNumeric className={pnlColor(pnlPct)}>
                          {pnlPct >= 0 ? '+' : ''}{pnlPct.toFixed(2)}%
                        </TableCellNumeric>
                      </TableRow>
                    )
                  })}
              </TableBody>
            </Table>
          )}
        </article>

        <article className="rounded-xl border border-slate-200 bg-white shadow-sm">
          <div className="border-b border-slate-100 px-5 py-4">
            <h3 className="font-semibold text-slate-900">カテゴリ別保有</h3>
          </div>
          {holdingsByCategory.size === 0 ? (
            <p className="p-5 text-sm text-slate-500">カテゴリ別データがありません。</p>
          ) : (
            <Table>
              <TableHeader>
                <TableRow>
                  <TableHead>カテゴリ</TableHead>
                  <TableHead className="text-right">評価額</TableHead>
                  <TableHead className="text-right">評価損益</TableHead>
                  <TableHead className="text-right">損益率</TableHead>
                </TableRow>
              </TableHeader>
              <TableBody>
                {[...holdingsByCategory.entries()]
                  .sort((a, b) => b[1].valuation - a[1].valuation)
                  .map(([categoryName, v]) => {
                    const pnl = v.valuation - v.cost
                    const pnlPct = v.cost > 0 ? (pnl / v.cost) * 100 : 0
                    return (
                      <TableRow key={categoryName}>
                        <TableCell className="font-medium text-slate-900">{categoryName}</TableCell>
                        <TableCellNumeric>¥{fmtJPY.format(v.valuation)}</TableCellNumeric>
                        <TableCellNumeric className={pnlColor(pnl)}>
                          ¥{fmtJPY.format(pnl)}
                        </TableCellNumeric>
                        <TableCellNumeric className={pnlColor(pnlPct)}>
                          {pnlPct >= 0 ? '+' : ''}{pnlPct.toFixed(2)}%
                        </TableCellNumeric>
                      </TableRow>
                    )
                  })}
              </TableBody>
            </Table>
          )}
        </article>
      </div>

      {/* PnL Reports */}
      <div className="grid gap-6 lg:grid-cols-2">
        <article className="rounded-xl border border-slate-200 bg-white shadow-sm">
          <div className="border-b border-slate-100 px-5 py-4">
            <h3 className="font-semibold text-slate-900">損益レポート（月次）</h3>
          </div>
          {monthlyRealized.size === 0 ? (
            <p className="p-5 text-sm text-slate-500">確定損益データがありません。</p>
          ) : (
            <div className="divide-y divide-slate-100">
              {[...monthlyRealized.entries()]
                .sort((a, b) => (a[0] > b[0] ? -1 : 1))
                .map(([month, pnl]) => (
                  <div key={month} className="flex items-center justify-between px-5 py-3">
                    <span className="text-sm text-slate-500">{month}</span>
                    <span className={`font-mono text-sm tabular-nums ${pnlColor(pnl)}`}>
                      ¥{fmtJPY.format(pnl)}
                    </span>
                  </div>
                ))}
            </div>
          )}
        </article>

        <article className="rounded-xl border border-slate-200 bg-white shadow-sm">
          <div className="border-b border-slate-100 px-5 py-4">
            <h3 className="font-semibold text-slate-900">損益レポート（年次）</h3>
          </div>
          {yearlyRealized.size === 0 ? (
            <p className="p-5 text-sm text-slate-500">確定損益データがありません。</p>
          ) : (
            <div className="divide-y divide-slate-100">
              {[...yearlyRealized.entries()]
                .sort((a, b) => (a[0] > b[0] ? -1 : 1))
                .map(([year, pnl]) => (
                  <div key={year} className="flex items-center justify-between px-5 py-3">
                    <span className="text-sm text-slate-500">{year}</span>
                    <span className={`font-mono text-sm tabular-nums ${pnlColor(pnl)}`}>
                      ¥{fmtJPY.format(pnl)}
                    </span>
                  </div>
                ))}
            </div>
          )}
        </article>
      </div>

      {/* Daily Balance Chart */}
      <article className="rounded-xl border border-slate-200 bg-white shadow-sm">
        <div className="border-b border-slate-100 px-5 py-4">
          <h3 className="font-semibold text-slate-900">残高履歴（日次）</h3>
        </div>
        {dailySeries.length === 0 ? (
          <p className="p-5 text-sm text-slate-500">daily_balances のデータがないためグラフを表示できません。</p>
        ) : (
          <div className="p-5 space-y-3">
            <div className="flex justify-end">
              <span className="font-mono text-xs tabular-nums text-slate-400">
                MAX: ¥{fmtJPY.format(maxDailyValuation)}
              </span>
            </div>
            <div className="flex h-40 items-end gap-1 rounded-lg bg-slate-50 p-3">
              {dailySeries.map((point) => (
                <div
                  key={point.date}
                  className="min-w-1 flex-1 rounded-sm bg-emerald-500 opacity-80 hover:opacity-100 transition-opacity"
                  style={{ height: `${Math.max((point.valuation / maxDailyValuation) * 100, 2)}%` }}
                  title={`${formatYmd(point.date)}: ¥${fmtJPY.format(point.valuation)}`}
                />
              ))}
            </div>
            <ul className="grid gap-1 text-xs text-slate-500 md:grid-cols-3">
              {dailySeries.slice(-6).map((point) => (
                <li key={point.date} className="font-mono tabular-nums">
                  {formatYmd(point.date)}: ¥{fmtJPY.format(point.valuation)}
                </li>
              ))}
            </ul>
          </div>
        )}
      </article>

      {/* Positions Table */}
      <article className="rounded-xl border border-slate-200 bg-white shadow-sm">
        <div className="border-b border-slate-100 px-5 py-4">
          <h3 className="font-semibold text-slate-900">通貨別ポジション（最新）</h3>
        </div>
        {holdings.length === 0 ? (
          <p className="p-5 text-sm text-slate-500">保有ポジションがありません。</p>
        ) : (
          <Table>
            <TableHeader>
              <TableRow>
                <TableHead>通貨 / アカウント</TableHead>
                <TableHead className="text-right">数量</TableHead>
                <TableHead className="text-right">単価</TableHead>
                <TableHead className="text-right">評価額</TableHead>
                <TableHead className="text-right">評価損益</TableHead>
              </TableRow>
            </TableHeader>
            <TableBody>
              {holdings
                .sort((a, b) => b.valuation - a.valuation)
                .map((h) => (
                  <TableRow key={`${h.accountId}-${h.cryptId}`}>
                    <TableCell>
                      <p className="font-bold text-slate-900">{cryptMap.get(h.cryptId) ?? h.cryptId}</p>
                      <p className="text-xs text-slate-500">{accountMap.get(h.accountId) ?? h.accountId}</p>
                    </TableCell>
                    <TableCellNumeric className="text-slate-700">{fmtQty.format(h.qty)}</TableCellNumeric>
                    <TableCellNumeric className="text-slate-700">¥{fmtJPY.format(h.price)}</TableCellNumeric>
                    <TableCellNumeric className="font-medium text-slate-900">¥{fmtJPY.format(h.valuation)}</TableCellNumeric>
                    <TableCellNumeric className={pnlColor(h.unrealizedPnl)}>
                      ¥{fmtJPY.format(h.unrealizedPnl)}
                    </TableCellNumeric>
                  </TableRow>
                ))}
            </TableBody>
          </Table>
        )}
      </article>
    </section>
  )
}
