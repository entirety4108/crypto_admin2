import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { AuthForm } from './auth-form'

const pushMock = vi.fn()
const refreshMock = vi.fn()
const signInWithPasswordMock = vi.fn()
const signUpMock = vi.fn()
const resetPasswordForEmailMock = vi.fn()

vi.mock('next/navigation', () => ({
  useRouter: () => ({ push: pushMock, refresh: refreshMock }),
}))

vi.mock('@/lib/supabase/client', () => ({
  createClient: () => ({
    auth: {
      signInWithPassword: signInWithPasswordMock,
      signUp: signUpMock,
      resetPasswordForEmail: resetPasswordForEmailMock,
    },
  }),
}))

describe('AuthForm', () => {
  beforeEach(() => {
    vi.clearAllMocks()
  })

  it('ログイン成功時にportfolioへ遷移する', async () => {
    signInWithPasswordMock.mockResolvedValue({ error: null })

    render(<AuthForm mode="login" locale="ja" />)

    fireEvent.change(screen.getByLabelText('email'), { target: { value: 'demo@example.com' } })
    fireEvent.change(screen.getByLabelText('password'), { target: { value: 'password123' } })
    fireEvent.click(screen.getByRole('button', { name: 'ログイン' }))

    await waitFor(() => {
      expect(signInWithPasswordMock).toHaveBeenCalledWith({
        email: 'demo@example.com',
        password: 'password123',
      })
      expect(pushMock).toHaveBeenCalledWith('/ja/portfolio')
    })
  })

  it('reset失敗時にエラーメッセージを表示する', async () => {
    resetPasswordForEmailMock.mockResolvedValue({ error: new Error('failed') })

    render(<AuthForm mode="reset" locale="ja" />)

    fireEvent.change(screen.getByLabelText('email'), { target: { value: 'demo@example.com' } })
    fireEvent.click(screen.getByRole('button', { name: 'リセットメール送信' }))

    expect(await screen.findByRole('alert')).toHaveTextContent('failed')
  })
})
