'use server'

import { createClient as createSupabaseClient } from '@supabase/supabase-js'
import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { cryptSchema } from '@/lib/validation/admin'

/** Returns service_role client for writing to RLS-protected master tables */
function createServiceRoleClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

  if (!url || !serviceKey) {
    throw new Error('Supabase service role configuration is missing')
  }

  return createSupabaseClient(url, serviceKey)
}

/** Verifies the caller is authenticated (reads from user client) */
async function requireAuth() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    throw new Error('ログインが必要です')
  }

  return user
}

export async function createCryptAction(formData: FormData) {
  const locale = String(formData.get('locale') ?? 'ja')

  await requireAuth()

  const parsed = cryptSchema.safeParse({
    symbol: formData.get('symbol'),
    projectName: formData.get('project_name') || '',
    coingeckoId: formData.get('coingecko_id') || '',
    iconUrl: formData.get('icon_url') || '',
    color: formData.get('color') || '',
    isActive: true,
  })

  if (!parsed.success) {
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')
  }

  const supabase = createServiceRoleClient()
  const { error } = await supabase.from('crypts').insert({
    symbol: parsed.data.symbol.toUpperCase(),
    project_name: parsed.data.projectName || null,
    coingecko_id: parsed.data.coingeckoId || null,
    icon_url: parsed.data.iconUrl || null,
    color: parsed.data.color || null,
    is_active: true,
  })

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/crypts`)
}

export async function updateCryptAction(formData: FormData) {
  const id = String(formData.get('id') ?? '')
  const locale = String(formData.get('locale') ?? 'ja')

  if (!id) throw new Error('更新対象IDが不正です')

  await requireAuth()

  const parsed = cryptSchema.safeParse({
    symbol: formData.get('symbol'),
    projectName: formData.get('project_name') || '',
    coingeckoId: formData.get('coingecko_id') || '',
    iconUrl: formData.get('icon_url') || '',
    color: formData.get('color') || '',
    isActive: formData.get('is_active') === 'on',
  })

  if (!parsed.success) {
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')
  }

  const supabase = createServiceRoleClient()
  const { error } = await supabase
    .from('crypts')
    .update({
      symbol: parsed.data.symbol.toUpperCase(),
      project_name: parsed.data.projectName || null,
      coingecko_id: parsed.data.coingeckoId || null,
      icon_url: parsed.data.iconUrl || null,
      color: parsed.data.color || null,
      is_active: parsed.data.isActive,
    })
    .eq('id', id)

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/crypts`)
}
