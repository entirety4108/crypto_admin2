import Link from 'next/link'
import { AuthForm } from '@/components/auth-form'

export default async function LoginPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params

  return (
    <main className="flex min-h-screen items-center justify-center p-6">
      <div className="w-full max-w-md space-y-4">
        <h1 className="text-center text-2xl font-semibold">ログイン</h1>
        <AuthForm mode="login" locale={locale} />
        <p className="text-center text-sm text-slate-600">
          アカウントがない場合は <Link className="underline" href={`/${locale}/register`}>新規登録</Link>
        </p>
        <p className="text-center text-sm text-slate-600">
          <Link className="underline" href={`/${locale}/reset-password`}>
            パスワードを忘れた場合
          </Link>
        </p>
      </div>
    </main>
  )
}
