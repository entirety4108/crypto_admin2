import { redirect } from 'next/navigation'
import { DashboardNav } from '@/components/dashboard-nav'
import { LanguageSwitcher } from '@/components/language-switcher'
import { createClient } from '@/lib/supabase/server'

export default async function DashboardLayout({
  children,
  params,
}: {
  children: React.ReactNode
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params
  let user: { id: string } | null = null

  try {
    const supabase = await createClient()
    const {
      data: { user: authUser },
    } = await supabase.auth.getUser()
    user = authUser
  } catch {
    user = null
  }

  if (!user) {
    redirect(`/${locale}/login`)
  }

  return (
    <div className="flex min-h-screen bg-slate-50">
      <aside className="fixed inset-y-0 left-0 z-20 flex w-64 flex-col bg-[#0f172a]">
        <div className="flex h-16 items-center border-b border-[#1e293b] px-6">
          <span className="text-lg font-bold text-white">₿ Crypto Admin</span>
        </div>
        <DashboardNav locale={locale} />
        <div className="mt-auto border-t border-[#1e293b] p-4">
          <LanguageSwitcher locale={locale} />
        </div>
      </aside>

      <div className="ml-64 flex min-h-screen flex-1 flex-col">
        <main className="mx-auto w-full max-w-7xl flex-1 p-8">{children}</main>
      </div>
    </div>
  )
}
