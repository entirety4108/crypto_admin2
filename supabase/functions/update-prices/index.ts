// update-prices Edge Function
// CoinGecko APIから価格を取得してpricesテーブルに保存

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

const COINGECKO_API_URL = 'https://api.coingecko.com/api/v3'

interface Crypt {
  id: string
  symbol: string
  coingecko_id: string
}

interface CoinGeckoPrice {
  jpy: number
}

serve(async (req) => {
  try {
    // CORSヘッダー設定
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers':
        'authorization, x-client-info, apikey, content-type',
    }

    // OPTIONSリクエストの処理
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders })
    }

    // Supabaseクライアント初期化（Service Role Key使用）
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    console.log('🚀 Starting price update...')

    // cryptsテーブルから全てのアクティブな暗号通貨を取得
    const { data: crypts, error: cryptsError } = await supabase
      .from('crypts')
      .select('id, symbol, coingecko_id')
      .eq('is_active', true)

    if (cryptsError) {
      throw new Error(`Failed to fetch crypts: ${cryptsError.message}`)
    }

    if (!crypts || crypts.length === 0) {
      return new Response(
        JSON.stringify({ message: 'No active cryptocurrencies found' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200,
        }
      )
    }

    console.log(`📊 Found ${crypts.length} active cryptocurrencies`)

    // CoinGecko IDのリストを作成
    const coingeckoIds = crypts
      .filter((c: Crypt) => c.coingecko_id)
      .map((c: Crypt) => c.coingecko_id)
      .join(',')

    if (!coingeckoIds) {
      throw new Error('No valid CoinGecko IDs found')
    }

    // CoinGecko API呼び出し（オプション: API Key使用）
    const apiKey = Deno.env.get('COINGECKO_API_KEY')
    const apiUrl = apiKey
      ? `${COINGECKO_API_URL}/simple/price?ids=${coingeckoIds}&vs_currencies=jpy&x_cg_demo_api_key=${apiKey}`
      : `${COINGECKO_API_URL}/simple/price?ids=${coingeckoIds}&vs_currencies=jpy`

    console.log('🌐 Fetching prices from CoinGecko...')
    const response = await fetch(apiUrl)

    if (!response.ok) {
      const errorText = await response.text()
      throw new Error(`CoinGecko API error (${response.status}): ${errorText}`)
    }

    const prices: Record<string, CoinGeckoPrice> = await response.json()
    console.log(
      `✅ Fetched prices for ${Object.keys(prices).length} cryptocurrencies`
    )

    // pricesテーブルにUPSERT
    const today = new Date().toISOString().split('T')[0]
    let successCount = 0
    let errorCount = 0

    for (const crypt of crypts as Crypt[]) {
      if (!crypt.coingecko_id || !prices[crypt.coingecko_id]) {
        console.warn(
          `⚠️  No price data for ${crypt.symbol} (${crypt.coingecko_id})`
        )
        errorCount++
        continue
      }

      const unitYen = prices[crypt.coingecko_id].jpy

      const { error: upsertError } = await supabase.from('prices').upsert(
        {
          crypt_id: crypt.id,
          exec_at: today,
          unit_yen: unitYen,
        },
        {
          onConflict: 'crypt_id,exec_at',
        }
      )

      if (upsertError) {
        console.error(
          `❌ Failed to upsert price for ${crypt.symbol}:`,
          upsertError.message
        )
        errorCount++
      } else {
        console.log(`💾 Updated ${crypt.symbol}: ¥${unitYen.toLocaleString()}`)
        successCount++
      }
    }

    const result = {
      success: true,
      message: 'Price update completed',
      timestamp: new Date().toISOString(),
      stats: {
        total: crypts.length,
        success: successCount,
        errors: errorCount,
      },
    }

    console.log('✨ Price update completed:', result.stats)

    return new Response(JSON.stringify(result), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 200,
    })
  } catch (error) {
    console.error('💥 Error:', error)

    return new Response(
      JSON.stringify({
        success: false,
        error:
          error instanceof Error ? error.message : 'Unknown error occurred',
      }),
      {
        headers: { 'Content-Type': 'application/json' },
        status: 500,
      }
    )
  }
})
