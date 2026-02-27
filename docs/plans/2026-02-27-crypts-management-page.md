# Crypts Management Page Implementation Plan

> **For Claude:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Add a `/crypts` dashboard page for managing the `crypts` master table (list + add + edit + is_active toggle).

**Architecture:** Server Component page fetches all crypts via Supabase read client. Server Actions use a service_role client (bypassing RLS write restriction) to INSERT/UPDATE crypts. Same collapsible card UI pattern as accounts/categories pages.

**Tech Stack:** Next.js 15 App Router, TypeScript, Tailwind CSS, Supabase (service_role for writes), Zod validation, Vitest

---

## Task 1: Add `cryptSchema` Zod validation

**Files:**
- Modify: `src/lib/validation/admin.ts`

**Step 1: Write the failing test**

Create `src/lib/validation/admin.test.ts`:

```typescript
import { describe, it, expect } from 'vitest'
import { cryptSchema } from './admin'

describe('cryptSchema', () => {
  it('valid input with all fields passes', () => {
    const result = cryptSchema.safeParse({
      symbol: 'BTC',
      projectName: 'Bitcoin',
      coingeckoId: 'bitcoin',
      iconUrl: 'https://example.com/btc.png',
      color: '#F7931A',
      isActive: true,
    })
    expect(result.success).toBe(true)
  })

  it('valid input with only required fields passes', () => {
    const result = cryptSchema.safeParse({ symbol: 'ETH' })
    expect(result.success).toBe(true)
  })

  it('empty symbol fails', () => {
    const result = cryptSchema.safeParse({ symbol: '' })
    expect(result.success).toBe(false)
    expect(result.error?.issues[0]?.message).toContain('シンボルは必須')
  })

  it('symbol longer than 20 chars fails', () => {
    const result = cryptSchema.safeParse({ symbol: 'A'.repeat(21) })
    expect(result.success).toBe(false)
  })

  it('invalid color format fails', () => {
    const result = cryptSchema.safeParse({ symbol: 'BTC', color: 'red' })
    expect(result.success).toBe(false)
  })

  it('invalid URL fails', () => {
    const result = cryptSchema.safeParse({ symbol: 'BTC', iconUrl: 'not-a-url' })
    expect(result.success).toBe(false)
  })

  it('empty iconUrl is allowed (treated as no icon)', () => {
    const result = cryptSchema.safeParse({ symbol: 'BTC', iconUrl: '' })
    expect(result.success).toBe(true)
  })
})
```

**Step 2: Run test to verify it fails**

```bash
cd S:/crypto_admin2
pnpm test src/lib/validation/admin.test.ts
```

Expected: FAIL with "cryptSchema is not exported from './admin'"

**Step 3: Add `cryptSchema` to validation file**

In `src/lib/validation/admin.ts`, append at the bottom:

```typescript
export const cryptSchema = z.object({
  symbol: z.string().trim().min(1, 'シンボルは必須です').max(20),
  projectName: z.string().trim().max(255).optional().or(z.literal('')),
  coingeckoId: z.string().trim().max(100).optional().or(z.literal('')),
  iconUrl: z.string().trim().url('有効なURLを入力してください').optional().or(z.literal('')),
  color: z
    .string()
    .trim()
    .regex(/^#[0-9A-Fa-f]{6}$/, 'カラーコードは #RRGGBB 形式で入力してください')
    .optional()
    .or(z.literal('')),
  isActive: z.boolean().default(true),
})
```

**Step 4: Run test to verify it passes**

```bash
pnpm test src/lib/validation/admin.test.ts
```

Expected: All 7 tests PASS

**Step 5: Commit**

```bash
git add src/lib/validation/admin.ts src/lib/validation/admin.test.ts
git commit -m "feat: add cryptSchema Zod validation for crypts master"
```

---

## Task 2: Create Server Actions for crypts

**Files:**
- Create: `src/app/[locale]/(dashboard)/crypts/actions.ts`

**Context:** The `crypts` table uses RLS: read is allowed for all, but **writes require service_role**. We must NOT use the standard `createClient()` from `@/lib/supabase/server` for writes. Instead, create a raw Supabase client with `SUPABASE_SERVICE_ROLE_KEY`.

**Step 1: Create actions.ts**

```typescript
'use server'

import { createClient as createSupabaseClient } from '@supabase/supabase-js'
import { revalidatePath } from 'next/cache'
import { createClient } from '@/lib/supabase/server'
import { cryptSchema } from '@/lib/validation/admin'

/** Returns service_role client for writing to RLS-protected master tables */
function createServiceRoleClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const serviceKey = process.env.SUPABASE_SERVICE_ROLE_KEY

  if (!url || !serviceKey) {
    throw new Error('Supabase service role configuration is missing')
  }

  return createSupabaseClient(url, serviceKey)
}

/** Verifies the caller is authenticated (reads from user client) */
async function requireAuth() {
  const supabase = await createClient()
  const {
    data: { user },
  } = await supabase.auth.getUser()

  if (!user) {
    throw new Error('ログインが必要です')
  }

  return user
}

export async function createCryptAction(formData: FormData) {
  const locale = String(formData.get('locale') ?? 'ja')

  await requireAuth()

  const parsed = cryptSchema.safeParse({
    symbol: formData.get('symbol'),
    projectName: formData.get('project_name') || '',
    coingeckoId: formData.get('coingecko_id') || '',
    iconUrl: formData.get('icon_url') || '',
    color: formData.get('color') || '',
    isActive: true,
  })

  if (!parsed.success) {
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')
  }

  const supabase = createServiceRoleClient()
  const { error } = await supabase.from('crypts').insert({
    symbol: parsed.data.symbol.toUpperCase(),
    project_name: parsed.data.projectName || null,
    coingecko_id: parsed.data.coingeckoId || null,
    icon_url: parsed.data.iconUrl || null,
    color: parsed.data.color || null,
    is_active: true,
  })

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/crypts`)
}

export async function updateCryptAction(formData: FormData) {
  const id = String(formData.get('id') ?? '')
  const locale = String(formData.get('locale') ?? 'ja')

  if (!id) throw new Error('更新対象IDが不正です')

  await requireAuth()

  const parsed = cryptSchema.safeParse({
    symbol: formData.get('symbol'),
    projectName: formData.get('project_name') || '',
    coingeckoId: formData.get('coingecko_id') || '',
    iconUrl: formData.get('icon_url') || '',
    color: formData.get('color') || '',
    isActive: formData.get('is_active') === 'on',
  })

  if (!parsed.success) {
    throw new Error(parsed.error.issues[0]?.message ?? '入力値が不正です')
  }

  const supabase = createServiceRoleClient()
  const { error } = await supabase
    .from('crypts')
    .update({
      symbol: parsed.data.symbol.toUpperCase(),
      project_name: parsed.data.projectName || null,
      coingecko_id: parsed.data.coingeckoId || null,
      icon_url: parsed.data.iconUrl || null,
      color: parsed.data.color || null,
      is_active: parsed.data.isActive,
    })
    .eq('id', id)

  if (error) throw new Error(error.message)

  revalidatePath(`/${locale}/crypts`)
}
```

**Step 2: Type-check**

```bash
pnpm typecheck
```

Expected: No errors. If there are import errors for `@supabase/supabase-js`, check `package.json` — it should already be there as a dependency (it's used by the supabase client library).

**Step 3: Commit**

```bash
git add src/app/[locale]/\(dashboard\)/crypts/actions.ts
git commit -m "feat: add Server Actions for crypts master management"
```

---

## Task 3: Create the Crypts page

**Files:**
- Create: `src/app/[locale]/(dashboard)/crypts/page.tsx`

**Step 1: Create page.tsx**

```typescript
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
    return <AlertMessage variant="error" message="ログインが必要です。" />
  }

  const { data: crypts, error } = await supabase
    .from('crypts')
    .select('id,symbol,project_name,icon_url,color,coingecko_id,is_active')
    .order('symbol')

  if (error) {
    return <AlertMessage variant="error" message={error.message} />
  }

  const cryptList = (crypts as Crypt[] | null) ?? []

  return (
    <section className="space-y-6">
      <div className="border-b border-slate-200 pb-4">
        <h2 className="text-2xl font-bold text-slate-900">Crypts</h2>
        <p className="mt-1 text-sm text-slate-500">暗号通貨マスターの登録・編集・有効無効の切り替えができます。</p>
      </div>

      {/* Add Crypt Form */}
      <details className="group rounded-xl border border-slate-200 bg-white shadow-sm">
        <summary className="flex cursor-pointer list-none items-center justify-between p-5 font-semibold text-slate-700 hover:bg-slate-50">
          <span>+ 新規通貨を追加</span>
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
          action={createCryptAction}
          className="grid gap-3 border-t bg-slate-50 p-5 md:grid-cols-2"
        >
          <input type="hidden" name="locale" value={locale} />
          <div>
            <label className="mb-1 block text-xs font-medium text-slate-600">シンボル <span className="text-red-500">*</span></label>
            <input
              name="symbol"
              placeholder="例: BTC, ETH"
              className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
              required
            />
          </div>
          <div>
            <label className="mb-1 block text-xs font-medium text-slate-600">プロジェクト名</label>
            <input
              name="project_name"
              placeholder="例: Bitcoin, Ethereum"
              className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
            />
          </div>
          <div>
            <label className="mb-1 block text-xs font-medium text-slate-600">CoinGecko ID</label>
            <input
              name="coingecko_id"
              placeholder="例: bitcoin, ethereum"
              className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
            />
          </div>
          <div>
            <label className="mb-1 block text-xs font-medium text-slate-600">アイコン URL</label>
            <input
              name="icon_url"
              placeholder="https://example.com/icon.png"
              className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
            />
          </div>
          <div className="flex items-end gap-3">
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
              className="flex-1 rounded-lg bg-emerald-500 px-4 py-2 text-sm font-medium text-white hover:bg-emerald-600"
              type="submit"
            >
              追加
            </button>
          </div>
        </form>
      </details>

      {/* Crypt Cards */}
      <div className="space-y-3">
        {cryptList.length === 0 ? (
          <EmptyState message="通貨がまだ登録されていません。" />
        ) : (
          cryptList.map((crypt) => {
            const cryptColor = getCryptColor(crypt.color)
            return (
              <details
                key={crypt.id}
                className="group overflow-hidden rounded-xl border border-slate-200 bg-white shadow-sm"
              >
                <summary className="flex cursor-pointer list-none items-center gap-4 p-5 hover:bg-slate-50">
                  {/* Color swatch */}
                  <div
                    className="h-3 w-3 flex-shrink-0 rounded-full"
                    style={{ backgroundColor: cryptColor }}
                  />
                  {/* Symbol + name + badge */}
                  <div className="min-w-0 flex-1">
                    <div className="flex items-center gap-2">
                      <span className={`text-base font-semibold ${crypt.is_active ? 'text-slate-900' : 'text-slate-400'}`}>
                        {crypt.symbol}
                      </span>
                      {crypt.project_name && (
                        <span className="text-sm text-slate-500">{crypt.project_name}</span>
                      )}
                      {!crypt.is_active && (
                        <span className="inline-flex items-center rounded-full bg-slate-100 px-2 py-0.5 text-xs font-medium text-slate-500">
                          無効
                        </span>
                      )}
                    </div>
                    {crypt.coingecko_id && (
                      <p className="mt-0.5 text-xs text-slate-400">CoinGecko: {crypt.coingecko_id}</p>
                    )}
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

                <form
                  action={updateCryptAction}
                  className="grid gap-3 border-t bg-slate-50 p-5 md:grid-cols-2"
                >
                  <input type="hidden" name="locale" value={locale} />
                  <input type="hidden" name="id" value={crypt.id} />
                  <div>
                    <label className="mb-1 block text-xs font-medium text-slate-600">シンボル <span className="text-red-500">*</span></label>
                    <input
                      name="symbol"
                      defaultValue={crypt.symbol}
                      className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
                      required
                    />
                  </div>
                  <div>
                    <label className="mb-1 block text-xs font-medium text-slate-600">プロジェクト名</label>
                    <input
                      name="project_name"
                      defaultValue={crypt.project_name ?? ''}
                      className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
                    />
                  </div>
                  <div>
                    <label className="mb-1 block text-xs font-medium text-slate-600">CoinGecko ID</label>
                    <input
                      name="coingecko_id"
                      defaultValue={crypt.coingecko_id ?? ''}
                      className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
                    />
                  </div>
                  <div>
                    <label className="mb-1 block text-xs font-medium text-slate-600">アイコン URL</label>
                    <input
                      name="icon_url"
                      defaultValue={crypt.icon_url ?? ''}
                      className="w-full rounded-lg border border-slate-200 bg-white px-3 py-2 text-sm focus:border-emerald-500 focus:outline-none focus:ring-1 focus:ring-emerald-500"
                    />
                  </div>
                  <div className="flex items-end gap-3">
                    <div>
                      <label className="mb-1 block text-xs font-medium text-slate-600">カラー</label>
                      <input
                        name="color"
                        type="color"
                        defaultValue={cryptColor}
                        className="h-10 w-14 cursor-pointer rounded-lg border border-slate-200 bg-white p-1"
                      />
                    </div>
                    <label className="flex items-center gap-2 text-sm text-slate-600">
                      <input
                        type="checkbox"
                        name="is_active"
                        defaultChecked={crypt.is_active}
                        className="rounded"
                      />
                      有効
                    </label>
                  </div>
                  <div className="flex items-end">
                    <button
                      className="w-full rounded-lg bg-slate-700 px-4 py-2 text-sm font-medium text-white hover:bg-slate-800"
                      type="submit"
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
```

**Step 2: Type-check**

```bash
pnpm typecheck
```

Expected: No errors.

**Step 3: Commit**

```bash
git add "src/app/[locale]/(dashboard)/crypts/page.tsx"
git commit -m "feat: add Crypts management page (list + add + edit + is_active toggle)"
```

---

## Task 4: Add Crypts to navigation

**Files:**
- Modify: `src/components/dashboard-nav.tsx`

**Step 1: Add CoinsIcon and Crypts link**

In `src/components/dashboard-nav.tsx`, add a coin icon function after the existing icon functions (before `export function DashboardNav`):

```typescript
function CoinsIcon() {
  return (
    <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
      <circle cx="8" cy="8" r="6" />
      <path d="M18.09 10.37A6 6 0 1 1 10.34 18" />
      <path d="M7 6h1v4" />
      <path d="m16.71 13.88.7.71-2.82 2.82" />
    </svg>
  )
}
```

Then in the `links` array inside `DashboardNav`, add after the Categories entry:

```typescript
{ href: `/${locale}/crypts`, label: 'Crypts', Icon: CoinsIcon },
```

Full updated `links` array:

```typescript
const links = [
  { href: `/${locale}/portfolio`, label: 'Portfolio', Icon: BarChart2Icon },
  { href: `/${locale}/transactions`, label: 'Transactions', Icon: ArrowLeftRightIcon },
  { href: `/${locale}/accounts`, label: 'Accounts', Icon: Building2Icon },
  { href: `/${locale}/categories`, label: 'Categories', Icon: TagIcon },
  { href: `/${locale}/crypts`, label: 'Crypts', Icon: CoinsIcon },
]
```

**Step 2: Type-check**

```bash
pnpm typecheck
```

Expected: No errors.

**Step 3: Commit**

```bash
git add src/components/dashboard-nav.tsx
git commit -m "feat: add Crypts link to dashboard navigation"
```

---

## Task 5: Run all tests and verify

**Step 1: Run all tests**

```bash
pnpm test
```

Expected: All tests pass including the new `admin.test.ts` tests.

**Step 2: Run type check**

```bash
pnpm typecheck
```

Expected: No errors.

**Step 3: Run lint**

```bash
pnpm lint
```

Expected: No lint errors.

**Step 4: Manual smoke test**

Start the dev server:

```bash
pnpm dev
```

Verify:
- Navigate to `http://localhost:3000/ja/crypts`
- The "Crypts" link appears in the sidebar
- The page shows existing crypts from the database
- "新規通貨を追加" expands a form
- Adding a new crypt (e.g., symbol: "TEST", project_name: "Test Coin") works
- The new entry appears in the list
- Editing an existing crypt (click to expand → change a field → 更新) works
- Toggling `is_active` checkbox → 更新 → inactive crypts show grayed-out "無効" badge

**Step 5: Final commit (if any fixes needed)**

```bash
git add -p
git commit -m "fix: address any issues found during smoke testing"
```
