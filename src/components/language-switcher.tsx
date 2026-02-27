'use client'

import { usePathname } from 'next/navigation'
import Link from 'next/link'
import { routing } from '@/i18n/routing'
import { useAppStore } from '@/stores/app-store'

export function LanguageSwitcher({ locale }: { locale: string }) {
  const pathname = usePathname()
  const setLocale = useAppStore((state) => state.setLocale)

  const toLocalePath = (nextLocale: string) => {
    const segments = pathname.split('/').filter(Boolean)

    if (segments.length === 0) {
      return `/${nextLocale}`
    }

    if (routing.locales.includes(segments[0] as 'ja' | 'en')) {
      segments[0] = nextLocale
      return `/${segments.join('/')}`
    }

    return `/${nextLocale}${pathname}`
  }

  return (
    <div className="flex gap-2 text-sm">
      {routing.locales.map((target) => (
        <Link
          key={target}
          href={toLocalePath(target)}
          onClick={() => setLocale(target)}
          className={
            target === locale
              ? 'font-semibold underline'
              : 'text-slate-600 hover:text-slate-900'
          }
        >
          {target.toUpperCase()}
        </Link>
      ))}
    </div>
  )
}
