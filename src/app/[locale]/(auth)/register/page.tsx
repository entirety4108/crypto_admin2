import Link from 'next/link'
import { AuthForm } from '@/components/auth-form'

export default async function RegisterPage({
  params,
}: {
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params

  return (
    <main className="flex min-h-screen items-center justify-center p-6">
      <div className="w-full max-w-md space-y-4">
        <h1 className="text-center text-2xl font-semibold">新規登録</h1>
        <AuthForm mode="register" locale={locale} />
        <p className="text-center text-sm text-slate-600">
          既にアカウントがある場合は{' '}
          <Link className="underline" href={`/${locale}/login`}>
            ログイン
          </Link>
        </p>
      </div>
    </main>
  )
}
