'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import {
  commissionSchema,
  purchaseSchema,
  sellSchema,
  swapSchema,
  transferSchema,
} from '@/lib/validation/transactions'

async function getAuthContext() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) throw new Error('ログインが必要です')
  return { supabase, userId: user.id }
}

function parseLocale(formData: FormData) {
  return String(formData.get('locale') ?? 'ja')
}

function revalidate(locale: string) {
  revalidatePath(`/${locale}/transactions`)
  revalidatePath(`/${locale}/portfolio`)
}

export async function createCommissionAction(formData: FormData) {
  const locale = parseLocale(formData)
  const parsed = commissionSchema.safeParse({
    execAt: formData.get('exec_at'),
    accountId: formData.get('account_id'),
    cryptId: formData.get('crypt_id'),
    unitYen: formData.get('unit_yen'),
    amount: formData.get('amount'),
    approximateYen: formData.get('approximate_yen'),
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase, userId } = await getAuthContext()
  const { error } = await supabase.from('commissions').insert({
    user_id: userId,
    exec_at: parsed.data.execAt,
    account_id: parsed.data.accountId,
    crypt_id: parsed.data.cryptId,
    unit_yen: parsed.data.unitYen,
    amount: parsed.data.amount,
    approximate_yen: parsed.data.approximateYen,
  })
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function createPurchaseAction(formData: FormData) {
  const locale = parseLocale(formData)
  const parsed = purchaseSchema.safeParse({
    execAt: formData.get('exec_at'),
    accountId: formData.get('account_id'),
    cryptId: formData.get('crypt_id'),
    unitYen: formData.get('unit_yen'),
    amount: formData.get('amount'),
    depositYen: formData.get('deposit_yen') || '0',
    purchaseYen: formData.get('purchase_yen'),
    type: formData.get('type'),
    commissionId: formData.get('commission_id') || '',
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase, userId } = await getAuthContext()
  const payload: Record<string, unknown> = {
    user_id: userId,
    exec_at: parsed.data.execAt,
    account_id: parsed.data.accountId,
    crypt_id: parsed.data.cryptId,
    unit_yen: parsed.data.unitYen,
    amount: parsed.data.amount,
    deposit_yen: parsed.data.depositYen,
    purchase_yen: parsed.data.purchaseYen,
    type: parsed.data.type,
    commission_id: parsed.data.commissionId || null,
  }

  const { error } = await supabase.from('purchases').insert(payload)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function createSellAction(formData: FormData) {
  const locale = parseLocale(formData)
  const parsed = sellSchema.safeParse({
    execAt: formData.get('exec_at'),
    accountId: formData.get('account_id'),
    cryptId: formData.get('crypt_id'),
    unitYen: formData.get('unit_yen'),
    amount: formData.get('amount'),
    yen: formData.get('yen'),
    type: 's',
    commissionId: formData.get('commission_id') || '',
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase, userId } = await getAuthContext()
  const { error } = await supabase.from('sells').insert({
    user_id: userId,
    exec_at: parsed.data.execAt,
    account_id: parsed.data.accountId,
    crypt_id: parsed.data.cryptId,
    unit_yen: parsed.data.unitYen,
    amount: parsed.data.amount,
    yen: parsed.data.yen,
    type: parsed.data.type,
    commission_id: parsed.data.commissionId || null,
  })
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function createTransferAction(formData: FormData) {
  const locale = parseLocale(formData)
  const parsed = transferSchema.safeParse({
    execAt: formData.get('exec_at'),
    fromAccountId: formData.get('from_account_id'),
    toAccountId: formData.get('to_account_id'),
    cryptId: formData.get('crypt_id'),
    amount: formData.get('amount'),
    commissionId: formData.get('commission_id') || '',
    memo: formData.get('memo') || undefined,
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase, userId } = await getAuthContext()
  const { error } = await supabase.from('transfers').insert({
    user_id: userId,
    exec_at: parsed.data.execAt,
    from_account_id: parsed.data.fromAccountId,
    to_account_id: parsed.data.toAccountId,
    crypt_id: parsed.data.cryptId,
    amount: parsed.data.amount,
    commission_id: parsed.data.commissionId || null,
    memo: parsed.data.memo || null,
  })
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function createSwapAction(formData: FormData) {
  const locale = parseLocale(formData)
  const parsed = swapSchema.safeParse({
    execAt: formData.get('exec_at'),
    sellAccountId: formData.get('sell_account_id'),
    sellCryptId: formData.get('sell_crypt_id'),
    sellUnitYen: formData.get('sell_unit_yen'),
    sellAmount: formData.get('sell_amount'),
    sellYen: formData.get('sell_yen'),
    buyAccountId: formData.get('buy_account_id'),
    buyCryptId: formData.get('buy_crypt_id'),
    buyUnitYen: formData.get('buy_unit_yen'),
    buyAmount: formData.get('buy_amount'),
    buyDepositYen: formData.get('buy_deposit_yen') || '0',
    buyPurchaseYen: formData.get('buy_purchase_yen'),
    commissionId: formData.get('commission_id') || '',
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase, userId } = await getAuthContext()

  const { data: sellTx, error: sellError } = await supabase
    .from('sells')
    .insert({
      user_id: userId,
      exec_at: parsed.data.execAt,
      account_id: parsed.data.sellAccountId,
      crypt_id: parsed.data.sellCryptId,
      unit_yen: parsed.data.sellUnitYen,
      amount: parsed.data.sellAmount,
      yen: parsed.data.sellYen,
      type: 'w',
      commission_id: parsed.data.commissionId || null,
    })
    .select('id')
    .single()
  if (sellError) throw new Error(sellError.message)

  const { data: buyTx, error: buyError } = await supabase
    .from('purchases')
    .insert({
      user_id: userId,
      exec_at: parsed.data.execAt,
      account_id: parsed.data.buyAccountId,
      crypt_id: parsed.data.buyCryptId,
      unit_yen: parsed.data.buyUnitYen,
      amount: parsed.data.buyAmount,
      deposit_yen: parsed.data.buyDepositYen,
      purchase_yen: parsed.data.buyPurchaseYen,
      type: 's',
    })
    .select('id')
    .single()

  if (buyError) {
    await supabase.from('sells').delete().eq('id', sellTx.id)
    throw new Error(buyError.message)
  }

  const { error: swapError } = await supabase.from('swaps').insert({
    user_id: userId,
    buy_tx_id: buyTx.id,
    sell_tx_id: sellTx.id,
  })
  if (swapError) {
    await supabase.from('purchases').delete().eq('id', buyTx.id)
    await supabase.from('sells').delete().eq('id', sellTx.id)
    throw new Error(swapError.message)
  }

  revalidate(locale)
}

export async function updatePurchaseAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('更新対象IDが不正です')

  const parsed = purchaseSchema.safeParse({
    execAt: formData.get('exec_at'),
    accountId: formData.get('account_id'),
    cryptId: formData.get('crypt_id'),
    unitYen: formData.get('unit_yen'),
    amount: formData.get('amount'),
    depositYen: formData.get('deposit_yen') || '0',
    purchaseYen: formData.get('purchase_yen'),
    type: formData.get('type'),
    commissionId: formData.get('commission_id') || '',
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase } = await getAuthContext()
  const payload: Record<string, unknown> = {
    exec_at: parsed.data.execAt,
    account_id: parsed.data.accountId,
    crypt_id: parsed.data.cryptId,
    unit_yen: parsed.data.unitYen,
    amount: parsed.data.amount,
    deposit_yen: parsed.data.depositYen,
    purchase_yen: parsed.data.purchaseYen,
    type: parsed.data.type,
    commission_id: parsed.data.commissionId || null,
  }

  const { error } = await supabase
    .from('purchases')
    .update(payload)
    .eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function updateSellAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('更新対象IDが不正です')

  const parsed = sellSchema.safeParse({
    execAt: formData.get('exec_at'),
    accountId: formData.get('account_id'),
    cryptId: formData.get('crypt_id'),
    unitYen: formData.get('unit_yen'),
    amount: formData.get('amount'),
    yen: formData.get('yen'),
    type: 's',
    commissionId: formData.get('commission_id') || '',
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase } = await getAuthContext()
  const { error } = await supabase
    .from('sells')
    .update({
      exec_at: parsed.data.execAt,
      account_id: parsed.data.accountId,
      crypt_id: parsed.data.cryptId,
      unit_yen: parsed.data.unitYen,
      amount: parsed.data.amount,
      yen: parsed.data.yen,
      type: 's',
      commission_id: parsed.data.commissionId || null,
    })
    .eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function updateTransferAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('更新対象IDが不正です')

  const parsed = transferSchema.safeParse({
    execAt: formData.get('exec_at'),
    fromAccountId: formData.get('from_account_id'),
    toAccountId: formData.get('to_account_id'),
    cryptId: formData.get('crypt_id'),
    amount: formData.get('amount'),
    commissionId: formData.get('commission_id') || '',
    memo: formData.get('memo') || undefined,
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase } = await getAuthContext()
  const { error } = await supabase
    .from('transfers')
    .update({
      exec_at: parsed.data.execAt,
      from_account_id: parsed.data.fromAccountId,
      to_account_id: parsed.data.toAccountId,
      crypt_id: parsed.data.cryptId,
      amount: parsed.data.amount,
      commission_id: parsed.data.commissionId || null,
      memo: parsed.data.memo || null,
    })
    .eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function deletePurchaseAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('削除対象IDが不正です')

  const { supabase } = await getAuthContext()
  const { error } = await supabase.from('purchases').delete().eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function deleteSellAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('削除対象IDが不正です')

  const { supabase } = await getAuthContext()
  const { error } = await supabase.from('sells').delete().eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function deleteTransferAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('削除対象IDが不正です')

  const { supabase } = await getAuthContext()
  const { error } = await supabase.from('transfers').delete().eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function deleteCommissionAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('削除対象IDが不正です')

  const { supabase } = await getAuthContext()

  await supabase
    .from('purchases')
    .update({ commission_id: null })
    .eq('commission_id', id)
  await supabase
    .from('sells')
    .update({ commission_id: null })
    .eq('commission_id', id)
  await supabase
    .from('transfers')
    .update({ commission_id: null })
    .eq('commission_id', id)

  const { error } = await supabase.from('commissions').delete().eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function updateCommissionAction(formData: FormData) {
  const locale = parseLocale(formData)
  const id = String(formData.get('id') ?? '')
  if (!id) throw new Error('更新対象IDが不正です')

  const parsed = commissionSchema.safeParse({
    execAt: formData.get('exec_at'),
    accountId: formData.get('account_id'),
    cryptId: formData.get('crypt_id'),
    unitYen: formData.get('unit_yen'),
    amount: formData.get('amount'),
    approximateYen: formData.get('approximate_yen'),
  })
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase } = await getAuthContext()
  const { error } = await supabase
    .from('commissions')
    .update({
      exec_at: parsed.data.execAt,
      account_id: parsed.data.accountId,
      crypt_id: parsed.data.cryptId,
      unit_yen: parsed.data.unitYen,
      amount: parsed.data.amount,
      approximate_yen: parsed.data.approximateYen,
    })
    .eq('id', id)
  if (error) throw new Error(error.message)

  revalidate(locale)
}

export async function deleteSwapAction(formData: FormData) {
  const locale = parseLocale(formData)
  const swapId = String(formData.get('swap_id') ?? '')
  const buyTxId = String(formData.get('buy_tx_id') ?? '')
  const sellTxId = String(formData.get('sell_tx_id') ?? '')

  if (!swapId || !buyTxId || !sellTxId) throw new Error('削除対象IDが不正です')

  const { supabase } = await getAuthContext()
  await supabase.from('swaps').delete().eq('id', swapId)
  await supabase.from('purchases').delete().eq('id', buyTxId)
  await supabase.from('sells').delete().eq('id', sellTxId)

  revalidate(locale)
}
