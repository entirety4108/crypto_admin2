import { create } from 'zustand'

type AppState = {
  sidebarOpen: boolean
  locale: 'ja' | 'en'
  setSidebarOpen: (open: boolean) => void
  setLocale: (locale: 'ja' | 'en') => void
}

export const useAppStore = create<AppState>((set) => ({
  sidebarOpen: true,
  locale: 'ja',
  setSidebarOpen: (open) => set({ sidebarOpen: open }),
  setLocale: (locale) => set({ locale }),
}))
