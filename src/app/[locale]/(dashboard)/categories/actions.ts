'use server'

import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { categorySchema, userCryptCategorySchema } from '@/lib/validation/admin'

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

export async function createCategoryAction(formData: FormData) {
  const locale = String(formData.get('locale') ?? 'ja')
  const parsed = categorySchema.safeParse({
    name: formData.get('name'),
    color: formData.get('color') || '',
  })

  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase, userId } = await getUserId()
  const { error } = await supabase.from('crypt_categories').insert({
    user_id: userId,
    name: parsed.data.name,
    color: parsed.data.color || null,
  })

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/categories`)
}

export async function updateCategoryAction(formData: FormData) {
  const id = String(formData.get('id') ?? '')
  const locale = String(formData.get('locale') ?? 'ja')
  const parsed = categorySchema.safeParse({
    name: formData.get('name'),
    color: formData.get('color') || '',
  })

  if (!id) throw new Error('更新対象IDが不正です')
  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase } = await getUserId()
  const { error } = await supabase
    .from('crypt_categories')
    .update({
      name: parsed.data.name,
      color: parsed.data.color || null,
    })
    .eq('id', id)

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/categories`)
}

export async function deleteCategoryAction(formData: FormData) {
  const id = String(formData.get('id') ?? '')
  const locale = String(formData.get('locale') ?? 'ja')

  if (!id) throw new Error('削除対象IDが不正です')

  const { supabase } = await getUserId()
  const { error } = await supabase
    .from('crypt_categories')
    .delete()
    .eq('id', id)

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/categories`)
}

export async function createUserCryptCategoryAction(formData: FormData) {
  const locale = String(formData.get('locale') ?? 'ja')
  const parsed = userCryptCategorySchema.safeParse({
    cryptId: formData.get('crypt_id'),
    categoryId: formData.get('category_id'),
  })

  if (!parsed.success)
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')

  const { supabase, userId } = await getUserId()
  const { error } = await supabase.from('user_crypt_categories').insert({
    user_id: userId,
    crypt_id: parsed.data.cryptId,
    category_id: parsed.data.categoryId,
  })

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/categories`)
}

export async function deleteUserCryptCategoryAction(formData: FormData) {
  const id = String(formData.get('id') ?? '')
  const locale = String(formData.get('locale') ?? 'ja')

  if (!id) throw new Error('削除対象IDが不正です')

  const { supabase } = await getUserId()
  const { error } = await supabase
    .from('user_crypt_categories')
    .delete()
    .eq('id', id)

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/categories`)
}
