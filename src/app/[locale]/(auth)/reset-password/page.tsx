import Link from 'next/link'
import { AuthForm } from '@/components/auth-form'

export default async function ResetPasswordPage({
  params,
}: {
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params

  return (
    <main className="flex min-h-screen items-center justify-center p-6">
      <div className="w-full max-w-md space-y-4">
        <h1 className="text-center text-2xl font-semibold">
          パスワードリセット
        </h1>
        <AuthForm mode="reset" locale={locale} />
        <p className="text-center text-sm text-slate-600">
          <Link className="underline" href={`/${locale}/login`}>
            ログイン画面に戻る
          </Link>
        </p>
      </div>
    </main>
  )
}
