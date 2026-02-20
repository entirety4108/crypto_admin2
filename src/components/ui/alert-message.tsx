type AlertVariant = 'error' | 'success' | 'info'

const variantClass: Record<AlertVariant, string> = {
  error: 'border-red-200 bg-red-50 text-red-700',
  success: 'border-emerald-200 bg-emerald-50 text-emerald-700',
  info: 'border-slate-200 bg-slate-50 text-slate-700',
}

export function AlertMessage({
  variant = 'info',
  message,
}: {
  variant?: AlertVariant
  message: string
}) {
  return (
    <p role="alert" aria-live="polite" className={`rounded border px-3 py-2 text-sm ${variantClass[variant]}`}>
      {message}
    </p>
  )
}
