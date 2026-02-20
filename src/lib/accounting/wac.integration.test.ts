import { calculateWacLedger } from './wac'

describe('wac integration flow', () => {
  it('作成フロー: 入金→売却で集計に反映される', () => {
    const snapshots = calculateWacLedger([
      {
        id: 'p1',
        userId: 'u1',
        accountId: 'a1',
        cryptId: 'btc',
        type: 'purchase',
        occurredAt: '2026-01-01T00:00:00.000Z',
        quantity: '1.00000000',
        yenAmount: '1000000.00',
      },
      {
        id: 's1',
        userId: 'u1',
        accountId: 'a1',
        cryptId: 'btc',
        type: 'sell',
        occurredAt: '2026-01-02T00:00:00.000Z',
        quantity: '0.40000000',
        yenAmount: '500000.00',
      },
    ])

    expect(snapshots).toHaveLength(2)
    expect(snapshots[0]).toMatchObject({
      totalQty: '1.00000000',
      totalCost: '1000000.00',
    })
    expect(snapshots[1]).toMatchObject({
      totalQty: '0.60000000',
      totalCost: '600000.00',
      realizedPnl: '100000.00',
    })
  })
})
