import {
  createCategoryAction,
  createUserCryptCategoryAction,
  deleteCategoryAction,
  deleteUserCryptCategoryAction,
  updateCategoryAction,
} from './actions'
import { createClient } from '@/lib/supabase/server'
import { AlertMessage } from '@/components/ui/alert-message'
import { EmptyState } from '@/components/ui/empty-state'

type Category = {
  id: string
  name: string
  color: string | null
}

type Crypt = {
  id: string
  symbol: string
  project_name: string | null
}

type Mapping = {
  id: string
  crypt_id: string
  category_id: string
}

function getCategoryColor(color: string | null): string {
  return color && color.trim() ? color : '#6366f1'
}

function getCryptLabel(crypt: Crypt): string {
  return crypt.project_name ? `${crypt.symbol} (${crypt.project_name})` : crypt.symbol
}

function buildCategoryMappingsMap(mappings: Mapping[]): Map<string, Mapping[]> {
  const map = new Map<string, Mapping[]>()
  for (const mapping of mappings) {
    const current = map.get(mapping.category_id) ?? []
    map.set(mapping.category_id, [...current, mapping])
  }
  return map
}

function buildCryptMap(crypts: Crypt[]): Map<string, Crypt> {
  return new Map(crypts.map((crypt) => [crypt.id, crypt]))
}

export default async function CategoriesPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return <AlertMessage variant="error" message="ログインが必要です。" />
  }

  const [categoriesRes, cryptsRes, mappingsRes] = await Promise.all([
    supabase.from('crypt_categories').select('id,name,color').order('created_at', { ascending: false }),
    supabase.from('crypts').select('id,symbol,project_name').eq('is_active', true).order('symbol'),
    supabase
      .from('user_crypt_categories')
      .select('id,crypt_id,category_id')
      .order('created_at', { ascending: false }),
  ])

  if (categoriesRes.error || cryptsRes.error || mappingsRes.error) {
    const message = categoriesRes.error?.message || cryptsRes.error?.message || mappingsRes.error?.message
    return <AlertMessage variant="error" message={message ?? '取得に失敗しました'} />
  }

  const categories = (categoriesRes.data as Category[] | null) ?? []
  const crypts = (cryptsRes.data as Crypt[] | null) ?? []
  const mappings = (mappingsRes.data as Mapping[] | null) ?? []

  const categoryMappingsMap = buildCategoryMappingsMap(mappings)
  const cryptMap = buildCryptMap(crypts)
  const allLinkedCryptIds = new Set(mappings.map((m) => m.crypt_id))

  return (
    <section className="space-y-6">
      <div className="border-b border-slate-200 pb-4">
        <h2 className="text-2xl font-bold text-slate-900">Categories</h2>
        <p className="mt-1 text-sm text-slate-500">カテゴリ管理と通貨の紐づけを設定できます。</p>
      </div>

      {/* Add Category Form */}
      <details className="group rounded-xl border border-slate-200 bg-white shadow-sm">
        <summary className="flex cursor-pointer list-none items-center justify-between p-5 font-semibold text-slate-700 hover:bg-slate-50">
          <span>+ 新規カテゴリを追加</span>
          <svg
            className="h-5 w-5 transition-transform group-open:rotate-180"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
          </svg>
        </summary>
        <form
          action={createCategoryAction}
          className="flex flex-wrap items-end gap-3 border-t bg-slate-50 p-5"
        >
          <input type="hidden" name="locale" value={locale} />
          <div className="flex-1 min-w-[180px]">
            <label className="mb-1 block text-xs font-medium text-slate-600">カテゴリ名</label>
            <input
              name="name"
              placeholder="例: DeFi, Layer1"
              className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
              required
            />
          </div>
          <div>
            <label className="mb-1 block text-xs font-medium text-slate-600">カラー</label>
            <input
              name="color"
              type="color"
              defaultValue="#6366f1"
              className="h-10 w-14 cursor-pointer rounded-lg border border-slate-200 bg-white p-1"
            />
          </div>
          <button
            className="rounded-lg bg-emerald-500 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-600"
            type="submit"
          >
            追加
          </button>
        </form>
      </details>

      {/* Category Cards */}
      <div className="space-y-3">
        {categories.length === 0 ? (
          <EmptyState message="カテゴリがまだありません。" />
        ) : (
          categories.map((category) => {
            const categoryMappings = categoryMappingsMap.get(category.id) ?? []
            const linkedCryptIds = new Set(categoryMappings.map((m) => m.crypt_id))
            const linkedCrypts = categoryMappings
              .map((m) => ({ mappingId: m.id, crypt: cryptMap.get(m.crypt_id) }))
              .filter((item): item is { mappingId: string; crypt: Crypt } => Boolean(item.crypt))
            const availableCrypts = crypts.filter((c) => !allLinkedCryptIds.has(c.id))
            const categoryColor = getCategoryColor(category.color)

            return (
              <details
                key={category.id}
                className="group overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm"
              >
                <summary className="flex cursor-pointer list-none items-center gap-4 p-5 hover:bg-slate-50">
                  {/* Color swatch */}
                  <div
                    className="h-3 w-3 flex-shrink-0 rounded-full"
                    style={{ backgroundColor: categoryColor }}
                  />
                  {/* Name + badge */}
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2">
                      <span className="text-base font-semibold text-slate-900">{category.name}</span>
                      <span className="inline-flex items-center rounded-full bg-emerald-100 px-2 py-0.5 text-xs font-medium text-emerald-700">
                        {categoryMappings.length}通貨
                      </span>
                    </div>
                  </div>
                  {/* Chevron */}
                  <svg
                    className="h-5 w-5 flex-shrink-0 text-slate-400 transition-transform group-open:rotate-180"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path strokeLinecap="round" strokeLinejoin="round" strokeWidth={2} d="M19 9l-7 7-7-7" />
                  </svg>
                </summary>

                <div className="border-t bg-slate-50">
                  {/* Edit / Delete Form */}
                  <form
                    action={updateCategoryAction}
                    className="flex flex-wrap items-end gap-3 p-5"
                  >
                    <input type="hidden" name="locale" value={locale} />
                    <input type="hidden" name="id" value={category.id} />
                    <div className="flex-1 min-w-[180px]">
                      <label className="mb-1 block text-xs font-medium text-slate-600">カテゴリ名</label>
                      <input
                        name="name"
                        defaultValue={category.name}
                        className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
                        required
                      />
                    </div>
                    <div>
                      <label className="mb-1 block text-xs font-medium text-slate-600">カラー</label>
                      <div className="flex items-center gap-2 rounded-lg border border-slate-200 bg-white px-2 py-1">
                        <input
                          name="color"
                          type="color"
                          defaultValue={categoryColor}
                          className="h-8 w-12 cursor-pointer rounded border-0 bg-transparent p-0"
                        />
                        <span className="text-xs text-slate-500">{categoryColor}</span>
                      </div>
                    </div>
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
                        formAction={deleteCategoryAction}
                      >
                        削除
                      </button>
                    </div>
                  </form>

                  {/* Linked Crypts Section */}
                  <div className="border-t p-5">
                    <div className="mb-3">
                      <h3 className="text-sm font-semibold text-slate-800">紐づけ通貨</h3>
                      <p className="text-xs text-slate-500">カテゴリに含める通貨を管理します。</p>
                    </div>

                    {linkedCrypts.length === 0 ? (
                      <p className="mb-4 text-sm italic text-slate-400">通貨が紐づけられていません</p>
                    ) : (
                      <div className="mb-4 flex flex-wrap gap-2">
                        {linkedCrypts.map(({ mappingId, crypt }) => (
                          <div
                            key={mappingId}
                            className="inline-flex items-center gap-1 rounded-full bg-slate-100 px-3 py-1 text-sm font-medium text-slate-700"
                          >
                            <span>{crypt.symbol}</span>
                            <form action={deleteUserCryptCategoryAction} className="contents">
                              <input type="hidden" name="locale" value={locale} />
                              <input type="hidden" name="id" value={mappingId} />
                              <button
                                type="submit"
                                className="ml-0.5 text-slate-400 transition-colors hover:text-red-500"
                                aria-label={`${crypt.symbol} の紐づけを削除`}
                              >
                                ×
                              </button>
                            </form>
                          </div>
                        ))}
                      </div>
                    )}

                    {/* Add Crypt Form */}
                    <form action={createUserCryptCategoryAction} className="flex gap-2">
                      <input type="hidden" name="locale" value={locale} />
                      <input type="hidden" name="category_id" value={category.id} />
                      <select
                        name="crypt_id"
                        className="flex-1 rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
                        required
                        disabled={availableCrypts.length === 0}
                      >
                        <option value="">
                          {availableCrypts.length === 0 ? 'すべて紐づけ済み' : '通貨を選択'}
                        </option>
                        {availableCrypts.map((crypt) => (
                          <option key={crypt.id} value={crypt.id}>
                            {getCryptLabel(crypt)}
                          </option>
                        ))}
                      </select>
                      <button
                        className="rounded-lg bg-emerald-500 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-600 disabled:cursor-not-allowed disabled:bg-emerald-300"
                        type="submit"
                        disabled={availableCrypts.length === 0}
                      >
                        追加
                      </button>
                    </form>
                  </div>
                </div>
              </details>
            )
          })
        )}
      </div>
    </section>
  )
}
