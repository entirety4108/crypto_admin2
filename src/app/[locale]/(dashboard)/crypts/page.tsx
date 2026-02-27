import { createCryptAction, updateCryptAction } from './actions'
import { createClient } from '@/lib/supabase/server'
import { AlertMessage } from '@/components/ui/alert-message'
import { EmptyState } from '@/components/ui/empty-state'

type Crypt = {
  id: string
  symbol: string
  project_name: string | null
  icon_url: string | null
  color: string | null
  coingecko_id: string | null
  is_active: boolean
}

function getCryptColor(color: string | null): string {
  return color && color.trim() ? color : '#6366f1'
}

export default async function CryptsPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return <AlertMessage variant='error' message='ログインが必要です。' />
  }

  const { data: crypts, error } = await supabase
    .from('crypts')
    .select('id,symbol,project_name,icon_url,color,coingecko_id,is_active')
    .order('symbol')

  if (error) {
    return <AlertMessage variant='error' message={error.message} />
  }

  const cryptList = (crypts as Crypt[] | null) ?? []

  return (
    <section className='space-y-6'>
      <div className='border-b border-slate-200 pb-4'>
        <h2 className='text-2xl font-bold text-slate-900'>Crypts</h2>
        <p className='mt-1 text-sm text-slate-500'>暗号通貨マスターの登録・編集・有効無効の切り替えができます。</p>
      </div>

      {/* Add Crypt Form */}
      <details className='group rounded-xl border border-slate-200 bg-white shadow-sm'>
        <summary className='flex cursor-pointer list-none items-center justify-between p-5 font-semibold text-slate-700 hover:bg-slate-50'>
          <span>+ 新規通貨を追加</span>
          <svg
            className='h-5 w-5 transition-transform group-open:rotate-180'
            fill='none'
            viewBox='0 0 24 24'
            stroke='currentColor'
          >
            <path strokeLinecap='round' strokeLinejoin='round' strokeWidth={2} d='M19 9l-7 7-7-7' />
          </svg>
        </summary>
        <form
          action={createCryptAction}
          className='grid gap-3 border-t bg-slate-50 p-5 md:grid-cols-2'
        >
          <input type='hidden' name='locale' value={locale} />
          <div>
            <label className='mb-1 block text-xs font-medium text-slate-600'>
              シンボル <span className='text-red-500'>*</span>
            </label>
            <input
              name='symbol'
              placeholder='例: BTC, ETH'
              className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
              required
            />
          </div>
          <div>
            <label className='mb-1 block text-xs font-medium text-slate-600'>プロジェクト名</label>
            <input
              name='project_name'
              placeholder='例: Bitcoin, Ethereum'
              className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
            />
          </div>
          <div>
            <label className='mb-1 block text-xs font-medium text-slate-600'>CoinGecko ID</label>
            <input
              name='coingecko_id'
              placeholder='例: bitcoin, ethereum'
              className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
            />
          </div>
          <div>
            <label className='mb-1 block text-xs font-medium text-slate-600'>アイコン URL</label>
            <input
              name='icon_url'
              placeholder='https://example.com/icon.png'
              className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
            />
          </div>
          <div className='flex items-end gap-3'>
            <div>
              <label className='mb-1 block text-xs font-medium text-slate-600'>カラー</label>
              <input
                name='color'
                type='color'
                defaultValue='#6366f1'
                className='h-10 w-14 cursor-pointer rounded-lg border border-slate-200 bg-white p-1'
              />
            </div>
            <button
              className='flex-1 rounded-lg bg-emerald-500 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-600'
              type='submit'
            >
              追加
            </button>
          </div>
        </form>
      </details>

      {/* Crypt Cards */}
      <div className='space-y-3'>
        {cryptList.length === 0 ? (
          <EmptyState message='通貨がまだ登録されていません。' />
        ) : (
          cryptList.map((crypt) => {
            const cryptColor = getCryptColor(crypt.color)
            return (
              <details
                key={crypt.id}
                className='group overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm'
              >
                <summary className='flex cursor-pointer list-none items-center gap-4 p-5 hover:bg-slate-50'>
                  <div
                    className='h-3 w-3 flex-shrink-0 rounded-full'
                    style={{ backgroundColor: cryptColor }}
                  />
                  <div className='min-w-0 flex-1'>
                    <div className='flex items-center gap-2'>
                      <span
                        className={
                          crypt.is_active
                            ? 'text-base font-semibold text-slate-900'
                            : 'text-base font-semibold text-slate-400'
                        }
                      >
                        {crypt.symbol}
                      </span>
                      {crypt.project_name && (
                        <span className='text-sm text-slate-500'>{crypt.project_name}</span>
                      )}
                      {!crypt.is_active && (
                        <span className='inline-flex items-center rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-500'>
                          無効
                        </span>
                      )}
                    </div>
                    {crypt.coingecko_id && (
                      <p className='mt-0.5 text-xs text-slate-400'>CoinGecko: {crypt.coingecko_id}</p>
                    )}
                  </div>
                  <svg
                    className='h-5 w-5 flex-shrink-0 text-slate-400 transition-transform group-open:rotate-180'
                    fill='none'
                    viewBox='0 0 24 24'
                    stroke='currentColor'
                  >
                    <path strokeLinecap='round' strokeLinejoin='round' strokeWidth={2} d='M19 9l-7 7-7-7' />
                  </svg>
                </summary>

                <form
                  action={updateCryptAction}
                  className='grid gap-3 border-t bg-slate-50 p-5 md:grid-cols-2'
                >
                  <input type='hidden' name='locale' value={locale} />
                  <input type='hidden' name='id' value={crypt.id} />
                  <div>
                    <label className='mb-1 block text-xs font-medium text-slate-600'>
                      シンボル <span className='text-red-500'>*</span>
                    </label>
                    <input
                      name='symbol'
                      defaultValue={crypt.symbol}
                      className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
                      required
                    />
                  </div>
                  <div>
                    <label className='mb-1 block text-xs font-medium text-slate-600'>プロジェクト名</label>
                    <input
                      name='project_name'
                      defaultValue={crypt.project_name ?? ''}
                      className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
                    />
                  </div>
                  <div>
                    <label className='mb-1 block text-xs font-medium text-slate-600'>CoinGecko ID</label>
                    <input
                      name='coingecko_id'
                      defaultValue={crypt.coingecko_id ?? ''}
                      className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
                    />
                  </div>
                  <div>
                    <label className='mb-1 block text-xs font-medium text-slate-600'>アイコン URL</label>
                    <input
                      name='icon_url'
                      defaultValue={crypt.icon_url ?? ''}
                      className='w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500'
                    />
                  </div>
                  <div className='flex items-end gap-3'>
                    <div>
                      <label className='mb-1 block text-xs font-medium text-slate-600'>カラー</label>
                      <input
                        name='color'
                        type='color'
                        defaultValue={cryptColor}
                        className='h-10 w-14 cursor-pointer rounded-lg border border-slate-200 bg-white p-1'
                      />
                    </div>
                    <label className='flex items-center gap-2 text-sm text-slate-600'>
                      <input
                        type='checkbox'
                        name='is_active'
                        defaultChecked={crypt.is_active}
                        className='rounded'
                      />
                      有効
                    </label>
                  </div>
                  <div className='flex items-end'>
                    <button
                      className='w-full rounded-lg bg-slate-700 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800'
                      type='submit'
                    >
                      更新
                    </button>
                  </div>
                </form>
              </details>
            )
          })
        )}
      </div>
    </section>
  )
}
