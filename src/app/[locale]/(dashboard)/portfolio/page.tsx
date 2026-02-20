import { createClient } from '@/lib/supabase/server'

type Account = { id: string; name: string }
type Crypt = { id: string; symbol: string }
type CostBasisRow = {
  account_id: string
  crypt_id: string
  occurred_at: string
  total_qty: string
  total_cost: string
  realized_pnl: string | null
}
type PriceRow = { crypt_id: string; exec_at: string; unit_yen: string }
type Category = { id: string; name: string }
type UserCryptCategory = { crypt_id: string; category_id: string }
type DailyBalance = { date: string; valuation: string | null }

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

export default async function PortfolioPage() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) return <p className="text-sm text-red-600">ログインが必要です。</p>

  const [accountsRes, cryptsRes, costBasisRes, pricesRes, categoriesRes, userCryptCategoriesRes, dailyBalancesRes] =
    await Promise.all([
      supabase.from('accounts').select('id,name').order('name'),
      supabase.from('crypts').select('id,symbol').eq('is_active', true).order('symbol'),
      supabase
        .from('cost_basis_history')
        .select('account_id,crypt_id,occurred_at,total_qty,total_cost,realized_pnl')
        .order('occurred_at', { ascending: false }),
      supabase.from('prices').select('crypt_id,exec_at,unit_yen').order('exec_at', { ascending: false }),
      supabase.from('crypt_categories').select('id,name').order('name'),
      supabase.from('user_crypt_categories').select('crypt_id,category_id'),
      supabase.from('daily_balances').select('date,valuation').order('date', { ascending: true }),
    ])

  const error =
    accountsRes.error ||
    cryptsRes.error ||
    costBasisRes.error ||
    pricesRes.error ||
    categoriesRes.error ||
    userCryptCategoriesRes.error ||
    dailyBalancesRes.error

  if (error) return <p className="text-sm text-red-600">{error.message}</p>

  const accounts = (accountsRes.data ?? []) as Account[]
  const crypts = (cryptsRes.data ?? []) as Crypt[]
  const costBasis = (costBasisRes.data ?? []) as CostBasisRow[]
  const prices = (pricesRes.data ?? []) as PriceRow[]
  const categories = (categoriesRes.data ?? []) as Category[]
  const userCryptCategories = (userCryptCategoriesRes.data ?? []) as UserCryptCategory[]
  const dailyBalances = (dailyBalancesRes.data ?? []) as DailyBalance[]

  const accountMap = new Map(accounts.map((a) => [a.id, a.name]))
  const cryptMap = new Map(crypts.map((c) => [c.id, c.symbol]))

  const latestByAccountCrypt = new Map<string, CostBasisRow>()
  for (const row of costBasis) {
    const key = `${row.account_id}:${row.crypt_id}`
    if (!latestByAccountCrypt.has(key)) latestByAccountCrypt.set(key, row)
  }

  const latestPriceByCrypt = new Map<string, number>()
  for (const row of prices) {
    if (!latestPriceByCrypt.has(row.crypt_id)) latestPriceByCrypt.set(row.crypt_id, n(row.unit_yen))
  }

  const holdings: Holding[] = []
  for (const row of latestByAccountCrypt.values()) {
    const qty = n(row.total_qty)
    if (qty <= 0) continue
    const cost = n(row.total_cost)
    const price = latestPriceByCrypt.get(row.crypt_id) ?? 0
    const valuation = qty * price
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

  const realizedPnlTotal = sum(costBasis.map((row) => n(row.realized_pnl)))
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
  for (const row of costBasis) {
    const pnl = n(row.realized_pnl)
    if (!pnl) continue
    const month = formatMonth(row.occurred_at)
    const year = String(new Date(row.occurred_at).getFullYear())
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
        <h2 className="text-xl font-semibold">Portfolio</h2>
        <p className="text-sm text-slate-600">Phase6: サマリー、保有内訳、損益レポート、残高履歴を表示します。</p>
      </div>

      <div className="grid gap-4 md:grid-cols-3">
        <article className="rounded-lg border p-4">
          <p className="text-sm text-slate-500">総評価額</p>
          <p className="text-2xl font-semibold">¥{fmtJPY.format(valuationTotal)}</p>
        </article>
        <article className="rounded-lg border p-4">
          <p className="text-sm text-slate-500">確定損益</p>
          <p className={`text-2xl font-semibold ${realizedPnlTotal >= 0 ? 'text-emerald-600' : 'text-rose-600'}`}>
            ¥{fmtJPY.format(realizedPnlTotal)}
          </p>
        </article>
        <article className="rounded-lg border p-4">
          <p className="text-sm text-slate-500">評価損益</p>
          <p className={`text-2xl font-semibold ${unrealizedPnlTotal >= 0 ? 'text-emerald-600' : 'text-rose-600'}`}>
            ¥{fmtJPY.format(unrealizedPnlTotal)}
          </p>
        </article>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <article className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">アカウント別保有</h3>
          {holdingsByAccount.size === 0 ? (
            <p className="text-sm text-slate-500">保有データがありません。</p>
          ) : (
            <ul className="space-y-2 text-sm">
              {[...holdingsByAccount.entries()]
                .sort((a, b) => b[1].valuation - a[1].valuation)
                .map(([accountId, v]) => (
                  <li key={accountId} className="rounded border p-2">
                    <p className="font-medium">{accountMap.get(accountId) ?? 'Unknown'}</p>
                    <p className="text-slate-600">
                      評価額: ¥{fmtJPY.format(v.valuation)} / 評価損益: ¥{fmtJPY.format(v.valuation - v.cost)} / 保有数量:{' '}
                      {fmtQty.format(v.qty)}
                    </p>
                  </li>
                ))}
            </ul>
          )}
        </article>

        <article className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">カテゴリ別保有</h3>
          {holdingsByCategory.size === 0 ? (
            <p className="text-sm text-slate-500">カテゴリ別データがありません。</p>
          ) : (
            <ul className="space-y-2 text-sm">
              {[...holdingsByCategory.entries()]
                .sort((a, b) => b[1].valuation - a[1].valuation)
                .map(([categoryName, v]) => (
                  <li key={categoryName} className="rounded border p-2">
                    <p className="font-medium">{categoryName}</p>
                    <p className="text-slate-600">
                      評価額: ¥{fmtJPY.format(v.valuation)} / 評価損益: ¥{fmtJPY.format(v.valuation - v.cost)} / 保有数量:{' '}
                      {fmtQty.format(v.qty)}
                    </p>
                  </li>
                ))}
            </ul>
          )}
        </article>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <article className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">損益レポート（月次）</h3>
          {monthlyRealized.size === 0 ? (
            <p className="text-sm text-slate-500">確定損益データがありません。</p>
          ) : (
            <ul className="space-y-1 text-sm">
              {[...monthlyRealized.entries()]
                .sort((a, b) => (a[0] > b[0] ? -1 : 1))
                .map(([month, pnl]) => (
                  <li key={month} className="flex items-center justify-between border-b py-1">
                    <span>{month}</span>
                    <span className={pnl >= 0 ? 'text-emerald-600' : 'text-rose-600'}>¥{fmtJPY.format(pnl)}</span>
                  </li>
                ))}
            </ul>
          )}
        </article>

        <article className="space-y-2 rounded-lg border p-4">
          <h3 className="font-medium">損益レポート（年次）</h3>
          {yearlyRealized.size === 0 ? (
            <p className="text-sm text-slate-500">確定損益データがありません。</p>
          ) : (
            <ul className="space-y-1 text-sm">
              {[...yearlyRealized.entries()]
                .sort((a, b) => (a[0] > b[0] ? -1 : 1))
                .map(([year, pnl]) => (
                  <li key={year} className="flex items-center justify-between border-b py-1">
                    <span>{year}</span>
                    <span className={pnl >= 0 ? 'text-emerald-600' : 'text-rose-600'}>¥{fmtJPY.format(pnl)}</span>
                  </li>
                ))}
            </ul>
          )}
        </article>
      </div>

      <article className="space-y-3 rounded-lg border p-4">
        <h3 className="font-medium">残高履歴（日次）</h3>
        {dailySeries.length === 0 ? (
          <p className="text-sm text-slate-500">daily_balances のデータがないためグラフを表示できません。</p>
        ) : (
          <div className="space-y-2">
            <div className="flex h-28 items-end gap-1 rounded border p-2">
              {dailySeries.map((point) => (
                <div
                  key={point.date}
                  className="min-w-1 flex-1 rounded-sm bg-slate-700"
                  style={{ height: `${Math.max((point.valuation / maxDailyValuation) * 100, 2)}%` }}
                  title={`${formatYmd(point.date)}: ¥${fmtJPY.format(point.valuation)}`}
                />
              ))}
            </div>
            <ul className="grid gap-1 text-xs text-slate-600 md:grid-cols-3">
              {dailySeries.slice(-6).map((point) => (
                <li key={point.date}>
                  {formatYmd(point.date)}: ¥{fmtJPY.format(point.valuation)}
                </li>
              ))}
            </ul>
          </div>
        )}
      </article>

      <article className="space-y-2 rounded-lg border p-4">
        <h3 className="font-medium">通貨別ポジション（最新）</h3>
        {holdings.length === 0 ? (
          <p className="text-sm text-slate-500">保有ポジションがありません。</p>
        ) : (
          <ul className="space-y-1 text-sm">
            {holdings
              .sort((a, b) => b.valuation - a.valuation)
              .map((h) => (
                <li key={`${h.accountId}-${h.cryptId}`} className="rounded border p-2">
                  <p className="font-medium">
                    {cryptMap.get(h.cryptId) ?? h.cryptId} / {accountMap.get(h.accountId) ?? h.accountId}
                  </p>
                  <p className="text-slate-600">
                    数量: {fmtQty.format(h.qty)} / 単価: ¥{fmtJPY.format(h.price)} / 評価額: ¥{fmtJPY.format(h.valuation)}
                  </p>
                </li>
              ))}
          </ul>
        )}
      </article>
    </section>
  )
}
