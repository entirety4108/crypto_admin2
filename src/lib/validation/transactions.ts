import { z } from 'zod'

const uuid = z.string().uuid('選択値が不正です')
const dateTime = z.string().min(1, '日時は必須です')
const positiveNumber = z.coerce.number().positive('0より大きい値を入力してください')
const nonNegativeNumber = z.coerce.number().min(0, '0以上の値を入力してください')

export const commissionSchema = z.object({
  execAt: dateTime,
  accountId: uuid,
  cryptId: uuid,
  unitYen: nonNegativeNumber,
  amount: positiveNumber,
  approximateYen: nonNegativeNumber,
})

export const purchaseSchema = z.object({
  execAt: dateTime,
  accountId: uuid,
  cryptId: uuid,
  unitYen: nonNegativeNumber,
  amount: positiveNumber,
  depositYen: nonNegativeNumber,
  purchaseYen: nonNegativeNumber,
  type: z.enum(['d', 'a']),
  commissionId: uuid.optional().or(z.literal('')),
  airdropType: z.coerce.number().int().min(1).max(2).optional(),
  airdropProfit: nonNegativeNumber.optional(),
}).superRefine((value, ctx) => {
  if (value.type === 'a') {
    if (!value.airdropType) {
      ctx.addIssue({ code: z.ZodIssueCode.custom, message: 'エアドロップ種別を選択してください', path: ['airdropType'] })
    }
    if (value.airdropProfit === undefined) {
      ctx.addIssue({ code: z.ZodIssueCode.custom, message: 'エアドロップ損益を入力してください', path: ['airdropProfit'] })
    }
  }
})

export const sellSchema = z.object({
  execAt: dateTime,
  accountId: uuid,
  cryptId: uuid,
  unitYen: nonNegativeNumber,
  amount: positiveNumber,
  yen: nonNegativeNumber,
  type: z.enum(['s']),
  commissionId: uuid.optional().or(z.literal('')),
})

export const transferSchema = z.object({
  execAt: dateTime,
  fromAccountId: uuid,
  toAccountId: uuid,
  cryptId: uuid,
  amount: positiveNumber,
  commissionId: uuid.optional().or(z.literal('')),
  memo: z.string().trim().max(1000).optional(),
}).refine((v) => v.fromAccountId !== v.toAccountId, {
  message: '振替元と振替先は別アカウントを選択してください',
  path: ['toAccountId'],
})

export const swapSchema = z.object({
  execAt: dateTime,
  sellAccountId: uuid,
  sellCryptId: uuid,
  sellUnitYen: nonNegativeNumber,
  sellAmount: positiveNumber,
  sellYen: nonNegativeNumber,
  buyAccountId: uuid,
  buyCryptId: uuid,
  buyUnitYen: nonNegativeNumber,
  buyAmount: positiveNumber,
  buyDepositYen: nonNegativeNumber,
  buyPurchaseYen: nonNegativeNumber,
  commissionId: uuid.optional().or(z.literal('')),
})

export const transactionFilterSchema = z.object({
  type: z.enum(['all', 'deposit', 'sell', 'swap', 'transfer', 'airdrop']).default('all'),
  from: z.string().optional().or(z.literal('')),
  to: z.string().optional().or(z.literal('')),
})
