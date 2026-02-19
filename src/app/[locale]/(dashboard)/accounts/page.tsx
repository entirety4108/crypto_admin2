import {
  createAccountAction,
  deleteAccountAction,
  updateAccountAction,
} from './actions'
import { createClient } from '@/lib/supabase/server'

type Account = {
  id: string
  name: string
  memo: string | null
  icon_url: string | null
  is_locked: boolean | null
}

export default async function AccountsPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return <p className="text-sm text-red-600">ログインが必要です。</p>
  }

  const { data: accounts, error } = await supabase
    .from('accounts')
    .select('id,name,memo,icon_url,is_locked')
    .order('created_at', { ascending: false })

  if (error) {
    return <p className="text-sm text-red-600">{error.message}</p>
  }

  return (
    <section className="space-y-8">
      <div>
        <h2 className="text-xl font-semibold">Accounts</h2>
        <p className="text-sm text-slate-600">取引所・ウォレットを管理します。</p>
      </div>

      <form action={createAccountAction} className="grid gap-3 rounded-lg border p-4 md:grid-cols-2">
        <input type="hidden" name="locale" value={locale} />
        <input name="name" placeholder="アカウント名" className="rounded border px-3 py-2" required />
        <input name="icon_url" placeholder="アイコンURL（任意）" className="rounded border px-3 py-2" />
        <input name="memo" placeholder="メモ（任意）" className="rounded border px-3 py-2 md:col-span-2" />
        <label className="flex items-center gap-2 text-sm">
          <input type="checkbox" name="is_locked" />
          ロックする
        </label>
        <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">
          追加
        </button>
      </form>

      <div className="space-y-3">
        {(accounts as Account[] | null)?.map((account) => (
          <form key={account.id} action={updateAccountAction} className="grid gap-2 rounded-lg border p-4 md:grid-cols-2">
            <input type="hidden" name="locale" value={locale} />
            <input type="hidden" name="id" value={account.id} />
            <input name="name" defaultValue={account.name} className="rounded border px-3 py-2" required />
            <input
              name="icon_url"
              defaultValue={account.icon_url ?? ''}
              className="rounded border px-3 py-2"
              placeholder="アイコンURL"
            />
            <input
              name="memo"
              defaultValue={account.memo ?? ''}
              className="rounded border px-3 py-2 md:col-span-2"
              placeholder="メモ"
            />
            <label className="flex items-center gap-2 text-sm">
              <input type="checkbox" name="is_locked" defaultChecked={Boolean(account.is_locked)} />
              ロック中
            </label>
            <div className="flex gap-2">
              <button className="rounded border px-3 py-2 text-sm" type="submit">
                更新
              </button>
              <button
                className="rounded border border-red-300 px-3 py-2 text-sm text-red-700"
                type="submit"
                formAction={deleteAccountAction}
              >
                削除
              </button>
            </div>
          </form>
        ))}
      </div>
    </section>
  )
}
