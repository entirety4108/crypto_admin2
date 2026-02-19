import createMiddleware from 'next-intl/middleware'
import { type NextRequest, NextResponse } from 'next/server'
import { createServerClient } from '@supabase/ssr'
import { routing } from './i18n/routing'

const intlMiddleware = createMiddleware(routing)

const AUTH_ROUTES = ['/login', '/register', '/reset-password']

export default async function proxy(request: NextRequest) {
  const response = intlMiddleware(request)

  const url = process.env.NEXT_PUBLIC_SUPABASE_URL
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY

  if (!url || !anonKey) {
    return response
  }

  const supabase = createServerClient(url, anonKey, {
    cookies: {
      getAll() {
        return request.cookies.getAll()
      },
      setAll(
        cookiesToSet: Array<{ name: string; value: string; options?: Record<string, unknown> }>,
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

  const {
    data: { user },
  } = await supabase.auth.getUser()

  const { pathname } = request.nextUrl
  const localeInPath = pathname.split('/')[1]
  const locale = routing.locales.includes(localeInPath as 'ja' | 'en')
    ? localeInPath
    : routing.defaultLocale
  const suffix = pathname.replace(`/${locale}`, '') || '/'
  const isAuthRoute = AUTH_ROUTES.includes(suffix)

  if (!user && !isAuthRoute) {
    const redirectUrl = request.nextUrl.clone()
    redirectUrl.pathname = `/${locale}/login`
    return NextResponse.redirect(redirectUrl)
  }

  if (user && isAuthRoute) {
    const redirectUrl = request.nextUrl.clone()
    redirectUrl.pathname = `/${locale}/portfolio`
    return NextResponse.redirect(redirectUrl)
  }

  return response
}

export const config = {
  matcher: ['/((?!api|_next|_vercel|.*\\..*).*)'],
}
