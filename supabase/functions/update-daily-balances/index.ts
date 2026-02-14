// update-daily-balances Edge Function
// 日次残高スナップショットをdaily_balancesテーブルに保存

import { serve } from 'https://deno.land/std@0.168.0/http/server.ts'
import { createClient } from 'https://esm.sh/@supabase/supabase-js@2.39.3'

interface Balance {
  user_id: string
  account_id: string
  crypt_id: string
  amount: number
}

interface Price {
  crypt_id: string
  price_jpy: number
}

serve(async (req) => {
  try {
    // CORSヘッダー設定
    const corsHeaders = {
      'Access-Control-Allow-Origin': '*',
      'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
    }

    // OPTIONSリクエストの処理
    if (req.method === 'OPTIONS') {
      return new Response('ok', { headers: corsHeaders })
    }

    // Supabaseクライアント初期化（Service Role Key使用）
    const supabaseUrl = Deno.env.get('SUPABASE_URL')!
    const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    console.log('🚀 Starting daily balance update...')

    const today = new Date().toISOString().split('T')[0]
    const jobName = 'update-daily-balances'

    // 冪等性チェック: 今日のジョブが既に実行済みか確認
    const { data: existingJob } = await supabase
      .from('job_runs')
      .select('id')
      .eq('job_name', jobName)
      .eq('run_date', today)
      .eq('status', 'completed')
      .single()

    if (existingJob) {
      console.log('✅ Job already completed for today')
      return new Response(
        JSON.stringify({ message: 'Job already completed for today', date: today }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200
        }
      )
    }

    // Advisory lockを取得（同時実行を防止）
    const lockKey = 12345 // update-daily-balances用の固有キー
    const { data: lockAcquired } = await supabase
      .rpc('pg_try_advisory_lock', { key: lockKey })

    if (!lockAcquired) {
      console.log('⚠️  Another instance is running, skipping...')
      return new Response(
        JSON.stringify({ message: 'Another instance is running' }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 409
        }
      )
    }

    try {
      // ジョブ開始を記録
      const { data: jobRun } = await supabase
        .from('job_runs')
        .insert({
          job_name: jobName,
          run_date: today,
          status: 'running',
        })
        .select()
        .single()

      console.log('📊 Calculating balances for all users...')

      // 全ユーザーのリストを取得
      const { data: users, error: usersError } = await supabase.auth.admin.listUsers()

      if (usersError) {
        throw new Error(`Failed to fetch users: ${usersError.message}`)
      }

      let totalBalances = 0

      for (const user of users.users) {
        const userId = user.id

        // ユーザーの全アカウント × 暗号資産の残高を計算
        const balances = await calculateUserBalances(supabase, userId)

        // 最新価格を取得
        const { data: prices, error: pricesError } = await supabase
          .from('prices')
          .select('crypt_id, price_jpy')
          .order('fetched_at', { ascending: false })
          .limit(100)

        if (pricesError) {
          console.error(`Failed to fetch prices: ${pricesError.message}`)
          continue
        }

        const priceMap = new Map<string, number>()
        const seenCrypts = new Set<string>()

        for (const price of prices as Price[]) {
          if (!seenCrypts.has(price.crypt_id)) {
            priceMap.set(price.crypt_id, price.price_jpy)
            seenCrypts.add(price.crypt_id)
          }
        }

        // daily_balancesにUPSERT
        for (const balance of balances) {
          if (balance.amount <= 0) continue

          const unitPrice = priceMap.get(balance.crypt_id) || 0
          const valuation = balance.amount * unitPrice

          const { error: upsertError } = await supabase
            .from('daily_balances')
            .upsert({
              user_id: balance.user_id,
              account_id: balance.account_id,
              crypt_id: balance.crypt_id,
              date: today,
              amount: balance.amount,
              unit_price: unitPrice,
              valuation: valuation,
            }, {
              onConflict: 'user_id,account_id,crypt_id,date'
            })

          if (upsertError) {
            console.error(`Failed to upsert balance: ${upsertError.message}`)
          } else {
            totalBalances++
          }
        }
      }

      console.log(`✅ Updated ${totalBalances} daily balances`)

      // ジョブ完了を記録
      await supabase
        .from('job_runs')
        .update({ status: 'completed', completed_at: new Date().toISOString() })
        .eq('id', jobRun!.id)

      return new Response(
        JSON.stringify({
          message: 'Daily balances updated successfully',
          date: today,
          total_balances: totalBalances
        }),
        {
          headers: { ...corsHeaders, 'Content-Type': 'application/json' },
          status: 200
        }
      )
    } finally {
      // Advisory lockを解放
      await supabase.rpc('pg_advisory_unlock', { key: lockKey })
    }
  } catch (error) {
    console.error('❌ Error:', error)
    return new Response(
      JSON.stringify({ error: error.message }),
      {
        headers: { 'Content-Type': 'application/json' },
        status: 500
      }
    )
  }
})

async function calculateUserBalances(
  supabase: any,
  userId: string
): Promise<Balance[]> {
  // 購入（入金）を取得
  const { data: purchases } = await supabase
    .from('purchases')
    .select('account_id, crypt_id, amount')
    .eq('user_id', userId)

  // 売却を取得
  const { data: sells } = await supabase
    .from('sells')
    .select('account_id, crypt_id, amount')
    .eq('user_id', userId)

  // 振替（送付元）を取得
  const { data: transfersOut } = await supabase
    .from('transfers')
    .select('from_account_id, crypt_id, amount')
    .eq('user_id', userId)

  // 振替（送付先）を取得
  const { data: transfersIn } = await supabase
    .from('transfers')
    .select('to_account_id, crypt_id, amount')
    .eq('user_id', userId)

  // 残高を計算
  const balanceMap = new Map<string, number>()

  const addBalance = (accountId: string, cryptId: string, amount: number) => {
    const key = `${accountId}:${cryptId}`
    balanceMap.set(key, (balanceMap.get(key) || 0) + amount)
  }

  // 購入: 残高増加
  for (const p of purchases || []) {
    addBalance(p.account_id, p.crypt_id, p.amount)
  }

  // 売却: 残高減少
  for (const s of sells || []) {
    addBalance(s.account_id, s.crypt_id, -s.amount)
  }

  // 振替出: 残高減少
  for (const t of transfersOut || []) {
    addBalance(t.from_account_id, t.crypt_id, -t.amount)
  }

  // 振替入: 残高増加
  for (const t of transfersIn || []) {
    addBalance(t.to_account_id, t.crypt_id, t.amount)
  }

  // Map to Array
  const balances: Balance[] = []
  for (const [key, amount] of balanceMap.entries()) {
    const [accountId, cryptId] = key.split(':')
    balances.push({
      user_id: userId,
      account_id: accountId,
      crypt_id: cryptId,
      amount: amount,
    })
  }

  return balances
}
