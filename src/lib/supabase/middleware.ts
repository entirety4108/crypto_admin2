import { createServerClient } from '@supabase/ssr'
import { type NextRequest, NextResponse } from 'next/server'

export async function updateSession(request: NextRequest) {
  const response = NextResponse.next({ request })

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  if (!url || !anonKey) {
    throw new Error(
      'Missing Supabase environment variables for middleware client'
    )
  }

  const supabase = createServerClient(url, anonKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll()
      },
      setAll(
        cookiesToSet: Array<{
          name: string
          value: string
          options?: Record<string, unknown>
        }>
      ) {
        for (const { name, value, options } of cookiesToSet) {
          request.cookies.set(name, value)
          if (options) {
            response.cookies.set(name, value, options as never)
          } else {
            response.cookies.set(name, value)
          }
        }
      },
    },
  })

  await supabase.auth.getUser()
  return response
}
