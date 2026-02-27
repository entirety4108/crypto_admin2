import {
  createAccountAction,
  deleteAccountAction,
  updateAccountAction,
} from './actions'
import { createClient } from '@/lib/supabase/server'
import { AlertMessage } from '@/components/ui/alert-message'
import { EmptyState } from '@/components/ui/empty-state'

type Account = {
  id: string
  name: string
  memo: string | null
  icon_url: string | null
  is_locked: boolean | null
}

function hasIconUrl(iconUrl: string | null): iconUrl is string {
  return Boolean(iconUrl?.trim())
}

function getAvatarColor(name: string): string {
  const colors = [
    'bg-blue-500',
    'bg-emerald-500',
    'bg-violet-500',
    'bg-rose-500',
    'bg-amber-500',
    'bg-cyan-500',
    'bg-pink-500',
    'bg-indigo-500',
  ]
  let hash = 0
  for (let i = 0; i < name.length; i++) {
    hash = name.charCodeAt(i) + ((hash << 5) - hash)
  }
  return colors[Math.abs(hash) % colors.length] ?? 'bg-slate-500'
}

export default async function AccountsPage({
  params,
}: {
  params: Promise<{ locale: string }>
}) {
  const { locale } = await params
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return <AlertMessage variant="error" message="ログインが必要です。" />
  }

  const { data: accounts, error } = await supabase
    .from('accounts')
    .select('id,name,memo,icon_url,is_locked')
    .order('created_at', { ascending: false })

  if (error) {
    return <AlertMessage variant="error" message={error.message} />
  }

  return (
    <section className="space-y-6">
      <div className="border-b border-slate-200 pb-4">
        <h2 className="text-2xl font-bold text-slate-900">Accounts</h2>
        <p className="mt-1 text-sm text-slate-500">
          口座の登録・編集・ロック状態を管理できます。
        </p>
      </div>

      <details className="group rounded-xl border border-slate-200 bg-white shadow-sm">
        <summary className="flex cursor-pointer list-none items-center justify-between p-5 font-semibold text-slate-700 hover:bg-slate-50">
          <span>+ 新規アカウントを追加</span>
          <svg
            className="h-5 w-5 transition-transform group-open:rotate-180"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              strokeLinecap="round"
              strokeLinejoin="round"
              strokeWidth={2}
              d="M19 9l-7 7-7-7"
            />
          </svg>
        </summary>
        <form
          action={createAccountAction}
          className="grid gap-3 border-t bg-slate-50 p-5 md:grid-cols-2"
        >
          <input type="hidden" name="locale" value={locale} />
          <input
            name="name"
            placeholder="アカウント名"
            className="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 focus:outline-none"
            required
          />
          <input
            name="icon_url"
            placeholder="アイコンURL（任意）"
            className="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 focus:outline-none"
          />
          <input
            name="memo"
            placeholder="メモ（任意）"
            className="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 focus:outline-none md:col-span-2"
          />
          <label className="flex items-center gap-2 text-sm text-slate-600">
            <input type="checkbox" name="is_locked" />
            ロックする
          </label>
          <button
            className="rounded-lg bg-emerald-500 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-600"
            type="submit"
          >
            追加
          </button>
        </form>
      </details>

      <div className="space-y-3">
        {((accounts as Account[] | null)?.length ?? 0) === 0 ? (
          <EmptyState message="アカウントがまだありません。まずは1件追加してください。" />
        ) : (
          (accounts as Account[] | null)?.map((account) => (
            <details
              key={account.id}
              className="group overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm"
            >
              <summary className="flex cursor-pointer list-none items-center gap-4 p-5">
                {hasIconUrl(account.icon_url) ? (
                  // eslint-disable-next-line @next/next/no-img-element
                  <img
                    src={account.icon_url}
                    alt={`${account.name} icon`}
                    className="h-10 w-10 flex-shrink-0 rounded-full border border-slate-200 object-cover"
                    loading="lazy"
                  />
                ) : (
                  <div
                    className={`flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full text-sm font-bold text-white ${getAvatarColor(account.name)}`}
                  >
                    {account.name.slice(0, 2).toUpperCase()}
                  </div>
                )}
                <div className="min-w-0 flex-1">
                  <div className="flex items-center gap-2">
                    <span className="text-base font-semibold text-slate-900">
                      {account.name}
                    </span>
                    {account.is_locked && (
                      <span className="inline-flex items-center rounded-full bg-amber-100 px-2 py-0.5 text-xs font-medium text-amber-700">
                        🔒 ロック中
                      </span>
                    )}
                  </div>
                  {account.memo && (
                    <p className="mt-0.5 truncate text-sm text-slate-500">
                      {account.memo}
                    </p>
                  )}
                </div>
                <svg
                  className="h-5 w-5 flex-shrink-0 text-slate-400 transition-transform group-open:rotate-180"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    strokeLinecap="round"
                    strokeLinejoin="round"
                    strokeWidth={2}
                    d="M19 9l-7 7-7-7"
                  />
                </svg>
              </summary>
              <form
                action={updateAccountAction}
                className="grid gap-3 border-t bg-slate-50 p-5 md:grid-cols-2"
              >
                <input type="hidden" name="locale" value={locale} />
                <input type="hidden" name="id" value={account.id} />
                <input
                  name="name"
                  defaultValue={account.name}
                  className="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 focus:outline-none"
                  required
                />
                <input
                  name="icon_url"
                  defaultValue={account.icon_url ?? ''}
                  className="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 focus:outline-none"
                  placeholder="アイコンURL"
                />
                <input
                  name="memo"
                  defaultValue={account.memo ?? ''}
                  className="rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 focus:outline-none md:col-span-2"
                  placeholder="メモ"
                />
                <label className="flex items-center gap-2 text-sm text-slate-600">
                  <input
                    type="checkbox"
                    name="is_locked"
                    defaultChecked={Boolean(account.is_locked)}
                  />
                  ロック中
                </label>
                <div className="flex gap-2">
                  <button
                    className="rounded-lg bg-slate-700 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
                    type="submit"
                  >
                    更新
                  </button>
                  <button
                    className="rounded-lg border border-red-200 px-4 py-2 text-sm font-medium text-red-600 hover:bg-red-50"
                    type="submit"
                    formAction={deleteAccountAction}
                  >
                    削除
                  </button>
                </div>
              </form>
            </details>
          ))
        )}
      </div>
    </section>
  )
}
