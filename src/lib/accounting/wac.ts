export type WacTransactionType =
  | 'purchase'
  | 'sell'
  | 'transfer_in'
  | 'transfer_out'

export type WacTransaction = {
  id: string
  userId: string
  accountId: string
  cryptId: string
  type: WacTransactionType
  occurredAt: string
  quantity: string
  yenAmount: string
}

export type WacLedgerSnapshot = {
  transactionId: string
  transactionType: WacTransactionType
  occurredAt: string
  totalQty: string
  totalCost: string
  wac: string
  realizedPnl: string | null
}

export type CostBasisHistoryRow = {
  user_id: string
  account_id: string
  crypt_id: string
  transaction_id: string
  transaction_type: WacTransactionType
  occurred_at: string
  total_qty: string
  total_cost: string
  wac: string
  realized_pnl: string | null
}

const QTY_SCALE = 8
const JPY_SCALE = 2
const WAC_SCALE = 8

const QTY_FACTOR = 10 ** QTY_SCALE
const JPY_FACTOR = 10 ** JPY_SCALE
const WAC_FACTOR = 10 ** WAC_SCALE

const TX_PRIORITY: Record<WacTransactionType, number> = {
  purchase: 1,
  transfer_in: 1,
  sell: 2,
  transfer_out: 2,
}

const parseDecimalToScaledInt = (value: string, scale: number): number => {
  const trimmed = value.trim()
  if (!/^-?\d+(\.\d+)?$/.test(trimmed)) {
    throw new Error(`Invalid decimal value: ${value}`)
  }

  const sign = trimmed.startsWith('-') ? -1 : 1
  const abs = sign < 0 ? trimmed.slice(1) : trimmed
  const [whole, rawFraction = ''] = abs.split('.')
  const fraction = rawFraction.slice(0, scale).padEnd(scale, '0')

  return sign * (Number(whole) * 10 ** scale + Number(fraction || '0'))
}

const formatScaledInt = (value: number, scale: number): string => {
  const sign = value < 0 ? '-' : ''
  const abs = Math.abs(Math.trunc(value))
  const factor = 10 ** scale
  const whole = Math.floor(abs / factor)
  const fraction = String(abs % factor).padStart(scale, '0')
  return `${sign}${whole}.${fraction}`
}

const roundHalfUp = (value: number): number => {
  return value >= 0 ? Math.floor(value + 0.5) : Math.ceil(value - 0.5)
}

const toWacUnits = (totalCostCents: number, totalQtyUnits: number): number => {
  if (totalQtyUnits === 0) {
    return 0
  }

  const raw =
    (totalCostCents * WAC_FACTOR * QTY_FACTOR) / (JPY_FACTOR * totalQtyUnits)
  return roundHalfUp(raw)
}

const costForQuantityFromWac = (wacUnits: number, qtyUnits: number): number => {
  const raw = (wacUnits * qtyUnits * JPY_FACTOR) / (WAC_FACTOR * QTY_FACTOR)
  return roundHalfUp(raw)
}

export const calculateWacLedger = (
  inputTransactions: WacTransaction[]
): WacLedgerSnapshot[] => {
  const transactions = [...inputTransactions].sort((a, b) => {
    const at = a.occurredAt.localeCompare(b.occurredAt)
    if (at !== 0) return at

    const p = TX_PRIORITY[a.type] - TX_PRIORITY[b.type]
    if (p !== 0) return p

    return a.id.localeCompare(b.id)
  })

  const snapshots: WacLedgerSnapshot[] = []
  let totalQty = 0
  let totalCost = 0

  for (const tx of transactions) {
    const qty = parseDecimalToScaledInt(tx.quantity, QTY_SCALE)
    const yen = parseDecimalToScaledInt(tx.yenAmount, JPY_SCALE)

    if (qty <= 0) {
      throw new Error(`Quantity must be positive. tx=${tx.id}`)
    }

    let realizedPnl: number | null = null

    if (tx.type === 'purchase' || tx.type === 'transfer_in') {
      totalQty += qty
      totalCost += yen
    } else {
      if (qty > totalQty) {
        throw new Error(
          `Insufficient balance for disposal. tx=${tx.id}, qty=${tx.quantity}`
        )
      }

      const currentWac = toWacUnits(totalCost, totalQty)
      const costOut = costForQuantityFromWac(currentWac, qty)
      realizedPnl = yen - costOut

      totalQty -= qty
      totalCost -= costOut

      if (totalQty === 0) {
        totalCost = 0
      }
    }

    const wac = toWacUnits(totalCost, totalQty)

    snapshots.push({
      transactionId: tx.id,
      transactionType: tx.type,
      occurredAt: tx.occurredAt,
      totalQty: formatScaledInt(totalQty, QTY_SCALE),
      totalCost: formatScaledInt(totalCost, JPY_SCALE),
      wac: formatScaledInt(wac, WAC_SCALE),
      realizedPnl:
        realizedPnl === null ? null : formatScaledInt(realizedPnl, JPY_SCALE),
    })
  }

  return snapshots
}

export const recalculateWacAfterMutation = (
  allTransactions: WacTransaction[]
): WacLedgerSnapshot[] => {
  return calculateWacLedger(allTransactions)
}

export const buildCostBasisHistoryRows = (
  transactions: WacTransaction[]
): CostBasisHistoryRow[] => {
  const snapshots = calculateWacLedger(transactions)
  const txMap = new Map(transactions.map((tx) => [tx.id, tx]))

  return snapshots.map((snapshot) => {
    const tx = txMap.get(snapshot.transactionId)
    if (!tx) {
      throw new Error(
        `Transaction not found for snapshot: ${snapshot.transactionId}`
      )
    }

    return {
      user_id: tx.userId,
      account_id: tx.accountId,
      crypt_id: tx.cryptId,
      transaction_id: snapshot.transactionId,
      transaction_type: snapshot.transactionType,
      occurred_at: snapshot.occurredAt,
      total_qty: snapshot.totalQty,
      total_cost: snapshot.totalCost,
      wac: snapshot.wac,
      realized_pnl: snapshot.realizedPnl,
    }
  })
}
