import {
  createCategoryAction,
  createUserCryptCategoryAction,
  deleteCategoryAction,
  deleteUserCryptCategoryAction,
  updateCategoryAction,
} from './actions'
import { createClient } from '@/lib/supabase/server'

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

export default async function CategoriesPage({ params }: { params: Promise<{ locale: string }> }) {
  const { locale } = await params
  const supabase = await createClient()

  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    return <p className="text-sm text-red-600">ログインが必要です。</p>
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
    return <p className="text-sm text-red-600">{message}</p>
  }

  const categories = categoriesRes.data
  const crypts = cryptsRes.data
  const mappings = mappingsRes.data

  const categoryMap = new Map((categories as Category[] | null)?.map((v) => [v.id, v.name]) ?? [])
  const cryptMap = new Map((crypts as Crypt[] | null)?.map((v) => [v.id, v.symbol]) ?? [])

  return (
    <section className="space-y-8">
      <div>
        <h2 className="text-xl font-semibold">Categories</h2>
        <p className="text-sm text-slate-600">カテゴリ管理と通貨の紐付けを行います。</p>
      </div>

      <form action={createCategoryAction} className="grid gap-3 rounded-lg border p-4 md:grid-cols-3">
        <input type="hidden" name="locale" value={locale} />
        <input name="name" placeholder="カテゴリ名" className="rounded border px-3 py-2" required />
        <input name="color" placeholder="#RRGGBB" className="rounded border px-3 py-2" />
        <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">
          追加
        </button>
      </form>

      <div className="space-y-3">
        {(categories as Category[] | null)?.map((category) => (
          <form key={category.id} action={updateCategoryAction} className="grid gap-2 rounded-lg border p-4 md:grid-cols-3">
            <input type="hidden" name="locale" value={locale} />
            <input type="hidden" name="id" value={category.id} />
            <input name="name" defaultValue={category.name} className="rounded border px-3 py-2" required />
            <input
              name="color"
              defaultValue={category.color ?? ''}
              className="rounded border px-3 py-2"
              placeholder="#RRGGBB"
            />
            <div className="flex gap-2">
              <button className="rounded border px-3 py-2 text-sm" type="submit">
                更新
              </button>
              <button
                className="rounded border border-red-300 px-3 py-2 text-sm text-red-700"
                type="submit"
                formAction={deleteCategoryAction}
              >
                削除
              </button>
            </div>
          </form>
        ))}
      </div>

      <div className="space-y-4 rounded-lg border p-4">
        <h3 className="font-medium">通貨カテゴリ紐付け</h3>
        <form action={createUserCryptCategoryAction} className="grid gap-3 md:grid-cols-3">
          <input type="hidden" name="locale" value={locale} />
          <select name="crypt_id" className="rounded border px-3 py-2" required>
            <option value="">通貨を選択</option>
            {(crypts as Crypt[] | null)?.map((crypt) => (
              <option key={crypt.id} value={crypt.id}>
                {crypt.symbol} {crypt.project_name ? `(${crypt.project_name})` : ''}
              </option>
            ))}
          </select>
          <select name="category_id" className="rounded border px-3 py-2" required>
            <option value="">カテゴリを選択</option>
            {(categories as Category[] | null)?.map((category) => (
              <option key={category.id} value={category.id}>
                {category.name}
              </option>
            ))}
          </select>
          <button className="rounded bg-slate-900 px-3 py-2 text-sm text-white" type="submit">
            紐付け追加
          </button>
        </form>

        <ul className="space-y-2">
          {(mappings as Mapping[] | null)?.map((mapping) => (
            <li key={mapping.id} className="flex items-center justify-between rounded border px-3 py-2 text-sm">
              <span>
                {cryptMap.get(mapping.crypt_id) ?? 'Unknown'} → {categoryMap.get(mapping.category_id) ?? 'Unknown'}
              </span>
              <form action={deleteUserCryptCategoryAction}>
                <input type="hidden" name="locale" value={locale} />
                <input type="hidden" name="id" value={mapping.id} />
                <button className="text-red-700" type="submit">
                  削除
                </button>
              </form>
            </li>
          ))}
        </ul>
      </div>
    </section>
  )
}
