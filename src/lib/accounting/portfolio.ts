export type PortfolioPurchaseRow = {
  id: string
  exec_at: string
  account_id: string
  crypt_id: string
  amount: string
  purchase_yen: string
}

export type PortfolioSellRow = {
  id: string
  exec_at: string
  account_id: string
  crypt_id: string
  amount: string
}

export type PortfolioTransferRow = {
  id: string
  exec_at: string
  from_account_id: string
  to_account_id: string
  crypt_id: string
  amount: string
}

export type PortfolioHolding = {
  accountId: string
  cryptId: string
  qty: number
  cost: number
  price: number
  valuation: number
  unrealizedPnl: number
}

type LedgerState = {
  qty: number
  cost: number
}

type LedgerEvent =
  | {
      kind: 'purchase'
      id: string
      execAt: string
      accountId: string
      cryptId: string
      qty: number
      cost: number
    }
  | { kind: 'sell'; id: string; execAt: string; accountId: string; cryptId: string; qty: number }
  | {
      kind: 'transfer'
      id: string
      execAt: string
      fromAccountId: string
      toAccountId: string
      cryptId: string
      qty: number
    }

const EVENT_PRIORITY: Record<LedgerEvent['kind'], number> = {
  purchase: 1,
  transfer: 2,
  sell: 3,
}

const toFiniteNumber = (value: string | number | null | undefined): number => {
  const parsed = Number(value ?? 0)
  return Number.isFinite(parsed) ? parsed : 0
}

const makeKey = (accountId: string, cryptId: string): string =>
  `${accountId}:${cryptId}`

const getState = (
  stateByKey: Map<string, LedgerState>,
  accountId: string,
  cryptId: string
): LedgerState => {
  const key = makeKey(accountId, cryptId)
  const state = stateByKey.get(key)
  if (state) {
    return state
  }

  const initialState: LedgerState = { qty: 0, cost: 0 }
  stateByKey.set(key, initialState)
  return initialState
}

const roundTo = (value: number, digits: number): number => {
  const factor = 10 ** digits
  return Math.round(value * factor) / factor
}

export const buildPortfolioHoldings = (args: {
  purchases: PortfolioPurchaseRow[]
  sells: PortfolioSellRow[]
  transfers: PortfolioTransferRow[]
  latestPriceByCrypt: Map<string, number>
}): PortfolioHolding[] => {
  const events: LedgerEvent[] = [
    ...args.purchases.map((row) => ({
      kind: 'purchase' as const,
      id: row.id,
      execAt: row.exec_at,
      accountId: row.account_id,
      cryptId: row.crypt_id,
      qty: toFiniteNumber(row.amount),
      cost: toFiniteNumber(row.purchase_yen),
    })),
    ...args.sells.map((row) => ({
      kind: 'sell' as const,
      id: row.id,
      execAt: row.exec_at,
      accountId: row.account_id,
      cryptId: row.crypt_id,
      qty: toFiniteNumber(row.amount),
    })),
    ...args.transfers.map((row) => ({
      kind: 'transfer' as const,
      id: row.id,
      execAt: row.exec_at,
      fromAccountId: row.from_account_id,
      toAccountId: row.to_account_id,
      cryptId: row.crypt_id,
      qty: toFiniteNumber(row.amount),
    })),
  ].filter((event) => event.qty > 0)

  events.sort((a, b) => {
    const byDate = a.execAt.localeCompare(b.execAt)
    if (byDate !== 0) {
      return byDate
    }

    const byPriority = EVENT_PRIORITY[a.kind] - EVENT_PRIORITY[b.kind]
    if (byPriority !== 0) {
      return byPriority
    }

    return a.id.localeCompare(b.id)
  })

  const stateByKey = new Map<string, LedgerState>()

  for (const event of events) {
    if (event.kind === 'purchase') {
      const state = getState(stateByKey, event.accountId, event.cryptId)
      state.qty += event.qty
      state.cost += event.cost
      continue
    }

    if (event.kind === 'sell') {
      const state = getState(stateByKey, event.accountId, event.cryptId)
      if (state.qty <= 0) {
        continue
      }

      const qtyOut = Math.min(event.qty, state.qty)
      const unitCost = state.cost / state.qty
      const costOut = unitCost * qtyOut

      state.qty = Math.max(state.qty - qtyOut, 0)
      state.cost = Math.max(state.cost - costOut, 0)
      continue
    }

    const fromState = getState(stateByKey, event.fromAccountId, event.cryptId)
    if (fromState.qty <= 0) {
      continue
    }

    const qtyOut = Math.min(event.qty, fromState.qty)
    const unitCost = fromState.cost / fromState.qty
    const costOut = unitCost * qtyOut

    fromState.qty = Math.max(fromState.qty - qtyOut, 0)
    fromState.cost = Math.max(fromState.cost - costOut, 0)

    const toState = getState(stateByKey, event.toAccountId, event.cryptId)
    toState.qty += qtyOut
    toState.cost += costOut
  }

  const holdings: PortfolioHolding[] = []

  for (const [key, state] of stateByKey.entries()) {
    if (state.qty <= 0) {
      continue
    }

    const separatorIndex = key.indexOf(':')
    if (separatorIndex <= 0 || separatorIndex >= key.length - 1) {
      continue
    }

    const accountId = key.slice(0, separatorIndex)
    const cryptId = key.slice(separatorIndex + 1)
    const price = args.latestPriceByCrypt.get(cryptId) ?? 0
    const qty = roundTo(state.qty, 8)
    const cost = roundTo(state.cost, 2)
    const valuation = roundTo(qty * price, 2)
    const unrealizedPnl = roundTo(valuation - cost, 2)

    holdings.push({
      accountId,
      cryptId,
      qty,
      cost,
      price,
      valuation,
      unrealizedPnl,
    })
  }

  return holdings
}
