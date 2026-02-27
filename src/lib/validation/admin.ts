import { z } from 'zod'

export const accountSchema = z.object({
  name: z.string().trim().min(1, 'アカウント名は必須です').max(255),
  memo: z.string().trim().max(1000).optional(),
  iconUrl: z
    .string()
    .trim()
    .url('有効なURLを入力してください')
    .optional()
    .or(z.literal('')),
  isLocked: z.boolean().default(false),
})

export const categorySchema = z.object({
  name: z.string().trim().min(1, 'カテゴリ名は必須です').max(100),
  color: z
    .string()
    .trim()
    .regex(/^#[0-9A-Fa-f]{6}$/, 'カラーコードは #RRGGBB 形式で入力してください')
    .optional()
    .or(z.literal('')),
})

export const userCryptCategorySchema = z.object({
  cryptId: z.string().uuid('通貨を選択してください'),
  categoryId: z.string().uuid('カテゴリを選択してください'),
})

export const cryptSchema = z.object({
  symbol: z.string().trim().min(1, 'シンボルは必須です').max(20),
  projectName: z.string().trim().max(255).optional().or(z.literal('')),
  coingeckoId: z.string().trim().max(100).optional().or(z.literal('')),
  iconUrl: z
    .string()
    .trim()
    .url('有効なURLを入力してください')
    .optional()
    .or(z.literal('')),
  color: z
    .string()
    .trim()
    .regex(/^#[0-9A-Fa-f]{6}$/, 'カラーコードは #RRGGBB 形式で入力してください')
    .optional()
    .or(z.literal('')),
  isActive: z.boolean().default(true),
})
