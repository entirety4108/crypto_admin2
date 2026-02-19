'use client'

import { FormEvent, useState } from 'react'
import { useRouter } from 'next/navigation'
import { Input } from '@/components/ui/input'
import { Button } from '@/components/ui/button'
import { createClient } from '@/lib/supabase/client'

type Mode = 'login' | 'register' | 'reset'

export function AuthForm({ mode, locale }: { mode: Mode; locale: string }) {
  const router = useRouter()
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [loading, setLoading] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)

  const isReset = mode === 'reset'

  const onSubmit = async (event: FormEvent<HTMLFormElement>) => {
    event.preventDefault()
    setLoading(true)
    setMessage(null)
    setError(null)

    try {
      const supabase = createClient()

      if (mode === 'login') {
        const { error: loginError } = await supabase.auth.signInWithPassword({ email, password })

        if (loginError) throw loginError

        router.push(`/${locale}/portfolio`)
        router.refresh()
        return
      }

      if (mode === 'register') {
        const { error: registerError } = await supabase.auth.signUp({ email, password })

        if (registerError) throw registerError

        router.push(`/${locale}/portfolio`)
        router.refresh()
        return
      }

      const { error: resetError } = await supabase.auth.resetPasswordForEmail(email, {
        redirectTo: `${window.location.origin}/${locale}/login`,
      })

      if (resetError) throw resetError

      setMessage('パスワードリセットメールを送信しました。')
    } catch (submitError) {
      const text = submitError instanceof Error ? submitError.message : '認証に失敗しました。'
      setError(text)
    } finally {
      setLoading(false)
    }
  }

  return (
    <form onSubmit={onSubmit} className="mx-auto w-full max-w-md space-y-4 rounded-lg border border-slate-200 p-6">
      <Input
        type="email"
        value={email}
        onChange={(event) => setEmail(event.target.value)}
        placeholder="Email"
        required
      />
      {!isReset && (
        <Input
          type="password"
          value={password}
          onChange={(event) => setPassword(event.target.value)}
          placeholder="Password"
          required
          minLength={8}
        />
      )}
      {error && <p className="text-sm text-red-600">{error}</p>}
      {message && <p className="text-sm text-emerald-600">{message}</p>}
      <Button disabled={loading} className="w-full" type="submit">
        {loading ? '処理中...' : mode === 'login' ? 'ログイン' : mode === 'register' ? '新規登録' : 'リセットメール送信'}
      </Button>
    </form>
  )
}
