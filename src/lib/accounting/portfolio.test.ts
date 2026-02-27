import { describe, expect, it } from 'vitest'

import {
  buildPortfolioHoldings,
  type PortfolioPurchaseRow,
  type PortfolioSellRow,
  type PortfolioTransferRow,
} from './portfolio'

describe('buildPortfolioHoldings', () => {
  it('reflects purchase immediately in holdings', () => {
    const purchases: PortfolioPurchaseRow[] = [
      {
        id: 'p1',
        exec_at: '2026-02-27T10:00:00Z',
        account_id: 'acc-1',
        crypt_id: 'btc',
        amount: '1.50000000',
        purchase_yen: '1500000',
      },
    ]

    const holdings = buildPortfolioHoldings({
      purchases,
      sells: [],
      transfers: [],
      latestPriceByCrypt: new Map([['btc', 1200000]]),
    })

    expect(holdings).toHaveLength(1)
    expect(holdings[0]).toMatchObject({
      accountId: 'acc-1',
      cryptId: 'btc',
      qty: 1.5,
      cost: 1500000,
      price: 1200000,
      valuation: 1800000,
      unrealizedPnl: 300000,
    })
  })

  it('reduces quantity and cost proportionally on sell', () => {
    const purchases: PortfolioPurchaseRow[] = [
      {
        id: 'p1',
        exec_at: '2026-02-01T00:00:00Z',
        account_id: 'acc-1',
        crypt_id: 'eth',
        amount: '2',
        purchase_yen: '400000',
      },
    ]
    const sells: PortfolioSellRow[] = [
      {
        id: 's1',
        exec_at: '2026-02-02T00:00:00Z',
        account_id: 'acc-1',
        crypt_id: 'eth',
        amount: '0.5',
      },
    ]

    const holdings = buildPortfolioHoldings({
      purchases,
      sells,
      transfers: [],
      latestPriceByCrypt: new Map([['eth', 250000]]),
    })

    expect(holdings).toHaveLength(1)
    expect(holdings[0]?.qty).toBeCloseTo(1.5, 8)
    expect(holdings[0]?.cost).toBeCloseTo(300000, 2)
    expect(holdings[0]?.valuation).toBeCloseTo(375000, 2)
  })

  it('moves quantity and cost between accounts on transfer', () => {
    const purchases: PortfolioPurchaseRow[] = [
      {
        id: 'p1',
        exec_at: '2026-02-01T00:00:00Z',
        account_id: 'acc-a',
        crypt_id: 'sol',
        amount: '10',
        purchase_yen: '100000',
      },
    ]
    const transfers: PortfolioTransferRow[] = [
      {
        id: 't1',
        exec_at: '2026-02-02T00:00:00Z',
        from_account_id: 'acc-a',
        to_account_id: 'acc-b',
        crypt_id: 'sol',
        amount: '4',
      },
    ]

    const holdings = buildPortfolioHoldings({
      purchases,
      sells: [],
      transfers,
      latestPriceByCrypt: new Map([['sol', 12000]]),
    }).sort((a, b) => a.accountId.localeCompare(b.accountId))

    expect(holdings).toHaveLength(2)
    expect(holdings[0]).toMatchObject({
      accountId: 'acc-a',
      qty: 6,
      cost: 60000,
    })
    expect(holdings[1]).toMatchObject({
      accountId: 'acc-b',
      qty: 4,
      cost: 40000,
    })
  })
})
