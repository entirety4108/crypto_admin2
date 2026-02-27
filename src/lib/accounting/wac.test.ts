import { describe, expect, it } from 'vitest'

import fixture from './wac.fixture.json'
import {
  buildCostBasisHistoryRows,
  calculateWacLedger,
  recalculateWacAfterMutation,
  type WacTransaction,
} from './wac'

describe('WAC ledger', () => {
  it('matches expected fixture (legacy comparison)', () => {
    const snapshots = calculateWacLedger(
      fixture.transactions as WacTransaction[]
    )
    expect(snapshots).toEqual(fixture.expectedSnapshots)
  })

  it('handles tiny decimal quantities without drifting below zero', () => {
    const txs: WacTransaction[] = [
      {
        id: 'a',
        userId: 'u-1',
        accountId: 'acc',
        cryptId: 'eth',
        type: 'purchase',
        occurredAt: '2026-01-01T00:00:00Z',
        quantity: '0.00000003',
        yenAmount: '9.00',
      },
      {
        id: 'b',
        userId: 'u-1',
        accountId: 'acc',
        cryptId: 'eth',
        type: 'sell',
        occurredAt: '2026-01-02T00:00:00Z',
        quantity: '0.00000003',
        yenAmount: '12.00',
      },
    ]

    const snapshots = calculateWacLedger(txs)
    expect(snapshots[1]).toMatchObject({
      totalQty: '0.00000000',
      totalCost: '0.00',
      wac: '0.00000000',
      realizedPnl: '3.00',
    })
  })

  it('recalculates correctly after edit/delete style mutation', () => {
    const baseTxs: WacTransaction[] = [
      {
        id: 't1',
        userId: 'u-1',
        accountId: 'acc',
        cryptId: 'btc',
        type: 'purchase',
        occurredAt: '2026-01-01T00:00:00Z',
        quantity: '1.00000000',
        yenAmount: '100.00',
      },
      {
        id: 't2',
        userId: 'u-1',
        accountId: 'acc',
        cryptId: 'btc',
        type: 'sell',
        occurredAt: '2026-01-02T00:00:00Z',
        quantity: '0.50000000',
        yenAmount: '70.00',
      },
    ]

    const edited: WacTransaction[] = [
      baseTxs[0]!,
      { ...baseTxs[1]!, yenAmount: '80.00' },
    ]

    const snapshots = recalculateWacAfterMutation(edited)
    expect(snapshots[1]!.realizedPnl).toBe('30.00')

    const deleted = recalculateWacAfterMutation([baseTxs[0]!])
    expect(deleted).toHaveLength(1)
    expect(deleted[0]!.totalQty).toBe('1.00000000')
  })

  it('creates cost_basis_history rows from ledger snapshots', () => {
    const rows = buildCostBasisHistoryRows(
      fixture.transactions as WacTransaction[]
    )
    expect(rows[2]).toMatchObject({
      transaction_id: 'tx-003',
      transaction_type: 'sell',
      total_qty: '1.10000000',
      realized_pnl: '73333.33',
    })
  })

  it('throws when selling more than available', () => {
    const txs: WacTransaction[] = [
      {
        id: 'x1',
        userId: 'u-1',
        accountId: 'acc',
        cryptId: 'sol',
        type: 'purchase',
        occurredAt: '2026-01-01T00:00:00Z',
        quantity: '1.00000000',
        yenAmount: '1000.00',
      },
      {
        id: 'x2',
        userId: 'u-1',
        accountId: 'acc',
        cryptId: 'sol',
        type: 'sell',
        occurredAt: '2026-01-02T00:00:00Z',
        quantity: '1.00000001',
        yenAmount: '1000.00',
      },
    ]

    expect(() => calculateWacLedger(txs)).toThrow(/Insufficient balance/)
  })
})
