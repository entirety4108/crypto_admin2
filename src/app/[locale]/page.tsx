import { useTranslations } from 'next-intl'

export default function Home() {
  const t = useTranslations('app')

  return (
    <main className="flex min-h-screen items-center justify-center">
      <h1 className="text-2xl font-bold">{t('title')}</h1>
    </main>
  )
}
