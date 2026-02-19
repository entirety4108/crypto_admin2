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
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    redirect(`/${locale}/login`)
  }

  return (
    <div className="min-h-screen bg-slate-50">
      <header className="flex items-center justify-between border-b bg-white px-6 py-3">
        <h1 className="text-lg font-semibold">Crypto Admin</h1>
        <LanguageSwitcher locale={locale} />
      </header>
      <div className="mx-auto grid max-w-7xl grid-cols-1 gap-6 p-6 md:grid-cols-[220px_1fr]">
        <aside className="rounded-lg border bg-white">
          <DashboardNav locale={locale} />
        </aside>
        <main className="rounded-lg border bg-white p-6">{children}</main>
      </div>
    </div>
  )
}
