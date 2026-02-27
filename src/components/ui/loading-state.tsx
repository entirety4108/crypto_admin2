export function LoadingState({
  message = '読み込み中...',
}: {
  message?: string
}) {
  return (
    <div
      role="status"
      aria-live="polite"
      className="rounded border px-3 py-4 text-sm text-slate-600"
    >
      {message}
    </div>
  )
}
