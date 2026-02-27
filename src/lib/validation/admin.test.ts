import { describe, it, expect } from 'vitest'
import { cryptSchema } from './admin'

describe('cryptSchema', () => {
  it('valid input with all fields passes', () => {
    const result = cryptSchema.safeParse({
      symbol: 'BTC',
      projectName: 'Bitcoin',
      coingeckoId: 'bitcoin',
      iconUrl: 'https://example.com/btc.png',
      color: '#F7931A',
      isActive: true,
    })
    expect(result.success).toBe(true)
  })

  it('valid input with only required fields passes', () => {
    const result = cryptSchema.safeParse({ symbol: 'ETH' })
    expect(result.success).toBe(true)
  })

  it('empty symbol fails', () => {
    const result = cryptSchema.safeParse({ symbol: '' })
    expect(result.success).toBe(false)
    expect(result.error?.issues[0]?.message).toContain('シンボルは必須')
  })

  it('symbol longer than 20 chars fails', () => {
    const result = cryptSchema.safeParse({ symbol: 'A'.repeat(21) })
    expect(result.success).toBe(false)
  })

  it('invalid color format fails', () => {
    const result = cryptSchema.safeParse({ symbol: 'BTC', color: 'red' })
    expect(result.success).toBe(false)
  })

  it('invalid URL fails', () => {
    const result = cryptSchema.safeParse({
      symbol: 'BTC',
      iconUrl: 'not-a-url',
    })
    expect(result.success).toBe(false)
  })

  it('empty iconUrl is allowed (treated as no icon)', () => {
    const result = cryptSchema.safeParse({ symbol: 'BTC', iconUrl: '' })
    expect(result.success).toBe(true)
  })
})
