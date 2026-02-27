import { redirect } from 'next/navigation'
import { createClient } from '@/lib/supabase/server'

export default async function LocaleRootPage({
  params,
}: {
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params
  let isLoggedIn = false

  try {
    const supabase = await createClient()
    const {
      data: { user },
    } = await supabase.auth.getUser()
    isLoggedIn = Boolean(user)
  } catch {
    isLoggedIn = false
  }

  redirect(`/${locale}/${isLoggedIn ? 'portfolio' : 'login'}`)
}
