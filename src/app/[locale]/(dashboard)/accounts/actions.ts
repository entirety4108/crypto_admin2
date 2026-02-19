'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { accountSchema } from '@/lib/validation/admin'

async function getUserId() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    throw new Error('ログインが必要です')
  }

  return { supabase, userId: user.id }
}

export async function createAccountAction(formData: FormData) {
  const locale = String(formData.get('locale') ?? 'ja')
  const parsed = accountSchema.safeParse({
    name: formData.get('name'),
    memo: formData.get('memo') || undefined,
    iconUrl: formData.get('icon_url') || '',
    isLocked: formData.get('is_locked') === 'on',
  })

  if (!parsed.success) {
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')
  }

  const { supabase, userId } = await getUserId()
  const { error } = await supabase.from('accounts').insert({
    user_id: userId,
    name: parsed.data.name,
    memo: parsed.data.memo || null,
    icon_url: parsed.data.iconUrl || null,
    is_locked: parsed.data.isLocked,
  })

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/accounts`)
}

export async function updateAccountAction(formData: FormData) {
  const id = String(formData.get('id') ?? '')
  const locale = String(formData.get('locale') ?? 'ja')

  const parsed = accountSchema.safeParse({
    name: formData.get('name'),
    memo: formData.get('memo') || undefined,
    iconUrl: formData.get('icon_url') || '',
    isLocked: formData.get('is_locked') === 'on',
  })

  if (!id) throw new Error('更新対象IDが不正です')
  if (!parsed.success) {
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')
  }

  const { supabase } = await getUserId()
  const { error } = await supabase
    .from('accounts')
    .update({
      name: parsed.data.name,
      memo: parsed.data.memo || null,
      icon_url: parsed.data.iconUrl || null,
      is_locked: parsed.data.isLocked,
    })
    .eq('id', id)

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/accounts`)
}

export async function deleteAccountAction(formData: FormData) {
  const id = String(formData.get('id') ?? '')
  const locale = String(formData.get('locale') ?? 'ja')

  if (!id) throw new Error('削除対象IDが不正です')

  const { supabase } = await getUserId()
  const { error } = await supabase.from('accounts').delete().eq('id', id)

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/accounts`)
}
