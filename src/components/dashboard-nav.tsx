import Link from 'next/link'

export function DashboardNav({ locale }: { locale: string }) {
  const links = [
    { href: `/${locale}/portfolio`, label: 'Portfolio' },
    { href: `/${locale}/accounts`, label: 'Accounts' },
    { href: `/${locale}/categories`, label: 'Categories' },
    { href: `/${locale}/transactions`, label: 'Transactions' },
  ]

  return (
    <nav className="space-y-1 p-4">
      {links.map((link) => (
        <Link
          key={link.href}
          href={link.href}
          className="block rounded-md px-3 py-2 text-sm text-slate-700 hover:bg-slate-100"
        >
          {link.label}
        </Link>
      ))}
    </nav>
  )
}
